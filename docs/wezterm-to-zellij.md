# WezTerm → Zellij 移行メモ

2026-05 に実施した、ターミナル多重化を WezTerm 内蔵機能から Zellij に切り替えた際の記録。

## 背景

### きっかけ

`claudecode.nvim` で `claude`
セッションを Neovim 内ターミナルではなく外部ターミナルのスプリットに開きたかった。プラグインには`external_terminal_cmd`
という設定があり、外部コマンドにペイン分割を委譲できる。

最初は WezTerm の `wezterm cli split-pane` を直接呼ぶ案を検討したが、

- WezTerm のペイン操作は CLI で完結できるが、Neovim 内のフォーカス制御まで含めるとシェル側に状態が漏れる
- ターミナル多重化は WezTerm 側よりも、より用途に特化した Zellij のほうが学習価値・拡張性ともに高い

という判断で、ペイン/タブ機能を Zellij へ全面移行した。

### 移行前後の役割分担

| 役割                               | 移行前  | 移行後                                   |
| ---------------------------------- | ------- | ---------------------------------------- |
| ウィンドウ/フォント/カラースキーム | WezTerm | WezTerm(変更なし)                        |
| ペイン分割                         | WezTerm | **Zellij**                               |
| タブ                               | WezTerm | **Zellij**                               |
| コピー&ペースト, フォントサイズ    | WezTerm | WezTerm(残置)                            |
| 外部 claude セッション起動         | (なし)  | `zellij run --direction right -- claude` |

WezTerm 側のペイン/タブ系キーバインドは
**コメントアウトのみで残置**(削除しない)。WezTerm 単体で起動したときの参照用かつ、後で戻したくなった場合の備え。

## 採用した構成

### 設計判断

| 論点                  | 採用                               | 却下                                    | 理由                                                                                                 |
| --------------------- | ---------------------------------- | --------------------------------------- | ---------------------------------------------------------------------------------------------------- | ---------------------------------------------- |
| Zellij 設定の管理方法 | `home.file` で `config.kdl` を配置 | `programs.zellij.settings`(Nix attrset) | キーバインドの記述が冗長になり、KDL の文法を直接学べない                                             |
| `default_mode`        | `locked`                           | `normal`                                | Neovim の `Ctrl+O/P/I/R/W/...`を奪われないため(ロック中は全キーが Neovim に渡る)                     |
| リーダーキー          | `Ctrl+Space`                       | `Space` ダブルタップ                    | Zellijはキーシーケンス(連続キー)未対応。検証時に KDL パースエラー                                    |
| tmux 風キーの実装     | **ビルトイン Tmux モードを流用**   | 自前で `normal` モードにフル実装        | Zellij 0.25.0 以降、Tmux モードに `                                                                  | - hjkl c n p x z r d [` 等がプリセット定義済み |
| `clear-defaults`      | **使わない**                       | `clear-defaults=true` で全消し          | `default_mode "locked"` を選んだ時点でデフォルトキーバインドは Neovim 操作中は休眠状態。消す必要なし |

### 操作フロー

1. 起動 → **Locked モード**。すべてのキーが Neovim/シェルに渡る
2. ペイン操作したくなったら `Ctrl+Space` → **Tmux モード** へ
3. Tmux モード内のキーバインド(ビルトイン):
   - `|` 右に縦分割 / `-` 下に横分割
   - `h j k l` フォーカス移動
   - `x` ペイン閉じる / `z` ズーム
   - `c` 新規タブ / `n` 次タブ / `p` 前タブ / `1`〜`9` タブ番号指定
   - `r` リサイズモード / `[` スクロールモード
   - `d` デタッチ
4. `Ctrl+Space` または `Esc` で Locked モードに戻る

### claudecode.nvim との接続

```lua
-- .config/nvim/lua/plugins/claudecode.lua
external_terminal_cmd = 'zellij run --direction right -- %s',
```

Neovim 内から `:ClaudeCode` を実行すると、Zellij が右側にペインを開き、その中で
`claude`が起動する。

## ファイル構成

```
.config/
├── wezterm/
│   ├── wezterm.lua       # 基本設定のみに縮小(ペイン/タブ系は撤去)
│   └── keybinds.lua      # ペイン/タブ系キーはコメントアウトで残置
└── zellij/
    ├── config.kdl        # default_mode, theme, leader バインド
    └── layouts/
        └── default.kdl   # 起動時の 2 ペイン縦分割レイアウト
```

`home.nix` の関連部分:

```nix
# programs.zellij は enable だけ(設定は KDL 直書き)
programs.zellij.enable = true;

# config.kdl と layout を home.file で配置
home.file = {
  ".config/zellij/config.kdl".source          = ./.config/zellij/config.kdl;
  ".config/zellij/layouts/default.kdl".source = ./.config/zellij/layouts/default.kdl;
};
```

## 既知の制約・落とし穴

### Zellij × KDL バージョンの罠

- Zellij 0.44.1 が期待する KDL は **v1**(値はクォート必須:
  `split_direction="vertical"`)
- `kdlfmt` 0.1.6 のデフォルトは **v2**(クォートを剥がしてしまう)
- `:Format` で保存すると
  `vertical`のクォートが剥がれて起動時にパースエラーになるため、conform.nvim 側で
  `--kdl-version v1`を明示的に渡している

```lua
-- .config/nvim/lua/plugins/conform.lua(抜粋)
formatters = {
  kdlfmt = {
    command = 'kdlfmt',
    args = { 'format', '--kdl-version', 'v1', '-' },
    stdin = true,
  },
},
```

`prepend_args` ではなく `args` 全体を上書きする必要がある(prepend_args だと
`--kdl-versionv1` が `format`
サブコマンドの前に挿入され、kdlfmt が引数として解釈できずエラーになる)。

### Tree-sitter

KDL のシンタックスハイライトには `tree-sitter` CLI が必要。`home.nix` の
`home.packages` に `tree-sitter` を追加済み。

### Space ダブルタップ不可

Zellij のキーバインドは「単一キー or 修飾キー組み合わせ」のみ。`bind "Space Space"`のような連続キーシーケンスは構文エラーになる。Neovimと同じ感覚でリーダーキーを揃えたかったが、これは妥協ポイント。

## 反映コマンド

```sh
home-manager switch --flake .#yuki
zellij setup --check   # パースエラーの有無を確認
zellij                 # 起動確認
```
