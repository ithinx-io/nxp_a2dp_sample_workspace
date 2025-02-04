# NXP Bluetooth A2DP Sample environment

west project to test NXP A2DP sample

# Initial project setup

This project contains a setup containing a [workspace file](https://code.visualstudio.com/docs/editor/workspaces) and [DevContainer](https://code.visualstudio.com/docs/devcontainers/containers) environment based on the official [Zephyr Docker setup](https://github.com/zephyrproject-rtos/docker-image) for [Visual Studio Code](https://code.visualstudio.com). \
Additionally it makes sure the required Zephyr Toolchains from the Zephyr Dockerfile are usable. \
To initialize:
- clone this repo containing the Zephyr DevContainer Workspace and the NXP-Zephyr as submodule:
  ```
  git clone <clone-url-of-this repo>
  ```
- Open the project by doubleClick on the [NXP.code-workspace](NXP.code-workspace) file. \
  VisualStudio Code will ask to `reopen the workspace in DevContainer`, please select `Reopen in Container` (mandatory!).
- After VSCode startup (will take some time for the initial docker container build), fetch/update NXP Zephyr and NXP HAL blobs:
  ```
  west update
  west blobs fetch hal_nxp
  ```

# Required Hardware rework

To run this sample on an EVK with M.2 wireless card some HW rework for BT/Audio ist necessary:
- **[MIMXRT1170-EVKB](https://mcuxpresso.nxp.com/mcuxsdk/24.12.00/html/middleware/edgefast_bluetooth/docs/HWRGEFBTPALUG/topics/MIMXRT1170-EVKB_Murata_1ZM.html)**
  - HCI UART rework
    - remove R183 (LPSPI1_SDI to LPSPI Flash)
    - remove R1816 (GPIO_DISP_B2_12 to RGMII1_PHY_INTB)
    - add 0R to R404 (GPIO_AD_31 to WL_RST#)
    - add 0R to R1901 (GPIO_DISP_B2_11/BT_UART_RXD to M.2 (via 1.8V Levelshifter))
    - add 0R to R1902 (GPIO_DISP_B2_12/BT_UART_CTS to M.2 (via 1.8V Levelshifter))
  - PCM interface rework
    - disconnect J79 (BT_PCM_SYNC -> BT_PCM_SYNC_1V8)
    - disconnect J80 (BT_PCM_BCLK -> BT_PCM_BCLK_1V8)
    - connect J81 (BT_PCM_BCLK_1V8 -> BT_PCM_BCLK)
    - connect J82 (BT_PCM_SYNC_1V8 -> BT_PCM_SYNC)
    - remove R1985 (GPIO_EMC_B2_13 -> SEMC_D28)
    - remove R1992 (GPIO_EMC_B2_13 -> DC_I2S3_RX_D0)
    - remove R1986 (GPIO_EMC_B2_14 -> SEMC_D29)
    - remove R1993 (GPIO_EMC_B2_14 -> DC_I2S3_TX_D0)
    - remove R1987 (GPIO_EMC_B2_15 -> SEMC_D30)
    - remove R1994 (GPIO_EMC_B2_15 -> DC_I2S3_TX_BCLK)
    - remove R1988 (GPIO_EMC_B2_16 -> SEMC_D31)
    - remove R1995 (GPIO_EMC_B2_16 -> DC_I2S3_TX_SYNC)
    - add 0R to R228 (GPIO_EMC_B2_13 -> BT_PCM_RXD)
    - add 0R to R229 (GPIO_EMC_B2_16 -> BT_PCM_SYNC)
    - add 0R to R232 (GPIO_EMC_B2_15 -> BT_PCM_BCLK)
    - add 0R to R234 (GPIO_EMC_B2_14 -> BT_PCM_TXD)
    - add 0R to R1903 (BT_PCM_RXD_1V8 -> BT_PCM_RXD)

  For the location of the resistors above please refer to the [front](docs/MIMXRT1170-EVKB%20UART%20Front.png) and [back](docs/MIMXRT1170-EVKB%20UART%20Back.png) board images

- **MIMXRT1060-EVKB**
  - HCI UART rework
    - mount R93   (GPIO_AD_B0_03 -> BT_UART_CTS)
    - mount R96   (GPIO_AD_B1_07 -> BT_UART_RXD)
    - mount R345  (GPIO_AD_B1_03 -> WL_RST#)
    - remove R193 (I2C3_SCL to GPIO_AD_B1_07)
    - mount R363  (GPIO_SD_B0_00 -> WIFI_SDIO_CMD)
    - remove R364 (GPIO_SD_B0_00 to SD1_CMD)
    - mount R365  (GPIO_SD_B0_01 -> WIFI_SDIO_CLK)
    - remove R366 (GPIO_SD_B0_01 to SD1_CLK)

  - PCM interface rework
    - remove  R86 (BT_PCM_BCLK -> BT_PCM_BCLK_1V8)
    - remove  R76 (BT_PCM_SYNC -> BT_PCM_SYNC_1V8)
    - connect R79 (BT_PCM_BCLK_1V8 -> BT_PCM_BCLK)
    - connect R70 (BT_PCM_SYNC_1V8 -> BT_PCM_SYNC)
    - remove R381 or R220 (ENET_RST -> KSZ8081RNB)
    - remove R87  (BT_PCM_RXD_1V8 -> BT_PCM_RXD)

    For the location of these resistors above please refer to the [schematics](docs/MIMXRT1060-EVKB-Schematics.pdf)

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
  west build -b <board> nxp-zephyr/samples/bluetooth/a2dp_source
  ```
  Supported evaluation boards:
  | Evaluation Board | build \<board> parameter | Device Tree Overlay File| additional Project Config File |
  |---|---|---|---|
  | NXP MIMXRT1060_EVK | **mimxrt1060_evk@qspi** | [mimxrt1060_evk_qspi.overlay](https://github.com/ithinx-io/nxp-zephyr/blob/feature/MCUX-74374-a2dp-source-sample-itx/samples/bluetooth/a2dp_source/boards/mimxrt1060_evk_qspi.overlay) | [mimxrt1060_evk_qspi.conf](https://github.com/ithinx-io/nxp-zephyr/blob/feature/MCUX-74374-a2dp-source-sample-itx/samples/bluetooth/a2dp_source/boards/mimxrt1060_evk_qspi.conf) |
  | NXP MIMXRT1060_EVKB | **mimxrt1060_evkb** | [mimxrt1060_evkb.conf](https://github.com/ithinx-io/nxp-zephyr/blob/feature/MCUX-74374-a2dp-source-sample-itx/samples/bluetooth/a2dp_source/boards/mimxrt1060_evkb.conf) | [mimxrt1060_evkb.overlay](https://github.com/ithinx-io/nxp-zephyr/blob/feature/MCUX-74374-a2dp-source-sample-itx/samples/bluetooth/a2dp_source/boards/mimxrt1060_evkb.overlay) |
  | NXP MIMXRT1170_EVK  | **mimxrt1170_evk@B/mimxrt1176/cm7** | [mimxrt1170_evk_mimxrt1176_cm7_B.overlay](https://github.com/ithinx-io/nxp-zephyr/blob/feature/MCUX-74374-a2dp-source-sample-itx/samples/bluetooth/a2dp_source/boards/mimxrt1170_evk_mimxrt1176_cm7_B.overlay) | [mimxrt1170_evk_mimxrt1176_cm7_B.conf](https://github.com/ithinx-io/nxp-zephyr/blob/feature/MCUX-74374-a2dp-source-sample-itx/samples/bluetooth/a2dp_source/boards/mimxrt1170_evk_mimxrt1176_cm7_B.conf) |

- by VSCode: \
  Simply press **Ctrl** + **Shift** + **B** (="Terminal"->"exeucte build job"). \
  The build options (board, device, build dir) can be changed in the [workspace config section](NXP.code-workspace#L21-L39).

# Run example

- by VSCode: \
  Simply select connected debugger and press **F5**

  | Evaluation Board | on-board Debugger |
  |------------------|-------------------|
  | MIMXRT1170-EVKB  | CMSIS-DAP         |
  | MIMXRT1060-EVK   | JLINK             |
