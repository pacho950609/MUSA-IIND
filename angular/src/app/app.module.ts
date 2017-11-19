import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { HttpModule } from '@angular/http';
import { routing } from './router.component';
import { AppComponent } from './app.component';
import { BarraSuperiorComponent } from './barra-superior/barra-superior.component';
import { IndexComponent } from './index/index.component';
import { AgregarEncuestaComponent } from './agregar-encuesta/agregar-encuesta.component';
import {AngularFireModule} from 'angularfire2' 
import {firebaseConfig} from './../environments/firebase.config';
import { VerEncuestasComponent } from './ver-encuestas/ver-encuestas.component';
import { VerResultadosComponent } from './ver-resultados/ver-resultados.component'
import {ChartModule} from "angular2-highcharts";
import { HighchartsStatic } from 'angular2-highcharts/dist/HighchartsService';
import { LinkEncuestaComponent } from './link-encuesta/link-encuesta.component';


export function highchartsFactory() {
  const hc = require('highcharts');
  const dd = require('highcharts/modules/drilldown');
  dd(hc);

  return hc;
}
export function highchartsFactory2() {
  const hc = require('highcharts/highstock');
  const dd = require('highcharts/modules/drilldown');
  dd(hc);

  return hc;
}


@NgModule({
  declarations: [
    AppComponent,
    BarraSuperiorComponent,
    IndexComponent,
    AgregarEncuestaComponent,
    VerEncuestasComponent,
    VerResultadosComponent,
    LinkEncuestaComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,
    HttpModule,
    routing,
    AngularFireModule.initializeApp(firebaseConfig),
    ChartModule,
    
     
  ],   
  providers: [ {
    provide: HighchartsStatic,
    useFactory: highchartsFactory
  },{
    provide: HighchartsStatic,
    useFactory: highchartsFactory2
  } ],
  bootstrap: [AppComponent]
})
export class AppModule { }
