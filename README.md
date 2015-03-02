概要
----

Sails.js/Node+MySQLのVagrantfileです。インストールされるソフトウェアは主に下記になります。詳しくは/vagrant/Vagrantfileと/vagrant/script.shを参照して下さい。

* CentOS
* Node
* MySQL
* Apache
* PHP
* phpMyAdmin

※ ApacheとPHPはphpMyAdminのためにインストールしています。

前提
----

* Gitをインストール済である事
* VirtualBoxおよびVagrantをインストール済である事

はじめに
----

リポジトリの内容は下記のようになっています。

```
vagrant-sails-mysql/
　├ README.md
　└ vagrant/
　   ├ Vagrantfile
　 　├ script.sh
　 　├ httpd.conf
　 　└ etc
```

vagrant upすると、ゲストOSの/shareにホストOSのvagrant-sails-mysqlフォルダがマウントされるので、ホストOSのvagrant-sails-mysql配下にアプリケーションのソースを配置して開発する事ができます。ホストOS（Mac・Windows）からお好みのテキストエディタとGitクライアントで開発を行ってください。Sailsの実行はゲストOSの/share以下から行います。

使い方
----

はじめにこのGitリポジトリをcloneします。

```
[ホストOSの操作]

$ git clone https://github.com/relationslab/vagrant-sails-mysql
```

次にMySQLの設定を行います。/vagrant/script.shに作成するユーザーとDBの情報を指定します。もしMySQL生成時にDDLを流したい場合はddl.sqlにDDLを記述してください。

準備が整ったらvagantフォルダに移動しvagrant upしてください。すると環境が生成されます。

```
[ホストOSの操作]

$ cd vagrant
$ vagrant up
```

環境が生成されるまでにしばらくかかります。環境が生成されたらSSHで接続します。

```
[ホストOSの操作]

$ vagrant ssh
```

次にSailsのアプリケーションのGitリポジトリを/share/配下にcloneしてください。sails newコマンドで新たに作成する事もできます。

ゲストOSの中でsails liftすると、ホストOSからは下記のURLでブラウザからアプリケーションの動作を確認することができます。phpMyAdminもインストール済になっています。

```
[ホストOSの操作]

http://192.168.33.40:1337/
http://192.168.33.40/phpMyAdmin/
```

次にこのGitリポジトリからAWSの環境にデプロイができるようにAWSDevToolsをセットアップします。

```
[ゲストOSの操作]

$ pwd
/share/<アプリケーションのGitリポジトリ>
$ sh ~/.aws/AWS-ElasticBeanstalk-CLI-2.5.1/AWSDevTools/Linux/AWSDevTools-RepositorySetup.sh 
```

下記のコマンドで、AWS Elastic Beanstalkの資格情報と環境情報を設定します。

```
[ゲストOSの操作]

$ git aws.config
```

aws.configで設定を行ったら、下記のコマンドでAWS Elastic Beanstalkの環境にアプリケーションをデプロイする事ができます。

```
[ゲストOSの操作]

$ git aws.push [--environment <environment_name>]
```

Vagrantの環境を停止する場合はホストOSの環境で/vagrantフォルダに移動し下記のコマンドを実行します。

```
[ホストOSの操作]

$ vagrant halt
```

