`# CI/CD Pipeline Server setup

## Run setup script
 
 ```bash
 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Raft-Labs/server-setup/main/setup.sh)"
 ```
 
 ```bash
 chmod +x setup.sh
 ```
 
 ```bash
 ./setup.sh
 ```


## Docker Installation

The setup script will install Docker on your system. It includes the following steps:
1. Add Docker's official GPG key.
2. Add the Docker repository to Apt sources.
3. Install Docker Engine and related components.
4. Perform post-installation steps to manage Docker as a non-root user.

## Swap File Creation

The setup script also includes an optional step to create a swap file. By default, it will create an 8GB swap file, but you can specify a different size as an argument.

### Example

To run the setup script and create a swap file of 4GB, use the following command:

```bash
./setup.sh 4096
```


If you do not want to create a swap file, simply run the script without any arguments and respond with 'n' when prompted:

```bash
./setup.sh
```
