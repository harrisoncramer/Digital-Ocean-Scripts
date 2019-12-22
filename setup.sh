# Script sets up DigitalOcean Nginx Reverse Proxy Server
# Can install MongoDB (optional), and Yarn.
#!/bin/bash
usage(){
    echo "Usage: ${0} [-my] USERNAME" >&2
    exit 1
};

while getopts my OPTION # The colon means that l requires an argument...
do 
    case ${OPTION} in
        m) 
            MONGODB="true" 
            echo "Installing MongoDB: Yes"
        ;;
        y) 
            YARN="true" 
            echo "Installing Yarn: Yes"
        ;;
        ?) usage ;;
    esac
done

shift $(( OPTIND -1 ));

if [[ "${#}" -eq 0 ]] # If no users are provided...
then
  usage
fi

USER_NAME=${1}

# Generate the random password.
SPECIAL_CHARACTERS='@!$%^&*()_+';
CHOSEN=$(echo $SPECIAL_CHARACTERS | fold -w1 | shuf | head -c1 ); # Split (fold) along 1 column, shuffle order, take first byte input
PASSWORD_BASE=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c8);
PASSWORD="${PASSWORD_BASE}${CHOSEN}";

# Creates a new user on the local system with the name provided
useradd -m "${USER_NAME}"

# # Informs the user if the account was not able to be created for some reason.
if [[ "${?}" -ne 0 ]]
then
    echo "There was a problem creating the account.";
    exit 1;
fi

# Set the password
echo "${USER_NAME}":"${PASSWORD}" | chpasswd;

if [[ "${?}" -ne 0 ]]
then
  echo "The password for the account could not be set."
  exit 1
fi

# Force the password to change on first login.
passwd -e "${USER_NAME}" # Expire the password.

echo "USERNAME IS: ${USER_NAME}";
echo "***** PASSWORD IS: ${PASSWORD} *****";

# Provide user with root privileges.
sudo usermod -aG sudo "${USER_NAME}"

if [[ "${?}" -ne 0 ]]
then
  echo "The user could not be granted root privileges."
  exit 1
fi

# Modified password login setup
sudo sed -i 's/PasswordAuthentication\ no/PasswordAuthentication\ yes/g' /etc/ssh/sshd_config
sudo service sshd reload

if [[ "${?}" -ne 0 ]]
then
  echo "The sshd could not be setup for the user."
  exit 1
fi

echo "User setup completed."
