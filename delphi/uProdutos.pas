unit uProdutos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, Vcl.Buttons, Vcl.DBCtrls, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    conMiniERP: TADOConnection;
    qryProdutos: TADOQuery;
    dsProdutos: TDataSource;
    grdProdutos: TDBGrid;
    DBNavigator1: TDBNavigator;
    Panel1: TPanel;
    Label1: TLabel;
    edtNome: TEdit;
    Label2: TLabel;
    edtPreco: TEdit;
    Label3: TLabel;
    edtEstoque: TEdit;
    Label4: TLabel;
    edtEstoqueMinimo: TEdit;
    btnSalvar: TButton;
    qryInsertProdutos: TADOQuery;
    procedure btnSalvarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnSalvarClick(Sender: TObject);

begin
  qryInsertProdutos.Parameters.ParamByName('nome').Value := edtNome.Text;
  qryInsertProdutos.Parameters.ParamByName('preco').Value := StrToFloat(edtPreco.Text);
  qryInsertProdutos.Parameters.ParamByName('estoque').Value := StrToInt(edtEstoque.Text);
  qryInsertProdutos.Parameters.ParamByName('estoque_minimo').Value := StrToInt(edtEstoqueMinimo.Text);
  qryInsertProdutos.ExecSQL;
  qryProdutos.Requery;
end;

end.
