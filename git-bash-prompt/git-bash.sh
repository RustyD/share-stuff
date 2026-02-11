

# --- A handy-dandy alias ---

alias groot='cd "$(git rev-parse --show-toplevel 2>/dev/null)"'  # Return to git repo top level directory



# --- Enable Auto-Completion for Git (when using the 'tab' key) ---

source ~/.git-completion.bash



# --- Now set up 2 different prompts: one for git, one for normal directories

# 'Bright' Colors (safe for bash prompt)
c_reset="\[\e[0m\]"
c_red="\[\e[91m\]"
c_green="\[\e[92m\]"
c_yellow="\[\e[93m\]"
c_blue="\[\e[94m\]"
c_magenta="\[\e[95m\]"
c_cyan="\[\e[96m\]"
c_white="\[\e[97m\]"
c_dim="\[\e[90m\]"


# --- Git-aware prompt for Bash ---

# Helper: return current branch (or short SHA if detached), or nothing if not in repo
__git_branch() {
  # Are we inside a work tree?
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 0

  # Branch name if on a branch…
  local b
  b="$(git symbolic-ref --quiet --short HEAD 2>/dev/null)" || true

  # …otherwise detached HEAD → short commit SHA
  if [[ -z "$b" ]]; then
    b="$(git rev-parse --short HEAD 2>/dev/null)" || true
    [[ -n "$b" ]] && printf "%s" "detached:$b"
  else
    printf "%s" "$b"
  fi
}

# Helper: return current working directory up to and including the top level git repo dir
__git_path() {
  local top rel
  top="$(git rev-parse --show-toplevel 2>/dev/null)" || return 0

  # rel = current directory path relative to repo root
  rel="${PWD#"$top"}"
  rel="${rel#/}"  # remove leading slash if present

  if [[ -n "$rel" ]]; then
    printf '%s/%s' "${top##*/}" "$rel"
  else
    printf '%s' "${top##*/}"
  fi
}

# Quick 'dirty' git repo indicator:
#   +  = staged changes
#   *  = unstaged changes
#   %  = untracked files
__git_dirty() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 0

  local s
  s="$(git status --porcelain 2>/dev/null)" || return 0  # porcelain output is stable for scripts [3](https://www.codestudy.net/blog/make-git-status-show-unmodified-unchanged-tracked-files/)[4](https://git-scm.com/docs/rev-list-options)

  local out=""

  # Staged: index status is in column 1 (not space or '?')
  if grep -qE '^[^ ?]' <<<"$s"; then
    out+="+"
  fi

  # Unstaged: working tree status is in column 2 (not space)
  if grep -qE '^.[^ ]' <<<"$s"; then
    out+="*"
  fi

  # Untracked: starts with '??'
  if grep -qE '^\?\?' <<<"$s"; then
    out+="%"
  fi

  # Only add a trailing space if we actually found something
  [[ -n "$out" ]] && out+=" "

  printf '%s' "$out"
}


__set_ps1() {
  local branch="$(__git_branch)"

  if [[ -n "$branch" ]]; then

    local gwd="$(__git_path)"
    local dirty="$(__git_dirty)"

    # Prompt when inside a Git repo
    PS1="${c_red}\d \t ${c_blue}${gwd} ${c_green}(${branch}) ${c_magenta}${dirty}${c_cyan}\$ ${c_reset}"

  else

    # Prompt when NOT in a Git repo
    PS1="${c_red}\d \t ${c_magenta}\h ${c_green}\u ${c_blue}\w ${c_cyan} \$ ${c_reset}"

  fi
}


# Run before each prompt - ensure existing PROMPT_COMMAND is post-pended.

PROMPT_COMMAND="__set_ps1;update_terminal_cwd"          # update_terminal_cwd for MacOS only, to preserve working directory between sessions

