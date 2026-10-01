# Observability Foundations for Claude Code: SecOps Edition

A 150-minute hands-on workshop from World Wide Technology, for security engineers: see what a coding agent does, detect the risky actions, and control it at one point.

This repository is your workspace for the workshop. It contains the lab guides, the helper scripts in `scripts/`, the LGTM settings in `lgtm/`, the detections, seeder and Collector config in `secops/`, and the agentgateway config in `agentgateway/`.

## What you need

- A laptop where you can install software and run Docker, and an internet connection.
- A GitHub account, and a way to sign in to Claude Code, such as a Claude account.
- Your own Anthropic API key, created in the Claude Console before the session. Labs 1 and 3 use it. You type it at a hidden prompt and never put it in a file or the chat.

## Start here

Do this before the session. The full pre-work guide, with troubleshooting for every step, is [workshop/pre-work.md](workshop/pre-work.md) (also as [pre-work.docx](workshop/pre-work.docx)).

### Step 1: Install git and the GitHub CLI

**Windows users: set up WSL first.** The workshop does not run in PowerShell or CMD. Open PowerShell as an administrator (right-click it, then choose Run as administrator) and run this:

```powershell
wsl --install
```

What this does: turns on Windows Subsystem for Linux and installs Ubuntu. It needs a restart, and leaves your Windows files alone.

Restart your computer when it asks. Then open Ubuntu from the Start menu, pick a username and password, and wait for the prompt to appear. From here on, type everything in that Ubuntu window, and follow the **Linux and WSL** commands below. Microsoft's guide is at https://learn.microsoft.com/en-us/windows/wsl/install. Keep your work in your Linux home folder, not under `/mnt/c`, because it is faster and avoids permission problems.

**How to do it.**

1. Install **git**.
   - **macOS:** run `xcode-select --install`, or `brew install git` if you use Homebrew (https://brew.sh).
   - **Linux and WSL:**

     ```bash
     sudo apt-get update && sudo apt-get install -y git curl
     ```

     What this does: refreshes the list of Ubuntu packages and installs git and curl. It asks for your password because it uses `sudo`.

   - Tell git who you are. Use your own name and email.

     ```bash
     git config --global user.name "Your Name"
     ```

     What this does: sets the name git puts on your commits, for every repository on this computer. It changes no files in any repository.

     ```bash
     git config --global user.email you@example.com
     ```

     What this does: sets the email address git puts on your commits, for every repository on this computer. It changes no files in any repository.

2. Install the **GitHub CLI**.
   - **macOS:** if you have Homebrew, run the command below. If you do not, either install Homebrew first from https://brew.sh (it needs administrator rights), or download the GitHub CLI installer from https://cli.github.com.

     ```bash
     brew install gh
     ```

     What this does: installs the GitHub CLI, `gh`, with Homebrew. It does not sign you in.

   - **Linux and WSL:** the official apt instructions are at https://github.com/cli/cli/blob/trunk/docs/install_linux.md. For Ubuntu and Debian, paste this whole block as one command:

     ```bash
     (type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) && sudo mkdir -p -m 755 /etc/apt/keyrings && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg && sudo mkdir -p -m 755 /etc/apt/sources.list.d && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null && sudo apt update && sudo apt install gh -y
     ```

     What this does: adds GitHub's package source and its signing key to apt, then installs `gh`. It asks for your password because it uses `sudo`, and it does not sign you in.

3. Open a **new terminal window** so your shell picks up the changes, then check each tool.

   ```bash
   git --version
   ```

   What this does: prints the version of git on your PATH. It changes nothing.

   ```bash
   gh --version
   ```

   What this does: prints the version of `gh`. It changes nothing.

### Step 2: Sign in to GitHub

**How to do it.**

1. Sign in to GitHub. Run this and answer the prompts. Choose **GitHub.com**, then **HTTPS**. When it asks "Authenticate Git with your GitHub credentials?", answer **Yes**. Then choose to sign in with a **web browser**. `gh` shows a one-time code and waits for you to press Enter before it opens your browser. Type the code there. If no browser opens (common in WSL), copy the URL that `gh` prints into a browser on Windows.

   ```bash
   gh auth login
   ```

   What this does: signs the GitHub CLI in to your GitHub account and stores its token on this computer. Because you answer yes to authenticating git, git uses it too when it pushes. It changes no repository.

2. Check that it worked.

   ```bash
   gh auth status
   ```

   What this does: shows which GitHub account `gh` is signed in to. It changes nothing.

### Step 3: Install Claude Code and sign in

**How to do it.**

1. Install **Claude Code** with the native installer. It works on macOS, Linux and WSL.

   ```bash
   curl -fsSL https://claude.ai/install.sh | bash
   ```

   What this does: downloads Anthropic's installer and installs Claude Code for your user account only. It changes no repository.

2. Open a **new terminal window**, then check the install.

   ```bash
   claude --version
   ```

   What this does: prints the version of Claude Code on your PATH. It changes nothing.

3. Sign in. Run this from any folder. On first launch Claude Code opens a browser window for you to log in. When it finishes, the terminal shows `Login successful`, and you press Enter to continue.

   ```bash
   claude
   ```

   What this does: starts an interactive Claude Code session in the current folder, and the first time, signs you in. Starting it changes no files.

   - If the browser does not open, press `c` to copy the login URL, then paste it into your browser.
   - If the browser shows a login code instead of returning to the terminal, paste the code at the `Paste code here if prompted` prompt. This is common in WSL.
   - If Claude Code asks whether you trust the folder, that is its workspace trust dialog. Read it, and say yes if the folder is one you made.
   - On first run you may also see theme or onboarding screens. Click through them.

4. Leave Claude Code: press `Ctrl+D` twice on an empty prompt. You are back at the normal prompt.

### Step 4: Make your copy of the workshop repository

**How to do it.** Run these two commands, one at a time, in the folder where you want the project to live. On WSL, that is your Linux home folder.

1. Clone the workshop repository into a folder called `my-claude-code-observability-secops`.

   ```bash
   git clone https://github.com/WWT-AINE-Workshops/claude-code-observability-secops.git my-claude-code-observability-secops
   ```

   What this does: downloads the workshop repository, with its full history, into a new folder called `my-claude-code-observability-secops`. Nothing else on your computer changes.

2. Move into the folder.

   ```bash
   cd my-claude-code-observability-secops
   ```

   What this does: moves your terminal into that folder. It changes nothing.

Stay in the `my-claude-code-observability-secops` folder for every step below. Now choose one of two paths.

**Quick: run the setup script.**

```bash
./scripts/setup-workshop.sh
```

What this does: walks you through the rest of the pre-work. It makes your private copy on GitHub, and checks your setup. If the workshop has GitHub issues for the labs, it also creates its labels and issues in your copy, and makes your copy the repository `gh` uses in this folder. Before each step it says what the step changes, then asks `Run it? [Y/n]`, so you can skip any step and do it by hand. It installs no tools and never asks for a password of its own, though git may ask you to sign in when it pushes. To answer yes to every question, run `./scripts/setup-workshop.sh --yes` instead.

When it ends with `Setup finished.`, the workshop basics are done: do step 5 and the lab tools check in step 6 next. If it ends with `Setup finished, with skipped steps:`, or stops on a step, do those steps by hand below.

**By hand.** Run these two commands, then carry on with the next step.

3. Remove the link back to the workshop repository.

   ```bash
   git remote remove origin
   ```

   What this does: deletes only your clone's pointer to the workshop's GitHub URL, which git calls `origin`. No commits, branches, tags or files are removed. The next command sets `origin` again, to your own private repository.

4. Create your private copy on GitHub and push to it.

   ```bash
   gh repo create my-claude-code-observability-secops --private --source . --remote origin --push
   ```

   What this does: creates a private repository called `my-claude-code-observability-secops` in your GitHub account, points `origin` at it and pushes your current branch, `main`, with its full history.

### Step 5: Install the lab tools

The labs need Docker running with the lab image already pulled, Python 3, agentgateway v1.6.0, and your own Anthropic API key. The image is a large download, so do this on a fast connection, before the session. The pre-work's step 5 has the steps for each system.

```bash
docker pull grafana/otel-lgtm:0.37.0
```

What this does: downloads the image that holds the OpenTelemetry Collector, Loki, Tempo, Prometheus and Grafana. It starts nothing.

### Step 6: Check your setup

**How to do it.** The setup script runs this check for you. On the by-hand path, run it in the `my-claude-code-observability-secops` folder, then read the output. Each line starts with a mark: a tick means ready, a warning means fix it if you can, a cross means it must be fixed.

```bash
./scripts/check-setup.sh
```

What this does: only reads and reports. It checks your tools, and changes nothing.

Then check the lab tools:

```bash
./scripts/check-lab-tools.sh
```

What this does: only reads and reports. It checks Docker, the lab image, Python, agentgateway and the lab ports, and changes nothing.

## Open the workshop guide

**[workshop/README.md](workshop/README.md)** has the agenda and links to every lab.

---
