

<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
$servername = "localhost";
$username = "rayekzfr_ohiouser";
$password = ")d7)NJ=)JA?3";
$dbname = "rayekzfr_onhiohealth";


// $data =  json_decode(file_get_contents('php://input'), true);

// $name = $data['name'];


// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection
if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}

$result = $conn->query("SELECT * FROM ohiohealth ORDER BY timestamp DESC LIMIT 1");

  $rows = array();
  while($r = mysqli_fetch_array($result)) {
    $rows[] = $r;
  }



if (count($rows)> 0) {
    header('Content-Type: application/json; charset=utf-8');
   echo json_encode($rows[0]);
} else {
  echo "Error: " . $sql . "<br>" . $conn->error;
}

$conn->close();