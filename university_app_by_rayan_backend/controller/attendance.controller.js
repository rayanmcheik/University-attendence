const AttendanceServices = require('../services/attendance.services');
const Attendance = require('../model/attendance.model'); 

// exports.addAttendance = async (req, res, next) => {
//     try {    
//         const { date, studentName } = req.body;   
//         console.log(date);
//         // Check if attendance record for the given date already exists
//         const existingAttendance = await AttendanceServices.getAttendanceByDate(date);

//         if (existingAttendance) {
//             // If attendance record exists, update it with the new student's name
//             const updatedAttendance = await AttendanceServices.updateAttendance(existingAttendance._id, studentName);
//             res.json({ status: true, message: 'Attendance updated successfully', updatedAttendance });
//         } else {
//             // If attendance record doesn't exist, create a new one
//             const newAttendance = await AttendanceServices.addAttendance(date, studentName);
//             res.json({ status: true, message: 'Attendance added successfully', newAttendance });
//         }
//     } catch (err) {
//         console.log("Error adding/updating attendance:", err);
//         res.status(500).json({ status: false, message: 'Failed to add/update attendance' });
//     }
// };

exports.addAttendance = async (req, res, next) => {
    try {
      const { date, studentName } = req.body;
      console.log("Received request to add/update attendance for date:", date, "and student:", studentName);
  
      // Validate date and studentName
      if (!date || !studentName) {
        res.status(400).json({ status: false, message: 'Invalid date or student name' });
        return;
      }
  
      // Parse the date string into a Date object
      const parsedDate = new Date(date);
  
      // Check if the parsedDate is a valid Date object
      if (isNaN(parsedDate.getTime())) {
        res.status(400).json({ status: false, message: 'Invalid date format' });
        return;
      }
  
      console.log("---------------");
      // Check if attendance record for the given date already exists
      const existingAttendance = await AttendanceServices.getAttendanceByDate(parsedDate);
      console.log("---------------");
      if (existingAttendance) {
        // If attendance record exists, update it with the new student's name
        const updatedAttendance = await AttendanceServices.updateAttendance(existingAttendance._id, studentName);
        console.log("---------------");
        res.json({ status: true, message: 'Attendance updated successfully', updatedAttendance });
        console.log("---------------");
      } else {
        // If attendance record doesn't exist, create a new one
        const newAttendance = await AttendanceServices.addAttendance(parsedDate, studentName);
        res.json({ status: true, message: 'Attendance added successfully', newAttendance });
      }
    } catch (err) {
      console.log("Error adding/updating attendance:", err);
      res.status(500).json({ status: false, message: 'Failed to add/update attendance' });
    }
  };
  
  exports.updateAttendance = async (req, res, next) => {
    try {
        const { attendanceId } = req.params;
        const { studentName } = req.body;

        // Check if attendanceId is a valid UUID
        if (!uuid.validate(attendanceId)) {
            return res.status(400).json({ status: false, message: 'Invalid attendance ID format' });
        }

        const updatedAttendance = await AttendanceServices.updateAttendance(attendanceId, studentName);
        res.json({ status: true, message: 'Attendance updated successfully', updatedAttendance });
    } catch (err) {
        console.log("Error updating attendance:", err);
        res.status(500).json({ status: false, message: 'Failed to update attendance' });
    }
};
exports.getAttendenceById = async (req, res) => {
    try {
        const attendanceId = req.params.attendanceId;
        
        const attend = await AttendanceServices.getAttendenceById(attendanceId);

        if (!attend) {
            return res.status(404).json({ message: 'Attendance not found' });
        }

        res.json(attend);
    } catch (error) {
        console.error("Error retrieving attendance:", error);
        res.status(500).json({ message: 'Internal server error' });
    }
};
