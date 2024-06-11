const db =require('../config/db');
const mongoose = require('mongoose');
const bcrypt = require("bcrypt");
const uuid = require('uuid'); // Import the uuid library

// Function to generate a random userId
function generateUserId() {
  return uuid.v4(); // Generate a random UUID
}

const {Schema}= mongoose;

const InsShema = new Schema({

    NameIns:{
        type: String,
        required: [true, "NameIns is required"],
    },
    
    emailIns:{
    type: String,
    lowercase:true,
    required: [true, "emailIns can't be empty"],
        // @ts-ignore
        match: [
            /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/,
            "email format is not correct",
        ],
        unique: true,
    },
    
    passwordIns:{
    type: String,
    required: [true, "passwordIns is required"],
    },
    profileimgIns:{
    
    },
    Id_university_Ins:{
    type:String,
    required: [true, "Id_university_Ins is required"],
    },
    l:{
        type:Number,
    }
    
    
    },{timestamps:true});


    InsShema.pre('save', async function(next) {
        try {
            var user = this;
            if (!user.isModified("passwordIns")) {
                return next();
            }
            const salt = await bcrypt.genSalt(10);
            const hashpass = await bcrypt.hash(user.passwordIns, salt);
            user.passwordIns = hashpass;
            next();
        } catch (err) {
            return next(err);
        }
    });
    InsShema.methods.comparePassword = async function (candidatePassword) {
        try {
            console.log('password:',this.passwordIns);
            const isMatch = await bcrypt.compare(candidatePassword, this.passwordIns);
            console.log('password:',this.passwordIns);
            return isMatch;
    
        } catch (error) {
            throw error;
        }
    };
    const InsModel = db.model('Ins',InsShema);
    module.exports = InsModel;