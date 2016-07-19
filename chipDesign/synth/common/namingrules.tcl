# This script renames nets into legal verilog names.
# Source at the beginning of your main script:
#         source -verbose "../../tcl/naming_rules.syn.tcl"
 
define_name_rules umich_naming_rules -allowed {a-zA-Z0-9_} \
    -max_length 256 -reserved_words \
    [list "always" "and" "assign" "begin" "buf" "bufif0" "bufif1" "case" "casex" \
         "casez" "cmos" "deassign" "default" "defparam" "disable" "edge" "else" \
         "end" "endcase" "endfunction" "endmodule" "endprimitive" "endspecify" \
         "endtable" "endtask" "event" "for" "force" "forever" "fork" "function" \
         "highz0" "highz1" "if" "initial" "inout" "input" "integer" "join" \
         "large" "macromodule" "medium" "module" "nand" "negedge" "nmos" "nor" \
         "not" "notif0" "notif1" "or" "output" "pmos" "posedge" "primitive" \
         "pull0" "pull1" "pulldown" "pullup" "rcmos" "reg" "release" "repeat" \
         "rnmos" "rpmos" "rtran" "rtranif0" "rtranif1" "scalered" "small" \
         "specify" "specparam" "strong0" "strong1" "supply0" "supply1" "table" \
         "task" "time" "tran" "tranif0" "tranif1" "tri" "tri0" "tri1" "triand" \
         "trior" "vectored" "wait" "wand" "weak0" "weak1" "while" "wire" "wor" \
         "xnor" "xor" "abs" "access" "after" "alias" "all" "and" "architecture" \
         "array" "assert" "attribute" "begin" "block" "body" "buffer" "bus" \
         "case" "component" "configuration" "constant" "disconnect" "downto" \
         "else" "elsif" "end" "entity" "exit" "file" "for" "function" "generate" \
         "generic" "guarded" "if" "in" "inout" "is" "label" "library" "linkage" \
         "loop" "map" "mod" "nand" "new" "next" "nor" "not" "null" "of" "on" \
         "open" "or" "others" "out" "package" "port" "procedure" "process" \
         "range" "record" "register" "rem" "report" "return" "select" "severity" \
         "signal" "subtype" "then" "to" "transport" "type" "units" "until" "use" \
         "variable" "wait" "when" "while" "with" "xor"] \
    -case_insensitive \
    -first_restricted "_" \
    -map {{{"*cell*","U"}, {"*-return","RET"}}} \
    -collapse_name_space \
    -equal_ports_nets \
    -inout_ports_equal_nets
 
change_names -rules umich_naming_rules -verbose -hierarchy


