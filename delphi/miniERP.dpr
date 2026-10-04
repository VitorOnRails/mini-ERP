program miniERP;

uses
  Vcl.Forms,
  uProdutos in 'uProdutos.pas' {frmProdutos},
  uVendas in 'uVendas.pas' {frmVendas},
  uEstoque in 'uEstoque.pas' {frmEstoque};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmProdutos, frmProdutos);
  Application.CreateForm(TfrmVendas, frmVendas);
  Application.CreateForm(TfrmEstoque, frmEstoque);
  Application.Run;
end.
