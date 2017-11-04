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


  categoriasActual = new Array() ;
  fechaActual : any ; 
  nombreActual :string ;
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

    this.encuestasDelPeriodo.forEach(element => 
      {
          var agregar = new Array() ;
          if(element.fecha != undefined)
          {
            var date = new Date(element.fecha);
            agregar.push(date.getTime());
            agregar.push(Number(element.satisfaccion));
            this.satisfaccionHistorico.push(agregar);
          }
      });
      

      console.log(this.satisfaccionHistorico);
 
      this.options2 = {
        title : { text : 'Grafica de control de la satisfaccion general' }, 
        yAxis: {
          tickPositions:[0,0.2,0.4,0.6,0.8,1],
          plotLines:[{
              value:0.8,
              color:'rgba(162,29,33,.75)',
              width:1,
              zIndex:3
          },{
              value:0.5,
              color:'rgba(24,90,169,.75)',
              width:1,
              zIndex:3
          },{
              value:0.1,
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



    });
    
    
    
    

    
  }

  ngOnInit() {
  }

}
