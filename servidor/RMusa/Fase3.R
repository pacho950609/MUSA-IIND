#---------------------------------------------------------------------------------------------------------------------------------------#$
#/-----------------------------FASE 3.ESTIMACI?N DE PESOS Y FUNCIONES DE SATISFACCI?N DE LOS CLIENTES ------------------------------------------- */#
#/*-----------------------------------------------------------------------------------------------------------------------------------*/#

# A partir de los resultados de los promedios de las variables se calculan los pesos promedio. Luego de realizar el analisis de estabilidad y obtener las variables de decision Zm  (??? m???Niveles de satisfaccion  global) y??? W???(ik )??? i??? Criterios,k ???Niveles de satisfaccion de cada criterio i, de
#cada uno de los criterios los de programacion lineal post optimo (uno por cada criterio que exista), desarrollados en la fase 2, se promedian para encontrar los pesos de cada uno de los criterios, los pesos de los subcriterios  y las funciones de satisfaccion  de los clientes para cad acrietrio y subcriterio, 
#asi como la funcion global.


#Pesos por criterio i bi[0,1]*/#  Se calcula como el promedio de los resultados de los pesos bi obtenidos en cada post ?ptimo

crit<-vector()
promedioBi<-vector()
for (i in 1:listParam$criterios)
{
  subs<- subset(biPostOptimo, biPostOptimo$CRITERIOS==i)
  promedioBi[i]<- mean( subs$pesosBi) #Promedio de los bi de cada suma(ni) post?ptimo 
  crit[i]<-i 
  biProm<-data.frame(criterios=crit,pesosBi=promedioBi,row.names=NULL)  #Pesos Promedios bi  
}


#Pesos de los subcriterios j del criterio i bij [0,1]*/ 
#Pesos bij-> bij {i in CRITERIOS, j in SUBCRITERIOS}:=(sum{t in 1..alfaIJ-1}wijk[i,j,t].val)/ sum{t in 1..alfaI-1}wik[i,t].val; 

#Pesos bij promedio de los suma(ni) LP postoptimos de la segunda fase

crit<-vector()
subcrit<-vector()
promedioBij<-vector()
contador<-0
for (i in 1:listParam$criterios)
{
  for(j in 1:subcriterios$subcriterios[i])
    
  {
    subs<- subset(bijPostOptimo, bijPostOptimo$CRITERIOS==i&bijPostOptimo$SUBCRITERIOS==j)
    promedioBij[j+contador]<- mean( subs$pesosBi) #peso Promedio de los bi de cada suma(ni) post?ptimo 
    crit[j+contador]<-i #criterio i
    subcrit[j+contador]<-j #subcriterio j
    bijProm<-data.frame(criterios=crit,subcriterios=subcrit,pesosBij=promedioBij,row.names=NULL)  #Pesos Promedios bi
  }
  contador<-contador+subcriterios$subcriterios[i]
}


#Funcion Xi* normalizada [0,100] para cada criterio de acuerdo a cada nivel de satisfaccion*
#xi{i in CRITERIOS, k in 2..alfaI}:=100*((sum{t in 1..k-1}wik[i,t].val)/ sum{t in 1..alfaI-1}wik[i,t].val);

crit<-vector()
nivel<-vector()
promedioXi<-vector()
contador<-0
for (i in 1:listParam$criterios)
{
  for(j in 1: listParam$alfaI)
    
  {
    subs<- subset(xiPostOptimo, xiPostOptimo$CRITERIOS==i&xiPostOptimo$NIVELESCRITERIOS==j)
    promedioXi[j+contador]<- mean( subs$funcionXi) #peso Promedio de los xi de cada suma(ni) post?ptimo 
    crit[j+contador]<-i #criterio i
    nivel[j+contador]<-j #nivel de satisfacci?n k
    xiProm<-data.frame(criterios=crit,niveles=nivel,funcionXi=promedioXi,row.names=NULL)  #Pesos Promedios bi
  }
  contador<-contador+ listParam$alfaI
}



#Funcion Xij* normalizada[0,100] para cada subcriterio j de cada criterio i en cada uno de los niveles de satisfaccion*/
# xij{i in CRITERIOS, j in SUBCRITERIOS, k in 1..alfaIJ}:= 100*(sum{t in 1..k-1} wijk[i,j,t].val)/ sum{t in 1..alfaIJ-1} wijk[i,j,t].val


crit<-vector()
subcrit<-vector()
nivel<-vector()
promedioXij<-vector()
contador<-0
for (i in 1:listParam$criterios)
{
  for( j in 1:subcriterios$subcriterios[i])
  {
    for(k in 1: listParam$alfaI)
      
    {
      subs<- subset(xijPostOptimo, xijPostOptimo$CRITERIOS==i&xijPostOptimo$SUBCRITERIOS==j& xijPostOptimo$A==k)
      promedioXij[k+contador]<- mean( subs$funcionXij) #peso Promedio de los xi de cada suma(ni) post?ptimo 
      crit[k+contador]<-i #criterio i
      subcrit[k+contador]<-j
      nivel[k+contador]<-k #nivel de satisfacci?n k
      xijProm<-data.frame(Criterios=crit,Subcriterios=subcrit,Niveles=nivel,funcionXij=promedioXij,row.names=NULL)  #Pesos Promedios bi
    }
    contador<-contador+ listParam$alfaI
  }
}


#Funcion Y* global normalizada [0,100] para cada uno de los niveles de satisfaccion global*/
# y{ m in 1..alfa}:=sum{t in 1..m-1}z[t].val;

nivel<-vector()
promedioY<-vector()
for (i in 1: listParam$alfa)
{
  subs<- subset(yPostOptimo, yPostOptimo$NIVELES==i)
  promedioY[i]<- mean( subs$funcionY) #Promedio de los bi de cada suma(ni) post?ptimo 
  nivel[i]<-i 
  yProm<-data.frame(Niveles=nivel,funcionY=promedioY,row.names=NULL)  #Pesos Promedios bi  
}

print("fin fase 3")
