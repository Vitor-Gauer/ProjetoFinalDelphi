unit UFuncoesGlobais;           // Cont�m fun��es gen�ricas o suficiente
                         // para serem usadas por diferentes componentes

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
  // Valida��o simples de email (cont�m '@')
  Result := Pos('@', AEmail) > 0;
end;

class function TAppUtils.FormatarData(ADate: TDateTime): string;
begin
  // Formata a data no padr�o brasileiro
  Result := FormatDateTime('dd/mm/yyyy', ADate);
end;

class function TAppUtils.TextoEstaVazio(const ATexto: string): Boolean;
begin
  // Verifica se o texto, ap�s remover espa�os, � vazio
  Result := Trim(ATexto) = '';
end;

end.
