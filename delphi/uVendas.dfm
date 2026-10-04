object frmVendas: TfrmVendas
  Left = 0
  Top = 0
  Caption = 'frmVendas'
  ClientHeight = 516
  ClientWidth = 784
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 784
    Height = 516
    Align = alClient
    Caption = 'conMiniERP'
    TabOrder = 0
    object lblProdutos: TLabel
      Left = 0
      Top = 17
      Width = 50
      Height = 17
      Caption = 'Produto:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object lblQtd: TLabel
      Left = 16
      Top = 46
      Width = 25
      Height = 17
      Caption = 'Qtd:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object lblTotal: TLabel
      Left = 216
      Top = 336
      Width = 35
      Height = 21
      Caption = 'Total:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object cboProduto: TComboBox
      Left = 52
      Top = 16
      Width = 125
      Height = 23
      TabOrder = 0
      TextHint = 'Escolha o produto'
    end
    object edtQtd: TEdit
      Left = 52
      Top = 45
      Width = 55
      Height = 23
      TabOrder = 1
    end
    object btnAdicionar: TButton
      Left = 16
      Top = 232
      Width = 75
      Height = 25
      Caption = 'Adicionar'
      TabOrder = 2
      OnClick = btnAdicionarClick
    end
    object grdCarrinho: TStringGrid
      Left = 216
      Top = 46
      Width = 500
      Height = 273
      FixedCols = 0
      RowCount = 2
      TabOrder = 3
    end
    object rgPagamento: TRadioGroup
      Left = 8
      Top = 96
      Width = 185
      Height = 105
      Caption = 'Forma de Pagamento'
      Items.Strings = (
        'Dinheiro'
        'Cart'#227'o'
        'PIX')
      TabOrder = 4
    end
    object btnFinalizar: TButton
      Left = 118
      Top = 232
      Width = 75
      Height = 25
      Caption = 'Finalizar'
      TabOrder = 5
      OnClick = btnFinalizarClick
    end
    object btnCancelarVenda: TButton
      Left = 616
      Top = 15
      Width = 100
      Height = 25
      Caption = 'Cancelar venda'
      TabOrder = 6
      OnClick = btnCancelarVendaClick
    end
    object btnRemoverProduto: TButton
      Left = 494
      Top = 15
      Width = 105
      Height = 25
      Caption = 'Remover produto'
      TabOrder = 7
      OnClick = btnRemoverProdutoClick
    end
  end
  object conMiniERP: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=MSOLEDBSQL19.1;Data Source=localhost;Initial Catalog=mi' +
      'niERP;Integrated Security=SSPI;Trust Server Certificate=True'
    LoginPrompt = False
    Provider = 'MSOLEDBSQL19.1'
    Left = 600
    Top = 392
  end
  object qryProdutos: TADOQuery
    ConnectionString = 
      'Provider=MSOLEDBSQL19.1;Integrated Security=SSPI;Initial Catalog' +
      '=miniERP;Data Source=localhost;Use Procedure for Prepare=1;Auto ' +
      'Translate=True;Packet Size=4096;Workstation ID=DESKTOP-OG5E8NA;U' +
      'se Encryption for Data=Mandatory;Tag with column collation when ' +
      'possible=False;MARS Connection=False;DataTypeCompatibility=0;Tru' +
      'st Server Certificate=True;Application Intent=READWRITE;MultiSub' +
      'netFailover=False;Use FMTONLY=False;TransparentNetworkIPResoluti' +
      'on=True;Connect Retry Count=1;Connect Retry Interval=10;'
    Parameters = <>
    SQL.Strings = (
      'SELECT id, nome, preco FROM produtos ORDER BY nome')
    Left = 664
    Top = 344
  end
  object qryFinalizarVenda: TADOQuery
    Connection = conMiniERP
    Parameters = <
      item
        Name = 'itensJson'
        Attributes = [paNullable, paLong]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = -1
        Value = Null
      end
      item
        Name = 'forma_pagamento'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 30
        Value = Null
      end>
    SQL.Strings = (
      'EXEC usp_RegistrarVenda_JSON :itensJson, :forma_pagamento')
    Left = 664
    Top = 416
  end
end
