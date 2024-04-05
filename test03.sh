#! /usr/bin/env dash

# ==============================================================================
# test03.sh
# Test subset1 slippy commands with multiple commands.
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
# 1. prints before deletes
# 2. prints after deletes

    seq 0 10 | 2041 slippy '/[0-5]/p;5d' > "$expected_output" 2>&1

    seq 0 10 | slippy '/[0-5]/p;5d' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

    seq 0 10 | 2041 slippy '5d;/[0-5]/p' > "$expected_output" 2>&1

    seq 0 10 | slippy '5d;/[0-5]/p' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

# 3. quits before prints
# 4. quits after prints

    seq 0 99 | 2041 slippy '5q;5p' > "$expected_output" 2>&1

    seq 0 99 | slippy '5q;5p' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

    seq 0 99 | 2041 slippy '5p;5q' > "$expected_output" 2>&1

    seq 0 99 | slippy '5p;5q' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

# 5. substitutes then deletes
# 6. deletes then substitutes

    seq 0 10 | 2041 slippy 's?[2-5]?9?;/[2-5]/d' > "$expected_output" 2>&1

    seq 0 10 | slippy 's?[2-5]?9?;/[2-5]/d' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

    seq 0 10 | 2041 slippy '/[2-5]/d;s?[2-5]?9?' > "$expected_output" 2>&1

    seq 0 10 | slippy '/[2-5]/d;s?[2-5]?9?' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

# 7. deletes then quits
# 8. quits then deletes

    seq 0 10 | 2041 slippy '5d;5q' > "$expected_output" 2>&1

    seq 0 10 | slippy '5d;5q' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

    seq 0 10 | 2041 slippy '5q;5d' > "$expected_output" 2>&1

    seq 0 10 | slippy '5q;5d' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

# 9. substitutes then prints
#10. prints then substitutes

    seq 0 10 | 2041 slippy 's?[2-5]?9?;/[2-5]/p' > "$expected_output" 2>&1

    seq 0 10 | slippy 's?[2-5]?9?;/[2-5]/p' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

    seq 0 10 | 2041 slippy '/[2-5]/p;s?[2-5]?9?' > "$expected_output" 2>&1

    seq 0 10 | slippy '/[2-5]/p;s?[2-5]?9?' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

#11. substitutes then quits
#12. quits then substitutes

    seq 0 10 | 2041 slippy 's?[2-5]?9?;/[2-5]/q' > "$expected_output" 2>&1

    seq 0 10 | slippy 's?[2-5]?9?;/[2-5]/q' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi

    seq 0 10 | 2041 slippy '/[2-5]/q;s?[2-5]?9?' > "$expected_output" 2>&1

    seq 0 10 | slippy '/[2-5]/q;s?[2-5]?9?' > "$received_output" 2>&1

    if ! diff "$expected_output" "$received_output"; then
        echo "Failed test"
        exit 1
    fi


echo "Passed test"
exit 0