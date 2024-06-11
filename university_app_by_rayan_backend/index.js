const app = require("./app");
const db = require('./config/db');
const UserModel = require('./model/user.model');
const SubjectModel = require('./model/subjects.model');

const port = 3001;
app.get('/', (req, res)=>{
    res.send("Hello Worlddddd")
     });
app.listen(port,()=>{
    console.log(`Server Listening on Port http://localhost:${port}`);
});