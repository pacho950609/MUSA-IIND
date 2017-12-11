import { Component, OnInit } from '@angular/core';
import {Servicio} from '../servicios/servicio';

@Component({
  selector: 'app-ver-encuestas',
  templateUrl: './ver-encuestas.component.html',
  styleUrls: ['./ver-encuestas.component.css'],
   providers: [Servicio]
})
export class VerEncuestasComponent implements OnInit {

  encuestaPadre : any ;
  llavePadre : string ;
  fecha:any ;
  encuestas = new Array(); 
  encuestasDelPeriodo = new Array(); 
  encuestasVer = new Array(); 

  categoriasActual = new Array() ;
  fechaActual : any ; 
  nombreActual :string ;
  rangoActual : string ;
  fakeArray : any ;
  llave : string ;


  sexo : string ;
  tipoUsuario : string ;


  constructor(private servicio: Servicio) 
  { 
      var i = 0;
      var lista =  servicio.obtenerEncuestas();
      lista.forEach(element => 
        {
          
            element.forEach(encuesta =>
            {
            
               if(i==0)
              {

                this.encuestas.push(encuesta); 
                if(encuesta.fecha==undefined && encuesta.eliminado==undefined )
                {
                  this.encuestasVer.push(encuesta);
                }
             }
            });

            i=1 ;
        });
      

  }


  createRange(number){
  var items: number[] = [];
  for(var i = 1; i <= number; i++){
     items.push(i);
  }
  return items;
}

seleccion(event,categoria)
{
  var target = event.target || event.srcElement || event.currentTarget;
  var idAttr = target.attributes.id;
  var value = idAttr.nodeValue;
  var res = value.split("-");
  var i ;

  for (i = 1; i < this.rangoActual+1; i++) 
  { 

    document.getElementById(res[0]+'-'+i).className='form-control';
   
  }

     
  document.getElementById(value).className='btn btn-success';
  

  if(categoria.puntaje== undefined)
  {
  categoria.puntaje =new Array();
  }
  if(categoria.encuesta== undefined)
  {
  categoria.encuesta =new Array();
  }

  categoria.mientras= res[1] ;
 

 

}

eliminar()
{

  var r = confirm("¿ Estas seguro que deseas eliminar la información de este mes ? Con el mes también se eliminarán todas las encuestas de este periodo.");
  if (r == true) {

    this.servicio.eliminarInfo(this.llave).then(v => 
      {
         window.location.href = 'http://localhost:4200/verencuesta'; 
     }); 
     
  } else {
      
  }
}

eliminarTodo()
{

  var r = confirm("¿ Estas seguro que deseas eliminar la encuesta ? Con esta opcion eliminaras todos los periodos y toda su informacion.");
  if (r == true) {

    this.servicio.eliminarInfo(this.llavePadre).then(v => 
      {
         window.location.href = 'http://localhost:4200/verencuesta'; 
     }); 
     
  } else {
      
  }

}


enviar()
{

  this.categoriasActual

  this.servicio.guardarInfo(this.llave,this.categoriasActual).then(v => 
     {
        window.location.href = 'http://localhost:4200/verencuesta'; 
    }); 

       window.alert("Datos cargados exitosamente");
       

}

dirigir()
{

  window.location.href = 'http://localhost:4200/linkencuesta/'+this.llave+'/'+this.llavePadre+'/'+this.fechaActual; 

}


guardar()
{

  var completo = true ;
  var i ;
  this.categoriasActual.forEach(categoria => 
    {
      if(completo)
      {
    
        var fila = false ;
        for( i = 1 ; i<= Number(this.rangoActual) ; i++)
        {
          
          if(document.getElementById(categoria.nombre+'-'+i).className=="btn btn-success")
          {
            fila = true ;
          }
        }
          completo = fila ;
      }
    });

    if ( this.sexo==undefined ||this.sexo=="")
    {
      completo=false ;
    }
    if ( this.tipoUsuario==undefined ||this.tipoUsuario=="")
    {
      completo=false ;
    }

    if(completo)
    {

      this.categoriasActual.forEach(categoria => 
        {
          if(categoria.nombre!="Satisfacción general")
          {
            categoria.subCategorias.forEach(sub =>
              {
                  if(completo)
                  {
                  
                    var fila = false ;
                    for( i = 1 ; i<= Number(this.rangoActual) ; i++)
                    {
                  
                      if(document.getElementById(categoria.nombre+'+'+sub.nombre+'-'+i).className=="btn btn-success")
                      {
                        fila = true ;
                      }
                    }

                    completo = fila ;

                 }

              });

          }
        
           
            
        });


    }

  


if(completo)
{
   this.categoriasActual.forEach(categoria => 
        {
          categoria.puntaje.push(categoria.mientras);
          if(categoria.nombre!='Satisfacción general')
          {
            categoria.subCategorias.forEach(sub =>
            {
              sub.puntaje.push(sub.mientras);  
            
              
              
            });
          }
          else{

            var datos={
              sexo : this.sexo,
              tipoUsuario : this.tipoUsuario
            }
            categoria.encuesta.push(datos)
          }
            
        });

     
       window.alert("agregado");
      this.limpiar();

}

else
{

  window.alert("es necesario completar la encuesta");


}

}

limpiar()
{

   this.categoriasActual.forEach(categoria => 
        {
          
              var i ;

              for (i = 1; i < this.rangoActual+1; i++) 
            { 
              var categoriaLimpiar= categoria.nombre;
              document.getElementById(categoriaLimpiar+'-'+i).className='form-control';
            
            }

    if(categoria.nombre!='Satisfacción general')
          {
            categoria.subCategorias.forEach(sub =>
            {
                  var j ;

              for (j = 1; j < this.rangoActual+1; j++) 
            { 
              var subcategoriaLimpiar= categoria.nombre+'+'+sub.nombre;
              document.getElementById(subcategoriaLimpiar+'-'+j).className='form-control';
            
            }



              
          });
          
          }
            
        });

 


}


  verPeriodos(encuesta)
  {

    this.encuestasDelPeriodo = new Array(); 
    this.encuestaPadre=encuesta ;
    this.llavePadre=encuesta.$key ;
    console.log(this.llavePadre);

    this.encuestas.forEach(element => 
      {
          if(element.nombreEncuesta==encuesta.nombreEncuesta && element.fecha != undefined && element.eliminado==undefined )
          {
            this.encuestasDelPeriodo.push(element);
          }
      });
 

  }

  verEncuesta(encuestaActual)
  {
    this.categoriasActual= encuestaActual.categorias;
    this.nombreActual = encuestaActual.nombreEncuesta;
    this.rangoActual = encuestaActual.rangoEncuesta;
    this.fechaActual = encuestaActual.fecha;
    this.fakeArray =  new Array(this.rangoActual);
    this.llave = encuestaActual.$key;
  }


  agregarPeriodo()
  {
  
  

    var objeto=
    {
        categorias: this.encuestaPadre.categorias,
        nombreEncuesta :this.encuestaPadre.nombreEncuesta,
        rangoEncuesta : this.encuestaPadre.rangoEncuesta,
        fecha : this.fecha
    }


    this.servicio.guardarEncuesta(objeto).then(v => 
    {
      window.location.href = 'http://localhost:4200/verencuesta'; 
    }); 
    
    window.alert("Encuesta agregada exitosamente");
  
  
  }


  


  ngOnInit() {
  }
 
}
