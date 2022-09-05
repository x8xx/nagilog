#![no_main]

extern {
    pub fn read(pointer: i64, offset: u8) -> i32;
}

#[no_mangle]
pub fn calc(pointer: i64, input: u8) -> i32 {
    let val = unsafe { read(pointer, 2) };
    input as i32 + val 
}
