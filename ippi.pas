(* /////////////////////////////////////////////////////////////////////////////
//
//                  INTEL CORPORATION PROPRIETARY INFORMATION
//     This software is supplied under the terms of a license agreement or
//     nondisclosure agreement with Intel Corporation and may not be copied
//     or disclosed except in accordance with the terms of that agreement.
//       Copyright (c) 1999-2012 Intel Corporation. All Rights Reserved.
//
//                Intel(R) Integrated Performance Primitives
//                           Image Processing
//
*)

unit ippi;

interface

uses ippdefs, ipptypes;

{$ALIGN OFF}
{$MINENUMSIZE 4}
{$SCOPEDENUMS ON}

type
  TVectorD=array [0..2] of double;

  TMatrixD=record
    function Inverse: TMatrixD;

    case Integer of
      0: (m11,m12,m13,m21,m22,m23:double);
      1: (M:array [0..1] of TVectorD);
  end;

  TPointD=record
    X: double;
    Y: double;
  end;

  TRectD=record
  case Integer of
    0: (Left, Top, Right, Bottom: double);
    1: (TopLeft, BottomRight: TPointD);
  end;

  TQPointD=array [0..3] of TPointD;
  PQPointD=^TQPointD;

{LINE 91}
type
  PIppiBorderSize=^IppiBorderSize;
  IppiBorderSize=record
    borderLeft: Ipp32u;
    borderTop: Ipp32u;
    borderRight: Ipp32u;
    borderBottom: Ipp32u;
  public
    constructor Create(ALeft,ATop,ARight,ABottom:Ipp32u);
  end;

 IppiInterpolationType=(
    ippNearest = IPPI_INTER_NN,
    ippLinear = IPPI_INTER_LINEAR,
    ippCubic = IPPI_INTER_CUBIC2P_CATMULLROM,
    ippLanczos = IPPI_INTER_LANCZOS,
    ippHahn = 0,
    ippSuper = IPPI_INTER_SUPER
  );

//typedef struct ResizeSpec_32f   IppiResizeSpec_32f;
  PIppiResizeSpec_32f=type of pointer;
//typedef struct IppiWarpSpec     IppiWarpSpec;
  PIppiWarpSpec=type of pointer;

{LINE 119}
(* /////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//                   Functions declarations
////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////// *)


(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiGetLibVersion
//  Purpose:    gets the version of the library
//  Returns:    structure containing information about the current version of
//  the Intel IPP library for image processing
//  Parameters:
//
//  Notes:      there is no need to release the returned structure
*)
function ippiGetLibVersion():PIppLibraryVersion stdcall;
{LINE 176}
(* /////////////////////////////////////////////////////////////////////////////
//                   Memory Allocation Functions
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiMalloc
//  Purpose:    allocates memory with 32-byte aligned pointer for ippIP images,
//              every line of the image is aligned due to the padding characterized
//              by pStepBytes
//  Parameter:
//    widthPixels   width of image in pixels
//    heightPixels  height of image in pixels
//    pStepBytes    pointer to the image step, it is an output parameter
//                  calculated by the function
//
//  Returns:    pointer to the allocated memory or NULL if out of memory or wrong parameters
//  Notes:      free the allocated memory using the function ippiFree only
*)
function ippiMalloc_8u_C1(widthPixels: Integer; heightPixels: Integer; var StepBytes: Integer): PIpp8u; stdcall;
function ippiMalloc_8u_C3(widthPixels: Integer; heightPixels: Integer; var StepBytes: Integer): PIpp8u; stdcall;
function ippiMalloc_8u_C4(widthPixels: Integer; heightPixels: Integer; var StepBytes: Integer): PIpp8u; stdcall;
function ippiMalloc_8u_AC4(widthPixels: Integer; heightPixels: Integer; var StepBytes: Integer): PIpp8u; stdcall;

{LINE 235}
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiFree
//  Purpose:    frees memory allocated by the ippiMalloc functions
//  Parameter:
//    ptr       pointer to the memory allocated by the ippiMalloc functions
//
//  Notes:      use this function to free memory allocated by ippiMalloc
*)
procedure ippiFree(ptr:pointer); stdcall;

{LINE 4224}
(* /////////////////////////////////////////////////////////////////////////////
//                     Affine Transform functions
// ////////////////////////////////////////////////////////////////////////// *)

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiGetAffineBound
//  Purpose:            Computes the bounding rectangle of the transformed image ROI
//  Parameters:
//    srcROI            Source image ROI
//    coeffs            The affine transform matrix
//                        |X'|   |a11 a12| |X| |a13|
//                        |  | = |       |*| |+|   |
//                        |Y'|   |a21 a22| |Y| |a23|
//    bound             Resultant bounding rectangle
//  Returns:
//    ippStsNoErr       OK
*)

function ippiGetAffineBound(srcROI: IppiRect; var bound:TRectD; const coeffs:TMatrixD):IppStatus stdcall;

{LINE 4245}
(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiGetAffineQuad
//  Purpose:            Computes coordinates of the quadrangle to which a source ROI is mapped
//  Parameters:
//    srcROI            Source image ROI
//    coeffs            The affine transform matrix
//                        |X'|   |a11 a12| |X| |a13|
//                        |  | = |       |*| |+|   |
//                        |Y'|   |a21 a22| |Y| |a23|
//    quad              Resultant quadrangle
//  Returns:
//    ippStsNoErr       OK
*)
//IPPAPI(IppStatus, ippiGetAffineQuad, (
//    IppiRect srcROI, double quad[4][2], const double coeffs[2][3]))

function ippiGetAffineQuad(srcROI: IppiRect; var quad: TQPointD; const coeffs:TMatrixD):IppStatus;stdcall;

{LINE 4262}
(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiGetAffineTransform
//  Purpose:            Computes coefficients to transform a source ROI to a given quadrangle
//  Parameters:
//      srcROI          Source image ROI.
//      coeffs          The resultant affine transform matrix
//                        |X'|   |a11 a12| |X| |a13|
//                        |  | = |       |*| |+|   |
//                        |Y'|   |a21 a22| |Y| |a23|
//      quad            Vertex coordinates of the quadrangle
//  Returns:
//    ippStsNoErr       OK
//  Notes: The function computes the coordinates of the 4th vertex of the quadrangle
//         that uniquely depends on the three other (specified) vertices.
//         If the computed coordinates are not equal to the ones specified in quad,
//         the function returns the warning message and continues operation with the computed values
*)

function ippiGetAffineTransform(srcROI: IppiRect; const quad:TQPointD; var coeffs: TMatrixD):IppStatus stdcall;

function ippiGetAffineSrcRoi(srcSize: IppiSize; const coeffs:TMatrixD; direction: IppiWarpDirection; dstRoiOffset: IppiPoint; dstRoiSize: IppiSize; var srcRoi:IppiRect):IppStatus stdcall;




{LINE 4284}
(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiGetRotateShift
//  Purpose:            Calculates shifts for ippiRotate function to rotate an image
//                      around the specified center (xCenter, yCenter)
//  Parameters:
//    xCenter, yCenter  Coordinates of the center of rotation
//    angle             The angle of clockwise rotation, degrees
//    xShift, yShift    Pointers to the shift values
//  Returns:
//    ippStsNoErr       OK
//    ippStsNullPtrErr  One of the pointers to the output data is NULL
*)
function ippiGetRotateShift(xCenter: double; yCenter: double; angle: double; var xShift: double; var yShift: double):IppStatus stdcall;

{LINE 4300}
(* /////////////////////////////////////////////////////////////////////////////
//  Name:                  ippiGetRotateTransform
//  Purpose:               Computes the affine coefficients for the transform that
//                         rotates an image around (0, 0) by specified angle + shifts it
//                         | cos(angle)  sin(angle)  xShift|
//                         |                               |
//                         |-sin(angle)  cos(angle)  yShift|
//  Parameters:
//    srcROI               Source image ROI
//    angle                The angle of rotation in degrees
//    xShift, yShift       The shift along the corresponding axis
//    coeffs               Output array with the affine transform coefficients
//  Returns:
//    ippStsNoErr          OK
//    ippStsOutOfRangeErr  Indicates an error if the angle is NaN or Infinity
*)

function ippiGetRotateTransform(angle:double; xShift:double; yShift:double; var coeffs:TMatrixD):IppStatus stdcall;

{LINE 4635}
(* /////////////////////////////////////////////////////////////////////////////
//                     Warp Transform functions
// ////////////////////////////////////////////////////////////////////////// *)

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiWarpGetBufferSize
//  Purpose:            Computes the size of external buffer for Warp transform
//
//  Parameters:
//    pSpec             Pointer to the Spec structure for warp transform
//    dstRoiSize        Size of the output image (in pixels)
//    numChannels       Number of channels, possible values are 1 or 3 or 4
//    pBufSize          Pointer to the size (in bytes) of the external buffer
//
//  Return Values:
//    ippStsNoErr           Indicates no error
//    ippStsNullPtrErr      Indicates an error if one of the specified pointers is NULL
//    ippStsNoOperation     Indicates a warning if width or height of output image is zero
//    ippStsContextMatchErr Indicates an error if pointer to an invalid pSpec structure is passed
//    ippStsNumChannelsErr  Indicates an error if numChannels has illegal value
//    ippStsSizeErr         Indicates an error condition in the following cases:
//                          - if width or height of the source image is negative,
//                          - if the calculated buffer size exceeds maximum 32 bit signed integer
//                            positive value (the processed image ROIs are too large ).
//    ippStsSizeWrn         Indicates a warning if the destination image size is more than
//                          the destination image origin size
*)
function ippiWarpGetBufferSize(const pSpec: PIppiWarpSpec; dstRoiSize:IppiSize; var BufSize:Integer):IppStatus stdcall;

{LINE 4778}
(* /////////////////////////////////////////////////////////////////////////////
//                     Warp Affine Transform functions
// ////////////////////////////////////////////////////////////////////////// *)

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiWarpAffineGetSize
//  Purpose:            Computes the size of Spec structure and temporal buffer for Affine transform
//
//  Parameters:
//    srcSize           Size of the input image (in pixels)
//    dstSize           Size of the output image (in pixels)
//    dataType          Data type of the source and destination images. Possible values
//                      are ipp8u, ipp16u, ipp16s, ipp32f and ipp64f.
//    coeffs            The affine transform coefficients
//    interpolation     Interpolation method. Supported values: ippNearest, ippLinear and ippCubic.
//    direction         Transformation direction. Possible values are:
//                          ippWarpForward  - Forward transformation.
//                          ippWarpBackward - Backward transformation.
//    border            Type of the border
//    pSpecSize         Pointer to the size (in bytes) of the Spec structure
//    pInitBufSize      Pointer to the size (in bytes) of the temporal buffer
//
//  Return Values:
//    ippStsNoErr               Indicates no error
//    ippStsNullPtrErr          Indicates an error if one of the specified pointers is NULL
//    ippStsNoOperation         Indicates a warning if width or height of any image is zero
//    ippStsSizeErr             Indicates an error in the following cases:
//                              -  if width or height of the source or destination image is negative,
//                              -  if one of the calculated sizes exceeds maximum 32 bit signed integer
//                                 positive value (the size of the one of the processed images is too large).
//    ippStsDataTypeErr         Indicates an error when dataType has an illegal value.
//    ippStsWarpDirectionErr    Indicates an error when the direction value is illegal.
//    ippStsInterpolationErr    Indicates an error if interpolation has an illegal value
//    ippStsNotSupportedModeErr Indicates an error if the requested mode is not supported.
//    ippStsCoeffErr            Indicates an error condition, if affine transformation is singular.
//    ippStsBorderErr           Indicates an error if border type has an illegal value
//
*)
function ippiWarpAffineGetSize(
           srcSize:IppiSize; dstSize:IppiSize; dataType:IppDataType; const coeffs:TMatrixD;
           interpolation: IppiInterpolationType; direction: IppiWarpDirection;
           borderType: IppiBorderType; var SpecSize: Integer; var InitBufSize:Integer):IppStatus stdcall;

{LINE 4820}
(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiWarpAffineNearestInit
//                      ippiWarpAffineLinearInit
//                      ippiWarpAffineCubicInit
//
//  Purpose:            Initializes the Spec structure for the Warp affine transform
//                      by different interpolation methods
//
//  Parameters:
//    srcSize           Size of the input image (in pixels)
//    dstSize           Size of the output image (in pixels)
//    dataType          Data type of the source and destination images. Possible values are:
//                      ipp8u, ipp16u, ipp16s, ipp32f, ipp64f.
//    coeffs            The affine transform coefficients
//    direction         Transformation direction. Possible values are:
//                          ippWarpForward  - Forward transformation.
//                          ippWarpBackward - Backward transformation.
//    numChannels       Number of channels, possible values are 1 or 3 or 4
//    valueB            The first parameter (B) for specifying Cubic filters
//    valueC            The second parameter (C) for specifying Cubic filters
//    border            Type of the border
//    borderValue       Pointer to the constant value(s) if border type equals ippBorderConstant
//    smoothEdge        The smooth edge flag. Supported values:
//                          0 - transform without edge smoothing
//                          1 - transform with edge smoothing
//    pSpec             Pointer to the Spec structure for resize filter
//    pInitBuf          Pointer to the temporal buffer for several initialization cases
//
//  Return Values:
//    ippStsNoErr               Indicates no error
//    ippStsNullPtrErr          Indicates an error if one of the specified pointers is NULL
//    ippStsNoOperation         Indicates a warning if width or height of any image is zero
//    ippStsSizeErr             Indicates an error if width or height of the source or destination
//                              image is negative
//    ippStsDataTypeErr         Indicates an error when dataType has an illegal value.
//    ippStsWarpDirectionErr    Indicates an error when the direction value is illegal.
//    ippStsCoeffErr            Indicates an error condition, if the affine transformation is singular.
//    ippStsNumChannelsErr      Indicates an error if numChannels has illegal value
//    ippStsBorderErr           Indicates an error if border type has an illegal value
//    ippStsWrongIntersectQuad  Indicates a warning that no operation is performed, if the transformed
//                              source image has no intersection with the destination image.
//    ippStsNotSupportedModeErr Indicates an error if the requested mode is not supported.
//
//  Notes/References:
//    1. The equation shows the family of cubic filters:
//           ((12-9B-6C)*|x|^3 + (-18+12B+6C)*|x|^2                  + (6-2B)  ) / 6   for |x| < 1
//    K(x) = ((   -B-6C)*|x|^3 + (    6B+30C)*|x|^2 + (-12B-48C)*|x| + (8B+24C); / 6   for 1 <= |x| < 2
//           0   elsewhere
//    Some values of (B,C) correspond to known cubic splines: Catmull-Rom (B=0,C=0.5), B-Spline (B=1,C=0) and other.
//      Mitchell, Don P.; Netravali, Arun N. (Aug. 1988). "Reconstruction filters in computer graphics"
//      http://www.mentallandscape.com/Papers_siggraph88.pdf
//
//    2. Supported border types are ippBorderRepl, ippBorderConst, ippBorderTransp and ippBorderInMem
*)

function ippiWarpAffineNearestInit(srcSize:IppiSize; dstSize: IppiSize;dataType: IppDataType;
           const coeffs: TMatrixD;direction: IppiWarpDirection; numChannels: integer;
           borderType: IppiBorderType;
           const pBorderValue: PIpp64f; smoothEdge: integer; pSpec: PIppiWarpSpec):IppStatus stdcall;

function ippiWarpAffineLinearInit(srcSize:IppiSize; dstSize:IppiSize; dataType:IppDataType;
           const coeffs: TMatrixD;
           direction:IppiWarpDirection; numChannels: Integer; borderType: IppiBorderType;
           const pBorderValue: PIpp64f; smoothEdge: Integer; pSpec: PIppiWarpSpec):IppStatus stdcall;

function ippiWarpAffineCubicInit(srcSize: IppiSize; dstSize: IppiSize; dataType: IppDataType;
           const coeffs: TMatrixD; direction: IppiWarpDirection; numChannels: integer;
           valueB: Ipp64f; valueC: Ipp64f;
           borderType: IppiBorderType;
           const pBorderValue: PIpp64f; smoothEdge: integer; pSpec: PIppiWarpSpec;
           pInitBuf: PIpp8u):IppStatus stdcall;

{LINE 4885}
(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiWarpAffineNearest
//                      ippiWarpAffineLinear
//                      ippiWarpAffineCubic
//
//  Purpose:            Performs affine transform of an image with using different interpolation methods
//
//  Parameters:
//    pSrc              Pointer to the source image
//    srcStep           Distance (in bytes) between of consecutive lines in the source image
//    pDst              Pointer to the destination image
//    dstStep           Distance (in bytes) between of consecutive lines in the destination image
//    dstRoiOffset      Offset of tiled image respectively destination image origin
//    dstRoiSize        Size of the destination image (in pixels)
//    border            Type of the border
//    borderValue       Pointer to the constant value(s) if border type equals ippBorderConstant
//    pSpec             Pointer to the Spec structure for resize filter
//    pBuffer           Pointer to the work buffer
//
//  Return Values:
//    ippStsNoErr               Indicates no error
//    ippStsNullPtrErr          Indicates an error if one of the specified pointers is NULL
//    ippStsNoOperation         Indicates a warning if width or height of output image is zero
//    ippStsBorderErr           Indicates an error if border type has an illegal value
//    ippStsContextMatchErr     Indicates an error if pointer to an invalid pSpec structure is passed
//    ippStsNotSupportedModeErr Indicates an error if requested mode is currently not supported
//    ippStsSizeErr             Indicates an error if width or height of the destination image
//                              is negative
//    ippStsStepErr             Indicates an error if the step value is not data type multiple
//    ippStsOutOfRangeErr       Indicates an error if the destination image offset point is outside the
//                              destination image origin
//    ippStsSizeWrn             Indicates a warning if the destination image size is more than
//                              the destination image origin size
//    ippStsWrongIntersectQuad  Indicates a warning that no operation is performed if the destination
//                              ROI has no intersection with the transformed source image origin.
//
//  Notes:
//    1. Supported border types are ippBorderRepl, ippBorderConst, ippBorderTransp and ippBorderRepl
*)

function ippiWarpAffineLinear_8u_C1R(const pSrc:PIpp8u; srcStep: Integer; pDst: PIpp8u; dstStep: Integer;
                                     dstRoiOffset: IppiPoint; dstRoiSize: IppiSize; const pSpec:PIppiWarpSpec;
                                     pBuffer: PIpp8u):IppStatus stdcall;
function ippiWarpAffineLinear_8u_C3R(const pSrc:PIpp8u; srcStep: Integer; pDst: PIpp8u; dstStep: Integer;
                                     dstRoiOffset: IppiPoint; dstRoiSize: IppiSize; const pSpec:PIppiWarpSpec;
                                     pBuffer: PIpp8u):IppStatus stdcall;

function ippiWarpAffineLinear_8u_C4R(const pSrc:PIpp8u; srcStep: Integer; pDst: PIpp8u; dstStep: Integer;
                                     dstRoiOffset: IppiPoint; dstRoiSize: IppiSize; const pSpec:PIppiWarpSpec;
                                     pBuffer: PIpp8u):IppStatus stdcall;

{LINE 5404}
(* /////////////////////////////////////////////////////////////////////////////
//                   Geometric Transform functions
///////////////////////////////////////////////////////////////////////////// *)

//{$if !defined( _OWN_BLDPCS )}
type
  IppiAxis= (
    ippAxsHorizontal,
    ippAxsVertical,
    ippAxsBoth
  ) ;

//{$endif} (*_OWN_BLDPCS*)

{LINE 5419}
(* /////////////////////////////////////////////////////////////////////////////
//
//  Name:        ippiMirror
//
//  Purpose:     Mirrors an image about a horizontal
//               or vertical axis, or both
//
//  Context:
//
//  Returns:     IppStatus
//    ippStsNoErr         No errors
//    ippStsNullPtrErr    pSrc == NULL, or pDst == NULL
//    ippStsSizeErr,      roiSize has a field with zero or negative value
//    ippStsMirrorFlipErr (flip != ippAxsHorizontal) &&
//                        (flip != ippAxsVertical) &&
//                        (flip != ippAxsBoth)
//
//  Parameters:
//    pSrc       Pointer to the source image
//    srcStep    Step through the source image
//    pDst       Pointer to the destination image
//    dstStep    Step through the destination image
//    pSrcDst    Pointer to the source/destination image (in-place flavors)
//    srcDstStep Step through the source/destination image (in-place flavors)
//    roiSize    Size of the ROI
//    flip       Specifies the axis to mirror the image about:
//                 ippAxsHorizontal     horizontal axis,
//                 ippAxsVertical       vertical axis,
//                 ippAxsBoth           both horizontal and vertical axes
//
//  Notes:
//
*)

function ippiMirror_8u_C1R(const pSrc: PIpp8u; srcStep: Integer; pDst: PIpp8u; dstStep: Integer;
                           roiSize:IppiSize; flip:IppiAxis):IppStatus stdcall;
function ippiMirror_8u_C3R(const pSrc: PIpp8u; srcStep: Integer; pDst: PIpp8u; dstStep: Integer;
                           roiSize:IppiSize; flip:IppiAxis):IppStatus stdcall;
function ippiMirror_8u_AC4R(const pSrc: PIpp8u; srcStep: Integer; pDst: PIpp8u; dstStep: Integer;
                           roiSize:IppiSize; flip:IppiAxis):IppStatus stdcall;
function ippiMirror_8u_C4R(const pSrc: PIpp8u; srcStep: Integer; pDst: PIpp8u; dstStep: Integer;
                           roiSize:IppiSize; flip:IppiAxis):IppStatus stdcall;

{LINE 9379}
(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiCopyReplicateBorder
//
//  Purpose:   Copies pixel values between two buffers and adds
//             the replicated border pixels.
//
//  Returns:
//    ippStsNullPtrErr    One of the pointers is NULL
//    ippStsSizeErr       1). srcRoiSize or dstRoiSize has a field with negative or zero value
//                        2). topBorderHeight or leftBorderWidth is less than zero
//                        3). dstRoiSize.width < srcRoiSize.width + leftBorderWidth
//                        4). dstRoiSize.height < srcRoiSize.height + topBorderHeight
//    ippStsStepErr       srcStep or dstStep is less than or equal to zero
//    ippStsNoErr         OK
//
//  Parameters:
//    pSrc                Pointer  to the source image buffer
//    srcStep             Step in bytes through the source image
//    pDst                Pointer to the  destination image buffer
//    dstStep             Step in bytes through the destination image
//    scrRoiSize          Size of the source ROI in pixels
//    dstRoiSize          Size of the destination ROI in pixels
//    topBorderHeight     Height of the top border in pixels
//    leftBorderWidth     Width of the left border in pixels
*)

function ippiCopyReplicateBorder_8u_C1R
            ( const pSrc: PIpp8u; srcStep: Integer; srcRoiSize:IppiSize;
                    pDst: PIpp8u; dstStep:Integer; dstRoiSize:IppiSize;
                    topBorderHeight: Integer; leftBorderWidth: Integer):IppStatus stdcall;
function ippiCopyReplicateBorder_8u_C3R
            ( const pSrc: PIpp8u; srcStep: Integer; srcRoiSize:IppiSize;
                    pDst: PIpp8u; dstStep:Integer; dstRoiSize:IppiSize;
                    topBorderHeight: Integer; leftBorderWidth: Integer):IppStatus stdcall;
function ippiCopyReplicateBorder_8u_AC4R
            ( const pSrc: PIpp8u; srcStep: Integer; srcRoiSize:IppiSize;
                    pDst: PIpp8u; dstStep:Integer; dstRoiSize:IppiSize;
                    topBorderHeight: Integer; leftBorderWidth: Integer):IppStatus stdcall;
function ippiCopyReplicateBorder_8u_C4R
            ( const pSrc: PIpp8u; srcStep: Integer; srcRoiSize:IppiSize;
                    pDst: PIpp8u; dstStep:Integer; dstRoiSize:IppiSize;
                    topBorderHeight: Integer; leftBorderWidth: Integer):IppStatus stdcall;

function ippiCopyReplicateBorder_8u_C1IR
                    ( const pSrc:PIpp8u; srcDstStep:Integer;
                            srcRoiSize:IppiSize; dstRoiSize:IppiSize;
                            topBorderHeight: Integer; leftborderwidth:Integer):IppStatus stdcall;
function ippiCopyReplicateBorder_8u_C3IR
                    ( const pSrc:PIpp8u; srcDstStep:Integer;
                            srcRoiSize:IppiSize; dstRoiSize:IppiSize;
                            topBorderHeight: Integer; leftborderwidth:Integer):IppStatus stdcall;
function ippiCopyReplicateBorder_8u_AC4IR
                    ( const pSrc:PIpp8u; srcDstStep:Integer;
                            srcRoiSize:IppiSize; dstRoiSize:IppiSize;
                            topBorderHeight: Integer; leftborderwidth:Integer):IppStatus stdcall;
function ippiCopyReplicateBorder_8u_C4IR
                    ( const pSrc:PIpp8u; srcDstStep:Integer;
                            srcRoiSize:IppiSize; dstRoiSize:IppiSize;
                            topBorderHeight: Integer; leftborderwidth:Integer):IppStatus stdcall;



{LINE 17475}
(* /////////////////////////////////////////////////////////////////////////////
//                      Resize Transform Functions
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiResizeGetSize
//  Purpose:            Computes the size of Spec structure and temporal buffer for Resize transform
//
//  Parameters:
//    srcSize           Size of the input image (in pixels)
//    dstSize           Size of the output image (in pixels)
//    interpolation     Interpolation method
//    antialiasing      Antialiasing method
//    pSpecSize         Pointer to the size (in bytes) of the Spec structure
//    pInitBufSize      Pointer to the size (in bytes) of the temporal buffer
//
//  Return Values:
//    ippStsNoErr               Indicates no error
//    ippStsNullPtrErr          Indicates an error if one of the specified pointers is NULL
//    ippStsNoOperation         Indicates a warning if width or height of any image is zero
//    ippStsSizeErr             Indicates an error in the following cases:
//                              -  if the source image size is less than a filter size of the chosen
//                                 interpolation method (except ippSuper),
//                              -  if one of the specified dimensions of the source image is less than
//                                 the corresponding dimension of the destination image (for ippSuper method only),
//                              -  if width or height of the source or destination image is negative,
//                              -  if one of the calculated sizes exceeds maximum 32 bit signed integer
//                                 positive value (the size of the one of the processed images is too large).
//                              -  if width or height of the source or destination image is negative.
//    ippStsInterpolationErr    Indicates an error if interpolation has an illegal value
//    ippStsNoAntialiasing      Indicates a warning if specified interpolation does not support antialiasing
//    ippStsNotSupportedModeErr Indicates an error if requested mode is currently not supported
//
//  Notes:
//    1. Supported interpolation methods are ippNearest, ippLinear, ippCubic, ippLanczos and ippSuper.
//    2. Antialiasing feature does not supported now. The antialiasing value should be equal zero.
//    3. The implemented interpolation algorithms have the following filter sizes: Nearest Neighbor 1x1,
//       Linear 2x2, Cubic 4x4, 2-lobed Lanczos 4x4.
*)
function ippiResizeGetSize_8u(
    srcSize: IppiSize; dstSize: IppiSize;
    interpolation: IppiInterpolationType; antialiasing: Ipp32u;
    var SpecSize: Ipp32s; var InitBufSize: Ipp32s): IppStatus stdcall;

{LINE 17531}
(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiResizeGetBufferSize
//  Purpose:            Computes the size of external buffer for Resize transform
//
//  Parameters:
//    pSpec             Pointer to the Spec structure for resize filter
//    dstSize           Size of the output image (in pixels)
//    numChannels       Number of channels, possible values are 1 or 3 or 4
//    pBufSize          Pointer to the size (in bytes) of the external buffer
//
//  Return Values:
//    ippStsNoErr           Indicates no error
//    ippStsNullPtrErr      Indicates an error if one of the specified pointers is NULL
//    ippStsNoOperation     Indicates a warning if width or height of output image is zero
//    ippStsContextMatchErr Indicates an error if pointer to an invalid pSpec structure is passed
//    ippStsNumChannelErr   Indicates an error if numChannels has illegal value
//    ippStsSizeErr         Indicates an error condition in the following cases:
//                          - if width or height of the source image is negative,
//                          - if the calculated buffer size exceeds maximum 32 bit signed integer
//                            positive value (the processed image ROIs are too large ).
//    ippStsSizeWrn         Indicates a warning if the destination image size is more than
//                          the destination image origin size
*)
function ippiResizeGetBufferSize_8u(
    pSpec: PIppiResizeSpec_32f;
    dstSize: IppiSize; numChannels: Ipp32u;
    var BufSize: Ipp32s): IppStatus stdcall;

{LINE 17572}
(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiResizeGetBorderSize
//  Purpose:            Computes the size of possible borders for Resize transform
//
//  Parameters:
//    pSpec             Pointer to the Spec structure for resize filter
//    borderSize        Size of necessary borders (for memory allocation)
//
//  Return Values:
//    ippStsNoErr           Indicates no error
//    ippStsNullPtrErr      Indicates an error if one of the specified pointers is NULL
//    ippStsContextMatchErr Indicates an error if pointer to an invalid pSpec structure is passed
*)
function ippiResizeGetBorderSize_8u(
    pSpec: PIppiResizeSpec_32f;
    var borderSize: IppiBorderSize):IppStatus stdcall;

{LINE 17597}
(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiResizeGetSrcOffset
//  Purpose:            Computes the offset of input image for Resize transform by tile processing
//
//  Parameters:
//    pSpec             Pointer to the Spec structure for resize filter
//    dstOffset         Offset of the tiled destination image respective
//                      to the destination image origin
//    srcOffset         Pointer to the offset of input image
//
//  Return Values:
//    ippStsNoErr           Indicates no error
//    ippStsNullPtrErr      Indicates an error if one of the specified pointers is NULL
//    ippStsContextMatchErr Indicates an error if pointer to an invalid pSpec structure is passed
//    ippStsOutOfRangeErr   Indicates an error if the destination image offset point is outside the
//                          destination image origin
*)
function ippiResizeGetSrcOffset_8u(
    pSpec: PIppiResizeSpec_32f;
    dstOffset: IppiPoint; srcOffset: PIppiPoint): IppStatus stdcall;

{LINE 17627}
(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiResizeGetSrcRoi
//  Purpose:            Computes the ROI of input image
//                      for Resize transform by tile processing
//
//  Parameters:
//    pSpec             Pointer to the Spec structure for resize filter
//    dstRoiOffset      Offset of the destination image ROI
//    dstRoiSize        Size of the ROI of destination image
//    srcRoiOffset      Pointer to the offset of source image ROI
//    srcRoiSize        Pointer to the ROI size of source image
//
//  Return Values:
//    ippStsNoErr           Indicates no error
//    ippStsNullPtrErr      Indicates an error if one of the specified pointers is NULL
//    ippStsContextMatchErr Indicates an error if pointer to an invalid pSpec structure is passed
//    ippStsOutOfRangeErr   Indicates an error if the destination image offset point is outside
//                          the destination image origin
//    IppStsSizeWrn         Indicates a warning if the destination ROI exceeds with
//                          the destination image origin
*)

function ippiResizeGetSrcRoi_8u(pSpec: PIppiResizeSpec_32f;
    dstRoiOffset: IppiPoint; dstRoiSize: IppiSize;
    var srcRoiOffset: IppiPoint; var srcRoiSize: IppiSize):IppStatus stdcall;


{LINE 17665}
(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiResizeNearestInit
//                      ippiResizeLinearInit
//                      ippiResizeCubicInit
//                      ippiResizeLanczosInit
//                      ippiResizeSuperInit
//
//  Purpose:            Initializes the Spec structure for the Resize transform
//                      by different interpolation methods
//
//  Parameters:
//    srcSize           Size of the input image (in pixels)
//    dstSize           Size of the output image (in pixels)
//    valueB            The first parameter (B) for specifying Cubic filters
//    valueC            The second parameter (C) for specifying Cubic filters
//    numLobes          The parameter for specifying Lanczos (2 or 3) or Hahn (3 or 4) filters
//    pInitBuf          Pointer to the temporal buffer for several filter initialization
//    pSpec             Pointer to the Spec structure for resize filter
//
//  Return Values:
//    ippStsNoErr               Indicates no error
//    ippStsNullPtrErr          Indicates an error if one of the specified pointers is NULL
//    ippStsNoOperation         Indicates a warning if width or height of any image is zero
//    ippStsSizeErr             Indicates an error in the following cases:
//                              -  if width or height of the source or destination image is negative,
//                              -  if the source image size is less than a filter size of the chosen
//                                 interpolation method (except ippiResizeSuperInit).
//                              -  if one of the specified dimensions of the source image is less than
//                                 the corresponding dimension of the destination image
//                                 (for ippiResizeSuperInit only).
//    ippStsNotSupportedModeErr Indicates an error if the requested mode is not supported.
//
//  Notes/References:
//    1. The equation shows the family of cubic filters:
//           ((12-9B-6C)*|x|^3 + (-18+12B+6C)*|x|^2                  + (6-2B)  ) / 6   for |x| < 1
//    K(x) = ((   -B-6C)*|x|^3 + (    6B+30C)*|x|^2 + (-12B-48C)*|x| + (8B+24C)) / 6   for 1 <= |x| < 2
//           0   elsewhere
//    Some values of (B,C) correspond to known cubic splines: Catmull-Rom (B=0,C=0.5), B-Spline (B=1,C=0) and other.
//      Mitchell, Don P.; Netravali, Arun N. (Aug. 1988). "Reconstruction filters in computer graphics"
//      http://www.mentallandscape.com/Papers_siggraph88.pdf
//
//    2. Hahn filter does not supported now.
//    3. The implemented interpolation algorithms have the following filter sizes: Nearest Neighbor 1x1,
//       Linear 2x2, Cubic 4x4, 2-lobed Lanczos 4x4, 3-lobed Lanczos 6x6.
*)
function ippiResizeNearestInit_8u(
    srcSize: IppiSize; dstSize: IppiSize;
    pSpec: PIppiResizeSpec_32f): IppStatus stdcall;

function ippiResizeLinearInit_8u(
    srcSize: IppiSize; dstSize: IppiSize;
    pSpec: PIppiResizeSpec_32f): IppStatus stdcall;

function ippiResizeCubicInit_8u(
    srcSize: IppiSize; dstSize: IppiSize; valueB: Ipp32f; valueC: Ipp32f;
    pSpec: PIppiResizeSpec_32f; pInitBuf: PIpp8u): IppStatus stdcall;

function ippiResizeLanczosInit_8u(
    srcSize: IppiSize; dstSize: IppiSize; numLobes: Ipp32u;
    pSpec: PIppiResizeSpec_32f; pInitBuf: PIpp8u):IppStatus stdcall;

function ippiResizeSuperInit_8u(
    srcSize: IppiSize; dstSize: IppiSize;
    pSpec: PIppiResizeSpec_32f): IppStatus stdcall;

{LINE 17759}
(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiResizeNearest
//                      ippiResizeLinear
//                      ippiResizeCubic
//                      ippiResizeLanczos
//                      ippiResizeSuper
//
//  Purpose:            Changes an image size by different interpolation methods
//
//  Parameters:
//    pSrc              Pointer to the source image
//    srcStep           Distance (in bytes) between of consecutive lines in the source image
//    pDst              Pointer to the destination image
//    dstStep           Distance (in bytes) between of consecutive lines in the destination image
//    dstOffset         Offset of tiled image respectively destination image origin
//    dstSize           Size of the destination image (in pixels)
//    border            Type of the border
//    borderValue       Pointer to the constant value(s) if border type equals ippBorderConstant
//    pSpec             Pointer to the Spec structure for resize filter
//    pBuffer           Pointer to the work buffer
//
//  Return Values:
//    ippStsNoErr               Indicates no error
//    ippStsNullPtrErr          Indicates an error if one of the specified pointers is NULL
//    ippStsNoOperation         Indicates a warning if width or height of output image is zero
//    ippStsBorderErr           Indicates an error if border type has an illegal value
//    ippStsContextMatchErr     Indicates an error if pointer to an invalid pSpec structure is passed
//    ippStsNotSupportedModeErr Indicates an error if requested mode is currently not supported
//    ippStsSizeErr             Indicates an error if width or height of the destination image
//                              is negative
//    ippStsStepErr             Indicates an error if the step value is not data type multiple
//    ippStsOutOfRangeErr       Indicates an error if the destination image offset point is outside the
//                              destination image origin
//    ippStsSizeWrn             Indicates a warning if the destination image size is more than
//                              the destination image origin size
//
//  Notes:
//    1. Supported border types are ippBorderInMemory and ippBorderReplicate
//       (except Nearest Neighbor and Super Sampling methods).
//    2. Hahn filter does not supported now.
*)
function ippiResizeNearest_8u_C1R(
    const pSrc: PIpp8u; srcStep: Ipp32s;
    pDst: PIpp8u; dstStep: Ipp32s; dstOffset: IppiPoint; dstSize: IppiSize;
    const pSpec: PIppiResizeSpec_32f; pBuffer: PIpp8u):IppStatus stdcall;
function ippiResizeNearest_8u_C3R(
    const pSrc: PIpp8u; srcStep: Ipp32s;
    pDst: PIpp8u; dstStep: Ipp32s; dstOffset: IppiPoint; dstSize: IppiSize;
    const pSpec: PIppiResizeSpec_32f; pBuffer: PIpp8u):IppStatus stdcall;
function ippiResizeNearest_8u_C4R(
    const pSrc: PIpp8u; srcStep: Ipp32s;
    pDst: PIpp8u; dstStep: Ipp32s; dstOffset: IppiPoint; dstSize: IppiSize;
    const pSpec: PIppiResizeSpec_32f; pBuffer: PIpp8u):IppStatus stdcall;

function ippiResizeLinear_8u_C1R(
    const pSrc:PIpp8u; srcStep:Ipp32s;
    pDst: PIpp8u; dstStep: Ipp32s; dstOffset: IppiPoint; dstSize: IppiSize;
    border: IppiBorderType; const pBorderValue: PIpp8u;
    const pSpec: PIppiResizeSpec_32f; pBuffer: PIpp8u):IppStatus stdcall;
function ippiResizeLinear_8u_C3R(
    const pSrc:PIpp8u; srcStep:Ipp32s;
    pDst: PIpp8u; dstStep: Ipp32s; dstOffset: IppiPoint; dstSize: IppiSize;
    border: IppiBorderType; const pBorderValue: PIpp8u;
    const pSpec: PIppiResizeSpec_32f; pBuffer: PIpp8u):IppStatus stdcall;
function ippiResizeLinear_8u_C4R(
    const pSrc:PIpp8u; srcStep:Ipp32s;
    pDst: PIpp8u; dstStep: Ipp32s; dstOffset: IppiPoint; dstSize: IppiSize;
    border: IppiBorderType; const pBorderValue: PIpp8u;
    const pSpec: PIppiResizeSpec_32f; pBuffer: PIpp8u):IppStatus stdcall;

function ippiResizeCubic_8u_C1R(
    const pSrc:PIpp8u; srcStep:Ipp32s;
    pDst: PIpp8u; dstStep: Ipp32s; dstOffset: IppiPoint; dstSize: IppiSize;
    border: IppiBorderType; const pBorderValue: PIpp8u;
    const pSpec: PIppiResizeSpec_32f; pBuffer: PIpp8u):IppStatus stdcall;
function ippiResizeCubic_8u_C3R(
    const pSrc:PIpp8u; srcStep:Ipp32s;
    pDst: PIpp8u; dstStep: Ipp32s; dstOffset: IppiPoint; dstSize: IppiSize;
    border: IppiBorderType; const pBorderValue: PIpp8u;
    const pSpec: PIppiResizeSpec_32f; pBuffer: PIpp8u):IppStatus stdcall;
function ippiResizeCubic_8u_C4R(
    const pSrc:PIpp8u; srcStep:Ipp32s;
    pDst: PIpp8u; dstStep: Ipp32s; dstOffset: IppiPoint; dstSize: IppiSize;
    border: IppiBorderType; const pBorderValue: PIpp8u;
    const pSpec: PIppiResizeSpec_32f; pBuffer: PIpp8u):IppStatus stdcall;

function ippiResizeLanczos_8u_C1R(
    const pSrc:PIpp8u; srcStep: Ipp32s;
    pDst:PIpp8u; dstStep: Ipp32s; dstOffset: IppiPoint; dstSize: IppiSize;
    border: IppiBorderType; borderValue: PIpp8u;
    pSpec: PIppiResizeSpec_32f; pBuffer: PIpp8u):IppStatus stdcall;
function ippiResizeLanczos_8u_C3R(
    const pSrc: PIpp8u; srcStep: Ipp32s;
    pDst: PIpp8u; dstStep: Ipp32s; dstOffset: IppiPoint; dstSize: IppiSize;
    border: IppiBorderType; borderValue: PIpp8u;
    pSpec: PIppiResizeSpec_32f; pBuffer: PIpp8u):IppStatus stdcall;
function ippiResizeLanczos_8u_C4R(
    const pSrc: PIpp8u; srcStep: Ipp32s;
    pDst: PIpp8u; dstStep: Ipp32s; dstOffset: IppiPoint; dstSize: IppiSize;
    border: IppiBorderType; borderValue: PIpp8u;
    pSpec: PIppiResizeSpec_32f; pBuffer: PIpp8u):IppStatus stdcall;

function ippiResizeSuper_8u_C1R(
    const pSrc: pIpp8u; srcStep: Ipp32s;
    pDst: pIpp8u; dstStep: Ipp32s; dstOffset: IppiPoint; dstSize: IppiSize;
    pSpec: pIppiResizeSpec_32f; pBuffer: pIpp8u):IppStatus stdcall;
function ippiResizeSuper_8u_C3R(
    const pSrc: pIpp8u; srcStep: Ipp32s;
    pDst: pIpp8u; dstStep: Ipp32s; dstOffset: IppiPoint; dstSize: IppiSize;
    pSpec: pIppiResizeSpec_32f; pBuffer: pIpp8u):IppStatus stdcall;
function ippiResizeSuper_8u_C4R(
    const pSrc: pIpp8u; srcStep: Ipp32s;
    pDst: pIpp8u; dstStep: Ipp32s; dstOffset: IppiPoint; dstSize: IppiSize;
    pSpec: pIppiResizeSpec_32f; pBuffer: pIpp8u):IppStatus stdcall;

implementation

uses
  ipplibs;
//const
//  legacy90='legacy90';

{ TMatrixD }

function TMatrixD.Inverse: TMatrixD;
var
  Determinant: double;
begin
  Determinant:=m11*m22-m12*m21;

  Result.m11:=+m22/Determinant;
  Result.m12:=-m12/Determinant;
  Result.m21:=-m21/Determinant;
  Result.m22:=+m11/Determinant;

  //El desplazamiento es el resultado de aplicar la rotacion a m13 y m23 al reves
  Result.m13:= - (m13 * +m22 + m23 * -m12) / Determinant;
  Result.m23:= - (m13 * -m21 + m23 * +m11) / Determinant;
end;

{ IppiBorderSize }
constructor IppiBorderSize.Create(ALeft,ATop,ARight,ABottom:Ipp32u);
begin
  borderLeft:=ALeft ;
  borderTop:=ATop;
  borderRight:=ARight;
  borderBottom:=ABottom;
end;

function ippiGetLibVersion;external ippilib {$ifdef MSWindows}{$ifdef MSWindows}delayed{$endif}{$endif};

function ippiMalloc_8u_C1;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiMalloc_8u_C3;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiMalloc_8u_C4;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiMalloc_8u_AC4;external ippilib {$ifdef MSWindows}delayed{$endif};

procedure ippiFree(ptr:pointer); external ippilib {$ifdef MSWindows}delayed{$endif};

function ippiGetAffineBound; external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiGetAffineQuad; external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiGetAffineTransform; external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiGetAffineSrcRoi; external ippilib {$ifdef MSWindows}delayed{$endif};


function ippiGetRotateShift; external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiGetRotateTransform;external ippilib {$ifdef MSWindows}delayed{$endif};

function ippiWarpAffineGetSize;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiWarpAffineNearestInit;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiWarpAffineLinearInit;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiWarpAffineCubicInit;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiWarpGetBufferSize;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiWarpAffineLinear_8u_C1R;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiWarpAffineLinear_8u_C3R;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiWarpAffineLinear_8u_C4R;external ippilib {$ifdef MSWindows}delayed{$endif};

function ippiMirror_8u_C1R;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiMirror_8u_C3R;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiMirror_8u_AC4R;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiMirror_8u_C4R;external ippilib {$ifdef MSWindows}delayed{$endif};

function ippiCopyReplicateBorder_8u_C1R;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiCopyReplicateBorder_8u_C3R;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiCopyReplicateBorder_8u_AC4R;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiCopyReplicateBorder_8u_C4R;external ippilib {$ifdef MSWindows}delayed{$endif};

function ippiCopyReplicateBorder_8u_C1IR;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiCopyReplicateBorder_8u_C3IR;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiCopyReplicateBorder_8u_AC4IR;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiCopyReplicateBorder_8u_C4IR;external ippilib {$ifdef MSWindows}delayed{$endif};

function ippiResizeGetSize_8u;external ippilib {$ifdef MSWindows}delayed{$endif};

function ippiResizeGetBorderSize_8u;external ippilib {$ifdef MSWindows}delayed{$endif};

function ippiResizeGetSrcOffset_8u;external ippilib {$ifdef MSWindows}delayed{$endif};

function ippiResizeGetBufferSize_8u;external ippilib {$ifdef MSWindows}delayed{$endif};

function ippiResizeGetSrcRoi_8u;external ippilib {$ifdef MSWindows}delayed{$endif};

function ippiResizeNearestInit_8u;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiResizeLinearInit_8u;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiResizeCubicInit_8u;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiResizeLanczosInit_8u;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiResizeSuperInit_8u;external ippilib {$ifdef MSWindows}delayed{$endif};

function ippiResizeNearest_8u_C1R;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiResizeNearest_8u_C3R;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiResizeNearest_8u_C4R;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiResizeLinear_8u_C1R;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiResizeLinear_8u_C3R;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiResizeLinear_8u_C4R;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiResizeCubic_8u_C1R;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiResizeCubic_8u_C3R;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiResizeCubic_8u_C4R;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiResizeLanczos_8u_C1R;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiResizeLanczos_8u_C3R;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiResizeLanczos_8u_C4R;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiResizeSuper_8u_C1R;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiResizeSuper_8u_C3R;external ippilib {$ifdef MSWindows}delayed{$endif};
function ippiResizeSuper_8u_C4R;external ippilib {$ifdef MSWindows}delayed{$endif};

end.

