from nand import NAND_gate
from not_gate import NOT_gate
from and_gate import AND_gate
from or_gate import OR_gate
from xor_gate import XOR_gate

# 0 + 0 = 00
# 0 + 1 = 01
# 1 + 0 = 01
# 1 + 1 = 10

# 1. Write half_adder() function and calculate the sum bit (s)
# 2. Calculate the carry bit (c) and add to half_adder()
def half_adder(a, b):
  s = XOR_gate(a, b)
  c = AND_gate(a, b)
  return s, c

# 3. Test out the half_adder()
print(half_adder(0, 0))  # Output: (0, 0)
print(half_adder(0, 1))  # Output: (1, 0)
print(half_adder(1, 0))  # Output: (1, 0)
print(half_adder(1, 1))  # Output: (0, 1)

# 4. Write full_adder() function add s and c_out, set them to 0 and return them
# 5. Use two half adders to create the sum bit s
# 6. Use OR gate and two half adders to product the carry-out bit
def full_adder(a, b, c):
  s = 0
  c_out = 0
  # a + b
  sum1, carry1 = half_adder(a, b)
  # sum1 + carry1
  s, carry2 = half_adder(sum1, c)
  #
  c_out = OR_gate(carry1, carry2) 
  return s, c_out

# 7. Test out the full_adder()
print(full_adder(0, 0, 0))  # Output: (0, 0)
print(full_adder(1, 1, 1))  # Output: (1, 1)
print(full_adder(0, 1, 1))  # Output: (0, 1)
print(full_adder(1, 1, 0))  # Output: (0, 1)

# 8. Write ALU() have it take in a, b, c and opcode (determines the operation the ALU should perform, if 0 return half_adder() output, if 1 return full_adder() output)
# 9. Write what happens with opcode inside ALU()(arithmetic logic unit) and return s, c
# 11. How to implement incrementation in ALU() i.e. adding 1 to a (add further option in opcode)
def ALU(a, b, c, opcode):
  if opcode == 0:
    s, c = half_adder(a, b)
  elif opcode == 1:
    s, c = full_adder(a, b ,c)
  elif opcode == 2:
    s, c = full_adder(a, 1, 0) # increment a by 1
  return s, c

# 10. Test out the ALU()
print(ALU(0, 0, 1, 0))  # half_adder (0, 0)
print(ALU(0, 0, 1, 1))  # full_adder (1, 0)
print(ALU(1, 1, 1, 0))  # half_adder (0, 1)
print(ALU(1, 1, 1, 1))  # full_adder (1, 1)
#11. Test out the ALU()
print(ALU(0, 0, 0, 2))  # Increment a (0): (1, 0)
print(ALU(1, 0, 0, 2))  # Increment a (1): (0, 1) - carry-out