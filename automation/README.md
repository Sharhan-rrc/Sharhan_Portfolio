# Module 4 Sprint 1B
Sharhan Kaji — Student ID 0424551

Install Vagrant and VirtualBox on the host. Internet access is required.
Stop any other VM using 192.168.56.53 before starting this environment.
From this folder, run `vagrant up`. No host Docker installation or host source paths are required.
The script installs Docker and Compose, clones the two public GitHub repositories, builds both images, and waits for healthy containers.
To repeat provisioning, run `vagrant provision`. Repository updates must fast-forward; guest source edits are not overwritten.

## Screenshots
1. Screenshot 002: terminal after `vagrant up`, showing both healthy containers and the URLs. To redisplay: `vagrant ssh -c "cd /home/vagrant/devops-sprints && docker compose ps"`.
2. Screenshot 003: open http://192.168.56.53:3000 with the address bar, Auto Deploy heading, name and student ID visible.
3. Screenshot 004: click View Banking App from the portfolio and capture the banking page with http://192.168.56.53:5090 and Auto Deploy visible.

Do not clean up until screenshots are saved. When finished, `vagrant halt` preserves the VM. To stop the application stack, use `docker compose down` inside /home/vagrant/devops-sprints in the guest. This prototype stores its SQLite data inside the container, so removing that container discards its test data.

## Reflection prompts for your own answers
- Trace the browser request from the portfolio link to the VM private IP and published banking port. Explain separately how Docker DNS allows containers on prf-network to reach bankingapp by name; the host browser uses the IP link, not Docker DNS.
- Compare what you personally did manually with what provision.sh now performs. Relate repeatability to Tyler's deployment problem.
- Describe how shared automation could save your team time, while considering the initial effort and debugging.
- Explain benefits you observed, including health checks for Kevin's availability concern and what further security improvements Ben would require.

## References
- https://docs.docker.com/engine/install/centos/
- https://docs.docker.com/compose/how-tos/startup-order/
