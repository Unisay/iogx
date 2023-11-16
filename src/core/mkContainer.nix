{ repoRoot, iogx-inputs, user-inputs, pkgs, lib, system, ... }:

userConfig:

let

  utils = lib.iogx.utils;

  evaluated-modules = lib.evalModules {
    modules = [{
      options = lib.iogx.options;
      config."mkContainer.<in>" = userConfig;
    }];
  };


  evaulatedConfig = evaluated-modules.config."mkContainer.<in>";

in
