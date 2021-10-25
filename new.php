

<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
$servername = "localhost";
$username = "rayekzfr_ohiouser";
$password = ")d7)NJ=)JA?3";
$dbname = "rayekzfr_onhiohealth";


$data =  json_decode(file_get_contents('php://input'), true);

$name = $data['name'];
$city = $data['city'];
$date = $data['date'];



// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection
if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}

$sql = "INSERT INTO ohiohealth (name, city, date)
VALUES ('$name', '$city', '$date')";

if ($conn->query($sql) === TRUE) {
  echo "New record created successfully";
} else {
  echo "Error: " . $sql . "<br>" . $conn->error;
}

$conn->close();