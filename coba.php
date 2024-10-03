<?php
for ($i = 5; $i >= 1; $i--) {
    for ($j = 5; $j > $i; $j--) {
        echo "&nbsp;&nbsp;";
    }
    for ($k = 1; $k <= (2 * $i - 1); $k++) {
        echo "*";
    }
    echo "<br/>";
}
?>
