#! /usr/bin/env dash

# ==============================================================================
# test02.sh
# Test subset1 slippy commands with $ representing last line.
#
# Written by: Claude Sun
# Date: 2022-08-07
# For COMP2041 Assignment 2
# ==============================================================================

# Create a temporary directory for the test.

    PATH="$PATH:$(pwd)"
    test_dir="$(mktemp -d)"
    cd "$test_dir" || exit 1

# Create some files to hold output.

    expected_output="$(mktemp)"
    received_output="$(mktemp)"

# Remove the temporary directory when the test is done.

    trap 'rm "$expected_output" "$received_output" -rf "$test_dir"' INT HUP QUIT TERM EXIT

# Test if slippy:
# 1. deletes
# 2. prints
# 3. quits
# with $

    seq 0 99 | 2041 slippy '$d' > "$expected_output" 2>&1

    seq 0 99 | slippy '$d' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

    seq 0 99 | 2041 slippy -n '$p' > "$expected_output" 2>&1

    seq 0 99 | slippy -n '$p' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

    seq 0 99 | 2041 slippy '$q' > "$expected_output" 2>&1

    seq 0 99 | slippy '$q' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

# Test if slippy substitutes with $
    seq 0 99 | 2041 slippy '$sX[0-9]XabcX' > "$expected_output" 2>&1

    seq 0 99 | slippy '$sX[0-9]XabcX' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

    seq 0 99 | 2041 slippy '$sX[0-9]XabcXg' > "$expected_output" 2>&1

    seq 0 99 | slippy '$sX[0-9]XabcXg' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

echo "Passed test"
exit 0