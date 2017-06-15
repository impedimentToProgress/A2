include hdl_sources.list

SYNTH_CC.   = genus
SYNTH_FLAGS = -legacy_ui -files

.PHONY: synth clean

synth: $(HDL_SOURCES)
	genus -legacy_ui -files ./synth/cadence.tcl

clean:
	rm -Rf /synth/fv
	rm -Rf /synth/synth_reports
	rm genus.*
	rm /synth/genus.*
