#!/usr/bin/env bash
#encoding=utf8

function echo_block() {
    echo "----------------------------"
    echo $1
    echo "----------------------------"
}

function check_installed_pip() {
   ${PYTHON} -m pip > /dev/null
   if [ $? -ne 0 ]; then
        echo_block "Installing Pip for ${PYTHON}"
        curl https://bootstrap.pypa.io/get-pip.py -s -o get-pip.py
        ${PYTHON} get-pip.py
        rm get-pip.py
   fi
}

# Check which python version is installed
function check_installed_python() {
    if [ -n "${VIRTUAL_ENV}" ]; then
        echo "Please deactivate your virtual environment before running setup.sh."
        echo "You can do this by running 'deactivate'."
        exit 2
    fi

    for v in 12 11 10
    do
        PYTHON="python3.${v}"
        which $PYTHON
        if [ $? -eq 0 ]; then
            echo "using ${PYTHON}"
            check_installed_pip
            return
        fi
    done

    echo "No usable python found. Please make sure to have python3.10 or newer installed."
    exit 1
}

function update_env() {
    echo_block "Updating your virtual environment"
    if [ ! -f .venv/bin/activate ]; then
        echo "Something went wrong, no virtual environment found."
        exit 1
    fi
    source .venv/bin/activate
    SYS_ARCH=$(uname -m)
    echo "pip install in-progress. Please wait..."
    ${PYTHON} -m pip install --upgrade pip wheel setuptools
    REQUIREMENTS=requirements.txt

    read -p "Do you want to install dependencies for development (Performs a full install with all dependencies) [y/N]? "
    dev=$REPLY
    if [[ $REPLY =~ ^[Yy]$ ]]
        REQUIREMENTS=requirements-dev.txt
    fi

    ${PYTHON} -m pip install --upgrade -r ${REQUIREMENTS}
    if [ $? -ne 0 ]; then
        echo "Failed installing dependencies"
        exit 1
    fi
    ${PYTHON} -m pip install -e .
    if [ $? -ne 0 ]; then
        echo "Failed installing PySATL Experiment"
        exit 1
    fi

    echo "pip install completed"
    echo
    if [[ $dev =~ ^[Yy]$ ]]; then
        ${PYTHON} -m pre_commit install
        if [ $? -ne 0 ]; then
            echo "Failed installing pre-commit"
            exit 1
        fi
    fi
}


# Install bot MacOS
function install_macos() {
    if [ ! -x "$(command -v brew)" ]
    then
        echo_block "Installing Brew"
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    brew install gettext libomp

    #Gets number after decimal in python version
    version=$(egrep -o 3.\[0-9\]+ <<< $PYTHON | sed 's/3.//g')
}

# Install Debian_ubuntu
function install_debian() {
    sudo apt-get update
    sudo apt-get install -y gcc build-essential autoconf libtool pkg-config make wget git curl $(echo lib${PYTHON}-dev ${PYTHON}-venv)
}

# Install RedHat_CentOS
function install_redhat() {
    sudo yum update
    sudo yum install -y gcc gcc-c++ make autoconf libtool pkg-config wget git $(echo ${PYTHON}-devel | sed 's/\.//g')
}

# Upgrade the
function update() {
    git pull
    if [ -f .env/bin/activate  ]; then
        # Old environment found - updating to new environment.
        recreate_environments
    fi
    update_env
    echo "Update completed."
    echo_block "Don't forget to activate your virtual environment with 'source .venv/bin/activate'!"

}

function check_git_changes() {
    if [ -z "$(git status --porcelain)" ]; then
        echo "No changes in git directory"
        return 1
    else
        echo "Changes in git directory"
        return 0
    fi
}

function recreate_environments() {
    if [ -d ".env" ]; then
        # Remove old virtual env
        echo "- Deleting your previous virtual env"
        echo "Warning: Your new environment will be at .venv!"
        rm -rf .env
    fi
    if [ -d ".venv" ]; then
        echo "- Deleting your previous virtual env"
        rm -rf .venv
    fi

    echo
    ${PYTHON} -m venv .venv
    if [ $? -ne 0 ]; then
        echo "Could not create virtual environment. Leaving now"
        exit 1
    fi

}

# Reset Develop or Stable branch
function reset() {
    echo_block "Resetting branch and virtual env"

    if [ "1" == $(git branch -vv |grep -cE "\* develop|\* stable") ]
    then
        if check_git_changes; then
            read -p "Keep your local changes? (Otherwise will remove all changes you made!) [Y/n]? "
            if [[ $REPLY =~ ^[Nn]$ ]]; then

                git fetch -a

                if [ "1" == $(git branch -vv | grep -c "* develop") ]
                then
                    echo "- Hard resetting of 'develop' branch."
                    git reset --hard origin/develop
                elif [ "1" == $(git branch -vv | grep -c "* stable") ]
                then
                    echo "- Hard resetting of 'stable' branch."
                    git reset --hard origin/stable
                fi
            fi
        fi
    else
        echo "Reset ignored because you are not on 'stable' or 'develop'."
    fi
    recreate_environments

    update_env
}

function config() {
    echo_block "Please use 'pysatl-experiment new-config -c user_data/config.json' to generate a new configuration file."
}

function install() {

    echo_block "Installing mandatory dependencies"

    if [ "$(uname -s)" == "Darwin" ]; then
        echo "macOS detected. Setup for this system in-progress"
        install_macos
    elif [ -x "$(command -v apt-get)" ]; then
        echo "Debian/Ubuntu detected. Setup for this system in-progress"
        install_debian
    elif [ -x "$(command -v yum)" ]; then
        echo "Red Hat/CentOS detected. Setup for this system in-progress"
        install_redhat
    else
        echo "This script does not support your OS."
        echo "If you have Python version 3.10 - 3.12, pip, virtualenv, ta-lib you can continue."
        echo "Wait 10 seconds to continue the next install steps or use ctrl+c to interrupt this shell."
        sleep 10
    fi
    echo
    reset
    config
    echo_block "Run the bot !"
    echo "You can now use the bot by executing 'source .venv/bin/activate; pysatl-experiment <subcommand>'."
    echo "You can see the list of available bot sub-commands by executing 'source .venv/bin/activate; pysatl-experiment --help'."
    echo "You verify that pysatl-experiment is installed successfully by running 'source .venv/bin/activate; pysatl-experiment --version'."
}

function plot() {
    echo_block "Installing dependencies for Plotting scripts"
    ${PYTHON} -m pip install plotly --upgrade
}

function help() {
    echo "usage:"
    echo "	-i,--install    Install pysatl-experiment from scratch"
    echo "	-u,--update     Command git pull to update."
    echo "	-r,--reset      Hard reset your develop/stable branch."
    echo "	-c,--config     Easy config generator (Will override your existing file)."
}

# Verify if 3.10+ is installed
check_installed_python

case $* in
--install|-i)
install
;;
--config|-c)
config
;;
--update|-u)
update
;;
--reset|-r)
reset
;;
*)
help
;;
esac
exit 0
