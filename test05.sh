#! /usr/bin/env dash

# ==============================================================================
# test05.sh
# Test subset1 slippy commands with comments.
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
# Remove the temporary directory when the test is done.

    trap 'rm "$expected_output" "$received_output" -rf "$test_dir"' INT HUP QUIT TERM EXIT

# Test if slippy:
# 1. command properly ends with newline
    seq 1 5 | 2041 slippy '/2/d#delete2
    4q#quit4' > "$expected_output" 2>&1

    seq 1 5 | slippy '/2/d#delete2
    4q#quit4' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

# 2. command without newline does not end
    seq 1 5 | 2041 slippy '/2/d#delete2;4q#quit4' > "$expected_output" 2>&1

    seq 1 5 | slippy '/2/d#delete2;4q#quit4' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

echo "Passed test"
exit 0