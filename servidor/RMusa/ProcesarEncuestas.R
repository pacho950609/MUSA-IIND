#Leer
#Escoger directorio de datos#
library(xlsx)


setwd("./")
pathActual <- getwd()
pathDatos <- file.path(pathActual,"Data1")
F_XlsDataEncuestas<- file.path(pathDatos,"respuestas Calidad 2016-2.xlsx")
F_XlsOutDatosEncuestas<- file.path(pathDatos,"SatisfacciónRtasFundamentos.xlsx")

dmu<-1
numColIdEncuesta<-4

data <- read.xlsx(F_XlsDataEncuestas, "Data")
# Recode 
data <- apply(data, 2, function(x) {x[x == "Nunca o casi nunca"] <- 1; x})
data <- apply(data, 2, function(x) {x[x == "Casi nunca"] <- 1; x})
data <- apply(data, 2, function(x) {x[x == "Ocasionalmente"] <- 2; x})
data <- apply(data, 2, function(x) {x[x == "A veces"] <- 3; x})
data <- apply(data, 2, function(x) {x[x == "Frecuentemente"] <- 4; x})
data <- apply(data, 2, function(x) {x[x == "Siempre o casi siempre"] <- 5; x})
data <- apply(data, 2, function(x) {x[x == "Casi siempre"] <- 5; x})
data <- apply(data, 2, function(x) {x[x == "No aplica"] <- NA; x})

data<- as.matrix(data)

#para imputar NA
Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}
# s[is.na(s)] = Mode(s) # para "imputar"
# moda alternativa : names(sort(-table(mydata[,12])))[1]





#Archivo 1: Información general de los criterios y sus subcriterios
###########
datosCriterios <- read.xlsx(F_XlsDataEncuestas, "infoCriterios")

filas<- subset(datosCriterios,ID!=0) # el id=0 es la global
filas$Criterio <- NULL # delete that column
filas$Col <- NULL # delete that column
names(filas)<-c("CRITERIOS", "subcriterios")
filas<-lapply(filas, function(x)as.numeric(x))
write.xlsx(filas,file=F_XlsOutDatosEncuestas,sheetName="Subcriterios",row.names = F)

#Archivo 2: Información sobre parametros a usar en el LP
###########
param <- read.xlsx(F_XlsDataEncuestas, "infoParametros")
                   
numClientes<- length( data[,numColIdEncuesta] )
numCriterios<- nrow(subset(datosCriterios,ID!=0))

df <- NULL;
df <- rbind(df,data.frame(Parametros="clientes",valor=numClientes) )
df <- rbind(df,data.frame(Parametros="criterios",valor=numCriterios) )
df <- rbind(df,data.frame(Parametros="alfa",valor=param[1,2]) )
df <- rbind(df,data.frame(Parametros="alfaI",valor=param[2,2]) )
df <- rbind(df,data.frame(Parametros="alfaIJ",valor=param[3,2]) )
df <- rbind(df,data.frame(Parametros="thr",valor=param[4,2]) )
df <- rbind(df,data.frame(Parametros="thrCriterio",valor=param[5,2]) )
df <- rbind(df,data.frame(Parametros="thrSubcriterio",valor=param[6,2]) )
df <- rbind(df,data.frame(Parametros="e",valor=param[7,2]) )
names(filas)<-c("CRITERIOS", "subcriterios")
filas<-lapply(filas, function(x)as.numeric(x))
write.xlsx(df,file=F_XlsOutDatosEncuestas,sheetName=paste0("Datos",dmu),append = T,row.names = F)

#Archivo 3: Información sobre satisfacción global
###########
fila<- subset(datosCriterios,ID==0) # el id=0 debe ser el global
col<- as.numeric(fila[4])
s<-data[,col]
s[is.na(s)] = Mode(s) # para "imputar" NA por la Moda
x<- data[,numColIdEncuesta] # en la columna cuatro debe estar el identificador de encuesta
z<- as.data.frame(cbind(x,s)) # en esa columna se encuentra la satisfacción global
names(z)<-c("CLIENTES","satGlobal")
z<-lapply(z, function(x)as.numeric(x))
write.xlsx(z,file=F_XlsOutDatosEncuestas,sheetName=paste0("SatisfaccionGlobal",dmu),append = T,row.names = F)

#Archivo 4: Información sobre satisfacción en los Criterios
###########
z<-vector()
for(i in 1:numCriterios){
  fila<- subset(datosCriterios,ID==i) # el id=i debe ser uno de los criterio 
  col<- as.numeric(fila[4])
  s<-data[,col]
  s[is.na(s)] = Mode(s) # para "imputar"
  x<- data[,numColIdEncuesta] # en la columna cuatro debe estar el identificador de encuesta
  z<-rbind(z,cbind(x,i,s))
}
z<- as.data.frame(z)
names(z)<-c("CLIENTES","CRITERIOS","satCriterios")
z<-lapply(z, function(x)as.numeric(x))
write.xlsx(z,file=F_XlsOutDatosEncuestas,sheetName=paste0("SatisfaccionCriterios",dmu),append = T,row.names = F)

#Archivo 5/5: Información sobre satisfacción en los Subcriterios
###########
datosSubcriterios <- read.xlsx(F_XlsDataEncuestas, "infoSubcriterios")
z<-vector()
for(i in 1:numCriterios) {
  filas<- subset(datosSubcriterios,Criterio==i)
  numFilas<- nrow(filas)
  for(j in 1:numFilas) {
    col<- as.numeric( filas[j,3])
    x<- data[,numColIdEncuesta] # en la columna cuatro debe estar el identificador de encuesta
    s<-data[,col]
    s[is.na(s)] = Mode(s) # para "imputar"
    z<-rbind(z,cbind(x,i,j,s))
  }
}
z<- as.data.frame(z)
names(z)<-c("CLIENTES","CRITERIOS","SUBCRITERIOS","satSubcriterios")
z<-lapply(z, function(x)as.numeric(x))
write.xlsx(z,file=F_XlsOutDatosEncuestas,sheetName=paste0("SatisfaccionSubcriterios",dmu),append = T,row.names = F)



