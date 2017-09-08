#!/bin/bash

# install brew
if ! type brew; then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  xcode-select --install
else
  echo 'brew update'
  brew update
fi

# helper functions
brew_install() {
  if ! type $1; then
    echo "installing: $1..."
    brew install $1
    echo 'finished'
  else
    echo "$1 is installed"
  fi
}

cask_install() {
  if !(brew cask list | grep $1); then
    echo "installing: $1..."
    brew cask install $1
    echo 'finished'
    brew tap caskroom/versions
  else
    echo "$1 is installed"
    brew cask update
  fi
}

brew_install_with_agents() {
  # todo mkdir ~/Library/LaunchAgents
  if ! type $1; then
    echo "installing: $1..."
    brew install $1
    echo 'agents installing...'
    # To have launchd start redis at login:
    ln -sfv /usr/local/opt/$1/*.plist ~/Library/LaunchAgents
    # Then to load redis now:
    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.$1.plist
    echo 'finished'
  else
    echo "$1 is installed"
  fi
}

if ! type rbenv; then
  brew_install rbenv
  brew_install ruby-build

  # Add rbenv to bash so that it loads every time you open a terminal
  echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile
  source ~/.bash_profile

  # Install Ruby # El Capitan hack
  brew install https://raw.githubusercontent.com/Homebrew/homebrew/b5cffc8d5fc41540a41ed4deba23afbb6431435e/Library/Formula/openssl.rb
  brew tap homebrew/versions
  brew switch openssl 1.0.1l
  brew link openssl --force

  # brew install llvm35 openssl
  RUBY_CONFIGURE_OPTS="--with-lib-dir=$(brew --prefix openssl)/lib --with-include-dir=$(brew --prefix openssl)/include" rbenv install 2.2.2
  rbenv global 2.2.2
  ruby -v
  gem install bundler
else
  echo 'rbenv and ruby installed'
fi

autostart_hidden() {
  for app; do
    echo "Autostart: $app"
    osascript -e "tell application \"System Events\" to make login item at end with properties {path:\"/Applications/$app.app\", hidden:true}" > /dev/null
  done
}

brew_install_with_agents postgresql
brew_install_with_agents mysql
brew_install_with_agents redis
brew_install_with_agents mongodb

brew_install caskroom/cask/brew-cask
brew_install qt
brew_install memcached
brew_install imagemagick
brew_install node
brew_install heroku
brew_install bash-completion
brew_install elixir
# brew_install pow
brew_install phantomjs
brew_install awscli
brew_install yarn

# Media

cask_install google-chrome
cask_install spotify
cask_install skype
cask_install dropbox
cask_install firefox
cask_install slack
cask_install atom
cask_install vlc
cask_install sublime-text3
cask_install iterm2
# cask_install todoist
# cask_install mailbox
# cask_install bettertouchtool
cask_install libreoffice
cask_install totalterminal
cask_install gimp
cask_install transmission
# cask_install spectacle
# cask_install dash
cask_install toggldesktop
cask_install slack
cask_install java
cask_install opera
cask_install torbrowser # browser
cask_install steam
cask_install pgadmin3
cask_install skitch
cask_install calibre
cask_install postico
cask_install zeplin
cask_install caffeine
cask_install flux
cask_install airdroid


# Optional/alternative
cask_install alfred

# Settings
# defaults write com.apple.dashboard mcx-disabled -boolean YES && killall Dock

# Set Autostart
# autostart_hidden BetterTouchTool Monosnap

# You need to install manualy:
# sunrise
# quickcast
# monosnap
# http://qnapi.github.io/
# discord
