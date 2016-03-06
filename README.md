Scene Framework
===============

Scene 是一个开源、全栈、松耦合的、使用 Zephir/PHP 编写的高性能 PHP 框架，并同时发布 C扩展和PHP两个版本。两个版本除了实现方式不同以外，没有其他差异，您可以在没有管理员权限、开发测试环境和对性能要求不高的情况下使用PHP版本，生产环境下想要获得更高的性能，您可以使用C扩展。

#开始
##要求
尽管Scene可以在 PHP 5.4 下运行，但不保证能够正常使用全部功能，因为使用了一些 PHP 5.5 新增的特性和函数，因此推荐使用 PHP 5.5, PHP 5.6, PHP 7.0。  

由于此版本依赖于zephir, 但zephir不支持windows, 因此要在window下使用scene, 请看另一个版本[scene-php](https://github.com/dangcheng/scene-php/)。  

此外，还必须满足以下条件，以编译PHP扩展：  
* g++ >= 4.4/clang++ >= 3.x/vc++ 9
* gnu make 3.81 or later
* php development headers and tools  

##安装

```
$ sudo apt-get update
$ sudo apt-get install git gcc make re2c php5 php5-json php5-dev libpcre3-dev
$ git clone https://github.com/dangcheng/zephir
$ cd zephir
$ ./install -c
$ zephir help
```
如果以上步骤都没错, 这时候应该可以看到 zephir 的帮助信息了。  

同理，要在PHP 7.0 下安装，需要安装 php7.0, php7.0-json, php7.0-dev。  

此外，scene 还依赖其他扩展, 请先安装它们, 如果没有安装，会在稍后的编译中抛出警告。

```
$ sudo apt-get install php5-mcrypt
$ sudo apt-get install php5-curl
```
如果需要使用数据库，还需要
```
$ sudo apt-get install php-pear php5-dev
$ sudo pecl install mongodb
```
如果需要使用自带的图片处理
```
$ sudo apt-get install php5-imagick
or
$ sudo apt-get install php5-gd
```
如果要在PHP 7.0 下使用 imagick
```
$ sudo apt-get install imagemagick
$ sudo apt-get install libmagick-dev
$ sudo apt-get install libmagickwand-dev libmagickcore-dev

$ wget http://pecl.php.net/get/imagick-3.4.0RC6.tgz
$ tar xzvf imagick-3.4.0RC6.tgz
$ cd imagick-3.4.0RC6

$　phpize
$ ./configure
$ make
$ make install
```
接着

```
$ git clone http://github.com/dangcheng/scene.git
$ cd scene
$ zephir build
```
然后将 “extension=scene.so” 添加到 php.ini 文件中。你应该可以在 phpinfo() 验证安装是否成功。到此为止, scene 已经安装完成了。  

##使用  
新建一个 php 文件，输入
```php
<?php
$app = new \Scene\Mvc\Micro();

$app->get('/', function() {
  echo 'Hello world !';
});

$app->handle();
```
这时候，你在浏览器中应该可以看到 "Hello world !", 就是这么简单。  

更多的使用说明，会继续补充。

License
=======
Scene 基于MIT开源协议。
