const routerr = require('express').Router();
const subjectsController = require('../controller/subjects.controller');

routerr.post('/Addsubjects', subjectsController.AddSubject);
routerr.get('/subjects', subjectsController.getAllSubjects); 
module.exports = routerr;