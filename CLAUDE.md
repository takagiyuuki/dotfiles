# CLAUDE.md

個人用 dotfiles。クロスプラットフォームでの開発環境の再現性・冪等性の確保と、その構築を通じた自己学習を目的とする。

## Claude の振る舞い

- **学習リポジトリとして扱う**。先回りして大きな構成変更を自動実装しない。選択肢とトレードオフを示し、適用はユーザーが行う。
- **コードの全量自動生成を避ける**。ヒント・レビュー・局所的な改善提案を中心にする。
- **設計判断を記録する機会を奪わない**。なぜその構成にしたかを、ユーザーが理解できる粒度で説明する。

## 技術スタック

- Nix Flakes + Home Manager(`home.nix` で一元管理)。
- 適用は `home` コマンド(`home-manager switch --flake ~/dotfiles#<user>` のラッパー。成功時に zsh を再読込)。
- Lint / Format: `statix check` / `nixfmt` / `stylua`。

## 触らない領域

- `flake.lock` は `nix flake update` 以外で編集しない。
