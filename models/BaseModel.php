<?php

namespace Models;

use Config\Database;
use PDO;

class BaseModel
{
    protected PDO $db;
    protected Database $database;
    protected int $userId;

    public function __construct(Database $database, int $userId = 0)
    {
        $this->database = $database;
        $this->db       = $database->connect();
        $this->userId   = $userId;
    }
}
