<?php
include "config.php";

if (isset($_GET['id']) && is_numeric($_GET['id'])) {
    $stmt = $conn->prepare("DELETE FROM meds WHERE MED_ID = ?");
    $stmt->bind_param("i", $_GET['id']);

    if ($stmt->execute()) {
		echo "<script>window.location.href = 'inventory-view.php';</script>";
        exit();
    } else {
        echo "ERROR: " . $stmt->error;  // Display detailed error message
    }

    $stmt->close();
} else {
    echo "ERROR: Invalid ID.";
}

$conn->close();
?>
