var fs = require('fs');

function base64_encode(file) {
    // read binary data
    var bitmap = fs.readFileSync(file);
    // convert binary data to base64 encoded string
    return new Buffer(bitmap).toString('base64');
}

const multer = require('multer');
const path = require("path");

exports.register = async (req, res, next) => {
    try {
    
        const {Name, email, password,profileimg,Id_university,l} = req.body;   
        console.log("name------------------------------------------------------------------: "+Name);
        console.log("k----------------------------------------: "+l);
        const duplicate = await UserServices.getUserByEmail(email);
        if (duplicate) {
            throw new Error(`Email ${email}, Already Registered`)
        }
        const duplica = await UserServices.getUserById(Id_university);
        if (duplicate) {
            throw new Error(`Id_university ${Id_university}, Already Registered`)
        }
        
        console.log("name------------------------------------------------------------------: "+Name);

        const storage = multer.diskStorage({
            destination:function (req,file,cb){
            cb(null,path.join(profileimg,"../images"));
            },
            filename: function(req,file,cb){
               cb(null,new Date().toISOString().replace(/:/g,"-") +" "+ file.originalname);
            }
        });
        
        

        async function deleteFile(filePath) {
            try {
              await fs.unlink(filePath);
              console.log('File deleted!');
            } catch (err) {
              // Handle specific error if any
              console.error(err.message);
            }
          }
  
const fileFilter = (req, file, callback) => {
    // allowed extentions
    const validExts = [".png", ".jpg", ".jpeg", ".gif",]

    if(!validExts.includes(path.extname(file.originalname))) {
        return callback(new Error("Only .png, .jpg, .jpeg & .gif formats are allowed."))
    }

    const fileSize = parseInt(req.headers["content-length"])
    if(fileSize > 1048576) {
        return callback(new Error("File size is over the limit allowed!"))
    }

    callback(null, true)
}

let upload = multer({
    storage: storage,
    fileFilter: fileFilter,
    fileSize: 52428800, // size of 10MB
}).single("imgBase64");
console.log("name------------------------------------------------------------------: "+Name);
       const response = await UserServices.registerUser(Name,email, password,profileimg,Id_university,l);
       console.log("name------------------------------------------------------------------: "+Name);
        res.json({ status: true, success: 'User registered successfully' });

    } catch (err) {
        console.log("---> err -->---------llll--", err);
        next(err);
    }


};




exports.getUserList =  async (req,res,next)=>{
    try {
        const { Name,email } = req.body;
        let userData = await userService.getUserList(Name,email);
        res.json({status: true,success:userData});
    } catch (error) {
        console.log(error, 'err---->');
        next(error);
    }
}

exports.login = async (req, res, next) => {
    try {
        const { email, password } = req.body;
        if (!email || !password) {
            throw new Error('Parameters are not correct');
        }
        console.log('--');
        let user = await UserServices.checkUser(email);
        console.log('---');
        if (!user) {
            throw new Error('Email does not exist');
        }
        console.log('---');
        const isPasswordCorrect = await user.comparePassword(password);
        if (isPasswordCorrect === false) {
            throw new Error('Email or Password does not match');
        }
        console.log('----');

        const token = await UserServices.generateAccessToken({ userId: user._id }, "secretKey", '1h');
        console.log('------');
        res.status(200).json({ 
            status: true, 
            message: "Login successful",
            user: {
                userId: user.userId,
                email: user.email,
                Name: user.Name,
                l: user.l,
                profileimg: user.profileimg,
                Id_university: user.Id_university,
               
            },
            token: token 
        });
    } catch (error) {
        // Log the error here
        console.log(error, 'err---->');
        next(error);
    }
}
exports.loginn = async (req, res, next) => {
    try {
        const { Id_university, password } = req.body;
        if (!Id_university || !password) {
            throw new Error('Parameter are not correct');
        }
        let user = await UserServices.checkUser_ID(Id_university);
        if (!user) {
            throw new Error('Id_university does not exist');
        }
        const isPasswordCorrect = await user.comparePassword(password);
        if (isPasswordCorrect === false) {
            throw new Error(`Id_university or Password does not match`);
        }
       
        const token = await UserServices.generateAccessToken({ userId: user._id }, "secretKey", '1h');
        res.status(200).json({ 
            status: true, 
            message: "Login successful",
            user: {
                userId: user.userId,
                email: user.email,
                l:user.l,
                Name: user.Name,
                profileimg: user.profileimg,
                Id_university:user.Id_university,
                
            },
            token: token 
        });
    } catch (error) {
        console.log(error, 'err---->');
        next(error);
    }
}
const UserServices = require('../services/user.services');
const User = require('../model/user.model'); 

exports.getAllUsers = async (req, res) => {
    try {
      const users = await User.find();
      res.json(users);
    } catch (err) {
      res.status(500).json({ message: err.message });
    }
  };
exports.infoClient = async (req,res,next)=>{
    try {
        const user = await User.findOne(profileImg,email,Name,password);
        res.json(user);
      } catch (err) {
        res.status(500).json({ message: err.message });
      }  
}
exports.uploadImage = async (req, res,next) => {
    try {
      const { filename } = req.file;
      const user = await User.findById(req.user.id);
        user.profileimg = filename;
        await user.save();
      res.status(200).send('Image uploaded successfully');
    } catch (error) {
      res.status(500).send(error.message);
    }
};
const mongoose = require('mongoose');

exports.getUserById = async (req, res) => {
    try {
        
        const userId = req.params.userId;
   

        // Find user by userId
        const user = await User.findOne({ userId: userId });

        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        res.json(user);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
};
