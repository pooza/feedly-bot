# feedly-bot

Feedlyの新着エントリーをSlackに喋らせる。

## ■設置の手順

- 常時起動のUNIX系サーバでさえあれば、どこでも設置可。

### リポジトリをクローン

```
git clone git@github.com:pooza/feedly-bot.git
```

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

### syslog設定

feedly-botというプログラム名で、syslogに出力している。  
必要に応じて、適宜設定。以下、rsyslogでの設定例。

```
:programname, isequal, "feedly-bot" -/var/log/feedly-bot.log
```

## ■操作

loader.rbを実行する。root権限不要。  
cronで60分毎等で起動。
