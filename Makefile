BUILD ?= build
DEVICE = GW2AR-LV18QN88C8/I7
FAMILY = GW2A-18C
FREQ = 27

SRC = timing.v pll.v top.v tmds.v image.v blinky.v
OBJ = $(SRC:%.v=$(BUILD)/%.json)

all: $(BUILD)/gate.fs

$(BUILD)/%.json: %.v 	
	@mkdir -p $(BUILD)
	yosys -p "read_verilog $<; hierarchy -top $(basename $(notdir $<)); proc; write_json $@"

$(BUILD)/gate.json: $(OBJ)
	yosys -p "read_json $(OBJ); synth_gowin -top top -json $@"

$(BUILD)/gate_pnr.json: $(BUILD)/gate.json gate.cst
	 nextpnr-himbaechel --json $< --write $@ --device $(DEVICE) --vopt family=$(FAMILY) --vopt cst=gate.cst --freq $(FREQ)

$(BUILD)/gate.fs: $(BUILD)/gate_pnr.json
	gowin_pack -d GW2A-18C -o $@ $^

.PHONY: upload flash clean

upload: $(BUILD)/gate.fs
	openFPGALoader -b tangnano20k $^

flash: $(BUILD)/gate.fs
	openFPGALoader -b tangnano20k -f $^

clean:
	rm -rf $(BUILD)
