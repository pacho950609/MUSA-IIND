var express = require('express');
var router = express.Router();
var controladores= require('.././controladores');





router.get('/generarYSubirAnalisis/:id',controladores.controladorPrincipal.generarYSubirAnalisis);


 







module.exports = router ; 