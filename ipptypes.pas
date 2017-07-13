(*
// Copyright 1999 2016 Intel Corporation All Rights Reserved.
//
// The source code, information and material ("Material") contained herein is
// owned by Intel Corporation or its suppliers or licensors, and title
// to such Material remains with Intel Corporation or its suppliers or
// licensors. The Material contains proprietary information of Intel
// or its suppliers and licensors. The Material is protected by worldwide
// copyright laws and treaty provisions. No part of the Material may be used,
// copied, reproduced, modified, published, uploaded, posted, transmitted,
// distributed or disclosed in any way without Intel's prior express written
// permission. No license under any patent, copyright or other intellectual
// property rights in the Material is granted to or conferred upon you,
// either expressly, by implication, inducement, estoppel or otherwise.
// Any license under such intellectual property rights must be express and
// approved by Intel in writing.
//
// Unless otherwise agreed by Intel in writing,
// you may not remove or alter this notice or any other notice embedded in
// Materials by Intel or Intel's suppliers or licensors in any way.
//
*)

(*
//              Intel(R) Integrated Performance Primitives
//              Derivative Types and Macro Definitions
//
//              The main purpose of this header file is
//              to support compatibility with the legacy
//              domains until their end of life.
//
*)

unit ipptypes;

interface

uses ippdefs;

{.$ALIGN OFF}
{$MINENUMSIZE 4}
{$SCOPEDENUMS ON}


{LINE 47}
const
  ippCPUID_MMX       = $00000001;  (* Intel Architecture MMX technology supported  *)
  ippCPUID_SSE       = $00000002;  (* Streaming SIMD Extensions                    *)
  ippCPUID_SSE2      = $00000004;  (* Streaming SIMD Extensions 2                  *)
  ippCPUID_SSE3      = $00000008;  (* Streaming SIMD Extensions 3                  *)
  ippCPUID_SSSE3     = $00000010;  (* Supplemental Streaming SIMD Extensions 3     *)
  ippCPUID_MOVBE     = $00000020;  (* The processor supports MOVBE instruction     *)
  ippCPUID_SSE41     = $00000040;  (* Streaming SIMD Extensions 4.1                *)
  ippCPUID_SSE42     = $00000080;  (* Streaming SIMD Extensions 4.2                *)
  ippCPUID_AVX       = $00000100;  (* Advanced Vector Extensions instruction set   *)
  ippAVX_ENABLEDBYOS = $00000200;  (* The operating system supports AVX            *)
  ippCPUID_AES       = $00000400;  (* AES instruction                              *)
  ippCPUID_CLMUL     = $00000800;  (* PCLMULQDQ instruction                        *)
  ippCPUID_ABR       = $00001000;  (* Reserved                                     *)
  ippCPUID_RDRRAND   = $00002000;  (* Read Random Number instructions              *)
  ippCPUID_F16C      = $00004000;  (* Float16 instructions                         *)
  ippCPUID_AVX2      = $00008000;  (* Advanced Vector Extensions 2 instruction set *)
  ippCPUID_ADCOX     = $00010000;  (* ADCX and ADOX instructions                   *)
  ippCPUID_RDSEED    = $00020000;  (* The RDSEED instruction                       *)
  ippCPUID_PREFETCHW = $00040000;  (* The PREFETCHW instruction                    *)
  ippCPUID_SHA       = $00080000;  (* Intel (R) SHA Extensions                     *)
  ippCPUID_AVX512F   = $00100000;  (* AVX-512 Foundation instructions              *)
  ippCPUID_AVX512CD  = $00200000;  (* AVX-512 Conflict Detection instructions      *)
  ippCPUID_AVX512ER  = $00400000;  (* AVX-512 Exponential & Reciprocal instructions*)
  ippCPUID_AVX512PF  = $00800000;  (* AVX-512 Prefetch instructions                *)
  ippCPUID_AVX512BW  = $01000000;  (* AVX-512 Byte & Word instructions             *)
  ippCPUID_AVX512DQ  = $02000000;  (* AVX-512 DWord & QWord instructions           *)
  ippCPUID_AVX512VL  = $04000000;  (* AVX-512 Vector Length extensions             *)
  ippCPUID_AVX512VBMI= $08000000;  (* AVX-512 Vector Length extensions             *)
  ippCPUID_MPX       = $10000000;  (* Intel MPX (Memory Protection Extensions)     *)
  ippCPUID_KNC       = $80000000;  (* Intel(R) Xeon Phi(TM) Coprocessor            *)

{LINE 89}
(*****************************************************************************)
(*                   Below are ippSP domain specific definitions             *)
(*****************************************************************************)
type
  IppRoundMode=(
    ippRndZero,
    ippRndNear,
    ippRndFinancial,
    ippRndHintAccurate=$10
  );

  IppHintAlgorithm=(
    ippAlgHintNone,
    ippAlgHintFast,
    ippAlgHintAccurate
  );

  IppCmpOp=(
    ippCmpLess,
    ippCmpLessEq,
    ippCmpEq,
    ippCmpGreaterEq,
    ippCmpGreater
  );

{LINE 134}
  IPP_FFT_ENUM=(
    IPP_FFT_DIV_FWD_BY_N = 1,
    IPP_FFT_DIV_INV_BY_N = 2,
    IPP_FFT_DIV_BY_SQRTN = 4,
    IPP_FFT_NODIV_BY_ANY = 8
  );

  IPP_DIV_ENUM=(
    IPP_DIV_FWD_BY_N = 1,
    IPP_DIV_INV_BY_N = 2,
    IPP_DIV_BY_SQRTN = 4,
    IPP_NODIV_BY_ANY = 8
  );

{LINE 240}
(*****************************************************************************)
(*                   Below are ippIP domain specific definitions             *)
(*****************************************************************************)

{$LINE 265}
type
  IppChannels=(
     ippC0    =  0,
     ippC1    =  1,
     ippC2    =  2,
     ippC3    =  3,
     ippC4    =  4,
     ippP2    =  5,
     ippP3    =  6,
     ippP4    =  7,
     ippAC1   =  8,
     ippAC4   =  9,
     ippA0C4  = 10,
     ippAP4   = 11
  );

  IppiBorderType=(
    ippBorderRepl         =  1,
    ippBorderWrap         =  2,
    ippBorderMirror       =  3, (* left border: 012... -> 21012... *)
    ippBorderMirrorR      =  4, (* left border: 012... -> 210012... *)
    ippBorderDefault      =  5,
    ippBorderConst        =  6,
    ippBorderTransp       =  7,
    ippBorderInMemTop     =  $0010,
    ippBorderInMemBottom  =  $0020,
    ippBorderInMemLeft    =  $0040,
    ippBorderInMemRight   =  $0080,
    ippBorderInMem        =  ippBorderInMemLeft or ippBorderInMemTop or ippBorderInMemRight or ippBorderInMemBottom
  );


implementation

end.
