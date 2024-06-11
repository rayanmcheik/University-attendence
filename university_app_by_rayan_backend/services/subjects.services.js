const SubjectModel = require("../model/subjects.model");
const jwt = require("jsonwebtoken");


class SubjectServices{
 
static async AddSubject(NameSub, backgroundColor, NameIns,emailIns,students){
        try{
           
                console.log("subjectId---NameSub------- backgroundColor--------NameIns-------students",NameSub, backgroundColor, NameIns,emailIns,students);
                
                const createSubjects = new SubjectModel({NameSub, backgroundColor, NameIns,emailIns,students});
                // if(req.file){
                //     userShema.profileimg = req.file.path
                // }
                return await createSubjects.save();
                
        }catch(err){
            throw err;
        }
      
    }
   
    static async getNameSub(NameSub){
        try{
            return await SubjectModel.findOne({NameSub});
        }catch(err){
            console.log(err);
        }
    }
}
module.exports = SubjectServices;