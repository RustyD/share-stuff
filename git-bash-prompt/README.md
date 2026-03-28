# git-bash.sh — Git-Aware Bash Prompt

A self-contained bash script that gives you a coloured, git-aware shell prompt. When inside a git repository, the prompt shows the repo path, current branch, and a dirty-state indicator. Outside a repo, it falls back to a standard coloured prompt.

---

## Prerequisites

The script requires one external file for git tab-completion:

**`~/.git-completion.bash`**

Download it with:

```bash
curl -o ~/.git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
```

> The prompt functionality itself is fully self-contained — `git-completion.bash` is only needed for tab-completing git commands and branch names.

---

## Installation

1. Download the prerequisite file (see above).
2. Append the contents of `git-bash.sh` to your `~/.bashrc`:

```bash
cat git-bash.sh >> ~/.bashrc
```

3. Reload your shell:

```bash
source ~/.bashrc
```

---

## Linux note

The last line of the script references `update_terminal_cwd`, which is a **macOS-only** function. On Linux, change the final line to:

```bash
PROMPT_COMMAND="__set_ps1"
```

---

## What the prompt shows

### Inside a git repo

```
DD Mon YYYY HH:MM:SS  repo-name/subdir  (branch-name)  dirty-flags  $
```

| Element | Meaning |
|---|---|
| `repo-name/subdir` | Path from repo root to current directory |
| `(branch-name)` | Current branch, or `detached:abc1234` if in detached HEAD state |
| `+` | Staged changes |
| `*` | Unstaged changes |
| `%` | Untracked files |

### Outside a git repo

```
DD Mon YYYY HH:MM:SS  hostname  username  ~/current/path  $
```

---

## Included alias

```bash
alias groot='cd "$(git rev-parse --show-toplevel 2>/dev/null)"'
```

Typing `groot` from anywhere inside a repo jumps you back to the repo's top-level directory.
