<!doctype html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Zadanie3</title>
</head>
<body>
    

    <?php 
    setcookie("ciacho1", "publiczne", NULL, NULL, NULL, NULL, FALSE);   
    setcookie("ciacho2", "prywatne", NULL, NULL, NULL, NULL, TRUE);   
    echo("<br><br>Zawartość tablicy COOKIE:<br>");
    print_r($_COOKIE);

?>
</body>
</html>