<?php
	include "config.php";
	$sql="DELETE FROM sales_items where sale_id='$_GET[slid]' and med_id='$_GET[mid]'";
	if ($conn->query($sql)){
		echo "<script>window.location.href = 'pharm-pos2.php';</script>";
	exit();
	}
	else
	echo "Error";
?>


