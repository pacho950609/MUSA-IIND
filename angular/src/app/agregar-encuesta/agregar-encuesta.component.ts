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


    if(this.categorias.length<1)
    {
      window.alert("Agregue una categoría");
    }

    else if ( this.nombreEncuesta==undefined ||this.nombreEncuesta=="")
    {
      window.alert("Defina el nombre de la encuesta");
    }

    else if ( this.rangoEncuesta==undefined || Number(this.rangoEncuesta)<=2)
    {
      window.alert("Defina los niveles de satisfacción de la encuesta, recuerde debe ser mayor a 2 ");
    }

    else
    {

    var agregar = new Categoria() ;
    agregar.nombre='Satisfacción general'
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