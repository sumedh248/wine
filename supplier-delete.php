<?php
	include "config.php";
	$sql="DELETE FROM suppliers where sup_id='$_GET[id]'";
	if ($conn->query($sql))
	echo "<script>window.location.href = 'supplier-view.php';</script>";
	else
	echo "error";
?>