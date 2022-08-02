<?php

use Dotenv\Dotenv;
use Core\BootSystem;

require(__DIR__."/../vendor/autoload.php");

try {

    $dotenv = Dotenv::createMutable(__DIR__."/../");
    $dotenv->load();

    BootSystem::execute();

} catch(\Exception $exception) {

    echo "<pre>";
    print_r($exception);
    echo "</pre>";

}