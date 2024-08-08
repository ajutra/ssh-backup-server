TAR_FILE=backup_server.tar

FILES_TO_INCLUDE=entrypoint.sh Dockerfile

# Default target
all: clean create-tar

create-tar:
	tar -czvf $(TAR_FILE) $(FILES_TO_INCLUDE)

clean:
	rm -f $(TAR_FILE)

.PHONY: all create-tar clean