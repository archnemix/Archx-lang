# archx: dialect=compat, version=1
print(hex(0), hex(1), hex(9), hex(10), hex(15), hex(16), hex(255), hex(4095))
print(oct(0), oct(1), oct(8), oct(511))
print(bin(0), bin(1), bin(5), bin(1023))
print(hex(-1), hex(-255), oct(-8), bin(-5))
print(hex(9223372036854775807), hex(-9223372036854775807 - 1))
print(f'{255:x} {255:X} {255:o} {255:b} {10:x}')
