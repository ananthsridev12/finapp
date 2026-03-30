<?php
header('X-LiteSpeed-Purge: *');
header('X-LiteSpeed-Cache-Control: no-cache');
echo 'Cache purged. Delete this file after use.';
