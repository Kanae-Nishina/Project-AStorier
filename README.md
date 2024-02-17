# AStoryer - あすとりや -

## サービス概要
AStoryerはTRPGで作成したキャラクターの創作やセッションログの投稿が出来るサービスです。

## サービスコンセプト
### 背景
TRPGで遊んだユーザーの中には、自分のPC、あるいは一緒に遊んだユーザーのキャラクターに愛着が湧き創作をする層が一定数います。ニッチかも知れませんが、中には同人誌を作った方もいるほど熱狂的なユーザーもいます。<br>
しかしながら現在、TRPGにおいて作成したキャラクター（以降は自PCと呼びます）から創作した創作物を投稿できる専用のサービスがありません。<br>
オリジナル小説と呼ぶには自PCの設定がシステムやシナリオに影響が大きく、二次創作と言うには創作物自体はオリジナル色が強く……一次創作から二次創作を行ったり来たりするような難しい立ち位置です。<br>
既存のサービスに投稿するにはネタバレ配慮が厳しい界隈です。ワンクッション挟むサービスなどでなんとか賄っているような、そんな状態です。<br>
こういった背景から「自PCの創作物を投稿できる場所があったら」と考え、サービスを作ろうと思いました。<br>
また、オンラインセッションが盛んな時代ですので、そのセッションログの保存もこのサービスでできたら
セッションの振り返りがより楽しくなるのではと考えています。

### 想定されるユーザー層
- TRPGで作成したキャラクターでイラスト・小説を書いている人
- TRPGでのセッションログを見やすくきれいな形で残しておきたい人

## 実装を予定している機能
### MVP
- ユーザー登録
  - メール・パスワード
  - ゲストログイン
- 連携
  - Xとの連携<br>
  （Xアカウント削除によるログイン出来ない問題を防ぐために会員登録では使用しない）
- アカウント
  - アイコン
  - プロフィール
- 小説
  - 一覧
  - 投稿（タグ付けにてオートコンプリート）
  - 編集
  - 削除
  - 検索（マルチ検索・オートコンプリート）
- イラスト
  - 一覧
  - 投稿（タグ付けにてオートコンプリート）
  - 編集※画像の差し替えではなくキャプションの編集のみ
  - 削除
  - 検索（マルチ検索・オートコンプリート）
- ハッシュタグ
  - 任意のタグ
  - シナリオ名
  - TRPGのシステム設定
- いいね
- コメント
- ブックマーク
- フォロー機能
- 公開範囲の設定
  - 全体公開（未ログイン可）
  - URLを知っている人のみ（未ログイン可）
  - フォロワー
  - Xのフォロワー
- 通知
  - メールアドレス宛
- Xシェア機能

### 本リリース
- ユーザー登録
  - Googleアカウント
- DM（チャット機能）
- ユーザーのリスト機能
- 公開範囲の設定
  - 相互フォロワー
  - リスト内
- 公開日時の設定
- 通知
  - LINE通知
- ココフォリアセッションログ保存
  - セッションログを読み込み・保存
  - ログの体裁を整えた表示

### 技術スタック
以下予定している技術スタックです。
| カテゴリー | 技術スタック |
| ---- | ---- |
| Frontend | Next.js, TypeScript |
| Backend | Ruby on Rails |
| Infrastructure | Render.com, Vercel, AWS S3 |
| Database | PostgreSQL |
| Monitoring | [Sentry](https://sentry.io/welcome/) |
| Environment | Docker |
| CSS | tailwind CSS |
| other | [stimulus-autocomplete](https://github.com/afcapel/stimulus-autocomplete), [bcdice-api](https://github.com/bcdice/bcdice-api), WebSocket |