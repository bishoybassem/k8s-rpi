# Kubernetes on Raspberry Pi
The aim of this project is to explore the installation process of Kubernetes, understand its components and how 
they interact together. Ansible is used to automate the cluster's setup (without kubeadm). Finally, this setup is intended for testing and experimenting purposes only.

![screen1](pis.jpg)

## Requirements
* At least 2 [Raspberry Pi](https://www.raspberrypi.org/products) devices with 
  [Raspbian OS](https://www.raspberrypi.org/downloads/raspbian). <br/>
  (used: Raspberry Pi 3 Model B+ and Raspbian Buster Lite 2020-02-13)
* The Pis should have ssh enabled with sudo privileges, better with key based authentication. ([guide](https://www.raspberrypi.org/documentation/remote-access/ssh/))  
  PS: a convenience script `install-os.sh` is added to simplify the OS installation to the SD card. It also configures the hostname, copies the WiFi network credentials to the card, configures SSH authorized access keys (and disables default password authentication in this case!). 
* A control machine that has the following installed:
  * Ansible (used version 2.9.1, [guide](https://docs.ansible.com/ansible/2.9/installation_guide/intro_installation.html))
  * Docker (used version 19.03.5-ce, [guide](https://docs.docker.com/install/))
  
## Steps
1. Clone the repository, and navigate to the clone directory.
2. Modify `hosts.yml`, and add there the hostnames of the Pis (names used in this setup are pi1, pi2, pi3 and pi4).
3. Run the main Ansible playbook:
   ```bash
   ansible-playbook -i hosts.yml playbook-main.yml
   ```
4. Check the status of the cluster nodes and pods:
   ```bash
   pi@pi1:~ $ sudo kubectl get nodes
   NAME   STATUS   ROLES    AGE     VERSION
   pi1    Ready    master   3m21s   v1.18.0
   pi2    Ready    worker   3m21s   v1.18.0
   pi3    Ready    worker   3m7s    v1.18.0
   pi4    Ready    worker   3m21s   v1.18.0
   ```
   ```bash
   pi@pi1:~ $ sudo kubectl get pods -A
   NAMESPACE     NAME                          READY   STATUS    RESTARTS   AGE
   kube-system   coredns-7bbbd858fd-2v556      1/1     Running   0          2m33s
   kube-system   coredns-7bbbd858fd-6pg4m      1/1     Running   0          2m33s
   kube-system   kube-apiserver-pi1            1/1     Running   0          3m22s
   kube-system   kube-controller-manager-pi1   1/1     Running   1          3m14s
   kube-system   kube-scheduler-pi1            1/1     Running   0          2m11s
   ```
5. Optional: run the addons playbook (sets up an in-cluster docker registry):
   ```bash
   ansible-playbook -i hosts.yml playbook-addons.yml
   ```