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

- **MIMXRT1060-EVKB**
  - HCI UART rework
    - mount R93   (GPIO_AD_B0_03 -> BT_UART_CTS)
    - mount R96   (GPIO_AD_B1_07 -> BT_UART_RXD)
    - mount R345  (GPIO_AD_B1_03 -> WL_RST#)
    - remove R193 (I2C3_SCL to GPIO_AD_B1_07)
    - mount R363  (GPIO_SD_B0_00 -> WIFI_SDIO_CMD)
    - remove R364 (GPIO_SD_B0_00 to SD1_CMD)
    - mount R363  (GPIO_SD_B0_01 -> WIFI_SDIO_CLK)
    - remove R364 (GPIO_SD_B0_01 to SD1_CLK)

  - PCM interface rework
    - remove  R86 (BT_PCM_BCLK -> BT_PCM_BCLK_1V8)
    - remove  R76 (BT_PCM_SYNC -> BT_PCM_SYNC_1V8)
    - connect R79 (BT_PCM_BCLK_1V8 -> BT_PCM_BCLK)
    - connect R70 (BT_PCM_SYNC_1V8 -> BT_PCM_SYNC)
    - remove R381 or R220 (ENET_RST -> KSZ8081RNB)
    - remove R87  (BT_PCM_RXD_1V8 -> BT_PCM_RXD)

    For the location of these resistors above please refer to the [front](docs/MIMXRT1060-EVK%20PCM%20Front.png) and [back](docs/MIMXRT1060-EVK%20PCM%20Back.png) board images and [schematics](docs/MIMXRT1060-EVKB-Schematics.pdf)

- **[MIMXRT1060-EVKC](https://mcuxpresso.nxp.com/mcuxsdk/24.12.00/html/middleware/edgefast_bluetooth/docs/HWRGEFBTPALUG/topics/RT1060EVKC_Murata_1XKM2.html#hardware-rework)**
  - HCI UART rework
    - mount R93    (BT_UART_CTS to GPIO_AD_B0_03)
    - mount R96    (BT_UART_RXD to GPIO_AD_B1_07)
    - connect J109 (GPIO_AD_B1_03 -> WL_RST#)
    - connect J76 2-3 (SDIO0_SD1_SEL=0) \
      routing GPIO_SD_B0_00->WIFI_SDIO_CMD & GPIO_SD_B0_01_B->WIFI_SDIO_CLK

  - PCM interface rework
    - remove  J54 (BT_PCM_BCLK -> BT_PCM_BCLK_1V8)
    - remove  J55 (BT_PCM_SYNC -> BT_PCM_SYNC_1V8)
    - connect J56 (BT_PCM_BCLK_1V8 -> BT_PCM_BCLK)
    - connect J57 (BT_PCM_SYNC_1V8 -> BT_PCM_SYNC)
    - remove R220 (ENET_RST -> KSZ8081RNB)
    - remove J103 (BT_PCM_RXD_1V8 -> BT_PCM_RXD)

    For the location of these resistors above please refer to the [front](docs/MIMXRT1170-EVKC%20Front.png) board image and [schematics](docs/MIMXRT1060-EVKC-Schematics.pdf).

    Note: When J103 is connected, flash cannot be downloaded. So, remove the connection when downloading flash and reconnect it after downloading.

MIMXRT1060-EVK PCM Back.png

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
