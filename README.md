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
