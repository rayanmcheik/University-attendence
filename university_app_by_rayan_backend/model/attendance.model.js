const mongoose = require('mongoose');
const uuid = require('uuid');

const { Schema } = mongoose;

const attendanceSchema = new Schema({
    attendanceId: {
        type: String,
        default: uuid.v4, 
    },
    date: { type: Date, index: true }, 
    students: [{
        name: String,
    }],
}, { timestamps: true });

const Attendance = mongoose.model('Attendance', attendanceSchema);

module.exports = Attendance;
