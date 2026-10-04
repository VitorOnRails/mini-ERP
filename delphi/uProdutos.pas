unit uProdutos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, Vcl.Buttons, Vcl.DBCtrls, Vcl.StdCtrls;

type
  TfrmProdutos = class(TForm)
    conMiniERP: TADOConnection;
    qryProdutos: TADOQuery;
    dsProdutos: TDataSource;
    pnlMain: TPanel;
    lblNome: TLabel;
    edtNome: TEdit;
    lblPreco: TLabel;
    edtPreco: TEdit;
    lblEstoque: TLabel;
    edtEstoque: TEdit;
    lblEstoque_min: TLabel;
    edtEstoqueMinimo: TEdit;
    btnSalvar: TButton;
    qryInsertProdutos: TADOQuery;
    grdProdutos: TDBGrid;
    DBNavigator1: TDBNavigator;
    btnNovaVenda: TButton;
    btnConsultaEstoque: TButton;
    procedure btnSalvarClick(Sender: TObject);
    procedure btnNovaVendaClick(Sender: TObject);
    procedure btnConsultaEstoqueClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmProdutos: TfrmProdutos;

implementation

  uses uVendas, uEstoque;
{$R *.dfm}

procedure TfrmProdutos.btnConsultaEstoqueClick(Sender: TObject);
begin
frmEstoque.Show;
end;

procedure TfrmProdutos.btnNovaVendaClick(Sender: TObject);
begin
frmVendas.Show;
end;

procedure TfrmProdutos.btnSalvarClick(Sender: TObject);

begin
  qryInsertProdutos.Parameters.ParamByName('nome').Value := edtNome.Text;
  qryInsertProdutos.Parameters.ParamByName('preco').Value := StrToFloat(edtPreco.Text);
  qryInsertProdutos.Parameters.ParamByName('estoque').Value := StrToInt(edtEstoque.Text);
  qryInsertProdutos.Parameters.ParamByName('estoque_minimo').Value := StrToInt(edtEstoqueMinimo.Text);
  qryInsertProdutos.ExecSQL;
  qryProdutos.Requery;
end;

end.
