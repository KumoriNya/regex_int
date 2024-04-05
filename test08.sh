#! /usr/bin/env dash

# ==============================================================================
# test08.sh
# Test subset1 slippy commands subtle cases.
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
# 1. integer range prints but regex range does not match when first line deleted
    seq 1 10 | 2041 slippy -n '/^1/d; /[1]/, $p' > "$expected_output" 2>&1

    seq 1 10 | slippy -n '/^1/d; /[1]/, $p' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

    seq 1 10 | 2041 slippy -n '/^1/d; 1, $p' > "$expected_output" 2>&1

    seq 1 10 | slippy -n '/^1/d; 1, $p' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

# 2. same integer range satisfies condition for one line, same regex range starts matching closing range from the next line 
    seq 1 10 | 2041 slippy -n '5,5p' > "$expected_output" 2>&1

    seq 1 10 | slippy -n '5,5p' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

    seq 1 10 | 2041 slippy -n '5,/[1-5]/p' > "$expected_output" 2>&1

    seq 1 10 | slippy -n '5,/[1-5]/p' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

    seq 1 11 | 2041 slippy -n '/[1-5]/,/^[1-5]/p' > "$expected_output" 2>&1

    seq 1 11 | slippy -n '/[1-5]/,/^[1-5]/p' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

echo "Passed test"
exit 0