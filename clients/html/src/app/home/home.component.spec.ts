import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { HttpClient, HttpParams, HttpHandler } from '@angular/common/http';
import { HomeComponent } from './home.component';

describe('HomeComponent', () => {
  let component: HomeComponent;
  let fixture: ComponentFixture<HomeComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      providers: [ HttpClient, HttpHandler ],
      declarations: [ HomeComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HomeComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeDefined();
  });

  it('should display given taxCredit and marketplace values', () => {
    let p = fixture.nativeElement.querySelector('p');
    component.taxCredit = 'Test Tax Credit';
    component.marketPlace = 'Test Marketplace';
    fixture.detectChanges();
    expect(p.textContent).toContain('Test Tax Credit');
    expect(p.textContent).toContain('Test Marketplace');
  });
});
