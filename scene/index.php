<?php

namespace Scene;

define('APP_PATH', realpath('..'));

$debug = new \Scene\Debug();
$debug->listen();

//$di = new \Scene\Di();

//$filter = new \Scene\Filter();
//echo $filter->sanitize("some(one)@exa\\mple.com", "email"); // returns "someone@example.com"
//echo $filter->sanitize("hello<<", "string"); // returns "hello"
//echo $filter->sanitize("!100a019", "int"); // returns "100019"
//echo $filter->sanitize("!100a019.01a", "float"); // returns "100019.01"

//$crypt = new \Scene\Crypt();

//$key = 'le passwordaaaaa';
//$text = 'This is a secret text';

//echo $encrypted = $crypt->encrypt($text, $key);

//echo $crypt->decrypt($encrypted, $key);

//$crypt2 = new \Scene\Crypt();
//$key2 = 'aaaaaaaaaaaaaaaa';
//echo $decryptBase64 = $crypt2->encryptBase64($text, $key2);
//echo $crypt2->decryptBase64($decryptBase64, $key2);

//echo \Scene\Text::camelize('coco_bongo____----'); //CocoBongo
//echo \Scene\Text::uncamelize('CocoBongo'); //coco_bongo

//echo \Scene\Text::increment("a"); // "a_1"
//echo \Scene\Text::increment("a_1"); // "a_2"

//echo \Scene\Text::random(\Scene\Text::RANDOM_ALNUM); //"aloiwkqz"

//echo \Scene\Text::startsWith("Hello", "He"); // true
//echo \Scene\Text::startsWith("Hello", "he", false); // false
//echo \Scene\Text::startsWith("Hello", "he"); // true

//echo \Scene\Text::endsWith("Hello", "llo"); // true
//echo \Scene\Text::endsWith("Hello", "LLO", false); // false
//echo \Scene\Text::endsWith("Hello", "LLO"); // true

//echo \Scene\Text::lower("HELLO"); // hello

//echo \Scene\Text::upper("hello"); // HELLO

//echo \Scene\Text::reduceSlashes("foo//bar/baz"); // foo/bar/baz
//echo \Scene\Text::reduceSlashes("http://foo.bar///baz/buz"); // http://foo.bar/baz/buz

//$str = \Scene\Text::concat("/", "/tmp/", "/folder_1/", "/folder_2", "folder_3/");
//echo $str; // /tmp/folder_1/folder_2/folder_3/

/*
$loader = new \Scene\Loader();

// Register some classes
$loader->registerClasses(
    array(
        "Say"         => APP_PATH . '/apps/Say.php',
    )
);

// Register autoloader
$loader->register();

$say = new \Say();
$say->sayHello();
*/

$request = new \Scene\Http\Request();
/*
if ($request->hasFiles()) {
    //Print the real file names and their sizes
    foreach ($request->getUploadedFiles() as $file){
        echo $file->getName(), " ", $file->getSize(), "\n";
    }
}
*/
var_dump($request->getHttpHost());
