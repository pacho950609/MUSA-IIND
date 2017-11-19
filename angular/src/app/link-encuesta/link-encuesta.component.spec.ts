import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { LinkEncuestaComponent } from './link-encuesta.component';

describe('LinkEncuestaComponent', () => {
  let component: LinkEncuestaComponent;
  let fixture: ComponentFixture<LinkEncuestaComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ LinkEncuestaComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(LinkEncuestaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
