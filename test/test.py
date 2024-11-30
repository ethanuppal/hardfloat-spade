# top = lib::test

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
    #
    # s.i.input = "40"
    # await Timer(10, units="ns")
    #
    # num = random.randint(0, 10000)  # needs to be nonnegative for now
    # print(f"testing that {num} converts correctly")
    # converted = await convert(s, num)
    # converted.assert_eq(int(float32_to_bits(num), 2))
