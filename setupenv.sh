#Run this to get up go env in bash test in mac OSX version 10.11.5 8/27/16
cd ~ &&
echo 'export GOROOT="/usr/local/go"
export GOPATH="$HOME/Desktop/goworkspace"
export PATH="$HOME/Desktop/goworkspace/bin:$PATH"' >> .bash_profile &&

go env;
