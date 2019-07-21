EESchema Schematic File Version 4
LIBS:GR8RAM-cache
EELAYER 29 0
EELAYER END
$Descr USLetter 11000 8500
encoding utf-8
Sheet 1 1
Title "GR8RAM"
Date "2019-07-21"
Rev "0.1"
Comp "Garrett's Workshop"
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L power:+5V #PWR0120
U 1 1 607FA428
P 7700 5850
F 0 "#PWR0120" H 7700 5700 50  0001 C CNN
F 1 "+5V" H 7700 6000 50  0000 C CNN
F 2 "" H 7700 5850 50  0001 C CNN
F 3 "" H 7700 5850 50  0001 C CNN
	1    7700 5850
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C4
U 1 1 607FA429
P 8900 5950
F 0 "C4" H 8950 6000 50  0000 L CNN
F 1 "100n" H 8950 5900 50  0000 L CNN
F 2 "stdpads:C_0805" H 8900 5950 50  0001 C CNN
F 3 "~" H 8900 5950 50  0001 C CNN
	1    8900 5950
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C5
U 1 1 607FA42A
P 9300 5950
F 0 "C5" H 9350 6000 50  0000 L CNN
F 1 "100n" H 9350 5900 50  0000 L CNN
F 2 "stdpads:C_0805" H 9300 5950 50  0001 C CNN
F 3 "~" H 9300 5950 50  0001 C CNN
	1    9300 5950
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C7
U 1 1 607FA42B
P 10100 5950
F 0 "C7" H 10150 6000 50  0000 L CNN
F 1 "100n" H 10150 5900 50  0000 L CNN
F 2 "stdpads:C_0805" H 10100 5950 50  0001 C CNN
F 3 "~" H 10100 5950 50  0001 C CNN
	1    10100 5950
	1    0    0    -1  
$EndComp
Wire Wire Line
	9300 5850 9700 5850
Connection ~ 8100 6350
Wire Wire Line
	7700 6350 8100 6350
Wire Wire Line
	8100 6350 8500 6350
Wire Wire Line
	8100 6550 8500 6550
Wire Wire Line
	8100 6550 7700 6550
Connection ~ 8100 6550
Wire Wire Line
	9700 6050 9300 6050
Connection ~ 9300 5850
Connection ~ 9300 6050
$Comp
L Device:C_Small C8
U 1 1 5CC13922
P 7700 6450
F 0 "C8" H 7750 6500 50  0000 L CNN
F 1 "100n" H 7750 6400 50  0000 L CNN
F 2 "stdpads:C_0805" H 7700 6450 50  0001 C CNN
F 3 "~" H 7700 6450 50  0001 C CNN
	1    7700 6450
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C9
U 1 1 5CC13929
P 8100 6450
F 0 "C9" H 8150 6500 50  0000 L CNN
F 1 "100n" H 8150 6400 50  0000 L CNN
F 2 "stdpads:C_0805" H 8100 6450 50  0001 C CNN
F 3 "~" H 8100 6450 50  0001 C CNN
	1    8100 6450
	1    0    0    -1  
$EndComp
Connection ~ 8900 6350
Wire Wire Line
	8500 6350 8900 6350
Wire Wire Line
	8900 6350 9300 6350
Wire Wire Line
	8900 6550 9300 6550
Wire Wire Line
	8900 6550 8500 6550
Connection ~ 8900 6550
$Comp
L Device:C_Small C10
U 1 1 5CC28073
P 8500 6450
F 0 "C10" H 8550 6500 50  0000 L CNN
F 1 "100n" H 8550 6400 50  0000 L CNN
F 2 "stdpads:C_0805" H 8500 6450 50  0001 C CNN
F 3 "~" H 8500 6450 50  0001 C CNN
	1    8500 6450
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C11
U 1 1 5CC2807A
P 8900 6450
F 0 "C11" H 8950 6500 50  0000 L CNN
F 1 "100n" H 8950 6400 50  0000 L CNN
F 2 "stdpads:C_0805" H 8900 6450 50  0001 C CNN
F 3 "~" H 8900 6450 50  0001 C CNN
	1    8900 6450
	1    0    0    -1  
$EndComp
Connection ~ 8500 6350
Connection ~ 8500 6550
Text Label 5450 6250 0    50   ~ 0
RD2
$Comp
L Device:C_Small C1
U 1 1 5D136B08
P 7700 5950
F 0 "C1" H 7750 6000 50  0000 L CNN
F 1 "100n" H 7750 5900 50  0000 L CNN
F 2 "stdpads:C_0805" H 7700 5950 50  0001 C CNN
F 3 "~" H 7700 5950 50  0001 C CNN
	1    7700 5950
	1    0    0    -1  
$EndComp
Connection ~ 8100 5850
$Comp
L Device:C_Small C6
U 1 1 5D140E8E
P 9700 5950
F 0 "C6" H 9750 6000 50  0000 L CNN
F 1 "100n" H 9750 5900 50  0000 L CNN
F 2 "stdpads:C_0805" H 9700 5950 50  0001 C CNN
F 3 "~" H 9700 5950 50  0001 C CNN
	1    9700 5950
	1    0    0    -1  
$EndComp
Wire Wire Line
	8100 5850 8500 5850
Wire Wire Line
	8100 6050 8500 6050
$Comp
L Device:C_Small C3
U 1 1 5D14D1AA
P 8500 5950
F 0 "C3" H 8550 6000 50  0000 L CNN
F 1 "100n" H 8550 5900 50  0000 L CNN
F 2 "stdpads:C_0805" H 8500 5950 50  0001 C CNN
F 3 "~" H 8500 5950 50  0001 C CNN
	1    8500 5950
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C2
U 1 1 5D14D1B0
P 8100 5950
F 0 "C2" H 8150 6000 50  0000 L CNN
F 1 "100n" H 8150 5900 50  0000 L CNN
F 2 "stdpads:C_0805" H 8100 5950 50  0001 C CNN
F 3 "~" H 8100 5950 50  0001 C CNN
	1    8100 5950
	1    0    0    -1  
$EndComp
Wire Wire Line
	7700 6050 8100 6050
Connection ~ 8100 6050
Wire Wire Line
	8100 5850 7700 5850
Connection ~ 8500 5850
Wire Wire Line
	8500 5850 8900 5850
Connection ~ 8500 6050
Wire Wire Line
	8500 6050 8900 6050
Connection ~ 8900 5850
Wire Wire Line
	8900 5850 9300 5850
Connection ~ 8900 6050
Wire Wire Line
	8900 6050 9300 6050
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
Connection ~ 9700 6050
$Comp
L power:+5V #PWR0111
U 1 1 5D155550
P 7700 6350
F 0 "#PWR0111" H 7700 6200 50  0001 C CNN
F 1 "+5V" H 7700 6500 50  0000 C CNN
F 2 "" H 7700 6350 50  0001 C CNN
F 3 "" H 7700 6350 50  0001 C CNN
	1    7700 6350
	1    0    0    -1  
$EndComp
Connection ~ 7700 6350
Connection ~ 7700 5850
$Comp
L Device:CP_Small C14
U 1 1 5D131416
P 2800 2650
F 0 "C14" H 2888 2696 50  0000 L CNN
F 1 "33u" H 2888 2605 50  0000 L CNN
F 2 "stdpads:CP_EIA-3528" H 2800 2650 50  0001 C CNN
F 3 "~" H 2800 2650 50  0001 C CNN
	1    2800 2650
	1    0    0    -1  
$EndComp
Wire Wire Line
	3200 3050 3200 3100
$Comp
L Device:C_Small C17
U 1 1 5D12AB6D
P 3200 2950
F 0 "C17" H 3250 3000 50  0000 L CNN
F 1 "100n" H 3250 2900 50  0000 L CNN
F 2 "stdpads:C_0805" H 3200 2950 50  0001 C CNN
F 3 "~" H 3200 2950 50  0001 C CNN
	1    3200 2950
	1    0    0    -1  
$EndComp
Wire Wire Line
	2800 2500 2800 2550
Wire Wire Line
	2800 2800 2800 2750
$Comp
L power:+5V #PWR0146
U 1 1 5CB63982
P 2800 2500
F 0 "#PWR0146" H 2800 2350 50  0001 C CNN
F 1 "+5V" H 2800 2650 50  0000 C CNN
F 2 "" H 2800 2500 50  0001 C CNN
F 3 "" H 2800 2500 50  0001 C CNN
	1    2800 2500
	1    0    0    -1  
$EndComp
Text Label 5450 6050 0    50   ~ 0
RD0
Connection ~ 9300 6550
$Comp
L stdparts:39F040 U2
U 1 1 5D81337E
P 4950 6750
F 0 "U2" H 4950 7800 50  0000 C CNN
F 1 "39F040" V 4950 6750 50  0000 C CNN
F 2 "stdpads:PLCC-32_SMDSocket" H 4950 6750 50  0001 C CNN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/25022B.pdf" H 4950 6750 50  0001 C CNN
	1    4950 6750
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0107
U 1 1 5D847F2B
P 5450 7650
F 0 "#PWR0107" H 5450 7400 50  0001 C CNN
F 1 "GND" H 5450 7500 50  0000 C CNN
F 2 "" H 5450 7650 50  0001 C CNN
F 3 "" H 5450 7650 50  0001 C CNN
	1    5450 7650
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0113
U 1 1 5D848386
P 5450 5850
F 0 "#PWR0113" H 5450 5700 50  0001 C CNN
F 1 "+5V" H 5450 6000 50  0000 C CNN
F 2 "" H 5450 5850 50  0001 C CNN
F 3 "" H 5450 5850 50  0001 C CNN
	1    5450 5850
	1    0    0    -1  
$EndComp
Text Label 4450 6250 2    50   ~ 0
A4
Text Label 4450 6350 2    50   ~ 0
A5
Text Label 4450 6450 2    50   ~ 0
A6
Text Label 4450 6550 2    50   ~ 0
A7
Text Label 4450 6150 2    50   ~ 0
A3
Text Label 4450 6050 2    50   ~ 0
A2
Text Label 4450 5950 2    50   ~ 0
A1
Text Label 4450 5850 2    50   ~ 0
A0
Text Label 4450 6650 2    50   ~ 0
A8
Text Label 4450 6850 2    50   ~ 0
A10
Text Label 4450 6750 2    50   ~ 0
A9
$Comp
L power:+5V #PWR0118
U 1 1 5DCF4586
P 1350 2000
F 0 "#PWR0118" H 1350 1850 50  0001 C CNN
F 1 "+5V" H 1350 2150 50  0000 C CNN
F 2 "" H 1350 2000 50  0001 C CNN
F 3 "" H 1350 2000 50  0001 C CNN
	1    1350 2000
	1    0    0    -1  
$EndComp
Wire Wire Line
	6850 6050 6550 6050
Connection ~ 6850 6050
Wire Wire Line
	6550 6050 6250 6050
Connection ~ 6550 6050
Wire Wire Line
	6250 6050 5950 6050
Connection ~ 6250 6050
Connection ~ 7150 6050
Wire Wire Line
	7150 6050 6850 6050
$Comp
L power:GND #PWR0132
U 1 1 607FA437
P 7150 6050
F 0 "#PWR0132" H 7150 5800 50  0001 C CNN
F 1 "GND" H 7155 5877 50  0000 C CNN
F 2 "" H 7150 6050 50  0001 C CNN
F 3 "" H 7150 6050 50  0001 C CNN
	1    7150 6050
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole_Pad H5
U 1 1 5CC871F0
P 7150 5950
F 0 "H5" H 7250 6001 50  0000 L CNN
F 1 " " H 7250 5910 50  0000 L CNN
F 2 "stdpads:PasteHole_1.1mm_PTH" H 7150 5950 50  0001 C CNN
F 3 "~" H 7150 5950 50  0001 C CNN
	1    7150 5950
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole_Pad H4
U 1 1 5CC7E0C0
P 6850 5950
F 0 "H4" H 6950 6001 50  0000 L CNN
F 1 " " H 6950 5910 50  0000 L CNN
F 2 "stdpads:PasteHole_1.1mm_PTH" H 6850 5950 50  0001 C CNN
F 3 "~" H 6850 5950 50  0001 C CNN
	1    6850 5950
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole_Pad H3
U 1 1 607FA435
P 6550 5950
F 0 "H3" H 6650 6001 50  0000 L CNN
F 1 " " H 6650 5910 50  0000 L CNN
F 2 "stdpads:PasteHole_1.1mm_PTH" H 6550 5950 50  0001 C CNN
F 3 "~" H 6550 5950 50  0001 C CNN
	1    6550 5950
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole_Pad H2
U 1 1 607FA434
P 6250 5950
F 0 "H2" H 6350 6001 50  0000 L CNN
F 1 " " H 6350 5910 50  0000 L CNN
F 2 "stdpads:PasteHole_1.1mm_PTH" H 6250 5950 50  0001 C CNN
F 3 "~" H 6250 5950 50  0001 C CNN
	1    6250 5950
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole_Pad H1
U 1 1 607FA433
P 5950 5950
F 0 "H1" H 6050 6001 50  0000 L CNN
F 1 " " H 6050 5910 50  0000 L CNN
F 2 "stdpads:PasteHole_1.1mm_PTH" H 5950 5950 50  0001 C CNN
F 3 "~" H 5950 5950 50  0001 C CNN
	1    5950 5950
	1    0    0    -1  
$EndComp
Text Label 1050 4100 2    50   ~ 0
TDI
Text Label 2550 6800 0    50   ~ 0
TCK
Text Label 1050 6400 2    50   ~ 0
~CAS~1
Text Label 2550 4800 0    50   ~ 0
~RES~
Text Label 2550 4700 0    50   ~ 0
PHI1r
Text Label 2550 7200 0    50   ~ 0
RA6
Text Label 2550 7100 0    50   ~ 0
RA8
Text Label 1050 6800 2    50   ~ 0
RA9
Text Label 1050 6900 2    50   ~ 0
RA10
Text Label 2550 4900 0    50   ~ 0
7Mr
Wire Wire Line
	2550 5000 2550 4900
Text Label 2550 4300 0    50   ~ 0
PHI0r
Text Label 1050 5000 2    50   ~ 0
~IOSTRB~
Text Label 1050 4800 2    50   ~ 0
~INH~
Text Label 2550 5800 0    50   ~ 0
~IOSEL~
Text Label 1050 4600 2    50   ~ 0
R~W~
Text Label 1050 4700 2    50   ~ 0
~DEVSEL~
Text Label 2550 5600 0    50   ~ 0
A0
Text Label 2550 5500 0    50   ~ 0
A1
Text Label 2550 5400 0    50   ~ 0
A2
Text Label 2550 5300 0    50   ~ 0
A3
Text Label 2550 7300 0    50   ~ 0
RA7
Text Label 2550 7400 0    50   ~ 0
RA4
Text Label 2550 7500 0    50   ~ 0
RA1
Text Label 1050 7300 2    50   ~ 0
RA0
Text Label 1050 7200 2    50   ~ 0
RA5
Text Label 1050 7100 2    50   ~ 0
RA2
Text Label 1050 7000 2    50   ~ 0
RA3
Text Label 1050 4000 2    50   ~ 0
A11
Text Label 2550 4000 0    50   ~ 0
A10
Text Label 2550 4100 0    50   ~ 0
A9
Text Label 2550 4200 0    50   ~ 0
A8
Text Label 2550 4500 0    50   ~ 0
A7
Text Label 2550 4600 0    50   ~ 0
A6
Text Label 2550 5100 0    50   ~ 0
A5
Text Label 2550 5200 0    50   ~ 0
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
Text Label 1950 2500 0    50   ~ 0
TCK
Text Label 1950 2600 0    50   ~ 0
TMS
Text Label 1950 2700 0    50   ~ 0
TDO
Text Label 1950 2800 0    50   ~ 0
TDI
$Comp
L power:GND #PWR0122
U 1 1 5DCF4205
P 1450 3200
F 0 "#PWR0122" H 1450 2950 50  0001 C CNN
F 1 "GND" H 1450 3050 50  0000 C CNN
F 2 "" H 1450 3200 50  0001 C CNN
F 3 "" H 1450 3200 50  0001 C CNN
	1    1450 3200
	1    0    0    -1  
$EndComp
$Comp
L Connector:AVR-JTAG-10 J2
U 1 1 5DCF2B5F
P 1450 2600
F 0 "J2" H 1450 2650 50  0000 C BNN
F 1 "JTAG" H 1450 2600 50  0000 C CNN
F 2 "stdpads:IDC_SMD_2x05_P2.54mm_Vertical" V 1300 2750 50  0001 C CNN
F 3 " ~" H 175 2050 50  0001 C CNN
	1    1450 2600
	1    0    0    -1  
$EndComp
NoConn ~ 1450 2000
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
Text Label 1050 6700 2    50   ~ 0
R~OE~
Wire Wire Line
	9300 6350 9700 6350
Wire Wire Line
	9300 6550 9700 6550
$Comp
L Device:C_Small C12
U 1 1 5E680811
P 9300 6450
F 0 "C12" H 9350 6500 50  0000 L CNN
F 1 "100n" H 9350 6400 50  0000 L CNN
F 2 "stdpads:C_0805" H 9300 6450 50  0001 C CNN
F 3 "~" H 9300 6450 50  0001 C CNN
	1    9300 6450
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0124
U 1 1 5E680817
P 9700 6550
F 0 "#PWR0124" H 9700 6300 50  0001 C CNN
F 1 "GND" H 9700 6400 50  0000 C CNN
F 2 "" H 9700 6550 50  0001 C CNN
F 3 "" H 9700 6550 50  0001 C CNN
	1    9700 6550
	1    0    0    -1  
$EndComp
Connection ~ 9700 6550
Connection ~ 9300 6350
$Comp
L Device:C_Small C19
U 1 1 5E8640A9
P 4100 2650
F 0 "C19" H 4150 2700 50  0000 L CNN
F 1 "100n" H 4150 2600 50  0000 L CNN
F 2 "stdpads:C_0805" H 4100 2650 50  0001 C CNN
F 3 "~" H 4100 2650 50  0001 C CNN
	1    4100 2650
	1    0    0    -1  
$EndComp
Wire Wire Line
	4100 3050 4100 3100
$Comp
L Device:C_Small C20
U 1 1 5E8640BA
P 4100 2950
F 0 "C20" H 4150 3000 50  0000 L CNN
F 1 "100n" H 4150 2900 50  0000 L CNN
F 2 "stdpads:C_0805" H 4100 2950 50  0001 C CNN
F 3 "~" H 4100 2950 50  0001 C CNN
	1    4100 2950
	1    0    0    -1  
$EndComp
Wire Wire Line
	4100 2500 4100 2550
$Comp
L power:-12V #PWR0127
U 1 1 5E86FE3D
P 4100 3100
F 0 "#PWR0127" H 4100 3200 50  0001 C CNN
F 1 "-12V" H 4100 3250 50  0000 C CNN
F 2 "" H 4100 3100 50  0001 C CNN
F 3 "" H 4100 3100 50  0001 C CNN
	1    4100 3100
	1    0    0    1   
$EndComp
$Comp
L power:+12V #PWR0128
U 1 1 5E875A47
P 4100 2500
F 0 "#PWR0128" H 4100 2350 50  0001 C CNN
F 1 "+12V" H 4100 2650 50  0000 C CNN
F 2 "" H 4100 2500 50  0001 C CNN
F 3 "" H 4100 2500 50  0001 C CNN
	1    4100 2500
	-1   0    0    -1  
$EndComp
Text Label 2550 4400 0    50   ~ 0
Q3r
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
Text Notes 5550 1550 0    40   ~ 0
Latch WR data
Text Notes 7950 1650 0    40   ~ 0
Latch addr. attr.\nSwitch ext. ROM
Text Label 7600 4450 0    50   ~ 0
RD7
Text Label 7600 4650 0    50   ~ 0
RD4
Text Label 7600 4550 0    50   ~ 0
RD5
$Comp
L power:GND #PWR0104
U 1 1 5D1A5FD4
P 8800 5300
F 0 "#PWR0104" H 8800 5050 50  0001 C CNN
F 1 "GND" H 8800 5150 50  0000 C CNN
F 2 "" H 8800 5300 50  0001 C CNN
F 3 "" H 8800 5300 50  0001 C CNN
	1    8800 5300
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0105
U 1 1 5D1A641A
P 6400 5300
F 0 "#PWR0105" H 6400 5050 50  0001 C CNN
F 1 "GND" H 6400 5150 50  0000 C CNN
F 2 "" H 6400 5300 50  0001 C CNN
F 3 "" H 6400 5300 50  0001 C CNN
	1    6400 5300
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0106
U 1 1 5D1A66E3
P 10000 5300
F 0 "#PWR0106" H 10000 5050 50  0001 C CNN
F 1 "GND" H 10000 5150 50  0000 C CNN
F 2 "" H 10000 5300 50  0001 C CNN
F 3 "" H 10000 5300 50  0001 C CNN
	1    10000 5300
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0114
U 1 1 5D1A6ED2
P 7600 5300
F 0 "#PWR0114" H 7600 5050 50  0001 C CNN
F 1 "GND" H 7600 5150 50  0000 C CNN
F 2 "" H 7600 5300 50  0001 C CNN
F 3 "" H 7600 5300 50  0001 C CNN
	1    7600 5300
	1    0    0    -1  
$EndComp
Text Label 2550 6900 0    50   ~ 0
RD7
Text Label 2550 5900 0    50   ~ 0
RD0
Text Label 1050 4900 2    50   ~ 0
TMS
Text Label 1050 5100 2    50   ~ 0
D7
Text Label 1050 5200 2    50   ~ 0
D6
Text Label 1050 5300 2    50   ~ 0
D5
Text Label 1050 5900 2    50   ~ 0
D2
Text Label 1050 6000 2    50   ~ 0
D1
Text Label 2550 6000 0    50   ~ 0
TDO
Text Label 2550 7000 0    50   ~ 0
~RAS~
Text Label 1050 6100 2    50   ~ 0
D0
Text Label 1050 4500 2    50   ~ 0
A15
Text Label 1050 4400 2    50   ~ 0
A14
Text Label 1050 4300 2    50   ~ 0
A13
Text Label 1050 4200 2    50   ~ 0
A12
NoConn ~ 1950 2400
NoConn ~ 1950 2300
Text Label 9200 4250 2    50   ~ 0
RA2
Text Label 9200 4650 2    50   ~ 0
RA4
Text Label 9200 4750 2    50   ~ 0
RA7
Text Label 9200 5150 2    50   ~ 0
RA10
Text Label 9200 5050 2    50   ~ 0
RA9
Text Label 9200 4950 2    50   ~ 0
RA8
Text Label 9200 4850 2    50   ~ 0
RA6
Text Label 6400 5000 0    50   ~ 0
R~WE~
Text Label 6400 4800 0    50   ~ 0
~CAS~0
Text Label 6400 4900 0    50   ~ 0
~RAS~
Text Label 7600 4800 0    50   ~ 0
~CAS~0
Text Label 7600 4900 0    50   ~ 0
~RAS~
Text Label 7600 5000 0    50   ~ 0
R~WE~
Text Label 8800 4800 0    50   ~ 0
~CAS~1
Text Label 8800 4900 0    50   ~ 0
~RAS~
Text Label 8800 5000 0    50   ~ 0
R~WE~
Text Label 10000 4800 0    50   ~ 0
~CAS~1
Text Label 10000 4900 0    50   ~ 0
~RAS~
Text Label 10000 5000 0    50   ~ 0
R~WE~
Connection ~ 10000 5300
Wire Wire Line
	10000 5100 10000 5300
$Comp
L power:+5V #PWR0116
U 1 1 5D16EE0A
P 10000 4150
F 0 "#PWR0116" H 10000 4000 50  0001 C CNN
F 1 "+5V" H 10000 4300 50  0000 C CNN
F 2 "" H 10000 4150 50  0001 C CNN
F 3 "" H 10000 4150 50  0001 C CNN
	1    10000 4150
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0117
U 1 1 5D16E8F4
P 8800 4150
F 0 "#PWR0117" H 8800 4000 50  0001 C CNN
F 1 "+5V" H 8800 4300 50  0000 C CNN
F 2 "" H 8800 4150 50  0001 C CNN
F 3 "" H 8800 4150 50  0001 C CNN
	1    8800 4150
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0119
U 1 1 5D16E360
P 7600 4150
F 0 "#PWR0119" H 7600 4000 50  0001 C CNN
F 1 "+5V" H 7600 4300 50  0000 C CNN
F 2 "" H 7600 4150 50  0001 C CNN
F 3 "" H 7600 4150 50  0001 C CNN
	1    7600 4150
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0121
U 1 1 5D16DCFA
P 6400 4150
F 0 "#PWR0121" H 6400 4000 50  0001 C CNN
F 1 "+5V" H 6400 4300 50  0000 C CNN
F 2 "" H 6400 4150 50  0001 C CNN
F 3 "" H 6400 4150 50  0001 C CNN
	1    6400 4150
	1    0    0    -1  
$EndComp
$Comp
L stdparts:AS4C4M4 U6
U 1 1 5D15F385
P 9600 4750
F 0 "U6" H 9600 5350 50  0000 C CNN
F 1 "AS4C4M4" V 9600 4750 50  0000 C CNN
F 2 "stdpads:SOP-24-26-300mil" H 9600 3850 50  0001 C CNN
F 3 "https://www.alliancememory.com/wp-content/uploads/pdf/AS6C8008.pdf" H 9600 4300 50  0001 C CNN
	1    9600 4750
	1    0    0    -1  
$EndComp
$Comp
L stdparts:AS4C4M4 U5
U 1 1 5D15E539
P 8400 4750
F 0 "U5" H 8400 5350 50  0000 C CNN
F 1 "AS4C4M4" V 8400 4750 50  0000 C CNN
F 2 "stdpads:SOP-24-26-300mil" H 8400 3850 50  0001 C CNN
F 3 "https://www.alliancememory.com/wp-content/uploads/pdf/AS6C8008.pdf" H 8400 4300 50  0001 C CNN
	1    8400 4750
	1    0    0    -1  
$EndComp
$Comp
L stdparts:AS4C4M4 U4
U 1 1 5D15CF1C
P 7200 4750
F 0 "U4" H 7200 5350 50  0000 C CNN
F 1 "AS4C4M4" V 7200 4750 50  0000 C CNN
F 2 "stdpads:SOP-24-26-300mil" H 7200 3850 50  0001 C CNN
F 3 "https://www.alliancememory.com/wp-content/uploads/pdf/AS6C8008.pdf" H 7200 4300 50  0001 C CNN
	1    7200 4750
	1    0    0    -1  
$EndComp
$Comp
L stdparts:AS4C4M4 U3
U 1 1 5D14F218
P 6000 4750
F 0 "U3" H 6000 5350 50  0000 C CNN
F 1 "AS4C4M4" V 6000 4750 50  0000 C CNN
F 2 "stdpads:SOP-24-26-300mil" H 6000 3850 50  0001 C CNN
F 3 "https://www.alliancememory.com/wp-content/uploads/pdf/AS6C8008.pdf" H 6000 4300 50  0001 C CNN
	1    6000 4750
	1    0    0    -1  
$EndComp
Text Label 5450 7350 0    50   ~ 0
R~OE~
Text Label 5450 7250 0    50   ~ 0
R~WE~
Text Label 5450 7150 0    50   ~ 0
R~CS~
Text Label 1050 6300 2    50   ~ 0
~CAS~0
Text Label 1050 6500 2    50   ~ 0
R~CS~
Text Notes 5150 3750 0    50   ~ 0
S[2:0] = (S == 0) ? 0 : (~Q3~ & PHI1) ? 1 : S+1 @ C7M\n\nBANKREG = (A==C0XF) & DEVSEL & REGEN @ C7M in S7\nRAMREG = (A==C0X3) & DEVSEL & REGEN @ C7M in S7\nADDRHI = (A==C0X2) & DEVSEL & REGEN @ C7M in S7\nADDRMD = (A==C0X1) & DEVSEL & REGEN @ C7M in S7\nADDRLO = (A==C0X0) & DEVSEL & REGEN @ C7M in S7\n\nREGEN = IOSEL ? 1 : REGEN @ C7M in S7\nROMEN = (A==CFFF) ? 0 :\n          (A==CX00 & IOSEL) ? 1 :\n          IOROMEN @ C7M in S7\n\nAR[22:16] = D[3:0] @ C7M in S3 if ADDRHI & ~R~W\nAR[15:8] = D[7:0] @ C7M in S3 if ADDRMED & ~R~W\nAR[7:0] = D[7:0] @ C7M in S3 if ADDRLO & ~R~W\nAR[22:0]++ @ C7M in S4 if RAMREG\nBank[7:0] = (S3 & BANKREG & ~R~W) ? D[7:0] @ C7M
Text Notes 5050 1750 2    50   ~ 0
~RAS~
Text Notes 5050 1900 2    50   ~ 0
~CAS~
Text Notes 5050 2050 2    50   ~ 0
R~WE~ovrd
Wire Wire Line
	5150 1750 5600 1750
Wire Wire Line
	5150 1900 5600 1900
Wire Wire Line
	5600 1900 5600 1800
Wire Wire Line
	6500 1800 6500 1900
Text Notes 6150 1650 0    40   ~ 0
Disallow CS, OE, WE\nIncrement addr. if attr.
Wire Wire Line
	5600 1750 5600 1650
Wire Wire Line
	8900 1800 8900 1900
Wire Wire Line
	5600 1800 6500 1800
Text Label 1050 5800 2    50   ~ 0
D3
Text Label 1050 5400 2    50   ~ 0
D4
Text Label 2550 6400 0    50   ~ 0
R~WE~
Text Label 6800 4150 2    50   ~ 0
RA3
Text Label 6800 4250 2    50   ~ 0
RA2
Text Label 6800 4350 2    50   ~ 0
RA5
Text Label 6800 4450 2    50   ~ 0
RA0
Text Label 6800 4550 2    50   ~ 0
RA1
Text Label 6800 4650 2    50   ~ 0
RA4
Text Label 6800 4750 2    50   ~ 0
RA7
Text Label 6800 5150 2    50   ~ 0
RA10
Text Label 6800 5050 2    50   ~ 0
RA9
Text Label 6800 4950 2    50   ~ 0
RA8
Text Label 6800 4850 2    50   ~ 0
RA6
Text Label 2550 6700 0    50   ~ 0
RD5
Text Label 2550 6600 0    50   ~ 0
RD6
Text Label 5600 5150 2    50   ~ 0
RA0
Text Label 5600 4950 2    50   ~ 0
RA4
Text Label 5600 4150 2    50   ~ 0
RA5
Text Label 5600 4850 2    50   ~ 0
RA7
Text Label 5600 4250 2    50   ~ 0
RA2
Text Label 5600 4350 2    50   ~ 0
RA3
Text Label 5600 4650 2    50   ~ 0
RA8
Text Label 5600 4750 2    50   ~ 0
RA6
Text Label 5600 4550 2    50   ~ 0
RA9
Text Label 5600 4450 2    50   ~ 0
RA10
Text Label 8000 4750 2    50   ~ 0
RA6
Text Label 8000 4650 2    50   ~ 0
RA8
Text Label 8000 4550 2    50   ~ 0
RA9
Text Label 8000 4450 2    50   ~ 0
RA10
Text Label 8000 4850 2    50   ~ 0
RA7
Text Label 8000 4950 2    50   ~ 0
RA4
Text Label 8000 5050 2    50   ~ 0
RA1
Text Label 8000 5150 2    50   ~ 0
RA0
Text Label 8000 4150 2    50   ~ 0
RA5
Text Label 8000 4250 2    50   ~ 0
RA2
Text Label 8000 4350 2    50   ~ 0
RA3
Text Label 6400 4650 0    50   ~ 0
RD0
Text Label 5450 6750 0    50   ~ 0
RD7
Text Label 2550 6500 0    50   ~ 0
RD4
Text Label 5450 6650 0    50   ~ 0
RD6
Text Label 2550 6200 0    50   ~ 0
RD2
Text Label 6400 4550 0    50   ~ 0
RD2
Text Label 5450 6550 0    50   ~ 0
RD5
Text Label 6400 4450 0    50   ~ 0
RD3
Text Label 2550 6300 0    50   ~ 0
RD3
Text Label 5450 6450 0    50   ~ 0
RD4
Text Label 2550 6100 0    50   ~ 0
RD1
Text Label 6400 4350 0    50   ~ 0
RD1
Text Label 5450 6350 0    50   ~ 0
RD3
Text Label 5450 6150 0    50   ~ 0
RD1
Text Label 7600 4350 0    50   ~ 0
RD6
Text Label 8800 4650 0    50   ~ 0
RD0
Text Label 8800 4550 0    50   ~ 0
RD2
Text Label 8800 4450 0    50   ~ 0
RD3
Text Label 8800 4350 0    50   ~ 0
RD1
Text Label 10000 4450 0    50   ~ 0
RD7
Text Label 10000 4650 0    50   ~ 0
RD4
Text Label 10000 4550 0    50   ~ 0
RD5
Text Label 10000 4350 0    50   ~ 0
RD6
$Comp
L Device:C_Small C13
U 1 1 5D8AF05B
P 9700 6450
F 0 "C13" H 9750 6500 50  0000 L CNN
F 1 "100n" H 9750 6400 50  0000 L CNN
F 2 "stdpads:C_0805" H 9700 6450 50  0001 C CNN
F 3 "~" H 9700 6450 50  0001 C CNN
	1    9700 6450
	1    0    0    -1  
$EndComp
Wire Wire Line
	10100 6050 9700 6050
Connection ~ 10100 6050
Wire Wire Line
	9700 5850 10100 5850
Connection ~ 9700 5850
Connection ~ 2800 2500
$Comp
L Device:CP_Small C15
U 1 1 5D8F9202
P 3200 2650
F 0 "C15" H 3288 2696 50  0000 L CNN
F 1 "33u" H 3288 2605 50  0000 L CNN
F 2 "stdpads:CP_EIA-3528" H 3200 2650 50  0001 C CNN
F 3 "~" H 3200 2650 50  0001 C CNN
	1    3200 2650
	1    0    0    -1  
$EndComp
Wire Wire Line
	2800 2500 3200 2500
Wire Wire Line
	3200 2500 3200 2550
$Comp
L power:GND #PWR0115
U 1 1 5D908483
P 2800 2800
F 0 "#PWR0115" H 2800 2550 50  0001 C CNN
F 1 "GND" H 2800 2650 50  0000 C CNN
F 2 "" H 2800 2800 50  0001 C CNN
F 3 "" H 2800 2800 50  0001 C CNN
	1    2800 2800
	1    0    0    -1  
$EndComp
$Comp
L Device:CP_Small C16
U 1 1 5D908489
P 3600 2650
F 0 "C16" H 3688 2696 50  0000 L CNN
F 1 "33u" H 3688 2605 50  0000 L CNN
F 2 "stdpads:CP_EIA-3528" H 3600 2650 50  0001 C CNN
F 3 "~" H 3600 2650 50  0001 C CNN
	1    3600 2650
	1    0    0    -1  
$EndComp
Wire Wire Line
	3200 2500 3600 2500
Wire Wire Line
	3600 2500 3600 2550
Connection ~ 3200 2500
Wire Wire Line
	4100 2750 4100 2800
Connection ~ 4100 2800
Wire Wire Line
	4100 2800 4100 2850
Connection ~ 2800 2800
Wire Wire Line
	3200 2750 3200 2800
Wire Wire Line
	2800 2800 3200 2800
Connection ~ 3200 2800
Wire Wire Line
	3200 2800 3200 2850
$Comp
L Device:R_Small R3
U 1 1 5DA0D6EB
P 4300 4050
F 0 "R3" V 4150 4050 50  0000 C CNN
F 1 "100" V 4250 4050 50  0000 C BNN
F 2 "stdpads:R_0805" H 4300 4050 50  0001 C CNN
F 3 "~" H 4300 4050 50  0001 C CNN
	1    4300 4050
	0    1    1    0   
$EndComp
$Comp
L Device:R_Small R2
U 1 1 5DA6C816
P 4300 4300
F 0 "R2" V 4150 4300 50  0000 C CNN
F 1 "100" V 4250 4300 50  0000 C BNN
F 2 "stdpads:R_0805" H 4300 4300 50  0001 C CNN
F 3 "~" H 4300 4300 50  0001 C CNN
	1    4300 4300
	0    1    1    0   
$EndComp
$Comp
L Device:R_Small R4
U 1 1 5DA6CBE2
P 4300 4550
F 0 "R4" V 4150 4550 50  0000 C CNN
F 1 "100" V 4250 4550 50  0000 C BNN
F 2 "stdpads:R_0805" H 4300 4550 50  0001 C CNN
F 3 "~" H 4300 4550 50  0001 C CNN
	1    4300 4550
	0    1    1    0   
$EndComp
$Comp
L Device:R_Small R1
U 1 1 5DA6CCA5
P 4300 3800
F 0 "R1" V 4150 3800 50  0000 C CNN
F 1 "100" V 4250 3800 50  0000 C BNN
F 2 "stdpads:R_0805" H 4300 3800 50  0001 C CNN
F 3 "~" H 4300 3800 50  0001 C CNN
	1    4300 3800
	0    1    1    0   
$EndComp
Text Label 4400 4300 0    50   ~ 0
PHI1r
Text Label 4400 4550 0    50   ~ 0
7Mr
Text Label 4400 4050 0    50   ~ 0
Q3r
Text Label 4400 3800 0    50   ~ 0
PHI0r
Text Label 4200 4300 2    50   ~ 0
PHI1
Text Label 4200 4550 2    50   ~ 0
7M
Text Label 4200 4050 2    50   ~ 0
Q3
Text Label 4200 3800 2    50   ~ 0
PHI0
$Comp
L Device:R_Small R5
U 1 1 5DAC3CAB
P 3250 3750
F 0 "R5" H 3309 3796 50  0000 L CNN
F 1 "820" H 3309 3705 50  0000 L CNN
F 2 "stdpads:R_0805" H 3250 3750 50  0001 C CNN
F 3 "~" H 3250 3750 50  0001 C CNN
	1    3250 3750
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0123
U 1 1 5DAD2F03
P 3050 3850
F 0 "#PWR0123" H 3050 3600 50  0001 C CNN
F 1 "GND" H 3055 3677 50  0000 C CNN
F 2 "" H 3050 3850 50  0001 C CNN
F 3 "" H 3050 3850 50  0001 C CNN
	1    3050 3850
	1    0    0    -1  
$EndComp
Text Label 3450 3850 0    50   ~ 0
~MODE~
$Comp
L Device:Jumper_NO_Small JP1
U 1 1 5DA0B76D
P 3150 3850
F 0 "JP1" H 3050 4050 50  0000 C CNN
F 1 "Mode" H 3050 3950 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical_SMD_Pin1Left" H 3150 3850 50  0001 C CNN
F 3 "~" H 3150 3850 50  0001 C CNN
	1    3150 3850
	1    0    0    -1  
$EndComp
Wire Wire Line
	3450 3850 3250 3850
Connection ~ 3250 3850
$Comp
L power:+5V #PWR0125
U 1 1 5DAEAA80
P 3250 3650
F 0 "#PWR0125" H 3250 3500 50  0001 C CNN
F 1 "+5V" H 3265 3823 50  0000 C CNN
F 2 "" H 3250 3650 50  0001 C CNN
F 3 "" H 3250 3650 50  0001 C CNN
	1    3250 3650
	1    0    0    -1  
$EndComp
Text Label 1050 6600 2    50   ~ 0
~MODE~
Text Label 4850 5100 2    50   ~ 0
INTin
Text Label 4850 5000 2    50   ~ 0
DMAin
Text Label 4950 5000 0    50   ~ 0
DMAout
Text Label 4950 5100 0    50   ~ 0
INTout
Wire Wire Line
	4850 5000 4950 5000
Wire Wire Line
	4950 5100 4850 5100
Wire Wire Line
	6200 1950 8000 1950
Wire Wire Line
	6200 1950 6200 2050
Wire Wire Line
	8000 1950 8000 2050
Wire Wire Line
	8000 2050 10150 2050
Wire Wire Line
	5150 2050 6200 2050
Text Label 4450 7050 2    50   ~ 0
RA1
Text Label 4450 7350 2    50   ~ 0
RA4
Text Label 4450 7450 2    50   ~ 0
RA5
Text Label 4450 7650 2    50   ~ 0
RA7
Text Label 4450 7250 2    50   ~ 0
RA3
Text Label 4450 7550 2    50   ~ 0
RA6
Text Label 4450 7150 2    50   ~ 0
RA2
Text Label 4450 6950 2    50   ~ 0
RA0
Text Label 9200 4450 2    50   ~ 0
RA0
Text Label 9200 4350 2    50   ~ 0
RA5
Text Label 9200 4150 2    50   ~ 0
RA3
Text Label 9200 4550 2    50   ~ 0
RA1
Text Label 5600 5050 2    50   ~ 0
RA1
Wire Wire Line
	7600 5300 7600 5100
Connection ~ 7600 5300
Wire Wire Line
	6400 5300 6400 5100
Connection ~ 6400 5300
Wire Wire Line
	8800 5100 8800 5300
Connection ~ 8800 5300
Wire Wire Line
	2050 7800 2150 7800
Connection ~ 2050 7800
Connection ~ 1950 3700
Wire Wire Line
	1950 7800 2050 7800
Connection ~ 1950 7800
Connection ~ 2150 7800
Wire Wire Line
	1850 3700 1950 3700
Connection ~ 1850 3700
Wire Wire Line
	1850 7800 1950 7800
Connection ~ 1850 7800
Wire Wire Line
	1750 3700 1850 3700
Connection ~ 1750 3700
Wire Wire Line
	1750 7800 1850 7800
Connection ~ 1750 7800
Wire Wire Line
	1950 3700 2050 3700
Wire Wire Line
	2050 3700 2150 3700
Connection ~ 2050 3700
Wire Wire Line
	1650 7800 1750 7800
Connection ~ 1650 7800
Wire Wire Line
	1650 3700 1750 3700
Connection ~ 1650 3700
Wire Wire Line
	1450 7800 1550 7800
Wire Wire Line
	1550 7800 1650 7800
Connection ~ 1550 7800
Wire Wire Line
	1450 3700 1550 3700
Wire Wire Line
	1550 3700 1650 3700
Connection ~ 1550 3700
Connection ~ 1450 3700
$Comp
L stdparts:EPM7128SL84 U1
U 1 1 5CBA3E53
P 1800 5700
F 0 "U1" H 1800 5750 50  0000 C CNN
F 1 "EPM7128SL84" H 1800 5650 50  0000 C CNN
F 2 "stdpads:PLCC-84_SMDSocket" H 1650 5900 50  0001 C CNN
F 3 "" H 1650 5900 50  0001 C CNN
	1    1800 5700
	1    0    0    -1  
$EndComp
NoConn ~ 1050 5500
NoConn ~ 1050 5600
NoConn ~ 1050 6200
Wire Wire Line
	9800 1750 9800 1650
Wire Wire Line
	9800 1900 9800 1800
Wire Wire Line
	6800 1650 6800 1750
Wire Wire Line
	6800 1750 7400 1750
Wire Wire Line
	7400 1750 7400 1650
Wire Wire Line
	5600 1650 6800 1650
Wire Wire Line
	7100 1900 7100 1800
Text Notes 7600 3800 0    50   ~ 0
CSEN = S1 | S2 | S3 @ ~C7M~\nR~WE~ovrd = S4 | S5 | S6 @ C7M\n\nRD[7:0] = ~R~W ? D[7:0] : 8’bZ\nD[7:0] = (~CSEN~ | ~DEVSEL~ | ~R~W) ? 8’bZ :\n          ADDRHI ? {1’b1, AR[22:16]} : \n          ADDRMED ? AR[15:8] : \n          ADDRLO ? AR[7:0] : \n          RD[7:0]\n\nRA[10:8] = S1 ? AR[10:8] : AR[21:19] @ C7M\nRA[7:0] = RAMREG ? (S1 ? AR[7:0] : AR[18:11]) : \n           IOSEL ? 8’b00 : Bank[7:0] @ C7M\n\nROMCS = IOSEL | (IOSTRB & ROMEN)\nR~WE~ = R~WE~ovrd | R~W~\nR~OE~ = ~R~W\nRAS = (RAMREG & (S1 | S2 | S3)) | S5 @ ~C7M~\nCASr = (RAMREG & (S2 | S3)) | S5 | S6 @ ~C7M~\nCAS0 = (CASr & PHI1) | (CASr & PHI1 & ~AR[22]~ & DEVSEL)\nCAS1 = (CASr & PHI1) | (CASr & PHI1 & AR[22] & DEVSEL)
Wire Wire Line
	6500 1900 7100 1900
Wire Wire Line
	7100 1800 8900 1800
Wire Wire Line
	8900 1900 9800 1900
Wire Wire Line
	8300 1650 8300 1750
Wire Wire Line
	9800 1750 8300 1750
Wire Wire Line
	7400 1650 8300 1650
Wire Wire Line
	9800 1650 10150 1650
Wire Wire Line
	9800 1800 10150 1800
$Comp
L Mechanical:Fiducial FID1
U 1 1 5D319AED
P 5950 6250
F 0 "FID1" H 6035 6296 50  0000 L CNN
F 1 "Fiducial" H 6035 6205 50  0000 L CNN
F 2 "stdpads:Fiducial" H 5950 6250 50  0001 C CNN
F 3 "~" H 5950 6250 50  0001 C CNN
	1    5950 6250
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:Fiducial FID2
U 1 1 5D321D2B
P 5950 6450
F 0 "FID2" H 6035 6496 50  0000 L CNN
F 1 "Fiducial" H 6035 6405 50  0000 L CNN
F 2 "stdpads:Fiducial" H 5950 6450 50  0001 C CNN
F 3 "~" H 5950 6450 50  0001 C CNN
	1    5950 6450
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:Fiducial FID3
U 1 1 5D321DA8
P 6550 6250
F 0 "FID3" H 6635 6296 50  0000 L CNN
F 1 "Fiducial" H 6635 6205 50  0000 L CNN
F 2 "stdpads:Fiducial" H 6550 6250 50  0001 C CNN
F 3 "~" H 6550 6250 50  0001 C CNN
	1    6550 6250
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:Fiducial FID4
U 1 1 5D322056
P 6550 6450
F 0 "FID4" H 6635 6496 50  0000 L CNN
F 1 "Fiducial" H 6635 6405 50  0000 L CNN
F 2 "stdpads:Fiducial" H 6550 6450 50  0001 C CNN
F 3 "~" H 6550 6450 50  0001 C CNN
	1    6550 6450
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:Fiducial FID5
U 1 1 5D3223BF
P 7150 6450
F 0 "FID5" H 7235 6496 50  0000 L CNN
F 1 "Fiducial" H 7235 6405 50  0000 L CNN
F 2 "stdpads:Fiducial" H 7150 6450 50  0001 C CNN
F 3 "~" H 7150 6450 50  0001 C CNN
	1    7150 6450
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C21
U 1 1 5D3403C6
P 10100 6450
F 0 "C21" H 10150 6500 50  0000 L CNN
F 1 "100n" H 10150 6400 50  0000 L CNN
F 2 "stdpads:C_0805" H 10100 6450 50  0001 C CNN
F 3 "~" H 10100 6450 50  0001 C CNN
	1    10100 6450
	1    0    0    -1  
$EndComp
Wire Wire Line
	9700 6350 10100 6350
Connection ~ 9700 6350
$Comp
L power:+12V #PWR0126
U 1 1 5D35C1BD
P 10100 6550
F 0 "#PWR0126" H 10100 6400 50  0001 C CNN
F 1 "+12V" H 10100 6700 50  0000 C CNN
F 2 "" H 10100 6550 50  0001 C CNN
F 3 "" H 10100 6550 50  0001 C CNN
	1    10100 6550
	-1   0    0    1   
$EndComp
Wire Wire Line
	3600 3100 3600 3050
Connection ~ 3600 3100
$Comp
L power:-5V #PWR0112
U 1 1 5D12D2DF
P 3600 3100
F 0 "#PWR0112" H 3600 3200 50  0001 C CNN
F 1 "-5V" H 3600 3250 50  0000 C CNN
F 2 "" H 3600 3100 50  0001 C CNN
F 3 "" H 3600 3100 50  0001 C CNN
	1    3600 3100
	-1   0    0    1   
$EndComp
Wire Wire Line
	3200 2800 3600 2800
Wire Wire Line
	3600 3100 3200 3100
Wire Wire Line
	3600 2850 3500 2850
Wire Wire Line
	3500 3150 2700 3150
Wire Wire Line
	2700 3150 2700 2500
Wire Wire Line
	2700 2500 2800 2500
Wire Wire Line
	3600 2750 3600 2800
Wire Wire Line
	3500 2850 3500 3150
$Comp
L Device:C_Small C18
U 1 1 5D37ABB8
P 3600 2950
F 0 "C18" H 3650 3000 50  0000 L CNN
F 1 "100n" H 3650 2900 50  0000 L CNN
F 2 "stdpads:C_0805" H 3600 2950 50  0001 C CNN
F 3 "~" H 3600 2950 50  0001 C CNN
	1    3600 2950
	1    0    0    -1  
$EndComp
Wire Wire Line
	3600 2800 4100 2800
Connection ~ 3600 2800
Wire Wire Line
	3600 3100 3750 3100
Wire Wire Line
	3950 3100 4100 3100
Connection ~ 4100 3100
$Comp
L Device:C_Small C22
U 1 1 5D44711B
P 3850 3100
F 0 "C22" V 4050 3100 50  0000 C BNN
F 1 "100n" V 3950 3100 50  0000 C CNN
F 2 "stdpads:C_0805" H 3850 3100 50  0001 C CNN
F 3 "~" H 3850 3100 50  0001 C CNN
	1    3850 3100
	0    1    1    0   
$EndComp
$EndSCHEMATC
