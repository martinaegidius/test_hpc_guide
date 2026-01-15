# Introduction
DTU HPC is DTUs computing cluster service, offering state of the art computing solution for developing computationally advanced algorithms. It is a more versatile alternative to services such as Google colab, as it allows to run experiments without connection and with control over the hardware used. This note is a hands-on tutorial on getting started on DTUs HPC system, and is, in most part, to be considered a practical extension of [DTU HPCs own material](https://www.hpc.dtu.dk/) for user's with little to no prior experience using cluster services or linux. We aditionally provide a GitHub repository which aids in establishing project structure and code debugging.   

## Accessing the cluster
The cluster is accessed using ssh. ssh is an abbreviation for *secure shell*, a network protocol which allows two computers to communicate. In order to be able to access the cluster using ssh, your computer needs to authenticate itself to the HPC, such that the HPC machine knows that you are indeed you. This authentication is either achieved by being logged onto a DTU WIFI network, the [DTU VPN](https://www.hpc.dtu.dk/?page_id=5685) or by using a private and public ssh key-pair. 

If you only need to use the cluster for a couple of days, using the VPN is fine. In this case, start and connect to the VPN service, and followingly open a terminal and write: 

```
ssh s123456@login1.gbar.dtu.dk
```

press enter, and enter the DTU password you always use to login into DTU services. Now move to the other sections of the tutorial.  

If, on the other hand, you're doing a longer project, setting up the ssh key pair is the best approach. To do so, open a terminal. Followingly, make a directory called .ssh in your home root by entering the following in the terminal: 
```
mkdir -p ~/.ssh
```

Here, -p is a flag to the command which allows parent folder creation, and does not give an error if the folder already exists. Followingly, change the working directory to the newly created directory issuing: 

```
cd .ssh 
```

and entering. `cd` means "change directory". Now it's time to generate the public and private ssh key-pair. Enter the following command: 
```
ssh-keygen -t ed25519 -f gbar
```
And enter a passphrase. This passphrase needs to be secure and secret, and cannot be the same passphrase which you use for your DTU login. This will create two files in your .ssh-directory: `gbar` and `gbar.pub`. Check this by entering 
```
ls -la
```
in your terminal. This lists all files and folders in the current working directory. Check that the two files are present. The `gbar` file is your private file and may in **no way** be shared, as this would allow adversaries to connect to the HPC services. We need to copy the content of the public key `gbar.pub` to the HPC server. Then, the HPC will accept an incoming connection from your PC. To do so, connect to the DTU VPN or be connected to a DTU WIFI network. Then ssh into the HPC service using a terminal and entering:

```
ssh s123456@login1.gbar.dtu.dk
```

and authorizing with your normal DTU password. Again, make a .ssh folder:
```
mkdir -m 700 -p ~/.ssh
```

here, -m is a flag which sets the mode of the folder as being only accessible by the owner (you) and the root (HPC admin). cd into the directory. Then write 
```
cat >> authorized_keys
``` 

and paste the complete contents of your *gbar.pub* file into the terminal and press enter. Then close the file by pressing `ctrl` + `d`. 

This file tells the system to accept incoming connections from your user on your machine. Finally, the permissions of the file need to be set to "600", which can be modified using the following command: 
```
chmod 600 authorized_keys
```
Now, you should be able to connect without the VPN active and from any network. Please remember still to be cautious and only login from networks which you trust.  

If you want to simplify the login procedure further, you can create a file in your local `.ssh` directory called `config`  and insert the following information in it: 
```
Host gbar
User s123456
IdentityFile ~/.ssh/gbar
Hostname login1.gbar.dtu.dk
```
Note, that you need to change the User line to fit with your own student number. Using this, you can simply run ssh gbar in your terminal to connect.

In this section the following commands have been used:

| Command | Function |
| :------ | :------ |
| `mkdir <new_folder_name>` | create a new directory |
| `cd <sub-directory>` | Change working directory.<br> Go back one level with `cd ..` |
| `ls -la` | List contents of a directory.<br> `-la` shows all files, including hidden ones |
| `chmod <permission-code> <your_file>` | Change file permissions |
| `cat >> <some_file>` | Append a line to `some_file`.<br> Creates the file if it does not exist |
| `cat <some_file>` | Print file contents |
| `ssh <user-id>@<host-server>` | Establish a secure shell connection<br> from local machine to host server |

## VSCode + remote-ssh
We strongly recommend using [VSCode](https://code.visualstudio.com/download) to program/interact with the HPC for beginners. While it is not strictly necessary, it can speed up the process of coding significantly, and feel almost just like coding locally on your own computer. 
After you've installed and opened VSCode, navigate to the extensions pane and install the Remote - SSH extension
![Remote SSH Extension](figures/remote_ssh.png "Install the Remote - SSH extension by Microsoft.")

After it is installed, press the two arrows in the bottom left corner of the editor. Choose "Connect to host" and choose gbar from the drop-down or manually add the host _login1.gbar.dtu.dk_. After entering your passphrase, a new editor will open which is a VSCode session on the cluster login node. The attached terminal works just like the terminal you would have after ssh'ing into the HPC system locally.

Notice how the left pane of the editor is a file explorer. Try clicking "Open folder" and pressing enter. This will make your current path the home folder of your HPC user. You may create, delete, move and copy files and folders using the file editor. You can also drag and drop local files from your computer to the file editor pane to copy files to the cluster. **Note**: you may only do this for smaller code files and folders, nothing large, as this will clog up the login node.

Now, navigate to the extensions panel and install the `Python` and `Python Debugger` extensions by Microsoft. Although you probably have them installed locally, you will also need to have them installed in the HPC VSCode editor. 


<!-- Actually in doubt if doing sxm2sh or smth similar will change the behaviour - im guessing vscode instance would still be on the login node?
I believe, that as long as you're on the remote, the node doesn't matter. It will only be the terminal that will be deployed onto the interactive node, which doesn't change the behaviour of our editor. -->


<!-- TODO  -->
If you are coding your project by yourself and you don't want to bother using git, then you may simply create a project folder, make an environment, and begin coding. If you are collaborating with someone, we advise you to set up GitHub. 

## GitHub setup
In order to collaborate with peers, you're probably interested in setting up a working GitHub environment on the cluster. This allows you to push code to and from the cluster into an online repository such that you can 1. communicate efficiently between the cluster and your local computer and 2. collaborate efficiently with peers.

This process is equivalent to what you would do on your local machine. If you're unfamiliar with the process, this section acts a a GitHub setup walkthrough to get you up and running.

#### Creating and using a ssh keypair for GitHub authentication
We will again use an ssh-keypair to allow the connection between your Github account and your user on the HPC system, following [this](docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) guide. 
1. Create and login to an account on github.com. 
2. `ssh` into the HPC system from a terminal or using VSCode.
3. enter `ssh-keygen -t ed25519 -C "your_email@example.com"` in the terminal. Here, the email must the same as used in GitHub.
4. Enter a passphrase which you can remember (which again should be different than the one used for your GitHub account)
5. Enter `ssh-add ~/.ssh/id_ed25519` into the terminal to add it to the ssh-agent
6. Copy the contents of the file ~/.ssh/id_ed25519.pub, e.g. using `cat ~/.ssh/id_ed25519.pub` and copying the contents to your clipboard 
7. Open GitHub in a browser.
8. Click on your profile picture
9. Click on ***Settings***
10. Click on ***SSH and GPG keys***
11. Press ***New SSH key***
12. Give the key the name "DTU HPC", and paste the public key content from your clipboard into key field.
13. Press ***Add SSH key***

The process is the exact same on your own machine. If you plan on editing code locally and pushing to the HPC, it may be beneficial to setup a ssh key pair for your local machine as well.

### Creating a new repository
1. Create a repository in your browser on GitHub.com.
2. After creating it, click on the green ***< > Code*** button and click on ***SSH***. Copy the URL to your clipboard.̈́
3. ```ssh``` into the HPC. Using the HPC terminal, write ```git clone <your_pasted_url>``` and press enter.
4. Authenticate with your GitHub ssh passphrase.
5. Now your GitHub repository is downloaded into a project folder. ```cd``` into it.
6. Repeat steps 1-5 in a terminal on your own machine
7. Steps 7-11 should be carried out on the HPC terminal. Make a new textfile by writing ```echo "test" >> helloworld.txt```. 
8. Type ```git add helloworld.txt```
9. Type ```git commit -m "First comission to my new repository!"
10. Type ```git push origin main```
11. Authenticate with your ssh passphrase
12. Open the repository on GitHub.com. You should be able to see that the repository contains the new file
13. On your local machine, in a terminal in the project folder, type "git pull origin main" and authenticate. This will pull new pushes to the GitHub repository down onto your local machine

While this process is nice for communicating with the HPC in an efficient manner, the real strength lies in the fact that you can invite other users to your GitHub repository on the GitHub webpage. Everyone is then able to edit, push and pull code. 

### Using the template project and pushing to your own repository
This can easily be done by following these steps: 
1. Make a completely empty GitHub repository and copy the URL 
2. `git clone <template_project_URL>`
3. Rename the folder by writing `mv HPCProjectTemplate <your_project_name>`
4. `cd` into `<your_project_name>`
5. write `git remote set-url origin <your_git_repo_URL>`. This tells git that the project should be linked to this repository instead
6. write `git push -u origin main`. This pushes all the local changes into your repository, and you may from now on use it as such. 

### Git command cheat-sheet
The most important commands to get started are: 


| Command | Function |
| :------ | :------ |
| ```git add <yourfile1> <yourfile2> ... ```| Tell git that you have done changes to these files and want to push them to the repository. If instead of filenames you just write ".", it will take all files which you have changed.|
| ```git commit -m "<your_message_here>"```| Bundle your changes with a commit message. Your commit message should describe why you are pushing, what you fixed, etc.|
| ```git push origin <branch_name>``` | push your submission to the spcified branch of your repository. The default branch is called main.|
| ```git pull``` | pull updates from the main branch of the repository |

Here, it is important to understand that `git add` takes a snapshot of the files as they are now. If you change the file after running `git add`, you will have to re-add it. In principle, usually you would change some files. Then you would add them in smaller comissions at a time such that each commit contains logically codependent content which may be well described with a message, and make a push for each bundle.  

 ### Merge conflicts 
 Imagine that user A and B both pull from a repository, and both change the same line of the same file *shared_file.txt*. Now both users try to push their changes, but user A pushed before user B. The repository will then in most cases not accept the push by user B, as the push conflicts with the current contents of *shared_file.txt*. User B will then have to pull the changes first, and then will have to merge their local changes into *shared_file.txt* in a specific way such that git knows which of the changes you then want to keep. This process is called *merging*. 


Getting good at git is hard work, and is covered in other DTU courses, and many excellent online resources exist, e.g. [git - the simple guide](https://rogerdudler.github.io/git-guide/). If you are doing a larger code-heavy project with one or multiple collaborators, it is strongly advised that you learn git as it will allow you to work more efficiently in parallel. 


## Setting up your project and project structure
Having gained access to the cluster and setup GitHub, we would now like to create a project folder. This can be done as you'd usually do on Visual Studio Code using the editor's file explorer, or by using the `mkdir` command.

The structure of the given folder is not pivotal, however, we highly recommend using the structure provided in this GitHub repository. This will save you a lot of trouble later on when e.g. debugging. We also include some relevant files, which will come in handy later on. You can simply clone this repository and copy the contents into your project folder. The outline of our repository is found below:
```
└── .vscode
    ├── launch.json
└── data
    ├── data_file1.npy
    ├── ...
└── logs
    ├── log-1.txt
    ├── ...
└── outputs
    ├── out.txt
    ├── ...
└── scripts
    ├── add_debug_machine.sh
    ├── run_file.sh
    ├── setup_env.sh
    ├── ...
└── src
    ├── main.py
    ├── ...
├── README.md
```
Here, the ***src*** directory is intended for your `python` files, ***scripts*** holds all shell script files, ***data*** holds all data files, ***logs*** holds all your logs for your batch jobs, ***outputs*** holds all logs when running in an interactive node session and ***.vscode*** holds a neat `launch.json` file.

Having created our project directory, we'd now like to step into it with our VS Code editor. This will make life a lot easier in the future. To do so, we first step into the folder using the terminal. Open a terminal and `cd` into your project directory. Once at the project root, we run the command:
```
pwd
```
`pwd`, or **p**rint **w**orking **d**irectory, does as the name suggests. Having run the command, now copy the console output.

Now in your editor, navigate to *File &rarr; Open Folder*, which will display a file explorer at the top of your screen. Paste the path to your project directory here and click *OK*; your editor is now located at your project root!

For future reference, this navigation is made much easier each time you connect to the server - just append the extra path elements onto the path string that you're prompted with initially.

## Activating and managing Python Virtual Environment
We'd now like to setup our *Python* environment. Effectively, when working on the cluster, this requires us to create a personal virtual environment.

The cluster has a huge set of so-called *modules*, which are software packages that are available to all users. One such type of module is `python`, which itself has a large array of different software packages available through the cluster modules. To see which modules that are currently loaded, run the following command:
```
module list
```
To list all available modules, run:
```
module avail
```
To only show `python` modules, run:
```
module avail | grep ^python
```
Here, `grep` is a search command, that allows you to filter text to only show relevant output lines. Here, `python` is the search word. The `^` character in the above query ensures that a line must start with the search word.

When running the command, you're prompted with several python versions which are available to you. Looking at the output list, you see there is a default choice, denoted by a string that ends with `(default)`. We can choose to load this module by simply running:
```
module load python3
```
If you'd like to run a specific python version, you have to specify the whole package in the above command.

Having loaded our desired python version, we're now ready to create a virtual environment. Run:
```
python3 -m venv <path/to/venv>
```
`path/to/venv` indicates the relative- or absolute path to where you'd like to put your virtual environment, where `venv` is the name of the environment. We recommend putting it into your project directory root.

Having created the environment, we can now activate it by running:
```
./path/to/venv/bin/activate
```
You've now got python up and running!

#### Streamlining environment activation
This whole process may be streamlined for future reference by employing the code found in the file `setup_env.sh`. You can either copy this file or simply copy the contents, create a file with a similar name and paste it there. In any case, you will need to update the permissions of the file, which currently is not executable. Running the command:
```
chmod +x path/to/setup_env.sh
```
will make the file executable. Before executing the file, you'll need to check whether the contents are as expected. You'll need to change two lines, being:
```
# Change these lines
module load python3
# ...
. /path/to/venv/bin/activate
```
such that they fit to your current setup. You may also append other modules that you want to activate each time you enter the cluster. To run the file, run:
```
source ./path/to/setup_env.sh
```
This one line will now do everything for you.

Reviewed commands:
| Command | Function |
| :------ | :------ |
| ``` module list ``` | Lists all currently activated modules. |
| ``` module avail ``` | Lists all modules available on the cluster. |
| ``` module load <m> ``` | Loads module `m` on the cluster. |
| ```<command1> \| <command2>``` | The _pipe_ operator creates a pipeline between the standard output (stdout) of `command1` into the standard output of `command2`. |
| ```grep <pattern> ```| Searches input for lines that match a desired pattern and prints these lines. Often used with _pipe_ operators. |

## Node types on DTU HPC
The DTU cluster has three main types of nodes: *login*, *interactive* and *compute* nodes. A node is a single computer in the cluster which provides CPU, memory and potentially GPU for running tasks. Each node has a specific use-case, outlined below: 

| Type of node | Function |
| :------ | :------ |
| Login node | Handles you connecting into the cluster. You always ssh into a login-node |
| Interactive node | Allows you to run code directly in a terminal or jupyter notebook. |
| Compute node | Only allows running code using batch-jobs. Can either be CPU only or also have a GPU |

**Login-nodes**: In all cases, ***please never run any programs on login nodes***. They are to be used only for logging in, and running code will slow the nodes for all other HPC users. 

**Interactive nodes** are shared between all users. This means that when running code interactively, resources allocated to your program depends on how many other users use the specific interactive node. As a result, your code may run out of memory suddenly, or have slower/faster execution based on the general workload of the interactive node. For this reason, interactive nodes are best used for debugging, running jupyter notebooks and running light code, e.g. visualizations, but not well-suited for heavy tasks such as model training, inference, 3D shape analysis, etc.
Given this specification, you're heavily encouraged to only debug **actively**, as you may be blocking other users from using GPU resources.
There exist interactive nodes which only have a CPU, but some nodes in addition have a GPU.

**Compute nodes** All heavy tasks should always be run on compute nodes. 
In addition, if you're profiling code or report run-times of code in your work, the only proper way to measure it is to use compute nodes. The batch job you submit will allocate a specific amount of system resources for your program, and thus runtimes will not be influenced by general system use.
In general, when you can use a compute node then you should, as this is the use which HPC is optimized for. Again, these nodes exist in CPU-only and GPU versions.  

Available GPU nodes are listed [here](https://www.hpc.dtu.dk/?page_id=2759). The next two subsections show how to use interactive and compute nodes.  

## Running a python script on an interactive GPU node
Assume you have a file on the HPC cluster. Then you can run the file interactively by following these steps: 
1. ssh into the cluster
2. change from a login session to an interactive session by entering a queue name into the terminal and pressing enter
3. load your python environment
4. executing the code from the terminal by writing ```python3 path/to/your/file.py```

Currently available interactive GPU queues are `sxm2sh`, `voltash` and `a100sh`. To start an interactive session, simply enter the node ID, e.g. ```voltash```, in the terminal and press enter. You can log out from a node by running the ```exit``` command.

In order to check the current workload of an interactive node, you can start a session on the node and enter ```nvidia-smi```. This will provide terminal output similar to the below: 

![nvidia-smi output](figures/nvidia-smi.png "example output from nvidia-smi on voltash. In this case, notice how only GPU ID 1 is used by two processes, and the processes use up 6608MB out of the 16348MB in total. As a result, GPU 1 is completely idle, and should preferentially be used for your application. This may be specified by forcing your script to run on the specific GPU id.")

Reviewed commands:
| Command | Function |
| :------ | :------ |
| ``` nvidia-smi ``` | Lists interactive node information over the current active node. |
## Running a script on a compute node
In order to run a script on a compute node, a *batch-script* is needed to tell the HPC system how many resources your program will take up. Basically, a batch-script can be understood as you placing an order on the HPC node. When placing the order, you create a *batch-job* which will be put in a queue. The scheduling system on the HPC then starts your script as soon as it is your turn in the queue, and the free resources are present. 

A batch script consists of a combination of batch-job code and bash code, and it should be saved with the file-extension `your_batch_filename.sh`. An example of a batch-script is provided below: 
```
#!/bin/sh
### The following section is the batch-job specific content which places your "order" 
### –- specify queue where you want to run your job --
#BSUB -q gpuv100
### -- set the job name: this is used for monitoring your job later --
#BSUB -J testjob
### -- ask for number of CPU cores (in most cases just leave it as 4) --
#BSUB -n 4
### -- Select 1 gpu in exclusive process mode (in most cases leave it as is) --
#BSUB -gpu "num=1:mode=exclusive_process"
### -- set walltime limit: hh:mm --  maximum 24 hours for GPU-queues. Your job is killed if it exceeds.
#BSUB -W 1:00
### request 5GB of GPU-memory
#BSUB -R "rusage[mem=5GB]"
### set the job to run on a single host machine (don't change this)
#BSUB -R "span[hosts=1]"
### -- set an email address - a mail will be sent with some important statistics about your job and whether it succeeded/failed --
#BSUB -u your_email_address
### -- send e-mail notification when job starts -- 
#BSUB -B
### -- send e-mail notification when job ends with statistics/status --
#BSUB -N
### -- Specify the file to which all your terminal output (e.g. print statements) are saved to
### -- %J will here give it the JobID number which the scheduler assigns when submitting. 
#BSUB -o logs/gpu_%J.out
### -- Specify the file to which all errors are saved to. Important for debugging if it crashes!
#BSUB -e gpu_%J.err

### -- end of batch job options - from here it is just shell code --
module load python3/3.10.12
source path/to/your/environment
echo "Training model..."
start=$(date +%s) #example timer start
python3 src/train_model.py  #train your model
stop=$(date '+%s') #stop the timer to time how long it took
elapsed=$(awk "BEGIN {print $stop - $start}")
echo "training finished in $elapsed seconds" #print how long it took
echo "Running inference"
python3 src/model_inference.py
echo "Plotting results..."
python3 src/some_result_plots.py
echo "Finished all scripts. "
```

The shell code is then executed as soon as it is your turn in the queue. Here, you may consider the shell code as simply being the same as interacting with the terminal line by line. As a result, you can stack a series of commands as done above which trains a model, followingly runs inference and plots some results while also timing how long model training takes and printing some stuff to the output. Note that both echo (which is linux for print) and python script terminal outputs will be redirected to the logs/gpu_%J.out file.

In order to submit the job, enter the following in a terminal: 
```bsub < your_batch_filename.sh```

Your job will then receive a job ID. You can see whether your job is running using ```bstat```. 
You may always kill a job using ```bkill <jobID (number)>```.

You can check how busy different compute nodes are using the ```bqueues``` command. Here, the ```PEND``` column shows how many jobs are currently in queue. If you want to check a specific queue, in this case `gpua100`, you may write: 
```bqueues | grep gpua100```
to only get the corresponding line.
Available compute nodes with GPUs are listed [here](https://www.hpc.dtu.dk/?page_id=2759). 

Reviewed commands:
| Command | Function |
| :------ | :------ |
| ``` bstat ``` | Lists information of your current batch jobs. |
| ``` bqueues ``` | Lists activity of all compute nodes on cluster. |

## Debugging on HPC
As most work on the cluster is done using python files, a working debugging environment is incredibly valuable. Files will inevitably become coupled over time, making it increasingly cumbersome to keep track of logic flows after execution. As debugging is not so straight forward when using the HPC, this section is dedicated to create a working debugging setup.

In order to get a working debugging setup you'll first need to install the Python Debugger extension from VS Code:
![Debug extension|100](figures/python_debug_package.png "The Python Debugger extension")
You'll also need the Python extension if you've not got this already.

Now in the left column menu in your editor, click on the Run & Debug section. This will either show an empty menu or you'll be prompted by some text and options, such as "create a launch.json file", and a large button with text "Run and Debug". If you see the latter case, then you don't have an existing *launch.json* file in your project root, which is necessary to start debugging. Click "create a launch.json file" if this is the case, which will prompt you with a dropdown menu. Select "Python Debugger", then "Remote Attach". Lastly, you'll need to specify a valid IP address and afterwards a valid port, for which the default options are fine for now; click enter twice. You'll now have a _launch.json_ file in a hidden _.vscode_ directory at your project root, which will look something like this:
```
{
    go.microsoft.com/fwlink/?linkid=814321
    "version": "0.2.0",
    "configurations": [
        
        {
            "name": "Python Debugger: Remote Attach",
            "type": "debugpy",
            "request": "attach",
            "connect": {
                "host": "localhost",
                "port": 5678
            },
            "pathMappings": [
                {
                    "localRoot": "${workspaceFolder}",
                    "remoteRoot": "."
                }
            ]
        }
    ]
}
```
The important thing to note here is everything within the "configurations" section, which is a list of all debugging setups you've created. In your Run and Debug section on VS Code, there is now a dopdown menu at the top, which will hold each of your debug configurations.

![Debugging|100](figures/debugging.png "Debugging in python - employ the configuration that fits with your current interactive node.")

Having created a _launch.json_ file, we now only need to create a communication channel between your current interactive node and your terminal. We've created a script to do this for you, which appends a debugging configuration for your current interactive node. Run the script _add_debug_machine.sh_ to do so.
**Note**, you'll need to do this each time you're on a new interactive node, so be aware.

Now that our debugging environment is ready, we now want to use a test script to see if the debugger works as expected. Make a new python file and add some logic, such as:
```
print("hello")
x=12
while x < 1500:
    x+=2
    x+=1
print(x)
x=6
```
Now we want to add a breakpoint, done by clicking to the left of the line indices in the python script. If you're unfamiliar with debugging, this means that when the debugger arrives at this point, it will come to an immediate stop, allowing you to inspect values of variables dynamically during execution. For the above code, try to set a breakpoint at line 5 - when debugging, the value of *x* should be *14*.

Now to start debugging, you need to run the *run_file.sh* script, using the command:
```
./scripts/run_file.sh path/to/test_file.py --debug
```

Upon executing the *run_file.sh* script, it will now wait until you attach your debugger onto your session. Just to the left of the dropdown debug configurations menu, there's a run button. Click this to attach your debugger (**note**: you need to wait for a couple of seconds, otherwise VS Code will complain). If everything works as expected, then execution starts and you should stop at your breakpoint!

One issue you may find is, that the debugger doesn't stop at your breakpoint. If this is the case, the likely reason is that your editor is not stationed at your project root, which is necessary for your debugger to work. Change directory and remember to move your _.vscode_ directory to your project root.

## The run_file.sh script
Elaborating on the *run_file.sh* file, its intended purpose is to streamline cluster interaction, such that all you need to do in order to run/debug (mostly) successfully:
1. ssh into the server at the project root
2. Connect to the given interactive node of your choice
3. Run *run_file.sh* script on a desired python file

The script will itself choose the GPU which has most available memory, meaning that you don't need to worry about commands such as *nvidia-smi*. If you can't run the script, then this subsequently means, that there is no space available on the current node!

Furthermore, the script itself calls *setup_env.sh*, meaning you don't have to think about your python environment. Finally, it handles the debugging configuration for you, as per the previous section.

There are two variables you may need to change, depending on your application. These can be found in the "personalized variables" file section:
```
# ---- Personalized variables ---- #

FILEPATH="src/main.py"
PORT="5678"

# ---- Personalized variables ---- #
```
Changing the FILEPATH variable will set the default file to be executed by the script. You therefore don't need to specify this path in the command line.
The PORT variable may never be needed, however, if you can't attach to the debugger, this may be the reason. If so, change this port number and match the port numbers found in *launch.json* with your chosen value.

### File transfer
You'll likely want to transfer files between your local computer and the cluster at some point.

**local &rarr; remote**
This can be done using the following command on a local terminal:
```
scp -r path /to/data <study-number>@transfer.gbar.dtu.dk:/path/to/your/project
```
Here, *scp* (secure copy) copies the file contents from your machine onto the remote location you've specified. The tag *-r* allows a *recursive* copy, meaning a directory may be copied in its entirety onto the cluster. Importantly, you need to specify the absolute path to the project on the server.

**remote &rarr; local**
This can either be done in a similar way by using a local terminal the opposite way round:
```
scp -r <study-number>@transfer.gbar.dtu.dk:/path/to/your/project/data path/to/destination
```
For small files, you may also employ a simpler method. In VS Code, right click the file you want to retrieve from the remote. Here, you'll see a *download* option - this will download the file onto your local machine. This, however, is not recommended for larger files, as this tends to slow down your file explorer when doing so.

**kaggle &rarr; remote**
If you want to download a dataset from *kaggle**, e.g. with the URL https://www.kaggle.com/datasets/welovehpc/satellite-images, you may `cd` into your project root, `cd` into a data folder, and then use the command 
```
curl -L -o data.zip
  https://www.kaggle.com/api/v1/datasets/download/welovehpc/satellite-images
```

This will allow you to download directly on the HPC server. Please only do this on interactive nodes.
**Some filesharing service &rarr; remote**
The `curl` approach is also useful if you have a download link for an arbitrary filesharing service, and you do not have space to download the dataset onto your own machine; here you would simply curl the download link. This usually works for filesharing services where you are able to get the URL of the file, usually by right-clicking the download button and copying the URL. This, of course, only works for archived files, e.g. *zip*, and similar:

```
curl wetransfer.com/some_dataset.zip
```

This works on *google drive* and some other arbitrary file sharing services.

Please ensure that you only do this for trusted sources, i.e. datasets provided by your project supervisor or original download links which are associated with peer-reviewed papers from trusted journals. 


### Some best-practices to save time and minimize bugs
1. Make your scripts with many print-statements of e.g. tensor shapes. This sometimes allows you to know the source of errors without having to re-do the run. Even better, use a logger (we recommend `loguru`).
2. Make naming conventions for files and functions - and stick to them
3. Modularize functions and code such that it may be re-used as much as possible.
4. Always run code from the project-root - that is, consistently invoke python scripts using ```python3 src/your_python_file.py``` and similar. This ensures that all path handling is constant across all scripts. Many (expensive) bugs occur due to path handling - e.g. saving results to a path which doesn't exist after finishing expensive operations; then you would have to re-run the whole pipeline.
5. For deep learning and machine learning algorithms using iterative optimization: save model checkpoints and optimizer state many times throughout training. If a bug occurs, you can continue from the last checkpoint and save valuable time
6. ***Always*** seed your algorithms. This ensures reproducibility.
7. Use professional experimental monitoring, such as Weights & Biases. This can save a lot of time.
8. Tune your batch-scripts such that you only request the amount of resources you actually need. In busy periods, this may allow you to gain a slot quickly on the compute queue.



### Running a Jupyter notebook
While, in general, it is ill advised to use Jupyter notebooks in most ML/DL tasks, they may find specific valid use cases such as for plotting or rapid prototyping. You can run jupyter notebooks directly on the HPC from interactive nodes through VSCode. To do so, use the remote ssh extension to login to a login node, open the terminal and start an interactive session. Now install the Jupyter extension in VSCode:

![The Jupyter VSCode extension](figures/VSCode_jupyter_extension.png "The Jupyter VSCode extension")

In addition, load your virtual environment and install the following packages: 
```
python -m pip install notebook ipykernel ipython
```

Now you can open/create a jupyter notebook (.ipynb) and run it on the HPC by choosing "Select kernel" in the upper right, and choosing your virtual environment. Executing cells, etc., is the same as on your local machine. 

### Monitoring
When training Deep Learning models, it is necessary to keep track of their behaviour. Which model parameters did I choose? Did the model converge correctly? Does the output of the model seem to generalize well to the underlying data? For a single model, this is not so difficult to monitor. Generally, however, you'd like to tweak your model in order to optimize performance. Tracking the nuances of each run can become very difficult in practice, which makes it difficult to manage e.g. the reproducability of a previously successful experiment.

For this, your friend and ally is _Weights & Biases_, also known as wandb. This framework is intended to streamline monitoring by broadcasting all your experiments onto your personal page on _wandb.ai_ . To use the framework, you'll need to register to wandb - navigate to the [wandb](https://wandb.ai/site) home page and sign up.

Broadly, wandb allows you to create sub-folders for your experiments (neat if only a subset is coupled), upload plots and histograms, create sub-sections for your train-val-test splits, upload images, files and much more. Many of these features can also be made temporal, i.e. for a given model, its output at epochs 10 and 100 can easily and intuitively be compared to each other. More advanced tools are also available such as model _sweeps_, which automate hyperparameter search whilst producing rich visualizations, simplifying parameter tuning significantly in some instances.

As Weights & Biases themselves have a perfectly fine guide, we direct you to the following site for further guidance: [Wandb guide](https://docs.wandb.ai/models/quickstart#command-line).