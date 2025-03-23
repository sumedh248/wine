<?php
	include "config.php";
	$sql="DELETE FROM employee where e_id='$_GET[id]'";
	if ($conn->query($sql))
	echo "<script>window.location.href = 'employee-view.php';</script>";
	else
	echo "error";
?>