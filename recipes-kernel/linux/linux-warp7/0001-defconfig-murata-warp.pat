diff --git a/arch/arm/configs/imx_v7_defconfig b/arch/arm/configs/imx_v7_defconfig
index 6512526..0c2948c 100644
--- a/arch/arm/configs/imx_v7_defconfig
+++ b/arch/arm/configs/imx_v7_defconfig
@@ -80,7 +80,7 @@ CONFIG_BT_HCIUART_H4=y
 # CONFIG_BT_HCIUART_ATH3K is not set
 CONFIG_BT_HCIBCM203X=y
 # CONFIG_BT_ATH3K is not set
-CONFIG_CFG80211=y
+CONFIG_CFG80211=n
 CONFIG_MAC80211=y
 CONFIG_DEVTMPFS=y
 CONFIG_DEVTMPFS_MOUNT=y
@@ -145,7 +145,7 @@ CONFIG_USB_RTL8150=m
 CONFIG_USB_RTL8152=m
 CONFIG_USB_USBNET=m
 CONFIG_USB_NET_CDC_EEM=m
-CONFIG_BCMDHD=m
+CONFIG_BCMDHD=n
 CONFIG_BCMDHD_SDIO=y
 CONFIG_BCMDHD_FW_PATH="/lib/firmware/bcm/1DX_BCM4343W/fw_bcmdhd.bin"
 CONFIG_BCMDHD_NVRAM_PATH="/lib/firmware/bcm/1DX_BCM4343W/bcmdhd.1DX.SDIO.cal"
