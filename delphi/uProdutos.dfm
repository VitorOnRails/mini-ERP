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
  object pnlMain: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 1038
    Height = 743
    Align = alClient
    Alignment = taLeftJustify
    TabOrder = 0
    ExplicitLeft = 8
    ExplicitTop = -2
    object lblNome: TLabel
      Left = 0
      Top = 19
      Width = 36
      Height = 15
      Caption = 'Nome:'
    end
    object lblPreco: TLabel
      Left = 1
      Top = 48
      Width = 33
      Height = 15
      Caption = 'Pre'#231'o:'
    end
    object lblEstoque: TLabel
      Left = 1
      Top = 77
      Width = 45
      Height = 15
      Caption = 'Estoque:'
    end
    object lblEstoque_min: TLabel
      Left = 0
      Top = 106
      Width = 90
      Height = 15
      Caption = 'Estoque M'#237'nimo:'
    end
    object edtNome: TEdit
      Left = 52
      Top = 16
      Width = 110
      Height = 23
      Alignment = taCenter
      TabOrder = 0
    end
    object edtPreco: TEdit
      Left = 52
      Top = 45
      Width = 113
      Height = 23
      Alignment = taCenter
      TabOrder = 1
    end
    object edtEstoque: TEdit
      Left = 52
      Top = 74
      Width = 113
      Height = 23
      Alignment = taCenter
      TabOrder = 2
    end
    object edtEstoqueMinimo: TEdit
      Left = 96
      Top = 103
      Width = 113
      Height = 23
      Alignment = taCenter
      TabOrder = 3
    end
    object btnSalvar: TButton
      Left = 43
      Top = 152
      Width = 75
      Height = 25
      Caption = 'Salvar'
      TabOrder = 4
      OnClick = btnSalvarClick
    end
    object grdProdutos: TDBGrid
      Left = 232
      Top = 0
      Width = 441
      Height = 170
      DataSource = dsProdutos
      TabOrder = 5
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
      Left = 488
      Top = 207
      Width = 270
      Height = 49
      DataSource = dsProdutos
      TabOrder = 6
    end
    object btnNovaVenda: TButton
      Left = 772
      Top = 11
      Width = 110
      Height = 33
      Caption = 'Nova Venda'
      TabOrder = 7
      OnClick = btnNovaVendaClick
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
    Top = 440
  end
  object qryProdutos: TADOQuery
    Active = True
    Connection = conMiniERP
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM produtos')
    Left = 304
    Top = 440
  end
  object dsProdutos: TDataSource
    DataSet = qryProdutos
    Left = 224
    Top = 440
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
    Left = 136
    Top = 440
  end
end
