import { Component } from '@angular/core';
import { NgbDateParserFormatter } from '@ng-bootstrap/ng-bootstrap';
import { UsDateParserFormatter } from "./us_date_parser_formatter"

@Component({
  providers: [{provide: NgbDateParserFormatter, useClass: UsDateParserFormatter}],
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'app';

  onActivate(event: any) {
    window.scroll(0,0);
  }
}
