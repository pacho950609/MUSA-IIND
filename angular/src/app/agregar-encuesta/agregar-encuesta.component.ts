import { Component, OnInit } from '@angular/core';
import {Servicio} from '../servicios/servicio';


@Component({
  selector: 'app-agregar-encuesta',
  templateUrl: './agregar-encuesta.component.html',
  styleUrls: ['./agregar-encuesta.component.css'],
  providers: [Servicio]
})
export class AgregarEncuestaComponent implements OnInit {


   nombreEncuesta : string ;
   rangoEncuesta : string ;

   categoria : string ;
  
   categorias = new Array(); 
   


  
 



  constructor(private servicio: Servicio) 
  { 

      

  }

  guardarEncuesta(){


    var agregar = new Categoria() ;
    agregar.nombre='Satisfaccion general'
    this.categorias.push(agregar); 

     var objeto=
          {
              categorias: this.categorias,
              nombreEncuesta :this.nombreEncuesta,
              rangoEncuesta : this.rangoEncuesta
          }
 

     this.servicio.guardarEncuesta(objeto).then(v => 
     {
        window.location.href = 'http://localhost:4200/verencuesta'; 
    }); 
      window.alert("Encuesta agregada exitosamente");
     
  }


  agregarEncuesta()
  {

    var agregar = new Categoria() ;
    agregar.nombre=this.categoria
    console.log(agregar.nombre);
    this.categorias.push(agregar); 
    this.categoria="";
   
   
  }




eliminarCategoria(categoriaActual)
  {


        var index = this.categorias.indexOf(categoriaActual, 0);
      if (index > -1) {
        this.categorias.splice(index, 1);
      }
        


  }

   agregarSub(f,categoriaActual)
  {

    categoriaActual.agregarSubCategoria(f.value.subCategoria);
    f.reset();


  }





  ngOnInit() {
  }

}



export class Categoria{


    nombre:string ;
    subCategorias = new Array(); 
    

      agregarSubCategoria(nombreSub)
  {

     var agregar2 = new subCategoria() ;
     agregar2.agregarNombre(nombreSub);
    this.subCategorias.push(agregar2); 
    
  }


    


}


export class subCategoria{


    nombre:string ;
   
      agregarNombre(agregar)
  {

    this.nombre=agregar; 
    


  }
    


}