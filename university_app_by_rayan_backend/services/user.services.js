const UserModel = require("../model/user.model");
const jwt = require("jsonwebtoken");
var fs = require('fs');
function base64_encode(file) {
    // read binary data
    var bitmap = fs.readFileSync(file);
    // convert binary data to base64 encoded string
    return new Buffer(bitmap).toString('base64');
}
class UserServices{
 
static async registerUser(Name,email,password,profileimg,Id_university,l){
        try{
           
                console.log("Name-----Email --- Password-----profileimg-----Id_university",Name,email,password,Id_university,l);
                
                const createUser = new UserModel({Name,email,password,profileimg,Id_university,l});
                return await createUser.save();
       
        }catch(eror){
            console.log("Name-----Email --- Password-----profileimg-----Id_university",Name,email,password,Id_university,l);
            throw eror;
           
        }
      
    }

    static async getUserByEmail(email){
        try{
            return await UserModel.findOne({email});
        }catch(err){
            console.log(err);
        }
    }
    static async getUserById(Id_university){
        try{
            return await UserModel.findOne({Id_university});
        }catch(err){
            console.log(err);
        }
    }
    static async checkUser(email , emailIns){
        try {
            
            return await UserModel.findOne({email});

        } catch (err) {
            throw err;
        }
    }
    static async checkUser_ID(Id_university){
        try {
            return await UserModel.findOne({Id_university});
        } catch (err) {
            throw err;
        }
    }
    static async getInsByEmail(emailIns){
        try{
            return await InsModel.findOne({emailIns});
        }catch(err){
            console.log(err);
        }
    }
    static async getInsById(Id_university_Ins){
        try{
            return await InsModel.findOne({Id_university_Ins});
        }catch(err){
            console.log(err);
        }
    }
    static async checkIns(emailIns){
        try {
            
            return await InsModel.findOne({emailIns});
            
        } catch (err) {
            throw err;
        }
    }
    static async checkIns_ID(Id_university_Ins){
        try {
            return await InsModel.findOne({Id_university_Ins});
        } catch (err) {
            throw err;
        }
    }
    static async generateAccessToken(tokenData,secretKey,jwt_expire ){
        return jwt.sign(tokenData, secretKey, { expiresIn: jwt_expire });
    }
    // static async getUserList(Name,email,profileimg){
    //     const userList = await ToDoModel.find({Name,email,profileimg})
    //     return userList;
    // }
}
module.exports = UserServices;