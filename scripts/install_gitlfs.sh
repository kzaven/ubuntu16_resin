#!/bin/bash
cd /tmp/
wget -O go-linux-arm64-bootstrap.tbz "https://www.dropbox.com/s/vqe68zvwiwzhbj2/go-linux-arm64-bootstrap.tbz?dl=0"
tar -xf go-linux-arm64-bootstrap.tbz
export PATH=:$PWD/go-linux-arm64-bootstrap/bin:$PATH
mkdir /tmp/gocode
export GOPATH=/tmp/gocode
go get github.com/github/git-lfs
cp /tmp/gocode/bin/git-lfs /usr/bin/
