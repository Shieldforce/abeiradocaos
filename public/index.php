<?php

use App\BootSystem;

require(__DIR__."/../vendor/autoload.php");

try {
    BootSystem::execute();
} catch(\Exception $exception) {
    echo "<pre>";
    print_r($exception);
    echo "</pre>";
}