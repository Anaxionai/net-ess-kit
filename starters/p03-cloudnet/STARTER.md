# Starter: CloudNet (P3, Guided)

This folder becomes your `cloudnet/` folder in P3 task 7. It holds the kit's app and OpenTofu skeleton in place (`app/` and `infra/`), plus **the VPC of task 8 done** in `infra/vpc.tf`, and one file per later task with `TODO(task N)` comments where your resources go.

## Copy it in

Do [`setup/aws.md`](../../setup/aws.md) first: MFA, `aws login`, the `cloudnet-tofu` profile and the budget. Then, in **Git Bash**, in P3 task 7's folder:

```bash
cp -r ~/net-ess-kit/starters/p03-cloudnet cloudnet
cd cloudnet/infra
export AWS_PROFILE=cloudnet
tofu init
tofu validate
```

`tofu validate` says `Success! The configuration is valid.` As shipped, `tofu plan` adds the IAM role and instance profile from `iam.tf` and the VPC: nothing that bills by the hour.

## What is included

| Path | What it is |
|---|---|
| `app/` | The kit's app and user-data scripts, unchanged (see the kit's `labs/cloudnet/README.md`) |
| `infra/versions.tf`, `provider.tf`, `iam.tf`, `.gitignore`, the budget JSON files | The kit's skeleton, unchanged |
| `infra/variables.tf`, `infra/outputs.tf` | The skeleton's files with TODOs for the variables and outputs your tasks add |
| `infra/vpc.tf` | **The VPC, done**; the subnets, gateway and route tables are TODO |
| `infra/security.tf`, `servers.tf`, `nacl.tf`, `lb.tf`, `endpoints.tf` | Comments only, one per resource your tasks add |
| `ACCESS.md` | The traffic matrix's columns |

## Every TODO

| Task | Files |
|---|---|
| 8 | `infra/vpc.tf`, `infra/outputs.tf` |
| 9 | `infra/security.tf`, `infra/servers.tf`, `infra/outputs.tf`, `ACCESS.md` |
| 10 | `infra/nacl.tf` |
| 17 | `infra/lb.tf`, `infra/security.tf`, `infra/nacl.tf`, `infra/servers.tf`, `infra/outputs.tf` |
| 18 | `infra/variables.tf`, `infra/servers.tf` |
| 19 | `infra/endpoints.tf`, `infra/security.tf`, `infra/nacl.tf` |
| 20 | No starter file: the teardown uses your code as it stands |

Find what is left with `grep -rn "TODO(task" cloudnet/`.

## What you still write yourself

Every resource except the VPC and the IAM role, every security-group and ACL rule from your own matrix, the outputs, `evidence.md`, `ACCESS.md`'s rows, `HTTPS.md`, `EGRESS.md` and `AI_LOG.md`. Put your own email address in `notifications-with-subscribers.json` before you create the budget.

**Every working day ends with `tofu destroy`.** The budget is not in OpenTofu, so it stays.
