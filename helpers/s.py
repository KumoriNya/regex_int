import sys
import re

arg = sys.argv[1]
delimitor = ""
deli_found = False
end_of_address = 0
print("In S")
for count, letter in enumerate(arg):
    if letter == "s":
        delimitor = arg[count+1]
        deli_found = True
        end_of_address = count
        break

    try:
        letter = int(letter)
        # print("Is int")
    except:
        delimitor = letter
        end_of_address = count
        # print(f"eoa = {end_of_address}")
        deli_found = True
        break
    
    
# print(f"Address starts from 0 to {end_of_address}, delimitor is {delimitor}")
# print(f"Address: {arg[0:end_of_address]}")
if end_of_address != 0:
    arg = arg[:end_of_address] + delimitor + arg[end_of_address:]
splited = re.split(delimitor, arg)
# print(f"arg splitted = {splited}")

sub_address = -1
sub_condition = ""
sub_target = ""
sub_replace = ""
if "s" == splited[0]:
    sub_target = splited[1]
    sub_replace = splited[2]
elif "s" == splited[1]:
    sub_address = int(splited[0])
    sub_target = splited[2]
    sub_replace = splited[3]
elif "s" == splited[2]:
    sub_condition = splited[1]
    sub_target = splited[3]
    sub_replace = splited[4]
print(f"Addr = {sub_address}\nCond = {sub_condition}\nTar = {sub_target}\nRep = {sub_replace}")

for count, line in enumerate(sys.stdin):
    modified = line
    # print(f"count = {count}")
    if count + 1 == sub_address:
        print("Try sub due to address")
        modified = re.sub(sub_target, sub_replace, modified)
    elif sub_address == -1 and re.search(sub_condition, line) != None:
        print("Try sub due to match condition")
        modified = re.sub(sub_target, sub_replace, modified)
    elif sub_address == -1 and sub_condition == "" and re.search(sub_target, line) != None:
        print("Try sub due to standard sub target found")
        modified = re.sub(sub_target, sub_replace, modified)
    print(modified, end = "")