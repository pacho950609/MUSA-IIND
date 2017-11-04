#Leer
#Escoger directorio de datos#
setwd("./")
pathActual <- getwd()
pathDatos <- file.path(pathActual,"Data1")

F_XlsDataEncuestas<- file.path(pathDatos,"respuestas Calidad 2016-2.xlsx")
dmu<-1

data <- read.xlsx(F_XlsDataEncuestas, "Data")


# Recode 
data <- apply(data, 2, function(x) {x[x == "Nunca o casi nunca"] <- 1; x})
data <- apply(data, 2, function(x) {x[x == "Casi nunca"] <- 1; x})
data <- apply(data, 2, function(x) {x[x == "Ocasionalmente"] <- 2; x})
data <- apply(data, 2, function(x) {x[x == "A veces"] <- 3; x})
data <- apply(data, 2, function(x) {x[x == "Frecuentemente"] <- 4; x})
data <- apply(data, 2, function(x) {x[x == "Siempre o casi siempre"] <- 5; x})
data <- apply(data, 2, function(x) {x[x == "Casi siempre"] <- 5; x})

data<- as.matrix(data)

numColIdEncuesta<-4

datos <- read.xlsx(F_XlsDataEncuestas, "infoCriterios")

#info sobre los criterios y subcriterios
filas<- subset(datos,ID!=0) # el id=0 es la global
filas$Criterio <- NULL # delete that column
filas$Col <- NULL # delete that column
names(filas)<-c("CRITERIOS", "subcriterios")
write.xlsx(filas,file="./test.xlsx",sheetName="Subcriterios",row.names = F)

"Datos de parametros del LP"
numClientes<- length( data[,numColIdEncuesta] )
numCriterios<- nrow(filas)
df <- NULL;
df <- rbind(df,data.frame(Parametros="clientes",valor=numClientes) )
df <- rbind(df,data.frame(Parametros="criterios",valor=numCriterios) )

param <- read.xlsx(F_XlsDataEncuestas, "infoParametros")
df <- rbind(df,data.frame(Parametros="alfa",valor=param[1,2]) )
df <- rbind(df,data.frame(Parametros="alfaI",valor=param[2,2]) )
df <- rbind(df,data.frame(Parametros="alfaIJ",valor=param[3,2]) )
df <- rbind(df,data.frame(Parametros="thr",valor=param[4,2]) )
df <- rbind(df,data.frame(Parametros="thrCriterio",valor=param[5,2]) )
df <- rbind(df,data.frame(Parametros="e",valor=param[6,2]) )

write.xlsx(df,file="./test.xlsx",sheetName=paste0("Datos",dmu),append = T,row.names = F)


#satisfacción global
fila<- subset(datos,ID==0) # el id=0 debe ser el global
col<- as.numeric(fila[4])
s<-data[,col]
x<- data[,numColIdEncuesta] # en la columna cuatro debe estar el identificador de encuesta
z<- cbind(x,s) # en esa columna se encuentra la satisfacción global
write.xlsx(z,file="./test.xlsx",sheetName=paste0("SatisfaccionGlobal",dmu),append = T,row.names = F)

numCriterios<-as.numeric(fila[3])
#escritura de satisfacción por Criterio
z<-vector()
for(i in 1:numCriterios){
  fila<- datos[datos[1]==i] # el id=i debe ser uno de los criterio 
  col<- as.numeric(fila[4])
  s<-data[,col]
  x<- data[,numColIdEncuesta] # en la columna cuatro debe estar el identificador de encuesta
  z<-rbind(z,cbind(x,i,s))
}
write.xlsx(z,file="./test.xlsx",sheetName=paste0("SatisfaccionCriterios",dmu),append = T,row.names = F)

datos <- read.xlsx(F_XlsDataEncuestas, "infoSubcriterios")


z<-vector()
for(i in 1:numCriterios) {
  filas<-  datos[datos[1]==i]
  numFilas<- as.integer(length(filas)/3)
  filas<-  matrix(filas,ncol=3,nrow=numFilas)
  for(j in 1:numFilas) {
    col<- as.numeric( filas[j,3])
    x<- data[,numColIdEncuesta] # en la columna cuatro debe estar el identificador de encuesta
    s<-data[,col]
    z<-rbind(z,cbind(x,i,j,s))
  }
}
write.xlsx(z,file="./test.xlsx",sheetName=paste0("SatisfaccionSubcriterios",dmu),append = T)



