

<?php
$servername = "localhost";
$username = "rayekzfr_ohiouser";
$password = ")d7)NJ=)JA?3";
$dbname = "rayekzfr_onhiohealth";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection
if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}

$sql = "INSERT INTO ohiohealth (name, city, date)
VALUES ('Rayen', 'Ocala', 'October 13 2021')";

if ($conn->query($sql) === TRUE) {
  echo "New record created successfully";
} else {
  echo "Error: " . $sql . "<br>" . $conn->error;
}

$conn->close();