import {Injectable} from '@angular/core';
import {Http, Headers, RequestOptions} from '@angular/http';
import 'rxjs/add/operator/map';
import 'rxjs/RX';
import { Observable } from 'rxjs/Observable';
import {BehaviorSubject} from 'rxjs/BehaviorSubject';
import {AngularFireDatabase} from 'angularfire2'




@Injectable()
export class Servicio{

 


    constructor(private fireBase: AngularFireDatabase, private http:Http) 
  { 
    
  }

    guardarEncuesta(encuestaGuardar)
    {
        const items = this.fireBase.list('Encuestas');
       return  items.push(encuestaGuardar)

    }

      obtenerEncuestas()
    {
        const items = this.fireBase.list('Encuestas');
        return items
    }


        guardarInfo(llave, informacion)
    {
        const items = this.fireBase.list('Encuestas/'+llave);
        return  items.update('categorias',informacion);
    } 

     correrModelo(llave)
    {
         
        return this.http.get('/api/generarYSubirAnalisis/'+llave).map(res=>res.json());

    }

     
} 