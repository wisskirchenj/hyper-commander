# IDEA EDU Course ...

Implemented in the Track 'Introduction to Command Line and Unix Shell' of hyperskill.org's JetBrains Academy.

## Technology / External Libraries

- bash 5.2.15 on macOS
- bash testing suite BATS (bats-core, bats-assert, bats-support)
- gnu-sed (brew installed ...)

## Repository Contents

The sources of main project tasks (6 stages) and testing.

## Setup the `bats` test suite (MIT license) 

```bash
git submodule add https://github.com/bats-core/bats-core.git test/bats
git submodule add https://github.com/bats-core/bats-support.git test/test_helper/bats-support
git submodule add https://github.com/bats-core/bats-assert.git test/test_helper/bats-assert
```

## Run all tests

```bash
./runtests
```

## Program description

The toy project implements a file manager similar to the then popular Norton Commander. The usability and a visual 
interface is key.

Run tests using bats (see above).

Have fun!

## Project completion

Project was completed on 31.07.23.

## Progress

31.07.23 Project started - gitHub repo and project structure setup.

31.07.23 Stage 1 completed - just printing of menu and input checking.

31.07.23 Stage 2 completed - use `uname` and `whoami` command .

31.07.23 Stage 3 completed - file menu with string operations - solved using GNU-`sed` and `find`. Great stage!

31.07.23 Stage 4 completed - change directory levels in the commander - navigate through file system.

31.07.23 Stage 5 completed - implement file operations - cllas of `rm`, `mv` and `chmod`.

31.07.23 Final stage 6 completed - find executables with `whereis` and split string into tokens with `($str)`.
