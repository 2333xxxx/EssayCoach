{
  description = "A development environment for EssayCoach";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/25.05";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs {
          inherit system;
          config = {};
          overlays = [];
        };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            # Frontend Development (Vue.js 3 + Vite)
            nodejs_22
            nodePackages.pnpm
            nodePackages.prettier
            nodePackages.typescript
            nodePackages.eslint
            nodePackages."@vue/language-server"

            # Backend Development (Python FastAPI + AI/ML)
            python311
            python311Packages.pip
            python311Packages.virtualenv
            black
            python311Packages.flake8
            python311Packages.mypy

            # Shell
            zsh
            oh-my-zsh
            zsh-syntax-highlighting
            zsh-autosuggestions
          ];
          shellHook = ''
            export SHELL=$(which zsh)
            export ZDOTDIR="$PWD/.zsh"
            mkdir -p "$ZDOTDIR"
            # Install oh-my-zsh
            if [ ! -d "$ZDOTDIR/oh-my-zsh" ]; then
              cp -r ${pkgs.oh-my-zsh}/share/oh-my-zsh "$ZDOTDIR/oh-my-zsh"
            fi
            # Install plugins
            mkdir -p "$ZDOTDIR/oh-my-zsh/custom/plugins"
            if [ ! -d "$ZDOTDIR/oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
              cp -r ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting "$ZDOTDIR/oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
            fi
            if [ ! -d "$ZDOTDIR/oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
              cp -r ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions "$ZDOTDIR/oh-my-zsh/custom/plugins/zsh-autosuggestions"
            fi
            # Create .zshrc with enhanced appearance
            if [ ! -f "$ZDOTDIR/.zshrc" ]; then
              cat > "$ZDOTDIR/.zshrc" <<EOF
export ZSH="$ZDOTDIR/oh-my-zsh"
ZSH_THEME="agnoster"
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)
source "$ZDOTDIR/oh-my-zsh/oh-my-zsh.sh"
EOF
            fi
            exec zsh
          '';
        };
      });
    };
}
