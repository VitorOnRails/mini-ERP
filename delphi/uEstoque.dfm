object frmEstoque: TfrmEstoque
  Left = 0
  Top = 0
  Caption = 'frmEstoque'
  ClientHeight = 505
  ClientWidth = 697
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 697
    Height = 505
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 464
    ExplicitTop = 288
    ExplicitWidth = 185
    ExplicitHeight = 41
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 695
      Height = 503
      Align = alClient
      DataSource = dsEstoque
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'produto'
          Title.Caption = 'Produtos'
          Width = 200
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'estoque_atual'
          Title.Caption = 'Estoque atual'
          Width = 200
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'estoque_minimo'
          Title.Caption = 'Estoque m'#237'nimo'
          Width = 200
          Visible = True
        end>
    end
  end
  object qryEstoque: TADOQuery
    Active = True
    Connection = conMiniERP
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM vw_AlertaEstoque')
    Left = 72
    Top = 64
  end
  object conMiniERP: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=MSOLEDBSQL19.1;Integrated Security=SSPI;Initial Catalog' +
      '=miniERP;Data Source=localhost;Use Procedure for Prepare=1;Auto ' +
      'Translate=True;Packet Size=4096;Workstation ID=DESKTOP-OG5E8NA;U' +
      'se Encryption for Data=Mandatory;Tag with column collation when ' +
      'possible=False;MARS Connection=False;DataTypeCompatibility=0;Tru' +
      'st Server Certificate=True;Application Intent=READWRITE;MultiSub' +
      'netFailover=False;Use FMTONLY=False;TransparentNetworkIPResoluti' +
      'on=True;Connect Retry Count=1;Connect Retry Interval=10;'
    LoginPrompt = False
    Provider = 'MSOLEDBSQL19.1'
    Left = 72
    Top = 8
  end
  object dsEstoque: TDataSource
    DataSet = qryEstoque
    Left = 72
    Top = 128
  end
end
