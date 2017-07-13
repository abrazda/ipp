unit ippcp;

interface

uses ippdefs;

type
  IppsSHA256State=record
  end;
  PIppsSHA256State=^IppsSHA256State;

(* SHA256 Hash Primitives *)
function ippsSHA256GetSize(var ASize:NativeInt):IppStatus stdcall;
function ippsSHA256Init(Ctx:PIppsSHA256State):IppStatus stdcall;
//function ippsSHA256Duplicate(const pSrcCtx:PIppsSHA256State; pDstCtx:PIppsSHA256State):IppStatus stdcall;

//function ippsSHA256Pack(const pCtx:PIppsSHA256State; pBuffer:PIpp8u):IppStatus stdcall;
//function ippsSHA256Unpack(const pBuffer:PIpp8u; pCtx:PIppsSHA256State):IppStatus stdcall;

function ippsSHA256Update(const pSrc:PIpp8u; len:Integer; pCtx:PIppsSHA256State):IppStatus stdcall;
//function ippsSHA256GetTag(pTag:PIpp8u; tagLen:Ipp32u; const pCtx:PIppsSHA256State):IppStatus stdcall;
function ippsSHA256Final(pMD: PIpp8u; pCtx:PIppsSHA256State):IppStatus stdcall;
//function ippsSHA256MessageDigest(const pMsg:PIpp8u; len:Integer; pMD:PIpp8u):IppStatus stdcall;

implementation

uses
  ipplibs;

//const
//  ippcplib='sha256.dll';
(*
function ippsSHA256GetSize; external ippcplib Name '_ippsSHA256GetSize@4' delayed;
function ippsSHA256Init; external ippcplib Name '_ippsSHA256Init@4' delayed;
//function ippsSHA256Duplicate; external ippcplib Name '_ippsSHA256Duplicate@8' delayed;

//function ippsSHA256Pack; external ippcplib Name '_ippsSHA256Pack@8' delayed;
//function ippsSHA256Unpack; external ippcplib Name '_ippsSHA256Unpack@8' delayed;

function ippsSHA256Update; external ippcplib Name '_ippsSHA256Update@12' delayed;
//function ippsSHA256GetTag; external ippcplib Name '_ippsSHA256GetTag@12' delayed;
function ippsSHA256Final; external ippcplib Name '_ippsSHA256Final@8' delayed;
//function ippsSHA256MessageDigest; external ippcplib Name '_ippsSHA256MessageDigest@12' delayed;
*)


function ippsSHA256GetSize; external ippcplib delayed;
function ippsSHA256Init; external ippcplib delayed;
//function ippsSHA256Duplicate; external ippcplib delayed;

//function ippsSHA256Pack; external ippcplib delayed;
//function ippsSHA256Unpack; external ippcplib delayed;

function ippsSHA256Update; external ippcplib delayed;
//function ippsSHA256GetTag; external ippcplib delayed;
function ippsSHA256Final; external ippcplib delayed;
//function ippsSHA256MessageDigest; external ippcplib delayed;


end.
