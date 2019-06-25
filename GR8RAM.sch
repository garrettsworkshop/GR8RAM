EESchema Schematic File Version 4
EELAYER 29 0
EELAYER END
$Descr USLetter 11000 8500
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L power:+5V #PWR0120
U 1 1 607FA428
P 8100 5850
F 0 "#PWR0120" H 8100 5700 50  0001 C CNN
F 1 "+5V" H 8100 6000 50  0000 C CNN
F 2 "" H 8100 5850 50  0001 C CNN
F 3 "" H 8100 5850 50  0001 C CNN
	1    8100 5850
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C4
U 1 1 607FA429
P 9300 5950
F 0 "C4" H 9350 6000 50  0000 L CNN
F 1 "100n" H 9350 5900 50  0000 L CNN
F 2 "stdpads:C_0805" H 9300 5950 50  0001 C CNN
F 3 "~" H 9300 5950 50  0001 C CNN
	1    9300 5950
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C5
U 1 1 607FA42A
P 9700 5950
F 0 "C5" H 9750 6000 50  0000 L CNN
F 1 "100n" H 9750 5900 50  0000 L CNN
F 2 "stdpads:C_0805" H 9700 5950 50  0001 C CNN
F 3 "~" H 9700 5950 50  0001 C CNN
	1    9700 5950
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C7
U 1 1 607FA42B
P 8100 6450
F 0 "C7" H 8150 6500 50  0000 L CNN
F 1 "100n" H 8150 6400 50  0000 L CNN
F 2 "stdpads:C_0805" H 8100 6450 50  0001 C CNN
F 3 "~" H 8100 6450 50  0001 C CNN
	1    8100 6450
	1    0    0    -1  
$EndComp
Wire Wire Line
	9700 5850 10100 5850
Connection ~ 8500 6350
Wire Wire Line
	8100 6350 8500 6350
Wire Wire Line
	8500 6350 8900 6350
Wire Wire Line
	8500 6550 8900 6550
Wire Wire Line
	8500 6550 8100 6550
Connection ~ 8500 6550
Wire Wire Line
	10100 6050 9700 6050
Connection ~ 9700 5850
Connection ~ 9700 6050
$Comp
L Device:C_Small C8
U 1 1 5CC13922
P 8500 6450
F 0 "C8" H 8550 6500 50  0000 L CNN
F 1 "100n" H 8550 6400 50  0000 L CNN
F 2 "stdpads:C_0805" H 8500 6450 50  0001 C CNN
F 3 "~" H 8500 6450 50  0001 C CNN
	1    8500 6450
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C9
U 1 1 5CC13929
P 8900 6450
F 0 "C9" H 8950 6500 50  0000 L CNN
F 1 "100n" H 8950 6400 50  0000 L CNN
F 2 "stdpads:C_0805" H 8900 6450 50  0001 C CNN
F 3 "~" H 8900 6450 50  0001 C CNN
	1    8900 6450
	1    0    0    -1  
$EndComp
Connection ~ 9300 6350
Wire Wire Line
	8900 6350 9300 6350
Wire Wire Line
	9300 6350 9700 6350
Wire Wire Line
	9300 6550 9700 6550
Wire Wire Line
	9300 6550 8900 6550
Connection ~ 9300 6550
$Comp
L Device:C_Small C10
U 1 1 5CC28073
P 9300 6450
F 0 "C10" H 9350 6500 50  0000 L CNN
F 1 "100n" H 9350 6400 50  0000 L CNN
F 2 "stdpads:C_0805" H 9300 6450 50  0001 C CNN
F 3 "~" H 9300 6450 50  0001 C CNN
	1    9300 6450
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C11
U 1 1 5CC2807A
P 9700 6450
F 0 "C11" H 9750 6500 50  0000 L CNN
F 1 "100n" H 9750 6400 50  0000 L CNN
F 2 "stdpads:C_0805" H 9700 6450 50  0001 C CNN
F 3 "~" H 9700 6450 50  0001 C CNN
	1    9700 6450
	1    0    0    -1  
$EndComp
Connection ~ 8900 6350
Connection ~ 8900 6550
$Comp
L power:GND #PWR0145
U 1 1 5CB588B6
P 9700 6550
F 0 "#PWR0145" H 9700 6300 50  0001 C CNN
F 1 "GND" H 9700 6400 50  0000 C CNN
F 2 "" H 9700 6550 50  0001 C CNN
F 3 "" H 9700 6550 50  0001 C CNN
	1    9700 6550
	1    0    0    -1  
$EndComp
Text Label 5650 6750 0    50   ~ 0
RD3
Text Label 5650 6550 0    50   ~ 0
RD2
Text Label 5650 6650 0    50   ~ 0
RD0
Text Label 5650 6150 0    50   ~ 0
RD6
Text Label 5650 6350 0    50   ~ 0
RD7
Text Label 5650 6250 0    50   ~ 0
RD4
$Comp
L Device:C_Small C1
U 1 1 5D136B08
P 8100 5950
F 0 "C1" H 8150 6000 50  0000 L CNN
F 1 "100n" H 8150 5900 50  0000 L CNN
F 2 "stdpads:C_0805" H 8100 5950 50  0001 C CNN
F 3 "~" H 8100 5950 50  0001 C CNN
	1    8100 5950
	1    0    0    -1  
$EndComp
Connection ~ 8500 5850
$Comp
L Device:C_Small C6
U 1 1 5D140E8E
P 10100 5950
F 0 "C6" H 10150 6000 50  0000 L CNN
F 1 "100n" H 10150 5900 50  0000 L CNN
F 2 "stdpads:C_0805" H 10100 5950 50  0001 C CNN
F 3 "~" H 10100 5950 50  0001 C CNN
	1    10100 5950
	1    0    0    -1  
$EndComp
Wire Wire Line
	8500 5850 8900 5850
Wire Wire Line
	8500 6050 8900 6050
$Comp
L Device:C_Small C3
U 1 1 5D14D1AA
P 8900 5950
F 0 "C3" H 8950 6000 50  0000 L CNN
F 1 "100n" H 8950 5900 50  0000 L CNN
F 2 "stdpads:C_0805" H 8900 5950 50  0001 C CNN
F 3 "~" H 8900 5950 50  0001 C CNN
	1    8900 5950
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C2
U 1 1 5D14D1B0
P 8500 5950
F 0 "C2" H 8550 6000 50  0000 L CNN
F 1 "100n" H 8550 5900 50  0000 L CNN
F 2 "stdpads:C_0805" H 8500 5950 50  0001 C CNN
F 3 "~" H 8500 5950 50  0001 C CNN
	1    8500 5950
	1    0    0    -1  
$EndComp
Wire Wire Line
	8100 6050 8500 6050
Connection ~ 8500 6050
Wire Wire Line
	8500 5850 8100 5850
Connection ~ 8900 5850
Wire Wire Line
	8900 5850 9300 5850
Connection ~ 8900 6050
Wire Wire Line
	8900 6050 9300 6050
Connection ~ 9300 5850
Wire Wire Line
	9300 5850 9700 5850
Connection ~ 9300 6050
Wire Wire Line
	9300 6050 9700 6050
$Comp
L power:GND #PWR0110
U 1 1 5D1550D4
P 10100 6050
F 0 "#PWR0110" H 10100 5800 50  0001 C CNN
F 1 "GND" H 10100 5900 50  0000 C CNN
F 2 "" H 10100 6050 50  0001 C CNN
F 3 "" H 10100 6050 50  0001 C CNN
	1    10100 6050
	1    0    0    -1  
$EndComp
Connection ~ 10100 6050
$Comp
L power:+5V #PWR0111
U 1 1 5D155550
P 8100 6350
F 0 "#PWR0111" H 8100 6200 50  0001 C CNN
F 1 "+5V" H 8100 6500 50  0000 C CNN
F 2 "" H 8100 6350 50  0001 C CNN
F 3 "" H 8100 6350 50  0001 C CNN
	1    8100 6350
	1    0    0    -1  
$EndComp
Connection ~ 8100 6350
Connection ~ 8100 5850
$Comp
L Device:CP_Small C16
U 1 1 5D131416
P 2600 2450
F 0 "C16" H 2688 2496 50  0000 L CNN
F 1 "33u" H 2688 2405 50  0000 L CNN
F 2 "stdpads:CP_EIA-3528" H 2600 2450 50  0001 C CNN
F 3 "~" H 2600 2450 50  0001 C CNN
	1    2600 2450
	-1   0    0    -1  
$EndComp
$Comp
L Device:C_Small C15
U 1 1 5D131410
P 2200 2450
F 0 "C15" H 2250 2500 50  0000 L CNN
F 1 "100n" H 2250 2400 50  0000 L CNN
F 2 "stdpads:C_0805" H 2200 2450 50  0001 C CNN
F 3 "~" H 2200 2450 50  0001 C CNN
	1    2200 2450
	-1   0    0    -1  
$EndComp
$Comp
L power:-5V #PWR0112
U 1 1 5D12D2DF
P 2200 2900
F 0 "#PWR0112" H 2200 3000 50  0001 C CNN
F 1 "-5V" H 2200 3050 50  0000 C CNN
F 2 "" H 2200 2900 50  0001 C CNN
F 3 "" H 2200 2900 50  0001 C CNN
	1    2200 2900
	1    0    0    1   
$EndComp
Connection ~ 2200 2900
Wire Wire Line
	2200 2850 2200 2900
Wire Wire Line
	2200 2600 2200 2650
Wire Wire Line
	2200 2600 2600 2600
Wire Wire Line
	2200 2900 2600 2900
Wire Wire Line
	2600 2600 2600 2650
Wire Wire Line
	2600 2900 2600 2850
$Comp
L Device:CP_Small C18
U 1 1 5D12AB79
P 2600 2750
F 0 "C18" H 2688 2796 50  0000 L CNN
F 1 "33u" H 2688 2705 50  0000 L CNN
F 2 "stdpads:CP_EIA-3528" H 2600 2750 50  0001 C CNN
F 3 "~" H 2600 2750 50  0001 C CNN
	1    2600 2750
	-1   0    0    -1  
$EndComp
$Comp
L Device:C_Small C17
U 1 1 5D12AB6D
P 2200 2750
F 0 "C17" H 2250 2800 50  0000 L CNN
F 1 "100n" H 2250 2700 50  0000 L CNN
F 2 "stdpads:C_0805" H 2200 2750 50  0001 C CNN
F 3 "~" H 2200 2750 50  0001 C CNN
	1    2200 2750
	-1   0    0    -1  
$EndComp
Wire Wire Line
	2200 2550 2200 2600
Wire Wire Line
	2200 2300 2200 2350
Wire Wire Line
	2200 2300 2600 2300
Wire Wire Line
	2600 2300 2600 2350
Wire Wire Line
	2600 2600 2600 2550
$Comp
L power:+5V #PWR0146
U 1 1 5CB63982
P 2200 2300
F 0 "#PWR0146" H 2200 2150 50  0001 C CNN
F 1 "+5V" H 2200 2450 50  0000 C CNN
F 2 "" H 2200 2300 50  0001 C CNN
F 3 "" H 2200 2300 50  0001 C CNN
	1    2200 2300
	-1   0    0    -1  
$EndComp
Connection ~ 2200 2300
Connection ~ 2200 2600
Connection ~ 2600 2600
$Comp
L power:GND #PWR0115
U 1 1 5D171B70
P 2600 2600
F 0 "#PWR0115" H 2600 2350 50  0001 C CNN
F 1 "GND" H 2600 2450 50  0000 C CNN
F 2 "" H 2600 2600 50  0001 C CNN
F 3 "" H 2600 2600 50  0001 C CNN
	1    2600 2600
	0    -1   -1   0   
$EndComp
Text Label 5650 6050 0    50   ~ 0
RD5
Text Label 5650 6450 0    50   ~ 0
RD1
Connection ~ 9700 6550
Text Label 4650 6950 2    50   ~ 0
A11
Text Label 4650 7050 2    50   ~ 0
RA0
Text Label 4650 7150 2    50   ~ 0
RA1
Text Label 4650 7250 2    50   ~ 0
RA2
Text Label 4650 7350 2    50   ~ 0
RA3
Text Label 4650 7450 2    50   ~ 0
RA4
Text Label 4650 7550 2    50   ~ 0
RA5
Text Label 4650 7650 2    50   ~ 0
RA6
$Comp
L stdparts:39F040 U5
U 1 1 5D81337E
P 5150 6750
F 0 "U5" H 5150 7800 50  0000 C CNN
F 1 "39F040" V 5150 6750 50  0000 C CNN
F 2 "stdpads:PLCC-32" H 5150 6750 50  0001 C CNN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/25022B.pdf" H 5150 6750 50  0001 C CNN
	1    5150 6750
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0107
U 1 1 5D847F2B
P 5650 7650
F 0 "#PWR0107" H 5650 7400 50  0001 C CNN
F 1 "GND" H 5650 7500 50  0000 C CNN
F 2 "" H 5650 7650 50  0001 C CNN
F 3 "" H 5650 7650 50  0001 C CNN
	1    5650 7650
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0113
U 1 1 5D848386
P 5650 5850
F 0 "#PWR0113" H 5650 5700 50  0001 C CNN
F 1 "+5V" H 5650 6000 50  0000 C CNN
F 2 "" H 5650 5850 50  0001 C CNN
F 3 "" H 5650 5850 50  0001 C CNN
	1    5650 5850
	1    0    0    -1  
$EndComp
Text Label 4650 6250 2    50   ~ 0
A4
Text Label 4650 6350 2    50   ~ 0
A5
Text Label 4650 6450 2    50   ~ 0
A6
Text Label 4650 6550 2    50   ~ 0
A7
Text Label 4650 6150 2    50   ~ 0
A3
Text Label 4650 6050 2    50   ~ 0
A2
Text Label 4650 5950 2    50   ~ 0
A1
Text Label 4650 5850 2    50   ~ 0
A0
Text Label 4650 6650 2    50   ~ 0
A8
Text Label 4650 6850 2    50   ~ 0
A10
Text Label 4650 6750 2    50   ~ 0
A9
$Comp
L power:+5V #PWR0118
U 1 1 5DCF4586
P 1000 2000
F 0 "#PWR0118" H 1000 1850 50  0001 C CNN
F 1 "+5V" H 1000 2150 50  0000 C CNN
F 2 "" H 1000 2000 50  0001 C CNN
F 3 "" H 1000 2000 50  0001 C CNN
	1    1000 2000
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole FD5
U 1 1 5CC97C65
P 7550 6450
F 0 "FD5" H 7650 6496 50  0000 L CNN
F 1 "Fiducial" H 7650 6405 50  0000 L CNN
F 2 "stdpads:Fiducial" H 7550 6450 50  0001 C CNN
F 3 "~" H 7550 6450 50  0001 C CNN
	1    7550 6450
	1    0    0    -1  
$EndComp
Wire Wire Line
	7250 6050 6950 6050
Connection ~ 7250 6050
Wire Wire Line
	6950 6050 6650 6050
Connection ~ 6950 6050
Wire Wire Line
	6650 6050 6350 6050
Connection ~ 6650 6050
Connection ~ 7550 6050
Wire Wire Line
	7550 6050 7250 6050
$Comp
L power:GND #PWR0132
U 1 1 607FA437
P 7550 6050
F 0 "#PWR0132" H 7550 5800 50  0001 C CNN
F 1 "GND" H 7555 5877 50  0000 C CNN
F 2 "" H 7550 6050 50  0001 C CNN
F 3 "" H 7550 6050 50  0001 C CNN
	1    7550 6050
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole_Pad H5
U 1 1 5CC871F0
P 7550 5950
F 0 "H5" H 7650 6001 50  0000 L CNN
F 1 " " H 7650 5910 50  0000 L CNN
F 2 "stdpads:PasteHole_1.1mm_PTH" H 7550 5950 50  0001 C CNN
F 3 "~" H 7550 5950 50  0001 C CNN
	1    7550 5950
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole_Pad H4
U 1 1 5CC7E0C0
P 7250 5950
F 0 "H4" H 7350 6001 50  0000 L CNN
F 1 " " H 7350 5910 50  0000 L CNN
F 2 "stdpads:PasteHole_1.1mm_PTH" H 7250 5950 50  0001 C CNN
F 3 "~" H 7250 5950 50  0001 C CNN
	1    7250 5950
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole_Pad H3
U 1 1 607FA435
P 6950 5950
F 0 "H3" H 7050 6001 50  0000 L CNN
F 1 " " H 7050 5910 50  0000 L CNN
F 2 "stdpads:PasteHole_1.1mm_PTH" H 6950 5950 50  0001 C CNN
F 3 "~" H 6950 5950 50  0001 C CNN
	1    6950 5950
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole_Pad H2
U 1 1 607FA434
P 6650 5950
F 0 "H2" H 6750 6001 50  0000 L CNN
F 1 " " H 6750 5910 50  0000 L CNN
F 2 "stdpads:PasteHole_1.1mm_PTH" H 6650 5950 50  0001 C CNN
F 3 "~" H 6650 5950 50  0001 C CNN
	1    6650 5950
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole_Pad H1
U 1 1 607FA433
P 6350 5950
F 0 "H1" H 6450 6001 50  0000 L CNN
F 1 " " H 6450 5910 50  0000 L CNN
F 2 "stdpads:PasteHole_1.1mm_PTH" H 6350 5950 50  0001 C CNN
F 3 "~" H 6350 5950 50  0001 C CNN
	1    6350 5950
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole FD4
U 1 1 607FA432
P 6950 6450
F 0 "FD4" H 7050 6496 50  0000 L CNN
F 1 "Fiducial" H 7050 6405 50  0000 L CNN
F 2 "stdpads:Fiducial" H 6950 6450 50  0001 C CNN
F 3 "~" H 6950 6450 50  0001 C CNN
	1    6950 6450
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole FD3
U 1 1 607FA431
P 6350 6450
F 0 "FD3" H 6450 6496 50  0000 L CNN
F 1 "Fiducial" H 6450 6405 50  0000 L CNN
F 2 "stdpads:Fiducial" H 6350 6450 50  0001 C CNN
F 3 "~" H 6350 6450 50  0001 C CNN
	1    6350 6450
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole FD2
U 1 1 607FA430
P 6950 6250
F 0 "FD2" H 7050 6296 50  0000 L CNN
F 1 "Fiducial" H 7050 6205 50  0000 L CNN
F 2 "stdpads:Fiducial" H 6950 6250 50  0001 C CNN
F 3 "~" H 6950 6250 50  0001 C CNN
	1    6950 6250
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole FD1
U 1 1 607FA42F
P 6350 6250
F 0 "FD1" H 6450 6296 50  0000 L CNN
F 1 "Fiducial" H 6450 6205 50  0000 L CNN
F 2 "stdpads:Fiducial" H 6350 6250 50  0001 C CNN
F 3 "~" H 6350 6250 50  0001 C CNN
	1    6350 6250
	1    0    0    -1  
$EndComp
Text Label 1050 4100 2    50   ~ 0
TDI
Text Label 2550 6800 0    50   ~ 0
TCK
Text Label 1050 4300 2    50   ~ 0
~CAS~
Text Label 2550 4800 0    50   ~ 0
~RES~
Text Label 2550 4700 0    50   ~ 0
PHI1
Text Label 2550 6700 0    50   ~ 0
RA7
Text Label 2550 6600 0    50   ~ 0
RA8
Text Label 2550 6500 0    50   ~ 0
RA9
Text Label 2550 6400 0    50   ~ 0
RA10
Text Label 2550 4900 0    50   ~ 0
7M
Wire Wire Line
	2550 5000 2550 4900
Text Label 2550 4600 0    50   ~ 0
PHI0
$Comp
L stdparts:EPM7128SL84 U1
U 1 1 5CBA3E53
P 1800 5700
F 0 "U1" H 1800 5750 50  0000 C CNN
F 1 "EPM7128SL84" H 1800 5650 50  0000 C CNN
F 2 "stdpads:PLCC-84" H 1650 5900 50  0001 C CNN
F 3 "" H 1650 5900 50  0001 C CNN
	1    1800 5700
	1    0    0    -1  
$EndComp
Wire Wire Line
	1450 7800 1550 7800
Wire Wire Line
	1550 7800 1650 7800
Wire Wire Line
	1450 3700 1550 3700
Wire Wire Line
	1550 3700 1650 3700
Connection ~ 1450 3700
Connection ~ 1550 3700
Connection ~ 1650 3700
Wire Wire Line
	1650 3700 1750 3700
Wire Wire Line
	1750 3700 1850 3700
Connection ~ 1750 3700
Connection ~ 1850 3700
Wire Wire Line
	1850 3700 1950 3700
Wire Wire Line
	1950 3700 2050 3700
Connection ~ 1950 3700
Connection ~ 2050 3700
Wire Wire Line
	2050 3700 2150 3700
Connection ~ 1550 7800
Connection ~ 1650 7800
Wire Wire Line
	1650 7800 1750 7800
Wire Wire Line
	1750 7800 1850 7800
Connection ~ 1750 7800
Connection ~ 1850 7800
Wire Wire Line
	1850 7800 1950 7800
Wire Wire Line
	1950 7800 2050 7800
Connection ~ 1950 7800
Connection ~ 2050 7800
Wire Wire Line
	2050 7800 2150 7800
Connection ~ 2150 7800
Text Label 2550 4200 0    50   ~ 0
~IOSTRB~
Text Label 2550 4100 0    50   ~ 0
~INH~
Text Label 2550 4400 0    50   ~ 0
~IOSEL~
Text Label 2550 4500 0    50   ~ 0
R~W~
Text Label 2550 4300 0    50   ~ 0
~DEVSEL~
Text Label 1050 7300 2    50   ~ 0
A0
Text Label 1050 7200 2    50   ~ 0
A1
Text Label 1050 7100 2    50   ~ 0
A2
Text Label 1050 7000 2    50   ~ 0
A3
Text Label 2550 6900 0    50   ~ 0
RA6
Text Label 2550 7000 0    50   ~ 0
RA5
Text Label 2550 7100 0    50   ~ 0
RA4
Text Label 2550 7200 0    50   ~ 0
RA3
Text Label 2550 7300 0    50   ~ 0
RA2
Text Label 2550 7400 0    50   ~ 0
RA1
Text Label 2550 7500 0    50   ~ 0
RA0
Text Label 1050 6200 2    50   ~ 0
A11
Text Label 1050 6300 2    50   ~ 0
A10
Text Label 1050 6400 2    50   ~ 0
A9
Text Label 1050 6500 2    50   ~ 0
A8
Text Label 1050 6600 2    50   ~ 0
A7
Text Label 1050 6700 2    50   ~ 0
A6
Text Label 1050 6800 2    50   ~ 0
A5
Text Label 1050 6900 2    50   ~ 0
A4
$Comp
L power:GND #PWR0136
U 1 1 607FA42D
P 2150 7800
F 0 "#PWR0136" H 2150 7550 50  0001 C CNN
F 1 "GND" H 2150 7650 50  0000 C CNN
F 2 "" H 2150 7800 50  0001 C CNN
F 3 "" H 2150 7800 50  0001 C CNN
	1    2150 7800
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0135
U 1 1 607FA42C
P 1450 3700
F 0 "#PWR0135" H 1450 3550 50  0001 C CNN
F 1 "+5V" H 1450 3850 50  0000 C CNN
F 2 "" H 1450 3700 50  0001 C CNN
F 3 "" H 1450 3700 50  0001 C CNN
	1    1450 3700
	1    0    0    -1  
$EndComp
Text Label 5650 7150 0    50   ~ 0
RAMROM~CS~gb
NoConn ~ 1050 4700
Text Label 1600 2500 0    50   ~ 0
TCK
Text Label 1600 2600 0    50   ~ 0
TMS
Text Label 1600 2700 0    50   ~ 0
TDO
Text Label 1600 2800 0    50   ~ 0
TDI
$Comp
L power:GND #PWR0122
U 1 1 5DCF4205
P 1100 3200
F 0 "#PWR0122" H 1100 2950 50  0001 C CNN
F 1 "GND" H 1100 3050 50  0000 C CNN
F 2 "" H 1100 3200 50  0001 C CNN
F 3 "" H 1100 3200 50  0001 C CNN
	1    1100 3200
	1    0    0    -1  
$EndComp
$Comp
L Connector:AVR-JTAG-10 J2
U 1 1 5DCF2B5F
P 1100 2600
F 0 "J2" H 1100 2650 50  0000 C BNN
F 1 "JTAG" H 1100 2600 50  0000 C CNN
F 2 "Connector_IDC:IDC-Header_2x05_P2.54mm_Vertical" V 950 2750 50  0001 C CNN
F 3 " ~" H -175 2050 50  0001 C CNN
	1    1100 2600
	1    0    0    -1  
$EndComp
NoConn ~ 1100 2000
Wire Wire Line
	10050 900  10050 1000
Wire Wire Line
	9750 900  10050 900 
Wire Wire Line
	9750 1000 9750 900 
Wire Wire Line
	9450 1000 9750 1000
Wire Wire Line
	9450 900  9450 1000
Wire Wire Line
	9150 900  9450 900 
Wire Wire Line
	9150 1000 9150 900 
Wire Wire Line
	8850 1000 9150 1000
Wire Wire Line
	8850 900  8850 1000
Wire Wire Line
	8550 900  8850 900 
Wire Wire Line
	8550 1000 8550 900 
Wire Wire Line
	8250 1000 8550 1000
Wire Wire Line
	8250 900  8250 1000
Wire Wire Line
	7950 900  8250 900 
Wire Wire Line
	7950 1000 7950 900 
Wire Wire Line
	7650 1000 7950 1000
Wire Wire Line
	7650 900  7650 1000
Wire Wire Line
	7350 900  7650 900 
Wire Wire Line
	7350 1000 7350 900 
Wire Wire Line
	7050 1000 7350 1000
Wire Wire Line
	6750 1000 6750 900 
Wire Wire Line
	6450 1000 6750 1000
Wire Wire Line
	6450 900  6450 1000
Wire Wire Line
	6150 900  6450 900 
Wire Wire Line
	6150 1000 6150 900 
Wire Wire Line
	5850 1000 6150 1000
Wire Wire Line
	5850 900  5850 1000
Wire Wire Line
	5550 900  5850 900 
Wire Wire Line
	5550 1000 5550 900 
Text Notes 5050 1000 2    50   ~ 0
C7M
Wire Wire Line
	7050 900  7050 1000
Wire Wire Line
	5250 1000 5250 900 
Wire Wire Line
	5250 900  5150 900 
Wire Wire Line
	5250 1000 5550 1000
Wire Wire Line
	9800 1450 8900 1450
Wire Wire Line
	7700 1350 8900 1350
Wire Wire Line
	6800 1450 7700 1450
Wire Wire Line
	7700 1350 7700 1450
Wire Wire Line
	9800 1450 9800 1350
Wire Wire Line
	8900 1350 8900 1450
Text Notes 5050 1450 2    50   ~ 0
Q3
Wire Wire Line
	6800 1350 6800 1450
Wire Wire Line
	6800 1350 5600 1350
Wire Wire Line
	5600 1350 5600 1450
Wire Wire Line
	6750 900  7050 900 
Text Notes 6350 1000 0    40   ~ 0
S5
Text Notes 6950 1000 0    40   ~ 0
S6
Text Notes 5150 1000 0    40   ~ 0
S3
Wire Wire Line
	9800 1300 9800 1200
Wire Wire Line
	7700 1300 9800 1300
Wire Wire Line
	7700 1200 7700 1300
Wire Wire Line
	5600 1200 7700 1200
Wire Wire Line
	5600 1300 5600 1200
Text Notes 5050 1300 2    50   ~ 0
PHI1
Text Notes 8050 750  0    100  ~ 0
6502 CPU Access
Wire Wire Line
	9800 1050 9800 1150
Wire Wire Line
	7700 1050 9800 1050
Wire Wire Line
	7700 1150 7700 1050
Wire Wire Line
	5600 1150 7700 1150
Wire Wire Line
	5600 1050 5600 1150
Text Notes 5050 1150 2    50   ~ 0
PHI0
Wire Wire Line
	5150 1050 5600 1050
Wire Wire Line
	5600 1300 5150 1300
Wire Wire Line
	5150 1450 5600 1450
Wire Bus Line
	5550 750  5550 1600
Wire Bus Line
	7650 750  7650 1600
Wire Bus Line
	6150 850  6150 1500
Wire Bus Line
	6750 850  6750 1500
Wire Bus Line
	7350 850  7350 1500
Wire Bus Line
	7950 850  7950 1500
Wire Bus Line
	8550 850  8550 1500
Wire Bus Line
	9150 850  9150 1500
Wire Bus Line
	9750 750  9750 1600
Text Notes 7550 1000 0    40   ~ 0
S7
Wire Wire Line
	10050 1000 10150 1000
Wire Wire Line
	9800 1150 10150 1150
Wire Wire Line
	9800 1200 10150 1200
Wire Wire Line
	9800 1350 10150 1350
Text Notes 6050 750  0    104  ~ 0
Video Access
$Comp
L power:+5V #PWR0109
U 1 1 5D120CE1
P 3900 5000
F 0 "#PWR0109" H 3900 4850 50  0001 C CNN
F 1 "+5V" V 3900 5200 50  0000 C CNN
F 2 "" H 3900 5000 50  0001 C CNN
F 3 "" H 3900 5000 50  0001 C CNN
	1    3900 5000
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR0108
U 1 1 5D11FEA8
P 3400 5000
F 0 "#PWR0108" H 3400 4750 50  0001 C CNN
F 1 "GND" V 3400 4800 50  0000 C CNN
F 2 "" H 3400 5000 50  0001 C CNN
F 3 "" H 3400 5000 50  0001 C CNN
	1    3400 5000
	0    1    -1   0   
$EndComp
$Comp
L power:+12V #PWR0103
U 1 1 5CFFF62F
P 3400 7400
F 0 "#PWR0103" H 3400 7250 50  0001 C CNN
F 1 "+12V" V 3400 7550 50  0000 L CNN
F 2 "" H 3400 7400 50  0001 C CNN
F 3 "" H 3400 7400 50  0001 C CNN
	1    3400 7400
	0    -1   -1   0   
$EndComp
Text Label 3400 7300 2    50   ~ 0
D0
Text Label 3400 7200 2    50   ~ 0
D1
Text Label 3400 7100 2    50   ~ 0
D2
Text Label 3400 7000 2    50   ~ 0
D3
Text Label 3400 6900 2    50   ~ 0
D4
Text Label 3400 6800 2    50   ~ 0
D5
Text Label 3400 6700 2    50   ~ 0
D6
Text Label 3400 6600 2    50   ~ 0
D7
Text Label 3400 6500 2    50   ~ 0
~DEVSEL~
Text Label 3400 6400 2    50   ~ 0
PHI0
Text Label 3400 6300 2    50   ~ 0
USER1
Text Label 3400 6200 2    50   ~ 0
PHI1
Text Label 3400 6100 2    50   ~ 0
Q3
Text Label 3400 6000 2    50   ~ 0
7M
Text Label 3400 5900 2    50   ~ 0
COLORREF
$Comp
L power:-12V #PWR0102
U 1 1 5CFEEC44
P 3400 5700
F 0 "#PWR0102" H 3400 5800 50  0001 C CNN
F 1 "-12V" V 3400 5850 50  0000 L CNN
F 2 "" H 3400 5700 50  0001 C CNN
F 3 "" H 3400 5700 50  0001 C CNN
	1    3400 5700
	0    -1   -1   0   
$EndComp
$Comp
L power:-5V #PWR0101
U 1 1 5CFEFECE
P 3400 5800
F 0 "#PWR0101" H 3400 5900 50  0001 C CNN
F 1 "-5V" V 3400 5950 50  0000 L CNN
F 2 "" H 3400 5800 50  0001 C CNN
F 3 "" H 3400 5800 50  0001 C CNN
	1    3400 5800
	0    -1   -1   0   
$EndComp
$Comp
L Connector_Generic:Conn_02x25_Counter_Clockwise J1
U 1 1 5CFC517D
P 3700 6200
F 0 "J1" H 3750 4775 50  0000 C CNN
F 1 "AppleIIBus" H 3750 4866 50  0000 C CNN
F 2 "stdpads:AppleIIBus_Edge" H 3700 6200 50  0001 C CNN
F 3 "~" H 3700 6200 50  0001 C CNN
	1    3700 6200
	-1   0    0    1   
$EndComp
Text Label 3400 5600 2    50   ~ 0
~INH~
Text Label 3400 5500 2    50   ~ 0
~RES~
Text Label 3400 5400 2    50   ~ 0
~IRQ~
Text Label 3400 5300 2    50   ~ 0
~NMI~
Text Label 3400 5200 2    50   ~ 0
INTin
Text Label 3400 5100 2    50   ~ 0
DMAin
Text Label 3900 5100 0    50   ~ 0
DMAout
Text Label 3900 5200 0    50   ~ 0
INTout
Text Label 3900 5300 0    50   ~ 0
DMA
Text Label 3900 5400 0    50   ~ 0
RDY
Text Label 3900 5500 0    50   ~ 0
~IOSTRB~
Text Label 3900 5600 0    50   ~ 0
SYNC
Text Label 3900 5700 0    50   ~ 0
R~W~
Text Label 3900 5800 0    50   ~ 0
A15
Text Label 3900 5900 0    50   ~ 0
A14
Text Label 3900 6000 0    50   ~ 0
A13
Text Label 3900 6100 0    50   ~ 0
A12
Text Label 3900 6200 0    50   ~ 0
A11
Text Label 3900 6300 0    50   ~ 0
A10
Text Label 3900 6400 0    50   ~ 0
A9
Text Label 3900 6500 0    50   ~ 0
A8
Text Label 3900 6600 0    50   ~ 0
A7
Text Label 3900 6700 0    50   ~ 0
A6
Text Label 3900 6800 0    50   ~ 0
A5
Text Label 3900 6900 0    50   ~ 0
A4
Text Label 3900 7000 0    50   ~ 0
A3
Text Label 3900 7100 0    50   ~ 0
A2
Text Label 3900 7200 0    50   ~ 0
A1
Text Label 3900 7300 0    50   ~ 0
A0
Text Label 3900 7400 0    50   ~ 0
~IOSEL~
Text Notes 9750 1600 0    40   ~ 0
Latch WR data
Text Notes 8550 1600 0    40   ~ 0
Allow CS, OE, WE
Text Notes 6150 1650 0    40   ~ 0
Disallow CS, OE, WE\nIncrement addr. if attr.
NoConn ~ 1050 4600
NoConn ~ 2550 5100
Text Label 5650 7350 0    50   ~ 0
ROM~OE~
Text Label 1050 4400 2    50   ~ 0
ROM~OE~
Text Notes 5500 3550 0    50   ~ 0
S[2:0] = (S == 0) ? 0 : (~Q3~ & PHI1) ? 1 : S+1 @ C7M\n\nSyncCnt[1:0] = SYNC ? 2’b11 : \n                SyncCnt==0 ? 0 :\n                SyncCnt-1 @ C7M in S7\n\nBANKREG = (A==C0XF) & DEVSEL @ C7M in S7\nRAMREG = (A==C0X3) & DEVSEL @ C7M in S7\nADDRHI = (A==C0X2) & DEVSEL @ C7M in S7\nADDRMD = (A==C0X1) & DEVSEL @ C7M in S7\nADDRLO = (A==C0X0) & DEVSEL @ C7M in S7\n\nIOROMEN = (A==CFFF) ? 0 :\n            (A==CX00 & IOSEL) ? 1 :\n            IOROMEN @ C7M in S7\n\nAR[19:16] = D[3:0] @ C7M in S3 if ADDRHI & ~R~W\nAR[15:8] = D[7:0] @ C7M in S3 if ADDRMED & ~R~W\nAR[7:0] = D[7:0] @ C7M in S3 if ADDRLO & ~R~W\nAR[19:0]++ @ C7M in S4 if RAMREG\nBank[5:0] = D[5:0] @ C7M if BANKREG & ~R~W
Text Label 2550 4000 0    50   ~ 0
SYNC
Wire Wire Line
	9700 6350 10100 6350
Wire Wire Line
	9700 6550 10100 6550
$Comp
L Device:C_Small C12
U 1 1 5E680811
P 10100 6450
F 0 "C12" H 10150 6500 50  0000 L CNN
F 1 "100n" H 10150 6400 50  0000 L CNN
F 2 "stdpads:C_0805" H 10100 6450 50  0001 C CNN
F 3 "~" H 10100 6450 50  0001 C CNN
	1    10100 6450
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0124
U 1 1 5E680817
P 10100 6550
F 0 "#PWR0124" H 10100 6300 50  0001 C CNN
F 1 "GND" H 10100 6400 50  0000 C CNN
F 2 "" H 10100 6550 50  0001 C CNN
F 3 "" H 10100 6550 50  0001 C CNN
	1    10100 6550
	1    0    0    -1  
$EndComp
Connection ~ 10100 6550
Connection ~ 9700 6350
$Comp
L Device:C_Small C19
U 1 1 5E8640A9
P 4600 4450
F 0 "C19" H 4650 4500 50  0000 L CNN
F 1 "100n" H 4650 4400 50  0000 L CNN
F 2 "stdpads:C_0805" H 4600 4450 50  0001 C CNN
F 3 "~" H 4600 4450 50  0001 C CNN
	1    4600 4450
	-1   0    0    -1  
$EndComp
Wire Wire Line
	4600 4850 4600 4900
$Comp
L Device:C_Small C20
U 1 1 5E8640BA
P 4600 4750
F 0 "C20" H 4650 4800 50  0000 L CNN
F 1 "100n" H 4650 4700 50  0000 L CNN
F 2 "stdpads:C_0805" H 4600 4750 50  0001 C CNN
F 3 "~" H 4600 4750 50  0001 C CNN
	1    4600 4750
	-1   0    0    -1  
$EndComp
Wire Wire Line
	4600 4300 4600 4350
Wire Wire Line
	4600 4550 4600 4650
$Comp
L power:-12V #PWR0127
U 1 1 5E86FE3D
P 4600 4900
F 0 "#PWR0127" H 4600 5000 50  0001 C CNN
F 1 "-12V" H 4600 5050 50  0000 C CNN
F 2 "" H 4600 4900 50  0001 C CNN
F 3 "" H 4600 4900 50  0001 C CNN
	1    4600 4900
	-1   0    0    1   
$EndComp
$Comp
L power:+12V #PWR0128
U 1 1 5E875A47
P 4600 4300
F 0 "#PWR0128" H 4600 4150 50  0001 C CNN
F 1 "+12V" H 4600 4450 50  0000 C CNN
F 2 "" H 4600 4300 50  0001 C CNN
F 3 "" H 4600 4300 50  0001 C CNN
	1    4600 4300
	1    0    0    -1  
$EndComp
Text Label 2550 5200 0    50   ~ 0
Q3
Text Notes 5750 1000 0    40   ~ 0
S4
Text Notes 8150 1000 0    40   ~ 0
S1
Text Notes 8750 1000 0    40   ~ 0
S2
Text Notes 9350 1000 0    40   ~ 0
S3
Text Notes 9950 1000 0    40   ~ 0
S4
Text Label 5650 7250 0    50   ~ 0
ROM~WE~
Text Notes 5550 1550 0    40   ~ 0
Latch WR data
Text Notes 7950 1650 0    40   ~ 0
Latch addr. attr.\nSwitch ext. ROM
Text Notes 7600 3550 0    50   ~ 0
CSEN = S1 | S2 | S3 @ C7M\n\nD[7:0] = (~CSEN~ | ~DEVSEL~ | ~R~W) ? 8’bZ :\n          BANKREG ? Bank[5:0]\n          ADDRHI ? {4’hF, AR[19:16]} : \n          ADDRMED ? AR[15:8] : \n          ADDRLO ? AR[7:0]\n\nRA[19] = AR[19]\nRA[18:12] = RAMREG ? AR[18:12] : { SyncCnt[2:0]!=0, Bank[5:0] }\nRA[11:0] = AR[11:0]\n\nRAMROM~CS~ = ~IOSEL or IOSTRB~\nRAMCS = CSEN & RAMREG\nROM~OE~ = CSEN & (IOSEL | (IOSTRB & IOROMEN)) & R~W~\nROM~WE~ = CSEN & (IOSEL | (IOSTRB & IOROMEN)) & ~R~W
$Comp
L stdparts:AS4C4M4 U?
U 1 1 5D14F218
P 6000 4650
F 0 "U?" H 6000 5567 50  0000 C CNN
F 1 "AS4C4M4" H 6000 5476 50  0000 C CNN
F 2 "Package_SO:TSOP-II-44_10.16x18.41mm_P0.8mm" H 6000 3750 50  0001 C CNN
F 3 "https://www.alliancememory.com/wp-content/uploads/pdf/AS6C8008.pdf" H 6000 4200 50  0001 C CNN
	1    6000 4650
	1    0    0    -1  
$EndComp
$Comp
L stdparts:AS4C4M4 U?
U 1 1 5D15CF1C
P 7200 4650
F 0 "U?" H 7200 5567 50  0000 C CNN
F 1 "AS4C4M4" H 7200 5476 50  0000 C CNN
F 2 "Package_SO:TSOP-II-44_10.16x18.41mm_P0.8mm" H 7200 3750 50  0001 C CNN
F 3 "https://www.alliancememory.com/wp-content/uploads/pdf/AS6C8008.pdf" H 7200 4200 50  0001 C CNN
	1    7200 4650
	1    0    0    -1  
$EndComp
$Comp
L stdparts:AS4C4M4 U?
U 1 1 5D15E539
P 8400 4650
F 0 "U?" H 8400 5567 50  0000 C CNN
F 1 "AS4C4M4" H 8400 5476 50  0000 C CNN
F 2 "Package_SO:TSOP-II-44_10.16x18.41mm_P0.8mm" H 8400 3750 50  0001 C CNN
F 3 "https://www.alliancememory.com/wp-content/uploads/pdf/AS6C8008.pdf" H 8400 4200 50  0001 C CNN
	1    8400 4650
	1    0    0    -1  
$EndComp
$Comp
L stdparts:AS4C4M4 U?
U 1 1 5D15F385
P 9600 4650
F 0 "U?" H 9600 5567 50  0000 C CNN
F 1 "AS4C4M4" H 9600 5476 50  0000 C CNN
F 2 "Package_SO:TSOP-II-44_10.16x18.41mm_P0.8mm" H 9600 3750 50  0001 C CNN
F 3 "https://www.alliancememory.com/wp-content/uploads/pdf/AS6C8008.pdf" H 9600 4200 50  0001 C CNN
	1    9600 4650
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 5D16DCFA
P 6400 4000
F 0 "#PWR?" H 6400 3850 50  0001 C CNN
F 1 "+5V" H 6400 4150 50  0000 C CNN
F 2 "" H 6400 4000 50  0001 C CNN
F 3 "" H 6400 4000 50  0001 C CNN
	1    6400 4000
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 5D16E360
P 7600 4000
F 0 "#PWR?" H 7600 3850 50  0001 C CNN
F 1 "+5V" H 7600 4150 50  0000 C CNN
F 2 "" H 7600 4000 50  0001 C CNN
F 3 "" H 7600 4000 50  0001 C CNN
	1    7600 4000
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 5D16E8F4
P 8800 4000
F 0 "#PWR?" H 8800 3850 50  0001 C CNN
F 1 "+5V" H 8800 4150 50  0000 C CNN
F 2 "" H 8800 4000 50  0001 C CNN
F 3 "" H 8800 4000 50  0001 C CNN
	1    8800 4000
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 5D16EE0A
P 10000 4000
F 0 "#PWR?" H 10000 3850 50  0001 C CNN
F 1 "+5V" H 10000 4150 50  0000 C CNN
F 2 "" H 10000 4000 50  0001 C CNN
F 3 "" H 10000 4000 50  0001 C CNN
	1    10000 4000
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5D16F1FA
P 9200 5400
F 0 "#PWR?" H 9200 5150 50  0001 C CNN
F 1 "GND" H 9200 5250 50  0000 C CNN
F 2 "" H 9200 5400 50  0001 C CNN
F 3 "" H 9200 5400 50  0001 C CNN
	1    9200 5400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5D16F4A1
P 8000 5400
F 0 "#PWR?" H 8000 5150 50  0001 C CNN
F 1 "GND" H 8000 5250 50  0000 C CNN
F 2 "" H 8000 5400 50  0001 C CNN
F 3 "" H 8000 5400 50  0001 C CNN
	1    8000 5400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5D16F748
P 6800 5400
F 0 "#PWR?" H 6800 5150 50  0001 C CNN
F 1 "GND" H 6800 5250 50  0000 C CNN
F 2 "" H 6800 5400 50  0001 C CNN
F 3 "" H 6800 5400 50  0001 C CNN
	1    6800 5400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5D16FAE4
P 5600 5400
F 0 "#PWR?" H 5600 5150 50  0001 C CNN
F 1 "GND" H 5600 5250 50  0000 C CNN
F 2 "" H 5600 5400 50  0001 C CNN
F 3 "" H 5600 5400 50  0001 C CNN
	1    5600 5400
	1    0    0    -1  
$EndComp
Text Label 6400 4900 0    50   ~ 0
RD3
Text Label 6400 4700 0    50   ~ 0
RD2
Text Label 6400 4800 0    50   ~ 0
RD0
Text Label 6400 4300 0    50   ~ 0
RD6
Text Label 6400 4500 0    50   ~ 0
RD7
Text Label 6400 4400 0    50   ~ 0
RD4
Text Label 6400 4200 0    50   ~ 0
RD5
Text Label 6400 4600 0    50   ~ 0
RD1
Text Label 7600 4900 0    50   ~ 0
RD3
Text Label 7600 4700 0    50   ~ 0
RD2
Text Label 7600 4800 0    50   ~ 0
RD0
Text Label 7600 4300 0    50   ~ 0
RD6
Text Label 7600 4500 0    50   ~ 0
RD7
Text Label 7600 4400 0    50   ~ 0
RD4
Text Label 7600 4200 0    50   ~ 0
RD5
Text Label 7600 4600 0    50   ~ 0
RD1
Text Label 10000 4900 0    50   ~ 0
RD3
Text Label 10000 4700 0    50   ~ 0
RD2
Text Label 10000 4800 0    50   ~ 0
RD0
Text Label 10000 4300 0    50   ~ 0
RD6
Text Label 10000 4500 0    50   ~ 0
RD7
Text Label 10000 4400 0    50   ~ 0
RD4
Text Label 10000 4200 0    50   ~ 0
RD5
Text Label 10000 4600 0    50   ~ 0
RD1
Text Label 8800 4900 0    50   ~ 0
RD3
Text Label 8800 4700 0    50   ~ 0
RD2
Text Label 8800 4800 0    50   ~ 0
RD0
Text Label 8800 4300 0    50   ~ 0
RD6
Text Label 8800 4500 0    50   ~ 0
RD7
Text Label 8800 4400 0    50   ~ 0
RD4
Text Label 8800 4200 0    50   ~ 0
RD5
Text Label 8800 4600 0    50   ~ 0
RD1
Text Label 5600 4700 2    50   ~ 0
RA7
Text Label 5600 4800 2    50   ~ 0
RA8
Text Label 5600 4900 2    50   ~ 0
RA9
Text Label 5600 5000 2    50   ~ 0
RA10
Text Label 5600 4600 2    50   ~ 0
RA6
Text Label 5600 4500 2    50   ~ 0
RA5
Text Label 5600 4400 2    50   ~ 0
RA4
Text Label 5600 4300 2    50   ~ 0
RA3
Text Label 5600 4200 2    50   ~ 0
RA2
Text Label 5600 4100 2    50   ~ 0
RA1
Text Label 5600 4000 2    50   ~ 0
RA0
Text Label 6800 4700 2    50   ~ 0
RA7
Text Label 6800 4800 2    50   ~ 0
RA8
Text Label 6800 4900 2    50   ~ 0
RA9
Text Label 6800 5000 2    50   ~ 0
RA10
Text Label 6800 4600 2    50   ~ 0
RA6
Text Label 6800 4500 2    50   ~ 0
RA5
Text Label 6800 4400 2    50   ~ 0
RA4
Text Label 6800 4300 2    50   ~ 0
RA3
Text Label 6800 4200 2    50   ~ 0
RA2
Text Label 6800 4100 2    50   ~ 0
RA1
Text Label 6800 4000 2    50   ~ 0
RA0
Text Label 8000 4700 2    50   ~ 0
RA7
Text Label 8000 4800 2    50   ~ 0
RA8
Text Label 8000 4900 2    50   ~ 0
RA9
Text Label 8000 5000 2    50   ~ 0
RA10
Text Label 8000 4600 2    50   ~ 0
RA6
Text Label 8000 4500 2    50   ~ 0
RA5
Text Label 8000 4400 2    50   ~ 0
RA4
Text Label 8000 4300 2    50   ~ 0
RA3
Text Label 8000 4200 2    50   ~ 0
RA2
Text Label 8000 4100 2    50   ~ 0
RA1
Text Label 8000 4000 2    50   ~ 0
RA0
Text Label 9200 4700 2    50   ~ 0
RA7
Text Label 9200 4800 2    50   ~ 0
RA8
Text Label 9200 4900 2    50   ~ 0
RA9
Text Label 9200 5000 2    50   ~ 0
RA10
Text Label 9200 4600 2    50   ~ 0
RA6
Text Label 9200 4500 2    50   ~ 0
RA5
Text Label 9200 4400 2    50   ~ 0
RA4
Text Label 9200 4300 2    50   ~ 0
RA3
Text Label 9200 4200 2    50   ~ 0
RA2
Text Label 9200 4100 2    50   ~ 0
RA1
Text Label 9200 4000 2    50   ~ 0
RA0
$Comp
L power:GND #PWR?
U 1 1 5D1A5FD4
P 8800 5400
F 0 "#PWR?" H 8800 5150 50  0001 C CNN
F 1 "GND" H 8800 5250 50  0000 C CNN
F 2 "" H 8800 5400 50  0001 C CNN
F 3 "" H 8800 5400 50  0001 C CNN
	1    8800 5400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5D1A641A
P 6400 5400
F 0 "#PWR?" H 6400 5150 50  0001 C CNN
F 1 "GND" H 6400 5250 50  0000 C CNN
F 2 "" H 6400 5400 50  0001 C CNN
F 3 "" H 6400 5400 50  0001 C CNN
	1    6400 5400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5D1A66E3
P 10000 5400
F 0 "#PWR?" H 10000 5150 50  0001 C CNN
F 1 "GND" H 10000 5250 50  0000 C CNN
F 2 "" H 10000 5400 50  0001 C CNN
F 3 "" H 10000 5400 50  0001 C CNN
	1    10000 5400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5D1A6ED2
P 7600 5400
F 0 "#PWR?" H 7600 5150 50  0001 C CNN
F 1 "GND" H 7600 5250 50  0000 C CNN
F 2 "" H 7600 5400 50  0001 C CNN
F 3 "" H 7600 5400 50  0001 C CNN
	1    7600 5400
	1    0    0    -1  
$EndComp
Text Label 1050 4800 2    50   ~ 0
D7
Text Label 1050 5000 2    50   ~ 0
D6
Text Label 1050 5100 2    50   ~ 0
D5
Text Label 1050 5200 2    50   ~ 0
D4
Text Label 1050 5300 2    50   ~ 0
D3
Text Label 1050 5400 2    50   ~ 0
D2
Text Label 1050 5500 2    50   ~ 0
D1
Text Label 1050 4900 2    50   ~ 0
TMS
Text Label 2550 5500 0    50   ~ 0
D7
Text Label 2550 5700 0    50   ~ 0
D6
Text Label 2550 5800 0    50   ~ 0
D5
Text Label 2550 5900 0    50   ~ 0
D4
Text Label 2550 6100 0    50   ~ 0
D3
Text Label 2550 6200 0    50   ~ 0
D2
Text Label 2550 6300 0    50   ~ 0
D1
Text Label 2550 6000 0    50   ~ 0
TDO
Text Label 1050 4200 2    50   ~ 0
~RAS~
Text Label 1050 4500 2    50   ~ 0
R~WE~
NoConn ~ 1050 4000
$EndSCHEMATC
