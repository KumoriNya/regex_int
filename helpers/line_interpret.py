import sys
import re

inputs = sys.argv[1:]
# print(type(inputs))
nums = []
i = 1
while i < 10:
    nums.append(str(i))
    i += 1
nums = tuple(nums)
for inp in inputs:
    if inp.startswith(nums):
        print(True)