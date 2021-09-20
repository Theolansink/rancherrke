echo "Wat is het IP-adres van de huidige VM:"
read IPMASTER
echo "Wat is het IP-adres van Node1:"
read IPNODE1
echo "Wat is het IP-adres van Node2:"
read IPNODE2
echo "als IPMASTER is $IPMASTER ingevuld"

ssh-keygen
ssh-copy-id -i ~/.ssh/id_rsa.pub $USER@$IPMASTER
echo -e "\n\n ssh-keys geinstalleerd \n\n"
sudo reboot now

###########################################################
# genereer ssh-key voor huidige non-root user voor toegang met ssh tot cluster
###########################################################
# install docker
sudo yum check-update
curl -fsSL https://get.docker.com/ | sh
#add user to group docker
sudo usermod -aG docker theo
sudo systemctl start docker
sudo systemctl enable docker
###########################################################
# stop firewall
###########################################################
sudo systemctl stop firewalld
sudo systemctl disable firewalld


