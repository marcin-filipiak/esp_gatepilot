<?php
$filename = "state.tmp";
$correctPassword = "your_password"; /// <--- enter here password for users
$cookieName = "auth";
$cookieValue = "1";
$cookieLifetime = 300 * 24 * 60 * 60; // 300 dni

function isOnline($filename = "state.tmp") {
    $maxAgeSeconds = 5 * 60; // 5 minut

    $content = trim(file_get_contents($filename));
    $fileAge = time() - filemtime($filename);

    if ($content === "1" && $fileAge > $maxAgeSeconds)
        return false;
    else
        return true;
}

// Obsługa żądania GET z parametrem state=show
if (isset($_GET['state']) && $_GET['state'] === 'show') {
    $state = file_exists($filename) ? trim(file_get_contents($filename)) : "0";
    echo $state;

    if ($state === "1") {
        file_put_contents($filename, "0");
    }

    exit;
}

// Obsługa logowania
session_start();
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['password'])) {
    if ($_POST['password'] === $correctPassword) {
        setcookie($cookieName, $cookieValue, time() + $cookieLifetime);
        $_COOKIE[$cookieName] = $cookieValue;
    } else {
        $error = "Wrong password.";
    }
}

// Sprawdzenie autoryzacji
if (!isset($_COOKIE[$cookieName]) || $_COOKIE[$cookieName] !== $cookieValue):
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Logowanie</title>
    <link rel="stylesheet" href="style.css">
</head>
<body class="login-body">
    <div class="login-box">
        <form method="POST">
            <p>password:</p>
            <input type="password" name="password" required>
            <br>
            <button type="submit">Login</button>
            <?php if (!empty($error)) echo "<div class='error'>$error</div>"; ?>
        </form>
    </div>
</body>
</html>
<?php
exit;
endif;

// Obsługa kliknięcia przycisku
if ($_SERVER['REQUEST_METHOD'] === 'POST' && !isset($_POST['password'])) {
    file_put_contents($filename, "1");

    $timestamp = date("Y-m-d H:i:s");
    file_put_contents("statistics.txt", $timestamp . PHP_EOL, FILE_APPEND);
}


// Odczyt stanu
$state = file_exists($filename) ? trim(file_get_contents($filename)) : "0";
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Status</title>
    <link rel="stylesheet" href="style.css">
    <script src="script.js"></script>
</head>
<body class="main-body">
    <div class="container">
        <img src="logo.gif" style="width:200px;">
        <?php if (!isOnline):?>
            <div class="error">Probably your gate isnt connected</div>
        <?php endif; ?>
        <form method="POST">
            <button type="submit">Move gate</button>
        </form>

        <?php if ($state === "1"): ?>
            <div class="status">Please wait...</div>
        <?php endif; ?>
    </div>
</body>
</html>

