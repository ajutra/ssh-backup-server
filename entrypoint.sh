#!/bin/bash

# Compress the files in /home/sshuser/backups
tar -czvf /home/sshuser/backup.tar.gz -C /home/sshuser/backup .

# Execute the original entrypoint
exec "$@"