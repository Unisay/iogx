iogx-inputs:

let
  l = builtins // iogx-inputs.nixpkgs.lib;

  utils = import ../lib/utils.nix iogx-inputs;

  mkContainerFromCabalExe-IN-submodule = l.types.submodule {
    options = {
      exe = l.mkOption {
        type = l.types.package;
        description = ''
          The exe produced by haskell.nix that you want to wrap in a container.
        '';
        example = l.literalExpression ''
          project.packages.fooExe
        '';
      };

      name = l.mkOption {
        type = l.types.nullOr l.types.str;
        default = null;
        defaultText = l.literalExpression "exe.exeName";
        description = ''
          Name of the container produced.
        '';
      };
    };
  };

  mkContainerFromCabalExe-OUT-submodule = l.types.submodule {
    options = { };
  };

  mkContainerFromCabalExe-IN = l.mkOption {
    type = mkContainerFromCabalExe-IN-submodule;
    description = ''
      # Not Rendered In Docs
    '';
  };

  mkContainerFromCabalExe-OUT = l.mkOption {
    type = mkContainerFromCabalExe-OUT-submodule;
    description = ''
      # Not Rendered In Docs
    '';
  };

  mkContainerFromCabalExe = l.mkOption {
    description = ''
      The `lib.iogx.mkContainerFromCabalExe` function builds a portable container for use with docker and similar tools.

      It outputs the results from running nix2container's buildImage function.

      See. https://github.com/nlewo/nix2container

      In this document:
        - Options for the input attrset are prefixed by `mkContainerFromCabalExe.<in>`.
    '';
    type = utils.mkApiFuncOptionType mkContainerFromCabalExe-IN.type mkContainerFromCabalExe-OUT.type;
    example = l.literalExpression ''
      # nix/containers.nix
      { repoRoot, inputs, pkgs, lib, system }:
      {
        fooContainer = lib.iogx.mkContainerFromCabalExe {
          exe = inputs.self.packages.fooExe;
        };

        barContainer = lib.iogx.mkContainerFromCabalExe {
          exe = inputs.self.packages.barExe;
          name = "bizz";
        };
      }

      # nix/outputs.nix
      { repoRoot, inputs, pkgs, lib, system }:
      let
        containers = repoRoot.nix.containers;
      in
      [
        {
          inherit containers;
        }
      ]
    '';
  };
in
{
  inherit mkContainerFromCabalExe;
  "mkContainerFromCabalExe.<in>" = mkContainerFromCabalExe-IN;
}
