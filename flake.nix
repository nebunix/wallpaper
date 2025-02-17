{
  inputs = { };

  outputs =
    { ... }:
    {
      nixosModules = {
        default = import ./module;
      };
    };
}
