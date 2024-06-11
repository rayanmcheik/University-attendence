const SubjectServices = require('../services/subjects.services');
const subjectModel = require('../model/subjects.model'); 

exports.AddSubject = async (req, res, next) => {
    try {    
        const {NameSub, backgroundColor, NameIns,emailIns,students} = req.body;   
        console.log("name------------------------------------------------------------------: "+NameSub);
        console.log("subjectId------------------------------------------------------------------: "+students);
        const duplicate = await SubjectServices.getNameSub(NameSub);
        if (duplicate) {
            throw new Error(`NameSubject ${NameSub}, Already Registered`)
        }

        const response = await SubjectServices.AddSubject(NameSub, backgroundColor, NameIns,emailIns,students);
        console.log("name------------------------------------------------------------------: "+NameSub);
        res.json({ status: true, success: 'subject added successfully' });
 
    } catch (err) {
        console.log("---> err -->--------------------------------", err);
        next(err);
    }
};

exports.getAllSubjects = async (req, res) => {
    try {
        const subject = await subjectModel.find();
        res.json(subject);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};
