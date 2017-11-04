const firebase = require('firebase');

firebase.initializeApp({
    serviceAccount:"credenciales.json",
    databaseURL:"tesisiind.firebaseio.com/"

});

var xl = require('excel4node'); 
var fs = require('fs');



const keyFilename="credenciales.json"; //replace this with api key file
const projectId = "tesisiind" //replace with your project id
const bucketName = `${projectId}.appspot.com`;

const gcs = require('@google-cloud/storage')({
    projectId,
    keyFilename
});

const bucket = gcs.bucket(bucketName);



module.exports = 
{
  
    //genera el excel , corre el archivo R y sube las graficas a firebase

    generarYSubirAnalisis: function(req, res, next)
    {
       var  db = firebase.database();
        var ref = db.ref("Encuestas/"+req.params.id);
        ref.once("value", 

        function(snapshot) 
        {

            if(  snapshot.val()!=null)
            {
                    console.log('empezo la creacion de excel');
                    //se escribe el excel 
                    // Create a new workbook file in current working-path 
                    var workbook = new xl.Workbook();
                    // Create a new worksheet with 10 columns and 12 rows 
                    var sheet1 = workbook.addWorksheet('Subcriterios');
                    var sheet2 = workbook.addWorksheet('Datos1');
                    var sheet3 = workbook.addWorksheet('SatisfaccionGlobal1');
                    var sheet4 = workbook.addWorksheet('SatisfaccionCriterios1');
                    var sheet5 = workbook.addWorksheet('SatisfaccionSubcriterios1');

                    numeroCategorias = snapshot.val().categorias.length;
                    numeroClientes =snapshot.val().categorias[0].puntaje.length

                    // datos de la hoja 1 
                    sheet1.cell(1, 1).string( 'CRITERIOS');
                    sheet1.cell(1, 2).string( 'subcriterios');
                    for (var i = 1; i <= numeroCategorias-1; i++)
                    {
                        sheet1.cell(1+i, 1).number( i);
                        sheet1.cell(1+i, 2).number( snapshot.val().categorias[i-1].subCategorias.length );
                      
                    }
                       
                    //datos de la hoja 2

                    sheet2.cell(1, 1).string( 'Parametros');
                    sheet2.cell(1, 2).string( 'valor');

                    sheet2.cell(2, 1).string( 'clientes');
                    sheet2.cell(2, 2).number( numeroClientes);

                    sheet2.cell(3, 1).string( 'criterios');
                    sheet2.cell(3, 2).number( numeroCategorias-1 );

                    sheet2.cell(4, 1).string( 'alfa');
                    sheet2.cell(4, 2).number( snapshot.val().rangoEncuesta);

                    sheet2.cell(5, 1).string( 'alfaI');
                    sheet2.cell(5, 2).number( snapshot.val().rangoEncuesta);

                    sheet2.cell(6, 1).string( 'alfaIJ');
                    sheet2.cell(6, 2).number( snapshot.val().rangoEncuesta);

                    sheet2.cell(7, 1).string( 'thr');
                    sheet2.cell(7, 2).number( 2);

                    sheet2.cell(8, 1).string( 'thrCriterio');
                    sheet2.cell(8, 2).number( 0.75);

                    sheet2.cell(9, 1).string( 'thrSubcriterio');
                    sheet2.cell(9, 2).number( 0.75);

                    sheet2.cell(10, 1).string( 'e');
                    sheet2.cell(10, 2).number( 0.05);

                    //datos hoja 3

                    sheet3.cell(1, 1).string( 'CLIENTES');
                    sheet3.cell(1, 2).string( 'satGlobal');

                    for (var i = 1; i <= numeroClientes; i++)
                    {
                        sheet3.cell(i+1, 1).number( i);
                        sheet3.cell(i+1, 2).number(Number( snapshot.val().categorias[numeroCategorias-1].puntaje[i-1]));
                    }
                    
                    //datos hoja4

                    sheet4.cell(1, 1).string( 'CLIENTES');
                    sheet4.cell(1, 2).string( 'CRITERIOS');
                    sheet4.cell(1, 3).string( 'satCriterios');

                    filaActual=2 ;
                    for (var i = 1; i <= numeroCategorias-1; i++)
                    {
                      categoriaActual = i ;

                      for (var j = 1; j <= numeroClientes; j++)
                      {
                        clienteActual = j ;
                        sheet4.cell( filaActual, 1).number( clienteActual);
                        sheet4.cell( filaActual, 2).number( categoriaActual);
                        sheet4.cell( filaActual, 3).number( Number(snapshot.val().categorias[categoriaActual-1].puntaje[clienteActual-1]));
                        filaActual=filaActual+1;
                      }

                    }

                    //datos hoja 5

                    sheet5.cell(1, 1).string( 'CLIENTES');
                    sheet5.cell(1, 2).string( 'CRITERIOS');
                    sheet5.cell(1, 3).string( 'SUBCRITERIOS');
                    sheet5.cell(1, 4).string( 'satSubcriterios');

                    filaActual=2 ;
                    for (var i = 1; i <= numeroCategorias-1; i++)
                    {
                      categoriaActual = i ;
                      numeroActualSubcriterios= snapshot.val().categorias[i-1].subCategorias.length

                      for (var k = 1; k <= numeroActualSubcriterios; k++)
                      {
                        subCriterioActual = k ;

                        for (var j = 1; j <= numeroClientes; j++)
                        {
                          clienteActual = j ;
                          sheet5.cell(filaActual, 1).number( clienteActual);
                          sheet5.cell(filaActual, 2).number( categoriaActual);
                          sheet5.cell(filaActual, 3).number( subCriterioActual);
                          sheet5.cell(filaActual, 4).number( Number(snapshot.val().categorias[categoriaActual-1].subCategorias[subCriterioActual-1].puntaje[clienteActual-1]));
                          filaActual=filaActual+1;
                        }

                        
                      }
     

                    }



                    
                    workbook.write('./RMusa/Data1/SatisfacciónRtasFundamentos.xlsx');
                    console.log('termino la creacion de excel');

                    const nodeCmd = require('node-cmd');
                    nodeCmd.get('Rscript CalculosMUSA.R', (err, data, stderr) => 
                    {
                        console.log('proceso R terminado ');
                    
                        var cambio = snapshot.val();
                        //agregar infromacion creada

                        var fss = require('fs'); 
                        var parse = require('csv-parse');
                        
                        var csvData=[];
                        fss.createReadStream('C:/temp/SalidasLM/satisfaccionCriterios.csv')
                            .pipe(parse({delimiter: ':'}))
                            .on('data', function(csvrow) {
                                csvData.push(csvrow);        
                            })
                            .on('end',function() 
                            {
                              //do something wiht csvData

                             
                              for (var i in csvData) 
                              {
                                if(i>0)
                                {
                                val = csvData[i];
                                var arr = val[0].split(",");
                                
                                cambio.categorias[arr[0]-1].satisfaccion = arr[1];

                                }
                              
                              }
                              console.log(cambio);

                              var csvData2=[];
                              fss.createReadStream('C:/temp/SalidasLM/satisfaccionsubCriterios.csv')
                                  .pipe(parse({delimiter: ':'}))
                                  .on('data', function(csvrow) {
                                      csvData2.push(csvrow);        
                                  })
                                  .on('end',function() 
                                  {
                                    //do something wiht csvData
      
                                   
                                    for (var i in csvData2) 
                                    {
                                      if(i>0)
                                      {
                                      val = csvData2[i];
                                      var arr = val[0].split(",");
                                      
                                      cambio.categorias[arr[0]-1].subCategorias[arr[1]-1].satisfaccion = arr[2];
      
                                      }
                                    
                                    }
                                    console.log(cambio.categorias[1]);

                                    var csvData3=[];
                                    fss.createReadStream('C:/temp/SalidasLM/satisfaccionGlobal.csv')
                                        .pipe(parse({delimiter: ':'}))
                                        .on('data', function(csvrow) {
                                            csvData3.push(csvrow);        
                                        })
                                        .on('end',function() 
                                        {
                                          //do something wiht csvData
            
                                         
                                          for (var i in csvData3) 
                                          {
                                            if(i>0)
                                            {
                                            val = csvData3[i];
                                            
                                            cambio.satisfaccion = val[0];
            
                                            }
                                          
                                          }
                                          console.log(cambio);

                                          
                                          ref.update(cambio);

        
                                        });
  
                                  });

                            });


                        

                                
                         res.json('acabe');
                        //subir las imagenes a firebase

                        const testFolder = 'C:/temp/Graficas1';
                        const fs = require('fs');
                        
                        fs.readdir(testFolder, (err, files) => {
                          files.forEach(file => 
                            {
                            
                                var options = 
                                {
                                 destination: req.params.id + '/'+ file,
                                };
                        
                                bucket.upload('C:/temp/Graficas1/'+file ,options, function(err, fileGuardado, apiResponse) 
                                {
                        
                                    console.log('archivo '+file + ' subido exitosamente');

                                

                                    
                                });
                
                          });
                        })
                        
                      
                    });
                    
             
                 
             }

             else {

                res.json('acabe mal ');

             }







        }
        , function (errorObject) 
        {
            console.log("The read failed: " + errorObject.code);
        });

        
 
    },


     //codigo para subir un archivo firebase pero no se usa

    subirArchivo: function(req, res, next)
    {
       

        const testFolder = 'C:/temp/Graficas1';
        const fs = require('fs');
        
        fs.readdir(testFolder, (err, files) => {
          files.forEach(file => 
            {
            
                var options = 
                {
                 destination: 'direccion/'+file,
                };
        
                bucket.upload('C:/temp/Graficas1/'+file ,options, function(err, file, apiResponse) 
                {
                    
        
                });

          });
        })

       

    }


    




}