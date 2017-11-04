import { InterfazPage } from './app.po';

describe('interfaz App', () => {
  let page: InterfazPage;

  beforeEach(() => {
    page = new InterfazPage();
  });

  it('should display message saying app works', () => {
    page.navigateTo();
    expect(page.getParagraphText()).toEqual('app works!');
  });
});
