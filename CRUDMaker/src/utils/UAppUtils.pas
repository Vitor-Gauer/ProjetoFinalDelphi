unit UAppUtils;           // Contém funções genéricas o suficiente
                         // para serem usadas por diferentes componentes

interface

uses
  System.SysUtils;

type
  TAppUtils = class
  public
    class function IsValidEmail(const AEmail: string): Boolean; static;
    class function FormatDate(ADate: TDateTime): string; static;
  end;

implementation

{ TAppUtils }

class function TAppUtils.IsValidEmail(const AEmail: string): Boolean;
begin
  Result := Pos('@', AEmail) > 0;
end;

class function TAppUtils.FormatDate(ADate: TDateTime): string;
begin
  Result := FormatDateTime('dd/mm/yyyy', ADate);
end;

end.
