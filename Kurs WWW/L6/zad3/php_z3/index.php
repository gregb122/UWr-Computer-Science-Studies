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
    echo("<br><br>Zawartość tablicy POST:<br>");
    print_r($_POST);
    echo("<br><br>Zawartość tablicy GET:<br>");
    print_r($_GET);
    echo("<br><br>Zawartość tablicy REQUEST:<br>");
    print_r($_REQUEST);
    echo("<br><br>Zawartość zmiennej SERVER:<br>");
    print_r($_SERVER);
?>
</body>
</html>