# SSH Backup Server

This tool sets up an SSH server to facilitate the backup of volumes from remote containers deployed in a cloud environment. The server allows you to download the backups using SFTP (SSH File Transfer Protocol).

## Purpose

The primary purpose of this tool is to create an SSH server that compresses and stores backups of specified volumes. These backups can then be securely downloaded using SFTP.

## Usage

### Prerequisites

- Docker
- Docker Compose
- Git
- SSH

### Setup

1. **Clone the repository:**

   ```sh
   git clone https://github.com/ajutra/ssh-backup-server.git
   ```

   ```sh
   cd ssh-backup-server
   ```

2. **Configure the environment:**

   Edit the [`config.yaml`](https://github.com/ajutra/ssh-backup-server/blob/main/config.yaml) file to set your SSH public key and the volumes you want to back up.

   ```yaml
   # SSH Public Key must be passed in order to access the server
   # There are three ways to pass the key:
   # 1. PUBLIC_KEY: The key itself
   # 2. PUBLIC_KEY_FILE: The path to the file containing the key
   # 3. PUBLIC_KEY_URL: The URL to the file containing the key (e.g. https://github.com/username.keys)
   # Only one of the three options is needed
   environment:
     - PUBLIC_KEY=myPublicKey
     - PUBLIC_KEY_FILE=path/to/public/key
     - PUBLIC_KEY_URL=https://github.com/username.keys
   # Define here the volumes that you want to mount in the container in order to backup the data
   volumes:
     - myVolumeName
   ```

3. **Generate the `compose.yaml` file:**

   Grant execute permissions to the [`generate-compose.sh`](https://github.com/ajutra/ssh-backup-server/blob/main/generate-compose.sh) script and run it to generate the `compose.yaml` file based on your configuration.

   ```sh
   chmod +x generate-compose.sh
   ```

   ```sh
   ./generate-compose.sh
   ```

4. **Build and start the Docker container:**

   ```sh
   docker-compose up --build -d
   ```

### Downloading Backups

To download the backup using SFTP, use the following `scp` command:

```sh
scp -i /path/to/private/ssh/key/file -P 2222 -s sshuser@SERVER_IP:/home/sshuser/backup.tar.gz /path/to/destination/folder
```

Replace `/path/to/private/ssh/key/file` with the path to your private SSH key, `SERVER_IP` with the IP address of your server, and `/path/to/destination/folder` with the path to the folder where you want to save the backup.

## Files

- [`config.yaml`](https://github.com/ajutra/ssh-backup-server/blob/main/config.yaml): Configuration file for environment variables and volumes.
- [`Dockerfile`](https://github.com/ajutra/ssh-backup-server/blob/main/Dockerfile): Dockerfile to build the SSH server image.
- [`entrypoint.sh`](https://github.com/ajutra/ssh-backup-server/blob/main/entrypoint.sh): Entrypoint script to compress the backup files.
- [`generate-compose.sh`](https://github.com/ajutra/ssh-backup-server/blob/main/generate-compose.sh): Script to generate the `compose.yaml` file based on [`config.yaml`](https://github.com/ajutra/ssh-backup-server/blob/main/config.yaml).
- [`Makefile`](https://github.com/ajutra/ssh-backup-server/blob/main/Makefile): Makefile to create a `.tar` file for building the Docker image in environments like Portainer.

## Disclaimer

This tool is provided "as is" without any warranty. Usage of this tool is under the user's responsibility, and it is highly recommended to review the code before execution.

## Acknowledgements

This tool uses the `linuxserver/openssh-server` Docker image from [linuxserver.io](https://hub.docker.com/r/linuxserver/openssh-server). We extend our sincere thanks to the linuxserver.io team for their excellent work and contributions to the open-source community.

## License

This project is licensed under the GNU GPLv3 License.
