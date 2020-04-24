<?php

// 获取指定天的上周的周一
$day
$week = date('w', strtotime($day));
if ($week == 0) {
    $week = 7;
}
$offset = $week - 1;
$week1stamp = strtotime($day) - (7 + $offset) * 86400;  // 指定天的上个周一
