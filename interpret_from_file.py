import sys
import re

def find_range(list_of_partial_cmd, delimiter):
    range1 = ""
    range2 = ""
    r1_found = False
    r2_found = False
    print(list_of_partial_cmd)
    for element in list_of_partial_cmd:
        print(f"current ele: '{element}'")
        if not r1_found:
            range1 += element
            if isinstance(range1, int):
                print(f"range 1 is int, found '{range1}'")
                r1_found = True
            elif len(range1) > 1 and range1.endswith(delimiter):
                print(f"range 1 found '{range1}'")
                r1_found = True
        elif not r2_found:
            range2 += element
            if isinstance(range2, int):
                print(f"range 2 is int, found '{range2}'")
                r2_found = True
            elif len(range2) > 1 and range2.endswith(delimiter):
                print(f"range 2 found '{range2}'")
                r2_found = True
    print(f"Range 1 is: '{range1}', range 2 is: '{range2}'")

cmd = sys.argv[1]

deli = cmd[0]
del_address = -1
del_target = None
all_cmd =[]
s = ""
if "," in cmd:
    s = cmd.split(',')
first = ""
if len(s) > 2:
    try:
        first = int(s[0])
    except:
        pass
    if isinstance(first, int):
        deli = s[1][0]
    find_range(s, deli)
    



print(s)

# number comma number
# number comma delimeter regex delimeter
# delimiter regex delimeter comma number
# delimiter regex delimiter comma delimiter regex delimiter
# if ""
# try:
#     deli = int(deli)
# except:
#     pass


# if deli == "$":
#     del_address = "$"
# elif not isinstance(deli, int):
#     del_target = re.split(deli, cmd)[1]
# else:
#     try:
#         del_address = int(cmd[:-1])
#     except:
#         del_address = re.split(',', cmd)
# all_cmd.append(
#     {
#         'operate_address'   : del_address,
#         'operate_target'    : del_target,
#         'operation_type'    : "d"
#     }
# )
# print(all_cmd)