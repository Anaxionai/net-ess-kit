# Set up your AWS account (P3)

P3 CloudNet builds a real network on AWS, in Mumbai (`ap-south-1`), with OpenTofu. This guide sets up the account safely **before** anything is built: the Free plan, MFA, an IAM user for daily work, a CLI sign-in with no stored keys, and a budget alarm. It ends with the teardown rule.

Do Parts 1 to 5 in P3 task 7, in order. Part 6 is the rule for every day after that. Run `aws` and `tofu` in **Git Bash**.

**Facts checked on 24 November 2026** on aws.amazon.com and the AWS documentation. Versions are in [`VERSIONS.md`](../VERSIONS.md).

## Part 1: the AWS Free plan account

What the Free plan gives (aws.amazon.com/free and the Free Tier documentation, read on 24 November 2026):

- **$100 in credits** at sign-up, and up to **$100 more** for doing set-up activities. Creating a budget (Part 5) is one of them and earns $20.
- The plan ends **6 months** after you open the account, or when the credits run out, whichever comes first. You are not charged on the Free plan; when it ends, AWS closes the account and keeps your data for 90 days unless you upgrade to the Paid plan.
- It covers a selection of services, including EC2 `t3.micro`, which CloudNet uses. Credits pay for the load balancer, public addresses and endpoints too, so they run down while your network exists.
- **A payment card.** Most new customers need none, but AWS may ask for one to check who you are. If it asks and you have no card that allows international payments, tell your mentor early: the centre provides one.
- Do not join AWS Organizations or upgrade to the Paid plan: either one ends the Free plan.

Sign up at https://aws.amazon.com, choose the **Free plan**, and use an email address you read every day: the budget alarms go there.

## Part 2: lock the root user

The root user is the email you signed up with. It can do anything, including close the account, so you use it only for these steps.

1. Sign in as root. Open your account name at the top right, then **Security credentials**.
2. Under **Multi-factor authentication (MFA)**, choose **Assign MFA device**: a passkey, or an authenticator app on your phone. Sign out and in again to check it asks.
3. Under **Access keys**, the list must be empty. If any key is listed, choose **Actions**, **Delete**. Root never gets access keys.
4. Open your account name, then **Account**. Find **IAM user and role access to Billing information**, choose **Edit**, tick **Activate IAM Access** and choose **Update**. Without this, your IAM user cannot see budgets or costs.

## Part 3: an IAM user for daily work

1. Open **IAM**. Choose **User groups**, **Create group**. Name it `admins`, attach the policy **AdministratorAccess**, and create it.
2. Choose **Users**, **Create user**. Name it `<yourname>-admin`, for example `asha-admin`. Tick **Provide user access to the AWS Management Console**, choose **I want to create an IAM user**, set a password, and untick "must create a new password". Add it to the group `admins`.
3. **Create no access keys** for this user. The CLI signs in another way (Part 4).
4. On the IAM dashboard, copy the **sign-in URL** for IAM users (it starts with your 12-digit account ID). Sign out of root, and sign in at that URL as `<yourname>-admin`.
5. As the IAM user, open your name at the top right, then **Security credentials**, and assign an MFA device to this user too.
6. At the top right, choose the Region **Asia Pacific (Mumbai) ap-south-1**. Check it before every step in the console.

From now on, sign in as the IAM user. Root stays locked away.

## Part 4: the CLI, signed in with `aws login`

### Install the AWS CLI and OpenTofu

- **AWS CLI v2**, version 2.32 or newer: download and run https://awscli.amazonaws.com/AWSCLIV2.msi (the AWS CLI install page), or `winget install --exact --id Amazon.AWSCLI`. Close every Git Bash window and open a new one, then check `aws --version`.
- **OpenTofu**: `winget install --exact --id=OpenTofu.Tofu --version <version>`, with the version in `VERSIONS.md`. Open a new Git Bash and check `tofu version`.

### Sign in

`aws login` signs the CLI in through your browser with your console sign-in. It stores **temporary** credentials that refresh themselves for up to 12 hours, so no access key ever sits on your laptop. It needs AWS CLI 2.32 or newer. (`AdministratorAccess` includes the permission it needs.)

In Git Bash:

```bash
aws login --profile cloudnet
```

- It asks for a Region the first time: type `ap-south-1`.
- A browser opens. Sign in as `<yourname>-admin` (with MFA), and choose the session. Then come back to Git Bash.
- If the browser does not open, use `aws login --profile cloudnet --remote` and paste the code it shows.

Check it:

```bash
export AWS_PROFILE=cloudnet
aws sts get-caller-identity
```

The `Arn` ends in `:user/<yourname>-admin`. If it ends in `:root`, sign out of the browser and sign in again as the IAM user.

When the sign-in expires (after up to 12 hours), commands fail with `ExpiredToken` or `NoCredentialProviders`: run `aws login --profile cloudnet` again.

### A profile for OpenTofu

The AWS CLI understands `aws login` sessions; for tools that may not, AWS documents a bridge: a profile whose `credential_process` asks the CLI for the current credentials. The kit's `provider.tf` uses this profile, `cloudnet-tofu`.

Open the config file in VS Code:

```bash
code ~/.aws/config
```

Under the `[profile cloudnet]` section that `aws login` wrote, add:

```ini
[profile cloudnet-tofu]
credential_process = aws configure export-credentials --profile cloudnet --format process
region = ap-south-1
```

Save, then check it:

```bash
aws sts get-caller-identity --profile cloudnet-tofu
```

It shows the same `Arn` as before. The file holds no secret: only the profile names, and the ARN of your session.

### One download of the AWS provider

Every P3 task folder runs `tofu init`, and each init would download the AWS provider again (hundreds of MB). A plugin cache keeps one copy. In Git Bash, once:

```bash
echo 'export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"' >> ~/.bashrc
mkdir -p ~/.terraform.d/plugin-cache
source ~/.bashrc
echo "$TF_PLUGIN_CACHE_DIR"
```

The last line prints the folder. From now on, `tofu init` copies the provider from the cache.

## Part 5: the budget alarm, before anything else

A budget compares your spending with an amount you choose, and emails you when it passes a threshold. Create it **before** you build anything.

**Budgets alert. They never stop spending.** A budget only sends an email: it does not stop or delete anything, and its data is updated up to three times a day, so the alert can come hours late. The only way to stop spending is to destroy what you built (Part 6).

**Usage before credits.** On the Free plan, credits pay for what you use. A budget that counts credits stays at $0 while your credits drain, and never fires. The kit's `budget.json` sets `"IncludeCredit": false`, so the budget counts your real usage.

The two files are in the kit's [`labs/cloudnet/tofu-skeleton/`](../labs/cloudnet/tofu-skeleton/), and in your `cloudnet/infra/` once you copy it there:

| File | What it says |
|---|---|
| `budget.json` | Budget `cloudnet-5usd`: a `COST` budget of 5 USD, `MONTHLY`, with `IncludeCredit` false |
| `notifications-with-subscribers.json` | Two email alerts: **80% of 5 USD, actual** spend, and **100%, forecasted** spend |

1. In `notifications-with-subscribers.json`, replace both `YOUR_EMAIL@example.com` with your own email address. Save. (Your email address is not a secret, but you may keep this edit out of your commit.)
2. In Git Bash, in `cloudnet/infra/`:

   ```bash
   export AWS_PROFILE=cloudnet
   ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
   aws budgets create-budget --account-id "$ACCOUNT_ID" \
     --budget file://budget.json \
     --notifications-with-subscribers file://notifications-with-subscribers.json
   ```

   It prints nothing when it works.
3. Check it, and paste the outputs into your evidence:

   ```bash
   aws budgets describe-budgets --account-id "$ACCOUNT_ID" \
     --query "Budgets[].{Name:BudgetName,Limit:BudgetLimit,TimeUnit:TimeUnit,IncludeCredit:CostTypes.IncludeCredit}"
   aws budgets describe-notifications-for-budget --account-id "$ACCOUNT_ID" --budget-name cloudnet-5usd
   ```

   They show `cloudnet-5usd`, `5.0 USD`, `MONTHLY`, `IncludeCredit: false`, and the two notifications: `ACTUAL` at 80 and `FORECASTED` at 100.
4. If AWS sends you an email to confirm the alerts, confirm it.

The budget is **not** in OpenTofu's state, on purpose: `tofu destroy` removes your network every day, and the budget stays for the whole course. To read what you have spent so far:

```bash
aws budgets describe-budget --account-id "$ACCOUNT_ID" --budget-name cloudnet-5usd --query "Budget.CalculatedSpend"
```

## Part 6: the teardown rule

Servers, the Elastic IP, the load balancer and interface endpoints bill **by the hour** while they exist, whether anyone uses them or not. A full CloudNet build costs about $0.11 an hour: $0.90 for a working day, or about $80 if you forget it for a month ([`labs/cloudnet/README.md`](../labs/cloudnet/README.md) has the prices).

1. **At the end of every working day**, in `cloudnet/infra/`:

   ```bash
   tofu destroy
   ```

   Read the plan: every resource shows `-`. Type `yes`. It ends with `Destroy complete! Resources: N destroyed.`
2. **Next morning**, `aws login --profile cloudnet` if needed, then `tofu apply` builds it all again from your code.
3. **Prove nothing is left** whenever a task asks, and at the end of P3:

   ```bash
   aws ec2 describe-instances --filters Name=tag:project,Values=cloudnet Name=instance-state-name,Values=pending,running,stopping,stopped --query "Reservations[].Instances[].InstanceId"
   aws ec2 describe-addresses --query "Addresses[].PublicIp"
   aws elbv2 describe-load-balancers --query "LoadBalancers[].LoadBalancerName"
   aws ec2 describe-vpc-endpoints --filters Name=tag:project,Values=cloudnet --query "VpcEndpoints[].VpcEndpointId"
   aws ec2 describe-nat-gateways --filter Name=state,Values=pending,available --query "NatGateways[].NatGatewayId"
   aws ec2 describe-vpcs --filters Name=tag:project,Values=cloudnet --query "Vpcs[].VpcId"
   ```

   Every one prints `[]`.
4. **Keep the budget.** It costs nothing and protects you for the rest of the Free plan.

## Secrets: what never goes into Git

- any AWS password, MFA code or access key (you should have none);
- `~/.aws/` (it lives outside your repository: keep it that way);
- `*.tfstate` and `*.tfplan` files (the kit's `.gitignore` lists them);
- your DuckDNS token (P3 task 18).

Your 12-digit account ID, your IAM user's ARN and your public IP addresses are not secrets.

## If something goes wrong

| What you see | What to do |
|---|---|
| `aws: command not found` | Close every Git Bash window and open a new one. |
| `aws: error: argument command: Invalid choice` for `login` | Your AWS CLI is older than 2.32. Install the current MSI, then reopen Git Bash. |
| `ExpiredToken`, `NoCredentialProviders` | Run `aws login --profile cloudnet` again. |
| `Error when retrieving credentials from custom-process` | The `cloudnet-tofu` profile cannot reach the `cloudnet` session. Run `aws sts get-caller-identity --profile cloudnet` first; if that fails, `aws login --profile cloudnet`. |
| `AccessDenied` on `budgets` | Part 2, step 4: activate IAM access to Billing information as root. |
| `DuplicateRecordException` from `create-budget` | The budget exists already. `describe-budgets` shows it. |
| The `Arn` ends in `:root` | You signed in to the browser as root. Sign out, sign in at the IAM sign-in URL, run `aws login --profile cloudnet` again. |
