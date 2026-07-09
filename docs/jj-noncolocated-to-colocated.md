# Jujutsu: non-colocated → colocated 化

## 背景

- 別プロジェクトで non-colocated 構成だと、git エコシステム(`gh` CLI、エディタの git 統合、`pre-commit` などのフック類)とまともに連携できないケースが頻発した。
- このリポジトリでも `gh pr create` が `fatal: not a git repository` で失敗し、`-R OWNER/REPO` を毎回付与する必要があった。
- PR #16 マージ後の落ち着いたタイミングで colocated に切り替えた。

## 変更内容

- `.jj/repo/store/git/` にあった内部 git store を `.git/` に移し、jj とワーキングディレクトリで共有する形に統合。
- 以後、素の `git` コマンドが直接動作する。

## 実行コマンド

```sh
jj git colocation status                              # 事前確認(non-colocated と表示される)
cp -r .jj ~/dotfiles-jj-backup-$(date +%Y%m%d)        # 万一に備えてバックアップ
jj git colocation enable                              # 変換
jj git colocation status                              # 事後確認(colocated と表示される)
```

## 確認ポイント

- `jj git colocation status` が `Workspace is currently colocated with Git.` を返す
- `.git/` ディレクトリが workspace 直下に出現する
- `git status` が動作する(`@` が detached HEAD として見えるが、これは正常)

## colocated 化後の運用メモ

- jj の作業コピー `@` は bookmark に乗らないことが多いため、`git` 側からは detached HEAD に見える。jj 流の通常状態なので問題ない。
- 作業開始の典型パターン:

  ```sh
  jj new main
  # ファイル編集
  jj describe -m "feat: ..."
  jj bookmark create feat/xxx -r @
  jj git push --bookmark feat/xxx
  ```

- `gh pr create` で `-R` フラグが不要になる。
- `.jj/` 配下は git に含めない(jj が自動で gitignore を設定する)。

## ロールバック

```sh
jj git colocation disable
```

`.git/` を `.jj/repo/store/git/` に戻し、元の non-colocated 構成に復元される。

## 参考

- [Git compatibility - Jujutsu docs](https://docs.jj-vcs.dev/latest/git-compatibility/)
- [Discussion #4945: Converting a repo into a co-located repo](https://github.com/jj-vcs/jj/discussions/4945)
- 関連: PR #16(colocated 化直前の最後の push)
