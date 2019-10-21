import { Component } from '@angular/core';
import { NgbDateParserFormatter } from '@ng-bootstrap/ng-bootstrap';
import { UsDateParserFormatter } from "./us_date_parser_formatter"
import { HttpClient } from '@angular/common/http';
import { JwtRefreshService } from './authentication/jwt_refresh_service';

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
  hasToken : boolean = false;

  constructor(private http: HttpClient) {
  }

  ngOnInit() {
    var jrs = new JwtRefreshService(this.http);
    jrs.getFirstToken(this);
  }
}
