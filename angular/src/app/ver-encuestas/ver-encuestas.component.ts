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


  constructor(private servicio: Servicio) 
  { 

      var lista =  servicio.obtenerEncuestas();
      lista.forEach(element => 
        {
            element.forEach(encuesta =>
            {
              this.encuestas.push(encuesta); 
              if(encuesta.fecha==undefined)
              {
                this.encuestasVer.push(encuesta);
              }
            });
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

  categoria.mientras= res[1] ;
 

 

}




enviar()
{

  this.servicio.guardarInfo(this.llave,this.categoriasActual).then(v => 
     {
        window.location.href = 'http://localhost:4200/verencuesta'; 
    }); 

       window.alert("Datos cargados exitosamente");
       

}

guardar()
{

   this.categoriasActual.forEach(categoria => 
        {
          categoria.puntaje.push(categoria.mientras);
          if(categoria.nombre!='Satisfaccion general')
          {
            categoria.subCategorias.forEach(sub =>
            {
              sub.puntaje.push(sub.mientras); 
            });
          }
            
        });

     
       window.alert("agregado");
      this.limpiar();

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

    if(categoria.nombre!='Satisfaccion general')
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

    this.encuestas.forEach(element => 
      {
          if(element.nombreEncuesta==encuesta.nombreEncuesta && element.fecha != undefined )
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
  
    console.log(this.fecha) ;

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
