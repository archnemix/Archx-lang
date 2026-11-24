// Suite 5 (Rust): std::collections::HashMap<String, i64> & HashMap<i64, i64>
// (Rust's std HashMap IS hashbrown SwissTable!).

use std::collections::HashMap;

fn main() {
    let mut vocab: Vec<String> = Vec::with_capacity(1024);
    for i in 0..1024_i64 {
        if i % 2 == 0 {
            vocab.push(format!("tok_{i}"));
        } else {
            vocab.push(format!("identifier_token_{i}"));
        }
    }

    let mut str_checksum: i64 = 0;
    let miss = "missing_token_xyz";
    for r in 0..120_i64 {
        let mut counts: HashMap<String, i64> = HashMap::new();
        for i in 0..1024_usize {
            counts.insert(vocab[i].clone(), 1);
        }
        for step in 0..8192_i64 {
            let idx = ((step * 73 + r * 19) % 1024) as usize;
            let k = &vocab[idx];
            *counts.get_mut(k.as_str()).unwrap() += (step % 7) + 1;
        }
        for p in 0..2048_i64 {
            let pidx = ((p * 131 + r * 7) % 1024) as usize;
            let pk = &vocab[pidx];
            if let Some(&v) = counts.get(pk.as_str()) {
                str_checksum += v;
            }
        }
        if !counts.contains_key(miss) {
            str_checksum += *counts.get(miss).unwrap_or(&3);
        }
        for (_k, v) in &counts {
            str_checksum += *v;
        }
    }

    let mut tab: HashMap<i64, i64> = HashMap::new();
    for i in 0..32768_i64 {
        let k = i * 17 + 3;
        tab.insert(k, (i * 31 + 7) % 100000);
    }
    let mut popped_sum: i64 = 0;
    let mut i: i64 = 0;
    while i < 32768 {
        let k = i * 17 + 3;
        popped_sum += tab.remove(&k).unwrap();
        i += 4;
    }
    for j in 0..8192_i64 {
        let nk = 1000000 + j * 13;
        tab.insert(nk, j * 5 + 1);
    }

    let mut int_checksum: i64 = popped_sum + (tab.len() as i64);
    for _pass in 0..40 {
        for (k, v) in &tab {
            int_checksum += (k % 997) * (*v);
        }
    }

    println!("{str_checksum}");
    println!("{int_checksum}");
}
