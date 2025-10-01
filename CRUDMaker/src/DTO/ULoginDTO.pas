unit ULoginDTO;    // Do "usuario" pro banco

interface

uses
  System.SysUtils;

type
  TLoginDTO = class
  private
    FUsuario: string;
    FSenha: string;
  public
    property Usuario: string read FUsuario write FUsuario;
    property Senha: string read FSenha write FSenha;
  end;

implementation

end.
