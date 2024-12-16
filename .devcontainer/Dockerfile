FROM zephyrprojectrtos/zephyr-build:v0.26.18

ARG USER_NAME=user
ARG USER_UID=1111
ARG USER_GID=$USER_UID

## Setup a user with sudo support
USER root

RUN  apt update \
  && apt install -y -q \
       bash-completion \
       gdb \
       nano

# Align user/group account if necessary ('user' is the name brought in by default Zephyr Docker images) and add to sudo group (password-free)
# https://serverfault.com/questions/437342/how-can-i-rename-a-unix-user
RUN apt install -y -q sudo \
&&  if ! grep :$USER_GID: /etc/group;  then groupmod -g $USER_GID user; fi \
&&  if ! grep :$USER_UID: /etc/passwd; then usermod -u $USER_GID user; fi \
&&  if ! grep $USER_NAME: /etc/group;  then groupmod --new-name $USER_NAME user; fi \
&&  if ! grep $USER_NAME: /etc/passwd; then usermod --login $USER_NAME --move-home --home /home/$USER_NAME user; fi \
&&  chown -R $USER_UID:$USER_GID /home/$USER_NAME \
&&  chsh -s /usr/bin/bash $USER_NAME \
&&  usermod -a -G root $USER_NAME && usermod -a -G dialout $USER_NAME \
&&  echo "$USER_NAME ALL = NOPASSWD: ALL" > /etc/sudoers.d/$USER_NAME \
&&  chmod 0440 /etc/sudoers.d/$USER_NAME

# default to $USER_NAME
USER $USER_NAME
