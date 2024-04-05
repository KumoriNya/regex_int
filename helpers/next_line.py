import sys

line = sys.stdin.readline()
next_line = ""
while True:
    print(f"line = '{line[:-1]}'")
    next_line = sys.stdin.readline()
    if next_line == "":
        print(f"Current line: {line}, next line: '{next_line}' is the last line")
        break
    line = next_line
