import { Component, OnInit } from '@angular/core';
import { FullComponent } from '../layouts/full/full.component';
import { BlankComponent } from '../layouts/blank/blank.component';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: [
    './home.component.css',
    '../app.component.css'
  ]
})
export class HomeComponent implements OnInit {

  constructor() { }

  ngOnInit() {
  }

}
