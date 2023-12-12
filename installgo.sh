#!/bin/bash

# Function for printing error messages
yell() {
  echo "$0: $*" >&2
}

# Function for displaying an error message and exiting
die() {
  yell "$*"
  exit 111
}

# Function for executing a command and handling errors
try() {
  "$@" || die "cannot $*"
}

# Function to get the operating system
get_os() {
  uname -s
}

# Function to check if uname is installed
check_uname() {
  local os
  os=$(get_os)
  if [ -z "$os" ]; then
    die "Panic system does not have uname installed"
  fi
}

# Function to print the script banner
print_banner() {
  local version="2.2.0"
  cat <<EOF
---------------------------------------------------------------------------------------------
#  Automated Golang installer                                                               #
#  ----------------------                                                                   #
#  | Version #$version     |                                                                   #
#  ----------------------                                                                   #
#  By: Gentry Rolofson                                                                      #
#  More info: https://bitdev.io                                                             #
#  Github: @xDarkicex                                                                       #
#                                                                                           #
---------------------------------------------------------------------------------------------
EOF
}

# Function to set up the workspace
workspace_setup() {
  local PS3="github.com/"
  local username

  echo "Enter GitHub username:"
  read -p ${PS3} username

  echo $username
  cd ~/$workspace_dir &&
    mkdir -p goworkspace/{bin,src,pkg}/github.com/"$username"/example &&
    # Make sample File
    cat <<EOF >main.go
package main

import "fmt"

func main() {
    fmt.Printf("hello, world\n")
}
EOF

  # Rest of the workspace setup...

  Path='$PATH'
  cd ~ &&
    echo "export GOROOT=\"/usr/local/go\"
export GOPATH=\"$HOME/${workspace_dir}/goworkspace/src/${username}\"
export PATH=\"$HOME/${workspace_dir}/goworkspace/bin:${Path}\"" >> .bash_profile &&
    go env
  cd ${local_dir}
}

# Function to set up the local workspace
workspace_local() {
  echo "-----------------------------------------------------------------------------------------"
  echo "Where do you want your Go workspace path? Options: [Desktop||Documents]"

  select opt in "${workspace[@]}"; do
    case $opt in
      "Desktop")
        username=""
        workspace_dir="Desktop"
        before_workspace=${PWD}
        workspace_setup
        break
        ;;
      "Documents")
        echo "Documents stuff"
        username=""
        workspace_dir="Documents"
        before_workspace=${PWD}
        workspace_setup
        break
        ;;
    esac
  done
}

# Function to install Go
install() {
  echo "Install Go"
  cd ~ &&
    current_dir=${PWD} &&
    echo "Do you want to use curl or wget? Options: [1||2]"
  select opt in "${options[@]}"; do
    case $opt in
      "Curl")
        cd ~ &&
          curl -# ${go_url} > $current_dir/golang.pkg &&
          try sudo installer -pkg $current_dir/golang.pkg -target / &&
          workspace_local
        break
        ;;
      "Wget")
        echo "Do you have wget installed? Options: [1||2]"
        select yn in "Yes" "No"; do
          case $yn in
            Yes)
              wget -P ${PWD} -O golang.pkg ${go_url} &&
                try sudo installer -pkg ${PWD}/golang.pkg -target / &&
                workspace_local
              break
              ;;
            No)
              echo "Homebrew required. Do you have Homebrew installed? Options: [1||2]"
              select yn in "Yes" "No"; do
                case $yn in
                  Yes)
                    try brew install wget &&
                      wget -P ${PWD} -O golang.pkg ${go_url} &&
                      try sudo installer -pkg ${PWD}/golang.pkg -target / &&
                      workspace_local
                    break
                    ;;
                  No)
                    try /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" &&
                      try brew install wget &&
                      wget -P ${PWD} -O golang.pkg ${go_url} &&
                      try sudo installer -pkg ${PWD}/golang.pkg -target / &&
                      workspace_local
                    break
                    ;;
                esac
              done
              break
              ;;
          esac
        done
        break
        ;;
    esac
  done
}

# Function to update Go
update() {
  echo "Updating to current golang version ${urlgo}"
  echo "Do you want to use curl or wget? Options: [1||2]"
  select opt in "${options[@]}"; do
    case $opt in
      "Curl")
        cd ~ &&
          current_dir=${PWD} &&
          curl -# ${go_url} > $current_dir/golang.pkg &&
          try sudo installer -pkg $current_dir/golang.pkg -target / &&
          cd $local_dir
        break
        ;;
      "Wget")
        cd ~ &&
          wget -P ${PWD} -O golang.pkg ${go_url} &&
          try sudo installer -pkg ${PWD}/golang.pkg -target / &&
          cd $local_dir
        break
        ;;
    esac
  done
}

# Main script

check_uname

# Set up panic err control will close setup
version="2.2.0"
options=("Curl" "Wget")
workspace=("Desktop" "Documents")

PS3='Please enter your choice: '

# Get installed version of go
localgo=$(go version | grep -Eo '\d+?(\.\d+)+?')
go_version=$localgo

# Get current version of golang download URL
go_url=$(
  curl -s https://golang.org/dl/ 2>&1 |
    grep -Eoi '<a [^>]+>' |
    grep -Eo 'href="[^\"]+"' |
    grep -Eo 'https?://[^"]+' |
    grep -i ${os} |
    sed -n 1p
)

# Log version
urlgo=$(echo $go_url | grep -Eo '\d+?(\.\d+)+?')
local_dir=${PWD}

print_banner

echo "Force update. Warning: Will put you on Edge Versions of go. Options: [1||2]"
force=("Yes" "No")
select opt in "${force[@]}"; do
  case $opt in
    "Yes") update ;;
    "No") break ;;
  esac
done

go_exists=$(which go)
if [ -z "$go_exists" ]; then
  install
elif [ "${localgo}" = "${urlgo}" ]; then
  echo "You are on the most current version of Go ${localgo}"
  go env

  cat <<EOF
          -------------------------------------------------------------
          #         *******     Congratulations      *******          #
          #                                                           #
          #         GoLang Version $go_version installed!              #  
          -------------------------------------------------------------
EOF
  exit 0
else
  exit 1
fi
