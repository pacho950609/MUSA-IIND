#-------------------------------------.----------------------------------------------------------------------#
#---------------------------------------------FASE 2- MODELO POST OPTIMO ------------------------------------------------------#
#------------------------------------------------------------------------------------------------------------#
#En este paso se aplica un algoritmo heuristico, al resolver un numero especifico de programaciones lineares, 
#con el fin de realizar una busqueda de soluciones cercanas, explorando el espacio o vecindario optimo definido por un poliedro. 
#En esta fase se deben formular y resolver tantos  modelos de programacion linear (LP)  como numero de subcriterios existan. 
#En cada uno de esos LP se debe maximizar el peso de un criterio en particular, teniendo en cuenta la formulacion apropiada.

# Teniendo en cuenta la fucnion objetivo obtenida en la fase anterior (suma de los errores de sobreestimacion y subestimacion de las variables)
#Leer el archivo de ParamMusaGen 
lines = readLines(F_ParamMusaGen,-1)
#Eliminar la ultima linea (equivalente al "end" del archivo de ParamMusaGen) para poder incluir el parametro de error(funcion obj del modelo anterior) al archivo original de datos
lines=lines[-length(lines)]
#sobre Escribir el archivo original sin la ultima linea. 
writeLines(lines,con=F_ParamMusaGen)
#Escribir el resultado obtenido en el archivos de datos de entrada que recibe el modelo de glpk
cat("param error:=",error,";", "\n", file=F_ParamMusaGen, append=TRUE)
#Escribir el  Umbral del an?lisis de post- optimalidad en el archivo de datos de entrada 
cat("param e:=",listParam$e,";", "\n",file=F_ParamMusaGen,append=TRUE)

#Creacion de los data frame finales que guardan la informacion del resultado de las variables en cada modelo LP. 
biPostOptimo<-data.frame(resultadoBi[FALSE,],row.names=NULL)
bijPostOptimo<-data.frame(resultadoBij[FALSE,],row.names=NULL)
xiPostOptimo<-data.frame(resultadoXi[FALSE,],row.names=NULL)
xijPostOptimo<-data.frame(resultadoXij[FALSE,],row.names=NULL)
yPostOptimo<-data.frame(resultadoY[FALSE,],row.names=NULL)

#-----Indice promedio de ajuste (AFI Average Fitting Indices):----------#
#------------------------------------------------------------------------#
#Mide que tanto se ajustan los datos de las encuestas de satisfacci?n a las funciones de preferencias agregadas obtenidas en la fase 3,
#incluyendo los pesos de cada uno de los criterios y las funciones de valor, con el m?nimo error posible,  

AFI<-1-(error/(100*listParam$clientes))
indicesAFI<-append(indicesAFI,AFI)

#------Intervalos-----# : 
#El modelo postoptimo debe resolver tantos  modelos de programacion linear (LP)  como numero de criterios existan. 

numASICorridaPO<-vector()

inter<-1
subInter<-1

for(inter in 1:listParam$criterios)
{
  for(subInter in 1:subcriterios$subcriterios[inter])
  {
    print(paste("inter",inter,"subinter",subInter))
    # Escribir el parametro numero del criterio a maximizar en el archivo de ParamMusaGen usado en el archivo postOptimo.mod
    cat("param criterioAmaximizar:=",inter,";", "\n", file=F_ParamMusaGen, append=TRUE)
    
    # Escribir el parametro numero del subcriterio a maximizar en el archivo de ParamMusaGen usado en el archivo postOptimo.mod
    cat("param subCriterioAmaximizar:=",subInter,";", "\n", file=F_ParamMusaGen, append=TRUE)
    
    #Agregar end; necesario para que el archivo de datos sea leido en glpk
    cat("end; \n", file=F_ParamMusaGen, append=TRUE)
    
    
    #El modelo se construye en mathprog  file (glpk) y se lee usando el paquete GLPKAPI, el cual lo resuelve. 
    
    error <- solveGlpkModelMusaFase(F_ModPostOptimo , F_ParamMusaGen, pathTempDatos)
    
    ##---------------------------------------------------#
    ##---------Resultados Parciales PostOptimo-----------#
    
    #En cada intervalo ( segun el numero de criterios a maximizar) se van guardando tempralmente los resultados obtenidos en glpkAPI
    
    
    #--------------*/Transformacion de variables */----------------
    #-------------------------------------------------------------      
    
    # Output del modelo de glpk
    #OJO: TRATAR DE HACER EL OUTPUT EN EXCEL
    #/*Pesos por criterio i bi[0,1]*/#
    
    resultadoBiPO <- read.csv(paste0(pathTempDatos,"/resultadoBi.csv"),header = TRUE, sep = ",",dec = ".");
    
    #/*Pesos de los subcriterios j del criterio i bij [0,1]*/     
    resultadoBijPO<-  read.csv(paste0(pathTempDatos,"/resultadoBij.csv"),header = TRUE, sep = ",",dec = ".") ;
    
    #/*Funcion Xi* normalizada [0,100] para cada criterio de acuerdo a cada nivel de satisfaccion*/
    resultadoXiPO <- read.csv(paste0(pathTempDatos,"/resultadoXi.csv"),header = TRUE, sep = ",",dec = ".") ;
    
    #/*Funcion Xij* normalizada[0,100] para cada subcriterio j de cada criterio i en cada uno de los niveles de satisfaccion*/
    resultadoXijPO<-  read.csv(paste0(pathTempDatos,"/resultadoXij.csv"),header = TRUE, sep = ",",dec = ".") ;
    
    #/ *Funcion Y* global normalizada [0,100] para cada uno de los niveles de satisfaccion global*/
    resultadoYPO<-  read.csv(paste0(pathTempDatos,"/resultadoY.csv"),header = TRUE, sep = ",",dec = ".") ;
    
    
    
    
    ##-----ASI  ?ndice de Estabilidad (ASI Average Stability Indices)--------------#
    #------------------------------------------------------------------------------#
    #Indica la estabilidad de los resultados en la fase 2 (an?lisis de post-optimalidad)  y puede evaluarse como el valor medio de la desviaci?n est?ndar normalizada de los pesos estimados. 
    
    # numASI->> raiz((n*sum(j in inter)(bij^2)) - (sum( j in inter)bij)^2)/ (100*raiz(n-1))
    numASI<- (sqrt((listParam$clientes*sum((resultadoBiPO[,2])^2))-sum((resultadoBiPO[,2]))^2))/(100*sqrt(listParam$clientes-1))
    numASICorridaPO<-append(numASICorridaPO,numASI) #factor del ?ndice de establidad, depende de cada corrida de los post?ptimo. Estos deben sumarse con todas las corridas de los post?ptimo
    
    
    #----------------/*Actualizacion de Matrices con los resultados*/ ------------------
    
    #Cada matriz de resultados obtenido en cada modelo de programacion lineal es guardado en un solo dataframe
    
    #Guarda los resultados de la variable bi obtenidos en cada modelo de programacion lineal de cada criterio 
    biPostOptimo<-rbind(biPostOptimo,resultadoBiPO)
    
    #Guarda los resultados de la variable bij obtenidos en cada modelo de programacion lineal de cada criterio 
    bijPostOptimo<-rbind(bijPostOptimo,resultadoBijPO)
    
    #Guarda los resultados de la variable xi obtenidos en cada modelo de programacion lineal de cada criterio 
    xiPostOptimo<-rbind(xiPostOptimo,resultadoXiPO)
    
    #Guarda los resultados de la variable xij obtenidos en cada modelo de programacion lineal de cada criterio 
    xijPostOptimo<-rbind(xijPostOptimo,resultadoXijPO)
    
    #Guarda los resultados de la variable y obtenidos en cada modelo de programacion lineal de cada criterio 
    yPostOptimo<-rbind(yPostOptimo,resultadoYPO)
    
    #----------------/* Actualizacion de la base de datos */-----------------------#
    
    #Leer el archivo de ParamMusaGen 
    lines = readLines(F_ParamMusaGen,-1)
    #Eliminar las 3 ultima lineas (equivalente al "criterioAMaximizar, subcriterioAMaximizar y el end" del archivo de ParamMusaGen) para poder incluir el parametro de error(funcion obj del modelo anterior) al archivo original de datos
    lines=lines[-(length(lines)-2):-length(lines)]
    #lines=lines[-(length(lines)-1):-length(lines)]
    #sobre Escribir el archivo original sin la ultima linea. 
    writeLines(lines,con=F_ParamMusaGen)
    
  }
}

lines = readLines(F_ParamMusaGen,-1)
#Eliminar la ultima linea (equivalente al "error, criterio e y el end" del archivo de ParamMusaGen) para poder incluir el parametro de error(funcion obj del modelo anterior) al archivo original de datos
lines=lines[-(length(lines)-1):-length(lines)]
#sobre Escribir el archivo original sin la ultima linea. 
writeLines(lines,con=F_ParamMusaGen)
#Agregar end; necesario para que el archivo de datos sea leido en glpk
cat("end; \n",file=F_ParamMusaGen, append=TRUE)


#-------------------------------------------------------------------------------#
###-----ASI  ?ndice de Estabilidad (ASI Average Stability Indices)--------------#
#------------------------------------------------------------------------------#
#Indica la estabilidad de los resultados en la fase 2 (an?lisis de post-optimalidad)  y puede evaluarse como el valor medio de la desviaci?n est?ndar normalizada de los pesos estimados. 

#Calculo del ?ndice ASI de la sucursal 
ASI<-(1-(1/listParam$clientes)*sum(numASICorridaPO))

#Agregarlo al vector que guarda los ?ndices ASI de todas las sucursales  
indicesASI<-append(indicesASI,ASI)

print("fin fase 2")

