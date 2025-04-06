#!/bin/bash
echo "📦 Ruby version (rbenv): $(rbenv version)"
echo "📦 Ruby path           : $(which ruby)"
echo "📦 Ruby version full   : $(ruby -v)"
echo "📦 Node version        : $(node -v)"
echo "📦 NPM version         : $(npm -v)"
echo "📦 Pod version         : $(pod --version)"
echo "📦 Bundler version     : $(bundle -v)"
echo "📦 React Native CLI    : $(react-native -v)"
echo
rbenv versions
echo
gem list --local
echo
npm list -g --depth=0
