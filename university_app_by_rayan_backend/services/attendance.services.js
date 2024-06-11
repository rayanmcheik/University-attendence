const attendenceModel = require('../model/attendance.model');

class AttendanceServices {
    static async addAttendance(date, studentName) {
        try {
            const newAttendance = new attendenceModel({ date, students: [{ name: studentName }] });
            return await newAttendance.save();
        } catch (err) {
            throw err;
        }
    }

    // static async getAttendanceByDate(date) {
    //     try {
    //         return await attendenceModel.findOne({ date });
    //     } catch (err) {
    //         throw err;
    //     }
    // }
    static async getAttendanceByDate(date) {
        try {
            // Log the input date
            console.log("Input Date:", date);
            
            // Convert the date string to a JavaScript Date object
            const dateObject = new Date(date);
            console.log("Date Object:", dateObject);
            
            // Function to format date to 'YYYY-MM-DD'
            function formatDate(date) {
                const year = date.getFullYear();
                const month = String(date.getMonth() + 1).padStart(2, '0'); // Months are 0-based
                const day = String(date.getDate()).padStart(2, '0');
                return `${year}-${month}-${day}`;
            }

            // Format the date object to 'YYYY-MM-DD'
            const formattedDate = formatDate(dateObject);
            console.log("Formatted Date:", formattedDate);

            // Attempt to find an attendance record for the given date
            const attendanceRecord = await attendenceModel.findOne({ date: dateObject });
            console.log("Attendance Record:", attendanceRecord);
            
            // If there is an attendance record, return it
            if (attendanceRecord) {
                console.log("Attendance Record Found");
                return attendanceRecord;
            } else {
                console.log("No Attendance Record Found");
                // If there is no attendance record for the given date, return null
                return null;
            }
        } catch (err) {
            // Log the error
            console.error('Error finding attendance record:', err);
            // If there's an error, throw it
            throw err;
        }
    }
    static async updateAttendance(attendanceId, studentName) {
        try {
            return await attendenceModel.findByIdAndUpdate(attendanceId, { $push: { students: { name: studentName } } }, { new: true });
        } catch (err) {
            throw err;
        }
    }

    static async getAttendenceById(attendanceId) {
        try {
            return await attendenceModel.findOne({ _id: attendanceId });
        } catch (err) {
            throw err;
        }
    }
}

module.exports = AttendanceServices;
