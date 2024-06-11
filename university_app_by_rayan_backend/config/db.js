const mongoose =require('mongoose');
mongoose.set('bufferTimeoutMS', 1000);
const connection =mongoose.createConnection('mongodb://127.0.0.1:27017/university_by_rayan').on('open',()=>{
    console.log("MondoDB Connected");
}).on('error',()=>{
    console.log("MondoDB Connected error");
});

module.exports = connection;