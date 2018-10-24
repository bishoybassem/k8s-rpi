# Kubernetes on Raspberry Pi
The aim of this repo is to explore the installation process of Kubernetes, understand its components and how 
they interact together. The setup is based on the official [documentation](https://kubernetes.io/docs/setup/scratch) 
for setting up a cluster from scratch. Moreover, Ansible is used to automate the installation steps. Finally, this setup is intended for testing and experimenting purposes only.

![screen1](pis.jpg)

## Requirements
* At least 2 [Raspberry Pi](https://www.raspberrypi.org/products) devices with 
  [Raspbian OS](https://www.raspberrypi.org/downloads/raspbian). <br/>
  (used: Raspberry Pi 3 Model B+ and Raspbian Stretch Lite 2018-10-09)
* The Pis should have ssh enabled with sudo privileges, better with key based authentication. ([guide](https://www.raspberrypi.org/documentation/remote-access/ssh/))
* A control machine that has Ansible installed. (used version 2.7.0, [guide](https://docs.ansible.com/ansible/2.7/installation_guide/intro_installation.html))

## Steps
* Clone the repo, navigate to the clone directory and execute `get-binaries.sh`. This will compile/download the required binaries.
* Modify `hosts.yml`, and add there the hostnames of the Pis (names used in this setup are pi1, pi2 and pi3).
* Run the base playbook with Ansible: <br/>
    ```bash
       ansible-playbook -i hosts.yml playbook-base.yml
    ```
* Restart the Pis.
* Check the status of the cluster nodes and pods: <br/>
    ```bash
       root@pi1:/home/pi# kubectl get nodes
       NAME   STATUS   ROLES    AGE     VERSION
       pi1    Ready    <none>   4d23h   v1.12.0
       pi2    Ready    <none>   4d23h   v1.12.0
       pi3    Ready    <none>   4d23h   v1.12.0
    ```
    ```bash
       root@pi1:/home/pi# kubectl get pods
       NAME                          READY   STATUS    RESTARTS   AGE
       kube-apiserver-pi1            1/1     Running   0          4d23h
       kube-controller-manager-pi1   1/1     Running   0          4d23h
       kube-scheduler-pi1            1/1     Running   0          4d23h
    ```
* Optional: run the addons playbook: <br/>
    ```bash
       ansible-playbook -i hosts.yml playbook-addons.yml
    ```