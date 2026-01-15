: '
    Setup environment for run configuration.

    Run 'source path/to/setup_env.sh' for persistant settings.
'

#!/bin/bash

# Load requisite modules
module load python3
module load cuda
module load gcc/14.2.0-binutils-2.43

# Activate virtual environment: #TODO: This does not work. It only works for the current
. /path/to/venv/bin/activate;
