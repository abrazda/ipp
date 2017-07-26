(* ////////////////////////////////// "ipps.h" /////////////////////////////////
//
//                  INTEL CORPORATION PROPRIETARY INFORMATION
//     This software is supplied under the terms of a license agreement or
//     nondisclosure agreement with Intel Corporation and may not be copied
//     or disclosed except in accordance with the terms of that agreement.
//         Copyright(c) 1999-2012 Intel Corporation. All Rights Reserved.
//
//                 Intel(R) Integrated Performance Primitives
//                      Signal Processing (ippSP)
//
*)

unit ipps;

interface

uses ippdefs;

{$ALIGN OFF}
{$MINENUMSIZE 4}
{$SCOPEDENUMS ON}


(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsGetLibVersion
//  Purpose:    get the library version
//  Parameters:
//  Returns:    pointer to structure describing version of the ipps library
//
//  Notes:      don't free the pointer
*)
function ippsGetLibVersion:PIppLibraryVersion stdcall;
var
  foo: function:PIppLibraryVersion stdcall;

{LINE 64}
(* /////////////////////////////////////////////////////////////////////////////
//                   Functions to allocate and free memory
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsMalloc
//  Purpose:    32-byte aligned memory allocation
//  Parameter:
//    len       number of elements (according to their type)
//  Returns:    pointer to allocated memory
//
//  Notes:      the memory allocated by ippsMalloc has to be free by ippsFree
//              function only.
*)

function ippsMalloc_8u(len: Integer): PIpp8u stdcall;
function ippsMalloc_16u(len: Integer): PIpp16u stdcall;
function ippsMalloc_32u(len: Integer): PIpp32u stdcall;
function ippsMalloc_8s(len: Integer): PIpp8s stdcall;
function ippsMalloc_16s(len: Integer): PIpp16s stdcall;
function ippsMalloc_32s(len: Integer): PIpp32s stdcall;
function ippsMalloc_64s(len: Integer): PIpp64s stdcall;

function ippsMalloc_32f(len: Integer): PIpp32f stdcall;
function ippsMalloc_64f(len: Integer): PIpp64f stdcall;

function ippsMalloc_8sc(len: Integer): PIpp8sc stdcall;
function ippsMalloc_16sc(len: Integer): PIpp16sc stdcall;
function ippsMalloc_32sc(len: Integer): PIpp32sc stdcall;
function ippsMalloc_64sc(len: Integer): PIpp64sc stdcall;
function ippsMalloc_32fc(len: Integer): PIpp32fc stdcall;
function ippsMalloc_64fc(len: Integer): PIpp64fc stdcall;

{LINE 97}
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsFree
//  Purpose:    free memory allocated by the ippsMalloc functions
//  Parameter:
//    ptr       pointer to the memory allocated by the ippsMalloc functions
//
//  Notes:      use the function to free memory allocated by ippsMalloc_*
*)
procedure ippsFree(ptr: pointer) stdcall;

{LINE 127}
(* /////////////////////////////////////////////////////////////////////////////
//                   Vector Initialization functions
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsCopy
//  Purpose:    copy data from source to destination vector
//  Parameters:
//    pSrc        pointer to the input vector
//    pDst        pointer to the output vector
//    len         length of the vectors, number of items
//  Return:
//    ippStsNullPtrErr        pointer(s) to the data is NULL
//    ippStsSizeErr           length of the vectors is less or equal zero
//    ippStsNoErr             otherwise
*)

function ippsCopy_8u(const pSrc: PIpp8u; pDst: PIpp8u; len: Integer ): IppStatus stdcall;

{LINE 196}
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsMove
//  Purpose:    The ippsMove function copies "len" elements from src to dst.
//              If some regions of the source area and the destination overlap,
//              ippsMove ensures that the original source bytes in the overlapping
//              region are copied before being overwritten.
//
//  Parameters:
//    pSrc        pointer to the input vector
//    pDst        pointer to the output vector
//    len         length of the vectors, number of items
//  Return:
//    ippStsNullPtrErr        pointer(s) to the data is NULL
//    ippStsSizeErr           length of the vectors is less or equal zero
//    ippStsNoErr             otherwise
*)
function ippsMove_8u(const pSrc:PIpp8u; pDst:PIpp8u; len: Integer):IppStatus stdcall;

{LINE 217}
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsZero
//  Purpose:    set elements of the vector to zero of corresponding type
//  Parameters:
//    pDst       pointer to the destination vector
//    len        length of the vectors
//  Return:
//    ippStsNullPtrErr        pointer to the vector is NULL
//    ippStsSizeErr           length of the vectors is less or equal zero
//    ippStsNoErr             otherwise
*)
function ippsZero_8u(pDst: PIpp8u; len: integer ):IppStatus stdcall;

function ippsSwapBytes_16u(const pSrc: PIpp16u; pDst: PIpp16u; len: Integer):IppStatus stdcall;
function ippsSwapBytes_24u(const pSrc: PIpp8u;  pDst: PIpp8u;  len: Integer):IppStatus stdcall;
function ippsSwapBytes_32u(const pSrc: PIpp32u; pDst: PIpp32u; len: Integer):IppStatus stdcall;
function ippsSwapBytes_64u(const pSrc: PIpp64u; pDst: PIpp64u; len: Integer):IppStatus stdcall;



implementation

uses
  ipplibs;

function ippsGetLibVersion;external ippslib {$ifdef MSWindows}delayed{$endif};

function ippsMalloc_8u;external ippslib {$ifdef MSWindows}delayed{$endif};
function ippsMalloc_16u;external ippslib {$ifdef MSWindows}delayed{$endif};
function ippsMalloc_32u;external ippslib {$ifdef MSWindows}delayed{$endif};

function ippsMalloc_8s;external ippslib {$ifdef MSWindows}delayed{$endif};
function ippsMalloc_16s;external ippslib {$ifdef MSWindows}delayed{$endif};
function ippsMalloc_32s;external ippslib {$ifdef MSWindows}delayed{$endif};
function ippsMalloc_64s;external ippslib {$ifdef MSWindows}delayed{$endif};

function ippsMalloc_32f;external ippslib {$ifdef MSWindows}delayed{$endif};
function ippsMalloc_64f;external ippslib {$ifdef MSWindows}delayed{$endif};

function ippsMalloc_8sc;external ippslib {$ifdef MSWindows}delayed{$endif};
function ippsMalloc_16sc;external ippslib {$ifdef MSWindows}delayed{$endif};
function ippsMalloc_32sc;external ippslib {$ifdef MSWindows}delayed{$endif};
function ippsMalloc_64sc;external ippslib {$ifdef MSWindows}delayed{$endif};
function ippsMalloc_32fc;external ippslib {$ifdef MSWindows}delayed{$endif};
function ippsMalloc_64fc;external ippslib {$ifdef MSWindows}delayed{$endif};

procedure ippsFree(ptr: pointer);external ippslib {$ifdef MSWindows}delayed{$endif};
function ippsCopy_8u;external ippslib {$ifdef MSWindows}delayed{$endif};
function ippsMove_8u;external ippslib {$ifdef MSWindows}delayed{$endif};
function ippsZero_8u;external ippslib {$ifdef MSWindows}delayed{$endif};

function ippsSwapBytes_16u;external ippslib {$ifdef MSWindows}delayed{$endif};
function ippsSwapBytes_24u;external ippslib {$ifdef MSWindows}delayed{$endif};
function ippsSwapBytes_32u;external ippslib {$ifdef MSWindows}delayed{$endif};
function ippsSwapBytes_64u;external ippslib {$ifdef MSWindows}delayed{$endif};


end.
