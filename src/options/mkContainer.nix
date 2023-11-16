iogx-inputs:

let

  l = builtins // iogx-inputs.nixpkgs.lib;

  utils = import ../lib/utils.nix iogx-inputs;

  link = x: utils.headerToLocalMarkDownLink x x;


  mkContainer-IN-submodule = l.types.submodule {
    options = {
      name = l.mkOption {
        type = l.types.nullOr l.types.str;
        default = null;
      };
      tag = l.mkOption {
        type = l.types.str;
        default = "latest";
      };
      description = l.mkOption {
        type = l.types.nullOr l.types.str;
        default = null;
      };
      # Want to easily default to shared value
      # Either set manually by the user for iogx use or automatically generated somehow
      sourceUrl = l.mkOption {
        type = l.types.nullOr l.types.str;
        default = null;
      };
      # Want to easily default to shared value
      # Either set manually by the user for iogx use or automatically generated somehow
      license = l.mkOption {
        type = l.types.nullOr l.types.str;
        default = null;
      };

      uid = l.mkOption {
        type = l.types.int;
        default = 0;
      };
      gid = l.mkOption {
        type = l.types.int;
        default = 0;
      };

      # nixpkgs.dockerTools
      #
      # Unpacks an image repo
      # gets the manifest from it
      # {
      #   # path to repo tarball cotaning the base image
      #   fromImage
      #   # base image name within repo
      #   # (Optional) if null use first image in tarball
      #   fromImageNmae
      #   # what tag of the image
      #   # (Optional)
      #   fromImageTag
      # }
      # nix2container
      #
      # Optional Base image to build everything on top of
      fromImage = l.mkOption { };

      # Simplified "copy things to root of container" (all deps are added to the
      # container's /nix/store/)
      # This creates the next layers
      # Direct them to buildEnv if they want to add packages to bin
      copyToRoot = l.mkOption { };

      # Script to run in vm as root chroot'ed into file system with the preceding layers
      # Used in user need imperative commands to setup environment
      # Might require system have kvm capability or use of fakeroot
      # Note: If the user does not us this we have many options on efficiently generating images
      runAsRoot = l.mkOption { };

      # Change parameters of files in image
      perms = l.mkOption { };
      # Commands to run in the resulting filesystem
      extraCommands = l.mkOption { };

      # What to run by default
      entrypoint = l.mkOption { };
      # As per https://github.com/opencontainers/image-spec/blob/8b9d41f48198a7d6d0a5c1a12dc2d1f7f47fc97f/specs-go/v1/config.go#L23
      imageConfig = l.mkOption { };
    };
  };


  mkContainer-OUT-submodule = l.types.submodule {
    options = { };
  };


  mkContainer-IN = l.mkOption {
    type = mkContainer-IN-submodule;
    description = ''
      # Not Rendered In Docs
    '';
  };


  mkContainer-OUT = l.mkOption {
    type = mkContainer-OUT-submodule;
    description = ''
      # Not Rendered In Docs
    '';
  };


  mkContainer = l.mkOption {
    description = ''
      The `lib.iogx.mkContainer` function builds a portable container for use with docker and similar tools.

      In this document:
        - Options for the input attrset are prefixed by `mkContainer.<in>`.
        - The returned attrset contains the attributes prefixed by `mkContainer.<out>`.
    '';
    type = utils.mkApiFuncOptionType mkContainer-IN.type mkContainer-OUT.type;
    example = l.literalExpression ''
      # nix/containers.nix
      { repoRoot, inputs, pkgs, lib, system }:
      {
        foo = lib.iogx.mkContainer {
        }
      }

      # nix/outputs.nix
      { repoRoot, inputs, pkgs, lib, system }:
      [
        {
          containers = repoRoot.containers;
        }
      ]
    '';
  };

in

{
  inherit mkContainer;
  "mkContainer.<in>" = mkContainer-IN;
}
