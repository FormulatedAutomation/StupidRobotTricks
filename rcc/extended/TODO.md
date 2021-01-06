# TODO file for a new robot

- Read all the `INTRODUCTION.md` files and follow their guidance (the files
  should help you get an understanding of what belongs where in this new
  robot).
- Add your content to the top-level `README.md` file.
- Add your license text to the `LICENSE` file.
- Make your changes to this project and make it yours.
- Refer to the "Full workflow with CLI" below for running your task.

# Full workflow with CLI

In the shell (or the command prompt), do the following:

## Creating a new task

```bash
rcc robot init --directory new_robot
cd new_robot
```

## Running the task in place

```
rcc task run --robot robot.yaml
```

## Providing access credentials for Robocorp Cloud connectivity

```bash
rcc configure credentials <paste your credentials here>
```

## Uploading to Robocorp Cloud

```bash
rcc cloud push --workspace 111 --robot 111
```
