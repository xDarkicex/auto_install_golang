# TESTING IF UNAME EXISTS
yell() { echo "$0: $*" >&2; }
die() { yell "$*"; exit 111; }
try() { "$@" || die "cannot $*"; }
os=$(uname -s)
# setup panic err control will close setup
if [ -z $os ]; then die "Panic system does not have uname installed"; fi
version="2.0.0"
options=("Curl" "Wget")
workspace=("Desktop" "Documents")
PS3='Please enter your choice: '
#get installed version of go
localgo=$(go version | grep -Eo '\d+?(\.\d+)+?');
go_version=$localgo
#get current version of golang download url
go_url=$(
curl -s https://golang.org/dl/ 2>&1 |
grep -Eoi '<a [^>]+>'               |
grep -Eo 'href="[^\"]+"'            |
grep -Eo 'https?://[^"]+'           |
grep -i ${os}                       |
sed -n 1p)
# log version
urlgo=$(echo $go_url | grep -Eo '\d+?(\.\d+)+?');
local_dir=${PWD}
echo "
---------------------------------------------------------------------------------------------
#  Automated Golang installer
#  ----------------------
#  | Version #$version     |
#  ----------------------
#  By: Gentry Rolofson
#  More info: https://bitdev.io
#  Github: @xDarkicex
#
---------------------------------------------------------------------------------------------
"

#DRY THAT CODE
function workspace_setup() {
  PS3="github.com/"
  echo "enter github username"
    while true; do
      read -p ${PS3} username
      break
    done
  echo $username
  cd ~/$workspace_dir &&
  mkdir goworkspace &&
  cd goworkspace &&
  mkdir bin &&
  mkdir src &&
  mkdir pkg &&
  cd src &&
  mkdir github.com &&
  cd github.com &&
  mkdir $username &&
  cd $username &&
  mkdir example &&
  cd example &&
# Make sample File
  echo "package main

import \"fmt\"

func main() {
fmt.Printf(\"hello, world\n\")
}" > main.go &&
#end sample files
  Path='$PATH'
  cd ~ &&
          echo "export GOROOT=\"/usr/local/go\"
export GOPATH=\"$HOME/${workspace_dir}/goworkspace\"
export PATH=\"$HOME/${workspace_dir}/goworkspace/bin:$Path\"" >> .bash_profile &&
          go env;
  cd ${local_dir}
}
function workspace_local() {
  echo "-----------------------------------------------------------------------------------------"
  echo "Where do you want your Go workspace path?
Options: [Desktop||Documents]"
    select opt in "${workspace[@]}"; do
      case $opt in
        "Desktop")
          username=""
          workspace_dir="Desktop"
          before_workspace=${PWD}
          workspace_setup
            break;;
        "Documents") echo "Documents stuff"
          username=""
          workspace_dir="Documents"
          before_workspace=${PWD}
          workspace_setup
            break;;
        esac
      done

}

function install() {
  echo "install go"

  cd ~ &&
  current_dir=${PWD} &&
  # echo $local_dir
  echo "Do you want to use curl or wget?
  Options: [1||2]"
  select opt in "${options[@]}"; do
      case $opt in
          "Curl") cd ~ && curl -# ${go_url} > $current_dir/golang.pkg &&
            sudo installer -pkg ${current_dir}/golang.pkg -target / &&
            workspace_local
            echo "-----------------------------------------------------------------------------------------"
            break;;
          "Wget") echo "Do you have wget installed?
  Options: [1||2]"
                select yn in "Yes" "No"; do
                  case $yn in
                    Yes )
                    wget -P ${PWD} -O golang.pkg ${go_url} &&
                    sudo installer -pkg ${PWD}/golang.pkg -target / &&
                    workspace_local
                    echo "-----------------------------------------------------------------------------------------"
                    break;;
                    No ) echo "homebrew required, do you have homebrew installed if unsure select no?
  Options: [1||2]"
                      select yn in "Yes" "No"; do
                        case $yn in
                          # This means that you have homebrew but not wget
                          Yes ) brew install wget &&
                          wget -P ${PWD} -O golang.pkg ${go_url} &&
                          sudo installer -pkg ${PWD}/golang.pkg -target / &&
                          workspace_local
                          echo "-----------------------------------------------------------------------------------------"
                          break;;
                          # This means that you do not have homebrew!!!
                          No )     /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" &&
                          brew install wget &&
                          wget -P ${PWD} -O golang.pkg ${go_url} &&
                          sudo installer -pkg ${PWD}/golang.pkg -target / &&
                          workspace_local
                          echo "-----------------------------------------------------------------------------------------"
                          break;;
                        esac
                      done
                      break;;
                    esac
                  done
           break;;
      esac
  done
}
function update() {
  echo "Updating to current golang version ${urlgo}"
  echo "Do you want to use curl or wget?
  Options: [1||2]"
  select opt in "${options[@]}"; do
      case $opt in
          "Curl")
          cd ~ &&
          current_dir=${PWD}
          curl -# ${go_url} > $current_dir/golang.pkg &&
            sudo installer -pkg ${current_dir}/golang.pkg -target / &&
            cd $local_dir
            echo "-----------------------------------------------------------------------------------------"
          break;;
          "Wget")
          cd ~ &&
          wget -P ${PWD} -O golang.pkg ${go_url} &&
          sudo installer -pkg ${PWD}/golang.pkg -target / &&
          cd $local_dir
          echo "-----------------------------------------------------------------------------------------"
        break;;
      esac
    done
}
echo "Force Update 
Options: [1||2]"
force=("Yes" "No")
    select opt in "${force[@]}"; do
      case $opt in 
        "Yes")
        install
        break
          ;;
        "No")
       break
         ;;
    esac
  done
go_exists=$(which go)
if [ -z "$go_exists" ]
 then
  install
elif [ "${localgo}" == "${urlgo}" ]
 then
  echo "You are on  the most current version of golang ${localgo}"

else
  update
fi

go env
echo "
          -------------------------------------------------------------
          #         *******     congratulations      *******
          #
          #         goLang Version $go_version $os installed!
          -------------------------------------------------------------
"
