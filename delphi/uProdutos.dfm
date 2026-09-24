object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 528
  ClientWidth = 1044
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object grdProdutos: TDBGrid
    Left = 184
    Top = 32
    Width = 473
    Height = 377
    DataSource = dsProdutos
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'id'
        Title.Caption = 'ID'
        Width = 40
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'nome'
        Title.Caption = 'Nome'
        Width = 140
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'preco'
        Title.Caption = 'Pre'#231'o'
        Width = 60
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'estoque'
        Title.Caption = 'Estoque'
        Width = 60
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'estoque_minimo'
        Title.Caption = 'Estoque m'#237'nimo'
        Width = 100
        Visible = True
      end>
  end
  object conMiniERP: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=MSOLEDBSQL19.1;Data Source=localhost;Initial Catalog=mi' +
      'niERP;Integrated Security=SSPI;Trust Server Certificate=True'
    LoginPrompt = False
    Provider = 'MSOLEDBSQL19.1'
    Left = 48
    Top = 40
  end
  object qryProdutos: TADOQuery
    Active = True
    Connection = conMiniERP
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM produtos')
    Left = 48
    Top = 104
  end
  object dsProdutos: TDataSource
    DataSet = qryProdutos
    Left = 48
    Top = 168
  end
end
