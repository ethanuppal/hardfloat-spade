# hardfloat-spade

![CI](https://github.com/ethanuppal/hardfloat-spade/actions/workflows/ci.yaml/badge.svg)

[Spade](https://spade-lang.org) wrappers for the [Berkley Hardfloat](https://github.com/ucb-bar/berkeley-hardfloat) floating-point library.

I had to hack Spade (in [!360](https://gitlab.com/spade-lang/spade/-/merge_requests/360) and [!362](https://gitlab.com/spade-lang/spade/-/merge_requests/362)) to add the language features needed to support this library.

## What's in this library?

This library exposes two levels of abstraction over Hardfloat:

### `hardfloat-sys`

`hardfloat-sys` provides raw bindings to the Hardfloat Verilog.
For instance, here's how you would convert a two's complement `uint<32>` to a
IEEE 32-bit floating point `uint<32>`:

```rs
use std::ports;

entity uint32_to_float32(input: uint<32>) -> uint<32> {
    let recoded_out = inst new_mut_wire();
    let exception_flags = inst new_mut_wire();
    let _ = inst hardfloat::hardfloat_sys::iNToRecFN::<32, 8, 24>(
        0, 
        false, 
        input, 
        0, 
        recoded_out, 
        exception_flags
    );
    let recoded_bits: uint<33> = inst ports::read_mut_wire(recoded_out);
    let float_out = inst new_mut_wire();
    let _ = inst hardfloat::hardfloat_sys::recFNToFN::<8, 24>(
        recoded_bits, 
        float_out
    );
    inst ports::read_mut_wire(float_out)
}
```

### `hardfloat`

## License

(This license does not apply to the code in Hardfloat. It applies only to the
code I have written. The license for Hardfloat is reproduced when the source
files are downloaded.)

hardfloat-spade is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

hardfloat-spade is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

A copy of the GNU Lesser General Public License, version 3, can be found in the [LICENSE](LICENSE) file.
