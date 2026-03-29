<?php
if (!function_exists('formatCurrency')) {
    function formatCurrency($value): string
    {
        return '&#8377; ' . number_format((float) $value, 2);
    }
}

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>FinApp — Personal Finance</title>

    <!-- Favicon -->
    <link rel="icon" href="public/icons/icon.svg" type="image/svg+xml">

    <!-- PWA -->
    <link rel="manifest" href="public/manifest.json">
    <meta name="theme-color" content="#0f1a2e">
    <meta name="mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <meta name="apple-mobile-web-app-title" content="FinApp">
    <link rel="apple-touch-icon" href="public/icons/icon.svg">

    <link rel="stylesheet" href="public/css/style.css?v=<?= filemtime(__DIR__ . '/../public/css/style.css') ?>">
    <script>(function(){var f=localStorage.getItem('em-font');if(f&&f!=='normal')document.documentElement.setAttribute('data-font',f);})();</script>
    <style>
    .finapp-user-bar{display:flex;align-items:center;gap:.6rem;padding:.45rem .9rem;background:#0f1a2e;border-bottom:1px solid rgba(120,150,210,.1);font-size:.78rem;color:#7a94c4;position:sticky;top:0;z-index:100;}
    .finapp-user-bar .user-name{font-weight:600;color:#b8ccf4;}
    .finapp-user-bar a.logout-btn{margin-left:auto;color:#f43f5e;text-decoration:none;font-size:.75rem;border:1px solid rgba(244,63,94,.3);padding:.2rem .6rem;border-radius:6px;}
    .finapp-user-bar a.logout-btn:hover{background:rgba(244,63,94,.1);}
    </style>
</head>
<body>
    <?php if (!empty($currentUser)): ?>
    <div class="finapp-user-bar">
        <span>Signed in as</span>
        <span class="user-name"><?= htmlspecialchars($currentUser['name'] ?? '') ?></span>
        <a href="?action=logout" class="logout-btn">Sign Out</a>
    </div>
    <?php endif; ?>
    <?= $content ?? '' ?>
    <script src="public/js/main.js?v=<?= filemtime(__DIR__ . '/../public/js/main.js') ?>"></script>
    <script>
    if ('serviceWorker' in navigator) {
        navigator.serviceWorker.register('/public/sw.js').catch(() => {});
    }
    </script>
</body>
</html>
