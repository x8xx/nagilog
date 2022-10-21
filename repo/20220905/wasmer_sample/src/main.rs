use std::fs::File;
use std::io::prelude::*;
use wasmer::{ Store, Module, Function, Memory, MemoryType, Instance, imports, Value };


fn main() {
    /**
     * wasmファイル読み込み
     */
    let mut f = File::open("../wasm/calc.wasm").unwrap();
    let metadata = std::fs::metadata("../wasm/calc.wasm").unwrap();
    let mut wasm = vec![0;metadata.len() as usize];
    f.read(&mut wasm).unwrap();

    /**
     * wasmから呼び出すホスト関数と仮データの用意
     */
    let mut data: Vec<u8> = Vec::new();
    data.push(0);
    data.push(1);
    data.push(2);
    data.push(3);
    let data_ptr = data.as_ptr();

    fn read(pointer: i64, offset: u8) -> i32 {
        unsafe {
            // 生ポインタに戻してアクセスする
            (*(pointer as *const u8).offset(offset as isize)) as i32
        }
    }

    /**
     * wasmer用意
     */
    // storeの役割がいまいちわからない
    // とりあえず分けてみた
    let store = Store::default();
    let read_fn_store = Store::default();
    let memory_store = Store::default();

    let module = Module::from_binary(&store, &wasm).unwrap();
    let read_fn = Function::new_native(&read_fn_store, read);
    let linear_memory = Memory::new(&memory_store, MemoryType::new(1, None, false)).unwrap();

    // ホストのread関数をimportしてあげる
    let import_object = imports! {
        "env" => {
            "read" => read_fn,
            "__linear_memory" => linear_memory,
        },
    };

    let instance = Instance::new(&module, &import_object).unwrap();

    /**
     * 実行フェイズ
     */
    let calc_fn = instance.exports.get_function("calc").unwrap();
    // 引数を設定
    let mut calc_args: Vec<Value> = Vec::new();
    calc_args.push(Value::I64(data_ptr as i64));
    calc_args.push(Value::I32(20));
    // 実行
    let result = calc_fn.call(&calc_args).unwrap();
    println!("result: {}", result[0].unwrap_i32());
}
