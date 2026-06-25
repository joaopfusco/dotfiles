# dotfiles

Config dos apps gerenciada com [GNU Stow](https://www.gnu.org/software/stow/).
Migrado do antigo `nix-config` (home-manager) — o nix continua só para dev (flakes por projeto).

## Estrutura

Cada pasta do topo é um pacote do stow: o conteúdo espelha o `$HOME`.

```
dotfiles/
├── packages/          # NÃO é stowado — só listas de instalação
│   ├── Brewfile       # macOS  (brew bundle)
│   └── Aptfile        # Linux  (apt + refs oficiais p/ o resto)
├── zsh/               # ~/.zshrc
├── git/               # ~/.config/git/config
├── zed/               # ~/.config/zed/{settings,keymap}.json
├── claude/            # ~/.claude/settings.json
└── direnv/            # ~/.config/direnv/direnvrc
```

> `packages/` não é passado pro stow, então ele nunca symlinka isso pro `$HOME`.

## Instalação numa máquina nova

```bash
# 1. Apps (opcional — escolha conforme o OS)
brew bundle --file packages/Brewfile                                  # macOS
sudo apt install -y $(grep -vE '^\s*#|^\s*$' packages/Aptfile)        # Linux

# 2. stow (se ainda não tiver: brew install stow / sudo apt install stow)
cd ~/dotfiles
stow git zsh zed claude direnv
```

No Linux, as ferramentas que não estão no apt (uv, terraform, language servers...)
têm o instalador oficial documentado nos comentários do `packages/Aptfile`.

> `stow` falha se já existir um arquivo real no destino (ex.: `~/.zshrc`).
> Mova/apague o conflitante antes, ou use `stow --adopt` com cuidado.

## Dia a dia

```bash
stow <pacote>      # cria os symlinks
stow -D <pacote>   # remove
stow -R <pacote>   # recria (após adicionar arquivos novos)
```

## Não migrado do nix-config (continua no nix, para dev)

`flake.nix` dos projetos, `direnv`/`nix-direnv`, e tooling de nix.
Home-manager foi aposentado — flakes (`nix develop`) não precisam dele.
