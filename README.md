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
  west blobs fetch hal_nxp
  ```

# Required Hardware rework

To run this sample on an EVK with M.2 wireless card some HW rework ist necessary:
- **MIMXRT1170-EVKB**
  - remove R183 (LPSPI1_SDI to LPSPI Flash)
  - remove R1816 (GPIO_DISP_B2_12 to RGMII1_PHY_INTB)
  - add 0R to R404 (GPIO_AD_31 to WL_RST#)
  - add 0R to R1901 (GPIO_DISP_B2_11/BT_UART_RXD to M.2 (via 1.8V Levelshifter))
  - add 0R to R1902 (GPIO_DISP_B2_12/BT_UART_CTS to M.2 (via 1.8V Levelshifter))

  For the location of the resistors above please refer to the [front](docs/MIMXRT1170-EVKB%20UART%20Front.png) and [back](docs/MIMXRT1170-EVKB%20UART%20Back.png) board images
- **MIMXRT1060-EVK**
  - ToDo


# Build example

- by command line:
  ```
  west build nxp-zephyr/samples/bluetooth/a2dp_source
  ```
- by VSCode: \
  Simply press **Ctrl** + **Shift** + **B** (="Terminal"->"exeucte build job")

# Run example

- by VSCode: \
  Simply select connected debugger and press **F5**

  | Evaluation Board | on-board Debugger |
  |------------------|-------------------|
  | MIMXRT1170-EVKB  | CMSIS-DAP         |
  | MIMXRT1060-EVK   | JLINK             |
