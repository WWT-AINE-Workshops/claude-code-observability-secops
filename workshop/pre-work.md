# Pre-work for Observability Foundations for Claude Code: SecOps Edition

Do this before the session. It takes about **15 minutes** if Docker and Claude Code are already installed, and up to **90 minutes** if they are not. Most of that is waiting for downloads: the lab image alone is a large download, so do step 5 on a fast connection. In the session you will start working in the first few minutes, so a ready laptop matters.

When you finish, you will have the tools installed and your own private copy of the workshop repository. You do not need to know the topic yet.

**What you need.**

- A laptop where you can install software and run Docker, with its charger and an internet connection.
- A GitHub account.
- A way to sign in to Claude Code, such as a Claude account. The docs list the options on their authentication page: https://code.claude.com/docs/en/authentication.
- **Your own Anthropic API key.** Create one in the Claude Console before the session. Lab 1 (step 5) and Lab 3 use it, and the labs send only a few short requests. You type it at a hidden prompt, and never put it in a file, a prompt or the chat. If you cannot get one, tell the facilitator: you can pair with a neighbour.

**Where to type commands.** Everything below runs in a terminal. On macOS that is the Terminal app. On Linux it is your terminal. On Windows you use WSL, a Linux terminal inside Windows, and the first step shows how to set it up. Lines in grey boxes are commands: copy one box at a time, paste it into the terminal and press Enter.

**Version numbers will differ.** Your numbers will not match the examples exactly. That is fine.

## Step 1: Install git and the GitHub CLI

**Who does it:** Everyone.

**Why it matters:** The labs use git to track changes and the GitHub CLI (`gh`) to create your own copy of the workshop repository.

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

**Done when:** both commands print a version number.

**If you get stuck.**

- `wsl --install` needs a restart and may need administrator rights, so allow extra time on Windows.
- Your company laptop blocks installs: ask your IT team, or bring a personal laptop. Tell the facilitator ahead of time and we will find a way.
- On another Linux distribution, install the same tools with your package manager. The links above have instructions.

## Step 2: Sign in to GitHub

**Who does it:** Everyone.

**Why it matters:** The GitHub CLI creates your copy of the repository, so it needs your account.

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

**Done when:** `gh auth status` says you are logged in to github.com.

**If you get stuck.**

- `gh auth login` keeps asking for a code: copy the code exactly, including the dash, into the page your browser opened.
- If your company signs in to GitHub with single sign-on, you may need to authorize the GitHub CLI for your organization. This workshop only uses your personal account.

## Step 3: Install Claude Code and sign in

**Who does it:** Everyone.

**Why it matters:** Claude Code is the tool this workshop is about, and it needs your account before it will answer anything. The docs list the ways to sign in, so read their authentication page first: https://code.claude.com/docs/en/authentication.

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

**Done when:** `claude --version` prints a version number, and Claude Code showed `Login successful`.

**If you get stuck.**

- `command not found: claude`: the install folder is not on your PATH yet. Open a new terminal and try again. If it still fails, see the install troubleshooting page: https://code.claude.com/docs/en/troubleshoot-install.
- The install fails with a `403` or a curl error: this is often a company network or proxy. Try from another network, and tell the facilitator what the error said.
- Which sign-in option to use depends on how you pay for Claude. Check the authentication page, or ask your team admin. If your organization gave you an invitation, accept it first.
- Setup docs for Claude Code: https://code.claude.com/docs/en/setup.

## Step 4: Make your copy of the workshop repository

**Who does it:** Everyone.

**Why it matters:** You get your own private repository, so you can commit, push and open pull requests without touching anyone else's. Cloning keeps the full commit history, so do not use GitHub's fork button.

**Why a private copy and not a fork.** A fork of a public repository is public, and GitHub does not let you make it private. In a fork, the GitHub CLI can pick the workshop repository instead of yours when you work with issues or pull requests. Some companies do not allow forks at all. And you lose nothing by not forking: your copy needs no link back to the workshop repository.

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

What this does: walks you through the rest of the pre-work. It makes your private copy on GitHub, and checks your setup. It also makes your copy the repository `gh` uses in this folder.

Before each step it says what the step changes, then asks `Run it? [Y/n]`, so you can skip any step and do it by hand. It installs no tools and never asks for a password of its own, though git may ask you to sign in when it pushes. To answer yes to every question, run `./scripts/setup-workshop.sh --yes` instead.

When it ends with `Setup finished.`, the workshop basics are done. The script doesn't install the lab tools, so do step 5 next, then run `./scripts/check-lab-tools.sh` from step 6. If it ends with `Setup finished, with skipped steps:`, or stops on a step, do those steps by hand below.

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

**Done when:** the setup script ended with `Setup finished.`, or the last command finished without an error. Step 5 comes next. Either way, the new repository shows up at `github.com/<your user name>/my-claude-code-observability-secops`.

**If you get stuck.**

- `Repository not found` on the clone: check your network and try again. If it still fails, tell the facilitator.
- The setup script says a tool is missing: install it with the command it shows, or with the steps above. Open a new terminal, then run the script again. It skips the steps that are already done.
- `Name already exists on this account`: you have a repository called `my-claude-code-observability-secops` already. Rename or delete that one on GitHub, or pick another name. To pick another name, run this, with the name you want in place of `<another name>`:

  ```bash
  ./scripts/setup-workshop.sh --name <another name>
  ```

  What this does: runs the setup again with the new name. It skips the steps that are already done.

  Or put the other name in the last command.

- `fatal: destination path 'my-claude-code-observability-secops' already exists`: you cloned before. Run `cd my-claude-code-observability-secops` and continue from there, or delete the folder and start again.

## Step 5: Install the lab tools

**Who does it:** Everyone.

**Why it matters:** The labs run an observability stack in Docker, a small Python script, and agentgateway. The stack is a large download, so it must be on your laptop before the session. The labs use ports 3000, 4000, 4317, 4318 and 15000, so stop any program that uses them before the session.

**How to do it.**

1. Install **Docker**.
   - **macOS:** install Docker Desktop from https://docs.docker.com/desktop/setup/install/mac-install/, then open it.
   - **Windows with WSL:** install Docker Desktop for Windows from https://docs.docker.com/desktop/setup/install/windows-install/. In Docker Desktop, open **Settings**, then **Resources**, then **WSL integration**, and turn it on for Ubuntu. Then work in the Ubuntu window as usual.
   - **Linux:** install Docker Engine from https://docs.docker.com/engine/install/, and make sure your user can run `docker` without `sudo`.

   Check that Docker is running.

   ```bash
   docker version
   ```

   What this does: prints the version of the Docker client and of the Docker engine it talks to. It changes nothing.

2. Pull the lab image. It holds the OpenTelemetry Collector, Loki, Tempo, Prometheus and Grafana in one container.

   ```bash
   docker pull grafana/otel-lgtm:0.37.0
   ```

   What this does: downloads the `grafana/otel-lgtm` image at version 0.37.0 into Docker. It is a large download. It starts nothing.

3. Check **Python 3**. macOS and most Linux systems already have it.

   ```bash
   python3 --version
   ```

   What this does: prints the version of Python 3. It changes nothing. If it is missing, run `brew install python` on macOS, or `sudo apt-get install -y python3` on Linux and WSL.

4. Install **agentgateway v1.6.0**. Open https://github.com/agentgateway/agentgateway/releases/tag/v1.6.0 and download the file for your system: macOS or Linux, and arm64 or amd64. On WSL, take the Linux one. If the file is an archive, such as `.tar.gz` or `.zip`, unpack it and use the `agentgateway` file inside. Make a folder for it.

   ```bash
   mkdir -p ~/.local/bin
   ```

   What this does: makes the folder `~/.local/bin` in your home folder, if it does not exist yet. It changes nothing else.

   Move the file you downloaded into that folder and name it `agentgateway`. Put the name of your downloaded file in place of `<downloaded file>`:

   ```bash
   mv ~/Downloads/<downloaded file> ~/.local/bin/agentgateway
   ```

   What this does: moves the downloaded binary into `~/.local/bin` as `agentgateway`. On WSL, your Windows downloads are under `/mnt/c/Users/<your Windows user>/Downloads`.

   Make it executable.

   ```bash
   chmod +x ~/.local/bin/agentgateway
   ```

   What this does: lets the file run as a program. It changes nothing else.

   Check that `~/.local/bin` is on your PATH: run `echo $PATH` and look for `.local/bin`. If it is missing, add this line to the end of `~/.zshrc` on macOS, or `~/.bashrc` on Linux and WSL:

   ```text
   export PATH="$HOME/.local/bin:$PATH"
   ```

   Then open a new terminal and check the install.

   ```bash
   agentgateway --version
   ```

   What this does: prints the version of agentgateway on your PATH. It changes nothing.

5. Have your **Anthropic API key** ready. Create one in the Claude Console if you do not have one, and keep it in your password manager. If you cannot get one before the session, tell the facilitator: you can pair with a neighbour. In the labs you type it at a hidden prompt. Never put it in a file, a prompt or a chat.

**Done when:** `docker version` shows a Server section, the image pull finished, `python3 --version` prints 3.8 or later, and `agentgateway --version` mentions 1.6.0.

**If you get stuck.**

- `Cannot connect to the Docker daemon`: Docker is not running. Start Docker Desktop, or on Linux run `sudo service docker start`, then try again.
- Your company laptop does not allow Docker Desktop: ask your IT team, or bring a laptop that does. Tell the facilitator ahead of time.
- `agentgateway: command not found`: `~/.local/bin` is not on your PATH. Add the `export PATH` line from the install step to `~/.zshrc` on macOS, or `~/.bashrc` on Linux and WSL, then open a new terminal.
- macOS says agentgateway cannot be opened because the developer cannot be verified: open **System Settings**, then **Privacy & Security**, and choose **Allow Anyway** for agentgateway. Then run `agentgateway --version` again.

## Step 6: Check your setup

**Who does it:** Everyone.

**Why it matters:** Two scripts check everything above and tell you how to fix anything missing. The first checks the workshop basics, the second the lab tools: Docker, the lab image, Python and agentgateway.

**How to do it.** The setup script runs this check for you. On the by-hand path, run it in the `my-claude-code-observability-secops` folder, then read the output. Each line starts with a mark: a tick means ready, a warning means fix it if you can, a cross means it must be fixed.

```bash
./scripts/check-setup.sh
```

What this does: only reads and reports. It checks your tools, and changes nothing.

Then check the lab tools.

```bash
./scripts/check-lab-tools.sh
```

What this does: only reads and reports. It checks Docker, the lab image, Python, agentgateway and the lab ports, and changes nothing.

**Done when:** the first script's last line says `Ready for the workshop.`, and the second one's says `Lab tools ready.`

**If you get stuck.**

- Each cross line says what is wrong and the command that fixes it. Run that command, then run the script again.
- `Permission denied`: run `chmod +x scripts/*.sh`, then try again.
- To check the Claude Code sign-in as well, add the `--live` option. It sends one tiny request, so it needs a working sign-in:

  ```bash
  ./scripts/check-setup.sh --live
  ```

  What this does: the same check, plus one short request to Claude Code to prove you are signed in. It changes no files.

## Before the session checklist

Tick each box.

- [ ] Windows only: WSL is installed, and I type everything in the Ubuntu window.
- [ ] `git --version` and `gh --version` print a version.
- [ ] `gh auth status` says I am logged in.
- [ ] `claude --version` prints a version, and Claude Code showed `Login successful`.
- [ ] My private `my-claude-code-observability-secops` repository exists on GitHub.
- [ ] Docker is running, and `docker pull grafana/otel-lgtm:0.37.0` finished.
- [ ] `python3 --version` and `agentgateway --version` print a version.
- [ ] I have my own Anthropic API key, and it is in my password manager, not in a file.
- [ ] `./scripts/check-setup.sh` ends with `Ready for the workshop.`, and `./scripts/check-lab-tools.sh` ends with `Lab tools ready.`
- [ ] I will bring my laptop, charger and an internet connection.
- [ ] I know who to ask for help if something in this list fails: the facilitator.

If one box will not tick, do not wait. Tell the facilitator before the session what the error says.
