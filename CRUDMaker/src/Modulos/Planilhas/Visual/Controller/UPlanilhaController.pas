unit UPlanilhaController;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  UTabelaDTO, UPlanilhaDTO,
  UPlanilhaService;

type
  TPlanilhaController = class
  private
    FPlanilhaService: TPlanilhaService;
  public
    constructor Create(APlanilhaService: TPlanilhaService);
    destructor Destroy; override;
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

end.
