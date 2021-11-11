#!/bin/bash
 askYesNo () 
{
        QUESTION=$1
        DEFAULT=$2
        if [ "$DEFAULT" = true ]; then
                OPTIONS="[Y/n]"
                DEFAULT="y"
            else
                OPTIONS="[y/N]"
                DEFAULT="n"
        fi
        read -p "$QUESTION $OPTIONS " -n 1 -s -r INPUT
        INPUT=${INPUT:-${DEFAULT}}
        echo ${INPUT}
        if [[ "$INPUT" =~ ^[yY]$ ]]; then
            ANSWER=true
        else
            ANSWER=false
        fi
}

pkg()
{
local packet="$1"
packagesNeeded=$packet
if [ -x "$(command -v apk)" ];       then sudo apk add --no-cache $packagesNeeded
elif [ -x "$(command -v apt-get)" ]; then sudo apt-get install $packagesNeeded
elif [ -x "$(command -v dnf)" ];     then sudo dnf install $packagesNeeded
elif [ -x "$(command -v zypper)" ];  then sudo zypper install $packagesNeeded
else echo "FAILED TO INSTALL PACKAGE: Package manager not found. You must manually install: $packagesNeeded">&2; fi
}


PS3='Which shell would you like to install on your system: '
shells=("zsh" "fish" "bash" "Quit")
select option in "${shells[@]}"; do
    case $option in
        "zsh")
            askYesNo "Do you want to install $option on your system?" true
            DOIT=$ANSWER

if [ "$DOIT" = true ]; then
    aux=$option
    pkg "$aux"
    chsh -s /bin/$aux $USERNAME
    touch ~/.zshrc
    mkdir -p ~/.config && touch ~/.config/starship.toml
    echo <<< # ~/.config/starship.toml

format = "[\\[](bold #ef476f)$username[@](bold #52b788)$hostname $directory[\\]](bold #ef476f)$character"

add_newline = false

[line_break]
disabled = true

[battery]
full_symbol = "🔋"
charging_symbol = "🔌"
discharging_symbol = "⚡"

[[battery.display]]
threshold = 30
style = "bold red"

[character]
error_symbol = "[\\$](bold #BB0A21)"
success_symbol = "[\\$](bold #3DDC97)"

[cmd_duration]
min_time = 10_000  # Show command duration over 10,000 milliseconds (=10 sec)
format = " took [$duration]($style)"

[directory]
truncation_length = 5
format = "[$path]($style #f28482)[$lock_symbol]($lock_style) "

[git_branch]
format = " [$symbol$branch]($style) "
symbol = "🍣 "
style = "bold yellow"

[git_commit]
commit_hash_length = 8
style = "bold white"

[git_state]
format = '[\($state( $progress_current of $progress_total)\)]($style) '

[git_status]
conflicted = "⚔️ "
ahead = "🏎️ 💨 ×${count}"
behind = "🐢 ×${count}"
diverged = "🔱 🏎️ 💨 ×${ahead_count} 🐢 ×${behind_count}"
untracked = "🛤️  ×${count}"
stashed = "📦 "
modified = "📝 ×${count}"
staged = "🗃️  ×${count}"
renamed = "📛 ×${count}"
deleted = "🗑️  ×${count}"
style = "bright-white"
format = "$all_status$ahead_behind"

[hostname]
ssh_only = false
format = "[$hostname]($style)"
trim_at = "-"
style = "bold #4ea8de"
disabled = false

[julia]
format = "[$symbol$version]($style) "
symbol = "ஃ "
style = "bold green"

[memory_usage]
format = "$symbol[${ram}( | ${swap})]($style) "
threshold = 70
style = "bold dimmed white"
disabled = false

[package]
disabled = true

[python]
format = "[$symbol$version]($style) "
style = "bold green"

[rust]
format = "[$symbol$version]($style) "
style = "bold green"

[time]
time_format = "%T"
format = "🕙 $time($style) "
style = "#FFF9FB"
disabled = true

[username]
style_user = "bold #FFC914"
format = "[$user]($style)"
show_always = true

>> ~/.config/starship.toml
    echo "eval "$(starship init zsh)"" >> ~/.zshrc
    sh -c "$(curl -fsSL https://starship.rs/install.sh)"
fi
break
	    # optionally call a function or run some code here
            ;;
        "fish")
            echo ""
	    # optionally call a function or run some code here
            ;;
        "bash")
            echo ""
	    # optionally call a function or run some code here
	    break
            ;;
	   "Quit")
	    echo "User requested exit"
	    exit
	    ;;
        *) echo "invalid option $REPLY";;
    esac
done


