unit UFuncoesGlobais;           // Contém funções genéricas o suficiente
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
  // Validação simples de email (contém '@')
  Result := Pos('@', AEmail) > 0;
end;

class function TAppUtils.FormatarData(ADate: TDateTime): string;
begin
  // Formata a data no padrão brasileiro
  Result := FormatDateTime('dd/mm/yyyy', ADate);
end;

class function TAppUtils.TextoEstaVazio(const ATexto: string): Boolean;
begin
  // Verifica se o texto, após remover espaços, é vazio
  Result := Trim(ATexto) = '';
end;

end.
