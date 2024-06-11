const express = require('express');
const router = express.Router();
const attendanceController = require('../controller/attendance.controller');

router.post('/addAttendance', attendanceController.addAttendance);


router.put('/updateAttendance/:attendanceId', attendanceController.updateAttendance);
router.get('/getattendence', attendanceController.getAttendenceById);
module.exports = router;
