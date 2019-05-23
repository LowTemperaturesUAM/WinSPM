unit ControlPID;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin;

type
  TPIDControl = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    SpinEdit1: TSpinEdit;
    Label8: TLabel;
    Label9: TLabel;
    SpinEdit2: TSpinEdit;
    Label10: TLabel;
    SpinEdit3: TSpinEdit;
    Label11: TLabel;
    Label12: TLabel;
    SpinEdit4: TSpinEdit;
    Label13: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PIDControl: TPIDControl;

implementation

{$R *.DFM}

end.
