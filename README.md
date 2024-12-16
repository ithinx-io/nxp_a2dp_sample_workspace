# NXP Bluetooth A2DP Sample environment

west project to test NXP A2DP sample

# Initial project setup

This project contains a setup containing a [workspace file](https://code.visualstudio.com/docs/editor/workspaces) and [DevContainer](https://code.visualstudio.com/docs/devcontainers/containers) environment based on the official [Zephyr Docker setup](https://github.com/zephyrproject-rtos/docker-image) for [Visual Studio Code](https://code.visualstudio.com). \
Additionally it make sure the required Zephyr Toolchains from the Zephyr Dockerfile are usable. \
To initialize:
- recursively clone this repo containing the Zephyr DevContainer Workspace and the NXP-Zephyr as submodule:
  ```
  git clone --recurse-submodules <clone-url-of-this repo>
  ```
- Open the project by doubleClick on the [NXP.code-workspace](NXP.code-workspace) file. \
  VisualStudio Code will ask to `reopen the workspace in DevContainer`, please select `Reopen in Container` (mandatory!).
- After VSCode startup (will take some time for the initial docker container build), update Zephyr modules and HAL blobs:
  ```
  west update
  west blobs fetch
  ```
- build example:
  ```
  west build -b mimxrt1170_evk@B/mimxrt1176/cm7 nxp-zephyr/samples/bluetooth/a2dp_source
  ```
