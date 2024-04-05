#! /usr/bin/env python3

from dataclasses import replace
import sys
import re

# def handle_flag()

def interpret(to_interpret):
    if to_interpret[0] not in ["/","s"]:
        print(f"position = {to_interpret[0]}")
        return to_interpret

def execute_command(command, text, address):
    print(f"Command = {command}")
    last    = command[-1]
    first   = command[0]
    operated_text = ""
    if last     == "q":
        target_pos  = int(command[:-1]) 
        operated_text = text
        if address == target_pos:
            print("quit")
            exit(0)
    elif last   == "p":
        target_pos  = int(command[:-1]) 
        operated_text = text
        if address == target_pos:
            print(text)
    elif last   == "d":
        print("delete")
    elif first  == "s":
        print("subsititue")

    return operated_text

def error_check(error_type, to_check):
    if error_type == "usage":
        if len(to_check) < 2:
            print("usage: slippy [-i] [-n] [-f <script-file> | <sed-command>] [<files>...]")
            exit(1)

def try_replace(line):
    pass
    # try s

if __name__ == "__main__":
    error_check("usage", sys.argv)
    all_inputs  = sys.argv[1:]
    flags       = [ i for i  in all_inputs if i.startswith('-')] # from https://stackoverflow.com/questions/44517191/how-to-find-the-python-list-item-that-start-with
    # print(flags)
    commands    = [ i for i in all_inputs if i not in flags]
    # print(commands)
    # print(type(commands))
    command_separators = ";\n"
    list_of_commands = re.split("[;]", commands[0])
    # print(list_of_commands)
    # Check what commands exist
    quits   = []
    prints  = []
    deletes = []
    substitutes = []
    for command in list_of_commands:
        if "q" == command[-1]:
            delimitor = command[0]
            del_address = -1
            del_target = ""
            try:
                delimitor = int(delimitor)
            except:
                pass
            if not isinstance(delimitor, int):
                regex = re.split(delimitor, command)[1]
            else:
                del_address = int(command[:-1])
            quits.append(
                {
                    'del_address'   : del_address,
                    'del_target'    : del_target
                }
            )
            # print("Will quit")
        elif "p" == command[-1]:
            prints.append(command)
            # print("Will print")
        elif "d" == command[-1]:
            deletes.append(command)
            # print("Will delete")
        else:
            end_of_address = 0
            delimitor = ""
            deli_found = False
            for count, letter in enumerate(command):
                if letter == "s":
                    delimitor = command[count+1]
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
    
            if end_of_address != 0:
                command = command[:end_of_address] + delimitor + command[end_of_address:]
            splited = re.split(delimitor, command)
            sub_address = -1
            sub_condition = ""
            sub_target = ""
            sub_replace = ""
            if "s" == splited[0]:
                sub_target = splited[1]
                sub_replace = splited[2]
            elif "s" == splited[1]:
                sub_address = splited[0]
                sub_target = splited[2]
                sub_replace = splited[3]
            elif "s" == splited[2]:
                sub_condition = splited[1]
                sub_target = splited[3]
                sub_replace = splited[4]
            replace_all = False
            if "g" == splited[-1]:
                replace_all = True
            substitutes.append(
                {
                    'sub_address'   : sub_address,
                    'sub_condition' : sub_condition,
                    'sub_target'    : sub_target,
                    'sub_replace'   : sub_replace,
                    'replace_all'   : replace_all
                }
            )
                # print(sub_command)
    # print(substitutes)
    # Cant read all stdin in one go, read input as we go
    address = 0
    to_quit = False
    for line in sys.stdin:
        address += 1
        modified = line
        if len(deletes) != 0:
            for delete in deletes:
                delimitor = delete[0]
                try:
                    delimitor = int(delimitor)
                except:
                    pass
                if not isinstance(delimitor, int):
                # print(delimitor)
                # print(re.split(delimitor, delete))
                    regex = re.split(delimitor, delete)[1]
                    if re.search(regex, modified) != None:
                        modified=''
                # print(delete)
                else:
                    target_address = int(delete[:-1])
                    if address == target_address:
                        modified=''
        if len(substitutes) != 0:
            # 1. distinguish different situatsions:
            # 1.1 starts with s, then delimitor, thus split to obtain sub_target, sub_replace, potentially g
            # 1.2 starts with integer, then find delimitor, apply the same, but substitutes only for the address
            # 1.3 starts with delimitor, then split to obtain:
            #   lines that matches the sub_condition, "s", sub_target(regex), sub_replace, potentially g
            for sub in substitutes:
                sub_address = int(sub['sub_address'])
                sub_condition = sub['sub_condition']
                sub_target = sub['sub_target']
                sub_replace = sub['sub_replace']
                replace_all = sub['replace_all']
                sub_count = 1
                if replace_all:
                    sub_count = 0
                if address == sub_address:
                    # print("Try sub due to address")
                    modified = re.sub(sub_target, sub_replace, modified, sub_count)
                elif sub_address == -1 and re.search(sub_condition, modified) != None:
                    # print("Try sub due to match condition")
                    modified = re.sub(sub_target, sub_replace, modified, sub_count)
                elif sub_address == -1 and sub_condition == "" and re.search(sub_target, modified) != None:
                    # print("Try sub due to standard sub target found")
                    modified = re.sub(sub_target, sub_replace, modified, sub_count)
        if "-n" not in flags:
            print(modified, end='')
        if len(prints) != 0:
            for p in prints:
                delimitor = p[0]
                try:
                    delimitor = int(delimitor)
                except:
                    pass
                if not isinstance(delimitor, int):
                # print(delimitor)
                # print(re.split(delimitor, p))
                    regex = re.split(delimitor, p)[1]
                    if re.search(regex, line) != None:
                        print(line, end = '')
                # print(p)
                else:
                    target_address = int(p[:-1])
                    if address == target_address:
                        print(line, end = '')
        if len(quits) != 0:
            for quit in quits:
                delimitor = quit[0]
                try:
                    delimitor = int(delimitor)
                except:
                    pass
                if not isinstance(delimitor, int):
                # print(delimitor)
                # print(re.split(delimitor, quit))
                    regex = re.split(delimitor, quit)[1]
                    if re.search(regex, line) != None:
                        to_quit = True
                # print(quit)
                else:
                    target_address = int(quit[:-1])
                    if address == target_address:
                        to_quit = True
        if to_quit:
            break


