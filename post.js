const express = require("express");
const path = require("path");
const { spawn } = require("child_process");

const router = express.Router();

router.post("/detect-hazard", (req, res) => {
  console.log("API Called!");

  const imagePath = req.body.image_path; // Receive image path from MATLAB

  if (!imagePath) {
    console.log("API error! No image path provided.");
    return res.status(400).send("No image path provided.");
  }

  console.log("File path: " + imagePath);

  // Path to the Python executable in the Conda environment
  const pythonPath = "/Users/erebus2507/opt/anaconda3/bin/python"; // Replace this with your actual path

  // Call the Python script using the specific Python interpreter
  const python = spawn(pythonPath, ["detect_hazard.py", imagePath]);

  let resultData = ""; // Variable to capture Python's stdout output

  // Capture Python script output (stdout) and append the result
  python.stdout.on("data", (data) => {
    resultData += data.toString();
  });

  // Capture output to check for errors
  python.stderr.on("data", (data) => {
    console.error(`stderr: ${data}`);
  });

  // Handle script completion
  python.on("close", (code) => {
    if (code === 0) {
      try {
        // Fix the Python output: replace single quotes with double quotes
        resultData = resultData.replace(/'/g, '"'); // Replace single quotes with double quotes

        // Parse the fixed JSON data from Python output
        const result = JSON.parse(resultData);

        // Send the result from Python to the client
        res.status(200).send(result);
        console.log("API response sent!");
      } catch (err) {
        console.error("Error parsing Python output:", err);
        res.status(500).send("Error parsing hazard detection result.");
      }
    } else {
      console.error(`Python script error: ${code}`);
      res.status(500).send("Error detecting hazard.");
    }
  });
});

module.exports = router;
