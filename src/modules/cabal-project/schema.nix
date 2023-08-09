validators: with validators;

{
  cabalProjectLocal.type = string;
  cabalProjectLocal.default = "";

  sha256map.type = attrset;
  sha256map.default = { };

  shellWithHoogle.type = bool;
  shellWithHoogle.default = false;

  shellBuildInputs.type = list;
  shellBuildInputs.default = [ ];

  modules.type = list;
  modules.default = [ ];

  overlays.type = list;
  overlays.default = [ ];
}