const express = require("express");
const bodyParser = require("body-parser");
const POST = require("./post");

// Initialize Express
const app = express();
app.use(bodyParser.json());
const port = 3000;

app.use("/api", POST);

app.listen(port, (error) => {
  if (!error) console.log("App is running fine on PORT 8080");
  else console.log("Error: " + error);
});
