import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { VerResultadosComponent } from './ver-resultados.component';

describe('VerResultadosComponent', () => {
  let component: VerResultadosComponent;
  let fixture: ComponentFixture<VerResultadosComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ VerResultadosComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(VerResultadosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
