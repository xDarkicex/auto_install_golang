version="1.0.0"
go_version="1.7"
go_url_darwin="https://storage.googleapis.com/golang/go1.7.darwin-amd64.pkg"
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
function workspace_local() {
  echo "-----------------------------------------------------------------------------------------"
  echo "Where do you want your Go workspace path?
Options: [Desktop||Documents]"
    select opt in "${workspace[@]}"; do
      case $opt in
        "Desktop") echo "desktop stuff"
          username=""
          before_workspace=${PWD}
          PS3="github.com/"
          echo "enter github username"
            while true; do
              read -p ${PS3} username
              break
            done
          echo $username
          cd ~/Desktop &&
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
          echo "package main

import "fmt"

func main() {
    fmt.Printf("hello, world\n")
}" > main.go &&
          Path='$PATH'
          cd ~ &&
                  echo "export GOROOT=\"/usr/local/go\"
export GOPATH=\"$HOME/Desktop/goworkspace\"
export PATH=\"$HOME/Desktop/goworkspace/bin:$Path\"" >> .bash_profile &&
                  go env;
          cd ${before_workspace} &&
          break;;
        "Documents") echo "Documents stuff"
          username=""
          before_workspace=${PWD}
          PS3="github.com/"
          echo "enter github username"
            while true; do
              read -p ${PS3} username
              break
            done
          echo $username
          cd ~/Documents &&
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
          echo "package main

import "fmt"

func main() {
    fmt.Printf("hello, world\n")
}" > main.go &&
          Path='$PATH'
          cd ~ &&
          echo "export GOROOT=\"/usr/local/go\"
export GOPATH=\"$HOME/Documents/goworkspace\"
export PATH=\"$HOME/Documents/goworkspace/bin:$Path\"" >> .bash_profile &&
                  go env;
          cd ${before_workspace} &&
          break;;
        esac
      done

}


options=("Curl" "Wget")
workspace=("Desktop" "Documents")
PS3='Please enter your choice: '

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

echo "
          -------------------------------------------------------------
          #         *******     congratulations      *******
          #
          #         goLang Version $go_version darwin-amd64 installed!
          -------------------------------------------------------------
"
