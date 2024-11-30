# top = hardfloat_sys_test::uint32_to_float32

# This file is part of hardfloat-spade.
# hardfloat-spade is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
# hardfloat-spade is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
# You should have received a copy of the GNU Lesser General Public License along with hardfloat-spade. If not, see <https://www.gnu.org/licenses/>.

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
