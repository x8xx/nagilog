#!/bin/bash

rustc -O --emit=obj  --target wasm32-wasi calc.rs
wasm2wat calc.o | sed '$ s/)$/\(export "calc" \(func $calc\)\)\)/' > tmp.wat
wat2wasm tmp.wat -o calc.wasm
rm -f tmp.wat
rm -f calc.o
