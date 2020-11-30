# Stupid Robot Tricks

This is our guide for solving common problems with Robot Framework and sometimes making it do things it wasn't supposed to.

## Installation

This project relies on Conda to install the requirements. You can create a new environment and use it as follows:

`conda env create -n StupidRobotTricks -f conda.yaml`
`conda activate StupidRobotTricks`


## Running each project

Simply enter the subdirectory and run the project using either run.sh/run.bat or run it directly with python;

`python -m robot --report NONE --outputdir output --logtitle "Task Log" tasks.robot`
