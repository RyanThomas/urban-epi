echo 'export PATH=$HOME/.npm-packages/bin:$PATH' >> ~/.bashrc
. ~/.bashrc
#mkdir -p ~/bin
mkdir ~/node-latest-install
cd ~/node-latest-install
curl http://nodejs.org/dist/node-latest.tar.gz | tar xz --strip-components=1
./configure --prefix=~/bin
# make # added this to the given
make install # ok, fine, this step probably takes more than 30 seconds...
# curl https://www.npmjs.org/install.sh | sh
# The above curl line has a script that needs to be modified 
# !#bin/sh ~> !#bin/bash
