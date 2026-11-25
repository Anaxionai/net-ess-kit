# Set up containerlab on your laptop (P2)

containerlab builds a whole network from one topology file: routers, hosts and the cables between them, each a container. You need it from week 4 (P2 OfficeLab) and in the capstone if you build in the lab.

**The course's route: the Containerlab WSL distro.** containerlab's own Windows guide (containerlab.dev/windows, read on 24 November 2026) recommends a ready-made WSL distribution called **Containerlab**. It has its own Docker engine and containerlab already installed, so nothing in your Ubuntu or Docker Desktop changes.

| | Where | What runs there |
|---|---|---|
| **The Containerlab terminal** | the Containerlab WSL distro | `containerlab`, `docker build` and `docker exec` for every P2 lab |
| The Ubuntu terminal | Ubuntu (WSL), with Docker Desktop | P1's LabNet (Docker Desktop's engine) |
| Git Bash | Windows | Git: commit and push |

The two Docker engines are separate: an image you build in one is not in the other. Every P2 lab command runs in the Containerlab terminal.

Versions are in [`VERSIONS.md`](../VERSIONS.md). Do steps 1 to 7 once, at the start of week 4. Plan about an hour; the download is about 1.2 GB.

## Step 1: check WSL

In **PowerShell**:

```powershell
wsl --version
```

`WSL version` must be **2.4.4 or newer**. If it is older, run `wsl --update`.

## Step 2: install the Containerlab distro

1. Open https://github.com/srl-labs/wsl-containerlab/releases/latest and download the `.wsl` file (named like `clab-0.83.0-1.0.wsl`). See `VERSIONS.md` for the release the course uses.
2. In PowerShell, in your Downloads folder:

   ```powershell
   wsl --install --from-file .\clab-0.83.0-1.0.wsl
   ```

   Use the file name you downloaded. Double-clicking the file does the same.
3. Open it: **Containerlab** in the Start menu, or `wsl -d Containerlab` in PowerShell.
4. The first time, a short menu asks which shell you want (choose **bash**, the course's shell), whether to install a font (yes is fine), and then sets up SSH keys for you. To run it again later: `/etc/oobe.sh`.

The distro's user is `clab`, with the password `clab`, and `sudo` needs no password. Commands in this course work without `sudo`; if one says `permission denied`, put `sudo` in front.

## Step 3: turn Docker Desktop's integration off for Containerlab

The distro must use its own Docker engine, not Docker Desktop's.

1. Open Docker Desktop, then **Settings** (the gear), **Resources**, **WSL integration**.
2. Make sure **Containerlab** is **off**. Keep **Ubuntu** on: P1 uses it.
3. Choose **Apply & restart**.

Check it in the Containerlab terminal:

```bash
docker version --format '{{.Server.Platform.Name}}'
containerlab version
```

- The first line must say `Docker Engine - Community`. If it says `Docker Desktop`, the integration is still on: repeat step 3, then run `wsl --terminate Containerlab` in PowerShell and open the distro again.
- `containerlab version` prints the version. To update it later: `sudo containerlab version upgrade`.

## Step 4: line endings

Topology files, `frr.conf` and scripts must have LF line endings, or FRR and bash fail with errors about `\r`.
In VS Code, open **Settings** (Ctrl+,), search for `eol`, and set **Files: Eol** to `\n`. The kit's `.gitattributes` keeps its own files LF.

## Step 5: the course kit in the Containerlab terminal

The distro has its own home folder, so it needs its own copy of the kit:

```bash
git clone https://github.com/Anaxionai/net-ess-kit.git ~/net-ess-kit
echo 'export CLAB_LABDIR_BASE=~/clab-labs' >> ~/.bashrc
mkdir -p ~/clab-labs
source ~/.bashrc
```

- `CLAB_LABDIR_BASE` tells containerlab to write each lab's working folder (`clab-<lab>/`) under `~/clab-labs` in the distro, not next to your topology file on drive C:. That is faster, and it keeps lab output out of your repository.
- Your course repository stays on drive C:, which the distro sees as `/mnt/c`. For example, `C:\Users\asha\net-ess-asha` is `/mnt/c/Users/asha/net-ess-asha`.

Some P2 briefs copy kit folders **in Git Bash** with `cp -r ~/net-ess-kit/...`. Git Bash has its own home folder too, so clone the kit there as well, once, in **Git Bash**:

```bash
cd ~ && git clone https://github.com/Anaxionai/net-ess-kit.git
```

When a task says to update the kit, run `git pull` in the copy that task uses.

## Step 6: build the router image

Every OfficeLab and broken lab uses the image `officelab-router`: FRR's containerlab image plus nftables, dnsmasq, WireGuard tools, bash, tcpdump and dig. Build it once, in the Containerlab terminal:

```bash
docker build -t officelab-router ~/net-ess-kit/labs/officelab/router-image
docker image ls officelab-router
```

The build downloads about 300 MB the first time. Build it again whenever a task tells you the kit's `router-image/Dockerfile` changed.

## Step 7: your first lab, two routers and one cable

Make a scratch folder in the distro and write the smallest possible lab:

```bash
mkdir -p ~/first && cd ~/first
cat > first.clab.yml <<'EOF'
name: first

topology:
  nodes:
    a:
      kind: frr
      image: officelab-router
    b:
      kind: frr
      image: officelab-router
  links:
    - endpoints: ["a:eth1", "b:eth1"]
EOF
containerlab deploy -t first.clab.yml
```

`deploy` prints a table with `clab-first-a` and `clab-first-b`, both `running`. The two routers have a cable between their `eth1` ports, and no addresses yet. Give them addresses and ping across:

```bash
docker exec clab-first-a ip addr add 10.0.0.1/30 dev eth1
docker exec clab-first-b ip addr add 10.0.0.2/30 dev eth1
docker exec clab-first-a ping -c 3 10.0.0.2
docker exec clab-first-a vtysh -c "show interface brief"
```

The ping gets three replies with 0% loss: your first network as code works. Then remove it:

```bash
containerlab destroy -t first.clab.yml --cleanup
```

`--cleanup` also deletes the lab's working folder. Every lab in the course follows this loop: **deploy, test, destroy**.

## Laptops with 8 GB of memory

Every WSL distro, Docker Desktop included, runs in one Linux virtual machine. The `memory=` limit in your `.wslconfig` (from `setup/windows.md`) covers all of them together.

- **Quit Docker Desktop while a P2 lab runs** (right-click its whale icon, **Quit Docker Desktop**). P2 does not use it, and it frees about 1 GB.
- **Run one lab at a time.** Destroy a lab before you deploy the next.
- What a lab costs, measured on 24 November 2026: an FRR router about **80–95 MB**, a host (`wbitt/network-multitool`) about **3 MB**. Office A (3 routers, 3 hosts) is about 350 MB; two offices about 450 MB; a broken lab under 250 MB.
- Close the browser tabs you do not need. If the laptop slows down, run `containerlab inspect --all` to see what is still running, and destroy it.

## Firewall logging (for P2 and the capstone)

nftables can count and log the packets a rule matches. Two ways work in a lab router:

1. **Counters (always works).** Add `counter` to a rule; `nft list ruleset` shows the packets and bytes it matched.
2. **NFLOG to tcpdump (tested in the course lab).** Write the rule with `log group 1` (you may add `prefix "M7 "`), then watch the matched packets on that router:

   ```bash
   docker exec -it clab-office-a-r1 tcpdump -i nflog:1 -nn
   ```

A plain `log prefix "..."` rule writes to the kernel log instead. Inside a lab container the kernel ignores it unless logging from containers is turned on for the whole WSL machine. Turn it on, once per WSL start, in the Containerlab terminal:

```bash
sudo modprobe nf_log_syslog
sudo sysctl -w net.netfilter.nf_log_all_netns=1
```

Then read the lines with `sudo dmesg | grep "M7 "`. If `sysctl` says the key is unknown, the logging module is not loaded: use the NFLOG way above.

## If something goes wrong

| What you see | What to do |
|---|---|
| `wsl --install --from-file` is not recognised | Your WSL is older than 2.4.4: `wsl --update`, then try again. |
| `docker version` says `Docker Desktop`, or containers vanish | Docker Desktop's integration is on for Containerlab. Step 3. |
| `Cannot connect to the Docker daemon` in the Containerlab terminal | Its engine is starting. Wait 10 seconds; if it persists, `sudo systemctl restart docker`. |
| `pull access denied for officelab-router` | Build the image (step 6) in the Containerlab terminal, not in Ubuntu or Git Bash. |
| `Pool overlaps with other one on this address space` | Another network uses `172.20.20.0/24`. Run `docker network ls`, then destroy the other lab. |
| `wg-quick: ... Protocol not supported` | `sudo modprobe wireguard`, then deploy again. |
| `$'\r': command not found` or FRR rejects a correct-looking line | CRLF line endings: step 4, then re-save the file as LF. |
| An edit does not show after a deploy | Deploy with `--reconfigure`. |
| The laptop is slow or a lab fails to start | Quit Docker Desktop, destroy other labs, and check `free -h` in the distro. |

To remove the distro after the course: `wsl --unregister Containerlab` in PowerShell. It deletes everything inside it, so push your work first.
