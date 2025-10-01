unit ULogService;

interface

uses
  ULogEntryDTO, UPostgresDAO;

type
  TLogService = class
  private
    FDAO: TPostgresDAO;
  public
    constructor Create(ADao: TPostgresDAO);
    procedure LogEvent(const ADescricao: string);
  end;

implementation

{ TLogService }

constructor TLogService.Create(ADao: TPostgresDAO);
begin
  FDAO := ADao;
end;

procedure TLogService.LogEvent(const ADescricao: string);
begin
end;

end.
