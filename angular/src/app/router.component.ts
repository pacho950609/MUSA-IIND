import { ModuleWithProviders }  from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { IndexComponent } from './index/index.component';
import { AgregarEncuestaComponent} from './agregar-encuesta/agregar-encuesta.component';
import { VerEncuestasComponent} from './ver-encuestas/ver-encuestas.component';
import { VerResultadosComponent} from './ver-resultados/ver-resultados.component';
import {LinkEncuestaComponent} from './link-encuesta/link-encuesta.component'



// Route Configuration
export const routes: Routes = [
    {path: '', redirectTo: '/index', pathMatch: 'full'},
     { path: 'index',component: IndexComponent },
     { path: 'agregarencuesta', component: AgregarEncuestaComponent },
     { path: 'verencuesta', component: VerEncuestasComponent },
     { path: 'verresultado', component: VerResultadosComponent },
     {path:'linkencuesta/:id/:padre/:fecha', component: LinkEncuestaComponent}

];

// Deprecated provide
// export const APP_ROUTER_PROVIDERS = [
//   provideRouter(routes)
// ];

export const routing: ModuleWithProviders = RouterModule.forRoot(routes);