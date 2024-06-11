
const InsModel = require("../model/Ins.model");
const jwt = require("jsonwebtoken");
var fs = require('fs');
function base64_encode(file) {
    // read binary data
    var bitmap = fs.readFileSync(file);
    // convert binary data to base64 encoded string
    return new Buffer(bitmap).toString('base64');
}
class InsServices{
 

static async registerIns(NameIns,emailIns,passwordIns,profileimgIns,Id_university_Ins,l){
        try{
           
                console.log("Name-----Email --- Password-----profileimg-----Id_university",NameIns,emailIns,passwordIns,profileimgIns,Id_university_Ins,l);
                
                const createIns = new InsModel({NameIns,emailIns,passwordIns,profileimgIns,Id_university_Ins,l});

                return await createIns.save();
                
                
        }catch(err){
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
module.exports = InsServices;