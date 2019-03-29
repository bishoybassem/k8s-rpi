# Kubernetes on Raspberry Pi
The aim of this project is to explore the installation process of Kubernetes, understand its components and how 
they interact together. The setup is based on the official [documentation](https://kubernetes.io/docs/setup/scratch) 
for setting up a cluster from scratch. Moreover, Ansible is used to automate the installation steps. Finally, this setup is intended for testing and experimenting purposes only.

![screen1](pis.jpg)

## Requirements
* At least 2 [Raspberry Pi](https://www.raspberrypi.org/products) devices with 
  [Raspbian OS](https://www.raspberrypi.org/downloads/raspbian). <br/>
  (used: Raspberry Pi 3 Model B+ and Raspbian Stretch Lite 2018-11-13)
* The Pis should have ssh enabled with sudo privileges, better with key based authentication. ([guide](https://www.raspberrypi.org/documentation/remote-access/ssh/))  
  PS: a convenience script `install-os.sh` is added to simplify the OS installation to the SD card. It also configures the hostname, copies the WiFi network credentials to the card, configures SSH authorized access keys (and disables default password authentication in this case!). 
* A control machine that has the following installed:
  * Ansible (used version 2.7.7, [guide](https://docs.ansible.com/ansible/2.7/installation_guide/intro_installation.html))
  * Docker (used version 18.09.0-ce, [guide](https://docs.docker.com/install/))
  
## Steps
1. Clone the repository, and navigate to the clone directory.
2. Modify `hosts.yml`, and add there the hostnames of the Pis (names used in this setup are pi1, pi2, pi3 and pi4).
3. Run the base playbook with Ansible: <br/>
    ```bash
    ansible-playbook -i hosts.yml playbook-base.yml
    ```
4. Check the status of the cluster nodes and pods: <br/>
    ```bash
    pi@pi1:~ $ kubectl get nodes
    NAME   STATUS   ROLES    AGE   VERSION
    pi1    Ready    <none>   16m   v1.14.0
    pi2    Ready    <none>   16m   v1.14.0
    pi3    Ready    <none>   16m   v1.14.0
    pi4    Ready    <none>   16m   v1.14.0
    ```
    ```bash
    pi@pi1:~ $ kubectl get pods
    NAME                          READY   STATUS    RESTARTS   AGE
    kube-apiserver-pi1            1/1     Running   1          16m
    kube-controller-manager-pi1   1/1     Running   3          16m
    kube-scheduler-pi1            1/1     Running   1          16m
    registry-5db74645dc-mv86v     1/1     Running   1          15m
    ```
5. Optional: run the addons playbook: <br/>
    ```bash
    ansible-playbook -i hosts.yml playbook-addons.yml
    ```