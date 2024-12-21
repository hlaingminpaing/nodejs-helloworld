const express = require("express");
const app = express();
const port = 3000;

app.get("/", (req, res) => {
  res.send("Hello, World! Welcome to ECS with CodeBuild Blue-Green Deployment! Version 12");
});

app.listen(port, () => {
  console.log(`App running on http://localhost:${port}`);
});
