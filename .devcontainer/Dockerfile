# https://github.com/zephyrproject-rtos/docker-image/tree/v0.26.18
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
       curl \
       # required for USB device handling and serial monitor
       udev \
       usbutils \
       # required for git messages
       nano \
       # required to build guiconfig
       python3-tk

# Download and install JLink tools
RUN  curl -d 'accept_license_agreement=accepted' \
      -X POST https://www.segger.com/downloads/jlink/JLink_Linux_x86_64.deb \
      -o /tmp/JLink_Linux_x86_64.deb \
  && dpkg --unpack /tmp/JLink_Linux_x86_64.deb \
  && rm /tmp/JLink_Linux_x86_64.deb \
  && rm -f /var/lib/dpkg/info/jlink.postinst \
  && (dpkg --configure jlink || apt install -yf) \
  && apt install -y libxrandr2 libxfixes3 libxcursor1

# Align user/group account if necessary ('user' is the name brought in by default Zephyr Docker images) and add to sudo group (password-free)
# https://serverfault.com/questions/437342/how-can-i-rename-a-unix-user
RUN  apt install -y -q sudo \
  && if ! grep x:$USER_GID: /etc/group;  then groupmod --gid $USER_GID user; fi \
  && if ! grep x:$USER_GID: /etc/group;  then groupmod --gid $USER_GID user; fi \
  && if ! grep $USER_NAME:x /etc/group;  then groupmod --new-name $USER_NAME user; fi \
  && if ! grep x:$USER_UID: /etc/passwd; then usermod --uid $USER_UID $USER_NAME; fi \
  && if ! grep :$USER_GID:: /etc/passwd; then usermod --gid $USER_GID $USER_NAME; fi \
  && if ! grep $USER_NAME:x /etc/passwd; then usermod --login $USER_NAME --move-home --home /home/$USER_NAME user; fi \
  && mkdir -p /home/$USER_NAME/.config \
  && chown -R $USER_UID:$USER_GID /home/$USER_NAME \
  && chsh -s /usr/bin/bash $USER_NAME \
  && usermod -a -G root $USER_NAME \
  && usermod -a -G dialout $USER_NAME \
  && echo "$USER_NAME ALL = NOPASSWD: ALL" > /etc/sudoers.d/$USER_NAME \
  && chmod 0440 /etc/sudoers.d/$USER_NAME

# default to $USER_NAME
USER $USER_NAME
