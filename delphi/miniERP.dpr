program miniERP;

uses
  Vcl.Forms,
  uProdutos in 'uProdutos.pas' {frmProdutos},
  uVendas in 'uVendas.pas' {frmVendas};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmProdutos, frmProdutos);
  Application.CreateForm(TfrmVendas, frmVendas);
  Application.Run;
end.
