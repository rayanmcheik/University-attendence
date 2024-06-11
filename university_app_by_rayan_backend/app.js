const express = require("express");
const bodyParser = require("body-parser");
const multer = require("multer")
const UserRoute = require("./routes/user.routes");
const SubjectRoute = require("./routes/subjects.routes");
const AttendenceRoute = require("./routes/attendance.routes");
const app = express();
app.use(express.json());
app.use(bodyParser.json());
app.use(bodyParser.json({ limit: "50mb" }));
app.use(bodyParser.urlencoded({ limit: "50mb", extended: true, parameterLimit: 50000 }));

app.use(
  bodyParser.urlencoded({
    extended: true,
    limit: '35mb',
    parameterLimit: 50000,
  }),);

app.use("/",UserRoute);
app.use("/",SubjectRoute);
app.use("/",AttendenceRoute);
app.get('/users', async (req, res) => {
    try {
      const users = await users.find();
      res.json(users);
    } catch (err) {
      res.status(500).json({ message: err.message });
    }
  });

  

module.exports = app;