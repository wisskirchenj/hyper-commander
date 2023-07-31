#!/usr/bin/env bash
# hyper-commander stage 5

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

print_file_menu() {
  echo """
---------------------------------------------------
| 0 Main menu | 'up' To parent | 'name' To select |
---------------------------------------------------"""
}

print_file_ops_menu() {
  echo """
---------------------------------------------------------------------
| 0 Back | 1 Delete | 2 Rename | 3 Make writable | 4 Make read-only |
---------------------------------------------------------------------"""
}

list_directory() {
  echo -e "\nThe list of files and directories:"
  find . -type f -maxdepth 1 | sed "s/^.\//F /"
  find . -type d -maxdepth 1 | grep -v "^.$" | sed "s/^.\//D /"
  print_file_menu
}

rename() {
  echo "Enter the new file name:" && read newfile
  mv $1 $newfile
  echo "$1 has been renamed as $newfile"
}

change_permission() {
  chmod $2 $1
  echo "Permissions have been updated."
  ls -l $file
}

file_operations() {
  file=$1
  print_file_ops_menu && read operation
  while [[ ! $operation =~ [0-4] ]]; do
    print_file_ops_menu && read operation
  done
  case $operation in
    1) rm $file && echo "$file has been deleted.";;
    2) rename $file;;
    3) change_permission $file a+w;;
    4) change_permission $file o-w;;
  esac
}

file_menu() {
  list_directory && read input
  while [[ ! $input = "0" ]]; do
    if [[ "up" = $input ]]; then
      cd ..
    elif [[ -d $input ]]; then
      cd $input
    else
      [[ -f $input ]] && file_operations $input || echo "Invalid input!"
    fi
    list_directory && read input
  done
}

find_executable() {
  echo "Enter an executable name:" && read executable
  where_output=($(whereis -b $executable))
  exec=${where_output[1]}
  [[ -z $exec ]] && echo "The executable with that name does not exist!" && return
  echo "Located in: $exec"
  echo "Enter arguments:" && read arguments
  $exec $arguments
}

echo "Hello $USER!"
print_menu && read choice
while [[ ! $choice = "0" ]]; do
  case $choice in
    1) uname -no;;
    2) whoami;;
    3) file_menu;;
    4) find_executable;;
    *) echo "Invalid option!";;
  esac
  print_menu && read choice
done
echo "Farewell!"