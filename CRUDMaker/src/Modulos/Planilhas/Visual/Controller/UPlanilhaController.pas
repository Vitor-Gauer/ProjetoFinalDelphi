unit UPlanilhaController;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  UTabelaDTO, UPlanilhaDTO, UInfoTabelaPlanilhaDTO,
  UPlanilhaService;

type
  TPlanilhaController = class
  private
    FPlanilhaService: TPlanilhaService;
  public
    constructor Create(APlanilhaService: TPlanilhaService);
    destructor Destroy; override;
    function SolicitarInfoTabelas(const ANomePlanilha: string): TObjectList<TInfoTabelaPlanilhaDTO>;
  end;

implementation

{ TPlanilhaController }

constructor TPlanilhaController.Create(APlanilhaService: TPlanilhaService);
begin
  inherited Create;
  FPlanilhaService := APlanilhaService;
end;

destructor TPlanilhaController.Destroy;
begin
  inherited;
end;

function TPlanilhaController.SolicitarInfoTabelas(const ANomePlanilha: string): TObjectList<TInfoTabelaPlanilhaDTO>;
begin
  // O Controller repassa a chamada para o Service
  if Assigned(FPlanilhaService) then
  begin
    Result := FPlanilhaService.ObterInfoTabelasDaPlanilha(ANomePlanilha);
  end
  else
  begin
    Result := TObjectList<TInfoTabelaPlanilhaDTO>.Create(True);
  end;
end;

end.
