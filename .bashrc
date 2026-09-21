# ~/.bashrc
#
# Interactive shell configuration.

# ============================================================
# Early exit for non-interactive shells
# ============================================================
[[ $- != *i* ]] && return


# ============================================================
# Environment
# ============================================================
export EDITOR="nvim"

# Add user's private bin to PATH, if it exists
if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Project paths / PYTHONPATH
export TOOLS="/home/toma/Documents/"
for i in RouToolPa MACE MAVR KrATER Biocrutch; do
    export PYTHONPATH="${PYTHONPATH}:${TOOLS}/${i}"
done


# ============================================================
# History
# ============================================================
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoredups:erasedups   # skip duplicate lines
shopt -s histappend                # append to the history file instead of overwriting it
shopt -s cmdhist                   # save multi-line commands as a single history entry

# Sync history across all open terminals after every prompt
PROMPT_COMMAND="history -a; history -c; history -r${PROMPT_COMMAND:+; $PROMPT_COMMAND}"


# ============================================================
# Prompt
# ============================================================
PS1='[\u@\h \W]\$ '


# ============================================================
# Aliases
# ============================================================
alias ls='ls --color=auto'
alias l='ls -lah'
alias ll='ls -lah'
alias lll='ls -lah'
alias grep='grep --color=auto'

alias mytmux='tmux attach || tmux new'

alias gfix="git add . && git commit -m 'fix' && git push origin master"
alias kgfix='CWD=$(pwd) && cd /home/toma/Documents/knowbase/ && git add . && git commit -m "fix" && git push origin master; cd "${CWD}"'


# ============================================================
# Utility functions
# ============================================================

# Create a directory (with parents) and cd into it
mkcd() {
    mkdir -p -- "$1" && cd -- "$1"
}

# Extract almost any archive type
extract() {
    if [ -z "$1" ]; then
        echo "Usage: extract <archive>"
        return 1
    fi
    if [ ! -f "$1" ]; then
        echo "'$1' is not a valid file"
        return 1
    fi
    case "$1" in
        *.tar.bz2) tar xjf "$1"  ;;
        *.tar.gz)  tar xzf "$1"  ;;
        *.tar.xz)  tar xJf "$1"  ;;
        *.tar)     tar xf  "$1"  ;;
        *.bz2)     bunzip2 "$1"  ;;
        *.rar)     unrar x "$1"  ;;
        *.gz)      gunzip "$1"   ;;
        *.zip)     unzip "$1"    ;;
        *.7z)      7z x "$1"     ;;
        *)         echo "Unknown archive format: '$1'" ;;
    esac
}

# Quick non-interactive grep through command history
# (Ctrl+R already gives fuzzy history search via fzf, see below)
hg() {
    history | grep --color=auto -- "$1"
}


# ============================================================
# fzf
# ============================================================

# Key bindings + fuzzy completion
eval "$(fzf --bash)"

# Use fd instead of the default find-based commands
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd for path / directory completion
_fzf_compgen_path() {
    fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
    fd --type=d --hidden --exclude .git . "$1"
}

# Preview: tree for directories, file contents (via bat) otherwise
show_file_or_dir_preview="if [ -d {} ]; then tree -C --dirsfirst -L 2 -- {}; else bat -n --color=always --line-range=:500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'tree -C --dirsfirst -L 2 -- {}'"

# Per-command preview customization
_fzf_comprun() {
    local command=$1
    shift

    case "$command" in
        cd)
            fzf --preview 'tree -C --dirsfirst -L 2 -- {}' "$@"
            ;;
        export|unset)
            fzf --preview "eval 'echo \${}'" "$@"
            ;;
        ssh)
            fzf --preview 'ssh -G {} 2>/dev/null | grep -E "^(hostname|user|port|identityfile) "' "$@"
            ;;
        *)
            fzf --preview "$show_file_or_dir_preview" "$@"
            ;;
    esac
}


# ============================================================
# Conda / mamba
# ============================================================

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/toma/miniforge3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/toma/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/home/toma/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/home/toma/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba shell init' !!
export MAMBA_EXE='/home/toma/miniforge3/bin/mamba'
export MAMBA_ROOT_PREFIX='/home/toma/miniforge3'
__mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias mamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<
