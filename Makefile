KICAD = /Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli
LAYERS = F.Cu,In1.Cu,In2.Cu,B.Cu,F.Paste,F.SilkS,B.SilkS,F.Mask,B.Mask,Edge.Cuts
CHIPTYPE = $(shell echo $@ | cut -f2 -d"/")

PYTHON = python3
BOM_SCRIPT =  ../GW_KiCADBuild/export_bom.py

F_PCB = $@/../GR8RAM.kicad_pcb
F_SCH = $@/../GR8RAM.kicad_sch
F_NETLIST = $@/GR8RAM-NET.xml
F_BOM = $@/GR8RAM-BOM.csv
F_POS_N = $@/GR8RAM-top-pos
F_POS = $(F_POS_N).csv
F_POS_VCORE = $(F_POS_N).VCORE.csv
F_POS_JUMPER = $(F_POS_N).JUMPER.csv
F_ZIP = $@/GR8RAM.4205B.$(CHIPTYPE)-gerber.zip
F_SCHPDF = $@/GR8RAM.4205B.$(CHIPTYPE)-Schematic.pdf
F_PCBPDF = $@/GR8RAM.4205B.$(CHIPTYPE)-Placement.pdf


OPT_GERBER = -l $(LAYERS) --subtract-soldermask --no-netlist --no-x2
CMD_GERBER = pcb export gerbers $(OPT_GERBER) -o $@/ $(F_PCB)

CMD_DRILL = pcb export drill -o $@/ $(F_PCB)

CMD_NETLIST = sch export netlist --format kicadxml -o $(F_NETLIST) $(F_SCH)

OPT_POS = --smd-only --units mm --side front --format csv
CMD_POS = pcb export pos $(OPT_POS) -o $(F_POS) $(F_PCB)

CMD_SCHPDF = sch export pdf --black-and-white --no-background-color -o $(F_SCHPDF) $(F_SCH)
CMD_PCBPDF = pcb export pdf --black-and-white -l F.Fab,Edge.Cuts -o $(F_PCBPDF) $(F_PCB)


.PHONY: all clean \
		Hardware/MAX Hardware/MAX/gerber Hardware/MAX/Documentation \
		Hardware/LCMXO2 Hardware/LCMXO2/gerber Hardware/LCMXO2/Documentation

all: Hardware/MAX Hardware/LCMXO2
clean:
	rm -fr Hardware/MAX/gerber/ Hardware/MAX/Documentation/
	rm -fr Hardware/LCMXO2/gerber/ Hardware/LCMXO2/Documentation/


Hardware/MAX: Hardware/MAX/gerber Hardware/MAX/Documentation
Hardware/LCMXO2: Hardware/LCMXO2/gerber Hardware/LCMXO2/Documentation

Hardware/MAX/gerber Hardware/LCMXO2/gerber:
	mkdir -p $@
	$(KICAD) $(CMD_GERBER)
	$(KICAD) $(CMD_DRILL)
	$(KICAD) $(CMD_POS)
	$(KICAD) $(CMD_NETLIST)
	sed -i '' 's/PosX/MidX/g' $(F_POS)
	sed -i '' 's/PosY/MidY/g' $(F_POS)
	sed -i '' 's/Rot/Rotation/g' $(F_POS)
	$(PYTHON) $(BOM_SCRIPT) $(F_NETLIST) $(F_BOM)
	cp $(F_POS) $(F_POS_VCORE)
	cp $(F_POS) $(F_POS_JUMPER)
	sed -i '' '/"R1"/d' $(F_POS_VCORE)
	sed -i '' '/"U10"/d' $(F_POS_JUMPER)
	rm -f $(F_ZIP)
	zip -r $(F_ZIP) $@/
Hardware/MAX/Documentation Hardware/LCMXO2/Documentation:
	mkdir -p $@
	$(KICAD) $(CMD_SCHPDF)
	$(KICAD) $(CMD_PCBPDF)
