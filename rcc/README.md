# A quick intro to RCC

A few weeks ago Robocorp released its latest open source tool for RPA, RCC, a tool "that allows you to create, manage, and distribute Python-based self-contained automation packages"

In this post, I'm going to go into more depth on what RCC is, why it's important and how to use it.

A quick technical overview of RCC
---------------------------------

RCC itself is an executable that runs python robots in a self-contained fashion. Instead of relying on the end user to install and set up a python environment for the robot, RCC handles all the necessary steps with a combination of YAML configuration scripts and Miniconda.

Now your automation scripts can specify not only the python packages required, but also what version of Python and even post-install steps. And because this is all self-contained, it won't interfere with your current Python setup if you have one.

Why this matters
----------------

My biggest issue previously with Robocorp had been the disconnect from how an automation script is run locally vs on Robocorp's platform. As a developer I want to minimize the number of differences between my development environment and production. This meant building my own Miniconda environment for each automation process and mimicking how it would be executed on production.

With RCC, I run the script locally exactly as it will be executed on my target system, be it Robocorp's cloud or one of my 'assistant' machines. This also has the added benefit of making it easier for a developer to jump into a project and not have to spend time getting bootstrapped. You can quickly make the necessary changes and test it out locally using RCC.

How to use it
-------------

As previously mentioned, RCC is just a compiled executable, it's not a python package or framework that you need to install. Typically you'd download the RCC executable for your operating system and architecture and then copy to an executable path.

At this point you can do one of two things. You can download an existing bot and run it via RCC, or you can have RCC create a new automation project for you. Since this is a Github repository, we'll also show you what a new project looks like so you can get an idea.

When RCC created a new project you'll be given the option to choose a template - [standard](standard), [python](python), or [extended](extended).

Creating a new project is as simple as `rcc create`

### Standard

Let's start with the 'standard' template as it's the easiest to quickly understand. Standard simply creates a project with a robots.yaml, conda.yaml and tasks.robot. This is pretty self explanatory, but lets look at them each

Robots.yaml

```

tasks:
  Default:
    command:
      - python
      - -m
      - robot
      - --report
      - NONE
      - --outputdir
      - output
      - --logtitle
      - Task log
      - tasks.robot
condaConfigFile: conda.yaml
artifactsDir: output
PATH:
  - .
PYTHONPATH:
  - .
ignoreFiles:
    - .gitignore
```

Here we define how the bot will be run, along with basic configuration items like PATH and PYTHONPATH. You'll also notice the pointer to conda.yaml:

```
channels:
  - defaults
  - conda-forge

dependencies:
  - python=3.7.5
  - pip=20.1
  - pip:
    - rpaframework==6.*
```

This is where the encapsulation magic happens. We specify the version of python and pip along with any required pip packages. If you're using other libraries you'll need to add them here.

And finally we have our tasks.robot file, which if you're reading this you likely know is our file which defines the tasks the robot will perform using the Robot Framework language.

Running this project is as simple as `rcc run`

### Python

There's not much to this template other than the change from Robot Framework to pure python. Not much else to note here.

### Extended

I'd actually call this the "Best Practices" template. It's a combination of Robot Framework and pure python. If you've got a complex automation this is likely the template you'll want to use. It's setup to allow you to define tasks in Robot Framework along with included custom keywords written in python for when you need a more powerful set of features.

Conclusion
----------

RCC is obviously still pretty new, but we think it represents a big next step for developers using Robocorp's automation solution. It's open source, so you're not tied to the Robocorp platform to use it, but it also helps you quickly deploy to Robocorp should you choose to. Honestly, I can't think of a reason not to use this if you're using Robot Framework to develop automations.

Links

-   [RCC Github](https://github.com/robocorp/rcc)
-   [RCC Docs](https://robocorp.com/docs/)