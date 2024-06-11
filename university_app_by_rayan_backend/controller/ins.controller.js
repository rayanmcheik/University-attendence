var fs = require('fs');

function base64_encode(file) {
    // read binary data
    var bitmap = fs.readFileSync(file);
    // convert binary data to base64 encoded string
    return new Buffer(bitmap).toString('base64');
}

const multer = require('multer');
const path = require("path");
const InsServices = require('../services/ins.services');

exports.registerIns = async (req, res, next) => {
    try {
    
        const {NameIns,emailIns,passwordIns,profileimgIns,Id_university_Ins,l} = req.body;   
        console.log("NameIns------------------------------------------------------------------: "+NameIns);
        console.log("l----------------------------------------: "+l);
        const duplicate = await InsServices.getInsByEmail(emailIns);
        if (duplicate) {
            throw new Error(`emailIns ${emailIns}, Already Registered`)
        }
        const duplica = await InsServices.getInsById(Id_university_Ins);
        if (duplicate) {
            throw new Error(`Id_university_Ins ${Id_university_Ins}, Already Registered`)
        }
        
       

        const storage = multer.diskStorage({
            destination:function (req,file,cb){
            cb(null,path.join(profileimgIns,"../images"));
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
       const response = await InsServices.registerIns(NameIns,emailIns,passwordIns,profileimgIns,Id_university_Ins,l);
       console.log("l----------------------------------------: "+l);
        res.json({ status: true, success: 'User registered successfully' });

    } catch (err) {
        console.log("---> err -->--------------------------------", err);
        next(err);
    }


}




const Ins = require('../model/Ins.model'); 


exports.infoClient = async (req,res,next)=>{
    try {
        const user = await Ins.findOne(profileImg,email,Name,password);
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


exports.loginIns = async (req, res, next) => {
    try {
        const { email, password } = req.body;
        if (!email || !password) {
            throw new Error('Parameters are not correct');
        }
        
        // Check if the email exists in instructors
        let user = await InsServices.checkIns(email);
        
        // If user not found, throw an error
        if (!user) {
            throw new Error('Email does not exist');
        }
        
        // Compare password
        const isPasswordCorrect = await user.comparePassword(password);
        if (!isPasswordCorrect) {
            throw new Error('Email or Password does not match');
        }

        // Generate token
        const token = await InsServices.generateAccessToken({ userId: user._id }, "secretKey", '1h');

        res.status(200).json({ 
            status: true, 
            message: "Login successful",
            user: {
                email: user.emailIns,
                Name: user.NameIns,
                l: user.l,
                profileimgIns: user.profileimgIns,
                Id_university_Ins: user.Id_university_Ins,
            },
            token: token 
        });
    } catch (error) {
        console.log(error, 'err---->');
        next(error);
    }
}
exports.loginnIns = async (req, res, next) => {
    try {
        const { Id_university_Ins, passwordIns } = req.body;
        if (!Id_university_Ins || !passwordIns) {
            throw new Error('Parameter are not correct');
        }
        let user = await InsServices.check(Id_university_Ins);
        if (!user) {
            throw new Error('Id_university_Ins does not exist');
        }
        const isPasswordCorrect = await user.comparePassword(passwordIns);
        if (isPasswordCorrect === false) {
            throw new Error(`Id_university or Password does not match`);
        }
       
        const token = await InsServices.generateAccessToken({ userId: user._id }, "secretKey", '1h');
        res.status(200).json({ 
            status: true, 
            message: "Login successful",
            user: {
                // userId: user.userId,
                emailIns: user.emailIns,
                NameIns: user.NameIns,
                l: user.l,
                profileimgIns: user.profileimgIns,
                Id_university_Ins: user.Id_university_Ins,
               
            },
            token: token 
        });
    } catch (error) {
        console.log(error, 'err---->');
        next(error);
    }
}