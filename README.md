# データベース授業用 MySQL スターター（bind mount版）

- **データはこのフォルダ直下の `db_data/` に保存**されます（Docker の named volume ではなく bind mount を使用）。  
- GUI クライアントを使いたい場合は **Adminer** を利用できます（デフォルトはコメントアウト）。  
- ホスト側ポートは **13306**（ローカルの 3306 と衝突しにくい設定）。  

---

## 事前準備：Docker のインストール

授業では **Docker Desktop**（Windows / macOS）または **Docker Engine**（Linux）を使用します。

---

### 🪟 Windows

1. [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/) をダウンロードしてインストール  
2. インストール後に再起動  

#### ✅ PowerShell 7 の推奨設定

PowerShell 5.x を使用していると、文字化けやスクリプト実行エラーが発生することがあります。  
**PowerShell 7 以降へのアップグレードを強く推奨します。**

##### 🔍 現在のバージョンを確認
```powershell
$PSVersionTable.PSVersion
```

##### ⚙️ バージョンが 7 未満の場合（例：5.x）

以下のいずれかの方法で PowerShell 7 をインストールしてください。  
詳細手順は Microsoft 公式ドキュメントに記載されています：  
👉 [PowerShell のインストール (Windows) - Microsoft Learn](https://learn.microsoft.com/ja-jp/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.5)

---

**方法 1：Microsoft Store（最も簡単）**
1. 「Microsoft Store」を開く  
2. 検索バーで **“PowerShell 7”** と入力  
3. 「入手」ボタンをクリックしてインストール  
4. インストール後、スタートメニューから「PowerShell 7」を起動（または `pwsh` と入力）

---

**方法 2：公式インストーラを使う**
1. Microsoft 公式ページにアクセス  
   👉 [https://aka.ms/powershell](https://aka.ms/powershell)
2. 最新の **PowerShell-7.x.x-win-x64.msi** をダウンロード  
3. インストーラを実行し、以下の設定を確認：
   - ✅ 「Add to PATH（環境変数に追加）」を有効化  
   - ✅ 「Enable PowerShell remoting」を有効化（任意）  
4. インストール完了後、「PowerShell 7」または `pwsh` で起動

---

**💡 スクリプト実行時の注意**
必ず **PowerShell 7（pwsh）で管理者権限** を使用して実行してください。

```powershell
pwsh ./scripts/start.ps1
```

またはスタートメニューから「PowerShell 7」を右クリック →  
「管理者として実行」を選択。

---

3. PowerShell で以下を実行し、バージョンが表示されればOK
```powershell
docker --version
docker compose version
```

---

### 🍎 macOS
1. [Docker Desktop for Mac](https://www.docker.com/products/docker-desktop/) をダウンロードしてインストール  
   - Apple Silicon(M1/M2) の場合は「Mac with Apple chip」を選択  
   - Intel Mac の場合は「Mac with Intel chip」を選択  
2. インストール後に再起動  
3. ターミナルで以下を実行し、バージョンが表示されればOK
```bash
docker --version
docker compose version
```

---

### 🐧 Linux (Ubuntu 例)
1. 必要なパッケージをインストール
```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release
```
2. Docker の公式 GPG キーを登録
```bash
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```
3. リポジトリを追加
```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
4. Docker Engine と Compose をインストール
```bash
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
5. インストール確認
```bash
docker --version
docker compose version
```
6. （任意）sudo なしで使えるようにする
```bash
sudo usermod -aG docker $USER
newgrp docker
```

---

## 🚀 起動方法（学生向け）

1. **Docker Desktop** を起動（Linux の場合はサービスが動いていることを確認）  
2. このフォルダを開き、以下のいずれかを実行：  
   - macOS / Linux:  
     ```bash
     ./scripts/start.sh
     ```
   - Windows (PowerShell):  
     👉 **必ず「管理者権限」で PowerShell を開いて実行してください**  
     ```powershell
     .\scripts\start.ps1
     ```
3. MySQL に接続（共通設定）：  
   - Host: `localhost`  
   - Port: `13306`  
   - Database: `sampledb`  
   - User: `student`  
   - Password: `student`

---

## 💻 MySQL クライアントでの利用例

```bash
# コンテナに入って mysql クライアントを使う
docker compose exec db mysql -ustudent -pstudent sampledb

# 例: テーブル一覧を確認
SHOW TABLES;

# 例: データを確認
SELECT * FROM students;
```

---

## 🧭 Adminer（ブラウザGUI）を使いたい場合

- `docker-compose.yml` の **adminer セクションのコメントを外す**  
- 起動:  
  ```bash
  docker compose up -d
  ```
- ブラウザでアクセス: **http://localhost:18080**  
- ログイン情報は上記と同じ（user=`student` / password=`student` / db=`sampledb`）

---

## 🧹 停止・再開・リセット

- 停止：  
  - macOS / Linux:  
    ```bash
    ./scripts/stop.sh
    ```
  - Windows:  
    👉 **必ず「管理者権限」で PowerShell を開いて実行してください**  
    ```powershell
    .\scripts\stop.ps1
    ```

- 再開：  
  - macOS / Linux:  
    ```bash
    ./scripts/start.sh
    ```
  - Windows:  
    ```powershell
    .\scripts\start.ps1
    ```

- **リセット（完全初期化）**：  
  - macOS / Linux:  
    ```bash
    ./scripts/reset.sh
    ```
  - Windows:  
    ```powershell
    .\scripts\reset.ps1
    ```
  - 実行前に **確認プロンプト** が表示され、`db_data/` 内のデータが削除されることが明示されます。  

> 通常の停止/再開ではデータは保持されます。**リセット時のみデータが消えます。**

---

## 🧩 トラブルシュート

- **接続できない / Port が違う場合**：
  ```bash
  docker ps --format 'table {{.Names}}\t{{.Ports}}\t{{.Status}}'
  ```
  `13306->3306` が表示されているか確認。異なる場合は接続設定を合わせる。

- **初回初期化に失敗した**：
  ```bash
  ./scripts/reset.sh
  ```
  （確認の上、`db_data` を削除して再初期化）

- **Apple Silicon で不安定**：  
  - `docker-compose.yml` の `platform: linux/arm64/v8` を有効化。

- **ログを見る**：
  ```bash
  docker compose logs -f db
  ```

---

## 📁 フォルダ構成

- `docker-compose.yml`：MySQL 本体 + Adminer（コメントアウト済み）  
- `init/00_schema.sql`, `init/01_seed.sql`：**初回のみ** 自動実行される初期スクリプト  
- `db_data/`：MySQL の実データ（配布時は空フォルダでOK）  
- `scripts/`：起動・停止・リセット（確認プロンプト付き）  
