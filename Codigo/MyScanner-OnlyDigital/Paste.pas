unit Paste;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormPaste = class(TForm)
    lblSizeX: TLabel;
    edtSizeX: TEdit;
    lblSizeY: TLabel;
    edtSizeY: TEdit;
    lblPosX: TLabel;
    edtPosX: TEdit;
    lblPosY: TLabel;
    edtPosY: TEdit;
    btnOk: TButton;
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure setSizeX(value: Single);
    procedure setSizeY(value: Single);
    procedure setOffsetX(value: Single);
    procedure setOffsetY(value: Single);

    function getSizeX():Single;
    function getSizeY():Single;
    function getOffsetX():Single;
    function getOffsetY():Single;
  end;

var
  FormPaste: TFormPaste;

implementation

{$R *.dfm}

procedure TFormPaste.btnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFormPaste.setSizeX(value: Single);
begin
  edtSizeX.Text := FloatToStrF(value, ffFixed, 4, 2);
end;

procedure TFormPaste.setSizeY(value: Single);
begin
  edtSizeY.Text := FloatToStrF(value, ffFixed, 4, 2);
end;

procedure TFormPaste.setOffsetX(value: Single);
begin
  edtPosX.Text := FloatToStrF(value, ffFixed, 4, 2);
end;

procedure TFormPaste.setOffsetY(value: Single);
begin
  edtPosY.Text := FloatToStrF(value, ffFixed, 4, 2);
end;

function TFormPaste.getSizeX():Single;
begin
  Result := StrToFloat(edtSizeX.Text);
end;

function TFormPaste.getSizeY():Single;
begin
  Result := StrToFloat(edtSizeY.Text);
end;

function TFormPaste.getOffsetX():Single;
begin
  Result := StrToFloat(edtPosX.Text);
end;

function TFormPaste.getOffsetY():Single;
begin
  Result := StrToFloat(edtPosY.Text);
end;

end.
