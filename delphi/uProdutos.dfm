object frmProdutos: TfrmProdutos
  Left = 0
  Top = 0
  Caption = 'frmProdutos'
  ClientHeight = 749
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
  object DBNavigator1: TDBNavigator
    Left = 280
    Top = 415
    Width = 270
    Height = 49
    DataSource = dsProdutos
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 237
    Top = 488
    Width = 329
    Height = 189
    Caption = 'Panel1'
    TabOrder = 2
    object Label1: TLabel
      Left = 1
      Top = -1
      Width = 36
      Height = 15
      Align = alCustom
      Caption = 'Nome:'
    end
    object Label2: TLabel
      Left = 1
      Top = 23
      Width = 33
      Height = 15
      Align = alCustom
      Caption = 'Pre'#231'o:'
    end
    object Label3: TLabel
      Left = 1
      Top = 47
      Width = 45
      Height = 15
      Alignment = taCenter
      Caption = 'Estoque:'
    end
    object Label4: TLabel
      Left = 0
      Top = 71
      Width = 90
      Height = 15
      Caption = 'Estoque M'#237'nimo:'
    end
    object edtNome: TEdit
      Left = 43
      Top = 0
      Width = 110
      Height = 23
      Alignment = taCenter
      TabOrder = 0
    end
    object edtPreco: TEdit
      Left = 43
      Top = 23
      Width = 113
      Height = 23
      Alignment = taCenter
      TabOrder = 1
    end
    object edtEstoque: TEdit
      Left = 52
      Top = 47
      Width = 113
      Height = 23
      Alignment = taCenter
      TabOrder = 2
    end
    object edtEstoqueMinimo: TEdit
      Left = 96
      Top = 71
      Width = 113
      Height = 23
      Alignment = taCenter
      TabOrder = 3
    end
    object btnSalvar: TButton
      Left = 1
      Top = 104
      Width = 75
      Height = 25
      Caption = 'Salvar'
      TabOrder = 4
      OnClick = btnSalvarClick
    end
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
  object qryInsertProdutos: TADOQuery
    Connection = conMiniERP
    Parameters = <
      item
        Name = 'nome'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 100
        Value = Null
      end
      item
        Name = 'preco'
        Attributes = [paSigned, paNullable]
        DataType = ftBCD
        NumericScale = 2
        Precision = 10
        Size = 19
        Value = Null
      end
      item
        Name = 'estoque'
        Attributes = [paSigned, paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'estoque_minimo'
        Attributes = [paSigned, paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end>
    SQL.Strings = (
      'INSERT INTO produtos (nome, preco, estoque, estoque_minimo)'
      'VALUES (:nome, :preco, :estoque, :estoque_minimo)')
    Left = 48
    Top = 232
  end
end
