# install docker
sudo yum check-update
curl -fsSL https://get.docker.com/ | sh
#add user to group docker
sudo usermod -aG docker theo
sudo systemctl start docker
sudo systemctl enable docker
sudo reboot now
