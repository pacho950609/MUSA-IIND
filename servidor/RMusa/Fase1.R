####--------------------------------------------------------------------------## 
####---------------------- FASE 1 ---------------------------------------------##
####--------------------------------------------------------------------------##
####  PROGRAMA DE OPTIMIZACIÓN LINEAL (MATHPROG)--------------------------------#
#--------------------------------------------------------------------------------------------------------------------------------#
#Funcion objetivo es la minimizacion de la suma de los errores (de sobrestimacion y subestimacion definidos en la ecuacion ordinal), 
#de manera que la consistencia entre la funcion de valor encontrada Y^*, compuesto por las funciones parciales de satisfaccion xi^*, 
#y el  juicio global emitido por el cliente sea la maxima posible.
#El modelo se construye en mathprog  file (glpk) y se lee usando el paquete GLPKAPI, el cual lo resuelve. 

#Cargar información en dataframes y cargar parametros

datos <- read.xlsx(F_XlsDatosEncuestas, paste0("Datos",dmu))
write.csv(file=file.path(pathTempDatos,"datos.csv"), x=datos, row.names = F, quote = FALSE)
listParam <- crearFileParametros(file.path(pathTempDatos,"datos.csv"), F_ParamMusaGen)

#Leer datos para el LP desde un archivo XLS
satGlobal <- read.xlsx(F_XlsDatosEncuestas, paste0("SatisfaccionGlobal",dmu))
satCriterios <- read.xlsx(F_XlsDatosEncuestas, paste0("SatisfaccionCriterios",dmu)) # read a sheet
satSubcriterios <- read.xlsx(F_XlsDatosEncuestas, paste0("SatisfaccionSubcriterios",dmu))
subcriterios <- read.xlsx(F_XlsDatosEncuestas, "Subcriterios")

#dejar los mismos nombres de campos que se usan en el LP
names(satGlobal) <- c("CLIENTES","satGlobal")
names(satCriterios) <- c("CLIENTES","CRITERIOS","satCriterios")
names(satSubcriterios) <- c("CLIENTES","CRITERIOS","SUBCRITERIOS","satSubcriterios")
names(subcriterios) <- c("CRITERIOS","subcriterios")

#crear los cuatro archivos que necesita el modelo GLPK: LP
write.csv(file=file.path(pathTempDatos,"satCriterios.csv"), x=satCriterios, row.names = F, quote = FALSE)
write.csv(file=file.path(pathTempDatos,"satGlobal.csv"), x=satGlobal, row.names = F, quote = FALSE)
write.csv(file=file.path(pathTempDatos,"satSubcriterios.csv"), x=satSubcriterios, row.names = F, quote = FALSE)
write.csv(file=file.path(pathTempDatos,"subcriterios.csv"), x=subcriterios, row.names = F, quote = FALSE)


# 
# #si existe la información en CSV copiarla al directorio de datos.
# #crear archivo de satiafacci?n global de cada sucursal por el nombre gen?rico "satGlobal.csv"
# file.copy(from=paste0(pathDatos,"/satGlobal",dmu,".csv"),to=paste0(pathTempDatos,"/satGlobal.csv"), overwrite = TRUE)
# #crear archivo de satiafacci?n por criterios de cada sucursal por el nombre gen?rico "satCriterios.csv"
# file.copy(from=paste0(pathDatos,"/satCriterios",dmu,".csv"),to=paste0(pathTempDatos,"/satCriterios.csv"),  overwrite = TRUE)
# #crear archivo de satiafacci?n de cada subcriterios de cada sucursal por el nombre gen?rico "satSubcriterios.csv"
# file.copy(from=paste0(pathDatos,"/satSubcriterios",dmu,".csv"),to=paste0(pathTempDatos,"/satSubcriterios.csv"), overwrite = TRUE)
# #copiar archivo de subcriterios por el nombre gen?rico "subcriterios.csv"
# file.copy(from=file.path(pathDatos,"subcriterios.csv"),to=file.path(pathTempDatos,"subcriterios.csv"), overwrite = TRUE)

error <- solveGlpkModelMusaFase(F_ModMusaGen , F_ParamMusaGen, pathTempDatos)

##----------------Resultados----------------------
#----------*/Transformacion de variables */-----------
#-----------------------------------------------------     

# Output del modelo de glpk#
#/*Pesos por criterio i bi[0,1]*/#

resultadoBi <- read.csv(paste0(pathTempDatos,"./resultadoBi.csv"),header = TRUE, sep = ",",dec = ".") 

#/*Pesos de los subcriterios j del criterio i bij [0,1]*/     
resultadoBij<-  read.csv(paste0(pathTempDatos,"/resultadoBij.csv"),header = TRUE, sep = ",",dec = ".") 

#/*Funcion Xi* normalizada [0,100] para cada criterio de acuerdo a cada nivel de satisfaccion*/
resultadoXi <- read.csv(paste0(pathTempDatos,"/resultadoXi.csv"),header = TRUE, sep = ",",dec = ".") 

#/*Funcion Xij* normalizada[0,100] para cada subcriterio j de cada criterio i en cada uno de los niveles de satisfaccion*/
resultadoXij<-  read.csv(paste0(pathTempDatos,"/resultadoXij.csv"),header = TRUE, sep = ",",dec = ".") 

#/ *Funcion Y* global normalizada [0,100] para cada uno de los niveles de satisfaccion global*/
resultadoY<-  read.csv(paste0(pathTempDatos,"/resultadoY.csv"),header = TRUE, sep = ",",dec = ".") 

print("fin fase 1")
