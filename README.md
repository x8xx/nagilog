# nagilog
## 概要

このリポジトリは、[mdbook](https://rust-lang.github.io/mdBook/)を使用してMarkdown形式の記事から静的サイトを生成し、GitHub Pagesで公開するブログシステムです。記事のメタデータを`nagilog.yml`で一元管理し、スクリプトによって自動的にナビゲーションやタグページを生成します。

## プロジェクト構成

```
.
├── book.toml              # mdbookの設定ファイル
├── nagilog.yml            # 記事とタグの定義ファイル
├── Makefile               # ビルド・デプロイコマンド
├── scripts/
│   └── regist_article.sh  # 記事登録スクリプト
├── src/                   # mdbookのソースディレクトリ
│   ├── SUMMARY.md         # 自動生成される目次
│   ├── all.md             # 自動生成される全記事一覧
│   ├── whoami.md          # プロフィールページ
│   ├── articles/          # 記事ファイル
│   ├── tags/              # タグページ（自動生成）
│   └── static/            # 静的ファイル
├── book/                  # mdbookによる生成物（ローカル用）
└── x8xx.github.io/        # GitHub Pages用サブモジュール（自動生成）
```

## 使い方

### 1. 新規記事の追加

#### 1.1 記事ファイルの作成

`src/articles/` ディレクトリに新しいMarkdownファイルを作成します。

```bash
# 例: YYYYMMDD.md の形式で作成
touch src/articles/20230316.md
```

#### 1.2 記事の登録

`nagilog.yml` に記事のメタデータを追加します。

```yaml
Articles:
  - date: 202303160000        # 記事の日付（YYYYMMDDhhmm形式）
    title: 記事のタイトル      # 記事のタイトル
    path: ./articles/20230316.md  # 記事ファイルのパス
    tags:                      # タグのリスト
      - "Rust"
      - "WASM"
```

#### 1.3 タグの定義（必要に応じて）

新しいタグを使用する場合は、`nagilog.yml`の`Tags`セクションに追加します。

```yaml
Tags:
  Rust: ./tags/rust.md
  WASM: ./tags/wasm.md
  # 新しいタグを追加
  Go: ./tags/go.md
```

### 2. ローカルでのプレビュー

#### 2.1 記事を登録してSUMMARY.mdを生成

```bash
make build
```

このコマンドは `scripts/regist_article.sh` を実行し、`nagilog.yml` の内容に基づいて以下のファイルを自動生成します：
- `src/SUMMARY.md` - mdbookの目次
- `src/all.md` - 全記事の一覧
- `src/tags/*.md` - 各タグごとの記事一覧

#### 2.2 ローカルサーバーの起動

```bash
make server
```

ブラウザで `http://localhost:3000` にアクセスしてプレビューを確認できます。

### 3. デプロイ

GitHub Pagesへデプロイします。

```bash
make deploy
```

このコマンドは以下の処理を実行します：
1. `mdbook build` でサイトをビルド
2. 生成されたファイルを `x8xx.github.io` サブモジュールに配置
3. `x8xx.github.io` リポジトリにコミット＆プッシュ
4. `nagilog` リポジトリにもコミット＆プッシュ

## 必要な環境

- [mdbook](https://rust-lang.github.io/mdBook/) - Rust製の静的サイトジェネレータ
- [yq](https://github.com/mikefarah/yq) - YAMLパーサー（記事登録スクリプトで使用）
- Bash - シェルスクリプトの実行環境

### インストール方法

```bash
# mdbookのインストール
cargo install mdbook

# yqのインストール（macOSの場合）
brew install yq
```

## ワークフロー

1. 新しい記事を `src/articles/` に作成
2. `nagilog.yml` に記事情報を追加
3. `make build` で記事を登録
4. `make server` でローカルプレビュー
5. 内容を確認後、`make deploy` でデプロイ

## ライセンス

このリポジトリのコードはMITライセンスの下で公開されています。記事の内容については別途著作権が適用される場合があります。
