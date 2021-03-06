#!/usr/bin/env bash
#
# Jus de Patate <yaume@ntymail.com>
# First release :       2018.11.10-01
               VERSION="2019.02.18-01"
#                       yyyy.mm.dd
#
# info.sh is a little script that works like `neofetch` or `screenfetch`
# it shows infos and was originally made for Termux (Linux on Android)
# but it was tested on Ubuntu, GhostBSD, Termux, iSH, macOS and Fedora
#
# License : BSD-3-CLAUSE "Jus de Patate, 2018-2019"
#
# Arguments :
# --update : update info.sh
# --update-rewrite : update info.sh & use rewrite instead of original info.sh
# -v : output version of info.sh
# --upload : upload output to transfer.sh (without public IPs)

if [ "$(which tput 2>/dev/null)" ]; then
    BOLD=$(tput bold)
    NORMAL=$(tput sgr0)
    UNDER=$(tput smul)
    GREY=$(tput setab 0 && tput setaf 0)
    RED=$(tput setab 1 && tput setaf 1)
    GREEN=$(tput setab 2 && tput setaf 2)
    YELLOW=$(tput setab 3 && tput setaf 3)
    BLUE=$(tput setab 4 && tput setaf 4)
    MAG=$(tput setab 5 && tput setaf 5)
    CYAN=$(tput setab 6 && tput setaf 6)
    WHITE=$(tput setab 7 && tput setaf 7)
else
    BOLD="\e[1m"
    NORMAL="\e[0m"
    UNDER="\e[4m"
    GREY="\e[30;40m"
    RED="\e[31;41m"
    GREEN="\e[32;42m"
    YELLOW="\e[33;43m"
    BLUE="\e[34;44m"
    MAG="\e[35;45m"
    CYAN="\e[36;46m"
    WHITE="\e[97;107m"
fi

if [ "$(which curl 2>/dev/null)" ]; then
    # if curl is installed, then
        REQMNGR="curl -s --max-time 10"
        # use curl as request manager
    DWNMNGR="curl -s --max-time 10 -LO"
        # use curl to download update
        UPMNGR="curl --upload-file"
elif [ "$(which wget 2>/dev/null)" ]; then
    # if wget is installed, then
        REQMNGR="wget -qO- --timeout=10"
        # use wget as request manager
        DWNMNGR="wget -q --timeout=10"
        # use wget to download update
        if [ "$1" = "--upload" ]; then
                echo "wget isn't supported for upload"
                echo "please install curl"
                exit 1
        fi
else
# if curl and wget aren't installed, then
        echo "Please install curl or wget"
        # error message
        exit 1
        # stop program (with an error)
fi
# end of if

if [ "$1" = "--update" ]; then
# if user wants to update
    $DWNMNGR "https://raw.githubusercontent.com/jusdepatate/info.sh/master/info.sh"
    # download new version
    echo -e "Update done,\n$(chmod +x info.sh &>/dev/null && bash info.sh -v) was downloaded"
    # output new version
    exit 0
    # stop program
elif [ "$1" = "--update-rewrite" ]; then
# if user wants to update
    $DWNMNGR "https://raw.githubusercontent.com/jusdepatate/info.sh/master/info_rewrite.sh"
    # download new version
    echo -e "Update done,\n$(chmod +x info_rewrite.sh &>/dev/null && bash info_rewrite.sh -v) was downloaded"
    echo -e "Now the name of of the executable of info.sh is info_rewrite.sh"
    # output new version
    exit 0
    # stop program
elif [ "$1" = "-v" ]; then
# if user wants to see version installed
        echo "info.sh $VERSION"
        # output version
        exit 0
        # stop program
fi
# end of argument detection

OS="$(uname -o 2>/dev/null)"
KERNEL="$(uname -sr)"
USER="$(whoami)"
HOSTNAME="$(hostname)"
FIRST="${BOLD}$USER${NORMAL}@${BOLD}"
BONUS1=""
# set up basic variables

banner() {
    msg="# $* #"
    edge=$(echo "$msg" | sed 's/./#/g')
    echo "$edge"
    echo "$msg"
    echo "$edge"
}
# https://unix.stackexchange.com/a/250094

if [ "$OS" = "Android" ];then
    # If user's os is Android (Termux)
    # --- FOR ANDROID (Termux) ---
    ISPNAME="$(getprop gsm.sim.operator.alpha)"
    # set variable ISPNAME to the output of command 'getprop gsm.sim.operator.alpha', it's output is the operator name of the user (getprop is very useful on Termux)
    ISPCOUNTRY="$(getprop gsm.operator.iso-country)"
    # set variable ISPCOUNTRY to the output of command 'getprop gsm.operator.iso-country', it's output is the iso code of the user's operator
    ANDVERSION="$(getprop ro.build.version.release)"
    # set variable ANDVERSION to the output of command 'uname -r', it's output is the version of Android

    FIRST+="$(getprop ro.product.manufacturer)"
    # add to the variable FIRST (first line of output) the output of command 'getprop ro.product.manufacturer', it's output is the user's phone manufacturer (Huawei, Samsung, ...)
    FIRST+=" $(getprop ro.product.model)${NORMAL} (${BOLD}$(getprop ro.config.marketing_name)${NORMAL})"
	# add to the variable FIRST the output of command 'getprop ro.product.model', it's output is the user's phone model

    SECOND="${BOLD}$OS"
    # set variable SECOND (second line of output) to the output of variable OS (Android in every case in this if)
    SECOND+=" $ANDVERSION${NORMAL}"
    # add to the variable SECOND the variable ANDVERSION
    SECOND+=" (${BOLD}$KERNELNAME $KERNEL${NORMAL})"
    # add to the variable SECOND the variable KERNELNAME and KERNEL

    BONUS1="Mobile ISP : ${BOLD}$ISPNAME${NORMAL} (${BOLD}$ISPCOUNTRY${NORMAL})"
    # set variable BONUS1 to "Mobile ISP : " and variable ISPNAME and ISPCOUNTRY
else
    # else :troll:
    # --- FOR ANYTHING ELSE ---
    FIRST+="$HOSTNAME${NORMAL}"
    # add to variable FIRST the output of command 'hostname' (machine name)
    PRDCT="$(cat /sys/devices/virtual/dmi/id/product_name 2>/dev/null)"
    if [ "$PRDCT" = "" ]; then
                b=b
                else
                if [ "$PRDCT" = "System Product Name" ]; then
       a=a
                else
                                FIRST+=" (${BOLD}$(cat /sys/devices/virtual/dmi/id/product_name)${NORMAL})"
    fi
          fi
    case "$OSTYPE" in
        # if env variable OSTYPE is equal to
        solaris*) OS="${BOLD}Solaris${NORMAL}" ;;
        # solaris* then set variable OS to "Solaris"
        darwin*)  OS="${BOLD}$(sw_vers -productName) $(sw_vers -productVersion)${NORMAL}" ;;
        # darwin* then set variable OS to "Mac OS X"
        linux-android*) OS="${BOLD}Android${NORMAL}" ;;
        # linux-android* set variable OS to "Android"
        linux*)   OS="${BOLD}GNU/Linux${NORMAL}" ;;
        # linux* then set variable OS to "GNU/Linux"
        gnu*) OS="${BOLD}GNU/Linux${NORMAL}" ;;
        # gnu* set variable OS to "GNU/Linux"
        dragonfly*)     OS="${BOLD}DragonFlyBSD $(uname -r | grep -o '[0-9]*\.[0-9]')${NORMAL}" ;;
        # dragonfly* then set variable OS to "DragonFlyBSD" and version
        FreeBSD*)     OS="${BOLD}FreeBSD $(uname -r | grep -o '[0-9]*\.[0-9]')${NORMAL}" ;;
        # FreeBSD* then set variable OS to "FreeBSD" and version
        netbsd*)     OS="${BOLD}NetBSD $(uname -r | grep -o '[0-9]*\.[0-9]')${NORMAL}" ;;
        # netbsd* then set variable OS to "netbsd" and version
        bsd*)     OS="${BOLD}BSD* $(uname -r | grep -o '[0-9]*\.[0-9]')${NORMAL}" ;;
        # bsd* then set variable OS to "BSD*" and version
        *bsd)  OS="${BOLD}*BSD $(uname -r | grep -o '[0-9]*\.[0-9]')${NORMAL}" ;;
        # FreeBSD then set variable OS to "*BSD" and version
        msys*)    OS="${BOLD}Windows${NORMAL}" ;;
        # msys* then set variable OS to "Windows" (not sure this can happen)
        cygwin*)  OS="${BOLD}Windows${NORMAL}" ;;
        # cygwin* then set variable OS to "Windows"
        haiku*) OS="${BOLD}Haiku${NORMAL}" ;;
        # haiku* then set variable OS to "Haiku"
        *)        OS="${BOLD}$OSTYPE${NORMAL}" ;;
        # anything else then set varible OS to env var OSTYPE
    esac
    # https://stackoverflow.com/a/18434831
    # end of case
    if [ "$OS" = "${BOLD}GNU/Linux${NORMAL}" ]; then
        # if variable OS is equal to GNU/Linux (+ formatting
        if [ $(which yum 2>/dev/null) ]; then
            # and if which yum is true (package exist)
            source /etc/os-release
            OS="${BOLD}$PRETTY_NAME${NORMAL}"
            # set variable OS to PRETTY_NAME
        elif [ $(which apt 2>/dev/null) ]; then
            # or if which apt is true (package exist)
            source /etc/os-release
            # take variables from /etc/os-release
            OS="${BOLD}$PRETTY_NAME${NORMAL}"
            # set variable OS to PRETTY_NAME
        elif [ $(which apk 2>/dev/null) ]; then
            # or if which apk is positive (package exists)
            source /etc/os-release
            # get variables from /etc/os-release
            OS="${BOLD}$PRETTY_NAME${NORMAL}"
            # set variable OS to the variable PRETTY_NAME of /etc/os_release
                  if [ "$(uname -r | grep 'ish')" ]; then OS="${BOLD}iOS/$PRETTY_NAME${NORMAL}"; fi
        elif [ $(which pacman 2>/dev/null) ]; then
            # or if which pacman is positive (package exists)
            source /etc/os-release
            # get vars from /etc/os-release
            OS="${BOLD}$PRETTY_NAME${NORMAL}"
            # set variable Os to the variable PRETTY_NAME of /etc/os_release
        elif [ $(which cards 2>/dev/null) ]; then
            # or if which cards is positive (package exists)
            source /etc/lsb-release
            # get vars from /etc/lsb-release
            OS="${BOLD}$DISTRIB_ID $DISTRIB_RELEASE ($DISTRIB_CODENAME)${NORMAL}"
        fi
        # end of if
    fi
    # end of if
    SECOND="${BOLD}$OS${NORMAL}"
    # set variable SECOND (second line of output) to variable OS
    SECOND+=" (${UNDER}$KERNEL${NORMAL})"
    # add to variable SECOND the variable KERNELNAME and KERNEL
fi
# end of if

PACKAGES="Packages: "
if [ "$(which dpkg 2>/dev/null)" ]; then
    DPKGS="$(dpkg --get-selections | grep -c 'install')"
    PACKAGES+="${BOLD}$DPKGS${NORMAL} (dpkg) "
fi
if [ "$(which apt 2>/dev/null)" ]; then
    APTS="$(apt list 2>/dev/null | grep -v 'Listing...' | grep 'installed' | wc -l)"
    PACKAGES+="${BOLD}$APTS${NORMAL} (apt) "
fi
if [ "$(which apk 2>/dev/null)" ]; then
    APKS="$(apk list 2>/dev/null | grep -c 'installed')"
    PACKAGES+="${BOLD}$APKS${NORMAL} (apk) "
fi
if [ "$(which pacman 2>/dev/null)" ]; then
        PACMANS="$(pacman -Q 2>/dev/null | wc -l)"
        PACKAGES+="${BOLD}$PACMANS${NORMAL} (pacman) "
fi
if [ "$(which flatpak 2>/dev/null)" ]; then
        FLATPAKS="$(flatpak list 2>/dev/null | wc -l)"
        PACKAGES+="${BOLD}$FLATPAKS${NORMAL} (flatpak) "
fi
if [ "$(which getprop 2>/dev/null && $OS = 'Android' 2>/dev/null)" ]; then
    PKGS="$(pkg list-all 2>/dev/null | grep -c 'installed')"
    PACKAGES+="${BOLD}$PKGS${NORMAL} (pkg) "
fi
if [ "$(which pip2 2>/dev/null)" ]; then
	    PIP2S="$(pip2 list --format=columns 2>/dev/null | grep -v 'Package ' | grep -v '\-\-\-\-\-\-\-' | wc -l)"
        PACKAGES+="${BOLD}$PIP2S${NORMAL} (pip2) "
fi
if [ "$(which pip3 2>/dev/null)" ]; then
		PIP3S="$(pip3 list 2>/dev/null | grep -v 'Package ' | grep -v '\-\-\-\-\-\-\-' | wc -l)"
		PACKAGES+="${BOLD}$PIP3S${NORMAL} (pip3) "
fi
if [ "$(which yarn 2>/dev/null)" ]; then
        YARNS="$(yarn global list | grep -v 'has binaries' | grep -v 'yarn global v' | grep -v 'Done in' | wc -l)"
        PACKAGES+="${BOLD}$YARNS${NORMAL} (yarn) "
fi
if [ "$(which npm 2>/dev/null)" ]; then
        NPMS="$(yarn global list | grep -v 'has binaries' | grep -v 'yarn global v' | grep -v 'Done in' | wc -l)"
        PACKAGES+="${BOLD}$NPMS${NORMAL} (npm) "
fi
if [ "$(which brew 2>/dev/null)" ]; then
        BREWS="$(brew list | wc -l)"
		PACKAGES+="${BOLD}$BREW${NORMAL} (brew) "
fi

THIRD="Arch: ${BOLD}$(uname -m)${NORMAL}"
# set variable THIRD to architecture (using uname)

FOURTH="Shell:"
# set variable FOURTH to "Shell:"
if [ $(echo $SHELL | grep "zsh") ]; then
    # if env var SHELL contains "zsh"
    SH="$(zsh --version | grep -o 'zsh [0-9]\.[0-9]\.[0-9]')"
    # set SH variable to output of "zsh --version" (modified using grep)
    FOURTH+=" ${BOLD}$SH${NORMAL}"
    # add to variable FOURTH variable SH
elif [ $(echo $SHELL | grep "bash") ]; then
    # or if env var contains bash
    SH="$(bash --version | head -1 | cut -d ' ' -f 4)"
    # set SH variable to output of "bash --version" (modified using head and cut)
    # https://askubuntu.com/a/1008422
    FOURTH+=" ${BOLD}bash $SH${NORMAL}"
    # add to variable FOURTH "bash" and variable SH
elif [ $(echo $SHELL | grep "csh") ]; then
    # or if env var contains csh
    SH="$(csh --version | grep -o 'csh [0-9]*\.[0-9]*\.[0-9]')"
    FOURTH+=" ${BOLD}$SH${NORMAL}"
elif [ $(echo $SHELL | grep "/bin/sh") ]; then
    # or if env var contains /bin/sh
    FOURTH+=" ${BOLD}sh${NORMAL}"
    # add to variable FOURTH "sh"
else
    # if shell isn't one listed above
    FOURTH+=" $SHELL"
    # add to variable FOURTH the variable SHELL
fi

FIFTH="Public IP(v4): "

if [ "$($REQMNGR https://check.torproject.org/api/ip | grep 'true')" ]; then
        FIFTH="Tor IP(v4): "
fi

if [ "$($REQMNGR https://v4.ident.me)" ]; then
    # set variable FIFTH "Public IP(v4): "
    FIFTH+=" ${BOLD}$($REQMNGR https://v4.ident.me)${NORMAL}"
    # connect to v4.ident.me with timeout of 10 seconds and put output into variable FIFTH
        FIFTH+=" (${BOLD}$($REQMNGR ifconfig.io/country_code) - $($REQMNGR ipinfo.io/org | awk '{print $1}') - $($REQMNGR ipinfo.io/org | cut -d' ' -f2-)${NORMAL})"
    # connect to ifconfig.io/country_code with timeout of 10 seconds and put output into variable FIFTH
else
    FIFTH=" Unable to connect to v4.ident.me (?)"
fi
if [ "$($REQMNGR https://v6.ident.me/)" ]; then
    # if i can connect to v6.ident.me with 10s of timeout (it means that user has an IPv6)
    FIFTH+="\nPublic IP(v6):"

        if [ "$($REQMNGR https://check.torproject.org/api/ip | grep 'true')" ]; then
                FIFTH="\nTor IP(v6):"
        fi
        FIFTH+=" ${BOLD}$($REQMNGR https://v6.ident.me/)${NORMAL} (${BOLD}$($REQMNGR ifconfig.io/country_code) - $($REQMNGR ipinfo.io/org | awk '{print $1}') - $($REQMNGR ipinfo.io/org | cut -d' ' -f2-)${NORMAL})"
    # add a line to variable FIFTH containing result of v6.ident.me and ifconfig.io with 10s of timeout for both
fi

SIXTH="Local IP: "
# set variable SIXTH to "Local IP: "

if [ "$(hostname -I 2>/dev/null)" ]; then
    SIXTH+="${BOLD}$(hostname -I)${NORMAL}"
elif [ "$(which ifconfig 2>/dev/null)" ]; then
    SIXTH+="${BOLD}$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')${NORMAL}"
else
    SIXTH+="Unable to get local IP"
fi
# --- ECHO ---

if [ "$1" = "--upload" ]; then
        echo -e "$(banner $(date '+%A %d %B, %Y'))\n$FIRST\n$SECOND\n$THIRD\n$PACKAGES\n$FOURTH\nPublic IP(vX): Not shown\n$SIXTH\n$BONUS1\n\ninfo.sh $VERSION\nhttps://github.com/jusdepatate/info.sh" > info.sh.log
        $UPMNGR info.sh.log https://transfer.sh/
        rm -f info.sh.log
        exit
fi

banner $(date "+%A %d %B, %Y")
# add a banner with the date
echo
# new line

echo -e $FIRST
# -e because it supports \n, bold, ...
# First : user@host (or phone man + phone mod)

echo -e $SECOND
# Second : OS

echo -e $THIRD
# Third : Arch

if [ -n "$PACKAGES" ]; then
    echo -e $PACKAGES
    # New line : Number of pkgs
fi

echo -e $FOURTH
# Fourth : Shell + version (only for bash and zsh)

echo -e $FIFTH
# Fifth : Public IP

echo -e $SIXTH
# Sixth : Local IP

if [ -n "$BONUS1" ]; then
    echo -e $BONUS1
    # Mobile operator
fi

echo
echo -e " ${GREY}██${NORMAL}${RED}██${NORMAL}${GREEN}██${NORMAL}${YELLOW}██${NORMAL}${BLUE}██${NORMAL}${MAG}██${NORMAL}${CYAN}██${NORMAL}${WHITE}██${NORMAL}"

echo
echo "Report any errors here :"
echo "https://github.com/jusdepatate/info.sh"

# vim: ft=sh ts=4 sw=4 sts=4
