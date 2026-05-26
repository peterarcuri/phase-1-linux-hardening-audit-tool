#!/bin/bash

create_users() {
    INPUT_FILE="../users/users.txt"

    while IFS=: read -r username group
    do
        if ! getent group "$group" > /dev/null; then
        groupadd "$group"
        fi 

        useradd -m -g "$group" "$username"

        password=$(openssl rand -base64 12)

        echo "${username}:${password}" | chpasswd

        passwd -e "$username"

        echo "Created user: $username"
    done < "$INPUT_FILE"
}

