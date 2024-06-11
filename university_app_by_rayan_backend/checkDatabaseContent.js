// const mongoose = require('mongoose');
// const attendenceModel = require('../model/attendance.model');// Ensure the path is correct based on your project structure

// async function checkDatabaseContent() {
//     try {
//         await mongoose.connect('mongodb://127.0.0.1:27017/university_by_rayan', { useNewUrlParser: true, useUnifiedTopology: true });

//         const records = await attendenceModel.find({});
//         console.log('All Attendance Records:', records);
//     } catch (err) {
//         console.error('Error connecting to the database:', err);
//     } finally {
//         mongoose.connection.close();
//     }
// }

// checkDatabaseContent();
