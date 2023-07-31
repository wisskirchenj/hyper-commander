setup() {
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'
    SRC_DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/../src"
}

function menu() {
    echo -e $1 | bash $SRC_DIR/menu.bash
}

# ---------- happy case testing -------

@test "exit" {
        run menu "0"
        assert_output --partial "Hello $USER!"
        assert_output --partial "------------------------------"
        assert_output --partial "| Hyper Commander            |"
        assert_output --partial "| 4: Find Executables        |"
}

@test "user info" {
        userinfo=$(whoami)
        run menu "2\n 0"
        assert_output --partial "$userinfo"
        assert_output --partial "------------------------------"
        assert_output --partial "| Hyper Commander            |"
        assert_output --partial "| 4: Find Executables        |"
}

@test "OS info" {
        osinfo=$(uname -no)
        run menu "1\n 0"
        assert_output --partial "$osinfo"
        assert_output --partial "------------------------------"
        assert_output --partial "| Hyper Commander            |"
        assert_output --partial "| 4: Find Executables        |"
}

# ---------- error case testing -------

@test "too large number" {
        run menu "5\n 0"
        assert_output --partial "------------------------------"
        assert_output --partial "| Hyper Commander            |"
        assert_output --partial "| 4: Find Executables        |"
        assert_output --partial "Invalid option!"
}

@test "negative number" {
        run menu "-1\n 0"
        assert_output --partial "Invalid option!"
}

@test "two digits" {
        run menu "11\n 0"
        assert_output --partial "Invalid option!"
}

@test "empty" {
        run menu "\n 0"
        assert_output --partial "Invalid option!"
}

@test "not a digit" {
        run menu "five\n 0"
        assert_output --partial "Invalid option!"
}
