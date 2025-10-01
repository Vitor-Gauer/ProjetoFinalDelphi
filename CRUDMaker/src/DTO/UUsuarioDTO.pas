unit UUsuarioDTO;

interface

uses
  System.SysUtils;

type
  TUsuarioDTO = class
  private
    FNome: string;
    FSenha: string;
    FDataTentativa: TDateTime;
  public
    property Nome: string read FNome write FNome;
    property SenhaColocada: string read FSenha write FSenha;
    property DataTentativa: TDateTime read FDataTentativa write FDataTentativa;
  end;

implementation

end.
