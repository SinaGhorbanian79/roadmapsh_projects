# SSH Remote Server Setup
## Step 1: Register and Set Up a Remote Linux Server

Choose a Cloud Provider:
You can select any provider like DigitalOcean, AWS, or others. For this example, we'll use DigitalOcean.
Sign up for DigitalOcean and create a droplet (or a small server instance).
Choose the Linux distribution (Ubuntu is common for beginners).
Select the server size (a basic one, such as 1GB RAM, should suffice for testing).
After setting up the server, you'll be provided with the server's IP address and SSH access credentials.

- Access the Server:

After the server is created, you will receive the root password or the ability to SSH in using a default SSH key. Use the following command to access the server:
```sh
ssh root@<server-ip>
```
Replace <server-ip> with your actual server's IP address. This assumes you already have the SSH key set up or will use a password for the first login.

## Step 2: Create SSH Key Pairs

You need to generate two separate SSH key pairs for this project.

- Generate the first SSH key pair:

Run this command on your local machine to generate the first key pair:
```sh
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa_1
```
Follow the prompts to set a passphrase (optional) and finish the key creation.

- Generate the second SSH key pair:

Similarly, create the second SSH key pair:
```sh
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa_2
```
- Verify the key pairs:

After generating the keys, you should see two private keys (id_rsa_1 and id_rsa_2) and their corresponding public keys (id_rsa_1.pub and id_rsa_2.pub) in the ~/.ssh/ directory.

## Step 3: Add the Public Keys to the Server

Now, you'll add the public keys to the server's ~/.ssh/authorized_keys file to enable SSH login with both keys.

- Copy the public key to the server:

Use the ssh-copy-id command to copy both public keys to the server.

First, copy the first public key:
```sh
ssh-copy-id -i ~/.ssh/id_rsa_1.pub root@<server-ip>
```
Then, copy the second public key:
```sh
ssh-copy-id -i ~/.ssh/id_rsa_2.pub root@<server-ip>
```
You will be prompted for the server password (if applicable) and the key will be added to the ~/.ssh/authorized_keys file on the server.

Verify SSH login with both keys:

Test logging into the server using both keys with these commands:
```sh
ssh -i ~/.ssh/id_rsa_1 root@<server-ip>
```
and
```sh
ssh -i ~/.ssh/id_rsa_2 root@<server-ip>
```
If both commands work, you've successfully added the keys to the server.

## Step 4: Configure SSH Config for Simplified Access

To make it easier to SSH into your server without specifying the key path each time, modify the ~/.ssh/config file on your local machine.

- Edit the SSH config file:

Open or create the SSH config file:
```sh
nano ~/.ssh/config
```
Add the server configuration:

Add the following configuration for your server:
```sh
Host myserver
    HostName <server-ip>
    User root
    IdentityFile ~/.ssh/id_rsa_1
```
You can also create an entry for the second key by adding:
```sh
Host myserver2
    HostName <server-ip>
    User root
    IdentityFile ~/.ssh/id_rsa_2
```
Save and exit the editor (press Ctrl + X, then Y and Enter to confirm).

- Test SSH connections using aliases:

Now, you can simply use the following command to SSH into your server:
```sh
ssh myserver
```
Or, for the second key:
```sh
ssh myserver2
```
This will automatically use the correct key based on the configuration.

## Step 5: (Stretch Goal) Install and Configure Fail2Ban

Fail2Ban helps secure your server by preventing brute-force SSH login attempts. Here's how you can install and configure it.

- Install Fail2Ban:

Run the following command to install Fail2Ban on your server:
```sh
sudo apt update
sudo apt install fail2ban
```
- Configure Fail2Ban for SSH:

The default configuration for Fail2Ban includes protection for SSH. To check or modify the settings, you can edit the configuration file:
```sh
sudo nano /etc/fail2ban/jail.local
```
Make sure the following section is included and uncommented for SSH protection:
```sh
[sshd]
enabled = true
port = ssh
logpath = /var/log/auth.log
maxretry = 3
bantime = 600
findtime = 600
```
This will block an IP for 10 minutes (bantime = 600) after 3 failed login attempts within 10 minutes (maxretry = 3 and findtime = 600).

- Restart Fail2Ban:

After editing the configuration, restart Fail2Ban to apply the changes:
```sh
sudo systemctl restart fail2ban
```
- Check Fail2Ban status:

You can verify that Fail2Ban is protecting your SSH service by running:
```sh
sudo fail2ban-client status sshd
```
