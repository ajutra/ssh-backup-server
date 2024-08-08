FROM lscr.io/linuxserver/openssh-server:latest

# Add the entrypoint script
COPY entrypoint.sh /entrypoint.sh

# Make the script executable
RUN chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Set the default command
CMD ["/init"]