# Check for run only as sudo
if [ "$EUID" -ne 0 ]
    then echo "Please use `sudo` before run"
    exit
fi

# Check if user joris exists
if id "joris" &>/dev/null; then
    echo 'user joris found'
else
    echo "User joris not found"
    exit 1
fi

# Create new key for user:
runuser -l joris -c ssh-keygen

# Install docker
grubby --update-kernel=ALL --args="systemd.unified_cgroup_hierarchy=0"
firewall-cmd --permanent --zone=trusted --add-interface=docker0
firewall-cmd --permanent --zone=FedoraWorkstation --add-masquerade
dnf install moby-engine docker-compose
systemctl enable docker
groupadd docker
usermod -aG docker $USER

# Install Snapd
dnf install snapd
sleep 15 #Wait a while
sudo ln -s /var/lib/snapd/snap /snap

# Install phpstorm
snap install phpstorm --classic
#runuser -l joris -c /home/joris/phpstorm.sh

# Install snap
snap install postman

# Install GIt
dnf install git
runuser -l joris -c git config --global user.name "Joris Ros"
runuser -l joris -c git config --global user.email "joris.ros@gmail.com"

# Install lazygit
dnf copr enable atim/lazygit -y
dnf install lazygit

#Lower security settings for compatibel with Bitbucket
sudo update-crypto-policies --set LEGACY

#Echo key
echo "Install following key in github and bitbucket"
cat /home/joris/.ssh/id_rsa.pub
