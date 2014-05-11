<?php
// Zabbix GUI configuration file
global $DB;

$DB["TYPE"]				= 'MYSQL';
$DB["SERVER"]			= 'localhost';
$DB["PORT"]				= '3306';
$DB["DATABASE"]			= 'zabbix';
$DB["USER"]				= 'zabbix';
$DB["PASSWORD"]			= 'password';
// SCHEMA is relevant only for IBM_DB2 database
$DB["SCHEMA"]			= '';

$ZBX_SERVER				= '192.168.33.111';
$ZBX_SERVER_PORT		= '10051';
$ZBX_SERVER_NAME		= '192.168.33.111';

$IMAGE_FORMAT_DEFAULT	= IMAGE_FORMAT_PNG;
?>
