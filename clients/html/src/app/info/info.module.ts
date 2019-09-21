import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule } from '@angular/forms';
import { Routes, RouterModule } from '@angular/router';

// import { InfoComponent } from './info.component';

const routes: Routes = [
  {
    path: '',
    data: {
      title: 'Info Page',
      urls: [
        { title: 'Dashboard', url: '/dashboard' },
        { title: 'Info Page' }
      ]
    },
    // component: InfoComponent
  }
];

@NgModule({
  imports: [ReactiveFormsModule, CommonModule, RouterModule.forChild(routes)],
  // declarations: [InfoComponent]
})
export class InfoModule {}