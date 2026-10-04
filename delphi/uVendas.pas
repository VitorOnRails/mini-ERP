unit uVendas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB,
  Data.Win.ADODB, Vcl.Grids;

type
  TfrmVendas = class(TForm)
    pnlMain: TPanel;
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
    btnCancelarVenda: TButton;
    btnRemoverProduto: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure btnFinalizarClick(Sender: TObject);
    procedure btnCancelarVendaClick(Sender: TObject);
    procedure btnRemoverProdutoClick(Sender: TObject);
  private
    procedure AtualizarTotal;
    procedure CarrinhoLimpar;
    function MontarJSON: string;
  public
    { Public declarations }
  end;

var
  frmVendas: TfrmVendas;

implementation

{$R *.dfm}

procedure TfrmVendas.AtualizarTotal;
var
  total: Currency;
  i: Integer;
begin
    total := 0;
    for i := 1 to grdCarrinho.RowCount - 1 do
      total := total + StrToCurr(grdCarrinho.Cells[4, i]);
    lblTotal.Caption := 'Total: R$ ' + CurrToStr(total);
end;

procedure TfrmVendas.btnAdicionarClick(Sender: TObject);
var
  linha, linhaExistente, id, qtd, novoQtd, i: Integer;
  preco, subtotal: Currency;
begin
    if cboProduto.ItemIndex = -1 then
    begin
      ShowMessage('Selecione um produto.');
      Exit;
    end;
    if not TryStrToInt(edtQtd.Text, qtd) or (qtd <= 0) then
    begin
      ShowMessage('Informe uma quantidade válida.');
      Exit;
    end;
    qryProdutos.Locate('nome', cboProduto.Text, []);
    id := qryProdutos.FieldByName('id').AsInteger;
    preco := qryProdutos.FieldByName('preco').AsCurrency;
    linhaExistente := -1;
    for i := 1 to grdCarrinho.RowCount - 1 do
      if grdCarrinho.Cells[0, i] = IntToStr(id) then
        linhaExistente := i;
    if linhaExistente <> -1 then
    begin
      novoQtd := StrToInt(grdCarrinho.Cells[2, linhaExistente]) + qtd;
      grdCarrinho.Cells[2, linhaExistente] := IntToStr(novoQtd);
      grdCarrinho.Cells[4, linhaExistente] := CurrToStr(novoQtd * preco);
    end
    else
    begin
    linha := grdCarrinho.RowCount - 1;
    if grdCarrinho.Cells[1, linha] <> '' then
    begin
      grdCarrinho.RowCount := grdCarrinho.RowCount + 1;
      linha := grdCarrinho.RowCount - 1;
    end;
    subtotal := qtd * preco;
    grdCarrinho.Cells[0, linha] := IntToStr(id);
    grdCarrinho.Cells[1, linha] := cboProduto.Text;
    grdCarrinho.Cells[2, linha] := IntToStr(qtd);
    grdCarrinho.Cells[3, linha] := CurrToStr(preco);
    grdCarrinho.Cells[4, linha] := CurrToStr(subtotal);
    end;
    AtualizarTotal;
    edtQtd.Text := '';
    cboProduto.ItemIndex := -1;
end;

procedure TfrmVendas.btnCancelarVendaClick(Sender: TObject);
begin
  CarrinhoLimpar;
end;

function TfrmVendas.MontarJSON: string;
var
  i: Integer;
begin
  Result := '[';
  for i := 1 to grdCarrinho.RowCount - 1 do
  begin
    Result := Result + '{"id_produto":' + grdCarrinho.Cells[0, i] + ',"qtd":' + grdCarrinho.Cells[2, i] + '}';
    if i < grdCarrinho.RowCount - 1 then
      Result := Result + ',';
  end;
  Result := Result + ']';
end;

procedure TfrmVendas.CarrinhoLimpar;
begin
  grdCarrinho.RowCount := 2;
  grdCarrinho.Rows[1].Clear;
  lblTotal.Caption := 'Total: R$ 0,00';
end;

procedure TfrmVendas.btnFinalizarClick(Sender: TObject);
var
  json, formaPagamento: string;
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
  json := MontarJSON;
  formaPagamento := rgPagamento.Items[rgPagamento.ItemIndex];
  qryFinalizarVenda.Parameters.ParamByName('forma_pagamento').Value := formaPagamento;
  qryFinalizarVenda.Parameters.ParamByName('itensJson').Value := json;
  try
  qryFinalizarVenda.ExecSQL;
  CarrinhoLimpar;
  ShowMessage('Venda registrada com sucesso!');
  except
  on E: Exception do
    ShowMessage('Erro ao registrar venda: ' + E.Message);
  end;
end;

procedure TfrmVendas.btnRemoverProdutoClick(Sender: TObject);
var
  i, linhaSelecionada: Integer;
begin
  linhaSelecionada := grdCarrinho.Row;
  if grdCarrinho.Cells[1, linhaSelecionada] = '' then
  begin
    ShowMessage('O carrinho está vazio.');
    Exit;
  end;
  if grdCarrinho.RowCount > 2 then
  begin
    for i := linhaSelecionada to grdCarrinho.RowCount - 2 do
      grdCarrinho.Rows[i] := grdCarrinho.Rows[i + 1];
    grdCarrinho.RowCount := grdCarrinho.RowCount - 1;
    AtualizarTotal;
  end
  else
    CarrinhoLimpar;
end;

procedure TfrmVendas.FormCreate(Sender: TObject);
begin
  grdCarrinho.RowCount := 2;
  grdCarrinho.Cells[0, 0] := 'id_produto';
  grdCarrinho.Cells[1, 0] := 'Produto';
  grdCarrinho.Cells[2, 0] := 'Quantidade';
  grdCarrinho.Cells[3, 0] := 'Preço';
  grdCarrinho.Cells[4, 0] := 'Subtotal';
  lblTotal.Caption := 'Total: R$ 0,00';
  qryProdutos.Open;
  while not qryProdutos.Eof do
  begin
    cboProduto.Items.Add(qryProdutos.FieldByName('nome').AsString);
    qryProdutos.Next;
  end;
end;

end.
