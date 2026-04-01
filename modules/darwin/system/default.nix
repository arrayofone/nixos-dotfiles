{
  lib,
  namespace,
  ...
}:
{
  options.${namespace}.system.name = lib.mkOption {
    description = "The system name";
    type = lib.types.str;
    default = "";
  };
}
