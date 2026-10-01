unit uVendas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB,
  Data.Win.ADODB, Vcl.Grids;

type
  TfrmVendas = class(TForm)
    Panel1: TPanel;
    cboProduto: TComboBox;
    lblProdutos: TLabel;
    lblQtd: TLabel;
    edtQtd: TEdit;
    btnAdicionar: TButton;
    conMiniERP: TADOConnection;
    qryProdutos: TADOQuery;
    grdCarrinho: TStringGrid;
    lblTotal: TLabel;
    rgPagamento: TRadioGroup;
    btnFinalizar: TButton;
    qryFinalizarVenda: TADOQuery;
    procedure FormCreate(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure btnFinalizarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmVendas: TfrmVendas;

implementation

{$R *.dfm}

procedure TfrmVendas.btnAdicionarClick(Sender: TObject);
var
  linha, id, qtd, i: Integer;
  preco, subtotal, total: Currency;
begin
    qtd := StrToInt(edtQtd.Text);
    qryProdutos.Locate('nome', cboProduto.Text, []);
    id := qryProdutos.FieldByName('id').AsInteger;
    preco := qryProdutos.FieldByName('preco').AsCurrency;
    subtotal := qtd * preco;
    linha := grdCarrinho.RowCount - 1;
    if grdCarrinho.Cells[1, linha] <> '' then
    begin
      grdCarrinho.RowCount := grdCarrinho.RowCount + 1;
      linha := grdCarrinho.RowCount - 1;
    end;
    grdCarrinho.Cells[0, linha] := IntToStr(id);
    grdCarrinho.Cells[1, linha] := cboProduto.Text;
    grdCarrinho.Cells[2, linha] := IntToStr(qtd);
    grdCarrinho.Cells[3, linha] := CurrToStr(preco);
    grdCarrinho.Cells[4, linha] := CurrToStr(subtotal);
    total := 0;
    for i := 1 to grdCarrinho.RowCount - 1 do
      total := total + StrToCurr(grdCarrinho.Cells[4, i]);
    lblTotal.Caption := 'Total: R$ ' + CurrToStr(total);
end;

procedure TfrmVendas.btnFinalizarClick(Sender: TObject);
var
  json, formaPagamento: string;
  i: Integer;
begin
  if grdCarrinho.Cells[1, 1] = '' then
  begin
    ShowMessage('O carrinho está vazio.');
    Exit;
  end;
  if rgPagamento.ItemIndex = -1 then
  begin
    ShowMessage('Selecione uma forma de pagamento.');
    Exit;
  end;
  json := '[';
  for i := 1 to grdCarrinho.RowCount - 1 do
  begin
    json := json + '{"id_produto":' + grdCarrinho.Cells[0, i] + ',"qtd":' + grdCarrinho.Cells[2, i] + '}';
    if i < grdCarrinho.RowCount - 1 then
    json := json + ',';
  end;
  json := json + ']';
  formaPagamento := rgPagamento.Items[rgPagamento.ItemIndex];
  qryFinalizarVenda.Parameters.ParamByName('forma_pagamento').Value := formaPagamento;
  qryFinalizarVenda.Parameters.ParamByName('itensJson').Value := json;
  try
  qryFinalizarVenda.ExecSQL;
  ShowMessage('Venda registrada com sucesso!');
  grdCarrinho.RowCount := 2;
  grdCarrinho.Rows[1].Clear;
  lblTotal.Caption := 'Total: R$0';
  except
  on E: Exception do
    ShowMessage('Erro ao registrar venda: ' + E.Message);
  end;
end;

procedure TfrmVendas.FormCreate(Sender: TObject);
begin
  grdCarrinho.RowCount := 2;
  grdCarrinho.Cells[0, 0] := 'id_produto';
  grdCarrinho.Cells[1, 0] := 'Produto';
  grdCarrinho.Cells[2, 0] := 'Quantidade';
  grdCarrinho.Cells[3, 0] := 'Preço';
  grdCarrinho.Cells[4, 0] := 'Subtotal';
  qryProdutos.Open;
  while not qryProdutos.Eof do
  begin
    cboProduto.Items.Add(qryProdutos.FieldByName('nome').AsString);
    qryProdutos.Next;
  end;
end;

end.
