const db =require('../config/db');
const mongoose = require('mongoose');
const subjectId = require('uuid'); // Import the uuid library

// Function to generate a random userId
function generateUserId() {
  return subjectId.v4(); // Generate a random UUID
}

const {Schema}= mongoose;

const SubjectShema = new Schema({
    subjectId: {
        type: String,
        default: generateUserId, // Assign a random userId when creating a new product
      },
    
      NameSub:{
        type: String,
        required: [true, "Name is required"],
    },

    backgroundColor:{
    type: String,
 
    },

    NameIns:{
    type: String,
    required: [true, "password is required"],
},
emailIns:{
  type: String,
  required: [true, "password is required"],
},
students: [{
  name: String,
  email: String
}]

},{timestamps:true});

SubjectShema.pre('save',async function(){
   
      
});



const SubjectModel = db.model('Subject',SubjectShema);

module.exports = SubjectModel;

