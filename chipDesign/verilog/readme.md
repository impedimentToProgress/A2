The detailed implementation is a little bit different from Figure 5 in the paper because of the specific technology, but basic idea is same. 

The reason Cunit is commented out is the parasitic capacitanceat that node is already enough, so we don't need to explicitly add a Cunit.

The transistor in parallel with Cmain is to create another leakage path because the leakage in Cmain is not enough to reset itself.
