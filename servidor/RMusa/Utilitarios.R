# fileModelo <- F_ModPostOptimo
# fileParametros <- F_ParamMusaGen
library(glpkAPI)

solveGlpkModelMusaFase <- function (fileModelo, fileParametros, pathData)
{
  #set a directory
  pathActual <- getwd()
  setwd(pathData)  #lugar donde están los datos a analizar
  
  #Allocate workspace
  workspace<- initProbGLPK();
  
  #give a name
  setProbNameGLPK(workspace, "MusaModel");
  
  # Allocate space
  a<- mplAllocWkspGLPK();
  
  # Read glpk model
  model <- mplReadModelGLPK(a, fileModelo, skip=1);
  
  # Read data
  data<-mplReadDataGLPK(a, fileParametros)
  
  # Generate the model
  result<- mplGenerateGLPK(a);
  
  # Build the problem object using result
  result <- mplBuildProbGLPK(a, workspace)
  
  # Number of constraints(including objective function) 
  numrows <- getNumRowsGLPK(workspace)
  
  # Solve the model
  return <- solveSimplexGLPK(workspace) 
  
  #PostSolve the model
  return <- mplPostsolveGLPK(a, workspace, GLP_PRIMAL);
  
  # Get solutions
  fobj<-getRowPrimGLPK (workspace,1) 
  #Funci?n objetivo Minimizaci?n de la suma de los errores absolutos
  
  # Free the workspace 
  mplFreeWkspGLPK(a)
  delProbGLPK(workspace)
  
  setwd(pathActual)
  
  return(fobj)
}



crearFileParametros <- function (fileDatosIn, fileParametrosOut)
{
  datos <- read.csv(fileDatosIn)
  listParam <- list(
    clientes = datos[1,2], #numero de clientes encuestados
    criterios= datos[2,2], #numero de criterios de satisfaccion
    alfa = datos[3,2], #Nivel de satisfacci?n global
    alfaI= datos[4,2], #Nivel de satisfacci?n parcial Criterios
    alfaIJ=datos[5,2], #Nivel de satisfacci?n parcial subcriterios
    thr=datos[6,2], #Threshold global (Umbral de preferencia)
    thrCriterio=datos[7,2], #Threshold Parcial (Umbral de preferencia criterios)
    thrSubcriterio=datos[8,2], #Threshold Parcial (Umbral de preferencia subcriterios)
    e = datos[9,2]  #par?metro de Error para definir el espacio de b?squeda del heur?stico en la fase 2 de estabilidad. 
  )
  # Escribir a archivo de parametros
  cat("/*Data del modelo .mod*/ \n data; \n", file= fileParametrosOut, append=FALSE)
  cat("   param alfa:=",listParam$alfa,";", "\n", file=fileParametrosOut, append=TRUE)
  cat("   param alfaI:=",listParam$alfaI,";", "\n", file=fileParametrosOut, append=TRUE)
  cat("   param alfaIJ:=",listParam$alfaIJ,";", "\n", file=fileParametrosOut, append=TRUE)
  cat("   param thr:=",listParam$thr,";", "\n", file=fileParametrosOut, append=TRUE)
  cat("   param thrCriterio:=",listParam$thrCriterio,";", "\n", file=fileParametrosOut, append=TRUE)
  cat("   param thrSubcriterio:=",listParam$thrSubcriterio,";", "\n", file=fileParametrosOut, append=TRUE)
  cat(" end;", "\n", file=fileParametrosOut, append=TRUE)

  return(listParam)
}

#Funci?n para crear el output de los principales data frame en Excel. Los guarda en varias hojas de un mismo archivo xlsx
# save.xlsx <- function (file, ...)
# {
#     require(xlsx, quietly = TRUE)
#     objects <- list(...)
#     fargs <- as.list(match.call(expand.dots = TRUE))
#     objnames <- as.character(fargs)[-c(1, 2)]
#     nobjects <- length(objects)
#      for (i in 1:nobjects) 
#       {
#         if (i == 1)
#         write.xlsx(objects[[i]], file, sheetName = objnames[i])
#          else write.xlsx(objects[[i]], file, sheetName = objnames[i],append = TRUE)
#        }
#     print(paste("Workbook", file, "has", nobjects, "worksheets."))
# }

