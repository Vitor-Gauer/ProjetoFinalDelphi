unit UFuncoesGlobais;

interface

uses
  System.SysUtils;

type
  TAppUtils = class
  public
    class function ValidarEmail(const AEmail: string): Boolean; static;
    class function FormatarData(ADate: TDateTime): string; static;
    class function TextoEstaVazio(const ATexto: string): Boolean; static;
  end;

implementation

{ TAppUtils }

class function TAppUtils.ValidarEmail(const AEmail: string): Boolean;
begin
  Result := Pos('@', AEmail) > 0;
end;

class function TAppUtils.FormatarData(ADate: TDateTime): string;
begin
  Result := FormatDateTime('dd/mm/yyyy', ADate);
end;

class function TAppUtils.TextoEstaVazio(const ATexto: string): Boolean;
begin
  Result := Trim(ATexto) = '';
end;

end.
