Title
status
context
decision
and consiquencesi





- skip on failure
- abort on failure
- tries after failure

> Also per step?
>
- ask on every action
If the scrips is tun in interactive mode


#### Interactive mode

Options
- fail if missing input
- dont ask on plan
- ask on every action
- skip on failure
In interactive mode, when the release script is invoked, it provides a few
interactions to make creating the release easier.
1. Requests any required configurion options that were not provided in a
configurion file or via command line argument are requested from the user.
2. Provide a simple way for a user to override, modify, set or unset any
configurion option for this release.
3. Prints a description of the actions it will take (the "release
plan"), and provide the user with options to "publish", "cancel", or return to
the "modify" step.
4. Provide live feedback as it preforms the actions previosly described allowing
the user to request to skip or cancel a step
 1. If a step fails allow the user to "try again", "revert completed steps",
 "skip", or "abort release".

### Release manifest
4. Print a release manifest detailing everything that was done
  1. What inputs and process were used to produce what content
  2. Where the results of the release can be accessed.
  3. When everything occured.

### Interactive inputs
If any required inputs are missing and the script is run in interactively mode,
for each the script requests that the user provides the missing required configurion
options. If the user provides valid values for the missing required configurion
options the script continues to the next step. If they don't the scrips exits
with an error message.

### Interactive and non-Interactive

The script can run in "interactive" or "non-interactive" modes. The scrip can
detect weather it is being run by an interactive shell or non-interactively run
the the approprate mode. It can also be forced to run in either mode.

In interactive mode, the scrip is optimized to help the user to create a release
even if there are issues by guiding the user threw using the controls avabile to
them and giving them oportonities to make informed decisions threw the process.

In non-interactive mode, the scrip attempts to create a release without user
interactions and handle issues the best it can according to the users
expecations for an automated process.

This allows the script to be optomaly usable interactively and in automated
scenarios.

#### Release plan

Then we show the user a description of the release plan. The release plan
describes the actions that will be taken to create the release.

If the script is run in non-interactive mode or the "--dont-ask-on-plan" option
is passed then the release plan is displayed to the user and the script
continues to the next step.

If the scrips is run in interactive mode the release plan is displayed to the
and user and the user is provided with the options to "publish" or "cancel". If
the user choses "cancel", the release is canceled and the script exits without
an error message. If the user choses "publish", the script continues to the next
step.

#### Script arguments - WIP

Every configurion option can be provided via command line argument. Any
configurion option already provided in a configurion file is overridable by the
approprate command line argument. This includes release content configurion.

---
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

### Command line controls

- Identifier
  - Type: String
  - Description: The base string for the release identifier.
  - Notes
    - If `Prefix` is set in the content configurion, then it is used with the
    value of this option to from the release identifier.
    - It overrides the `Identifier` in the content configurion.
    - If it is not provided the `Identifier` in the content configurion will be
    used.
- Content
  - Type: Path
  - Default: release.y(a)ml
  - Description: A path to a content configurion file.
- Publish git tag
  - fail-on-exists
    - Type: Flag
    - Description: Fail if the tag does exists.
  - fail-on-not-exists
    - Type: Flag
    - Description: Fail if the tag does not already exists.
-
- On-conflict
  - Type: Option
    - Error
    - Replace
    - Ignore
  - Default: Error
  - Description: What do if there is already work destributed as the same release.


#### Release Actions

- Publish git tag to GitHub - Get a tag named
`release identifier+Git.Tag.Prefix` of the current HEAD commit on the GitHub
repo.
  1. Check if exists locally
      1. If it does exists

  1. Check if it exists on remote *Pre-check*
      1. If it does exists
          1. If fail-on-exists, fail the action
          2. If it does not match, fail the action
          3. Else, succeded the action
      2. If it does not exists
          1. If fail-on-not-exists, fail the action
          2. Else, include action in release plan
  2. Create it with HEAD commit
      1. If it fails, fail the action
      2. If it succedes, continue

#### Release Checks

- Check if release exists on GitHub
  1. If it does exist
      1. If it does not match, fail the check
         - Match here might be confusing, its important to know that we are
         checking for what we need to do. If everything that the user cares
         about is the way they want then the release is already on GitHub,
         nothing to do. If something is not how they want it then the check
         failed (since the script cant do anything else about it at this point)
         - Checks
             1. Download all the assets and check if their hashes match the
             assets to be published (EXPENSIVE)
             2. Name
             3. tagName
             4. if tag is pointing to expected commit (HEAD?)
             5. Body - Is the body what we expect?
             Description + if include generate github release notes
               - We can use a github API to get the generated release notes,
               but how GH generates the release notes could changed at any
               time.
             6. isPrerelease
             7. isDraft
             8. Author?
      2. Else, succeded the check
  2. If it does not exist, include "Create GitHub release" in release plan.

### Command line controls

- Identifier
  - Type: String
  - Description: The base string for the release identifier.
  - Notes
    - If `Prefix` is set in the content configurion, then it is used with the
    value of this option to from the release identifier.
    - It overrides the `Identifier` in the content configurion.
    - If it is not provided the `Identifier` in the content configurion will be
    used.
- Content
  - Type: Path
  - Default: release.y(a)ml
  - Description: A path to a content configurion file.
- On-conflict
  - Type: Option
    - Error
    - Replace
    - Ignore
  - Default: Error
  - Description: What do if there is already work destributed as the same release.

# Release content configuration

There are configurion options that can control how releases are created, but of
those configurion options their are two types that we can identify, release
process configurion and release content configurion.

We want to keep release process configurion seprate from release content
configurion

so that the entire release content configurion...
- Wont require information more sensitive than the inputs to the release
content.
- Wont contain controls that could require different access control than the
rest of the configurion.
- Is defined by a static API that does not change structure based on inputs.
- Does not need to change
- Enable maintainence of release process and release content configurion to be
sperate.

