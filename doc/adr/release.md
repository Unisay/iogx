# Publish script

## Motivation

Currently, the smart contracts teams either creates releases on their own or
with the direct support of the SCDE team. There lacks consistency and
reliability in software release and the processes and configurations that create
them.

We want to...

- Allow smart contracts teams to easily create consistent and reliable software
releases for users and create and maintain configurations for release
automations themselves.
- Prevent the SCDE team from having to directly provide support for every
release the product teams wish to make.
- Prevent the SCDE team from having to provide support to maintain release
process documentation, scrips and configurations per project.

## Current state

Currently, iogx does not provide any utilities for users to create software
releases. This leaves users to manually create software releases, document
complex releases processes and create custom release automation configurations
and scripts, or get assistance from SCDE to do so.

Not all repositories create any notion of a release, but the ones that do,
preform releases with a few methods.

- Manually preform specific actions to create releases according to specific
desired outcomes.
- Manually preform specific actions to create releases according to a notion of
convention across IOG or wider contexts.
- Manually preform specific actions to create releases according to documented
processes.
- Creating custom release scrips and manually invoking them.
- Configuring GitHub actions to automatically invoked custom release scripts on
specific events and schedules and under specific conditions.

The manually processes are prone to errors and in-material inconsistencies from
release to release. This is because manually creating release is a processes
that is contains many decisions and processes and is typically preformed
in-frequently. Meaning it is a task that you likely have not done in a while,
and have to make a lot of un-familiar decisions to complete.

Fallowing conventions can help provide some consistency and prevent some
errors and fallowing a documented process helps even more so, but when a user
manually preforms these steps there is a chance for novel hard to debug issues
to affect releases.

The projects that use release scrips and automations can provide more consistent
error-free releases, and with less of a burden on everyone supporting the
releases for the project, per release. The issue with the projects that have
automations is that the automation code for every project is separate but seeks
to achieve similar results and very detailed in how to produce releases.

The automation code being very detailed in how to produce releases leads to
projects seeking support from SCDE. This means that both the team owning the
project and SCDE has to be involved in maintaining the release automations for
the project. This leads to the SCDE team having to provide direct support for
most projects that have release automations. Given that each project has its own
separate automation code, this means that the SCDE team is given a lot of
maintenance burden between all the projects producing releases, and faces
scaling issues with the growth of the number of projects producing releases.

## Solution

If we assert that...

1. The teams owning the individual projects only really care about some
   high-level details about how releases are created.
2. The SCDE team only wants provide support to teams producing releases in a
   maintainable manner.

We can separate the concerns of the teams by creating a script that provides
the users with high-level supported controls that allow the users to specify
their desired results for releases, and enacts the steps to realize those
results on the behalf of the user. The SCDE will only be responsible for
maintaining the script and the controls the script provides, the teams that want
to produce releases will only be responsible for the their use of the script.

### Concepts

To understand how the script will work it is import to understand some concepts
first.

#### Controls

The controls are way that the script allows the user to express are their
desired results of the release process. It is import that SCDE provide controls
that are clear and dependable to the user while being able to maintain the
expected results around the use of the control.

Depending on the control, the user can provide input to interact with the
control via command line option or via a release content configuration file.

##### Release content configuration

The release content configuration exclusively provides controls that allows the
user to specify aspects of content distributed as part of the release.

#### Release objectives

The release objectives are the high level objectives of an invocation of the
release script.

The release objectives are determined by the desires communicated threw the
user's uses of the controls.

Each release objective has checks that determine what release actions, if any,
need to be preformed to satisfy the release objective.

#### Release Actions

Release actions are actions that are preformed to satisfy release objectives.

The release plan is a sequence of release actions that will be enacted to
satisfy all of the unsatisfied release objective.

While the contents of the release plan is generated based on the what release
actions the release objectives' checks determined need to be preformed, the
sequence of the release actions in the release plan are determined by what
release actions depend on what other release actions.

Also, Given that release actions are expected to be very dependent on services
and cause state-full changes...

1. Checks are preformed before enacting release actions to determine if an
action is likely to fail before attempting to enact them.
2. Revert actions are enacted for all successfully enacted release actions when
a release action fails.

Each release action could also require certain information from the user for it
to be enacted.

#### Needed information

To preform some the release actions the scrip will require information not part
of the controls from the user. The information the release scrip needs from
the user depends on what release actions are part of the release plan, and as a
result the information needed depends on the user's use of the controls.

Depending on the information needed, the information can be sourced from user's
environment or be provided by the user via command line argument.

### Controls

The scrip will provide an initial set of controls.

The use can specify their release content configuration in a `release.yml` file
at the root of their repository.


#### Release Identifier

TODO

### Command line controls

- Identifier
  - Type: String
  - Description: The base string for the release identifier.
  - Notes
    - If `Prefix` is set in the content configuration, then it is used with the
    value of this option to from the release identifier.
    - It overrides the `Identifier` in the content configuration.
    - If it is not provided the `Identifier` in the content configuration will be
    used.
- Content
  - Type: Path
  - Default: release.y(a)ml
  - Description: A path to a content configuration file.

#### Release Content configuration options

- Identifier
  - Type: String
  - Description: The release identifier.
  - Notes
    - Only used if the `Identifier` argument was not provided via the command
    line.
    - Not required but if it is missing and the `Identifier` argument is not
    provided via the command line, then there will be not "Release Identifier"
    and the release will fail.
- Prefix
  - Type: String
  - Default: ""
  - Description: A string prepended to the `Identifier` provided via the command
  line to form the release identifier.
  - Notes
    - If the `Identifier` argument is not provided in the command line, this is
    ignored and the `Identifier` from the content configuration is used directly
    as the "Release Identifier".
- Title.Prefix
  - Type: String
  - Default: ""
  - Description: A prefix combined with the release identifier to form a release
  title to be used where human readable is more important.
- Description
  - Text
    - Type: String
    - Default: ""
    - Description: A description of the release.
  - Include GitHub Generated Release Notes
    - Type: Bool
    - Default: False
    - Description: Whether to include the release note generated by GitHub in
    the descriptions of the release.
- Git.Tag
  - Always Publish
    - Type: Bool
    - Default: False
    - Description: If the git tag should be published even if no release
    objectives call for it.
  - Prefix
    - Type: String
    - Default: ""
    - Description: A string prepended to the release identifier to form the git
    tag representing the release in git repositories.
- GitHub.Release
  - Always Publish
    - Type: Bool
    - Default: True
    - Description: If the GitHub release should be published even if no other
    release objectives call for it.
  - Assets
    - Type: List of ((Name+`static asset`) and `static asset`)
    - Default: Empty list
    - Description: A list of static assets to be include in the GitHub release.
    - Notes
      - For every Name+`static asset` pair use the name as the name of the file
      on GitHub and the `static asset` for the actual file to upload.
      - For every `static asset` use the name of the file as the name of the
      file on GitHub and the `static asset` as the actual file to upload.
      - Error if there are any name conflicts between the names in assets and
      in Asset_folders.
  - Asset_folders
    - Type: List of `Directory of static asserts`
    - Default: Empty list
    - Description: A list of directories of assert to be included in the GitHub
    release.
    - Notes
      - Use the names of the files in the directories as the asset names on
      GitHub.
      - Error if there are any name conflicts between the names in assets and
      in Asset_folders.

Where a `static assert` is a reference to a nix derivation in the nix flake
output, optionally with a path post-fixed to the the output. The
derivation+optional path needs to resolve to a file for it to be a valid
`static assert`.

Examples
```
$(allStatic)/marlowe-cli
$(allStatic)/marlowe-finder
lib.getExe static.x86_64-linux.marlowe-cli
```

Where a `Directory of static asserts` is reference to a  nix derivation in the
flake output, optionally with a path post-fixed to the output. The
derivation+optional path needs to resolve to a directory only containing files
for it to be a valid `Directory of static asserts`.

Examples
```
"allStatic.x86_64-linux"
```

### Objectives

- GitHub release published
  - Objective - A release is on GitHub for the HEAD commit, tagged with the
  release tag, with the appropriate contents.
  - Reasons
    - `GitHub.Release.Always Publish` is `True`.
    - `GitHub.Release.Assets` is not Empty.
    - `GitHub.Release.Asset_folders` is not Empty.
  - Checks
    - Release exists on GitHub
- Release tag published
  - Objective - A git tag for the HEAD commit, with the appropriate contents, is
  publish to public git repositories.
  - Reasons
    - `Git.Tag.Always Publish` is `True`.
  - Checks
    - Tag exists on GitHub

### Checks

- Release exists on GitHub
  - Check if release exists on GitHub
    - If it does not exist, include "Create GitHub release" in release plan.
    - If it does exist, fail the check
- GitHub Cli configured correctly
  - Check if the GitHub Cli is configured correctly
    - If it is, succeeded the check
    - If it is not, fail the check
- Tag exists on GitHub
  - Check if tag exists on GitHub
    - If it does not exist, include "Push remote tag" in release plan.
    - If it does exist, check if it is as expected
      - If it is, succeeded the check
      - If it is not, fail the check
- Tag exists locally
  - Check if tag exists locally
    - If it does not exists, include "Create local tag" in release plan.
    - If it does exists, check if it is as expected
      - If it is, succeeded the check
      - If it is not, fail the check
- Git configuring correctly
  - Check if git is configured correctly
    - If it is, succeeded the check
    - If it is not, fail the check

### Actions

- Create GitHub release
  - Description: Create a release on appropriate GitHub repo.
  - Pre-checks
    - Git configured correctly
    - GitHub Cli configured correctly
    - Tag exists on GitHub ?Not needed?
  - After
    - Push remote tag
  - Steps
    -
    ```
    gh release create ${Git.Tag.Prefix+release identifier} \
      -t ${Title.Prefix+release identifier}
      -n "${Description.Text+if include GitHub generated then \n GitHub generate release notes}"
      PATHS_TO_ASSETS
    ```
  - Success Checks
    - `gh release view ${Git.Tag.Prefix+release identifier}`
  - Revert Actions
    - `gh release delete ${Git.Tag.Prefix+release identifier}`
- Push remote tag
  - Description: Push tag to remote repositories
  - Pre-checks
    - Git configured correctly
    - Tag exists locally
  - After
    - Create local tag
  - Steps
    - `git push origin ${Git.Tag.Prefix+release identifier}`
  - Success Checks
    -
    ```
    git ls-remote \
      --exit-code \
      origin \
      refs/tags/${Git.Tag.Prefix+release identifier}
    ```
  - Revert actions
    - `git push origin -d ${Git.Tag.Prefix+release identifier}`
- Create local tag
  - Description: Create tag locally
  - Pre-checks
    - Git configured correctly
  - Steps
    -
    ```
    git tag \
      -a ${Git.Tag.Prefix+release identifier} \
      -m "${Description.Text+if include GitHub generated then \n GitHub generate release notes}"
    ```
  - Success Checks
    -
    ```
    release_commit=$(git rev-list -1 ${Git.Tag.Prefix+release identifier})
    head_commit=$(git rev-parse HEAD)
    [ $release_commit = $head_commit ]
    ```
  - Revert actions
    - `git tag -d ${Git.Tag.Prefix+release identifier}`

### Script steps

When the release script is invoked, the script preforms a few steps...

#### 1. Validate inputs

The first step is to check if any values for any configuration options are
invalid and if any values are missing for any required configuration options.

If there are any invalid or missing values...

1. For every value that is invalid or missing,
    1. Display an error message stating the that the value is invalid or missing
    2. Display a message to help the user provide a valid value for the
    configuration option.
2. Exit the script.

If no required inputs are invalid or missing, continue to the next step.

#### 2. Determine release objectives

Release objectives are determined from the inputs provided.

#### 3. Release Objective Checks

1. For each check in each release objective,
    1. If the check had been preformed already, skip the check.
    2. If the check has not been ran, preform the check.
        1. Track that the check had been preformed.
        2. If the check failed, displayed an error message.
        3. If the check succeeded, displayed a success message.
        4. If the check requested to include release actions to the release plan
            1. For each release action
                1. If the release action has already been marked to be queued
                into the release plan, continue to the next release action.
                2. If the release action has not been marked to be queued into
                the release plan,
                  1. Start an empty queue of checks.
                  2. Add all the checks that have not been ran into the queue.
                  3. Run all the checks in the queue
                      1. Track that the check had been preformed.
                      2. If the check failed, displayed an error message.
                      3. If the check succeeded, displayed a success message.
                      4. If the check requested to include release actions to
                      the release plan
                          1. For each release action
                              1. If the release action has already been marked
                              to be queued into the release plan, continue to
                              the next release action.
                              2. If the release action has not been marked to
                              be queued into the release plan
                                  1. Add all the checks that have not been ran
                                  into the queue.
                                  2. Continue to the next release action.
                      5. Keep running all the checks in the queue until the
                      queue is empty.
2. If any release checks failed display any error message and exit the script.
3. If there are no release actions marked to be queued into the release plan
then display a message saying to actions need to be taken to preform a release
and exit the scrip successfully.
4. If there are release actions marked to be queued into the release plan,
continue to the next step.


#### 4. Schedule the release plan

Using the info describing what actions must come after what other actions,
keep taking unqueued release actions that do not have any unqueued release
actions that that they are after and remove them from the list of unqueued
release actions and queue them into the release plan.

#### 5. Display the release plan

The script displays a description of the release plan to the user. The release
plan describes a sequence of release actions that will be taken to create the
release.

#### 4. Release actions

The script attempts to preform the actions described in the release plan.

1. For every release action
    1. Display that the action that will be attempted
    2. Attempt to preform the action
        1. If it succeeds
            1. Display that the action has succeeded
            2. Continue to the next release action
        2. If it fails
            1. Display an error message describing the failure of the release
            action
            2. Display the release actions that will not be attempted
            3. For every release action that has succeeded, in reverse order
                1. Display that a revert action for the release action will be
                attempted
                2. Attempt to preform the revert action
                    1. If it succeeds
                        1. Display that the revert action has succeeded and the
                        release action has been reverted
                        2. Continue to the next succeeded release action to be
                        reverted
                    2. If it fails
                        1. Display an error message describing the failure of
                        the revert action, and that the release action was not
                        reverted
                        2. Display the release actions that the script will not
                        attempt to revert and the revert actions that would have
                        been used.
                        3. Exit the script
            4. Display a message saying that the successful release actions were
            successfully reverted
            5. Exit the script
2. Display a message saying that the release plan was successfully enacted.
