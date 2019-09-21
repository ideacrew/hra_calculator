import { Component } from '@angular/core';

@Component({
  selector: 'layout-footer',
  templateUrl: './footer.component.html',
  styleUrls: ['./../../app.component.scss']
})
export class FooterComponent {
  today: number = Date.now();
}