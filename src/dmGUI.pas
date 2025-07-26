unit dmGUI;

interface

uses
  System.SysUtils, System.Classes, Vcl.BaseImageCollection, Vcl.ImageCollection;

type
  TDataModuleGui = class(TDataModule)
    ICTabButtons: TImageCollection;
    ICPlayerButtons: TImageCollection;
    ICIcons: TImageCollection;
    ICGraphics: TImageCollection;
    ICSkinIcons: TImageCollection;
    ICSkinPlayerButtons: TImageCollection;
    ICSkinTabButtons: TImageCollection;
    ICSettingsGraphics: TImageCollection;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  DataModuleGui: TDataModuleGui;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
