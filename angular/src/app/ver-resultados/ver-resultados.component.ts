import { Component, OnInit } from '@angular/core';
import {Servicio} from '../servicios/servicio';
import { ChartModule }  from 'angular2-highcharts'; 


@Component({
  selector: 'app-ver-resultados',
  templateUrl: './ver-resultados.component.html',
  styleUrls: ['./ver-resultados.component.css'],
  providers: [Servicio],
  
})
export class VerResultadosComponent implements OnInit {

  encuestas = new Array(); 
  encuestasDelPeriodo = new Array(); 
  encuestasVer = new Array(); 
  options: Object;
  options2: Object;
  encuestaPadre : any ;
  satisfaccionHistorico = new Array(); 

  graficaControl = new Array();
  numerosCriterio = new Array(); 
  datosCriterio = new Array();  
  mediaCriterio = new Array();  
  desviacionCriterio = new Array();  


  categoriasActual = new Array() ;
  fechaActual : any ; 
  nombreActual :string ;
  llave : string ;


  constructor(private servicio: Servicio) 
  {


    var i = 0;

    var lista =  servicio.obtenerEncuestas();
    lista.forEach(element => 
      {
        console.log("aca");
          element.forEach(encuesta =>
          {
            if(i==0)
            {
            this.encuestas.push(encuesta); 
            if(encuesta.fecha==undefined)
            {
              this.encuestasVer.push(encuesta);
            }
          }
          });

          i=1 ;
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

    this.satisfaccionHistorico= new Array();
    var media = 0
    var numeros = new Array();
    this.encuestasDelPeriodo.forEach(element => 
      {
          var agregar = new Array() ;
          if(element.fecha != undefined)
          {
            var date = new Date(element.fecha);
            agregar.push(date.getTime());
            agregar.push(Number(element.satisfaccion));
            media += Number(element.satisfaccion);
            numeros.push(Number(element.satisfaccion));
            this.satisfaccionHistorico.push(agregar);
          }
      });
      
      media = media / this.satisfaccionHistorico.length ;

      var desviacion = 0 ;

        numeros.forEach(element => 
        {
            desviacion += (element-media)*(element-media) ;
        });

        desviacion= desviacion / (this.satisfaccionHistorico.length-1)
        desviacion = Math.sqrt(desviacion);

     


      
      this.options2 = {
        title : { text : 'Gráfica de control de la satisfacción general' }, 
        yAxis: {
          tickPositions:[0,0.2,0.4,0.6,0.8,1.05],
          plotLines:[{
              value:Math.min(media+3*desviacion,1),
              color:'rgba(162,29,33,.75)',
              width:1,
              zIndex:3
          },{
            value:Math.min(media+2*desviacion,1),
            color:'rgba(246,145,145,.75)',
            width:1,
            zIndex:3
        },{
              value:media,
              color:'rgba(24,90,169,.75)',
              width:1,
              zIndex:3
          },{
            value:Math.max(media-2*desviacion,0),
            color:'rgba(246,145,145,.75)',
            width:1,
            zIndex:3
        },{
              value:Math.max(media-3*desviacion,0),
              color:'rgba(162,29,33,.75)',
              width:1,
              zIndex:3
          }],
          title: {text: 'nivel de satisfaccion'},
          gridLineColor:'rgba(24,90,169,.25)',
          min:0,
          max:1,
      },  
        series : [{
            name : 'Satisfaccion', 
            data: this.satisfaccionHistorico, 
            tooltip: {
                valueDecimals: 2 
            }
        }]
    };

    this.mediaCriterio = new Array() ;
    this.numerosCriterio=new Array() ;
    this.datosCriterio=new Array() ;
    this.graficaControl=new Array() ;


    var i ;
    for (i = 0; i < this.encuestaPadre.categorias.length-1; i++) 
    { 
      this.mediaCriterio[i] = 0 ;
      this.numerosCriterio[i]=new Array() ;
      this.datosCriterio[i]=new Array() ;
    }
   

    this.encuestasDelPeriodo.forEach(element => 
      {
       
          if(element.fecha != undefined)
          {
            var voy = 0;

            element.categorias.forEach(categoria => 
              {
                if(voy!= element.categorias.length-1)
                {
                  var agregar = new Array() ;
                  var date = new Date(element.fecha);
                  agregar.push(date.getTime());
                  agregar.push(Number(categoria.satisfaccion));
                  this.mediaCriterio[voy] += Number(categoria.satisfaccion);
                  this.numerosCriterio[voy].push(Number(categoria.satisfaccion));
                  this.datosCriterio[voy].push(agregar);

                voy = voy + 1 ;
                }

              });


          }
      });


     

      for (i = 0; i < this.encuestaPadre.categorias.length-1; i++) 
      { 

        this.mediaCriterio[i]=  this.mediaCriterio[i] / this.encuestasDelPeriodo.length;
        
        var desv = 0 ;
        
                this.numerosCriterio[i].forEach(element => 
                {
                    desv += (element-this.mediaCriterio[i])*(element-this.mediaCriterio[i]) ;
                });
        
                desv= desv / ( this.encuestasDelPeriodo.length-1)
                desv = Math.sqrt(desv);
                this.desviacionCriterio[i]=desv ;
      }

  



      for (i = 0; i < this.encuestaPadre.categorias.length-1; i++) 
      { 
       
        var grafica = { 
          title : { text : 'Gráfica de control de la satisfacción de la categoría '+this.encuestaPadre.categorias[i].nombre }, 
          yAxis: {
            tickPositions:[0,0.2,0.4,0.6,0.8,1.05],
            plotLines:[{
                value:Math.min(this.mediaCriterio[i]+3*this.desviacionCriterio[i],1),
                color:'rgba(162,29,33,.75)',
                width:1,
                zIndex:3
            },
            {
              value:Math.min(this.mediaCriterio[i]+2*this.desviacionCriterio[i],1),
              color:'rgba(246,145,145,.75)',
              width:1,
              zIndex:3
          },{
                value:this.mediaCriterio[i],
                color:'rgba(24,90,169,.75)',
                width:1,
                zIndex:3
            },{
              value:Math.max(this.mediaCriterio[i]-2*this.desviacionCriterio[i],0),
              color:'rgba(246,145,145,.75)',
              width:1,
              zIndex:3
          },{
                value:Math.max(this.mediaCriterio[i]-3*this.desviacionCriterio[i],0),
                color:'rgba(162,29,33,.75)',
                width:1,
                zIndex:3
            }],
            title: {text: 'nivel de satisfaccion'},
            gridLineColor:'rgba(24,90,169,.25)',
            min:0,
            max:1,
        },  
          series : [{
              name : 'Satisfaccion', 
              data: this.datosCriterio[i], 
              tooltip: {
                  valueDecimals: 2 
              }
          }]
      };




        this.graficaControl[i]= grafica ;
        
     
      }

      console.log(this.datosCriterio);
      console.log(this.numerosCriterio);
      console.log(this.graficaControl);
      console.log(this.desviacionCriterio);
     
    

  }

  verEncuesta(encuestaActual)
  {
    this.categoriasActual= encuestaActual.categorias;
    this.nombreActual = encuestaActual.nombreEncuesta;
    this.fechaActual = encuestaActual.fecha;
    this.llave = encuestaActual.$key;
  }

  correrModelo()
  {
    this.servicio.correrModelo(this.llave).subscribe(respuesta=>
    {

      console.log(respuesta);
      window.location.href = 'http://localhost:4200/verresultado'; 


    });
    
    
    
    

    
  }

  ngOnInit() {
  }

}
