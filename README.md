<img src="https://github.com/user-attachments/assets/a45cd8b6-e46e-4f9d-9d50-c1b1ec99830c" width="1000px" />

## サービスURL

https://astoryer.com/ja

## サービス概要

AStoryer は TRPG で作成したキャラクターの創作やセッションログの投稿が出来るサービスです。

## サービスコンセプト

### 背景

TRPG で遊んだユーザーの中には、自分の PC、あるいは一緒に遊んだユーザーのキャラクターに愛着が湧き創作をする層が一定数います。ニッチかも知れませんが、中には同人誌を作った方もいるほど熱狂的なユーザーもいます。<br>
しかしながら現在、TRPG において作成したキャラクター（以降は自 PC と呼びます）から創作した創作物を投稿できる専用のサービスがありません。<br>
オリジナル創作と呼ぶには自 PC の設定がシステムやシナリオに影響が大きく、二次創作と言うには創作物自体はオリジナル色が強く……一次創作から二次創作を行ったり来たりするような難しい立ち位置です。<br>
既存のサービスに投稿するにはネタバレ配慮が厳しい界隈です。ワンクッション挟むサービスなどでなんとか賄っているような、そんな状態です。<br>
こういった背景から「自 PC の創作物を投稿できる場所があったら」と考え、サービスを作ろうと思いました。

### 想定されるユーザー層

- TRPG で作成したキャラクターでイラストを書いている人

## 機能

★ がついているものはユーザー登録すると使える機能です。

|                                     トップページ                                     |                                    検索・検索結果                                    |
| :----------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------: |
| <img src="https://github.com/user-attachments/assets/ef92e093-c9e2-418e-9df3-407454d819da" width="300px" /> | <img src="https://github.com/user-attachments/assets/3f1b2c94-e47c-43ab-8a57-cb0973cba0f2" width="300px" /> |

|                                     イラスト詳細                                     |                                    ユーザーページ                                    |
| :----------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------: |
| <img src="https://github.com/user-attachments/assets/fd1e7171-0dcd-4aef-88f8-4a5dd01c9cd1" width="300px" /> | <img src="https://github.com/user-attachments/assets/511d94ae-0af5-499a-923f-eb2ca7a47448" width="300px" /> |

|                                  新規登録・ログイン                                  |                                    ★ イラスト投稿                                    |
| :----------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------: |
| <img src="https://i.gyazo.com/778363f57128fe1c4329f5d75d2d53ae.gif" width="300px" /> | <img src="https://github.com/user-attachments/assets/fef747d1-412a-44ef-a48d-b47155530be2" width="300px" /> |

|                               ★ イラスト編集（下書き）                               |                              ★ イラスト編集（公開済み）                              |
| :----------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------: |
| <img src="https://i.gyazo.com/4468931e1dc9a09cec52f23d608bea2a.gif" width="300px" /> | <img src="https://i.gyazo.com/1e01a32cddb5b064a15e484828869d90.gif" width="300px" /> |

|                                    ★ イラスト削除                                    |                               ★ フォロー・フォロー解除                               |
| :----------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------: |
| <img src="https://i.gyazo.com/4a7cdf393443c4cd4cb762a8667d76d1.gif" width="300px" /> | <img src="https://i.gyazo.com/bacfc9c60f4179cbd57ae2edcf39b466.gif" width="300px" /> |

|                                       ★ いいね                                       |                                    ★ ブックマーク                                    |
| :----------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------: |
| <img src="https://i.gyazo.com/02ecb2e3b2a685feca11103ef840f833.gif" width="300px" /> | <img src="https://i.gyazo.com/323adf0bef31c4d96a291e7b4a35bc7e.gif" width="300px" /> |

|                                      ★ コメント                                      |                                     ★ マイページ                                     |
| :----------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------: |
| <img src="https://i.gyazo.com/17e9fbd90ecac5493b231fceb8d29162.gif" width="300px" /> | <img src="https://github.com/user-attachments/assets/00e4cf61-9b78-4ab4-b23b-cec7c25d8200" width="300px" /> |

|                                   ★ アカウント設定                                   |                                        ★ 退会                                        |
| :----------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------: |
| <img src="https://i.gyazo.com/6904e85638a6e40de7bdb9cad606ce96.png" width="300px" /> | <img src="https://i.gyazo.com/0367be34da034cd9184669c6b7b56168.gif" width="300px" /> |

### 今後の実装予定

- テストコード
- ワンクッション機能
- 小説投稿機能
- 通知機能

### 技術スタック

| カテゴリー     | 技術スタック                                                                                          |
| -------------- | ----------------------------------------------------------------------------------------------------- |
| Frontend       | React ver.18,Next.js ver.14, TypeScript ver.20                                                        |
| Backend        | Ruby ver3.2.2, Ruby on Rails ver7.1.3 API モード                                                      |
| Infrastructure | Render.com, Vercel, AWS S3, AWS SES                                                                   |
| Database       | PostgreSQL                                                                                            |
| Monitoring     | Sentry                                                                                                |
| Environment    | Docker                                                                                                |
| CSS            | tailwind CSS                                                                                          |
| npm            | Mantine, Axios, Framer-Motion, next-intl, Recoil, rocketicons, SWR, ESLint                            |
| Gem            | annotate, RSpec, Factorybot, simplecov,<br/>DeviseTokenAuth, OmniAuth, GoogleAPIsSheetsV4, ActiveHash |

# 画面遷移図

画面遷移図は[こちら](https://www.figma.com/file/Z8BLQOGYOCx1tB3gs7YeM9/Astoryer-%E7%94%BB%E9%9D%A2%E9%81%B7%E7%A7%BB%E5%9B%B3?type=design&node-id=0%3A1&mode=design&t=N3XTulFLnkgiPiJh-1)

# ER 図

<img src="https://github.com/user-attachments/assets/9688d547-73ba-4415-9dc8-33b81a3d5392" width="500px" />
