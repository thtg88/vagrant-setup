#!/usr/bin/env bash

# Install and configure Node via NVM

# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash

# Add the following lines to your ~/.bashrc to have it automatically sourced upon login
# cat >> /home/vagrant/.bashrc <<EOF
#
# export NVM_DIR="/home/vagrant/.nvm"
# [ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "\$NVM_DIR/bash_completion" ] && \. "\$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# EOF

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Install Node 10
nvm install 10.16.0

# Install Yarn
npm install -g yarn
