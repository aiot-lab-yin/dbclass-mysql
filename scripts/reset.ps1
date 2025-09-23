services:
  db:
    image: mysql:8.4
    restart: unless-stopped
    environment:
      - TZ=Asia/Tokyo
      - MYSQL_ROOT_PASSWORD=root
      - MYSQL_DATABASE=sampledb
      - MYSQL_USER=student
      - MYSQL_PASSWORD=student

    command:
      - --character-set-server=utf8mb4
      - --collation-server=utf8mb4_0900_ai_ci

    ports:
      - "13306:3306"
    volumes:
      - ./db_data:/var/lib/mysql
      - ./init:/docker-entrypoint-initdb.d

    # ✅ healthcheck 追加（引数リストで安全に）
    healthcheck:
      test:
        - CMD
        - mysqladmin
        - ping
        - --protocol=TCP
        - -h
        - 127.0.0.1
        - -uroot
        - -proot
      interval: 5s
      timeout: 5s
      retries: 20
      start_period: 60s

  # -------------------------------------------------------
  # Adminer（ブラウザからDB操作ができる簡易GUIツール）
  # - DBeaver がインストールできない／うまく動かない学生向けの代替手段
  # - ブラウザだけで MySQL の内容を確認・操作できる
  #
  # 使い方:
  #   1) 下の adminer: セクションのコメントを外す
  #   2) `docker compose up -d` で起動
  #   3) ブラウザで http://localhost:18080 にアクセス
  #   4) ログイン画面で以下を入力
  #        - System: MySQL
  #        - Server: db   （つながらなければ localhost）
  #        - Username: student
  #        - Password: student
  #        - Database: sampledb
  #   → SQL実行・テーブル確認・データ追加などが可能
  # -------------------------------------------------------
  adminer:
    image: adminer:latest
    restart: unless-stopped
    ports:
      - "18080:8080"
    depends_on:
      db:
        condition: service_healthy
