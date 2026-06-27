# dotfiles

Configurações pessoais gerenciadas com [GNU Stow](https://www.gnu.org/software/stow/).
Cada pasta do topo é um pacote: o conteúdo dela espelha o `$HOME` e é aplicado via symlink.

## Estrutura

```
dotfiles/
├── pacote1/
└── pacote2/
```

## Instalação numa máquina nova

```bash
git clone <repo> ~/dotfiles
cd ~/dotfiles
stow pacote1 pacote2     # ou: stow */
```

Isto cria os symlinks no `$HOME`. Depois, abra um shell novo (`exec zsh`).

> **Atenção:** o `stow` recusa se já existir um arquivo real no destino
> (ex.: `~/.zshrc`). Mova/apague o conflitante antes, ou use `stow --adopt`.

### Dependências externas

Os configs assumem que os apps já estão instalados. Alguns pacotes dependem de
peças que **não** ficam neste repo:

- **zsh** → [oh-my-zsh](https://ohmyz.sh) (tema `gentoo`) + plugins `zsh-autosuggestions`
  e `zsh-syntax-highlighting`. Instale o oh-my-zsh **antes** de stowar o `zsh`
  (com `KEEP_ZSHRC=yes`), senão o instalador dele sobrescreve o `~/.zshrc`:

  ```bash
  # oh-my-zsh (KEEP_ZSHRC evita sobrescrever o ~/.zshrc)
  KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  # plugins
  ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  git clone https://github.com/zsh-users/zsh-autosuggestions     "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

  # depois stowe o pacote e recarregue o shell
  stow zsh && exec zsh
  ```
- **direnv** → `direnv` + `nix-direnv` (`nix profile add nixpkgs#nix-direnv`),
  carregado pelo `direnvrc`.

## Dia a dia

```bash
stow <pacote>      # cria os symlinks
stow -D <pacote>   # remove
stow -R <pacote>   # recria (após adicionar arquivos novos ao pacote)
stow -nv <pacote>  # dry-run: mostra o que faria, sem alterar nada
```

No `.zshrc` há o atalho `dots`, que stowa todas as pastas de uma vez.
