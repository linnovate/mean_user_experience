#!/usr/bin/env bash
set -u
export dir_root=$(cd `basename $0`;echo $PWD)

set_env(){
export file_cfg=$dir_root/test/sh/config.cfg
export file_capture=$dir_root/test/sh/capture.sh
export address=0

if [ "$LOGNAME" = travis ];then
  address='0.0.0.0:3000'
else
  address='0.0.0.0:3000'
fi

test -f $file_capture
test -f $file_cfg

chmod +x $file_capture
source $file_cfg
}



grunt_stuff(){
commander cat Gruntfile.js
commander grunt test || { exit 1; }
trace 'Running grunt now ..';
commander grunt &
}


install_pre(){
sudo apt-get install -y -q curl 
npm install -g bower grunt grunt-cli mean-cli
}

user_instructions(){
commander npm install -g
commander npm link
commander env
commander mean status
commander grunt_stuff
}

test_navigation(){
while true; do  commander curl $address 2>/dev/null && break ; sleep 1 ; done
}

test_mean_init(){
cd $dir_root
echo -e '\n' |  mean init myApp
cd $dir_root/myApp
user_instructions
test_navigation
cd $dir_root
}

tests(){
#test_self
install_pre
test_mean_init
}

navigation(){
( bash -c $file_capture )
}

steps(){
set_env
tests
navigation
}

steps
