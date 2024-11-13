#!/bin/bash

xcode-select --install

mkdir Tech_acharya

cd Tech_acharya

LOG_DIR="./logs"
LOG_FILE="smart_tech.log"
LOG_PATH="$LOG_DIR/$LOG_FILE"

if [ ! -d "$LOG_DIR" ]; then
    mkdir -p "$LOG_DIR"
    echo "Log directory created: $LOG_DIR"
fi

# Check if the log file exists
if [ -f "$LOG_PATH" ]; then
    # If the log file exists, delete all log files in the directory
    rm -f "$LOG_DIR/*.log"
    echo "All log files in $LOG_DIR have been deleted."
fi

# If no log file exists, create a new log file
touch "$LOG_PATH"
echo "New log file created: $LOG_PATH"

if [ ! -f "smartmontools-7.4.tar.gz" ]; then
    echo  "\n\n\n Downloading the file \n\n\n " >> $LOG_FILE
    wget  https://sourceforge.net/projects/smartmontools/files/smartmontools/7.4/smartmontools-7.4.tar.gz/download -O smartmontools-7.4.tar.gz
    echo  "\n\n\n Extracting file \n\n\n" >> $LOG_FILE
    tar -xzf smartmontools-7.4.tar.gz >> $LOG_FILE
    rm smartmontools-7.4.tar.gz
    mv smartmontools-7.4 smart_tools_tech_acharya
fi

cd smart_tools_tech_acharya

echo  "\n\n\n Configure file \n\n\n" >> $LOG_FILE
./configure >> $LOG_FILE

echo  "\n\n\n Complie file \n\n\n" >> $LOG_FILE
make >> $LOG_FILE

echo  "\n\n\n Complie Successful \n\n\n" >> $LOG_FILE
# Declare an associative array (map) to store the extracted values
model_number=""
available_spare=""
available_spare_threshold=""
percentage_used=""
total_ssd_storage=""
total_ssd_writes=""
total_ssd_reads=""
# Capture the output of the command
smartctl_output=$(./smartctl -a /dev/disk0)
diskutil_data=$(diskutil list)

model_number=$(echo "$smartctl_output" | grep "Model Number:" | awk -F ": " '{print $2}')
available_spare=$(echo "$smartctl_output" | grep "Available Spare:" | awk -F ": " '{print $2}')
available_spare_threshold=$(echo "$smartctl_output" | grep "Available Spare Threshold:" | awk -F ": " '{print $2}')
percentage_used=$(echo "$smartctl_output" | grep "Percentage Used:" | awk -F ": " '{print $2}')
total_ssd_storage=$(echo "$diskutil_data" | grep "GUID_partition_scheme" | awk '{ print $3 }')
total_ssd_reads=$(echo "$smartctl_output" | grep "Data Units Read:" | awk -F "[][]" '{print $2}')
total_ssd_writes=$(echo "$smartctl_output" | grep "Data Units Written:"  | awk -F "[][]" '{print $2}')

# echo "$data_Units_Read"
# echo "----"
# echo "$data_Units_Written"

# Print the extracted values

echo " \n\n\n Details \n\n\n" >> $LOG_FILE
echo " \n\n\n Model Number: $model_number \n\n\n" >> $LOG_FILE
echo " \n\n\n Available Spare: $available_spare \n\n\n" >> $LOG_FILE
echo " \n\n\n Available Spare Threshold: $available_spare_threshold \n\n\n" >> $LOG_FILE
echo " \n\n\n Percentage Used: $percentage_used \n\n\n" >> $LOG_FILE

echo " \n\n\n Total Storage: $total_ssd_storage \n\n\n" >> $LOG_FILE
echo " \n\n\n Total Data Written: $total_ssd_writes \n\n\n" >> $LOG_FILE
echo " \n\n\n Total Data Read: $total_ssd_reads \n\n\n" >> $LOG_FILE

echo " Model Number: $model_number " 
echo " Available Spare: $available_spare "
echo " Available Spare Threshold: $available_spare_threshold "
echo " Percentage Used: $percentage_used "
echo " Total Storage:                      $total_ssd_storage"
echo " Total Data Written:                 $total_ssd_writes"
echo " Total Data Read:                    $total_ssd_reads"
