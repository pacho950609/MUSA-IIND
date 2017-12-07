##------------------------------------------------------------------------------------------------##
#---------------------------------------------FASE 4. INDICES---------------------------------------------##
##-----------------------------------------------------------------------------------------------##
# El uso de estos indices y diagramas son de especial utilidad en el modelo porque permiten identificar prioridades y posibles mejoras, 
#asi como los criterios mas relevantes segun la opinion de los clientes.

#-------------Lectura de datos-------------#




#------------------ ?ndices respecto a los resultados del modelo-----------------------#

##----------------------------------------------------------------##
#---------------------Indice promedio de satisfaccion (S)-------------##

#Se obtiene una medida normalizada del desempe?o  global,por criterios y por subcriterios, que corresponden, basicamente, la media de las funciones globales o marginales de valor  normalizado en el intervalo [0, 100%], 
#teniendo en cuenta la frecuencia relativa de los clientes que se?alaron cierto nivel de satisfaccion en la encuesta y el valor normalizado de dicho nivel (Grigoroudis & Siskos, 2010).

#----GLOBAL------#
#calcular el histograma de frecuencias relativas para el desempe?o global (satisf global)

FrecuenciaRelativaGlobal<-cbind( NivelSatisfaccion= nivelsatisfaccion<-c(1: listParam$alfa),Freq=tabulate(satGlobal$satGlobal,nbins = listParam$alfa),relative=prop.table(tabulate(satGlobal$satGlobal,nbins = listParam$alfa)))
#Calculo del indice promedio de satisfaccion global: La frecuencia relativa de cada nivel de satifaccion alfa se debe multiplicar por la fucnion Y de cada nivel. El resultado obtenido se suma obteniendo el indice deseado.
#s=(1/100)*suma(k in 1:alfa)frecuenciaRelativa(k)* FuncionY(k) 
indiceSatisfaccionGlobal<-0
for(k in 1: listParam$alfa)
  
{ indiceSatisfaccionGlobal<-sum(c(indiceSatisfaccionGlobal,FrecuenciaRelativaGlobal[k,3]*yProm$funcionY[k]))}
indiceSatisfaccionGlobal<-indiceSatisfaccionGlobal/100


#----CRITERIOS------#
#Calcular el histograma de frecuencias relativas para cda uno de los criterios i (satisf criterios i)
FrecuenciaRelativaCriterios<-c(1: listParam$alfaI)

for( i in 1:listParam$criterios)
{  
  satCriterioActual<-vector()
  for(j in 1:nrow(satCriterios) )
  { 
    if(satCriterios$CRITERIOS[j]==i)
    {
      satCriterioActual<-append(satCriterioActual,satCriterios$satCriterios[j])
    }
  }
  FrecuenciaRelativaCriterios<-cbind(FrecuenciaRelativaCriterios,criterio=c(i:i),Freq=tabulate(satCriterioActual,nbins = listParam$alfa),relative=prop.table(tabulate(satCriterioActual,nbins = listParam$alfa)))
  
  #
}
FrecuenciaRelativaCriterios<-FrecuenciaRelativaCriterios[,-1]
dim(FrecuenciaRelativaCriterios)<-c( listParam$alfaI,3,listParam$criterios) # Divide la matriz en 3 dimensiones: por criterios muestra la frecuencia para cada nivel de satisfacci?n
colnames(FrecuenciaRelativaCriterios)=c("Criterio","Frecuencia","Frecuencia relativa")

#Calculo del indice promedio de satisfaccion para cada criterio i: La frecuencia relativa de cada nivel de satifaccion alfaI de cada criterio i se debe multiplicar por la fucnion Xi de criterio i. El resultado obtenido se suma obteniendo el indice deseado.
#si{i in Criterios} := (1/100)*suma(k in 1:alfaI)frecuenciaRelativa(i,k)* FuncionXi(i,k)

indiceSatisfaccionCriterios<-matrix(0,nrow=listParam$criterios, ncol=2)
colnames(indiceSatisfaccionCriterios)=c("Criterio","IndiceSatisfaccion")
cont<-0
for( i in 1:listParam$criterios)
{  
  for(k in 1: listParam$alfaI)
  { indiceSatisfaccionCriterios[i,1]<-i
  indiceSatisfaccionCriterios[i,2]<-sum(c(indiceSatisfaccionCriterios[i,2],FrecuenciaRelativaCriterios[k,3,i]*xiProm$funcionXi[k+cont]))
  }    
  cont<-cont+ listParam$alfaI
}
indiceSatisfaccionCriterios[,2]<-indiceSatisfaccionCriterios[,2]/100
indiceSatisfaccionCriterios<-as.data.frame(indiceSatisfaccionCriterios)

#----SUBCRITERIOS------#

#calcular el histograma de frecuencias relativas para cda uno de los subcriterios j del criterios i (satisf subcriterios j)
FrecuenciaRelativaSubcriterios<-c(1: listParam$alfaIJ)

for( i in 1:listParam$criterios)
{
  satSubcriterioActual<-vector()
  for( j in 1:subcriterios$subcriterios[i])
  {
    
    for(k in 1:nrow(satSubcriterios) )
    { 
      if(satSubcriterios$CRITERIOS[k]==i && satSubcriterios$SUBCRITERIOS[k]==j ) #se guardan el resultado para el criterio i subcriterio j en un vector 
      {
        satSubcriterioActual<-append(satSubcriterioActual,satSubcriterios$satSubcriterios[k])
      }
    }
    #Hallar tabla de frecuencia relativa y frecuencia absoluta para la satiafacci?n de subcriterios
    FrecuenciaRelativaSubcriterios<-cbind( FrecuenciaRelativaSubcriterios,criterio=c(i:i),subcriterio=c(j:j),Freq=tabulate(satSubcriterioActual,nbins = listParam$alfa),relative=prop.table(tabulate(satSubcriterioActual,nbins = listParam$alfa)))
    
    #histogramaCriterio<-histogram(satCriterioActual,freq=TRUE,main=paste("Satisfaccion Criterio",i,sep=""), xlab="Niveles de satisfaccion")  
    #histogramaCriterio
    
  }
}
FrecuenciaRelativaSubcriterios<-FrecuenciaRelativaSubcriterios[,-1]
dim(FrecuenciaRelativaSubcriterios)<-c( listParam$alfaIJ,4,sum(subcriterios$subcriterios))
colnames(FrecuenciaRelativaSubcriterios)=c("Criterio", "Subcriterio", "Frecuencia","Frecuencia relativa") 

#Calculo del indice promedio de satisfaccion para cada subcriterio j del criterio i: La frecuencia relativa de cada nivel de satifaccion alfaIJ de cada subcriterio j del criterio i se debe multiplicar por la funcion Xij del subcriterio j del criterio i. El resultado obtenido se suma obteniendo el indice deseado.
#sij{i in Criterios, j in subcriterios} :=suma(k in 1:alfaI)frecuenciaRelativa(i,j,k)* FuncionXi(i,j,k) 

indiceSatisfaccionSubcriterios<-matrix(0,nrow=sum(subcriterios$subcriterios), ncol=3)
colnames(indiceSatisfaccionSubcriterios)=c("Criterio","Subcriterio","IndiceSatisfaccion")
cont<-0
cont2<-0
for( i in 1:listParam$criterios)
{  
  for (j in 1:subcriterios$subcriterios[i])
  {
    for(k in 1: listParam$alfaIJ)
    { 
      indiceSatisfaccionSubcriterios[j+cont,1]<-i
      indiceSatisfaccionSubcriterios[j+cont,2]<-j
      indiceSatisfaccionSubcriterios[j+cont,3]<-sum(c(indiceSatisfaccionSubcriterios[j+cont,3],FrecuenciaRelativaSubcriterios[k,4,j+cont]*xijProm$funcionXij[k+cont2]))
    }  
    
    cont2<-cont2+ listParam$alfaIJ
  }
  cont<-cont+subcriterios$subcriterios[i]
}

indiceSatisfaccionSubcriterios[,3]<-indiceSatisfaccionSubcriterios[,3]/100
indiceSatisfaccionSubcriterios<-as.data.frame(indiceSatisfaccionSubcriterios)

##----------------------------------------------------------------##
#---------------------Indice promedio de demanda (D)-------------##
#Es una medida cuantitativa del nivel de demanda de los estudiantes, utilizado en el analisis de comportamiento de los clientes. 
#Tambien pueden indicar la magnitud de los esfuerzos de mejora de la compa?ia: cuanto mayor sea el valor del indice, el nivel de satisfaccion de los clientes debe ser mejorado con el fin de cumplir con sus expectativas.
#Este indice esta normalizado en el intervalo [-1,1] y se halla de manera global y parcial (para cada criterio de satisfaccion). Los casos posibles son:
#D = 1 o Di = 1: Los clientes tienen el maximo nivel de demanda, 
#D = 0 o Di = 0   Este caso se refiere a los clientes neutrales 
#D =-1 o Di =- 1: Los clientes tienen el nivel minimo de demanda.

#-----GLOBAL-----#
#Calculo del indice promedio de demanda (D) para la satisfaccion global de los clientes


#EL Y barra se refiere al promedio de la funcion de satisfaccion promedio YProm. 
yBarra<-mean(yProm$funcionY)
#Indice de demanda Global (D) =(1-(yBarra/50))/(1-(2/alfa)). 
indiceDemandaGlobal<-(1-(yBarra/50))/(1-(2/ listParam$alfa))

#-----CRITERIOS-----#
#Calculo del indice promedio de demanda (D)  del criterio i 


#El Xi barra se refiere al promedio de la funcion de satisfaccion promedio XiProm del criterio i. AL usar la funcion aggregate se calcula la media por grupos (criterios) 
xiBarra<-aggregate(xiProm$funcionXi,list(xiProm$criterios),mean)
colnames(xiBarra)<-c("Criterios","xiBarra")

#Indice de demanda por criterios (Di){i in Criterios} :=(1-(xBarra[i]/50))/(1-(2/alfaI)). 
indiceDemandaCriterios<-matrix(nrow=listParam$criterios,ncol=2)
colnames(indiceDemandaCriterios)<-c("Criterios","indiceDemandaCriterio")
for(i in 1:listParam$criterios)
{
  indiceDemandaCriterios[i,1]<-i
  indiceDemandaCriterios[i,2]<-(1-(xiBarra$xiBarra[i]/50))/(1-(2/ listParam$alfaI))
}
indiceDemandaCriterios<-as.data.frame(indiceDemandaCriterios)

#-----SUBCRITERIOS-----#
#Calculo del indice promedio de demanda (D) de cada  subcriterio j del criterio i 


#El Xij barra se refiere al promedio de la funcion de satisfaccion promedio XijProm del subcriterio j del criterio i. AL usar la funcion aggregate se calcula la media por grupos (criterios, subcriterios) 
xijBarra<-aggregate(xijProm$funcionXij,list(xijProm$Criterios,xijProm$Subcriterios),mean)
colnames(xijBarra)<-c("Criterios","subcriterios","xijBarra")
xijBarra<-xijBarra[order(xijBarra$Criterios,decreasing=FALSE),] # reorganizar la tabla en orden creciente seg?n los criterios. 

#Indice de demanda por subcriterios (Dij){i in Criterios, j in subcriterios} :=(1-(xijBarra[i,j]/50))/(1-(2/alfaIJ)). 
indiceDemandaSubcriterios<-matrix(nrow=sum(subcriterios$subcriterios),ncol=3)
cont<-0

for(i in 1:listParam$criterios)
{
  for(j in 1:subcriterios$subcriterios[i])
  {  
    
    indiceDemandaSubcriterios[j+cont,1]<-i
    indiceDemandaSubcriterios[j+cont,2]<-j
    indiceDemandaSubcriterios[j+cont,3]<-(1-(xijBarra$xijBarra[j+cont]/50))/(1-(2/ listParam$alfaIJ))
  }
  cont<-cont+subcriterios$subcriterios[i]
  
}
colnames(indiceDemandaSubcriterios)<-c("Criterios","subcriterios","indiceDemandaSub")
indiceDemandaSubcriterios<-as.data.frame(indiceDemandaSubcriterios)


##----------------------------------------------------------------##
#---------------------Indice promedio de mejora (I)-------------##

#Los indices promedio de mejora muestran los margenes de mejora que debe tener la organizacion en un criterio especifico.
#Depende de la importancia de cada una de las dimensiones de satisfaccion (peso bi de cada criterio) y su contribucion a la satisfaccion (nivel de satisfaccion actual de cada criterio Si).
#Est?n normalizados en el intervalo [0,1]

#--CRITERIOS----#

#Calculo del indice promedio de mejora(Ii) para cada uno de lso criterios i 
#I{i in criterios}:=bi[i]*(1-S[i]). DOnde S[i] hace referencia al indice promedio de satisfaccion del criterio i 

indicePromedioMejoraCriterios<-matrix(nrow= listParam$criterios,ncol=2)
colnames(indicePromedioMejoraCriterios)<-c("Criterios","indiceMejora")
for(i in 1: listParam$criterios)
{
  indicePromedioMejoraCriterios[i,1]<-i
  indicePromedioMejoraCriterios[i,2]<-biProm$pesosBi[i]*(1-indiceSatisfaccionCriterios[i,2])
}
indicePromedioMejoraCriterios<-as.data.frame(indicePromedioMejoraCriterios)
#------SUBCRITERIOS-----#

#Calculo del indice promedio de mejora(Ii) para cada uno de lso criterios i 
#I{i in criterios}:=bi[i]*(1-S[i]). DOnde S[i] hace referencia al indice promedio de satisfaccion del criterio i 

indicePromedioMejoraSubcriterios<-matrix(nrow=sum(subcriterios$subcriterios),ncol=3)
colnames(indicePromedioMejoraSubcriterios)<-c("Criterios","subcriterios","indiceMejora")
cont<-0
for(i in 1: listParam$criterios)
{
  for( j in 1:subcriterios$subcriterios[i])
  {
    indicePromedioMejoraSubcriterios[j+cont,1]<-i
    indicePromedioMejoraSubcriterios[j+cont,2]<-j
    indicePromedioMejoraSubcriterios[j+cont,3]<-bijProm$pesosBij[j+cont]*(1-indiceSatisfaccionSubcriterios[j+cont,3])
  }
  cont<-cont+subcriterios$subcriterios[i]
}
indicePromedioMejoraSubcriterios<-as.data.frame(indicePromedioMejoraSubcriterios)

##-----------Resumen Indices ---------------#
##------------------------------------------#

#Tabla de resumen que contiene  los pesos y los tres indices para la satisfacci?n global, criterio i y subcriterio j

#Vector con los tres indices para la satisfacci?n global 
resulGlobal<-matrix(nrow=1,ncol=4)
colnames(resulGlobal)<-c(paste("Peso sucursal ",dmu,sep=""),paste("Indice Satisfaccion(S) sucursal ",dmu,sep=""), paste("Indice Demanda(D) sucursal ",dmu,sep=""),paste("Indice Mejora(I) sucursal ",dmu,sep=""))
resulGlobal[1,1] <- " - " 
resulGlobal[1,2] <- indiceSatisfaccionGlobal
resulGlobal[1,3]<- indiceDemandaGlobal
resulGlobal[1,4]<- " - " 

#Matriz  con los tres indices y el peso de cada criterio i
resulCriterios<-matrix(nrow=listParam$criterios,ncol=5)
colnames(resulCriterios)<-c("Criterio ", paste("Peso sucursal ",dmu,sep=""),paste("Indice Satisfaccion(S) sucursal ",dmu,sep=""), paste("Indice Demanda(D) sucursal ",dmu,sep=""),paste("Indice Mejora(I) sucursal ",dmu,sep=""))
for ( i in  1:listParam$criterios)
{
  resulCriterios[i,1]<-i
  resulCriterios[i,2]<-biProm$pesosBi[i]
  resulCriterios[i,3]<-indiceSatisfaccionCriterios[i,2]
  resulCriterios[i,4]<-indiceDemandaCriterios[i,2]
  resulCriterios[i,5]<-indicePromedioMejoraCriterios[i,2]
}

#Matriz  con los tres indices y el peso de cada criterio i
resulSubcriterios<-matrix(nrow=sum(subcriterios$subcriterios),ncol=6)
colnames(resulSubcriterios)<-c("Criterio ","Subcriterio  ",paste("Peso sucursal ",dmu,sep=""),paste("Indice Satisfaccion(S) sucursal ",dmu,sep=""), paste("Indice Demanda(D) sucursal ",dmu,sep=""),paste("Indice Mejora(I) sucursal ",dmu,sep=""))
cont<-0
for ( i in  1:listParam$criterios)
{ 
  for(j in 1:subcriterios$subcriterios[i])
  {
    resulSubcriterios[j+cont,1]<-i
    resulSubcriterios[j+cont,2]<-j   
    resulSubcriterios[j+cont,3]<-bijProm$pesosBij[j+cont]
    resulSubcriterios[j+cont,4]<-indiceSatisfaccionSubcriterios[j+cont,3]
    resulSubcriterios[j+cont,5]<-indiceDemandaSubcriterios[j+cont,3]
    resulSubcriterios[j+cont,6]<-indicePromedioMejoraSubcriterios[j+cont,3]
    
  }
  cont<-cont+subcriterios$subcriterios[i]
}

#Tabla con el resumen total: Contiene  los pesos y los tres indices para la satisfacci?n global, criterio i y subcriterio j
resumenResultadosIndices<-as.data.frame(rbind(resulGlobal, resulCriterios[,-1],resulSubcriterios[,c(-1,-2)],row.names=NULL))


#creo excel con las satisfacciones 
write.csv(file=file.path(pathTempDatos,"satisfaccionCriterios.csv"), x=indiceSatisfaccionCriterios, row.names = F, quote = FALSE)
write.csv(file=file.path(pathTempDatos,"satisfaccionsubCriterios.csv"), x=indiceSatisfaccionSubcriterios, row.names = F, quote = FALSE)
write.csv(file=file.path(pathTempDatos,"satisfaccionGlobal.csv"), x=indiceSatisfaccionGlobal, row.names = F, quote = FALSE)



print("fin fase 4")
