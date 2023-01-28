{
  description = "JupyterLab Flake with Marlowe Environment";

  inputs = {
    jupyterWith.url = "github:tweag/jupyterWith";
    flake-utils.url = "github:numtide/flake-utils";
    here.url = "github:input-output-hk/marlowe-cardano/SCP-4758";
  };

  outputs = { self, nixpkgs, jupyterWith, flake-utils, here }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = import nixpkgs {
          system = system;
          overlays = nixpkgs.lib.attrValues jupyterWith.overlays;
        };
        local = here.packages.${system};
        ibash = pkgs.jupyterWith.kernels.bashKernel {
          name = "Marlowe";
        };
        jupyterEnvironment = pkgs.jupyterlabWith {
          kernels = [
            ibash
          ];
          extraPackages = p: [
            local.marlowe-rt
            local.marlowe-cli
          # local.marlowe.cardano-address
          # local.marlowe.cardano-node
            local.pkgs.cardano.packages.cardano-cli
            p.coreutils
            p.curl
            p.gnused
            p.jq
          ];
        };
      in
        {
          apps = rec {
            default = jupyter;
            jupyter = {
              type = "app";
              program = "${jupyterEnvironment}/bin/jupyter-lab";
            };
          };
          hydraJobs = {
            inherit jupyterEnvironment;
          };
        }
    );
}
