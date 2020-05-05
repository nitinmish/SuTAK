<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="refresh" content="<?php echo 610?>;URL='<?php echo $_SERVER['PHP_SELF'];?>'">
</head>
<?
	$myotp=exec('bash ./genTOpt.bash');
	date_default_timezone_set('Asia/Kolkata');
	echo ("<body><br>$myotp</br><br>" . date("h:i:sa d-m-Y") . "</br></body>");
?>

</html>
