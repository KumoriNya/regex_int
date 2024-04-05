#! /usr/bin/env dash

# ==============================================================================
# test09.sh
# Test subset1 slippy commands when white spaces and '&' are in regex.
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
# 1. $ in regex
    seq 1 10 | 2041 slippy -n '/$/d; /$/p' > "$expected_output" 2>&1

    seq 1 10 | slippy -n '/$/d; /$/p' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

    seq 1 10 | 2041 slippy -n '/$/d; /[$]/p' > "$expected_output" 2>&1

    seq 1 10 | slippy -n '/$/d; /[$]/p' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

    seq 1 10 | 2041 slippy -n '/$/d; $p' > "$expected_output" 2>&1

    seq 1 10 | slippy -n '/$/d; $p' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

    seq 1 10 | 2041 slippy '/[$]/,/3/s?[0-9]?$$$?g' > "$expected_output" 2>&1

    seq 1 10 | slippy '/[$]/,/3/s?[0-9]?$$$?g' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

    seq 1 10 | 2041 slippy '/$/,/3/s?[0-9]?$$$?g' > "$expected_output" 2>&1

    seq 1 10 | slippy '/$/,/3/s?[0-9]?$$$?g' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi
# 2. white spaces in regex
    seq 1 10 | 2041 slippy '/[ 0 - 9 ]/,/3/s?[ 0 - 9 ]?$$$?g' > "$expected_output" 2>&1

    seq 1 10 | slippy '/[ 0 - 9 ]/,/3/s?[ 0 - 9 ]?$$$?g' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

    seq 1 10 | 2041 slippy '/[ 0 - 9 ]/,/3/s?[0-9]?$$$?g' > "$expected_output" 2>&1

    seq 1 10 | slippy '/[ 0 - 9 ]/,/3/s?[0-9]?$$$?g' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi
echo "Passed test"
exit 0