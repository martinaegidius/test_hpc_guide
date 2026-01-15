: '
    Run a target python script with debugging support interactively on the GPU with least resource use.
    
    Usage:
        bash run_file.sh [FILEPATH] [--multi <num_gpus>] [--debug]

    Specifying FILEPATH as an argument overwrites FILEPATH defined in file.
    --debug flag should be provided if you wish to attach a VSCode debug session over remote ssh. 

    Authors: Ludvík Petersen and Martin Ægidius, Technical University of Denmark 
'
#!/bin/bash

# ---- Personalized variables ---- #

FILEPATH="src/main.py"
PORT="5678"

# ---- Personalized variables ---- #

# ---- environment variables ---- #

# Get current python version and the number of GPUs set to use
PYTHON_VERSION=$(python --version | grep -o "3.[0-9]\+\b" | awk -F '.' '{print $NF}') # Extract the minor version( of Python
NUM_GPUS=$([ "$1" == "--multi" ] && echo "$2" || echo 1) # Number of GPUs to use

# Extract optimal device(s):
DEVICE_CONFIG=$(nvidia-smi --query-gpu=index,memory.free --format=csv,noheader,nounits \
    | sort -t, -k2 -nr | head -n $(($NUM_GPUS)))
DEVICE=$(awk -F, -v n="$NUM_GPUS" '{line=line "," $1} NR%n==0{print substr(line,2); line=""}' <<< $DEVICE_CONFIG) # Extract the GPU index
RESOURCES=$(awk -F, -v n="$NUM_GPUS" '{line=line "," $2} NR%n==0{print substr(line,3); line=""}' <<< $DEVICE_CONFIG) # Extract the GPU memory available

# Get IPv4 address for machine:
HOST=$(ip addr show eth0 | awk '/inet / {print $2}' | cut -d/ -f1)

# ---- environment variables ---- #

# Load modules and activate virtual environment if necessary
if [ "$(($PYTHON_VERSION))" -lt 11 ]; then
    source scripts/setup_env.sh
fi

# Set CUDA DEVICE(S)
export CUDA_VISIBLE_DEVICES=$DEVICE

echo "Running training script with devices: $DEVICE (memory: $RESOURCES)"
echo "Machine properties: $HOST:$PORT"

# Run main script script
# FILEPATH=$([ -z "$FILEPATH" ] && $2 || $FILEPATH)
FILEPATH=$( [ $# -ge 1 ] && [ "${1#--}" = "$1" ] && printf '%s' "$1" || printf '%s' "$FILEPATH" )
echo $FILEPATH
if [ ${*: -1} == "--debug" ]; then
    python3 -m debugpy --listen $HOST:$PORT --wait-for-client $FILEPATH
else
    python $FILEPATH
fi
