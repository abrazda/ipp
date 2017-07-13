unit ippi90legacy;

interface

uses
  ippdefs;

{$I ipp.inc}

{LINE 2371}
(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiRotate
//  Purpose:            Rotates an image around (0, 0) by specified angle + shifts it
//  Parameters:
//    pSrc              Pointer to the source image data (point to pixel (0,0))
//    srcSize           Size of the source image
//    srcStep           Step through the source image
//    srcROI            Region of interest in the source image
//    pDst              Pointer to  the destination image (point to pixel (0,0))
//    dstStep           Step through the destination image
//    dstROI            Region of interest in the destination image
//    angle             The angle of clockwise rotation in degrees
//    xShif, yShift     The shift along the corresponding axis
//    interpolation     The type of interpolation to perform for rotating the input image:
//                        IPPI_INTER_NN       Nearest neighbor interpolation
//                        IPPI_INTER_LINEAR   Linear interpolation
//                        IPPI_INTER_CUBIC    Cubic convolution interpolation
//                        IPPI_INTER_CUBIC2P_CATMULLROM  Catmull-Rom cubic filter
//                      The special feature in addition to one of general methods:
//                        IPPI_SMOOTH_EDGE    Edges smoothing
//  Returns:
//    ippStsNoErr       OK
//    ippStsNullPtrErr  pSrc or pDst is NULL
//    ippStsSizeErr     One of the image dimensions has zero or negative value
//    ippStsStepErr     srcStep or dstStep has a zero or negative value
//    ippStsInterpolateErr  interpolation has an illegal value
*)

function ippiRotate_8u_C1R(
    const pSrc: PIpp8u; srcSize: IppiSize; srcStep: Integer; srcROI: IppiRect; pDst: PIpp8u; dstStep: Integer; dstROI: IppiRect;
    angle: double; xShift: double; yShift: double; interpolation: Integer):IppStatus; stdcall
function ippiRotate_8u_C3R(
    const pSrc: PIpp8u; srcSize: IppiSize; srcStep: Integer; srcROI: IppiRect; pDst: PIpp8u; dstStep: Integer; dstROI: IppiRect;
    angle: double; xShift: double; yShift: double; interpolation: Integer):IppStatus stdcall;
function ippiRotate_8u_C4R(
    const pSrc: PIpp8u; srcSize: IppiSize; srcStep: Integer; srcROI: IppiRect; pDst: PIpp8u; dstStep: Integer; dstROI: IppiRect;
    angle: double; xShift: double; yShift: double; interpolation: Integer):IppStatus stdcall;
function ippiRotate_8u_AC4R(
    const pSrc: PIpp8u; srcSize: IppiSize; srcStep: Integer; srcROI: IppiRect; pDst: PIpp8u; dstStep: Integer; dstROI: IppiRect;
    angle: double; xShift: double; yShift: double; interpolation: Integer):IppStatus stdcall;

{LINE 2574}
(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiAddRotateShift
//  Purpose:            Calculates shifts for ippiRotate function to rotate an image
//                      around the specified center (xCenter, yCenter) with arbitrary shifts
//  Parameters:
//    xCenter, yCenter  Coordinates of the center of rotation
//    angle             The angle of clockwise rotation, degrees
//    xShift, yShift    Pointers to the shift values
//  Returns:
//    ippStsNoErr       OK
//    ippStsNullPtrErr  One of pointers to the output data is NULL
*)

function ippiAddRotateShift(xCenter:double; yCenter:double; angle:double; var xShift: double; var yShift: double):IppStatus stdcall;

{LINE 2590}
(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiGetRotateQuad
//  Purpose:            Computes the quadrangle to which the source ROI would be mapped
//  Parameters:
//    srcROI            Source image ROI
//    angle             The angle of rotation in degrees
//    xShift, yShift    The shift along the corresponding axis
//    quad              Output array with vertex coordinates of the quadrangle
//  Returns:
//    ippStsNoErr       OK
*)
type
  ippiGetRotateQuadValue=array [0..3,0..1] of double;

function ippiGetRotateQuad(
    srcROI: IppiRect; quad:ippiGetRotateQuadValue; angle: double; xShift: double; yShift: double): IppStatus stdcall;

{LINE 2604}
(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiGetRotateBound
//  Purpose:            Computes the bounding rectangle for the transformed image ROI
//  Parameters:
//    srcROI            Source image ROI
//    angle             The angle of rotation in degrees
//    xShift, yShift    The shift along the corresponding axis
//    bound             Output array with vertex coordinates of the bounding rectangle
//  Returns:
//    ippStsNoErr       OK
*)
type
  ippiGetRotateBoundValue=array [0..1,0..1] of double;

function ippiGetRotateBound(
    srcROI: IppiRect; bound:ippiGetRotateBoundValue; angle: double; xShift: double; yShift: double): IppStatus stdcall;

implementation

uses
  ipplibs;

{$if ippilgclib<>'ippi90lgc.dll'}
  {.$define ippiname}
{$endif}

const
  legacy90={$ifdef ippiname'}'_'+{$endif}'legacy90';

  function ippiRotate_8u_C1R;external ippilgclib Name legacy90+'ippiRotate_8u_C1R'{$ifdef ippiname}+'@84'{$endif} delayed;
  function ippiRotate_8u_C3R;external ippilgclib Name legacy90+'ippiRotate_8u_C3R'{$ifdef ippiname}+'@84'{$endif} delayed;
  function ippiRotate_8u_C4R;external ippilgclib Name legacy90+'ippiRotate_8u_C4R'{$ifdef ippiname}+'@84'{$endif} delayed;
  function ippiRotate_8u_AC4R;external ippilgclib Name legacy90+'ippiRotate_8u_AC4R'{$ifdef ippiname}+'@84'{$endif} delayed;

  function ippiAddRotateShift;external ippilgclib {$ifdef ippiname} Name '_legacy90ippiAddRotateShift@32'{$endif} delayed;
  function ippiGetRotateQuad;external ippilgclib {$ifdef ippiname} Name '_legacy90ippiGetRotateQuad@44'{$endif} delayed;
  function ippiGetRotateBound;external ippilgclib {$ifdef ippiname} Name '_legacy90ippiGetRotateBound@44'{$endif} delayed;
end.



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

function ippiGetRotateShift(xCenter: double; yCenter: double; angle: double; xShift: Pdouble; yShift: Pdouble): IppStatus stdcall;

function ippiGetRotateShift;external ippilib {$ifdef ippiname} Name '_ippiGetRotateShift@32'{$endif} delayed;

