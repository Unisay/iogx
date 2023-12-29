# Gh releases

- The "Contributors" section is generated from the mentions in the body
- `generate_release_notes`
  - "What's changed" - earlist to lateist PRs merged into target branch
  - "New Contributors" - Anyone who made first PR into
  - "Full Changelog" - commits of the tag of the release

# What does plutus do

Just uses gh generated release notes

# What does marlowe-cardano do

some stuff with scriv

# What to do for now -- ROSARIO CONTINUE FROM HERE

I should probable not worry about scriv for now, as at least plutus is only gh
generated release notes

could have a `github_include_geneated_release_notes`

# dfkdjf

release.yml
```yml
name : "something"
description :
  text : "Release of blaaaa"
  include_changelog_from_scriv : true
  include_pull_requests : true
  include_contributors : true


assert
  foo : bar
```


```sh
create_release <tag>
  --config release.yml
  --target <branch|commit>
  --prerelease
  --rotate_scriv_changelog
# If I want to create release
create_release v0.1.0

# If I want to create a pre-release
# Marked as pre-release on github dose not rotate scriv logs
create_release head --pre-release

# If I want to overide the description
create_release head --pre-release --discription ""

# If I want to create a release of the tools
# By the full file name or just specifier (don't care)
create_release --config tools v0.1.0
create_release --config release-tools.yaml v0.1.0
```

# teams might want better control over the release process/notes 
# teams might not want to use automated releases
# teams might want to edit release notes manually later 
# The above could mean that we'll have to provide some sort of templating solution 



- release.yaml
- release-tools.yaml
- release-services.yaml

```yaml
{
    description:str="",

    include_changelog_from_scriv=True, 
    include_pull_requests=True,
    include_contributors=True,
    
    asset = {
      ...
    }
}
```

Interactive commands
```bash
# Maybe an interactive flag or maybe an --automated flag
$create_release -i
# If there is only one release-config use it else show options
> Wich release config would you like to use?
> [1] Default
> [2] tools
> [3] services
> Select release config (Press enter to use the default):
# Show a useful summary of the important details of whats important in the config
> Will publish...

```

Autoamted commands
```bash
# If I want to create release
create_release v0.1.0

# If I want to create a pre-release
# Marked as pre-release on github dose not rotate scriv logs
create_release head --pre-release

# If I want to overide the description
create_release head --pre-release --discription ""

# If I want to create a release of the tools
# By the full file name or just specifier (don't care)
create_release --config tools v0.1.0
create_release --config release-tools.yaml v0.1.0
```

publish-github-release() {
  --config::file{}
}



def publish_github_release(
    tag_name:str, # will create a tag if does not exits, and abort it exists
#    is_latest:bool=True, 
    description:str="",
    include_changelog_from_scriv=True, 
    rotate_scriv_changelog=True,
    include_pull_requests=True,
    include_contributors=True,
    asset_file
    assets=[
      ("attrset to a nix derivation from the flake":str, assert_name:str)
    ],
):
  pass 



{
  "asset_anme" = "drv_path";
}


github-release-assets.nix

{ repoRoot, inputs, pkgs, ... }:

(lib.option system=)
{ 
  "asset_name" = inputs.self....;
}

# release.nix 
{ repoRoot, inputs, pkgs, ... }:

{
  github-release-assets = import ./github-release-assets.nix; # outputs: {};
}


{ repoRoot, inputs, pkgs, ... }:
outputs:
{outputs.thing inputs.self.system.thing.
{outputs.system.thing
  "uplc-static-x86_64-linux": "x86_64-linux.ghc96-musl64.cabalProject.hsPkgs.plutus-core.components.exes.pir";
  "uplc-static-x86_64-darwin": "x86_64-linux.ghc96-musl64.cabalProject.hsPkgs.plutus-core.components.exes.pir";
}

hydraJobs.musl64.ghc96.pir = ghc96-musl64.cabalProject.hsPkgs.plutus-core.components.exes.pir;
hydraJobs.musl64.ghc96.plc = ghc96-musl64.cabalProject.hsPkgs.plutus-core.components.exes.plc;
hydraJobs.musl64.ghc96.uplc = ghc96-musl64.cabalProject.hsPkgs.plutus-core.components.exes.uplc; # editorconfig-checker-disable-line
hydraJobs.musl64.ghc96.debugger = ghc96-musl64.cabalProject.hsPkgs.plutus-core.components.exes.debugger; # editorconfig-checker-disable-line
    


include_changelog_from_scriv=True, 
rotate_scriv_changelog=True,
include_pull_requests=True,
include_contributors=True,

- 

github assets 
deployments
... 




  lib.iogx.mkGithubRelease {
    [drv], "$excname_$system_$version";
    { drv = drv, asset-name = "$excname-$version-$system.tar.gz"
  };
  {
    [drv], "$excname_$system_$version_static";

    drv = drv: "name"; "$exc-name_$system_$version_static_$wig"
  }


---
```
gh -R https://github.com/input-output-hk/marlowe-cardano \
  <tag> \
  --target_commitish
  --title <string>
  --notes <string> | --notes-file <file> \
  --prerelease \
```

Env

GH_TOKEN
GH_REPO

