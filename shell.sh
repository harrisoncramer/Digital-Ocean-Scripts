#!/bin/bash
if [[ $EUID -eq 0 ]]; then
   echo "This script should not be run as root." 
   exit 1
fi


# Install ZSH and make it default shell
sudo apt install zsh -y
sudo chsh -s $(which zsh)
touch ~/.zshrc

# Install Oh-My-ZSH
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install powerline fonts
git clone https://github.com/powerline/fonts.git
cd fonts
sudo ./install.sh

# Change theme
sed -i 's/robbyrussell/agnoster/g' ~/.zshrc
 
# Change prompt
prompt=$(cat << 'EOF'
prompt_context() {
  # Custom (Random emoji)
  emojis=("⚡️" "🔥" "💀" "👑" "😎" "🐸" "🐵" "🦄" "🌈" "🍻" "💡" "🎉" "🔑" "🇹🇭" "🚦" "🌙")
  RAND_EMOJI_N=$(( $RANDOM % ${#emojis[@]} + 1))
  prompt_segment black default "${emojis[$RAND_EMOJI_N]} "
}
EOF
)

echo "$prompt" >> ~/.zshrc

chsh -s /bin/zsh
