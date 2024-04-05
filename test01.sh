#! /usr/bin/env dash

# ==============================================================================
# test01.sh
# Test subset1 slippy commands with less restricted delimiters.
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

# Test if slippy substitutes with non '/' delimeters

    seq 1 5 | 2041 slippy 'sX[15]XzzzX' > "$expected_output" 2>&1

    seq 1 5 | slippy 'sX[15]XzzzX' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

    seq 1 5 | 2041 slippy 's?[15]?zzz?' > "$expected_output" 2>&1

    seq 1 5 | slippy 's?[15]?zzz?' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

    seq 1 5 | 2041 slippy 's5[15]5zzz5' > "$expected_output" 2>&1

    seq 1 5 | slippy 's5[15]5zzz5' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

echo "Passed test"
exit 0