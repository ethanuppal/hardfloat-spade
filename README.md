# hardfloat-spade

![CI](https://github.com/ethanuppal/hardfloat-spade/actions/workflows/ci.yaml/badge.svg)

[Spade](https://spade-lang.org) wrappers for the [Berkley Hardfloat](https://github.com/ucb-bar/berkeley-hardfloat) floating-point library, powered by my [custom downstream patches](https://github.com/ethanuppal/berkeley-hardfloat).

I had to hack Spade (in [!360](https://gitlab.com/spade-lang/spade/-/merge_requests/360) and [!362](https://gitlab.com/spade-lang/spade/-/merge_requests/362)) to add the language features needed to support this library.

## What's in this library?

This library exposes two levels of abstraction over Hardfloat:

### `hardfloat-sys`

`hardfloat-sys` provides raw bindings to the Hardfloat Verilog.
For instance, here's how you would convert a two's complement `uint<32>` to a
IEEE 32-bit floating point `uint<32>` (it was Berkeley's decision to
use camel case, don't @ me):

```rs
use std::ports;

entity uint32_to_float32(input: uint<32>) -> uint<32> {
    let recoded_out = inst new_mut_wire();
    let exception_flags = inst new_mut_wire();

    // int -> recoded
    let _ = inst hardfloat::hardfloat_sys::iNToRecFN::<32, 8, 24>(
        0, // control bit(s)
        true, // whether inpt is signed 
        input, // actual integer value to convert
        0, // rounding mode
        recoded_out,  // output floating point
        exception_flags // errors that occured in conversion
    );

    // recoded 32-bit float is 33 bits
    let recoded_bits: uint<33> = inst ports::read_mut_wire(recoded_out);
    let float_out = inst new_mut_wire();

    // recoded -> ieee
    let _ = inst hardfloat::hardfloat_sys::recFNToFN::<8, 24>(
        recoded_bits, // recoded representation
        float_out // ieee representation
    );

    inst ports::read_mut_wire(float_out)
}
```

Let's break down what's going on here, in case you aren't too familiar with
Spade.

We're declaring a new `entity`, which is kind of like a general Verilog module,
that takes in and returns 32-bit unsigned integers.
To do so, we'll use `hardfloat_sys::iNToRecFN`.

- The `input` is to be a two's complement representation of an integer.
- The output is a (presumably big endian) representation of the floating-point number best approximating `input`.

Since `hardfloat-sys` exposes Verilog entities, we're going to have to use
`std::ports` to construct `inv &` wires (which are kind of like Verilog's
`output` ports).
(Yes, I'm aware I don't use the fancy new `port` features here; it's something
I'll fix later.)

Hardfloat works with an internal "recoded" representation that is one more bit
than the standard IEEE representation.
We can restore the IEEE representation using `hardfloat_sys::recFNToFN`.

And that's it!
We can test this using `cocotb`:

```python
# top = hardfloat_sys_test::uint32_to_float32

import random
import struct
from spade import SpadeExt
from cocotb.triggers import Timer
from cocotb import cocotb

def float32_to_bits(f):
    return format(struct.unpack("!I", struct.pack("!f", f))[0], "032b")

async def convert(s, value):
    s.i.input = value
    await Timer(10, units="ps")
    return s.o

@cocotb.test()
async def test(dut):
    s = SpadeExt(dut)

    for _ in range(0, 100):
        num = random.randint(0, 10000)  # needs to be nonnegative for now
        print(f"testing that {num} converts correctly")
        converted = await convert(s, num)
        converted.assert_eq(int(float32_to_bits(num), 2))
```

If you run `swim test`, it will pass!
(You have to use [my custom `swim`](https://gitlab.com/ethanuppal/swim/-/commit/9ea23fe92b1623f6f3a3e2f81f499650d68a09d8) on my GitLab as of writing this.)

### `hardfloat`

Currently, only the raw bindings are usable.
With a bit more hacking in Spade's type system, my envisioned API should be able
to work.
However, you can view the beginnings at [`src/lib.spade`](./src/lib.spade).

## License

(This license does not apply to the code in Hardfloat. It applies only to the
code I have written. The license for Hardfloat is reproduced when the source
files are downloaded.)

hardfloat-spade is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

hardfloat-spade is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

A copy of the GNU Lesser General Public License, version 3, can be found in the [LICENSE](LICENSE) file.
