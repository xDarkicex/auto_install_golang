#!/bin/bash
#Test files
# yell() { echo "$0: $*" >&2; }
# die() { yell "$*"; exit 111; }
# try() { "$@" || die "cannot $*"; }
os=$(uname -s)
#
# if [ -z $os ]; then die "system does not have uname installed"; fi
#
# # echo $os
# #


function oscheck() {
  case "$os" in
    Darwin )
      echo "I am Darwin put darwin curl here"
      ;;
    Linux )
      echo "I am Linux put linux curl here"
      ;;
    FreeBSD )
      echo "I am FreeBSD curl here"
      ;;
    *)
      echo "Unsupported OS"
  esac
}
function install() {
  echo "install go"
}
function update() {
  echo "Updating to current golang version ${urlgo}"
}

go_url=$(
curl -s https://golang.org/dl/ 2>&1 |
grep -Eoi '<a [^>]+>'               |
grep -Eo 'href="[^\"]+"'            |
grep -Eo 'https?://[^"]+'           |
grep -i ${os}                       |
sed -n 1p)
echo $os
echo $go_url
localgo=$(go version | grep -Eo '\d+?(\.\d+)+?');
urlgo=$(echo $go_url | grep -Eo '\d+?(\.\d+)+?');
echo $localgo
echo $urlgo
oscheck

go_exists=$(which go)
if [ -z "$go_exists" ]
 then
  install
elif [ "${localgo}" == "" ]
 then
  echo "You are on  the most current version of golang ${localgo}"
else
  update
fi


localgo=$(go version | grep -Eo '\d+?(\.\d+)+?');
go_version=$localgo
echo $go_version
