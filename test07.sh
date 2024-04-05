#! /usr/bin/env dash

# ==============================================================================
# test07.sh
# Test subset1 slippy commands with range of addresses.
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
# 1. operates with integer address ranges
    seq 1 5 | 2041 slippy '1,3s/[123]/yo/; 1,3p; 1,3d;4p;5q' > "$expected_output" 2>&1

    seq 1 5 | slippy '1,3s/[123]/yo/; 1,3p; 1,3d;4p;5q' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

# 2. operates with one of the address being regex address ranges
    seq 1 5 | 2041 slippy '1,/^2/s/[123]/yo/; /[0-9]/,3p; 1,/^3/d;4p;5q' > "$expected_output" 2>&1

    seq 1 5 | slippy '1,/^2/s/[123]/yo/; /[0-9]/,3p; 1,/^3/d;4p;5q' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi
    
# 3. operates with regex address ranges
    seq 10 35 | 2041 slippy '/5$/,/^3/s/[7-9]/hey/; /^1/,/^3/p' > "$expected_output" 2>&1

    seq 10 35 | slippy '/5$/,/^3/s/[7-9]/hey/; /^1/,/^3/p' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

# 4. operates when the second address is smaller the the first
    seq 1 5 | 2041 slippy -n '3,1p;4q;4d' > "$expected_output" 2>&1

    seq 1 5 | slippy -n '3,1p;4q;4d' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

echo "Passed test"
exit 0