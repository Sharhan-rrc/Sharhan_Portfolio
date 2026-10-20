#!/usr/bin/env bash
# Sharhan Kaji | 0424551 | Repeatable CentOS Stream 9 deployment
set -Eeuo pipefail
trap 'echo "Provisioning failed at line $LINENO" >&2' ERR

dnf install -y dnf-plugins-core git curl
auto_repo=/etc/yum.repos.d/docker-ce.repo
if [[ ! -f "$auto_repo" ]]; then
  dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
fi
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable --now docker
usermod -aG docker vagrant

workdir=/home/vagrant/devops-sprints
install -d -o vagrant -g vagrant "$workdir"
# Fetch rather than clone again, making repeated provisioning safe.
sync_repo() {
  local name="$1"
  if [[ ! -d "$workdir/$name/.git" ]]; then
    sudo -u vagrant git clone "https://github.com/Sharhan-rrc/$name.git" "$workdir/$name"
  else
    sudo -u vagrant git -C "$workdir/$name" fetch origin
    sudo -u vagrant git -C "$workdir/$name" merge --ff-only '@{u}'
  fi
}
sync_repo Sharhan_Portfolio
sync_repo BankingApp
install -o vagrant -g vagrant -m 644 /tmp/module4-compose.yml "$workdir/docker-compose.yml"

# Open only the assignment web ports if the guest firewall is active.
if systemctl is-active --quiet firewalld; then
  firewall-cmd --permanent --add-port=3000/tcp
  firewall-cmd --permanent --add-port=5090/tcp
  firewall-cmd --reload
fi
cd "$workdir"
docker compose config --quiet
docker compose up -d --build --wait --wait-timeout 180
docker compose ps
curl --fail --silent http://127.0.0.1:3000/ | grep -q 'Welcome to My Portfolio Auto Deploy'
curl --fail --silent http://127.0.0.1:5090/ | grep -q 'Welcome to the Banking App Auto Deploy'
docker exec studentportfolio wget -q -O /dev/null http://bankingapp:5090/
echo "Sharhan Kaji | Student ID 0424551 | Auto Deploy ready"
echo "Portfolio: http://192.168.56.53:3000"
echo "Banking:   http://192.168.56.53:5090"
