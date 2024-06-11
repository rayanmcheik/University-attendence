const db =require('../config/db');
const mongoose = require('mongoose');
const bcrypt = require("bcrypt");
const uuid = require('uuid'); // Import the uuid library

// Function to generate a random userId
function generateUserId() {
  return uuid.v4(); // Generate a random UUID
}

const {Schema}= mongoose;

const userShema = new Schema({
    userId: {
        type: String,
        default: generateUserId, // Assign a random userId when creating a new product
      },
    
Name:{
        type: String,
        required: [true, "Name is required"],
    },

email:{
    type: String,
    lowercase:true,
    required: [true, "email can't be empty"],
        // @ts-ignore
        match: [
            /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/,
            "email format is not correct",
        ],
        unique: true,
    },

password:{
    type: String,
    required: [true, "password is required"],
},
profileimg:{
 
},
Id_university:{
    type:String,
    required: [true, "Id_university is required"],
},

l:{
    type:Number,
},


},{timestamps:true});

userShema.pre('save',async function(){
   
        var user = this;
        if(!user.isModified("password")){
            return
        }
        try{
        const salt = await(bcrypt.genSalt(10));
        const hashpass = await bcrypt.hash(user.password,salt);

        user.password = hashpass;

        
    }catch(err){
        throw err;
     }
});

userShema.methods.comparePassword = async function (candidatePassword) {
    try {
        console.log('password:',this.password);
        const isMatch = await bcrypt.compare(candidatePassword, this.password);
        console.log('password:',this.password);
        return isMatch;

    } catch (error) {
        throw error;
    }
};

const UserModel = db.model('user',userShema);

module.exports = UserModel;

