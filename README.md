## 配置完整Rails空项目

配置完整Rails空项目.

### System dependencies

* Ruby 2.2.0-p0
* Postgres
* Rails 4.2.4
* Nginx + Unicorn
* Faye
* Linux or vagrant for mac
* Sidekiq
* Redis
* Grape

### Configuration
```
  $ cp config/database.example.yml config/database.yml
```

### How to run the test suite
```
  $ rspec spec
```

## 如何运行该项目，有两种方案

### 方案一：本地安装所有以上的依赖环境，然后运行以下相关命令

```shell
  $ bundle install
  $ rake db:create
  $ rake db:migrate
  $ rake db:seed
  $ rails s
```

### 方案二：使用Vagrant

> 提供的Vagrant镜像包已经包含系统所有依赖的环境，只需本地加载这个镜像包，项目就可以启动运行了。
 目前镜像已经存在的用户有vagrant 和 deploy 密码同用户名

#### 初始化Vagrant镜像

```shell
  $ mkdir -p ~/workspace/source && cd ~/workspace
  $ vagrant box add 36kr ubuntu_tls_ruby_mongo_postgre_memcached_redis_nginx_node_els_img_faye_sidekiq_36kr_v3.box
  $ vagrant init 36kr
```

 修改Vagrantfile文件
```shell
  # 开启vagrant与host的端口映射
  $ config.vm.network "forwarded_port", guest: 3000, host: 3000
  # 开启目录映射
  $ config.vm.synced_folder "~/workspace/source/36krx2015", "/vagrant_data"
```

#### 启动Vagrant

```shell
  $ vagrant up
```

## Deployment instructions

使用Capistrano3 进行

#### 如果是初次部署:

* 产品环境
```shell
  $ bundle exec cap production deploy:create_database
  $ bundle exec cap production deploy
  $ bundle exec cap production deploy:rake_seed
  $ bundle exec cap production run_faye
```
* 开发环境
```shell
  $ bundle exec cap development deploy:create_database
  $ bundle exec cap development deploy
  $ bundle exec cap development deploy:rake_seed
  $ bundle exec cap development run_faye
```
* Vagrant环境
```shell
  $ bundle exec cap vagrant deploy:create_database
  $ bundle exec cap vagrant deploy
  $ bundle exec cap vagrant deploy:rake_seed
  $ bundle exec cap vagrant run_faye
```

#### 如果不是第一次运行以下命令即可:

* 产品环境
```shell
  ruby bundle exec cap production deploy
```
* 开发环境
```shell
  ruby bundle exec cap development deploy
```
## 其他

### API 文档

在浏览器里打开
```shell
  http://localhost:3000/api/doc
```
### Sidekiq Web 监控

在本地项目根目录
```shell
  $ bundle exec sidekiq
```
然后在浏览器访问
```shell
  http://localhost:3000/sidekiq
```
### Redis Web 监控

在本地项目根目录
```shell
  $ redis-stat --server
  $ redis-stat --verbose --server=8080 5

  # redis-stat server can be daemonized
  $ redis-stat --server --daemon

  # Kill the daemon
  $ killall -9 redis-stat-daemon
```
然后在浏览器访问
```shell
  http://localhost:8080/sidekiq
```

### NewRelic 本地监控

然后在浏览器访问
```shell
  http://localhost:3000/newrelic
```
