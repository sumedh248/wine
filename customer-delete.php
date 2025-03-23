<?php
	include "config.php";
	$sql="DELETE FROM customer where c_id='$_GET[id]'";
	if ($conn->query($sql))
	echo "<script>window.location.href = 'customer-view.php';</script>";
	else
	echo "error";
?>