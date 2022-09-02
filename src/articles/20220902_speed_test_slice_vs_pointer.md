# Rustのスライスとポインタの速度比較
どんぐらい違うのかなーって気になったので, 適当に実験した軽いメモ

1000万回回したらこんな感じ
```
Start!
slice_time: 0.666
pointer_time: 0.485
43175
39986
```

コードはこれ

変に最適化されないようにしたつもり
```
use std::time::Instant;
use rand::Rng;

fn main() {
    // 試行回数
    let count = 10000000;
    // バッファサイズ
    let size = 100000;

    let mut rng = rand::thread_rng();

    // 2つのバッファ用意して適当に値放り込んどく
    let mut buf1: Vec<u8> = Vec::new();
    let mut buf2: Vec<u8> = Vec::new();
    for _ in 0..size {
        buf1.push(rng.gen_range(0..255));
        buf2.push(rng.gen_range(0..255));
    }

    // スライスとポインタ用意するよ
    let slice_buf = &buf1;
    let pointer_buf = buf2.as_ptr();

    // アクセス先のindexを事前に用意
    let mut index_list: Vec<usize> = Vec::new();
    for _ in 0..count {
        index_list.push(rng.gen_range(0..size));
    }

    // アクセスした値を放り込む箱用意しとくよ
    let mut slice_result: Vec<u8> = vec![0;count];
    let mut pointer_result: Vec<u8> = vec![0;count];


    println!("Start!");

    // スライスアクセス計測
    let slice_start = Instant::now();
    for (i, index) in index_list.iter().enumerate() {
        slice_result[i] = slice_buf[*index];
    }
    let slice_end = slice_start.elapsed();
    println!("slice_time: {}.{:03}", slice_end.as_secs(), slice_end.subsec_nanos() / 1_000_000);


    // ポインタアクセス計測
    let pointer_start = Instant::now();
    for (i, index) in index_list.iter().enumerate() {
        unsafe {
            pointer_result[i] = *pointer_buf.offset(*index as isize);
        }
    }
    let pointer_end = pointer_start.elapsed();
    println!("pointer_time: {}.{:03}", pointer_end.as_secs(), pointer_end.subsec_nanos() / 1_000_000);


    // なんか処理しとかないと, 最適化で消える気がするので適当に
    println!("{}", slice_result.iter().filter(|&v| *v == 100).count());
    println!("{}", pointer_result.iter().filter(|&v| *v == 100).count());
}
```
