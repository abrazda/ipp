(* /////////////////////////////////////////////////////////////////////////////
//
//                  INTEL CORPORATION PROPRIETARY INFORMATION
//     This software is supplied under the terms of a license agreement or
//     nondisclosure agreement with Intel Corporation and may not be copied
//     or disclosed except in accordance with the terms of that agreement.
//          Copyright(c) 2004-2013 Intel Corporation. All Rights Reserved.
//
//                  Intel(R) Performance Primitives
//                  Data Compression Library (ippDC)
//
*)
unit ippdc;

interface

uses ippdefs;

{1772}
(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippsCRC32
//  Purpose:            Computes the CRC32(ITUT V.42) checksum for the source vector.
//
//  Parameters:
//   pSrc               Pointer to the source vector.
//   srcLen             Length of the source vector.
//   pCRC32             Pointer to the checksum value.
//  Return:
//   ippStsNoErr        Indicates no error.
//   ippStsNullPtrErr   Indicates an error when the pSrc pointer is NULL.
//   ippStsSizeErr      Indicates an error when the length of the source vector is less
//                      than or equal to zero.
//
*)
function ippsCRC32_8u(const pSrc:pIpp8u; srcLen: Integer; var CRC32:Ipp32u):IppStatus stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippsCRC32C
//  Purpose:            Computes the CRC32C (the polinomial 0x11EDC6F41) value
//                      for the source vector.
//                      Reference: "Optimization of cyclic redundancy-check
//                      codes with 24 and 32 parity bits". Castagnoli, G.;
//                      Brauer, S.; Herrmann, M.; Communications,
//                      IEEE Transactions on Volume 41, Issue 6,
//                      June 1993 Page(s):883 - 892.
//
//  Parameters:
//   pSrc               Pointer to the source vector
//   srcLen             Length of the source vector
//   pCRC32C            Pointer to the CRC32C value
//  Return:
//   ippStsNoErr        No errors
//   ippStsNullPtrErr   One or several pointer(s) is NULL
//   ippStsSizeErr      Length of the source vector is equal zero
//
*)
function ippsCRC32C_8u(const pSrc: pIpp8u; srcLen: Ipp32u; var CRC32C:Ipp32u):IppStatus stdcall;

implementation

uses ipplibs;

//function ippsCRC32_8u; external ippdclib Name '_ippsCRC32_8u@12' delayed;
//function ippsCRC32C_8u; external ippdclib Name '_ippsCRC32C_8u@12' delayed;

function ippsCRC32_8u; external ippdclib delayed;
function ippsCRC32C_8u; external ippdclib delayed;

end.
