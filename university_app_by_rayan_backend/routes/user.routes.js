const router = require('express').Router();
const UserController =require('../controller/user.controller');
const InsController =require('../controller/ins.controller');
const multer = require('multer');
const path = require("path");
const storage = multer.diskStorage({
    destination:function (req,file,cb){
    cb(null,path.join(__dirname,"../images"));
    },
    filename: function(req,file,cb){
       cb(null,new Date().toISOString().replace(/:/g,"-") +" "+ file.originalname);
    }
});
const upload= multer({ storage });

router.post('/registration', upload.single("profileimg"),UserController.register);
router.post('/registrationIns', upload.single("profileimgIns"),InsController.registerIns);
router.post('/login',UserController.login);
router.post('/loginn',UserController.loginn);
router.post('/loginIns',InsController.loginIns);
router.post('/loginnIns',InsController.loginnIns);
router.get('/infoClient',UserController.infoClient);
router.get('/users', UserController.getAllUsers);
router.get('/users/:userId', UserController.getUserById);
module.exports = router;

