#!/bin/bash

### iOS Dev Setup Script (latest rbenv, Ruby, Node, RN)

set -e

echo "[1] Xcode Command Line Tools 설치..."
xcode-select --install 2>/dev/null || echo "이미 설치되어 있거나 GUI로 설치 필요."

echo "[2] Homebrew 설치 확인..."
if ! command -v brew &>/dev/null; then
  echo "Homebrew 설치 중..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew가 이미 설치되어 있음."
fi

echo "[3] 필수 패키지 설치"
brew update
brew install openssl readline libyaml gmp nvm node watchman

echo "[4] 기존 rbenv 제거"
brew uninstall --force rbenv ruby-build &>/dev/null || true
rm -rf ~/.rbenv

echo "[5] 최신 rbenv 설치 (GitHub)"
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
mkdir -p ~/.rbenv/plugins
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

echo "[6] .zshrc 설정"
ZSHRC="$HOME/.zshrc"
grep -q 'rbenv init - zsh' "$ZSHRC" || cat << 'EOF' >> "$ZSHRC"

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "\$(rbenv init - zsh)"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

autoload -Uz compinit
compinit
EOF

source "$ZSHRC"

echo "[7] Node.js 설치"
mkdir -p ~/.nvm
nvm install 18
nvm use 18
nvm alias default 18

echo "[8] Ruby 설치"
rbenv install -s 3.2.2
rbenv global 3.2.2
rbenv rehash

echo "[9] gem + cocoapods"
gem install bundler
gem install cocoapods

echo "[10] React Native CLI"
npm install -g react-native-cli

echo "[11] 개발환경 백업 스크립트 생성"
cat << 'EOS' > ~/backup_env.sh
#!/bin/bash
echo "📦 Ruby version (rbenv): \$(rbenv version)"
echo "📦 Ruby path           : \$(which ruby)"
echo "📦 Ruby version full   : \$(ruby -v)"
echo "📦 Node version        : \$(node -v)"
echo "📦 NPM version         : \$(npm -v)"
echo "📦 Pod version         : \$(pod --version)"
echo "📦 Bundler version     : \$(bundle -v)"
echo "📦 React Native CLI    : \$(react-native -v)"
rbenv versions
gem list --local
npm list -g --depth=0
EOS
chmod +x ~/backup_env.sh

echo "[12] 완료! 새 터미널을 열거나 source ~/.zshrc"
