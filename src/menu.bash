#!/usr/bin/env bash
# hyper-commander stage 1

print_menu() {
  echo """
------------------------------
| Hyper Commander            |
| 0: Exit                    |
| 1: OS info                 |
| 2: User info               |
| 3: File and Dir operations |
| 4: Find Executables        |
------------------------------
"""
}

echo "Hello $USER!"
print_menu && read choice
while [[ ! $choice = "0" ]]; do
  case $choice in
    1) uname -no;;
    2) whoami;;
    [3-4]) echo "Not implemented!";;
    *) echo "Invalid option!";;
  esac
  print_menu && read choice
done
echo "Farewell!"