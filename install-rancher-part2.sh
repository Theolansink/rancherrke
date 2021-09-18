###########################################################
# genereer ssh-key voor huidige non-root user voor toegang met ssh tot cluster
###########################################################
ssh-keygen
ssh-copy-id -i ~/.ssh/id_rsa.pub theo@10.10.41.117
echo -e "\n\n ssh-keys geinstalleerd \n\n"
###########################################################
# installeer RKE kubernetes
###########################################################
wget https://github.com/rancher/rke/releases/download/v1.2.12/rke_linux-amd64
mv rke_linux-amd64 rke
chmod +x rke
export PATH=$PATH:.
echo -e "\n\n RKE gedownload en gerenamed naar rke \n\n"
###########################################################
# installeer rke door config aan te roepen; geef ip adres host, usernaam huidige user, naam host (node1)
###########################################################
./rke config
echo -e "\n\n rke config afgerond \n\n"
###########################################################
# installeer helm (package manager)
###########################################################
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
echo -e "\n\n helm (package manager) geinstalleerd \n\n"
###########################################################
# installeer kubectl
###########################################################
cat <<EOF > kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
sudo mv kubernetes.repo /etc/yum.repos.d
sudo yum install -y kubectl
echo -e "\n\n kubectl geinstalleerd \n\n"
###########################################################
# start kubernetes cluster
###########################################################
rke up
echo -e "\n\n rke cluster is op \n\n"
###########################################################
# zet kubeconfig in juiste map .kube
###########################################################
mkdir ~/.kube
cp kube_config_cluster.yml ~/.kube/config
export KUBECONFIG=$HOME/.kube/config
echo -e "\n\n rke config in .kube geplaatst \n\n"
###########################################################
# installeer certmanager om certificaat te genereren voor Rancher
###########################################################
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.5.1/cert-manager.crds.yaml
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.5.1
echo -e "\n\n cert manager geinstalleerd \n\n"
###########################################################
# installeer rancher
###########################################################
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
kubectl create namespace cattle-system
helm install rancher rancher-stable/rancher \
  --namespace cattle-system \
  --set hostname=rancher.org \
  --set bootstrapPassword=admin
echo -e "\n\n rancher geinstalleerd \n\n"
###########################################################
# controleer voortgang installatie
###########################################################
kubectl -n cattle-system rollout status deploy/rancher ## check voortgang installatie




