unit ippcore;

interface

uses
  ippdefs;

{LINE 43}
type IppAffinityType=(
    ippAffinityCompactFineCore, (* KMP_AFFINITY=granularity=fine,compact,n,offset, where n - level *)
    ippAffinityCompactFineHT,   (* KMP_AFFINITY=granularity=fine,compact,0,offset *)
    ippAffinityAllEnabled,      (* KMP_AFFINITY=respect *)
    ippAffinityRestore,
    ippTstAffinityCompactFineCore, (* test mode for affinity type ippAffinityCompactFineCore *)
    ippTstAffinityCompactFineHT    (* test mode for affinity type ippAffinityCompactFineHT   *)
) ;


(* /////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//                   Functions declarations
////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////// *)

{LINE 60}
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippGetLibVersion
//  Purpose:    getting of the library version
//  Returns:    the structure of information about version
//              of ippcore library
//  Parameters:
//
//  Notes:      not necessary to release the returned structure
*)
function ippGetLibVersion():PIppLibraryVersion;stdcall;

{LINE 72}
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippGetStatusString
//  Purpose:    convert the library status code to a readable string
//  Parameters:
//    StsCode   IPP status code
//  Returns:    pointer to string describing the library status code
//
//  Notes:      don't free the pointer
*)
function ippGetStatusString(StsCode: IppStatus):PAnsiChar;stdcall;

{LINE 95}
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippGetCpuClocks
//  Purpose:    reading of time stamp counter (TSC) register value
//  Returns:    TSC value
//
//  Note:      An hardware exception is possible if TSC reading is not supported by
/              the current chipset
*)

function ippGetCpuClocks():Ipp64u; stdcall;

{LINE 107}
(* ///////////////////////////////////////////////////////////////////////////
//  Names:  ippSetFlushToZero,
//          ippSetDenormAreZero.
//
//  Purpose: ippSetFlushToZero enables or disables the flush-to-zero mode,
//           ippSetDenormAreZero enables or disables the denormals-are-zeros
//           mode.
//
//  Arguments:
//     value       - !0 or 0 - set or clear the corresponding bit of MXCSR
//     pUMask      - pointer to user store current underflow exception mask
//                   ( may be NULL if don't want to store )
//
//  Return:
//   ippStsNoErr              - Ok
//   ippStsCpuNotSupportedErr - the mode is not supported
*)

function ippSetFlushToZero(value: Integer; pUMask: PCardinal):IppStatus; stdcall;
function ippSetDenormAreZeros(value: Integer): IppStatus; stdcall;

{LINE 130}
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippAlignPtr
//  Purpose:    pointer aligning
//  Returns:    aligned pointer
//
//  Parameter:
//    ptr        - pointer
//    alignBytes - number of bytes to align
//
*)
function ippAlignPtr(ptr:Pointer;alignBytes: Integer ):Pointer;stdcall;
{LINE 142}
(* /////////////////////////////////////////////////////////////////////////////
//                   Functions to allocate and free memory
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippMalloc
//  Purpose:    64-byte aligned memory allocation
//  Parameter:
//    len       number of bytes
//  Returns:    pointer to allocated memory
//
//  Notes:      the memory allocated by ippMalloc has to be free by ippFree
//              function only.
*)

function ippMalloc(length: Integer): Pointer; stdcall;

{LINE 159}
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippFree
//  Purpose:    free memory allocated by the ippMalloc function
//  Parameter:
//    ptr       pointer to the memory allocated by the ippMalloc function
//
//  Notes:      use the function to free memory allocated by ippMalloc
*)
procedure ippFree(ptr:pointer); stdcall;

{LINE 186}
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippInit
//  Purpose:    Automatic switching to best for current cpu library code using.
//  Returns:
//   ippStsNoErr
//
//  Parameter:  nothing
//
//  Notes:      At the moment of this function execution no any other IPP function
//              has to be working
*)
function ippInit():IppStatus; stdcall;

{LINE 242}
(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippGetCpuFreqMhz
//
//  Purpose:    the function estimates cpu frequency and returns
//              its value in MHz as a integer
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         null pointer to the freq value
//    ippStsSizeErr            wrong num of tries, internal var
//  Arguments:
//    pMhz                     pointer to the integer to write
//                             cpu freq value estimated
//
//  Notes:      no exact value is guaranteed, the value could
//              vary with cpu workloading
*)

function ippGetCpuFreqMhz(pMhz: PInteger):IppStatus; stdcall;

{LINE 295}
(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippGetMaxCacheSizeB
//
//  Purpose:  Detects maximal from the sizes of L2 or L3 in bytes
//
//  Return:
//    ippStsNullPtrErr         The result's pointer is NULL.
//    ippStsNotSupportedCpu    The cpu is not supported.
//    ippStsUnknownCacheSize   The cpu is supported, but the size of the cache is unknown.
//    ippStsNoErr              Ok
//
//  Arguments:
//    pSizeByte                Pointer to the result
//
//  Note:
//    1). Intel(R) processors are supported only.
//    2). Intel(R) Itanium(R) processors and platforms with Intel XScale(R) technology are unsupported
//    3). For unsupported processors the result is "0",
//        and the return status is "ippStsNotSupportedCpu".
//    4). For supported processors the result is "0",
//        and the return status is "ippStsUnknownCacheSize".
//        if sizes of the cache is unknown.
//
*)
function ippGetMaxCacheSizeB(var SizeByte:Integer):IppStatus; stdcall;

{LINE 330}
(*
//  Name:       ippGetCpuFeatures
//  Purpose:    Detects CPU features.
//  Parameters:
//    pFeaturesMask   Pointer to the features mask.
//                    Nonzero value of bit means the corresponding feature is supported.
//                    Features mask values are defined in the ippdefs.h
//                      [ 0] - MMX        ( ippCPUID_MMX   )
//                      [ 1] - SSE        ( ippCPUID_SSE   )
//                      [ 2] - SSE2       ( ippCPUID_SSE2  )
//                      [ 3] - SSE3       ( ippCPUID_SSE3  )
//                      [ 4] - SSSE3      ( ippCPUID_SSSE3 )
//                      [ 5] - MOVBE      ( ippCPUID_MOVBE )
//                      [ 6] - SSE41      ( ippCPUID_SSE41 )
//                      [ 7] - SSE42      ( ippCPUID_SSE42 )
//                      [ 8] - AVX        ( ippCPUID_AVX   )
//                      [ 9] - ENABLEDBYOS( ippAVX_ENABLEDBYOS )
//                      [10] - AES        ( ippCPUID_AES   )
//                      [11] - PCLMULQDQ  ( ippCPUID_CLMUL )
//                      [12] - ABR        ( ippCPUID_ABR )
//                      [13] - RDRAND     ( ippCPUID_RDRAND )
//                      [14] - F16C       ( ippCPUID_F16C )
//                      [15] - AVX2       ( ippCPUID_AVX2 )
//                      [16] - ADOX/ADCX  ( ippCPUID_ADCOX )      ADCX and ADOX instructions
//                      [17] - RDSEED     ( ippCPUID_RDSEED )     The RDSEED instruction
//                      [18] - PREFETCHW  ( ippCPUID_PREFETCHW )  The PREFETCHW instruction
//                      [19] - SHA        ( ippCPUID_SHA )        Intel (R) SHA Extensions
//                      [20:63] - Reserved
//
//    pCpuidInfoRegs  Pointer to the 4-element vector.
//                    Result of CPUID.1 are stored in this vector.
//                      [0] - register EAX
//                      [1] - register EBX
//                      [2] - register ECX
//                      [3] - register EDX
//                    If pointer pCpuidInfoRegs is set to NULL, registers are not stored.
//
//  Returns:
//    ippStsNullPtrErr         The pointer to the features mask (pFeaturesMask) is NULL.
//    ippStsNotSupportedCpu    CPU is not supported.
//    ippStsNoErr              Ok
//
//  Note: Only IA-32 and Intel(R) 64 are supported
*)
type
  TCpuidInfoRegs= array [0..3] of Ipp32u;
function ippGetCpuFeatures(const FeaturesMask:Ipp64u; var CpuidInfoRegs: TCpuidInfoRegs):IppStatus; stdcall;

implementation

uses
  ipplibs;

function ippGetLibVersion; external ippcorelib delayed;
function ippGetStatusString; external ippcorelib delayed;
function ippGetCpuClocks; external ippcorelib delayed;
function ippSetFlushToZero; external ippcorelib delayed;
function ippSetDenormAreZeros; external ippcorelib delayed;
function ippAlignPtr; external ippcorelib delayed;
function ippMalloc; external ippcorelib delayed;
procedure ippFree; external ippcorelib delayed;
function ippInit; external ippcorelib delayed;
function ippGetCpuFreqMhz; external ippcorelib delayed;
function ippGetMaxCacheSizeB; external ippcorelib delayed;
function ippGetCpuFeatures; external ippcorelib delayed;

end.
