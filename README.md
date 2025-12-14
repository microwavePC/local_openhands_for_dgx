# ローカル稼働型コーディング支援システム

## 使用前の環境準備

1. Docker関連の必要なツール類がインストール済みであることを確認する。

    ```bash
    # 以下のどちらを実行してもバージョン番号が表示される（＝使える状態となっている）必要がある。
    docker -v
    docker buildx version
    ```

## 使用方法

1. このリポジトリを、DGX Spark上の任意のディレクトリにcloneする。

1. cloneしたこのリポジトリのルートディレクトリで、以下のコマンドを実行する。

    ```bash
    # shコマンドでは代用不可なので注意！
    bash ./setup-openhands.sh
    ```

1. DGX Spark上のWebブラウザで [http://localhost:3000](http://localhost:3000) を開く。

1. Web画面上に表示されるダイアログ上で以下の通りに入力・選択し、「Save」をクリックする。

    | 項目名 | 設定する値 | 備考 |
    | --- | --- | --- |
    | LLM Provider | OpenAI | 後続作業で適切なものに変えるので実質何でも良いが、とりあえずこれを選択する。 |
    | LLM Model | 何でもOK | 〃 |
    | API Key | dummy-key | 〃 |

   ブラウザ上でパスワード保存の要否を確認されたら、不要なので「No」をクリックする。

1. 「Your Privacy Preferences」というダイアログが表示されたら、「Send anonymous usage data」のチェックボックスをオフにし、「Confirm Preferences」をクリックする。

1. 画面上の「Open Repository」という領域にある「Settings」をクリックする。

1. Settings画面左側のメニューにある「LLM」をクリックし、以下の通りに設定し、「Save Changes」をクリックする。

    | 項目名 | 設定する値 | 備考 |
    | --- | --- | --- |
    | Advanced | ONにする |  |
    | Custom Model | devstral-small-2505 |  |
    | Base URL | http://llama-server:8080/v1 |  |
    | API Key | dummy-key | 実質的には任意の文字列で問題ない。 |
    | Search API Key (Tavily) | デフォルト値 | Tavilyを使ったWeb検索機能を使用する場合に必要となる。 |
    | Agent | デフォルト値 | OpenHandsの挙動テンプレート。 |
    | Memory condenser max history size | デフォルト値 | 要約を挿入するまでに溜めるイベント数。 |
    | Enable memory condensation | デフォルト値 |  |
    | Enable Confirmation Mode | デフォルト値 |  |

1. メイン画面に戻り、画面上の「Start from scratch」という領域にある「New Conversation」をクリックする。すると、初回起動時は内部処理でruntimeコンテナのビルドが実行され始め、およそ10分を要するので、これが完了し操作可能となるまで待機する。

## TODO: 残タスク

- [ ] LLM接続の確実化＆自動化（setup-openhands.shを実行するだけでllama-serverのLLMと接続されるようにしたい）
- [ ] とりあえず「チャット中心のコーディング支援」が動くようにする
- [ ] 運用形態の切り替え（チャット中心 ↔ リポジトリ実行型）に合わせたsandbox設計
