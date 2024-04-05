#! /usr/bin/env dash

# ==============================================================================
# test00.sh
# Test subset0 slippy commands.
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


# Test if slippy gives correct usage message

    2041 slippy > "$expected_output" 2>&1

    slippy > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

# Test if slippy exits at correct address

    seq 1 5 | 2041 slippy '1d' > "$expected_output" 2>&1

    seq 1 5 | slippy '1d' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

# Test if slippy exits after all inputs are iterated

    seq 1 5 | 2041 slippy '6q' > "$expected_output" 2>&1

    seq 1 5 | slippy '6q' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

# Test if slippy exits when regex is matched

    seq 1 5 | 2041 slippy '/6/q' > "$expected_output" 2>&1

    seq 1 5 | slippy '/6/q' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

    seq 1 5 | 2041 slippy '/[0-9]/q' > "$expected_output" 2>&1

    seq 1 5 | slippy '/[0-9]/q' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

# Test if slippy prints:
# 1. all inputs
    seq 1 5 | 2041 slippy 'p' > "$expected_output" 2>&1

    seq 1 5 | slippy 'p' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

# 2. correct address
    seq 1 5 | 2041 slippy '2p' > "$expected_output" 2>&1

    seq 1 5 | slippy '2p' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

    seq 1 5 | 2041 slippy '6p' > "$expected_output" 2>&1

    seq 1 5 | slippy '6p' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

# 3. regex
    seq 1 5 | 2041 slippy '/[0-9]/p' > "$expected_output" 2>&1

    seq 1 5 | slippy '/[0-9]/p' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

    seq 1 5 | 2041 slippy '/[a-z]/p' > "$expected_output" 2>&1

    seq 1 5 | slippy '/[a-z]/p' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

    seq 1 5 | 2041 slippy -n /[a-z]/p > "$expected_output" 2>&1

    seq 1 5 | slippy -n /[a-z]/p > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

# Test if slippy deletes:
# 1. all inputs
    seq 1 5 | 2041 slippy d > "$expected_output" 2>&1

    seq 1 5 | slippy d > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

# 2. correct address
    seq 1 5 | 2041 slippy 2d > "$expected_output" 2>&1

    seq 1 5 | slippy 2d > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

    seq 1 5 | 2041 slippy 6d > "$expected_output" 2>&1

    seq 1 5 | slippy 6d > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

# 3. regex
    seq 1 5 | 2041 slippy '/[0-9]/d' > "$expected_output" 2>&1

    seq 1 5 | slippy '/[0-9]/d' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

    seq 1 5 | 2041 slippy '/[a-z]/d' > "$expected_output" 2>&1

    seq 1 5 | slippy '/[a-z]/d' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

    seq 1 5 | 2041 slippy -n /[a-z]/d > "$expected_output" 2>&1

    seq 1 5 | slippy -n /[a-z]/d > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

# Test if slippy substitutes:
# 1. correct address
    seq 1 5 | 2041 slippy 's/1/5/' > "$expected_output" 2>&1

    seq 1 5 | slippy 's/1/5/' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

    seq 1 5 | 2041 slippy 's/6/p/' > "$expected_output" 2>&1

    seq 1 5 | slippy 's/6/p/' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

# 2. regex
    seq 1 5 | 2041 slippy 's/[0-9]/hey/' > "$expected_output" 2>&1

    seq 1 5 | slippy 's/[0-9]/hey/' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

    seq 1 5 | 2041 slippy 's/[a-z]/hey/' > "$expected_output" 2>&1

    seq 1 5 | slippy 's/[a-z]/hey/' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

    seq 1 5 | 2041 slippy -n s/[a-z]/p/ > "$expected_output" 2>&1

    seq 1 5 | slippy -n s/[a-z]/p/ > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi







echo "Passed test"
exit 0