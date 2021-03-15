Make functions

$1
$_
$?
$$ 
$# (process)
#@ (all arguments)

!!

|| (evaluate first argument)

$(pwd)

for file in "@#"; do
    grep 

grep project* (many char)
grep project? (1 char)

convert image.png image.jpg
equivalent to
convert image.{jpg,png}

touch test{1,2,3}.txt
touch test{1,2}/test{1,2,3}.txt

diff <(ls foo) <(ls bar)

> versus > versus 2>


first line to determine which software to run
#!/bin/bash 
#!/usr/bin/env python

to as to use 

./script.py
./script.sh

shellcheck script.sh

man mv

find . -path '**/test/*.py' -type f

locate conda

grep "word to check" <file-to-search>

>> /dev/null &
https://askubuntu.com/questions/12098/what-does-outputting-to-dev-null-accomplish-in-bash-scripts



sed -i s#IMAGE_HERE#gcr.io/$GOOGLE_CLOUD_PROJECT/valkyrie-app:v0.0.1#g k8s/deployment.yaml

history

history 1 | grep ls

fzf 
