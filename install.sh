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
    mkdir -p ~/.config && cp -a user/starship.toml ~/.config/starship.toml
    sh -c "$(curl -fsSL https://starship.rs/install.sh)"
    sed -i -e 'eval "$(starship init zsh)"' ~/.zshrc
    echo "Please Restart your terminal!"
fi
break
            ;;
        "fish")
            askYesNo "Do you want to install $option on your system?" true
            DOIT=$ANSWER

if [ "$DOIT" = true ]; then
    aux=$option
    pkg "$aux"
    chsh -s /usr/bin/$aux $USERNAME
    mkdir -p ~/.config/fish/ && touch ~/.config/fish/config.fish
    mkdir -p ~/.config && cp -a user/starship.toml ~/.config/starship.toml
    sh -c "$(curl -fsSL https://starship.rs/install.sh)"
    sed -i -e '$aeval "$(starship init fish | source)"' ~/.config/fish/config.fish
    echo "Please Restart your terminal!"
fi
break
            ;;
        "bash")
        askYesNo "Do you want to install prompt theme on your system?" true
            DOIT=$ANSWER
if [ "$DOIT" = true ]; then
    aux=$option
    chsh -s /bin/$aux $USERNAME
    mkdir -p ~/.config && cp -a user/starship.toml ~/.config/starship.toml 
    sh -c "$(curl -fsSL https://starship.rs/install.sh)"
    sed -i -e '$aeval "$(starship init bash)"' ~/.bashrc
    echo "Please Restart your terminal!"
fi            
	    break
            ;;
	   "Quit")
	    echo "User requested exit"
	    exit
	    ;;
        *) echo "invalid option $REPLY";;
    esac
done
