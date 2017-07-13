unit ippMemoryManager;

interface

implementation

uses
  System.SysUtils,
  ippdefs,ippcore,ipps;

function GetMem(Size: NativeInt): Pointer;
begin
  if Size>MaxInt then
    exit(nil);

  Result:=ippMalloc(Size);
end;

function FreeMem(P: Pointer): Integer;
begin
  ippFree(P);
  Result:=0;
end;

function ReallocMem(P: Pointer; Size: NativeInt): Pointer;
begin
  Result:=GetMem(Size);

  if Result=nil then
    raise EOutOfMemory.Create('Could not reallocmem');

  if ippsMove_8u(PIpp8u(P),PIpp8U(Result),Size)=IppStatus.ippStsNoErr then
    ;
  FreeMem(P);
end;

{Extended (optional) functionality.}
function AllocMem(Size: NativeInt): Pointer;
begin
  if Size>MaxInt then
    exit(nil);

  Result:=GetMem(Size);

  if Assigned(Result) then
    ippsZero_8u(Result,Size);
end;

function RegisterExpectedMemoryLeak(P: Pointer): Boolean;
begin

end;

function UnregisterExpectedMemoryLeak(P: Pointer): Boolean;
begin

end;

procedure InitMemoryManager;
var
  MemoryManager: TMemoryManagerEx;
begin
  MemoryManager.GetMem:=GetMem;
  MemoryManager.FreeMem:=FreeMem;
  MemoryManager.ReallocMem:=ReallocMem;

  MemoryManager.AllocMem:=AllocMem;
  MemoryManager.RegisterExpectedMemoryLeak:=nil;
  MemoryManager.UnregisterExpectedMemoryLeak:=nil;
end;

initialization
  InitMemoryManager;
finalization

end.
