{ nixpkgs ? import <nixpkgs> {}, compiler ? "default" }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, Euterpea, stdenv }:
      mkDerivation {
        pname = "euterpea";
        version = "0.1.0.0";
        src = ./.;
        isLibrary = false;
        isExecutable = true;
        executableHaskellDepends = [ base Euterpea ];
        license = stdenv.lib.licenses.bsd3;
      };

  haskellPackages = pkgs.haskellPackages.override (old: {
    overrides = self: super: {
      Euterpea = 
        pkgs.haskell.lib.dontCheck (self.callHackage "Euterpea" "1.1.1" {});
      PortMidi = self.callHackage "PortMidi" "0.1.5.2" {};
      stm = self.callHackage "stm" "2.4.2" {};
      heap = self.callHackage "heap" "0.6.0" {};
    };
  });
  #Euterpea = pkgs.haskell.lib.dontCheck Euterpea;
                    
  drv = haskellPackages.callPackage f {};

in

  if pkgs.lib.inNixShell then drv.env else drv
