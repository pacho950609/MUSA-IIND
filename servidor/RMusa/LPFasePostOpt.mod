# Satisfaccion de Clientes de un servicio que proporciona  una organizacion empresarial, teniendo en cuenta tres criterios Producto, proceso de compra y servicios  adicionales con tres subcriterios cada uno 


# Problema de Programaci?n lineal Post Optimo!
/*-------------------------------*/
/*PAR?METROS INCIALES*/
/*-----------------------------*/
param criterios; /*Numero de criterios de satisfacci?n*/
param alfa; /* Cantidad de niveles de satisfacci?n global */
param alfaI; /* Cantidad de niveles de satisfacci?n con respecto a cada criterio i */
param alfaIJ; /* Cantidad de niveles de satisfacci?n de subcriterios j*/

/*-----------------------------*/
/*CONJUNTOS*/
/*-----------------------------*/


/* Conjunto de estudiantes  indexado en q*/
set CLIENTES;

/*  Conjunto de  Criterios indexado en i */
set CRITERIOS;

/*  Conjunto de  Niveles de satisfaccion indexado en k ( criterios ) o m ( global) */
set NIVELES:=1..alfa;

/*  Conjunto de  Niveles de satisfaccion indexado en k ( criterios ) o m ( global) */
set NIVELESCRITERIOS:=1..alfaI;

/*  Conjunto de  Niveles de satisfaccion indexado en k ( criterios ) o m ( global) */
set NIVELESSUBCRITERIOS:=1..alfaIJ;

/*satisfaccion por cliente y poir criterio*/
set K dimen 2;

/*satisfaccion por cliente por criterio y por subcriterios*/
set C dimen 3;



/*-----------------------------*/
/*PARAMETROS*/
/*-----------------------------*/
/* Nivel de Satisfacci?n global del estudiante j */
param satisfaccionGlobal {i in CLIENTES}>=0;

/* Nivel de Satisfacci?n del estudiante j para el criterio i*/
param satisfaccionCriterios {i in CLIENTES, j in CRITERIOS} >=0;


/*Umbral de preferencia para la funci?n de satisfacci?n global */
param thr>=0;

/*Umbral de preferencia para la funci?n de satisfacci?n de cada criterio i**/
param thrCriterio>=0;

/*Umbral de preferencia para la funci?n de satisfacci?n de cada subcriterio k **/
param thrSubcriterio>=0;

/*subcriterios por cada criterio */
param subcriteriosPorCriterio {j in CRITERIOS}>=0;
table tab_subc IN "CSV" "subcriterios.csv":
  CRITERIOS<-[CRITERIOS], subcriteriosPorCriterio~subcriterios;

/*------CONJUNTOS  INDEXADOS--------*/
/*  Conjunto de subcriterios indexado en j*/
set SUBCRITERIOS{i in CRITERIOS} :={1..subcriteriosPorCriterio[i]};

/* Nivel de Satisfacci?n del estudiante j para el criterio i y el subcriterio k*/
param satisfaccionSubcriterios{i in CLIENTES,j in CRITERIOS,k in SUBCRITERIOS[j]}>=0;

/*error */
param error;

/* Criterio a maximizar: Al ir cambiando el n?mero de criterio, la fucni?n objetivo maximizara el peso del criterio escogifo  actualmente: La informaci?n del criterio actual proviene desde R */
param criterioAmaximizar;

/* SubCriterio a maximizar: Al ir cambiando el n?mero de criterio, la fucni?n objetivo maximizara el peso del criterio escogifo  actualmente: La informaci?n del subcriterio actual proviene desde R */
param subCriterioAmaximizar;


/*-----------------------------*/
/*DATOS*/
/*-----------------------------*/


table tab_global IN "CSV" "satGlobal.csv":
  CLIENTES<-[CLIENTES], satisfaccionGlobal~satGlobal;
  
table tab_criterios IN "CSV" "satCriterios.csv" :
  K <- [CLIENTES,CRITERIOS], satisfaccionCriterios ~ satCriterios;
  
table tab_subcriterios IN "CSV" "satSubcriterios.csv":
  C <-[CLIENTES, CRITERIOS,SUBCRITERIOS], satisfaccionSubcriterios~ satSubcriterios;
  
/*
display CRITERIOS;
display CLIENTES;
display{i in CRITERIOS}SUBCRITERIOS[i];
display card(C);
display{i in CRITERIOS} card(SUBCRITERIOS[i]);
*/


/*-----------------------------*/
/*VARIABLES*/
/*-----------------------------*/

/*  Error de sobreestimaci?n para cada cliente j*/
var sigmaPos {CLIENTES} >=0;

/*  Error de subestimaci?n para cada cliente j*/
var	sigmaNeg {CLIENTES} >=0;

/*  Error de sobreestimaci?n para cada cliente j en el criterio i*/
var	sigmaPosCriterio {CLIENTES,CRITERIOS}>=0;

/*  Error de subestimaci?n para cada cliente j en el criterio i*/
var	sigmaNegCriterio {CLIENTES,CRITERIOS}>=0;


/*  Diferencia de la funci?n de satisfacci?n Xi* en el nivel K  respecto al nivel k+1 ( entre dos niveles sucesivos) */
var wik{CRITERIOS, j in 1..(alfaI-1)}>=0;
var wik1{CRITERIOS, j in 1..(alfaI-1)}>=0;

/*  Diferencia de la funci?n de satisfacci?n Xij* en el nivel K  respecto al nivel k+1 ( entre dos niveles sucesivos) */
var wijk{i in CRITERIOS,j in SUBCRITERIOS[i],k in 1..(alfaIJ-1)}>=0;
var wijk1{i in CRITERIOS,j in SUBCRITERIOS[i],k in 1..(alfaIJ-1)}>=0;
/*  Diferencia de la funci?n de satisfacci?n Y* en el nivel K  respecto al nivel k+1 ( entre dos niveles sucesivos) */
var z {j in 1..(alfa-1)}>=0;
var z1{j in 1..(alfa-1)}>=0;

/*Porcentaje de error de Fprima */
param e;

/*FUNCI?N OBJETIVO */ 
/*  Minimizar la suma de los errores*/

maximize MaximizarSubcriterio: sum{k in 1..alfaIJ-1} wijk[criterioAmaximizar,subCriterioAmaximizar,k];


/*-----------------------------*/
/*RESTRICCIONES*/
/*-----------------------------*/
s.t. s{j in 1..(alfa-1)}:z1[j]=z[j]-thr;
s.t.s1{i in CRITERIOS, j in 1..(alfaI-1)}:wik1[i,j]=wik[i,j]-thrCriterio;
s.t. s2{i in CRITERIOS,j in SUBCRITERIOS[i],k in 1..(alfaIJ-1)}:wijk1[i,j,k]=wijk[i,j,k]-thrSubcriterio;

/* Ecuacion de regresion ordinal- consistencia maxima entre la funcion de valor Y * y los juicios de los clientes Y.  */
s.t. regresion{q in CLIENTES}: sum{i in CRITERIOS,k in 1..satisfaccionCriterios[q,i]-1} wik1[i,k]- sum{ m in 1..satisfaccionGlobal[q]-1}z1[m]- sigmaPos[q]+ sigmaNeg[q] = thr*( satisfaccionGlobal[q]-1)-sum{i in CRITERIOS}(thrCriterio*(satisfaccionCriterios[q,i]-1));

/* Ecuacion de regresion ordinal- consistencia maxima entre la funcion de valor Xi * y los juicios de los clientes 1 por cada criterio i Xi.  */
s.t.regresion2{q in CLIENTES, i in CRITERIOS}:sum{j in SUBCRITERIOS[i], k in 1..satisfaccionSubcriterios[q,i,j]-1}wijk1[i,j,k]-sum{k in 1..satisfaccionCriterios[q,i]-1}(wik1[i,k])-sigmaPosCriterio[q,i]+sigmaNegCriterio[q,i]= (thrCriterio*(satisfaccionCriterios[q,i]-1))-sum{j in SUBCRITERIOS[i]}thrSubcriterio*(satisfaccionSubcriterios[q,i,j]-1);


/* Limitaciones para la normalizacion Y^*  en el intervalo [0, 100], */
s.t. NormalizacionZ:sum{m in 1..alfa-1} z1[m] = 100-(thr*(alfa-1));

/* Limitaciones para la normalizacion Xi^*  en el intervalo [0, 100], */
s.t. NormalizacionXi: sum{i in CRITERIOS ,k in 1..alfaI-1} wik1[i,k] = 100 -(card(CRITERIOS)*thrCriterio*(alfaI-1));
display((card(CRITERIOS)*thrCriterio*(alfaI-1)));

/* Limitaciones para la normalizacion Xij^*  en el intervalo [0, 100], */
s.t. NormalizacionXij: sum{i in CRITERIOS,j in SUBCRITERIOS[i],k in 1.. alfaIJ-1} wijk1[i,j,k]=100-(sum{i in CRITERIOS, j in SUBCRITERIOS[i]}(thrSubcriterio*(alfaIJ-1)));
 display(sum{i in CRITERIOS, j in SUBCRITERIOS[i]}(thrSubcriterio*(alfaIJ-1)));

 /* espacio de solucion optima*/
s.t.solucion: sum{q in CLIENTES} (sigmaPos[q]+ sigmaNeg[q])+ sum{q in CLIENTES, i in CRITERIOS}((1/ card(CRITERIOS))*(sigmaPosCriterio[q,i]+sigmaNegCriterio[q,i])) <=error* (1 + e);

/*Solve*/
solve;

/*-----------------------------*/
/*TRANSFORMACI?N DE VARIABLES */
/*-----------------------------*/

/*Pesos por criterio i bi[0,1]*/
param bi{i in CRITERIOS}:=(1/100)*sum{t in 1..alfaI-1}wik[i,t].val;

/*Funcion Xi* normalizada [0,100] para cada criterio de acuerdo a cada nivel de satisfaccion*/

param xi {i in CRITERIOS, k in 1..alfaI}:=if sum{t in 1..alfaI-1}wik[i,t].val==0 then 0 
else 100*((sum{t in 1..k-1}wik[i,t].val)/ sum{t in 1..alfaI-1}wik[i,t].val);

/*Pesos de los subcriterios j del criterio i bij [0,1]*/

param bij {i in CRITERIOS, j in SUBCRITERIOS[i]}:= if sum{t in 1..alfaI-1}wik[i,t].val==0 then 0
else (sum{t in 1..alfaIJ-1}wijk[i,j,t].val)/ sum{t in 1..alfaI-1}wik[i,t].val; 

/*Funcion Xij* normalizada[0,100] para cada subcriterio j de cada criterio i en cada uno de los niveles de satisfaccion*/
param xij{i in CRITERIOS, j in SUBCRITERIOS[i], k in 1..alfaIJ}:= 
    if sum{t in 1..alfaIJ-1}wijk[i,j,t].val=0 then 0
   else 100*(sum{t in 1..k-1} wijk[i,j,t].val)/ sum{t in 1..alfaIJ-1} wijk[i,j,t].val;

/*Funcion Y* global normalizada [0,100] para cada uno de los niveles de satisfaccion global*/
param y{ m in 1..alfa}:=sum{t in 1..m-1}z[t].val;


/*-----------------------------*/
/*Output*/
/*-----------------------------*/

/*
printf "\n";
printf "\n";
printf "Libro con subcriterios \n";
printf "\n";
printf "---------------------\n";
printf "wik \n";
printf "---------------------\n";
  display{i in CRITERIOS, k in 1..alfaI-1}: i, k, wik[i,k].val;
printf "\n";

printf "---------------------\n";
printf "Wijk \n";
printf "---------------------\n";
  display {i in CRITERIOS,j in SUBCRITERIOS[i], k in 1..alfaIJ-1}: i,j, k, wijk[i,j,k];
printf "\n";

printf "---------------------\n";
printf "Variables Originales\n";
printf "---------------------\n";


printf "\n";
printf "Pesos bi \n";
printf "---------------\n";
  display{i in CRITERIOS}: i,bi[i];

printf "\n";

printf "---------------------\n";
printf "Pesos bij \n";
printf "---------------------\n";
 display{ i in CRITERIOS, j in SUBCRITERIOS[i]}: i,j,  bij[i,j];

printf "\n";
printf "---------------------\n";
printf "Funciones Xi* \n";
printf "---------------------\n";
  display{i in CRITERIOS, k in NIVELESCRITERIOS}: i, k, xi[i,k];


printf "\n";
printf "---------------------\n";
printf "Funciones Xij* \n";
printf "---------------------\n";
  display{ i in CRITERIOS, j in SUBCRITERIOS[i], k in NIVELESSUBCRITERIOS}:i,j,k, xij[i,j,k];

printf "\n";
printf "---------------------\n";
printf "Funcion global Y* \n";
printf "---------------------\n";
 display {m in NIVELES}:m,y[m];
*/ 
 
 
/*-----------------------------*/
 /*OUTPUT*/ 

table tab_result{i in CRITERIOS} OUT "CSV" "resultadoBi.csv" :
  i ~ CRITERIOS, bi[i] ~ pesosBi;
  
table tab_result{i in CRITERIOS, j in SUBCRITERIOS[i]} OUT "CSV" "resultadoBij.csv" :
  i ~ CRITERIOS, j ~ SUBCRITERIOS, bij[i,j] ~ pesosBij;

table tab_result {i in CRITERIOS, j in NIVELESCRITERIOS} OUT "CSV" "resultadoXi.csv" :
  i ~ CRITERIOS, j ~ NIVELESCRITERIOS, xi[i,j] ~ funcionXi;
  
table tab_result{i in CRITERIOS, j in SUBCRITERIOS[i],k in NIVELESSUBCRITERIOS} OUT "CSV" "resultadoXij.csv" :
  i ~ CRITERIOS, j ~ SUBCRITERIOS, k ~A, xij[i,j,k] ~ funcionXij;

table tab_result{m in NIVELES} OUT "CSV" "resultadoY.csv" :
  m ~ NIVELES,y[m]~funcionY;


 

/*INICIALIZACI?N DE DATOS
data;
  param alfa:=5;
  param alfaI:=5;
  param alfaIJ:=5;
  param thr:=2;
  param thrCriterio:=0.75;
  param thrSubcriterio:=0.75;
  param error:=233.09375;
  param criterioAmaximizar:=2;
  param subCriterioAmaximizar:=3;
  param e:=0.05;

end;
*/
