# Publish script

## Motivation

Currenty, the smart contracts teams either creates releases on their own or with
the direct support of the SCDE team. There lacks consistancey and reliabilty in
software release and the processes and configurions that create them.

We want to...
- Allow smart contracts teams to easily create consistant and reliable software
releases for users and create and maintain configurions for release automaitons
themselfs.
- Prevent the SCDE team from having to directly provide support for every
release the product teams wish to make.
- Prevent the SCDE team from having to provide support to maintain release
process documentaiton, scrips and configurions per project.

## Current state

Currenty, iogx does not provide any utilities for users to create software
releases. Thie leaves users to manually create software releases, doucment complex
releases processes and create custom release automation configurions and
scripts, or get assitance from SCDE to do so.

Not all repos create any notion of a release, but the ones that do, preform
releases with a few methods.
- Manually preform specific actions to create releases according to specifc
desired outcomes.
- Manually preform specific actions to create releases according to a notion of
convention accross IOG or wider contexts.
- Manually preform specific actions to create releases according to doucmented
processes.
- Creating custom release scrips and manually invoking them.
- Configuring github actions to automatically invoked custom release scripts on
specific events and schedules and under specifc conditions.

The manually processes are prone to errors and in-materal inconsistancies from
release to release. This is because manually creating release is a processes
that is contains many decisions and processes and is typically preformed
in-frequently. Meaning it is a task that you likily have not done in a while,
and have to make alot of un-familar decisions to complete.

Fallowing conventions can help provide some consistancey and prevent some
errors and fallowing a documented process helps even more so, but when a user
manually preforms these steps there is a chance for novel hard to debug issues
to affect releases.

The projects that use release scrips and automaitons can provide more consistant
error-free releases, and with less of a burden on everyone supporting the
releases for the project, per release. The issue with the projects that have
automaitons is that the automaiton code for every project is sperate but seeks
to achive similar results and very detailed in how to produce releases.

The automaiton code being very detailed in how to produce releases leads to
projects seeking support from SCDE. This means that both the team owning the
project and SCDE has to be involved in maintaining the release automaitons for
the project. This leads to the SCDE team having to provide direct support for
most projects that have release automaitons. Given that each project has its own
sperate automaiton code, this means that the SCDE team is given a lot of
maintainence burden between all the projects producing releases, and faces
scaling issues with the growth of the number of projects producing releases.

## Solution

If we assert that...
1. The teams owning the individual projects only really care about some
high-level details about how releases are created.
2. The SCDE team only wants provide support to teams producing releases in a
maintainable manner.

We can seprate the concerns of the teams by creating a script that takes
high-level release configurion options and preforms actions to distribute
content under a release. The SCDE will only be reponsibly for maintaining the
script and the configurion options the script provides and the teams that want
to produce releases will only be reponsible for the configurion values they
provide to the script and their use of the script.

### Script steps

When the release script is invoked, the script preforms a few steps...

#### 1. Validate inputs

The first step is to check if any values for any configurion options are invalid
and if any values are missing for any requried configurion options.

If there are any invalid or missing values...

1. For every value that is invalid or missing,
    1. Display an error message stating the that the value is invalid or missing
    2. Display a message to help the user provide a valid value for the configurion option.
2. Exit the script.

If no required inputs are invalid or missing, continue to the next step.

#### 2. Release plan

The script displays a description of the release plan to the user. The release
plan describes a sequence of release actions that will be taken to create the
release.

#### 3. Pre-release check

The scrip preforms checks for each release action to un-cover any errors
that could come up when preforming the release actions.

If their are any checks that fail...

1. For every failed check,
    1. Display the check that failed and for what action the check if for.
    2. Display information about how the check failed.
2. Exit the script.

If all the checks pass, continue to the next step.

#### 4. Release actions

The script attempts to preform the actions described in the release plan.

1. For every release action
    1. Display that the action that will be attempted
    2. Attempt to preform the action
        1. If it succedes
            1. Display that the action has succeded
            2. Continue to the next release action
        2. If it fails
            1. Display an error message describing the failure of the release action
            2. Display the release actions that will not be attempted
            3. For every release action that has succeded, in reverse order
                1. Display that a revert action for the release action will be attempted
                2. Attempt to preform the revert action
                    1. If it succedes
                        1. Display that the revert action has succeded and the release action has been reverted
                        2. Continue to the next succeded release action to be reverted
                    2. If it fails
                        1. Display an error message describing the failure of the revert action, and that the release action was not reverted
                        2. Display the release actions that the script will not attempt to revert and the revert actions that would have been used.
                        3. Exit the script
            4. Display a message saying that the succesfull release actions were succesfully reverted
            5. Exit the script
2. Display a message saying that the release plan was succesfully enacted.

#### Script arguments - WIP

Every configurion option can be provided via command line argument. Any
configurion option already provided in a configurion file is overridable by the
approprate command line argument. This includes release content configurion.

### Release configurion - WIP

The release script be able to consume release configurions with a sub-set that
configurion being the release content configurion.


#### Release content configurion - WIP

Release content configurion will be different from the rest of the release
configurion in that it only specifies the desired content of the release. Users
will be able to specify release content configurion sepratly from the rest of
the configurion.


### Configuration - TODO

#### Content configurion - WIP

Description (template)?
name template?
asset(w) - name value pair,
  - name - the name the assert will be presented as online
  - value - the
```nix
$(allStatic.x86_64-linux)/marlowe-cli
$(allStatic.x86_64-linux)/marlowe-finder
lib.getExe static.x86_64-linux.marlowe-cli
```

maybe we make the name optional and use the file name
maybe we can allow a folder with assert to be provided, using the names
of each file


```yml
asset
  "lib.getExe static.x86_64-linux.marlowe-cli"
  marlowe-finder-linux : "${allStatic.x86_64-linux}/marlowe-finder"
  -- This is a whole folder that seems like it needs to ship together
  pir-windows : "hydraJobs.x86_64-linux.mingwW64.ghc96.packages.plutus-core:exe:pir"

assert-folder : "allStatic.x86_64-linux"
```

#### Config files - WIP
