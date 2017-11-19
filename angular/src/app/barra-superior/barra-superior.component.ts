import { Component, OnInit } from '@angular/core';
import {ActivatedRoute} from '@angular/router'
@Component({
  selector: 'app-barra-superior',
  templateUrl: './barra-superior.component.html',
  styleUrls: ['./barra-superior.component.css']
})
export class BarraSuperiorComponent implements OnInit {

  respuesta : boolean;
  constructor(private route:ActivatedRoute)
   {
    
      
      this.respuesta=window.location.pathname.startsWith("/linkencuesta");
  }

  ngOnInit() {
  }

}
