echo "
---------------------------------------------------------------------------------------------
#
#  Step one: build function
#  Build function, if you do not have brew this will install brew.
#  Do you have brew installed? if you do have brew then run build yes; else run build.
#  Step two: goenv function
#  The goenv function will setup our go path at either Desktop or Documents
#  goenv takes two arguments Desktop of Documents
---------------------------------------------------------------------------------------------"
#I know they will really take infinie arguments this is bata.

while true
  do
    read -e -n 1 -p "Press Yes to install Golang [y/N] " RESP
    case $RESP in
    [yY])
    build
  break
  ;;
[nN]|"")

  break
  ;;
esac
done

function build() {
  brew='$1'

  cd ~ &&
  current_dir=${PWD} &&
  while true
    do
      read -e -n 1 -p "Do you have brew? [y/N] " RESP
      case $RESP in
      [yY])
    echo "Good Brew is required for this automated installation, plus its awesome."
    break
    ;;
  [nN]|"")
      /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    break
    ;;
  esac
done
  brew install wget &&
  wget -P ${PWD} -O golang.pkg https://storage.googleapis.com/golang/go1.7.darwin-amd64.pkg &&
  sudo installer -pkg ${PWD}/golang.pkg -target /
  while true
    do
      read -e -n 1 -p "Where do you want your Go workspace path? [Desktop/No] " RESP
      case $RESP in
      [Desktop])
          # env_root_dir=$1
          current_dir=${PWD}
          Path='$PATH'
          cd ~ &&
          # cd ${env_root_dir} &&
          echo "export GOROOT=\"/usr/local/go\"
        export GOPATH=\"$HOME/Desktop/goworkspace\"
        export PATH=\"$HOME/Desktop/goworkspace/bin:$Path\"" >> .bash_profile &&


          go env;
          cd $current_dir
    break
    ;;
  [nN]|"")
        # env_root_dir=$1
        current_dir=${PWD}
        Path='$PATH'
        cd ~ &&
        # cd ${env_root_dir} &&
        echo "
  export GOROOT=\"/usr/local/go\"
  export GOPATH=\"$HOME/Documents/goworkspace\"
  export PATH=\"$HOME/Documents/goworkspace/bin:$Path\"" >> .bash_profile &&


        go env;
        cd $current_dir
    break
    ;;
  esac
done
echo "
-------------------------------------------------------------
#         *******     congratulations      *******
#
#         goLang Version 1.7 darwin-amd64 installed!
-------------------------------------------------------------
"
}

function goenv() {
  env_root_dir=$1
  current_dir=${PWD}
  Path='$PATH'
  cd ~ &&
  # cd ${env_root_dir} &&
  echo "export GOROOT=\"/usr/local/go\"
export GOPATH=\"$HOME/${env_root_dir}/goworkspace\"
export PATH=\"$HOME/${env_root_dir}/goworkspace/bin:$Path\"" >> .bash_profile &&


  go env;
  cd $current_dir
}
