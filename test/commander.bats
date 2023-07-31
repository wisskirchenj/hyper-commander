setup() {
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'
    SRC_DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/../src"
}

function commander() {
    echo -e $1 | bash $SRC_DIR/commander.bash
}

# ---------- happy case testing -------

@test "exit" {
        run commander "0"
        assert_line "Hello $USER!"
        assert_line "------------------------------"
        assert_line "| Hyper Commander            |"
        assert_line "| 4: Find Executables        |"
        assert_line "Farewell!"
}

@test "user info" {
        userinfo=$(whoami)
        run commander "2\n 0"
        assert_line "$userinfo"
        assert_line "------------------------------"
        assert_line "| Hyper Commander            |"
        assert_line "| 4: Find Executables        |"
}

@test "OS info" {
        osinfo=$(uname -no)
        run commander "1\n 0"
        assert_line "$osinfo"
        assert_line "------------------------------"
        assert_line "| Hyper Commander            |"
        assert_line "| 4: Find Executables        |"
}

@test "dir listing" {
        run commander "3\n 0\n 0"
        assert_line "The list of files and directories:"
        assert_line "| 0 Main menu | 'up' To parent | 'name' To select |"
        assert_line "F runtests"
        assert_line "F .gitignore"
        assert_line "D test"
}

@test "dir subdir and up" {
        run commander "3\n test\n up\n 0\n 0"
        assert_line "The list of files and directories:"
        assert_line "| 0 Main menu | 'up' To parent | 'name' To select |"
        assert_line "F runtests"
        assert_line "D test_helper"
}

@test "dir subdir and upp" {
        run commander "3\n test\n up\n 0\n 0"
        assert_line "The list of files and directories:"
        assert_line "| 0 Main menu | 'up' To parent | 'name' To select |"
        assert_line "F runtests"
        assert_line "D test_helper"
}

@test "file delete" {
        touch afile
        run commander "3\n afile\n 1\n 0\n 0"
        assert_line "F afile"
        refute_line "Invalid input!"
        refute_line "Invalid option!"
        assert_line "afile has been deleted."
}

@test "file rename" {
        touch bfile
        run commander "3\n bfile\n 2\n cfile\n cfile\n 1\n 0\n 0"
        assert_line "F bfile"
        assert_line "F cfile"
        assert_line "Enter the new file name:"
        refute_line "Invalid input!"
        refute_line "Invalid option!"
        assert_line "bfile has been renamed as cfile"
        assert_line "cfile has been deleted."
}

@test "file chmod write" {
        touch dfile
        run commander "3\n dfile\n 3\n dfile\n 1\n 0\n 0"
        assert_line "F dfile"
        refute_line "Invalid input!"
        refute_line "Invalid option!"
        assert_line "Permissions have been updated."
        assert_line  --partial "-rw-rw-rw- "
}

@test "file chmod read" {
        touch efile
        run commander "3\n efile\n 3\n efile\n 4\n efile\n 1\n 0\n 0"
        assert_line "F efile"
        refute_line "Invalid input!"
        refute_line "Invalid option!"
        assert_line "Permissions have been updated."
        assert_line  --partial "-rw-rw-rw- "
        assert_line  --partial "-rw-rw-r-- "
}

@test "executable runs" {
        run commander "4\n ls\n -al\n 0"
        assert_line "Enter an executable name:"
        assert_line "Enter arguments:"
        assert_line --partial "Located in:"
        assert_line --partial "total "
        refute_line "The executable with that name does not exist!"
        refute_line "Invalid input!"
        refute_line "Invalid option!"
}

# ---------- error case testing -------

@test "too large number" {
        run commander "5\n 0"
        assert_line "------------------------------"
        assert_line "| Hyper Commander            |"
        assert_line "| 4: Find Executables        |"
        assert_line "Invalid option!"
}

@test "negative number" {
        run commander "-1\n 0"
        assert_line "Invalid option!"
}

@test "two digits" {
        run commander "11\n 0"
        assert_line "Invalid option!"
}

@test "empty" {
        run commander "\n 0"
        assert_line "Invalid option!"
}

@test "not a digit" {
        run commander "five\n 0"
        assert_line "Invalid option!"
}

@test "file menu invalid no" {
        run commander "3\n 1\n 0\n 0"
        assert_line "The list of files and directories:"
        assert_line "| 0 Main menu | 'up' To parent | 'name' To select |"
        assert_line "F runtests"
        assert_line "Invalid input!"
}

@test "file menu invalid text" {
        run commander "3\n somerandomtext\n 0\n 0"
        assert_line "The list of files and directories:"
        assert_line "| 0 Main menu | 'up' To parent | 'name' To select |"
        assert_line "F runtests"
        assert_line "Invalid input!"
}

@test "file operations invalid choices silent" {
        run commander "3\n runtests\n 5\n 0\n 0\n 0"
        assert_line "The list of files and directories:"
        assert_line "| 0 Main menu | 'up' To parent | 'name' To select |"
        menuline="\| 0 Back \| 1 Delete \| 2 Rename \| 3 Make writable \| 4 Make read-only \|"
        assert_output --regexp ".*${menuline}.*${menuline}.*"         # menuline is in twice
        assert_line "F runtests"
        refute_line "Invalid input!"
        refute_line "Invalid option!"
}

@test "executable not there" {
        run commander "4\n not_there\n 0"
        assert_line "Enter an executable name:"
        assert_line "The executable with that name does not exist!"
        refute_line "Invalid input!"
        refute_line "Invalid option!"
        refute_line "Enter arguments:"
}
