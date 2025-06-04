# hardfloat-spade

![CI](https://github.com/ethanuppal/hardfloat-spade/actions/workflows/ci.yaml/badge.svg)

**[Read the documentation](https://ethanuppal.com/hardfloat-spade/index.html)**

[Spade](https://spade-lang.org) wrappers for the [Berkley Hardfloat](https://github.com/ucb-bar/berkeley-hardfloat) floating-point library, powered by my [custom downstream patches](https://github.com/ethanuppal/berkeley-hardfloat).

> [!IMPORTANT]
>
> > I had to hack Spade (in [!360](https://gitlab.com/spade-lang/spade/-/merge_requests/360) and [!362](https://gitlab.com/spade-lang/spade/-/merge_requests/362)) to add the language features needed to support this library.
>
> 🎉 Spade@eeecd521^ and Swim@6d55f8d7^ can now build this library with my PRs!

## What's in this library?

This library exposes two levels of abstraction over Hardfloat:

### `hardfloat-sys`

`hardfloat-sys` provides raw bindings to the Hardfloat Verilog.
For instance, here's how you would convert a two's complement `uint<32>` to a
IEEE 32-bit floating point `uint<32>` (it was Berkeley's decision to
use camel case, don't @ me):

```rs
entity uint32_to_float32(int_to_convert: uint<32>) -> uint<32> {
    let (recoded_out, recoded_out_inv) = port;
    let (exception_flags, exception_flags_inv) = port;

    // int -> recoded
    inst hardfloat::hardfloat_sys::iNToRecFN::<32, 8, 24>(
        0, // control bit(s)
        true, // whether input is signed 
        int_to_convert, // actual integer value to convert
        0, // rounding mode
        recoded_out_inv,  // output floating point
        exception_flags_inv // errors that occured in conversion
    );

    // recoded 32-bit float is 33 bits
    let recoded_bits: uint<33> = inst ports::read_mut_wire(recoded_out);
    let (float_out, float_out_inv) = port;

    // recoded -> ieee
    inst hardfloat::hardfloat_sys::recFNToFN::<8, 24>(
        *recoded_out, // recoded representation
        float_out // ieee representation
    );

    *float_out
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
the `port` keyword to construct `inv &` wires (which are kind of like Verilog's
`output` ports).

Hardfloat works with an internal "recoded" representation that is one more bit
than the standard IEEE representation.
We can restore the IEEE representation using `hardfloat_sys::recFNToFN`.

And that's it!
We can test this entity in Rust using [marlin](https://github.com/ethanuppal/marlin):

```python
use marlin::{spade::prelude::*, verilator::VerilatorRuntimeOptions};
use rand::Rng;
use snafu::Whatever;

#[spade(src = "src/hardfloat_sys_test.spade", name = "uint32_to_float32")]
struct UInt32ToFloat32;

#[test]
#[snafu::report]
fn main() -> Result<(), Whatever> {
    colog::init();

    let mut runtime = SpadeRuntime::new(
        SpadeRuntimeOptions {
            verilator_options: VerilatorRuntimeOptions {
                // hardfloat has these warnings
                ignored_warnings: vec!["WIDTHTRUNC".into(), "WIDTHEXPAND".into()],
                ..Default::default()
            },
            ..Default::default()
        },
        true,
    )?;

    let mut uint32_to_float32 = runtime.create_model::<UInt32ToFloat32>()?;

    let mut rng = rand::rng();
    for _ in 0..100 {
        let random_int = rng.random::<u32>();
        let expected = u32::from_ne_bytes((random_int as f32).to_ne_bytes());

        uint32_to_float32.int_to_convert = u32::from_ne_bytes(random_int.to_ne_bytes());
        uint32_to_float32.eval();
        let actual = uint32_to_float32.result;

        assert_eq!(actual, expected, "Casting the integer {} to its nearest floating point representation did not agree with the hardware module", random_int);
    }

    Ok(())
}
```

If you run `cargo test`, it will pass!

### `hardfloat`

Currently, only the raw bindings are usable.
With a bit more hacking in Spade's type system, my envisioned API should be able
to work.
However, you can view the beginnings at [`src/main.spade`](./src/main.spade).

## License

(This license does not apply to the code in Hardfloat. It applies only to the
code I have written. The license for Hardfloat is reproduced when the source
files are downloaded.)

hardfloat-spade is licensed under the Mozilla Public License 2.0. 
This license is similar to the Lesser GNU Public License, except that the copyleft applies only to the source code of this library, not any library that uses it.
That means you can statically or dynamically link with unfree code (see https://www.mozilla.org/en-US/MPL/2.0/FAQ/#virality).

A copy of the Mozilla Public License, version 2.0, can be found in the [LICENSE](LICENSE) file.
