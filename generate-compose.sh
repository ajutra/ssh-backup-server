PUBLIC_KEY=$(grep 'PUBLIC_KEY=' config.yaml | cut -d'=' -f2)
PUBLIC_KEY_FILE=$(grep 'PUBLIC_KEY_FILE=' config.yaml | cut -d'=' -f2)
PUBLIC_KEY_URL=$(grep 'PUBLIC_KEY_URL=' config.yaml | cut -d'=' -f2)

# Read volumes from config.yaml
volumes=$(awk '/volumes:/ {flag=1; next} /^[^ ]/ {flag=0} flag && !/^#/ && $0 !~ /^ *$/ {print}' config.yaml | grep -o '^[^#]*' | grep -o '[^ ]*' | grep -v '^-$')

# Start the compose.yaml content
cat <<EOF > compose.yaml
services:
  openssh-server:
    build:
      dockerfile: Dockerfile
    container_name: openssh-server
    environment:
      - USER_NAME=sshuser
      - PUBLIC_KEY=$PUBLIC_KEY
      - PUBLIC_KEY_FILE=$PUBLIC_KEY_FILE
      - PUBLIC_KEY_URL=$PUBLIC_KEY_URL
    volumes:
EOF

# Initialize a variable to store volumes without paths
external_volumes=""

# Add each volume to the compose.yaml with a unique subfolder based on the volume name or path
for volume in $volumes; do
    case $volume in
        /*)
            # Volume with path
            volume_name=$(basename "$volume")
            echo "      - $volume:/home/sshuser/backup/$volume_name" >> compose.yaml
            ;;
        *)
            # Volume without path
            external_volumes="$external_volumes$volume\n"
            echo "      - $volume:/home/sshuser/backup/$volume" >> compose.yaml
            ;;
    esac
done

cat <<EOF >> compose.yaml
    ports:
      - 2222:2222
    restart: unless-stopped
EOF

# Add external volumes to the end of the compose.yaml file
if [ -n "$external_volumes" ]; then
    echo "volumes:" >> compose.yaml
    printf "$external_volumes" | while read -r volume; do
        if [ -n "$volume" ]; then
            echo "  $volume:" >> compose.yaml
            echo "    external: true" >> compose.yaml
        fi
    done
fi