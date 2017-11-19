
#---------------------------------------------------------------------------------------------#
#-----------------------FASE 5. DIAGRAMAS Y GRAFICAS DE FUNCIONES----------------------------#
##_------------------------------------------------------------------------------------------#

#----------GR?FICAS DE LAS FUNCIONES-------------------: 
#La forma de estas funciones, al momento de graficarlas, permite establecer el nivel de demanda de los clientes. Para realizar ?stas gr?ficas, se debe tener en cuenta que el eje X 
#corresponde a los niveles de satisfacci?n establecidos, mientras que el eje Y se compone del valor estandarizado de satisfacci?n, en un intervalo de [0,100] de cada nivel de satisfacci?n. 
#Los tres niveles de demanda que pueden tener diferentes grupos de clientes, son: Clientes Neutrales (lineales), Clientes Demandantes (convexa) y Clientes No demandantes (C?ncava). 

#---------Grafica funci?n de satisfaccion global--------:
#obtener el rango de los ejes x y y (x funcionY valor estandarizado de satisfacci?n)y y(niveles e satisfaccion globales alfa)

#Ruta de acceso para guardar las grÃ¡fica 
mypath <- file.path(paste0(PathGraficas,dmu),'funcionGlobal.jpg') 

jpeg(mypath)
#unir las dos gr?ficas en un solo plot
par(mfrow=c(1,2))#to create a matrix of 1 x 2 plots that are filled in by row.

xrange<-yProm$Niveles #Rango eje x
yrange<-yProm$funcionY#Rango eje y 

# Crear el plot 
plot(xrange, yrange, type="n", xlab="Niveles", ylab="Funcion Y" ) 

# agregar las lineas
lines(yProm$Niveles,yProm$funcionY, type="o", lwd=1.5, col="coral1")

# agregar titulo y subtitulo
title("Función de satisfacción")

#Histograma de frecuencias relativas
h <- hist(satGlobal$satGlobal, plot=FALSE,breaks=c(0: listParam$alfa))
h$counts=h$counts/sum(h$counts)
plot(h,main=" Histograma ",col="coral1", border="black", xlab="Niveles", ylab="Frec. Relativa")
dev.off()

#--------Gr?ficas funcion de satisfaccion por criterios----------#
#obtener el rango de los ejes x (x funcionXi valor estandarizado de satisfacci?n)y y(niveles e satisfaccion por criterios alfaI)

for( i in 1:listParam$criterios)
{
  #Ruta de acceso para guardar las grÃ¡ficas 
  mypath <- file.path(paste0(PathGraficas,dmu),paste0('funcionCriterios',i,'.jpg')) 
  jpeg(mypath)
  
  #subset que contiene  las funciones Xi para el criterio i  
  subset<-subset(xiProm, xiProm$criterios==i)
  #unir las dos gr?ficas en el mismo plot 
  attach(mtcars,warn.conflicts = FALSE)
  par(mfrow=c(1,2))#With the par( ) function, you can include the option mfrow=c(nrows, ncols) to create a matrix of nrows x ncols plots that are filled in by row. mfcol=c(nrows, ncols) fills in the matrix by columns.
  
  xrange<-subset$niveles #Rango eje x
  yrange<-subset$funcionXi #Rango eje y
  
  # Crear el plot 
  plot(xrange, yrange, type="o", xlab=paste("Niveles",sep=""), ylab=paste("Funcion X",i, sep="") )
  # agregar las lineas
  
  lines(subset$niveles,subset$funcionXi, type="o", lwd=1.5,  col=i+100)
  
  # agregar titulo y subtitulo
  title(paste("Función de satisfacción",sep=""))
  
  #Histograma de frecuencias relativas para el criterio i
  crit<-satCriterios$CRITERIOS==i
  h <- hist((subset (satCriterios,crit))$satCriterios, plot=FALSE,breaks=c(0: listParam$alfa))
  h$counts=h$counts/sum(h$counts)
  plot(h,main=paste(" Histograma",sep=""),col=i+100, border="black", xlab="Niveles", ylab="Frec. Relativa")
  detach(mtcars)
  dev.off()
}


#--------Gr?ficas funcion de satisfaccion por subcriterios----------#
#obtener el rango de los ejes x (x funcionXi valor estandarizado de satisfacci?n)y y(niveles e satisfaccion por criterios alfaI)

for( i in 1:listParam$criterios)
{
  for( j in 1:subcriterios$subcriterios[i])
  {
    
    #Ruta de acceso para guardar las grÃ¡ficas 
    mypath <- file.path(paste0(PathGraficas,dmu),paste0('funcionCriterios',i,'subcriterio ',j,'.jpg')) 
    jpeg(mypath)
    
    #subset que contiene  las funciones Xi para el criterio i  
    subset<-subset(xijProm, xijProm$Criterios==i & xijProm$Subcriterios==j)
    #unir las dos gr?ficas en el mismo plot 
    attach(mtcars,warn.conflicts = FALSE)
    par(mfrow=c(1,2))#With the par( ) function, you can include the option mfrow=c(nrows, ncols) to create a matrix of nrows x ncols plots that are filled in by row. mfcol=c(nrows, ncols) fills in the matrix by columns.
    
    xrange<-subset$Niveles #Rango eje x
    yrange<-subset$funcionXij #Rango eje y
    
    # Crear el plot 
    plot(xrange, yrange, type="o", xlab=paste("Niveles",sep=""), ylab=paste("Funcion X",i,j, sep=""))
    # agregar las lineas
    
    lines(subset$Niveles,subset$funcionXij, type="o", lwd=1.5,  col=j+1+cont)
    
    # agregar titulo y subtitulo
    title(paste("Función de satisfacción",sep=""))
    
    #Histograma de frecuencias relativas para el criterio i
    crit<-satSubcriterios$CRITERIOS==i & satSubcriterios$SUBCRITERIOS==j
    h <- hist((subset (satSubcriterios,crit))$satSubcriterios, plot=FALSE,breaks=c(0:listParam$alfa))
    h$counts=h$counts/sum(h$counts)
    plot(h,main=paste(" Histograma ",jsep=" "),col=j+1+cont, border="black", xlab="Niveles", ylab="Frec. Relativa")
    detach(mtcars)
    dev.off()
  }
  cont<-cont+subcriterios$subcriterios[i]
}

#---------------------------------------------------------#
#-----------------------------  Diagramas-----------------# 
#---------------------------------------------------------#

#----------------------1.Diagramas de Acci?n------------------#.

#Este tipo de diagrama combina los pesos (bi) y los ?ndices medios de satisfacci?n (S) para indicar puntos fuertes y d?biles de la satisfacci?n del cliente,
#y definir los esfuerzos de mejora necesarios para aumentarla, (Grigoroudis & Siskos, 2010), similar a los an?lisis DOFA (Fortalezas Debilidades-Oportunidades-Amenazas). Los diagramas est?n divididos en cuadrantes, en funci?n del desempe?o (Alto/bajo) y la importancia (alta/baja) que puede ser usado para clasificar las acciones. 

#Los cuadrantes son:
#Status quo (bajo desempe?o/baja importancia): Por lo general, no requiere ninguna acci?n, teniendo en cuenta que estas dimensiones de satisfacci?n no se consideran tan importante por los clientes.
#Aprovechar la oportunidad competitiva (alto desempe?o/alta importancia): Esta ?rea puede ser utilizada como ventaja frente a la competencia. En varios casos, los criterios de satisfacci?n ubicados en este espacio son considerados las razones m?s importantes por las que los clientes han comprado el producto o servicio bajo estudio (o en este caso las razones que tienen los estudiantes para escoger la Universidad de  Los Andes).
#Transferencia de los recursos (alto desempe?o/baja importancia): Los recursos invertidos para el manejo de los criterios ubicados en este cuadrante, podr?an estar siendo mejor utilizados en otros criterios.
#Oportunidad de Acci?n o de mejora (bajo desempe?o/alta importancia): Estos son los criterios que necesitan atenci?n de manera inmediata y centrar en ellos los esfuerzos de mejora.


#---##Diagrama de accion relativo##-----#
#--------------------------------------##


#------CRITERIOS-----#

#Eje x: Importancia  biPrima{ i in Criterios} ;=(bi[i]-bBarra)/(raiz(suma (i in criterios)(bi[i]-bBarra)^2))
#Eje y: desempe?o    siPrima{ i in Criterios }:=(si[i]-sBarra)/(raiz(suma (i in criterios)(si[i]-sBarra)^2))


bBarra<-mean(biProm$pesosBi) #Promedio de los pesos bi
sBarra<-mean(indiceSatisfaccionCriterios$IndiceSatisfaccion) #Promedio de los indices de satisfacci?n por criterio i (Si)
numEjeX<-c() #Vector correspondiente al numerador del eje Importancia (bi[i]-bBarra)
denEjeX<-c() #Vector correspondiente al denominador del eje Importancia (bi[i]-bBarra)^2
bPrima<-c() #bPrima ( valor para el eje X)
numEjeY<-c() #Vector correspondiente al numerador del eje Desempe?o (si[i]-sBarra)
denEjeY<-c() #Vector correspondiente al denominador del eje Desempe?o (si[i]-sBarra)^2
sPrima<-c() #sPrima ( valor para el eje y)

for ( i in 1:listParam$criterios)
{
  numEjeX[i]<-(biProm$pesosBi[i]-bBarra) #Calculo de cada peso menos el promedio bBarra
  denEjeX[i]<-(numEjeX[i])^2 #Calculo de cada peso menos el promedio bBarra al cuadrado
  numEjeY[i]<-(indiceSatisfaccionCriterios$IndiceSatisfaccion[i]-sBarra) #Calculo de cada peso menos el promedio bBarra
  denEjeY[i]<-(numEjeY[i])^2 #Calculo de cada peso menos el promedio bBarra al cuadrado
  
}
#C?lculo de los valores para el eje x y para el eje y
for( i in 1:listParam$criterios)
{
  bPrima[i]<-numEjeX[i]/(sqrt(sum(denEjeX))) #Valor del criterio i en el eje X Importancia: bPrima
  sPrima[i]<-numEjeY[i]/(sqrt(sum(denEjeY))) #Valor del criterio i en el eje y Desempe?o: sPrima
}

#matriz con los resultados bPrima y Sprima para cad auno de lso criterios
diagramaAccionCriterios<-as.data.frame(cbind(criterios=c(1:listParam$criterios),bPrima=bPrima,sPrima=sPrima))

#Ruta de acceso para guardar las grÃ¡ficas 
mypath <- file.path(paste0(PathGraficas,dmu),'diagramaAccionRelativoCriterios.jpg')
jpeg(mypath)

#Dibujar los c?rculos de cada criterio en el diagrama 
symbols(diagramaAccionCriterios$bPrima,diagramaAccionCriterios$sPrima,circles=rep(0.03,each=nrow(diagramaAccionCriterios)),xlab="Importancia",ylab="Desempeño",inches=FALSE,bg = 100:(100+nrow(diagramaAccionCriterios)),xlim=c(-1,1),ylim=c(-1.5,1.5))

#DIvidir el cuadrante en 4
abline(h = 0, col = "black")
abline(v = 0, col = "black")

# add a legend 
text(diagramaAccionCriterios$bPrima,diagramaAccionCriterios$sPrima, labels=paste("Criterio ",as.data.frame(diagramaAccionCriterios)$criterios),pos=2, cex = 0.7, offset = 0.6)
legend(0.4,1.4,legend="Oportunidad Competitiva\nalto desempeño/alta importancia",xjust=0.5,yjust=0.5,text.font=2,cex=0.7,box.lwd=-0.0001)
legend(0.5,-1.4,legend="Oportunidad de mejora  \n bajo desempeño/alta importancia",xjust=0.5,yjust=0.5,text.font=2,cex=0.7,box.lwd=-0.0001)
legend(-0.5,-1.4,legend="Status Quo \n bajo desempeño/importancia",xjust=0.5,yjust=0.5,text.font=2,cex=0.7,box.lwd=-0.0001) 
legend(-0.5,1.4,legend="Transferir Recursos alto \n desempeño/baja importancia",xjust=0.5,yjust=0.5,text.font=2,cex=0.7,box.lwd=-0.0001)

dev.off()


#------SUBCRITERIOS-----#

#Eje x: Importancia  bijPrima{ i in Criterios,j in subcriterios} ;=(bij[i,j]-bijBarra)/(raiz(suma (i in criterios, j in subcriterios)(bij[i,j]-bijBarra)^2))
#Eje y: desempe?o    siPrima{ i in Criterios, j in subcriterios }:=(sij[i,j]-sijBarra)/(raiz(suma (i in criterios, j in subcriterios)(sij[i,j]-sijBarra)^2))


bijBarra<-mean(bijProm$pesosBij) #Promedio de los pesos bij
sijBarra<-mean(indiceSatisfaccionSubcriterios$IndiceSatisfaccion) #Promedio de los indices de satisfacci?n porsubcriterio j y criterio i (Sij)
numEjeX<-c() #Vector correspondiente al numerador del eje Importancia (bi[i]-bBarra)
denEjeX<-c() #Vector correspondiente al denominador del eje Importancia (bi[i]-bBarra)^2
bijPrima<-c() #bijPrima ( valor para el eje X)
numEjeY<-c() #Vector correspondiente al numerador del eje Desempe?o (si[i]-sBarra)
denEjeY<-c() #Vector correspondiente al denominador del eje Desempe?o (si[i]-sBarra)^2
sijPrima<-c() #sijPrima ( valor para el eje y)

contador<-0
for ( i in 1:listParam$criterios)
{
  for (j in 1:subcriterios$subcriterios[i])
  {
    numEjeX[j+contador]<-(subset(bijProm, bijProm$criterios==i& bijProm$subcriterios==j )$pesosBij-bijBarra) #Calculo de cada peso menos el promedio bBarra
    denEjeX[j+contador]<-(numEjeX[j+contador])^2 #Calculo de cada peso menos el promedio bBarra al cuadrado
    numEjeY[j+contador]<-(indiceSatisfaccionSubcriterios$IndiceSatisfaccion[j+contador]-sijBarra) #Calculo de cada peso menos el promedio bBarra
    denEjeY[j+contador]<-(numEjeY[j+contador])^2 #Calculo de cada peso menos el promedio bBarra al cuadrado
  }  
  contador<-contador+subcriterios$subcriterios[i]
}
#C?lculo de los valores para el eje x y para el eje y
contador<-0
for( i in 1:listParam$criterios)
{
  for (j in 1:subcriterios$subcriterios[i])
  {
    bijPrima[j+contador]<-numEjeX[j+contador]/(sqrt(sum(denEjeX))) #Valor del criterio i en el eje X Importancia: bPrima
    sijPrima[j+contador]<-numEjeY[j+contador]/(sqrt(sum(denEjeY))) #Valor del criterio i en el eje y Desempe?o: sPrima
    
  }
  contador<-contador+subcriterios$subcriterios[i]
}
#matriz con los resultados bPrima y Sprima para cad auno de lso criterios
diagramaAccionSubcriterios<-as.data.frame(cbind(criterios=indiceSatisfaccionSubcriterios$Criterio, subcriterios=indiceSatisfaccionSubcriterios$Subcriterio,bijPrima=bijPrima,sijPrima=sijPrima))


#Ruta de acceso para guardar las grÃ¡ficas 
mypath <- file.path(paste0(PathGraficas,dmu),'diagramaAccionRelativoSubcriterios.jpg')
jpeg(mypath)

#Dibujar los c?rculos de cada criterio en el diagrama 
symbols(diagramaAccionSubcriterios$bijPrima,diagramaAccionSubcriterios$sijPrima,circles=rep(0.03,each=nrow(diagramaAccionSubcriterios)),xlab="Importancia",ylab="Desempe?o",inches=FALSE,bg = 100:(100+nrow(diagramaAccionCriterios)),xlim=c(-1,1), ylim=c(-1.5,1.5))

#DIvidir el cuadrante en 4
abline(h = 0, col = "black")
abline(v = 0, col = "black")

# add a legend 
#text(diagramaAccionSubcriterios$bijPrima,diagramaAccionSubcriterios$sijPrima, labels=paste("Criterio ",diagramaAccionSubcriterios$criterios),pos=2, cex = 0.6, offset = 0.6)
legend(0.45,1.4,legend="Oportunidad Competitiva\nalto desempeño/alta importancia",xjust=0.5,yjust=0.5,text.font=2,cex=0.7,box.lwd=-0.001)
legend(0.45,-1.4,legend="Oportunidad de mejora  \n bajo desempeño/alta importancia",xjust=0.5,yjust=0.5,text.font=2,cex=0.7,box.lwd=-0.001)
legend(-0.45,-1.4,legend="Status Quo \n bajo desempeño/baja importancia",xjust=0.5,yjust=0.5,text.font=2,cex=0.7,box.lwd=-0.001) 
legend(-0.45,1.4,legend="Transferir Recursos alto \n desempeño/baja importancia",xjust=0.5,yjust=0.5,text.font=2,cex=0.7,box.lwd=-0.001)

dev.off()




#------------------------2.Diagramas de mejora----------------#
#En los diagramas de mejora (Figura 2) se determina la magnitud de los esfuerzos de mejora y la prioridad teniendo en cuenta otros criterios, combinando para ello los ?ndices promedio de demanda  (D) y de mejora (I) (Grigoroudis & Siskos, 2010). 
#Los cuadrantes son: 
#-  Prioridad 1 (Poco esfuerzo/ Alta efectividad): en este cuadrante se deben enfocar todas las acciones directas de mejora.
#-  Prioridad 2 (Poco esfuerzo/Poca efectividad o Alto esfuerzo/Alta efectividad): comprende criterios de satisfacci?n que tienen, ya sea un bajo ?ndice de demanda o un alto ?ndice de mejora.
#-	Prioridad 3 (Alto esfuerzo/Poca efectividad): se refiere a las dimensiones de satisfacci?n que tienen m?rgenes de mejora peque?os y un esfuerzo considerable.

#------CRITERIOS-----#

#Eje x: Efectividad  IiPrima{ i in Criterios} ;=(Ii[i]-IBarra)/(raiz(suma (i in criterios)(Ii[i]-IBarra)^2))
#Eje y: Demanda-Esfuerzo  D{ i in Criterios}:=indiceDemandaCriterios[i]


IBarra<-mean(indicePromedioMejoraCriterios$indiceMejora) #Promedio de los indices de mejora para cada criterio 
numEjeX<-c() #Vector correspondiente al numerador del eje Efectividad(Ii[i]-IBarra)
denEjeX<-c() #Vector correspondiente al denominador del eje Efectividad (Ii[i]-IBarra)^2
IPrima<-c() #IPrima ( valor para el eje X)

for ( i in 1:listParam$criterios)
{
  numEjeX[i]<-(indicePromedioMejoraCriterios$indiceMejora[i]-IBarra) #Calculo de cada indice de mejora de cada criterio i menos el promedio IBarra
  denEjeX[i]<-(numEjeX[i])^2 #Calculo de cada indice de mejora (I)de cada criterio i menos el promedio IBarra al cuadrado
  
}
#C?lculo de los valores para el eje x y para el eje y
for( i in 1:listParam$criterios)
{
  IPrima[i]<-numEjeX[i]/(sqrt(sum(denEjeX))) #Valor del criterio i en el eje X Efectividad: IPrima=Ii[i]-IBarra)/(raiz(suma (i in criterios)(Ii[i]-IBarra)^2))
}

#matriz con los resultados bPrima y Sprima para cad auno de lso criterios
diagramaMejoraCriterios<-as.data.frame(cbind(criterios=indicePromedioMejoraCriterios$Criterios,IPrima=IPrima,IndiceDemanda=indiceDemandaCriterios$indiceDemandaCriterio))

mypath <- file.path(paste0(PathGraficas,dmu),'diagramaMejoraRelativoCriterios.jpg')
jpeg(mypath)

#Dibujar los c?rculos de cada criterio en el diagrama 
symbols(diagramaMejoraCriterios$IPrima,diagramaMejoraCriterios$IndiceDemanda,circles=rep(0.04,each=nrow(diagramaMejoraCriterios)),xlab="Efectividad",ylab="Demanda-Esfuerzo",inches=FALSE,bg = 100:(100+nrow(diagramaMejoraCriterios)),xlim=c(-1,1),ylim=c(-1.5,1.5))

#DIvidir el cuadrante en 4
abline(h = 0, col = "black")
abline(v = 0, col = "black")

# add a legend 
text(diagramaMejoraCriterios$IPrima,diagramaMejoraCriterios$IndiceDemanda, labels=paste("Criterio ",diagramaMejoraCriterios$criterios),pos=1, cex = 0.7, offset =1)
legend(0.45,1.4,legend="Prioridad 2\n (Alto esfuerzo/Alta efectividad)",xjust=0.5,yjust=0.5,text.font=2,cex=0.7,box.lwd=-0.001)
legend(0.45,-1.4,legend="Prioridad 1 \n(Poco esfuerzo/ Alta efectividad)",xjust=0.5,yjust=0.5,text.font=2,cex=0.7,box.lwd=-0.001)
legend(-0.45,-1.4,legend="Prioridad 2 \n(Poco esfuerzo/Poca efectividad)",xjust=0.5,yjust=0.5,text.font=2,cex=0.7,box.lwd=-0.001) 
legend(-0.45,1.4,legend="Prioridad 3 \n(Alto esfuerzo/Poca efectividad)",xjust=0.5,yjust=0.5,text.font=2,cex=0.7,box.lwd=-0.001)

dev.off()

# Gr?fica de mejora relativa sin tener en cuenta los l?mites para EL EJE X Y Y  xlim=(-1,1), ylim=(-1,1)
mypath <- file.path(paste0(PathGraficas,dmu),'diagramaMejoraRelativoCriterios2.jpg')
jpeg(mypath)

#Dibujar los c?rculos de cada criterio en el diagrama 
symbols(diagramaMejoraCriterios$IPrima,diagramaMejoraCriterios$IndiceDemanda,circles=rep(0.04,each=nrow(diagramaMejoraCriterios)),xlab="Efectividad",ylab="Demanda-Esfuerzo",inches=FALSE,bg = 100:(100+nrow(diagramaMejoraCriterios)))

#DIvidir el cuadrante en 4
abline(h = 0, col = "black")
abline(v = 0, col = "black")

# add a legend 
text(diagramaMejoraCriterios$IPrima,diagramaMejoraCriterios$IndiceDemanda, labels=paste("Criterio ",diagramaMejoraCriterios$criterios),pos=1, cex = 0.7, offset =1)
legend(0.45,0.3,legend="Prioridad 2\n (Alto esfuerzo/Alta efectividad)",xjust=0.5,yjust=0.5,text.font=2,cex=0.55,box.lwd=-0.001)
legend(0.45,-0.4,legend="Prioridad 1 \n(Poco esfuerzo/ Alta efectividad)",xjust=0.5,yjust=0.5,text.font=2,cex=0.55,box.lwd=-0.001)
legend(-0.6,-0.5,legend="Prioridad 2 \n(Poco esfuerzo/Poca efectividad)",xjust=0.5,yjust=0.5,text.font=2,cex=0.54,box.lwd=-0.001) 
legend(-0.45,0.2,legend="Prioridad 3 \n(Alto esfuerzo/Poca efectividad)",xjust=0.5,yjust=0.5,text.font=2,cex=0.55,box.lwd=-0.001)

dev.off()


#------SUBCRITERIOS-----#

#Eje x: Efectividad  IiPrima{ i in Criterios} ;=(Iij[i.j]-IijBarra)/(raiz(suma (i in criterios,j in subcriterios[i])(Iij[i]-IijBarra)^2))
#Eje y: Demanda-Esfuerzo  D{ i in Criterios}:=indiceDemandaCriterios[i]


IijBarra<-mean(indicePromedioMejoraSubcriterios$indiceMejora) #Promedio de los indices de mejora para cada criterio 
numEjeX<-c() #Vector correspondiente al numerador del eje Efectividad(Ii[i]-IBarra)
denEjeX<-c() #Vector correspondiente al denominador del eje Efectividad (Ii[i]-IBarra)^2
IijPrima<-c() #IPrima ( valor para el eje X)
contador<-0
for ( i in 1:listParam$criterios)
{
  for(j in 1:subcriterios$subcriterios[i])
  {
    numEjeX[j+contador]<-(indicePromedioMejoraSubcriterios$indiceMejora[j+contador]-IijBarra) #Calculo de cada indice de mejora de cada criterio i y cada subcriterio j menos el promedio IijBarra
    denEjeX[j+contador]<-(numEjeX[j+contador])^2 #Calculo de cada indice de mejora (I)de cada criterio i y cada subcriterio j menos el promedio IijBarra al cuadrado
    
  }
  contador<-contador+subcriterios$subcriterios[i]
}
#C?lculo de los valores para el eje x y para el eje y
contador<-0
for( i in 1:listParam$criterios)
{
  for(j in 1:subcriterios$subcriterios[i])
  {
    IijPrima[j+contador]<-numEjeX[j+contador]/(sqrt(sum(denEjeX))) #Valor del criterio i y subcriterio j en el eje X Efectividad: IijPrima=Iij[i,j]-IijBarra)/(raiz(suma (i in criterios, j in subcriterios[i])(Iiji[i,j]-IBarra)^2))
  }
  contador<-contador+subcriterios$subcriterios[i]
}

#matriz con los resultados bPrima y Sprima para cad auno de lso criterios
diagramaMejoraSubcriterios<-as.data.frame(cbind(criterios=indicePromedioMejoraSubcriterios$Criterios,subcriterios=indicePromedioMejoraSubcriterios$subcriterios,IijPrima=IijPrima,IndiceDemanda=indiceDemandaSubcriterios$indiceDemandaSub))

for(i in 1:listParam$criterios)
{
  mypath <- file.path(paste0(PathGraficas,dmu),paste0("diagramaMejoraRelativoSubcriterios Criterio",i,".jpg"))
  jpeg(mypath)
  
  #Dibujar los c?rculos de cada criterio en el diagrama 
  symbols(subset(diagramaMejoraSubcriterios, diagramaMejoraSubcriterios$criterios==i)$IijPrima,subset(diagramaMejoraSubcriterios, diagramaMejoraSubcriterios$criterios==i )$IndiceDemanda,circles=rep(0.06,each=nrow(subset(diagramaMejoraSubcriterios, diagramaMejoraSubcriterios$criterios==i ))),xlab="Efectividad",ylab="Demanda-Esfuerzo",inches=FALSE,bg = 100:(100+nrow(subset(diagramaMejoraSubcriterios, diagramaMejoraSubcriterios$criterios==i ))),ylim=c(-1.5,1.5),xlim=c(-1,1))
  
  #Dividir el cuadrante en 4
  
  abline(h = 0, col = "black")
  abline(v = 0, col = "black")
  
  # add a legend 
  text(subset(diagramaMejoraSubcriterios, diagramaMejoraSubcriterios$criterios==i)$IijPrima,subset(diagramaMejoraSubcriterios, diagramaMejoraSubcriterios$criterios==i)$IndiceDemanda, labels=paste("sub",subset(diagramaMejoraSubcriterios, diagramaMejoraSubcriterios$criterios==i)$subcriterios),pos=1,text.font=10, cex = 0.7, offset =1)
  legend(0.4,1.4,legend="Prioridad 2\n (Alto esfuerzo/Alta efectividad)",xjust=0.5,yjust=0.5,text.font=2,cex=0.7,box.lwd=-0.001)
  legend(0.4,-1.4,legend="Prioridad 1 \n(Poco esfuerzo/ Alta efectividad)",xjust=0.5,yjust=0.5,text.font=2,cex=0.7,box.lwd=-0.001)
  legend(-0.6,-1.4,legend="Prioridad 2 \n(Poco esfuerzo/Poca efectividad)",xjust=0.5,yjust=0.5,text.font=2,cex=0.7,box.lwd=-0.001) 
  legend(-0.6,1.4,legend="Prioridad 3 \n(Alto esfuerzo/Poca efectividad)",xjust=0.5,yjust=0.5,text.font=2,cex=0.7,box.lwd=-0.001)
  
  dev.off()
  
}


###--------Funci?n de valor para las respuestas de las encuestas----##
#Se transforma el resultado o juicio de  cada cliente en las encuestas a nivel global, criterio y subcriterio seg?n el resultadoo de la funci?n de valor

satGlobalFuncionTran<-data.frame(satGlobal$CLIENTES,0)
colnames(satGlobalFuncionTran)<-c("Clientes","satGlobal")
satCriteriosFuncionTran<-data.frame( satCriterios$CLIENTES,satCriterios$CRITERIOS,0)
colnames(satCriteriosFuncionTran)<-c("Clientes","Criterios","satCriterios")
satSubcriteriosFuncionTran<-data.frame( satSubcriterios$CLIENTES,satSubcriterios$CRITERIOS,satSubcriterios$SUBCRITERIOS,0)
colnames(satSubcriteriosFuncionTran)<-c("Clientes","Criterios","Subcriterios","satSubcriterios")

#Resultados encuestas a nivel global transformadas al valor de la funci?n de valor.
#Donde 1 equivale a 0 y alfa equivale a 100
for( k in 1: listParam$alfa)
{
  satGlobalFuncionTran$satGlobal[which(satGlobal$satGlobal == k, arr.ind=TRUE)]=yProm$funcionY[k]
}

#Resultados encuestas a nivel de criterios transformadas al valor de la funci?n de valor.
#Donde 1 equivale a 0 y alfaI equivale a 100  
for ( i in 1:listParam$criterios)
{
  for( k in 1: listParam$alfaI)
  {
    satCriteriosFuncionTran$satCriterios[which(subset(satCriterios, CRITERIOS == i, select = c(CLIENTES,CRITERIOS,satCriterios))$satCriterios== k, arr.ind=TRUE)+listParam$clientes*(i-1)]=subset(xiProm,(criterios==i& niveles==k),select=funcionXi)
  }
}
#Resultados encuestas a nivel de subcriterios transformadas al valor de la funci?n de valor.
#Donde 1 equivale a 0 y alfaIJ equivale a 100 
contador<-0
for ( i in 1:listParam$criterios)
{
  for( j in 1:subcriterios$subcriterios[i])
  {
    for( k in 1: listParam$alfaI)
    {
      satSubcriteriosFuncionTran$satSubcriterios[which(subset(satSubcriterios,( CRITERIOS == i & SUBCRITERIOS==j), select = c(CLIENTES,CRITERIOS,SUBCRITERIOS,satSubcriterios))$satSubcriterios== k, arr.ind=TRUE)+listParam$clientes*contador]=subset(xijProm,(Criterios==i& Subcriterios==j & Niveles==k),select=funcionXij)
    }
    contador<-contador+1
  } 
}

#Promedios de los resultados o juicios de los clientes a nivel de global, criterios y subcriterios
mean(satGlobalFuncionTran$satGlobal)
aggregate(unlist(satCriteriosFuncionTran$satCriterios),list(satCriteriosFuncionTran$Criterios),FUN=mean)
meanSubcriteriosFun<-aggregate(unlist(satSubcriteriosFuncionTran$satSubcriterios),list(satSubcriteriosFuncionTran$Criterios,satSubcriteriosFuncionTran$Subcriterios),FUN=mean)
meanSubcriteriosFun<-meanSubcriteriosFun[ order(meanSubcriteriosFun$Group.1),]
colnames(meanSubcriteriosFun)<-c("criterios","subcriterios","xijPromTran")

#Agregar los resultados de los indices de satisfacci?n (S), demanda(D) y mejora (I) para cada sucursal. 
resumenResultadosIndiceTotal<-c(resumenResultadosIndiceTotal,as.list(resumenResultadosIndices))

#creo imagen de los pesos de los criterios

library(gridExtra)
mypath <- file.path(paste0(PathGraficas,dmu),'pesoCriterios.jpg')
jpeg(mypath)
             
grid.table(head(indiceSatisfaccionCriterios))
dev.off()



print("fin fase 5")

