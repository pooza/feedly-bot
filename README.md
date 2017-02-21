# Feedlyに新着記事がきたらメールするツール。

## 設置の手順

1. <https://feedly.com/v3/auth/dev> でアクセストークンを作成。  
取得したアクセストークンと期限日を控えておく。

1. サーバ上の適当な場所で、git cloneする。

    `git clone git@github.com:pooza/feedly_deliverer.git`

1. bundlerを実行。

    `bundler install`

1. 設定ファイルを、feedly_deliverer.yamlの名前で作成する。  
作成する場所は、git cloneしたリポジトリのディレクトリ内、 /usr/local/etc 、 /etc のいずれか。（この順位で読み込まれる）  
以下、設定ファイルの例。  
    ~~~
    mail_to: hoge@example.com #メールの宛先
    access_token:
      token: __YOUR_TOKEN__ #アクセストークン
      expires_on: 2017-03-23 #アクセストークンの期限日
    ~~~

1. リポジトリ内のfeedly_deliverer.rbを、cron等で実行。

## 今後の予定
1. 現状、1通のメールに未読記事全てを列挙しているが、未読記事毎に別々のメールを送るようにしたい。
1. Feedlyの登録状況に合わせてGmailにタグとフィルタを登録し、未読記事のメールが適切に振り分けられるようにしたい。
