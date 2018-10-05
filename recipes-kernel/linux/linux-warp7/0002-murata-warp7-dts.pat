diff --git a/arch/arm/boot/dts/imx7s-warp.dts b/arch/arm/boot/dts/imx7s-warp.dts
index 98ed810..38f2a87 100644
--- a/arch/arm/boot/dts/imx7s-warp.dts
+++ b/arch/arm/boot/dts/imx7s-warp.dts
@@ -66,26 +66,14 @@
 		};
 	};
 
-	bcmdhd_wlan_0: bcmdhd_wlan@0 {
-		compatible = "android,bcmdhd_wlan";
-		/* WL_HOST_WAKE=GPIO<5,11>, WL_REG_ON=GPIO<5,10>  */
-		gpios = <&gpio5 11 0>, <&gpio5 10 0>;
-		wlreg_on-supply = <&wlreg_on>;
-	};
-
 	regulators {
 		compatible = "simple-bus";
 		#address-cells = <1>;
 		#size-cells = <0>;
 
-		wlreg_on: fixedregulator@100 {
-			compatible = "regulator-fixed";
-			regulator-min-microvolt = <5000000>;
-			regulator-max-microvolt = <5000000>;
-			regulator-name = "wlreg_on";
-			gpio = <&gpio5 10 0>; /* GPIO drives WL_REG_ON signal */
-			startup-delay-us = <100>;
-			enable-active-high;
+		usdhc1_pwrseq: usdhc1_pwrseq {		/* add construct for "fmac" to control WL_REG_ON signal */
+			compatible = "mmc-pwrseq-simple";
+			reset-gpios = <&gpio5 10 GPIO_ACTIVE_LOW>; /* WL REG ON */
 		};
 	};
 
@@ -414,15 +402,25 @@
 };
 
 &usdhc1 {
-	pinctrl-names = "default", "state_100mhz", "state_200mhz";
-	pinctrl-0 = <&pinctrl_usdhc1>; /* "default entry selected as Murata 1DX */
-	pinctrl-1 = <&pinctrl_usdhc1_100mhz>;
-	pinctrl-2 = <&pinctrl_usdhc1_200mhz>;
+	#address-cells = <1>;
+	#size-cells = <0>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_usdhc1>;
 	keep-power-in-suspend;
-	enable-sdio-wakeup;
-	tuning-step = <2>;
-	wifi-host; /* Murata -- add hook for SD card detect mechanism */
+	non-removable;
+	mmc-pwrseq = <&usdhc1_pwrseq>;
+	pm-ignore-notify;
+	no-1-8-v;
 	status = "okay";
+	brcmf: bcrmf@1 {
+		reg = <1>;
+		compatible = "brcm,bcm4329-fmac";
+		interrupt-parent = <&gpio5>;
+		interrupts = <11 IRQ_TYPE_LEVEL_HIGH>; /* WL_HOST_WAKE = GPIO5_IO11 active high. */
+		interrupt-names = "host-wake";
+		brcm,broken_sg_support;
+		brcm,sd_sgentry_align =/bits/ 16 <16>;
+	};
 };
 
 &usdhc3 {
@@ -507,11 +505,11 @@
 
 		pinctrl_uart3: uart3grp {
 			fsl,pins = <
-				MX7D_PAD_UART3_TX_DATA__UART3_DCE_TX 0x79
-				MX7D_PAD_UART3_RX_DATA__UART3_DCE_RX 0x79
-				MX7D_PAD_UART3_CTS_B__UART3_DCE_CTS 0x79
-				MX7D_PAD_UART3_RTS_B__UART3_DCE_RTS 0x79
-				MX7D_PAD_SD2_DATA3__GPIO5_IO17 0x14/*BT_REG_ON*/
+				MX7D_PAD_UART3_TX_DATA__UART3_DCE_TX	0x79
+				MX7D_PAD_UART3_RX_DATA__UART3_DCE_RX	0x79
+				MX7D_PAD_UART3_CTS_B__UART3_DCE_CTS	0x79
+				MX7D_PAD_UART3_RTS_B__UART3_DCE_RTS	0x79
+				MX7D_PAD_SD2_DATA3__GPIO5_IO17		0x14	/*BT_REG_ON*/
 				/* BT_REG_ON is on GPIO5 IO17 and must be toggle to reset the device */
 			>;
 		};
@@ -524,7 +522,8 @@
 				MX7D_PAD_SD1_DATA1__SD1_DATA1           0x59
 				MX7D_PAD_SD1_DATA2__SD1_DATA2           0x59
 				MX7D_PAD_SD1_DATA3__SD1_DATA3           0x59
-				MX7D_PAD_SD2_WP__GPIO5_IO10             0x59
+				MX7D_PAD_SD2_WP__GPIO5_IO10             0x19	/* WL_REG_ON - 100K PD */
+				MX7D_PAD_SD2_RESET_B__GPIO5_IO11	0x19	/* WL_HOST_WAKE - 100K PD */
 			>;
 		};
 
@@ -535,8 +534,7 @@
 				MX7D_PAD_SD1_DATA0__SD1_DATA0           0x5a
 				MX7D_PAD_SD1_DATA1__SD1_DATA1           0x5a
 				MX7D_PAD_SD1_DATA2__SD1_DATA2           0x5a
-				MX7D_PAD_SD1_DATA3__SD1_DATA3           0x5a
-				MX7D_PAD_SD2_WP__GPIO5_IO10             0x59 
+				MX7D_PAD_SD1_DATA3__SD1_DATA3           0x5a 
 			>;
 		};
 
@@ -547,8 +545,7 @@
 				MX7D_PAD_SD1_DATA0__SD1_DATA0           0x5b
 				MX7D_PAD_SD1_DATA1__SD1_DATA1           0x5b
 				MX7D_PAD_SD1_DATA2__SD1_DATA2           0x5b
-				MX7D_PAD_SD1_DATA3__SD1_DATA3           0x5b
-				MX7D_PAD_SD2_WP__GPIO5_IO10             0x59 
+				MX7D_PAD_SD1_DATA3__SD1_DATA3           0x5b 
 			>;
 		};
 
