use marlin::{
    spade::{prelude::*, SpadeModelConfig},
    verilator::VerilatedModelConfig,
};
use rand::Rng;
use snafu::Whatever;

#[spade(src = "src/hardfloat_sys_test.spade", name = "uint32_to_float32")]
struct UInt32ToFloat32;

#[test]
#[snafu::report]
fn main() -> Result<(), Whatever> {
    colog::init();

    let runtime = SpadeRuntime::new(SpadeRuntimeOptions::default())?;

    let mut uint32_to_float32 = runtime.create_model::<UInt32ToFloat32>(SpadeModelConfig {
        verilator_config: VerilatedModelConfig {
            ignored_warnings: vec!["WIDTHTRUNC".into(), "WIDTHEXPAND".into()],
            ..Default::default()
        },
    })?;

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
