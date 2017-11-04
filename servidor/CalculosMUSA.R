#Installar el paquete Rglpk #http://cran.r-project.org/web/packages/glpkAPI/vignettes/glpk-gmpl-intro.pdf
#install.packages('Rglpk')
#install.packages('glpkAPI')
library(Rglpk);
library(glpkAPI);
library(xlsx)




#Escoger directorio de datos#
setwd("C:/Users/Dr Francisco/Desktop/tesisIIND/servidor/RMusa")
pathActual <- setwd("C:/Users/Dr Francisco/Desktop/tesisIIND/servidor/RMusa")
pathDatos <- file.path(pathActual,"Data1")
pathModelos <- pathActual

#pathResultados <- file.path(pathActual,"Resultados")
pathResultados <- file.path("c:","temp")   # tempdir()
pathTempDatos <- file.path(pathResultados,"SalidasLM")
PathGraficas <- file.path(pathResultados,"Graficas")

#nombre de modelos  archivos in out
F_XlsDatosEncuestas<- file.path(pathDatos,"Satisfacci�nRtasFundamentos.xlsx")

F_ModMusaGen <- file.path(pathModelos,"LPFase1.mod")
F_ModPostOptimo <- file.path(pathModelos,"LPFasePostOpt.mod")
F_ParamMusaGen<- file.path(pathTempDatos,"ParamModeloMusa.dat")



#Lista donde se guardar? los resultados de lso indices y los pesos de lso criterios y subcriterios para cada uno de las sucursales analizadas. 
resumenResultadosIndiceTotal<-list()
#vector donde se guardar?n los indices AFI de cada sucursal.
indicesAFI<-vector()
#vector donde se guardar?n los indices ASI de cada sucursal.
indicesASI<-vector()



#Número de sucursales a analizar
sucursales<-1
dmu <-1

# Borrar directorio de salida
unlink(pathResultados, recursive = TRUE) 
dir.create(paste0(pathResultados))

#Creación de carpetas de salida de cada sucursal (dmu)
dir.create(paste0(PathGraficas,dmu))
dir.create(pathTempDatos)

##for(dmu in 1:sucursales) #sE CORRE EL N?MERO DE SUCURSALES QUE EXISTAN
#cierra en 65  {
source("Utilitarios.R")

source("Fase1.R")

source("Fase2.R")

source("Fase3.R")
  
source("Fase4.R")   

source("Fase5.R")   
  
##}

#Convertir la matriz de resumen de ?ndices en un data frame
resumenResultadosIndiceTotal<-as.data.frame(resumenResultadosIndiceTotal)
rnames<-"Global"
for(i in 1:listParam$criterios)
{
  rnames<-append(rnames,c(i)) #Agregar nombre de las filas (criterios)
}
for(i in 1:listParam$criterios)
{
  for(j in 1:subcriterios$subcriterios[i])
  {
    rnames<-append(rnames,paste(i,",",j,sep=" ")) #Agregar nombre de las filas (subcriterios)
  }
}
resumenResultadosIndiceTotal<-(cbind(rnames,resumenResultadosIndiceTotal))
resumenResulCriteriosTotal<-resumenResultadosIndiceTotal[1:listParam$criterios+1,]

#Obtener s?lo la satisfacci?n global de las sucursales

satGlobalSucursales<-as.data.frame(t( resumenResultadosIndiceTotal[1,grep("Indice.Satisfaccion.S.", colnames(resumenResultadosIndiceTotal))]))
colnames(satGlobalSucursales)<-c("Indice Satisfacci?n Global")
rnames<-vector()
for(i in 1:sucursales)
   {
      rnames<-append(rnames,paste("Indice Satisfacci?n (",i,")",sep=" ") )
   }
rownames(satGlobalSucursales)<-rnames

print(paste0("ver resultados en: ",pathResultados))

