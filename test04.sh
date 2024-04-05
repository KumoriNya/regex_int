#! /usr/bin/env dash

# ==============================================================================
# test04.sh
# Test subset1 slippy commands with -f and file commands.
#
# Written by: Claude Sun
# Date: 2022-08-07
# For COMP2041 Assignment 2
# ==============================================================================

# Create a temporary directory for the test.

    PATH="$PATH:$(pwd)"
    test_dir="$(mktemp -d)"
    cd "$test_dir" || exit 1

# Create some temporary files.

    expected_output="$(mktemp)"
    received_output="$(mktemp)"
    commands_slippy="$(mktemp)"
    two_txt="$(mktemp)"
    five_txt="$(mktemp)"
    seq 1 2 > two_txt
    seq 1 5 > five_txt
# Remove the temporary directory when the test is done.

    trap 'rm "$expected_output" "$received_output" "commands.slippy" "two_txt" "five_txt" -rf "$test_dir"' INT HUP QUIT TERM EXIT

# Test if slippy:
# 1. operates with command file and stdin
    echo 4q   >  commands.slippy
    echo /2/d >> commands.slippy
    seq 1 5 | 2041 slippy -f commands.slippy > "$expected_output" 2>&1

    seq 1 5 | slippy -f commands.slippy > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

    echo /2/d >  commands.slippy
    echo 4q   >> commands.slippy
    seq 1 5 | 2041 slippy -f commands.slippy > "$expected_output" 2>&1

    seq 1 5 | slippy -f commands.slippy > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

# 2. operates with cmd and file input
    2041 slippy '5q;5p' two_txt five_txt > "$expected_output" 2>&1

    slippy '5q;5p' two_txt five_txt > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

# 3. operates with command file and file input
    echo 4q   >  commands.slippy
    echo /2/d >> commands.slippy
    2041 slippy -f commands.slippy two_txt five_txt > "$expected_output" 2>&1

    slippy -f commands.slippy two_txt five_txt > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

    echo /2/d >  commands.slippy
    echo 4q   >> commands.slippy
    2041 slippy -f commands.slippy two_txt five_txt > "$expected_output" 2>&1

    slippy -f commands.slippy two_txt five_txt > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

echo "Passed test"
exit 0