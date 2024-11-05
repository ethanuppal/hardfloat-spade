# top = lib::test

import cocotb
from spade import FallingEdge, SpadeExt
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge


@cocotb.test()
async def test(dut):
    s = SpadeExt(dut)  # Wrap the dut in the Spade wrapper

    # To access unmangled signals as cocotb values (without the spade wrapping) use
    # <signal_name>_i
    # For cocotb functions like the clock generator, we need a cocotb value
    clk = dut.clk_i

    await cocotb.start(Clock(clk, period=10, units="ns").start())

    await FallingEdge(clk)
    s.o.assert_eq("0")
