# Set up your Windows laptop

This guide sets up a Windows 11 laptop for NET-ESS. Do it in week 1 (the Launchpad), section by section, and run each check before you go on.
P2 adds one more piece, the Containerlab distro ([`containerlab.md`](containerlab.md)), and P3 adds the AWS CLI and OpenTofu ([`aws.md`](aws.md)).

The versions the course uses are in [`VERSIONS.md`](../VERSIONS.md).

## Before you start

- **Windows 11, version 23H2 or newer.** Press Windows+R, type `winver`, press Enter. Docker Desktop needs 23H2 (build 22631) or newer.
- **At least 8 GB of memory and 20 GB of free disk space.**
- **Virtualisation turned on.** Task Manager → Performance → CPU must say `Virtualization: Enabled`. If it says Disabled, ask your mentor to turn on Intel VT-x or AMD SVM in the BIOS.
- **An administrator account** on the laptop, and the charger plugged in.

## Which terminal for what

| Terminal | How to open it | Use it for |
|---|---|---|
| **PowerShell** | Start menu → PowerShell (for installs: right-click → Run as administrator) | Windows network tools: `ipconfig /all`, `ping`, `tracert`, `nslookup`, `Get-NetTCPConnection`; `wsl` commands; Wireshark's `tshark.exe` |
| **Git Bash** | VS Code's terminal (the default profile, prompt `MINGW64`) | Git: clone, commit, push. In P3 also `aws` and `tofu` |
| **Ubuntu (WSL)** | VS Code's terminal menu (the arrow next to +) → **Ubuntu (WSL)** | Linux networking commands (`ip`, `ss`, `dig`, `ipcalc`, `nc`, `tcpdump`) and Docker in P1 |
| **Containerlab** (from P2) | Start menu → Containerlab, or `wsl -d Containerlab` | `containerlab` and `docker exec` for the P2 labs and a lab capstone |

Every brief says which terminal a step uses. When in doubt: Git in Git Bash, Linux in Ubuntu.

## 1. Git, Git Bash and VS Code (Launchpad tasks 5 and 6)

1. Install Git for Windows from https://git-scm.com/downloads/win with the default options. It brings **Git Bash** and Git Credential Manager (for signing in to GitHub).
2. Install VS Code from https://code.visualstudio.com/download with the default options; keep **Add to PATH** ticked.
3. In VS Code, press Ctrl+Shift+P, run `Terminal: Select Default Profile`, and choose **Git Bash**.
4. In Settings (Ctrl+,), search for `eol` and set **Files: Eol** to `\n`. Files you create then have LF line endings, which Linux, containers and routers need.

Check it: open a terminal with Ctrl+`. The prompt shows `MINGW64`, and `git --version` prints `git version 2.` and more.

## 2. WSL 2 with Ubuntu (Launchpad task 11)

WSL 2 runs a real Linux system inside Windows. In **PowerShell as administrator**:

```powershell
wsl --install
```

Restart when it asks. When Ubuntu opens, choose a short Linux user name (such as `asha`) and a password you will remember: `sudo` asks for it.

Check it in a normal PowerShell:

```powershell
wsl --version
wsl -l -v
```

`WSL version` is 2.4.4 or newer (run `wsl --update` if not), and `Ubuntu` shows `VERSION 2`.

## 3. Limit WSL's memory (8 GB laptops: do this before any container)

Ubuntu, Docker Desktop and (from P2) the Containerlab distro all run inside one WSL virtual machine. This limit keeps them to 4 GB, so Windows, VS Code and your browser keep enough.

In Git Bash, write `.wslconfig` in your Windows user folder:

```bash
cat > ~/.wslconfig <<'EOF'
[wsl2]
memory=4GB
swap=2GB

[experimental]
autoMemoryReclaim=gradual
EOF
cat ~/.wslconfig
```

On a 16 GB laptop, use `memory=8GB` instead. Then, in PowerShell, `wsl --shutdown`, and wait 8 seconds before you start Docker Desktop.

## 4. Docker Desktop, with Ubuntu's integration on (Launchpad task 11)

Docker Desktop runs containers on Windows, using WSL 2. It is free under the Personal plan for individual learning, and for small businesses with fewer than 250 employees and less than $10 million in yearly revenue.

1. Download **Docker Desktop for Windows (x86_64)** from https://docs.docker.com/desktop/setup/install/windows-install/ and run it. Keep **Use WSL 2 instead of Hyper-V** ticked.
2. Start Docker Desktop. Accept the agreement; signing in is optional. Wait for **Engine running** at the bottom left.
3. Open **Settings** (the gear) → **Resources** → **WSL integration**. Turn on **Ubuntu**, then **Apply & restart**.

Check it in the **Ubuntu terminal** (VS Code → terminal menu → Ubuntu (WSL)):

```bash
docker run --rm hello-world
docker compose version
docker info | grep "Total Memory"
```

You see `Hello from Docker!`, a Compose version, and `Total Memory` of about 3.8 GiB (your 4 GB limit).

Docker Desktop must be running whenever P1 uses Docker. In P2, quit it while a lab runs ([`containerlab.md`](containerlab.md)).

## 5. Linux tools in Ubuntu (Launchpad task 11)

In the Ubuntu terminal:

```bash
sudo apt update
sudo apt install -y bind9-dnsutils ipcalc netcat-openbsd tcpdump
dig -v
ipcalc 192.168.1.10/24
```

`dig -v` prints a version, and `ipcalc` prints the network, broadcast and host range of `192.168.1.10/24`. `ip`, `ss`, `ping` and `traceroute`-style tools come with Ubuntu (`sudo apt install -y traceroute` adds `traceroute`).

## 6. The course kit (Launchpad task 11)

Clone the kit into your **Linux** home folder, in the Ubuntu terminal, with the command in the kit's [`README.md`](../README.md). Then:

```bash
ls ~/net-ess-kit
```

It lists `README.md`, `VERSIONS.md`, `setup`, `labs` and the other folders. Your course repository stays on drive C:, which Ubuntu sees as `/mnt/c` (for example `/mnt/c/Users/asha/net-ess-asha`).

## 7. Wireshark and Npcap (Launchpad task 9)

Wireshark shows packets. On Windows it captures through the **Npcap** driver, which the Wireshark installer installs for you.

1. Download **Windows x64 Installer** from https://www.wireshark.org/download.html (the version in `VERSIONS.md`), and run it.
2. Click through **Welcome**, the **licence** and **Choose Components** with the defaults.
3. On **Packet Capture**, keep **Install Npcap** ticked. On **USB Capture**, leave **Install USBPcap** unticked.
4. When the Npcap installer opens, accept its licence and keep its default options (do **not** tick "Restrict Npcap driver's access to Administrators only"). Finish it.
5. Finish the Wireshark installer. Restart if it asks.

Check it in PowerShell:

```powershell
& "C:\Program Files\Wireshark\tshark.exe" -D
```

It lists your interfaces (such as `Wi-Fi` and `Ethernet`): Npcap works. If the list is empty, run the installer again with **Install Npcap** ticked.

**Capture only your own traffic**, on your own laptop or in your own lab. Never capture on a network or machine you do not own or have not been told to test.

To give a capture as evidence, use text: Wireshark's **File → Export Packet Dissections → As Plain Text**, or `tshark.exe -r file.pcapng`. Never commit `.pcap` or `.pcapng` files unless a task asks for them.

## Final check

| Where | Command | You see |
|---|---|---|
| Git Bash | `git --version` | `git version 2.` and more |
| PowerShell | `wsl -l -v` | `Ubuntu` with `VERSION 2` |
| Git Bash | `cat ~/.wslconfig` | `memory=4GB` (or `8GB`) and `swap=2GB` |
| Ubuntu | `docker run --rm hello-world` | `Hello from Docker!` |
| Ubuntu | `ipcalc 10.0.0.0/30` | the network, broadcast and two hosts |
| Ubuntu | `ls ~/net-ess-kit` | the kit's folders |
| PowerShell | `& "C:\Program Files\Wireshark\tshark.exe" -D` | your interfaces |

## If something goes wrong

| What you see | What to do |
|---|---|
| `wsl --install` says virtualisation is off | Turn on Intel VT-x or AMD SVM in the BIOS. Ask your mentor. |
| `docker: command not found` in Ubuntu | Start Docker Desktop; check Settings → Resources → WSL integration has Ubuntu on; open a new Ubuntu terminal. |
| `Cannot connect to the Docker daemon` | Docker Desktop is not running, or still starting. Wait for **Engine running**. |
| Ubuntu (WSL) is missing from VS Code's terminal menu | Install the **WSL** extension from Microsoft in VS Code, then reopen VS Code. |
| `$'\r': command not found` or `bad interpreter` | The file has CRLF line endings. Click `CRLF` in VS Code's status bar, choose `LF`, save. Then check **Files: Eol** (section 1). |
| `tshark.exe -D` lists nothing | Npcap is missing: run the Wireshark installer again with **Install Npcap** ticked. |
| The laptop is slow when Docker runs | Check section 3, and stop labs with `docker compose down` when you finish. |
