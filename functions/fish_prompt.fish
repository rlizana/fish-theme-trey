set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

function _git_branch_name
  command git symbolic-ref HEAD 2>/dev/null | sed -e 's|^refs/heads/||'
end

function fish_prompt
  set -l last_status $status

  # User variables and dynamic colors
  set -q fish_prompt_user_color; or set fish_prompt_user_color "757575"

  # Colors
  set -l gray (set_color -o 757575)
  set -l white (set_color -o FFFFFF)
  set -l primary (set_color -o 282D3C)
  set -l yellow (set_color -o E6DB74)
  set -l bg_yellow (set_color -b yellow)
  set -l red (set_color -o CC6666)
  set -l bg_red (set_color -b red)
  set -l blue (set_color -o 66D9EF)
  set -l green (set_color -o 00C853)
  set -l normal (set_color normal)

  # Dynamic color
  set -l user_color (set_color -o $fish_prompt_user_color)

  # Virtualenv
  set -l virtualenv $VIRTUAL_ENV_PROMPT
  if test -n "$virtualenv"
    set virtualenv_prompt "$green($virtualenv)$normal "
  end

  # User and hostname
  set -l user (whoami)
  set -l host (hostname)
  set -l user_indicator "$user_color$user@$host$normal"
  if test $user = "root"
    set user_indicator "$white$bg_red ! $normal $user_color$user@$host$normal"
  end

  # Current directory
  set -l cwd "$blue"(prompt_pwd)"$normal"

  # Git information
  set -l git_info ''
  set -l branch (_git_branch_name)
  if test -n "$branch"
    set -l _git_changes_count (command git status -s --ignore-submodules=dirty | wc -l)
    if test $_git_changes_count = 0
      set git_info "$normal ($green$branch$normal)"
    else
      set git_info "$normal ($yellow$branch ±$_git_changes_count$normal)"
    end
  end

  # Status indicator
  if test $last_status -eq 0
    set status_indicator "$white➜ "
  else
    set status_indicator "$red✗ "
  end

  # Build the prompt
  echo -n "$virtualenv_prompt$user_indicator $cwd $git_info $status_indicator$normal "
end
