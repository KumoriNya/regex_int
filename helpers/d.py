import sys
import re

command = sys.argv[1]
delimitor = command[0]
del_address = -1
del_target = None
try:
    delimitor = int(delimitor)
except:
    pass
if not isinstance(delimitor, int):
    del_target = re.split(delimitor, command)[1]
else:
    del_address = int(command[:-1])

    
for count, line in enumerate(sys.stdin):
    modified = line
    # print(f"count = {count}")
    if count + 1 == del_address:
        print("Try sub due to address")
        modified = ""
    elif del_address == -1 and re.search(del_target, line) != None:
        print("Try sub due to standard sub target found")
        modified = ""
    print(modified, end = "")