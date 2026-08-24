# 概要
ポートフォリオサイトの、画像api練習用です

- rails
- ruby
- postgresql
- active storage


dockerを用いずにwindowsでUbuntu上での操作をしています。将来的に本番環境用にDockerを用いた運用へ移行予定。ラズパイで自宅サーバ運用をしたい

# 操作とか
Ubuntu起動→ cd image-app → code .　でvscode開く
なんか変になった時
docker compose restart backend

### Fat Controllerの回避と責務の分離
- コントローラーが肥大化しないよう、単一責任の原則を意識して処理を切り出しました。
   - Model: データ構造の変換や判定ロジックなど、データ自身の知識を集約

   - Service Object: 複数モデルの操作・外部連携（WebSocket配信等）を伴う業務ロジックを集約

   - Controller: リクエストの受け取りとレスポンス返却（交通整理）に専念


## 🛠 使用技術 (Tech Stack)

### 🎨 フロントエンド
- **フレームワーク:** Next.js (App Router) / React
- **言語:** TypeScript
- **リアルタイム通信:** `@rails/actioncable` (WebSocket クライアント)
- **スタイル:** CSS / Inline Styles

### ⚙️ バックエンド
- **フレームワーク:** Ruby on Rails (API モード)
- **言語:** Ruby
- **リアルタイム通信:** Action Cable (WebSocket)
- **ファイル管理:** Active Storage
- **データベース:** PostgreSQL (またはご利用のDB名)

### 🐳 開発環境・インフラ
- **コンテナ化:** Docker / Docker Compose

---

## ✨ 主な実装機能・アピールポイント

### 1. Action Cable (WebSocket) によるリアルタイムチャット
- **即時描画:** 画面のリロードを行わずに、他ユーザーの投稿（テキスト・画像・タグ）がリアルタイムに同期されます。
- **リソース管理:** Next.js の `useEffect` 内でチャンネルごとの WebSocket 接続 (Subscription) を管理し、チャンネル切り替え時や画面退場時には `unsubscribe()` および `disconnect()` を呼び出してメモリリークを防止しています。
- **重複描画防止:** POST リクエストのレスポンスと WebSocket ブロードキャストの双方を受け取った場合でも、メッセージ ID による検証を行い、画面に二重表示されないロジックを実装しています。

### 2. Active Storage と FormData を活用したマルチパート送信
- 画像ファイル添付・メッセージ本文・複数タグの送信に対応するため、`FormData` 形式による REST API 送信を組み込んでいます。
- バックエンド側の Active Storage で画像を保存・管理し、返却された画像 URL をフロントエンド側でプレビュー表示・リアルタイム配信します。

### 3. 型安全なコンポーネント設計
- TypeScript を用いて API レスポンスやコンポーネント間データの型定義 (`Channel`, `MessageItem`) を一元管理し、堅牢なフロントエンド開発を行っています。

### 工夫ポイント：メッセージに紐づいたtagの持ち方について
　当初、メッセージテーブルにそれぞれtagカラムを持つ設計だったが、じぇすどろツールへのtag受けわたしにおいて、tagテーブル、mssageTagsテーブルと分離し保存することにすることで、apiのロジックの簡略化に成功

---

## 🔄 システム構成・通信フロー

```mermaid
sequenceDiagram
    autonumber
    actor UserA as ユーザーA (Next.js)
    participant Rails as Rails API
    participant DB as DB / Active Storage
    actor UserB as ユーザーB (Next.js)

    UserA->>Rails: HTTP POST (FormData: テキスト, 画像, タグ)
    Rails->>DB: メッセージ保存 & 画像アップロード
    DB-->>Rails: 保存完了
    Rails-->>UserA: HTTP 200 (新規メッセージ JSON)
    Rails->>UserB: Action Cable (WebSocket) ブロードキャスト
    Note over UserB: 画面リロードなしで即時描画

# File Server Backend

個人用ファイルサーバのバックエンドAPI。

Discordのようなチャンネル・メッセージ形式でテキストや画像を管理し、
タグを利用した画像検索・ランダム取得などの機能を提供する。

フロントエンドにはNext.jsを使用し、本リポジトリではRails APIをバックエンドとして使用する。

---

## Overview

RailsをAPIサーバとして利用し、フロントエンドからHTTPリクエストを受け取り、
データベースやファイルストレージを操作してJSONを返す。

### 主な機能

- ユーザー管理
- チャンネル管理
- メッセージ管理
- メッセージへのタグ付け
- 画像ファイルのアップロード
- Active Storageによる画像管理
- タグからの画像検索
- 指定枚数のランダム画像取得
- JSON APIによるフロントエンドとの通信

---

## Architecture

```text
Next.js Frontend
       |
       | HTTP / JSON / FormData
       ↓
Rails API
       |
       ├── Controllers
       |      └── HTTP Request / Response
       |
       ├── Services
       |      └── Application Logic
       |
       ├── Models
       |      └── Data / Business Rules
       |
       ├── Active Storage
       |      └── Image File Management
       |
       ↓
PostgreSQL
```

### Frontend

Next.jsからRails APIへHTTPリクエストを送信する。

Railsから返されたJSONを利用して画面を構築する。

### Backend

Rails APIを使用。

ControllerでHTTPリクエストを受け取り、
必要に応じてServiceやModelを利用して処理を行い、
JSONレスポンスを返す。

### Database

PostgreSQLを使用。

ユーザー、チャンネル、メッセージなどの永続データを管理する。

### File Storage

画像ファイルの管理にはRailsのActive Storageを使用する。

画像そのものを`messages`テーブルに保存するのではなく、
Active StorageによってファイルとMessageを関連付ける。

---

## Tech Stack

### Backend

- Ruby
- Ruby on Rails
- Rails API Mode
- Active Record
- Active Storage
- Devise
- Devise JWT

### Database

- PostgreSQL

### Infrastructure / Development

- Docker
- Docker Compose
- Git / GitHub

### Frontend

- Next.js
- React
- TypeScript

---

## Directory Structure

```text
app/
├── controllers/
│   └── api/
│       └── v1/
│           ├── health_controller.rb
│           ├── image_controller.rb
│           ├── messages_controller.rb
│           └── ...
│
├── models/
│   ├── user.rb
│   ├── message.rb
│   ├── channel.rb
│   └── ...
│
└── services/
    └── image_search_service.rb

config/
├── routes.rb
├── database.yml
└── ...

db/
├── migrate/
└── schema.rb
```

---

# Database

主なテーブル：

- users
- channels
- messages

その他、Rails / Active Storageが利用するテーブルが存在する。

---

## Messages

`messages`テーブルでは、メッセージの内容や所属チャンネル、
メッセージタイプ、タグなどを管理する。

```text
messages

id
channel_id
user_id
content
message_type
tags
url
is_edited
created_at
updated_at
```

### tags

タグはPostgreSQLのJSONB型で配列として保存する。

例：

```json
[
  "眼鏡",
  "メカクレ"
]
```

現在は単一のMessageに複数タグを設定できる。

---

## Message Model

```ruby
class Message < ApplicationRecord
  belongs_to :channel
  belongs_to :user, optional: true

  has_one_attached :image

  validates :message_type, inclusion: { in: %w[text image] }
end
```

MessageにはActive Storageを利用した画像添付機能を持たせている。

---

# Active Storage

画像ファイルは`messages`テーブルに直接保存しない。

```ruby
has_one_attached :image
```

をMessageモデルに定義し、

```ruby
message.image.attach(file)
```

によって画像を添付する。

Active Storageは、

- 実際の画像ファイル
- ファイルのメタデータ
- Messageとの関連付け

を管理する。

そのため、`messages`テーブルに画像データそのものを保存する必要がない。

画像の存在確認には、

```ruby
message.image.attached?
```

を使用する。

---

# API

APIは`/api/v1`以下に配置する。

## Health Check

```http
GET /api/v1/health
```

APIサーバが正常に動作しているか確認するためのエンドポイント。

---

# Image Search API

タグを指定して、条件に一致する画像をランダムに取得する。

現在は1つのタグを指定する形式で実装予定。

## Request

```http
POST /api/v1/images/search
Content-Type: application/json
```

```json
{
  "tag": "眼鏡",
  "quantity": 5
}
```

### Parameters

| Parameter | Type | Description |
|---|---|---|
| `tag` | string | 検索対象のタグ |
| `quantity` | number | 最大取得枚数 |

## Processing

1. 指定されたタグを持つMessageを検索
2. 画像が添付されているMessageのみ抽出
3. 指定枚数を上限としてランダムに取得
4. Active Storageから画像URLを生成
5. JSONとして返却

該当する画像が指定枚数に満たない場合は、
取得可能な画像を最大数まで返す。

例えば10枚要求して該当画像が3枚しかない場合、

```json
{
  "images": [
    { "url": "..." },
    { "url": "..." },
    { "url": "..." }
  ]
}
```

のように3枚を返す。

---

# Tag API

フロントエンドのタグ選択UIで利用するため、
DB内に存在するタグ一覧を取得するAPIを実装予定。

```http
GET /api/v1/tags
```

Response:

```json
{
  "tags": [
    "眼鏡",
    "メカクレ",
    "猫"
  ]
}
```

現在タグはMessageのJSONBカラムに保存しているため、
Messageからタグを抽出して一覧を生成する。

---

# Service Object

複雑なアプリケーションロジックはServiceに分離する。

例：

```text
app/services/image_search_service.rb
```

## ImageSearchService

画像検索に必要な処理を担当する。

```text
tag
 ↓
Message検索
 ↓
画像付きMessageのみ抽出
 ↓
ランダム取得
 ↓
Controllerへ結果を返す
```

Serviceを利用することで、Controllerに大量の処理を記述することを避ける。

### Responsibility

#### Controller

- HTTPリクエストの受付
- paramsの取得
- Serviceの呼び出し
- JSONレスポンスの生成

#### Service

- アプリケーション固有の処理
- 複数のModelを組み合わせた処理
- 画像検索などのユースケース

#### Model

- データ自身に関するルール
- バリデーション
- Model同士の関連
- Model固有の処理

---

# Database Migration

DB構造の変更にはRailsのMigrationを使用する。

```bash
rails generate migration AddSomethingToMessages
```

MigrationファイルにDBの変更内容を記述し、

```bash
rails db:migrate
```

でデータベースへ反映する。

MigrationはDB構造の変更履歴として管理する。

例：

```ruby
class AddSomethingToMessages < ActiveRecord::Migration[8.1]
  def change
    add_column :messages, :something, :string
  end
end
```

既に実行済みのMigrationを直接編集するのではなく、
原則として新しいMigrationを追加してDB構造を変更する。

---

# Development

## Requirements

- Docker
- Docker Compose

---

## Start Development Environment

```bash
docker compose up
```

Rails API、PostgreSQLなどのコンテナを起動する。

---

## Run Rails Commands

Railsコンテナ内でコマンドを実行する。

```bash
docker compose exec web bundle exec rails console
```

Migration:

```bash
docker compose exec web bundle exec rails db:migrate
```

Routes:

```bash
docker compose exec web bundle exec rails routes
```

---

# Rails Console

Rails Consoleを利用してModelやActive Storageの動作を確認できる。

```bash
docker compose exec web bundle exec rails console
```

例：

```ruby
message = Message.find(42)
```

画像が添付されているか確認：

```ruby
message.image.attached?
```

Messageのタグを確認：

```ruby
message.tags
```

---

# Authentication

ユーザー認証にはDeviseを使用する。

API認証にはDevise JWTを利用し、
クライアントとRails API間の認証をJWTベースで行う。

---

# Design Policy

このプロジェクトでは、フロントエンドとバックエンドの責務を分離する。

### Frontend

- UI
- ユーザー操作
- フォーム入力
- 表示
- APIとの通信

### Backend

- 認証
- データ永続化
- DBアクセス
- データの整合性
- ファイル管理
- アプリケーションロジック
- APIレスポンス

クライアント側で実行するバリデーションだけに依存せず、
重要なデータの検証はバックエンドでも行う。

---

# Future Plans

- [ ] タグ一覧API
- [ ] タグによる画像検索API
- [ ] 複数タグ検索
- [ ] 画像URLのAPIレスポンス対応
- [ ] 画像検索条件の拡張
- [ ] ページネーション
- [ ] Active Storageの本番ストレージ設定
- [ ] APIドキュメント整備
- [ ] テストの追加
- [ ] 本番環境へのデプロイ
