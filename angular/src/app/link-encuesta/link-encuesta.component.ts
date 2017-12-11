import { Component, OnInit } from '@angular/core';
import {Servicio} from '../servicios/servicio';
import {ActivatedRoute} from '@angular/router'

@Component({
  selector: 'app-link-encuesta',
  templateUrl: './link-encuesta.component.html',
  styleUrls: ['./link-encuesta.component.css'],
  providers: [Servicio]
})
export class LinkEncuestaComponent implements OnInit {

  llave : string ;
  categorias = new Array() ;
  nombreencuesta :string;
  rangoencuesta:string ;
  fecha:string ;
  fakeArray : any ;
  categoriasReal = new Array();


  llavePadre:string ;

  sexo : string ;
  tipoUsuario : string ;


  constructor(private route: ActivatedRoute , private servicio:Servicio) 
  {
   
   }

   actualizar()
   {
    var i = 0;
    var lista =  this.servicio.obtenerEncuestas();
    lista.forEach(element => 
      {
        
          element.forEach(encuesta =>
          {
            
            if(encuesta.$key==this.llave && i==0)
            {
              i=1;  
              this.categoriasReal=encuesta.categorias;
              console.log(this.categoriasReal);
             
              this.enviar();
            }
          });
      });
   }

   enviar()
   {

   

    var completo = true ;
    var i ;
    this.categorias.forEach(categoria => 
      {
        if(completo)
        {
      
          var fila = false ;
          for( i = 1 ; i<= Number(this.rangoencuesta) ; i++)
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
  
        this.categorias.forEach(categoria => 
          {
       
            if(categoria.nombre!="Satisfacción general" && categoria.subCategorias!=undefined)
            {

              categoria.subCategorias.forEach(sub =>
                {
                    if(completo)
                    {
                    
                      var fila = false ;
                      for( i = 1 ; i<= Number(this.rangoencuesta) ; i++)
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
  
    
  
  var j ;
  if(completo)
  {
    
    for( i = 0 ; i< this.categorias.length ; i++)
    {
      if(this.categoriasReal[i].puntaje==undefined)
      {
        this.categoriasReal[i].puntaje =new Array();
     
      }
      if(this.categoriasReal[i].encuesta==undefined)
      {
       
        this.categoriasReal[i].encuesta =new Array();
      }
      this.categoriasReal[i].puntaje.push( this.categorias[i].puntaje);

      if(i==this.categorias.length-1)
      {
        var datos={
          sexo : this.sexo,
          tipoUsuario : this.tipoUsuario
        }
        this.categoriasReal[i].encuesta.push(datos)
      }
     
      for( j = 0 ; i<this.categorias.length-1 && j< this.categorias[i].subCategorias.length ; j++)
      {
        if(this.categoriasReal[i].subCategorias[j].puntaje==undefined)
        {
          this.categoriasReal[i].subCategorias[j].puntaje=new Array();
        }
        this.categoriasReal[i].subCategorias[j].puntaje.push(this.categorias[i].subCategorias[j].puntaje);
        
      }
  


    }



      
    this.servicio.guardarInfoLink(this.llave,this.categoriasReal).then(v => 
      {
         this.nombreencuesta=undefined ;
         
     }); 
         window.alert("agregado");
   }
        
  else
  {
  
    window.alert("es necesario completar la encuesta");
  
  
  }


   }

   seleccion(event,categoria)
   {
     var target = event.target || event.srcElement || event.currentTarget;
     var idAttr = target.attributes.id;
     var value = idAttr.nodeValue;
     var res = value.split("-");
     var i ;
   
     for (i = 1; i < this.rangoencuesta+1; i++) 
     { 
   
       document.getElementById(res[0]+'-'+i).className='form-control';
      
     }
   
        
     document.getElementById(value).className='btn btn-success';
     
    categoria.puntaje= res[1] ;
    
     
    
   
    
   
   }

  ngOnInit() 
  {

    this.route.params.subscribe(params =>
      
    {
      this.llave=params["id"];
      this.llavePadre=params["padre"];
      this.fecha=params["fecha"];
     
      var lista =  this.servicio.obtenerEncuesta(this.llavePadre);
      lista.forEach(element => 
        {
         
          this.categorias=element[0];
          this.nombreencuesta=element[1].$value;
          this.rangoencuesta=element[2].$value;
        
    
          this.fakeArray =  new Array(this.rangoencuesta);
        });
  
       


    });    




  }

}
