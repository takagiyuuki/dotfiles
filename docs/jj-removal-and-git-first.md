# jj を外して git 単独運用へ(git 学習フェーズ)

`docs/jj-noncolocated-to-colocated.md` と対になるメモ。colocated 構成から jj を外し、
git 単独で運用する手順と、その判断の記録。

## 背景 / 判断

- git の基礎(staging / HEAD / refs / reflog / rebase)を習得する前に jj に進んでしまった。
  いったん git に立ち戻り、Git ベースの開発フローを一通りできるようにする。
- jj は staging や HEAD を意図的に隠すため、git 学習中は並行モデルがノイズになる。
  `.jj` を外すと git の HEAD / index / reflog が「git の真実そのもの」になり学びやすい。
- 再導入は `jj git init --colocate` で数秒・非破壊。今外すコストは低く、いつでも戻せる。

## 外し方(colocated → git 単独)

colocated では `.git` が本体で `.jj` はオーバーレイなので、`.jj` を消せば通常の git repo に戻る。

1. 事前確認: 作業ツリーがクリーンで main が最新であること。
   jj にしか無いコミットが無いかを git 側で確認する。
   ```sh
   git status -sb
   git log --oneline --graph --all -10
   ```
   jj の作業コピー用コミット(メッセージ空のコミットが main の上に乗る)は
   どのブランチにも属さないので、削除後に参照が外れて gc される。中身が空なら実害なし。

2. jj オーバーレイを削除:
   ```sh
   rm -rf .jj
   ```

3. jj が入れた gitignore エントリの掃除(今回は無し):
   ```sh
   grep -n "\.jj" .gitignore .git/info/exclude 2>/dev/null
   # 見つかった .jj 行があれば削除
   ```

## Starship プロンプト

`jj-starship`(Git/JJ 統合モジュール, `custom.jj`)を単独の VCS 表示として使う。

- format から `git_branch` / `git_commit` / `git_status` を外す(jj-starship と二重化するため)。
- `git_state`(rebase/merge 進行中の表示)/ `git_metrics`(増減行数)は jj-starship が
  出さないので残す。
- jj-starship は `.jj` の有無で Git ビュー / JJ ビューを自動切替する。
  よって `.jj` を消せば Git ビュー、将来 colocated に戻せば JJ ビューになり、
  **starship の再設定は不要**。

`jj-starship` の Git ステータス記号(実測): `+` staged / `!` modified / `?` untracked /
`⇡`/`⇣` ahead/behind / `(hash)` commit id。ステージング領域も区別するため git 学習でも十分。

## 将来 jj に戻すとき

1. 対象 repo で colocated 化:
   ```sh
   jj git init --colocate
   ```
2. starship は統合構成のままなら再設定不要(JJ ビューに自動で切り替わる)。
   colocated で「git を優先して jj を隠したい」場合のみ、`custom.jj` の `when` を
   `jj-starship detect && ! git rev-parse --is-inside-work-tree >/dev/null 2>&1` に
   ゲートしてネイティブ `git_*` を復活させる。
3. 参照: `docs/jj-noncolocated-to-colocated.md`
