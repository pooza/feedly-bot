# feedly-bot

Feedlyの新着エントリーをSlackに喋らせる。

## ■設置の手順

- 常時起動のUNIX系サーバでさえあれば、どこでも設置可。

### リポジトリをクローン

```
git clone git@github.com:pooza/feedly-bot.git
```
クローンを行うとローカルにリポジトリが作成されるが、このディレクトリの名前は
変更しないことを推奨。（syslogのプログラム名や、設定ファイルのパス等に影響）

### 依存するgemのインストール

```
cd feedly-bot
bundle install
```

### local.yamlを編集

```
vi config/local.yaml
```

以下、設定例。

```
access_token:
  token: __YOUR_TOKEN__ #アクセストークン
  expires_on: 2017-03-23 #アクセストークンの期限日
slack:
  hook:
    url: https://hooks.slack.com/services/*********/*********/************************
```

アクセストークンの期限が近くなると、その旨もSlackで通知される。

### syslog設定

feedlrというプログラム名で、syslogに出力している。  
以下、rsyslogでの設定例。

```
:programname, isequal, "feedlr" -/var/log/feedlr.log
```

## ■操作

loader.rbを実行する。root権限不要。  
cronで60分毎等で起動。

## ■設定ファイルの検索順

local.yamlは、上記設置例ではconfigディレクトリ内に置いているが、
実際には以下の順に検索している。（ROOT_DIRは設置先）

- /usr/local/etc/feedly-bot/local.yaml
- /usr/local/etc/feedly-bot/local.yml
- /etc/feedly-bot/local.yaml
- /etc/feedly-bot/local.yml
- __ROOT_DIR__/config/local.yaml
- __ROOT_DIR__/config/local.yml
