{
  display = ./display.nix;
  qemu = ./qemu.nix;
  connection = ./connection.nix;
  binding = ./binding.nix;
  ssl = ./ssl.nix;
  domain = ./domain.nix;
  mutable-state = ./mutable-state.nix;

  __functionArgs = { };
  __functor = self: { ... }: {
    imports = with self; [
      display
      qemu
    ];
  };
}
