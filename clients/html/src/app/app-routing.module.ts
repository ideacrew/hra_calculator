import { Routes } from '@angular/router';
import { HomeComponent } from './home/home.component';
import { InfoComponent } from './info/info.component';
import { ResultComponent } from './result/result.component';

// import { FullComponent } from './layouts/full/full.component';

export const routes: Routes = [
  {
    path: '',
    redirectTo: '/home',
    pathMatch: 'full'
  },
  {
    path: 'home',
    component: HomeComponent
  },
  {
    path: 'result',
    component: ResultComponent,
  },
  {
    path: 'info',
    component: InfoComponent,
    children: [
      { path: '', redirectTo: '/info', pathMatch: 'full' },
      {
        path: 'info',
        loadChildren: () => import('./info/info.module').then(m => m.InfoModule)
      },
      {
        path: 'component',
        loadChildren: () => import('./component/component.module').then(m => m.ComponentsModule)
      }
    ]
  },
  {
    path: '**',
    redirectTo: 'home'
  }
];

export class AppRoutingModule { }
