unit RedeemerQR;

// Redeemer's QR Code Encoder (16 and 17 Jan 2020)
// (c) redeemer.biz 2020
//
// https://www.delphipraxis.net/203147-redeemerqr-qr-code-encoder-klasse-fuer-delphi.html
//
// Limitations:
// - Supports only numeric, alphanumeric and Latin1 encodings
// - Doesn't yet support compression by splitting input into multiple inputs
//
// License: WTFPL

interface

uses
  Graphics, RedeemerInheritablePNG, Generics.Collections, SysUtils, pngimage;

type
  TQRECLevel = (ecLow, ecMedium, ecQuarter, ecHigh);
  TBoolean2D = array of array of Boolean;

  TRedeemerBitImage = class(TRedeemerInheritablePNG)
    public
      constructor Create(); override;
      procedure LoadFromBoolean2D(const Data: TBoolean2D);
      var
        Color0: TColor; // white
        Color1: TColor; // black
  end;

  TRedeemerQR = class(TRedeemerBitImage)
    protected
      class function  CreateGeneratorPolynomialGaloisField(const LeadingCoefficient: Byte; const Exponent: Byte; const TotalLength: Byte; const ECSize: Byte): TBytes; overload;
      class function  CreateGeneratorPolynomialGaloisField(const LeadingCoefficient: Byte; const Exponent: Byte; const TotalLength: Byte; const Polynomial: array of Byte; const ECSize: Byte): TBytes; overload;
      class function  CreateReedSolomonBlock(const Data: TBytes; const ECSize: Byte): TBytes;
      class procedure CreateBaseImage(const Version: Byte; var TempPixels, AllocatedPixels: TBoolean2D);
      class procedure DrawFormatInfo(const Mask: Byte; const ECLevel: TQRECLevel; var Pixels: TBoolean2D);
      class function  ApplyMask(const Mask: Byte; const ECLevel: TQRECLevel; const Pixels, AllocatedPixels: TBoolean2D): TBoolean2D;
      class function  RateMask(const Pixels: TBoolean2D): Cardinal;
    public
      procedure LoadFromString(const Latin1: RawByteString; const ECLevel: TQRECLevel);
  end;


implementation

uses
  RtlConsts;

type
  QRCodeVersion = 1..40;

const
  // Number of 8-bit modules
  QRTotalBytes: array[QRCodeVersion] of Word =
      (26,   44,   70,  100,  134,  172,  196,  242,  292,  346,
      404,  466,  532,  581,  655,  733,  815,  901,  991, 1085,
     1156, 1258, 1364, 1474, 1588, 1706, 1828, 1921, 2051, 2185,
     2323, 2465, 2611, 2761, 2876, 3034, 3196, 3362, 3532, 3706);

  // Number of 8-bit modules not used for error correction
  QRDataBytes: array[TQRECLevel,QRCodeVersion] of Word = (
      // LOW
      (19,   34,   55,   80,  108,  136,  156,  194,  232,  274,
      324,  370,  428,  461,  523,  589,  647,  721,  795 , 861,
      932, 1006, 1094, 1174, 1276, 1370, 1468, 1531, 1631, 1735,
     1843, 1955, 2071, 2191, 2306, 2434, 2566, 2702, 2812, 2956),
      // MEDIUM
      (16,   28,   44,   64,   86,  108,  124,  154,  182,  216,
      254,  290,  334,  365,  415,  453,  507,  563,  627,  669,
      714,  782,  860,  914, 1000, 1062, 1128, 1193, 1267, 1373,
     1455, 1541, 1631, 1725, 1812, 1914, 1992, 2102, 2216, 2334),
      // QUARTER
      (13,   22,   34,   48,   62,   76,   88,  110,  132,  154,
      180,  206,  244,  261,  295,  325,  367,  397,  445,  485,
      512,  568,  614,  664,  718,  754,  808,  871,  911,  985,
     1033, 1115, 1171, 1231, 1286, 1354, 1426, 1502, 1582, 1666),
      // HIGH
       (9,   16,   26,   36,   46,   60,   66,   86,  100,  122,
      140,  158,  180,  197,  223,  253,  283,  313,  341,  385,
      406,  442,  464,  514,  538,  596,  628,  661,  701,  745,
      793,  845,  901,  961,  986, 1054, 1096, 1142, 1222, 1276));

  // Number of Reed-Solomon blocks
  // (block sizes are very easy to calculate, so no need for a constant)
  QRRSBlocks: array[TQRECLevel,QRCodeVersion] of Byte = (
      // LOW
       (1,  1,  1,  1,  1,  2,  2,  2,  2,  4,
        4,  4,  4,  4,  6,  6,  6,  6,  7,  8,
        8,  9,  9, 10, 12, 12, 12, 13, 14, 15,
       16, 17, 18, 19, 19, 20, 21, 22, 24, 25),
      // MEDIUM
       (1,  1,  1,  2,  2,  4,  4,  4,  5,  5,
        5,  8,  9,  9, 10, 10, 11, 13, 14, 16,
       17, 17, 18, 20, 21, 23, 25, 26, 28, 29,
       31, 33, 35, 37, 38, 40, 43, 45, 47, 49),
      // QUARTER
       (1,  1,  2,  2,  4,  4,  6,  6,  8,  8,
        8, 10, 12, 16, 12, 17, 16, 18, 21, 20,
       23, 23, 25, 27, 29, 34, 34, 35, 38, 40,
       43, 45, 48, 51, 53, 56, 59, 62, 65, 68),
      // HIGH
       (1,  1,  2,  4,  4,  4,  5,  6,  8,  8,
       11, 11, 16, 16, 18, 16, 19, 21, 25, 25,
       25, 34, 30, 32, 35, 37, 40, 42, 45, 48,
       51, 54, 57, 60, 63, 66, 70, 74, 77, 81));

  // Generator polynomials for Reed-Solomon codes (they depend on the RS size)
  QRRSGenPoly7:  array[0.. 7] of Byte = (0, 87, 229, 146, 149, 238, 102, 21);                                                                                                             // repairs  2 bytes
  QRRSGenPoly10: array[0..10] of Byte = (0, 251, 67, 46, 61, 118, 70, 64, 94, 32, 45);                                                                                                    // repairs  4 bytes
  QRRSGenPoly13: array[0..13] of Byte = (0, 74, 152, 176, 100, 86, 100, 106, 104, 130, 218, 206, 140, 78);                                                                                // repairs  6 bytes
  QRRSGenPoly15: array[0..15] of Byte = (0, 8, 183, 61, 91, 202, 37, 51, 58, 58, 237, 140, 124, 5, 99, 105);                                                                              // repairs  7 bytes
  QRRSGenPoly16: array[0..16] of Byte = (0, 120, 104, 107, 109, 102, 161, 76, 3, 91, 191, 147, 169, 182, 194, 225, 120);                                                                  // repairs  8 bytes
  QRRSGenPoly17: array[0..17] of Byte = (0, 43, 139, 206, 78, 43, 239, 123, 206, 214, 147, 24, 99, 150, 39, 243, 163, 136);                                                               // repairs  8 bytes
  QRRSGenPoly18: array[0..18] of Byte = (0, 215, 234, 158, 94, 184, 97, 118, 170, 79, 187, 152, 148, 252, 179, 5, 98, 96, 153);                                                           // repairs  9 bytes
  QRRSGenPoly20: array[0..20] of Byte = (0, 17, 60, 79, 50, 61, 163, 26, 187, 202, 180, 221, 225, 83, 239, 156, 164, 212, 212, 188, 190);                                                 // repairs 10 bytes
  QRRSGenPoly22: array[0..22] of Byte = (0, 210, 171, 247, 242, 93, 230, 14, 109, 221, 53, 200, 74, 8, 172, 98, 80, 219, 134, 160, 105, 165, 231);                                        // repairs 11 bytes
  QRRSGenPoly24: array[0..24] of Byte = (0, 229, 121, 135, 48, 211, 117, 251, 126, 159, 180, 169, 152, 192, 226, 228, 218, 111, 0, 117, 232, 87, 96, 227, 21);                            // repairs 12 bytes
  QRRSGenPoly26: array[0..26] of Byte = (0, 173, 125, 158, 2, 103, 182, 118, 17, 145, 201, 111, 28, 165, 53, 161, 21, 245, 142, 13, 102, 48, 227, 153, 145, 218, 70);                     // repairs 13 bytes
  QRRSGenPoly28: array[0..28] of Byte = (0, 168, 223, 200, 104, 224, 234, 108, 180, 110, 190, 195, 147, 205, 27, 232, 201, 21, 43, 245, 87, 42, 195, 212, 119, 242, 37, 9, 123);          // repairs 14 bytes
  QRRSGenPoly30: array[0..30] of Byte = (0, 41, 173, 145, 152, 216, 31, 179, 182, 50, 48, 110, 86, 239, 96, 222, 125, 42, 173, 226, 193, 224, 130, 156, 37, 251, 216, 238, 40, 192, 180); // repairs 15 bytes

  // Galois field 256 with primitive polonomial 285
  GF256PP285: array[Byte] of Byte =
       (1,   2,   4,   8,  16,  32,  64, 128,  29,  58, 116, 232, 205, 135,  19,  38,
       76, 152,  45,  90, 180, 117, 234, 201, 143,   3,   6,  12,  24,  48,  96, 192,
      157,  39,  78, 156,  37,  74, 148,  53, 106, 212, 181, 119, 238, 193, 159,  35,
       70, 140,   5,  10,  20,  40,  80, 160,  93, 186, 105, 210, 185, 111, 222, 161,
       95, 190,  97, 194, 153,  47,  94, 188, 101, 202, 137,  15,  30,  60, 120, 240,
      253, 231, 211, 187, 107, 214, 177, 127, 254, 225, 223, 163,  91, 182, 113, 226,
      217, 175,  67, 134,  17,  34,  68, 136,  13,  26,  52, 104, 208, 189, 103, 206,
      129,  31,  62, 124, 248, 237, 199, 147,  59, 118, 236, 197, 151,  51, 102, 204,
      133,  23,  46,  92, 184, 109, 218, 169,  79, 158,  33,  66, 132,  21,  42,  84,
      168,  77, 154,  41,  82, 164,  85, 170,  73, 146,  57, 114, 228, 213, 183, 115,
      230, 209, 191,  99, 198, 145,  63, 126, 252, 229, 215, 179, 123, 246, 241, 255,
      227, 219, 171,  75, 150,  49,  98, 196, 149,  55, 110, 220, 165,  87, 174,  65,
      130,  25,  50, 100, 200, 141,   7,  14,  28,  56, 112, 224, 221, 167,  83, 166,
       81, 162,  89, 178, 121, 242, 249, 239, 195, 155,  43,  86, 172,  69, 138,   9,
       18,  36,  72, 144,  61, 122, 244, 245, 247, 243, 251, 235, 203, 139,  11,  22,
       44,  88, 176, 125, 250, 233, 207, 131,  27,  54, 108, 216, 173,  71, 142,   1);

  // Inverse Galois field 256 with primitive polonomial 285
  GF256PP285inv: array[1..255] of Byte =
            (0,   1,  25,   2,  50,  26, 198,   3, 223,  51, 238,  27, 104, 199,  75,
        4, 100, 224,  14,  52, 141, 239, 129,  28, 193, 105, 248, 200,   8,  76, 113,
        5, 138, 101,  47, 225,  36,  15,  33,  53, 147, 142, 218, 240,  18, 130,  69,
       29, 181, 194, 125, 106,  39, 249, 185, 201, 154,   9, 120,  77, 228, 114, 166,
        6, 191, 139,  98, 102, 221,  48, 253, 226, 152,  37, 179,  16, 145,  34, 136,
       54, 208, 148, 206, 143, 150, 219, 189, 241, 210,  19,  92, 131,  56,  70,  64,
       30,  66, 182, 163, 195,  72, 126, 110, 107,  58,  40,  84, 250, 133, 186,  61,
      202,  94, 155, 159,  10,  21, 121,  43,  78, 212, 229, 172, 115, 243, 167,  87,
        7, 112, 192, 247, 140, 128,  99,  13, 103,  74, 222, 237,  49, 197, 254,  24,
      227, 165, 153, 119,  38, 184, 180, 124,  17,  68, 146, 217,  35,  32, 137,  46,
       55,  63, 209,  91, 149, 188, 207, 205, 144, 135, 151, 178, 220, 252, 190,  97,
      242,  86, 211, 171,  20,  42,  93, 158, 132,  60,  57,  83,  71, 109,  65, 162,
       31,  45,  67, 216, 183, 123, 164, 118, 196,  23,  73, 236, 127,  12, 111, 246,
      108, 161,  59,  82,  41, 157,  85, 170, 251,  96, 134, 177, 187, 204,  62,  90,
      203,  89,  95, 176, 156, 169, 160,  81,  11, 245,  22, 235, 122, 117,  44, 215,
       79, 174, 213, 233, 230, 231, 173, 232, 116, 214, 244, 234, 168,  80,  88, 175);

  // Alphanumeric 0010 mode character encoding table
  QRAlphanumericCodePoints: array[AnsiChar] of ShortInt =
      (-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
       -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
       36, -1, -1, -1, 37, 38, -1, -1, -1, -1, 39, 40, -1, 41, 42, 43,
        0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 44, -1, -1, -1, -1, -1,
       -1, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
       25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, -1, -1, -1, -1, -1,
       -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
       -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
       -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
       -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
       -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
       -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
       -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
       -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
       -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
       -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);

  // I was too lazy to implement Bose-Chaudhuri-Hocquenghem
  QRFormatInfo: array[TQRECLevel, 0..7] of Word = (
    (30660, 29427, 32170, 30877, 26159, 25368, 27713, 26998),
    (21522, 20773, 24188, 23371, 17913, 16590, 20375, 19104),
    (13663, 12392, 16177, 14854,  9396,  8579, 11994, 11245),
     (5769,  5054,  7399,  6608,  1890,   597,  3340,  2107));

  QRVersionInfo: array[7..40] of Cardinal =         (31892,  34236,  39577,  42195,
     48118,  51042,  55367,  58893,  63784,  68472,  70749,  76311,  79154,  84390,
     87683,  92361,  96236, 102084, 102881, 110507, 110734, 117786, 119615, 126325,
    127568, 133589, 136944, 141498, 145311, 150283, 152622, 158308, 161089, 167017);

  EncodingBits = 4; // Bits used to specify encoding at the start of a stream
  TerminatorBits = EncodingBits; // Bits used to specify the end of stream (using invalid encoding mode 0)


{ TRedeemerQR }

class function TRedeemerQR.CreateGeneratorPolynomialGaloisField(const LeadingCoefficient, Exponent, TotalLength, ECSize: Byte): TBytes;
begin
  case ECSize of
    7:  Result := CreateGeneratorPolynomialGaloisField(LeadingCoefficient, Exponent, TotalLength, QRRSGenPoly7,  ECSize);
    10: Result := CreateGeneratorPolynomialGaloisField(LeadingCoefficient, Exponent, TotalLength, QRRSGenPoly10, ECSize);
    13: Result := CreateGeneratorPolynomialGaloisField(LeadingCoefficient, Exponent, TotalLength, QRRSGenPoly13, ECSize);
    15: Result := CreateGeneratorPolynomialGaloisField(LeadingCoefficient, Exponent, TotalLength, QRRSGenPoly15, ECSize);
    16: Result := CreateGeneratorPolynomialGaloisField(LeadingCoefficient, Exponent, TotalLength, QRRSGenPoly16, ECSize);
    17: Result := CreateGeneratorPolynomialGaloisField(LeadingCoefficient, Exponent, TotalLength, QRRSGenPoly17, ECSize);
    18: Result := CreateGeneratorPolynomialGaloisField(LeadingCoefficient, Exponent, TotalLength, QRRSGenPoly18, ECSize);
    20: Result := CreateGeneratorPolynomialGaloisField(LeadingCoefficient, Exponent, TotalLength, QRRSGenPoly20, ECSize);
    22: Result := CreateGeneratorPolynomialGaloisField(LeadingCoefficient, Exponent, TotalLength, QRRSGenPoly22, ECSize);
    24: Result := CreateGeneratorPolynomialGaloisField(LeadingCoefficient, Exponent, TotalLength, QRRSGenPoly24, ECSize);
    26: Result := CreateGeneratorPolynomialGaloisField(LeadingCoefficient, Exponent, TotalLength, QRRSGenPoly26, ECSize);
    28: Result := CreateGeneratorPolynomialGaloisField(LeadingCoefficient, Exponent, TotalLength, QRRSGenPoly28, ECSize);
    30: Result := CreateGeneratorPolynomialGaloisField(LeadingCoefficient, Exponent, TotalLength, QRRSGenPoly30, ECSize);
    else raise Exception.Create(SInvalidImage);
  end;
end;

class function TRedeemerQR.ApplyMask(const Mask: Byte; const ECLevel: TQRECLevel; const Pixels, AllocatedPixels: TBoolean2D): TBoolean2D;
var
  EdgeEnd: Integer;
  i: Byte;
procedure ApplyMask0();
var
  i, j: Byte;
begin
  for i := 0 to EdgeEnd do // y
  for j := 0 to EdgeEnd do // x
  if AllocatedPixels[j, i] then
  Result[j, i] := Pixels[j, i]
  else
  Result[j, i] := Pixels[j, i] xor ((i+j) mod 2 = 0);
end;
procedure ApplyMask1();
var
  i, j: Byte;
begin
  for i := 0 to EdgeEnd do // y
  for j := 0 to EdgeEnd do // x
  if AllocatedPixels[j, i] then
  Result[j, i] := Pixels[j, i]
  else
  Result[j, i] := Pixels[j, i] xor (i mod 2 = 0);
end;
procedure ApplyMask2();
var
  i, j: Byte;
begin
  for i := 0 to EdgeEnd do // y
  for j := 0 to EdgeEnd do // x
  if AllocatedPixels[j, i] then
  Result[j, i] := Pixels[j, i]
  else
  Result[j, i] := Pixels[j, i] xor (j mod 3 = 0);
end;
procedure ApplyMask3();
var
  i, j: Byte;
begin
  for i := 0 to EdgeEnd do // y
  for j := 0 to EdgeEnd do // x
  if AllocatedPixels[j, i] then
  Result[j, i] := Pixels[j, i]
  else
  Result[j, i] := Pixels[j, i] xor ((i+j) mod 3 = 0);
end;
procedure ApplyMask4();
var
  i, j: Byte;
begin
  for i := 0 to EdgeEnd do // y
  for j := 0 to EdgeEnd do // x
  if AllocatedPixels[j, i] then
  Result[j, i] := Pixels[j, i]
  else
  Result[j, i] := Pixels[j, i] xor ((i div 2 + j div 3) mod 2 = 0);
end;
procedure ApplyMask5();
var
  i, j: Word;
begin
  for i := 0 to EdgeEnd do // y
  for j := 0 to EdgeEnd do // x
  if AllocatedPixels[j, i] then
  Result[j, i] := Pixels[j, i]
  else
  Result[j, i] := Pixels[j, i] xor (i*j mod 2 + i*j mod 3 = 0);
end;
procedure ApplyMask6();
var
  i, j: Word;
begin
  for i := 0 to EdgeEnd do // y
  for j := 0 to EdgeEnd do // x
  if AllocatedPixels[j, i] then
  Result[j, i] := Pixels[j, i]
  else
  Result[j, i] := Pixels[j, i] xor ((i*j mod 2 + i*j mod 3) mod 2 = 0);
end;
procedure ApplyMask7();
var
  i, j: Word;
begin
  for i := 0 to EdgeEnd do // y
  for j := 0 to EdgeEnd do // x
  if AllocatedPixels[j, i] then
  Result[j, i] := Pixels[j, i]
  else
  Result[j, i] := Pixels[j, i] xor ((i * j mod 3 + (i+j) mod 2) mod 2 = 0);
end;
begin
  EdgeEnd := High(Pixels);
  SetLength(Result, EdgeEnd + 1);
  for i := 0 to EdgeEnd do // y
  SetLength(Result[i], EdgeEnd + 1);

  case Mask of
    0: ApplyMask0();
    1: ApplyMask1();
    2: ApplyMask2();
    3: ApplyMask3();
    4: ApplyMask4();
    5: ApplyMask5();
    6: ApplyMask6();
    7: ApplyMask7();
  end;

  DrawFormatInfo(Mask, ECLEvel, Result);
end;

class procedure TRedeemerQR.CreateBaseImage(const Version: Byte; var TempPixels, AllocatedPixels: TBoolean2D);
function ChebyshevDistance(a, b: ShortInt): Byte; inline; // infinity metric
begin
  if a < 0 then
  a := -a;
  if b < 0 then
  b := -b;
  if a > b then
  Result := a
  else
  Result := b;
end;
var
  EdgeSize: Byte;
procedure PlacePatterns(const Positions: array of Byte);
procedure PlacePattern(const X, Y: Byte);
var
  i, j: SmallInt;
begin
  for i := -2 to 2 do
  for j := -2 to 2 do
  begin
    AllocatedPixels[x+i, y+j] := True;
    TempPixels[x+i, y+j] := ChebyshevDistance(i, j) <> 1;
  end;
end;
var
  X, Y: Byte;
begin
  for X in Positions do
  for Y in Positions do
  if not ((X = 6) and (Y = Version * 4 + 10) or (X = Version * 4 + 10) and (Y = 6) or (X = 6) and (Y = 6)) then // omit top left, top right and bottom left ones
  PlacePattern(X, Y);
end;
procedure PlaceBigPattern(const X, Y: Byte);
var
  i, j: SmallInt;
begin
  for i := -4 to 4 do
  for j := -4 to 4 do
  if (x+i >= 0) and (y+j >= 0) and (x+i < EdgeSize) and (y+j < EdgeSize) then // in the visible area
  begin
    AllocatedPixels[x+i, y+j] := True;
    case ChebyshevDistance(i, j) of
      2, 4: TempPixels[x+i, y+j] := False;
      else TempPixels[x+i, y+j] := True;
    end;
  end;
end;
var
  i, j: Integer;
  VersionInfo: Cardinal;
begin
  EdgeSize := Version * 4 + 17;
  // InitBlankNonPaletteImage(COLOR_RGB, 8, EdgeSize, EdgeSize);
  SetLength(AllocatedPixels, EdgeSize);
  for i := 0 to EdgeSize - 1 do
  SetLength(AllocatedPixels[i], EdgeSize);
  SetLength(TempPixels, EdgeSize);
  for i := 0 to EdgeSize - 1 do
  SetLength(TempPixels[i], EdgeSize);


  // Placing alignment patterns
  case Version of
    2: PlacePatterns([18]);
    3: PlacePatterns([22]);
    4: PlacePatterns([26]);
    5: PlacePatterns([30]);
    6: PlacePatterns([34]);
    7: PlacePatterns([6, 22, 38]);
    8: PlacePatterns([6, 24, 42]);
    9: PlacePatterns([6, 26, 46]);
    10: PlacePatterns([6, 28, 50]);
    11: PlacePatterns([6, 30, 54]);
    12: PlacePatterns([6, 32, 58]);
    13: PlacePatterns([6, 34, 62]);
    14: PlacePatterns([6, 26, 46, 66]);
    15: PlacePatterns([6, 26, 48, 70]);
    16: PlacePatterns([6, 26, 50, 74]);
    17: PlacePatterns([6, 30, 54, 78]);
    18: PlacePatterns([6, 30, 56, 82]);
    19: PlacePatterns([6, 30, 58, 86]);
    20: PlacePatterns([6, 34, 62, 90]);
    21: PlacePatterns([6, 28, 50, 72, 94]);
    22: PlacePatterns([6, 26, 50, 74, 98]);
    23: PlacePatterns([6, 30, 54, 78, 102]);
    24: PlacePatterns([6, 28, 54, 80, 106]);
    25: PlacePatterns([6, 32, 58, 84, 110]);
    26: PlacePatterns([6, 30, 58, 86, 114]);
    27: PlacePatterns([6, 34, 62, 90, 118]);
    28: PlacePatterns([6, 26, 50, 74, 98, 122]);
    29: PlacePatterns([6, 30, 54, 78, 102, 126]);
    30: PlacePatterns([6, 26, 52, 78, 104, 130]);
    31: PlacePatterns([6, 30, 56, 82, 108, 134]);
    32: PlacePatterns([6, 34, 60, 86, 112, 138]);
    33: PlacePatterns([6, 30, 58, 86, 114, 142]);
    34: PlacePatterns([6, 34, 62, 90, 118, 146]);
    35: PlacePatterns([6, 30, 54, 78, 102, 126, 150]);
    36: PlacePatterns([6, 24, 50, 76, 102, 128, 154]);
    37: PlacePatterns([6, 28, 54, 80, 106, 132, 158]);
    38: PlacePatterns([6, 32, 58, 84, 110, 136, 162]);
    39: PlacePatterns([6, 26, 54, 82, 110, 138, 166]);
    40: PlacePatterns([6, 30, 58, 86, 114, 142, 170]);
  end;

  // Stripes
  for i := 8 to Version * 4 + 8 do
  begin
    AllocatedPixels[6, i] := True;
    AllocatedPixels[i, 6] := True;
    if i and 1 = 0 then
    begin
      TempPixels[6, i] := True;
      TempPixels[i, 6] := True;
    end
    else
    begin
      TempPixels[6, i] := False;
      TempPixels[i, 6] := False;
    end;
  end;

  // Big patterns
  PlaceBigPattern(3, 3);
  PlaceBigPattern(3, EdgeSize - 4);
  PlaceBigPattern(EdgeSize - 4, 3);

  // Write version (version 7+)
  if Version >= 7 then
  begin
    VersionInfo := QRVersionInfo[Version];
    for i := 0 to 5 do
    for j := EdgeSize - 11 to EdgeSize - 9 do
    begin
      AllocatedPixels[i, j] := True;
      AllocatedPixels[j, i] := True;
      TempPixels[i, j] := Boolean(VersionInfo and 1);
      TempPixels[j, i] := Boolean(VersionInfo and 1);
      VersionInfo := VersionInfo shr 1;
    end;
  end;

  // Reserve version info areas
  for i := 0 to 8 do
  begin
    AllocatedPixels[8, i] := True;
    AllocatedPixels[i, 8] := True;
  end;
  for i := EdgeSize - 1 downto EdgeSize - 8 do
  begin
    AllocatedPixels[8, i] := True;
    AllocatedPixels[i, 8] := True;
  end;
  TempPixels[8, EdgeSize- 8] := True;
end;

class function TRedeemerQR.CreateGeneratorPolynomialGaloisField(const LeadingCoefficient, Exponent, TotalLength: Byte; const Polynomial: array of Byte; const ECSize: Byte): TBytes;
var
  CoefficientExponent: Byte;
  i: Byte;
begin
  SetLength(Result, TotalLength);
  CoefficientExponent := GF256PP285inv[LeadingCoefficient];
  for i := Low(Result) to High(Result) do
  if (i >= TotalLength - ECSize - 1 - Exponent) and // Are we in the part of the polynomial with non-zero coefficients?
     (i < TotalLength - Exponent) then
  Result[i] := GF256PP285[Byte(
                               (Word(CoefficientExponent) + Word(Polynomial[i - TotalLength + ECSize + 1 + Exponent])) mod 255
                               )]
  //else
  //Result[i] := 0;
end;

class function TRedeemerQR.CreateReedSolomonBlock(const Data: TBytes; const ECSize: Byte): TBytes;
var
  i, j: Integer;
  TempPoly: TBytes;
  GenPoly: TBytes;
begin
  // Create temporary polynomial
  TempPoly := Copy(Data);
  SetLength(TempPoly, Length(Data) + ECSize);
  //for i := Length(Data) to High(TempPoly) do
  //TempPoly[i] := 0;

  // Do polynomial division
  for i := 0 to Length(Data) - 1 do
  if TempPoly[i] > 0 then // need to do polynomial division to remove this coefficient
  begin
    GenPoly := CreateGeneratorPolynomialGaloisField(TempPoly[i], Length(Data) - 1 - i, Length(TempPoly), ECSize);
    for j := Low(TempPoly) to High(TempPoly) do
    TempPoly[j] := TempPoly[j] xor GenPoly[j];
  end;

  // Create result
  Result := Copy(Data);
  SetLength(Result, Length(Data) + ECSize);
  for i := Length(Data) to High(TempPoly) do
  Result[i] := TempPoly[i];
end;

class procedure TRedeemerQR.DrawFormatInfo(const Mask: Byte; const ECLevel: TQRECLevel; var Pixels: TBoolean2D);
var
  Data: Word;
  i: Byte;
  EdgeEnd: Byte;
begin
  Data := QRFormatInfo[ECLevel, Mask];
  EdgeEnd := High(Pixels);
  for i := 0 to 7 do
  begin
    Pixels[8, i + Byte(i >= 6)] := Boolean((Data shr i) and 1);
    Pixels[EdgeEnd - i, 8] := Boolean((Data shr i) and 1);
  end;
  for i := 0 to 6 do
  begin
    Pixels[8, EdgeEnd - i] := Boolean((Data shr (14 - i)) and 1);
    Pixels[i + Byte(i = 6), 8] := Boolean((Data shr (14 - i)) and 1);
  end;
end;

procedure TRedeemerQR.LoadFromString(const Latin1: RawByteString; const ECLevel: TQRECLevel);
var
  // Encoding and
  Version: QRCodeVersion;
  TotalSize: Word;    // 26..3706
  DataSize: Word;     // 9..2956
  DataSizeBits: Word; // 72..23648
  DataSizeUsed: Word; // Number of bytes in DataBitStream (Count div 8)
  i, j: Integer;
  c: AnsiChar;
  CanNumeric: Boolean;
  CanAlphanumeric: Boolean;
  SizeSize: Integer; // Size of size (in bits)
  DataBitStream: TList<Boolean>;
  EncodedData: TBytes;
  InputLength: Integer;
  ReedSolomonBlockCache: array of TBytes;

  Chunk: AnsiString; // characters of one encoded unit

  // Reed-Solomon stuff
  ECSize: Byte;
  RSBlockCount: Byte; // taken from constant QRRSBlocks
  LesserRSBlockDataSize: Byte; // Size of lesser block's data (without EC data)
  LesserRSBlockTotalSize: Byte; // Size of lesser block's total size (with EC data)
  GreaterRSBlockCount: Byte; // Number of smaller blocks
  LesserRSBlockCount: Byte; // Number of smaller blocks

  TotalResult: TList<Byte>;

  // Image generation stuff
  EdgeSize: Integer;
  PreAllocatedPixels: TBoolean2D; // pixels blocked by being pre-allocated
  UnmaskedPixels: TBoolean2D;
  X: Byte;
  Y: SmallInt;
  YDir: ShortInt; // Direction of Y-movement: -1 = up, 1 = down
  Right: Boolean; // Using the right
  b: Byte;

  // Masking
  TempMaskedPixels: TBoolean2D;
  TempRating: Cardinal;
  BestMaskedPixels: TBoolean2D;
  BestRating: Cardinal;

procedure FindVersion();
var
  i: Integer;
begin
  SizeSize := 0;
  for i := Low(QRCodeVersion) to High(QRCodeVersion) do
  begin
    Version := i;
    DataSize := QRDataBytes[ECLevel, i];
    DataSizeBits := DataSize shl 3;
    if CanNumeric then
    begin
      case Version of
        1..9: SizeSize := 10;
        10..26: SizeSize := 12;
        27..40: SizeSize := 14;
      end;
      if (DataSizeBits - EncodingBits - SizeSize) * 3 div 10 >= InputLength then
      Exit;
    end
    else
    if CanAlphanumeric then
    begin
      case Version of
        1..9: SizeSize := 9;
        10..26: SizeSize := 11;
        27..40: SizeSize := 13;
      end;
      if (DataSizeBits - EncodingBits - SizeSize) * 2 div 11 >= InputLength then
      Exit;
    end
    else
    begin
      case Version of
        1..9: SizeSize := 8;
        10..40: SizeSize := 16;
      end;
      if (DataSizeBits - EncodingBits - SizeSize) div 8 >= InputLength then
      Exit;
    end;
  end;
  raise Exception.CreateFmt(SListCountError, [InputLength]);
end;
procedure WriteToBitStream(Data: Cardinal; const Bits: Byte);
var
  i: Byte;
begin
  for i := Bits - 1 downto 0 do
  DataBitStream.Add((Data shr i) and 1 = 1);
end;
procedure DrawBit(const Bit: Boolean);
begin
  repeat
    if not Right then
    begin
      Inc(Y, YDir);
      case Y of
        -1: begin
              Y := 0;
              X := X - 2;
              if X = 5 then // right pixel would be stripe pattern column
              Dec(X);
              YDir := -YDir;
            end;
        6:  Inc(Y, YDir); // stripe pattern row
        else
            if Y = EdgeSize then // constants not allowed in case...
            begin
              Y := EdgeSize - 1;
              X := X - 2;
              if X = 5 then // right pixel would be stripe pattern column
              Dec(X);
              YDir := -YDir;
            end;
      end;
    end;
    Right := not Right;
  until not PreAllocatedPixels[X + Byte(Right), Y];
  UnmaskedPixels[X + Byte(Right), Y] := Bit;
end;
begin
  //
  //  DATA ENCODING
  //

  // Determine the encoding to use
  CanAlphanumeric := True;
  CanNumeric := True;
  for c in Latin1 do
  if not (Ord(c) in [48..57]) then
  begin
    CanNumeric := False;
    if QRAlphanumericCodePoints[c] = -1 then
    begin
      CanAlphanumeric := False;
      Break;
    end;
  end;

  // Determine version
  // Note: This would be the difficult part when working with multiple streams (in addition to finding the splitting to produce the smallest amount of data):
  //       You will not know which version you need because the length size depends on the version, but at the same time, the version depends on the total size.
  //       This means that you will have to assume the versions 9, 26 and 40 and encode data without padding. Take the smallest of these three versions that can hold the data.
  //       If the encoded data without padding would fit lesser versions, use these lesser versions. No need to re-encode the data, just add the different types of padding.
  InputLength := Length(Latin1);
  FindVersion();
  TotalSize := QRTotalBytes[Version];

  DataBitStream := TList<Boolean>.Create();
  try
    // Write data encoding
    if CanNumeric then
    WriteToBitStream(1, EncodingBits)
    else
    if CanAlphanumeric then
    WriteToBitStream(2, EncodingBits)
    else
    WriteToBitStream(4, EncodingBits);

    // Write data length
    WriteToBitStream(InputLength, SizeSize);

    // Encode data
    if CanNumeric then
    for i := 0 to (InputLength - 1) div 3 do
    begin
      Chunk := Copy(Latin1, i * 3 + 1, 3);
      WriteToBitStream(StrToInt(string(Chunk)), 1 + 3 * Length(Chunk));
    end
    else
    if CanAlphanumeric then
    for i := 0 to (InputLength - 1) div 2 do
    begin
      Chunk := Copy(Latin1, i * 2 + 1, 2);
      case Length(Chunk) of
        1: WriteToBitStream(QRAlphanumericCodePoints[Chunk[1]], 6);
        2: WriteToBitStream(Word(QRAlphanumericCodePoints[Chunk[1]]) * 45 + Word(QRAlphanumericCodePoints[Chunk[2]]), 11);
      end;
    end
    else
    for i := 0 to InputLength - 1 do
    WriteToBitStream(Ord(Latin1[i+1]), 8);

    // Add terminator (if there's enough room)
    if DataBitStream.Count <= DataSizeBits - TerminatorBits then // there's room for the terminator
    WriteToBitStream(0, TerminatorBits);

    // Add padding bits to make it a full byte
    while DataBitStream.Count mod 8 > 0 do
    WriteToBitStream(0, 1);

    // Convert to TBytes
    SetLength(EncodedData, DataSize);
    DataSizeUsed := DataBitStream.Count div 8;
    for i := 0 to DataSize - 1 do
    if i < DataSizeUsed then
    EncodedData[i] := Byte(DataBitStream[i * 8    ]) shl 7 +
                      Byte(DataBitStream[i * 8 + 1]) shl 6 +
                      Byte(DataBitStream[i * 8 + 2]) shl 5 +
                      Byte(DataBitStream[i * 8 + 3]) shl 4 +
                      Byte(DataBitStream[i * 8 + 4]) shl 3 +
                      Byte(DataBitStream[i * 8 + 5]) shl 2 +
                      Byte(DataBitStream[i * 8 + 6]) shl 1 +
                      Byte(DataBitStream[i * 8 + 7])
    else
    // Add padding bytes to fill data modules
    case (i - DataSizeUsed) mod 2 of
      0: EncodedData[i] := 236;
      1: EncodedData[i] := 17;
    end;
  finally
    DataBitStream.Free();
  end;



  //
  //  REED-SOLOMON
  //

  // Determine Reed-Solomon parameters
  RSBlockCount := QRRSBlocks[ECLevel][Version];
  LesserRSBlockDataSize := DataSize div RSBlockCount;
  LesserRSBlockTotalSize := TotalSize div RSBlockCount;
  ECSize := LesserRSBlockTotalSize - LesserRSBlockDataSize;
  GreaterRSBlockCount := TotalSize - RSBlockCount * LesserRSBlockTotalSize;
  LesserRSBlockCount := RSBlockCount - GreaterRSBlockCount;


  TotalResult := TList<Byte>.Create();
  TotalResult.Capacity := TotalSize;
  try
    SetLength(ReedSolomonBlockCache, RSBlockCount);

    // Create lesser Reed-Solomon block(s)
    for i := 0 to LesserRSBlockCount - 1 do
    ReedSolomonBlockCache[i] := CreateReedSolomonBlock(Copy(EncodedData, i * LesserRSBlockDataSize, LesserRSBlockDataSize), ECSize);

    // Create great Reed-Solomon block(s) (if any)
    for i := 0 to GreaterRSBlockCount - 1 do
    ReedSolomonBlockCache[LesserRSBlockCount + i] := CreateReedSolomonBlock(Copy(EncodedData, LesserRSBlockDataSize * LesserRSBlockCount + i * (LesserRSBlockDataSize + 1), LesserRSBlockDataSize + 1), ECSize);

    // Interleaving - encoded data
    for i := 0 to LesserRSBlockDataSize - 1 do
    for j := 0 to RSBlockCount - 1 do
    TotalResult.Add(ReedSolomonBlockCache[j][i]);
    for j := 0 to GreaterRSBlockCount - 1 do
    TotalResult.Add(ReedSolomonBlockCache[LesserRSBlockCount + j][LesserRSBlockDataSize]);

    // Interleaving - error correction
    for i := LesserRSBlockDataSize to LesserRSBlockDataSize + ECSize - 1 do
    for j := 0 to RSBlockCount - 1 do
    TotalResult.Add(ReedSolomonBlockCache[j][i+Byte(j>=LesserRSBlockCount)]);



    //
    //  IMAGE GENERATION
    //

    EdgeSize := 17 + Version * 4;
    Y := EdgeSize;
    X := EdgeSize -2;
    Right := False;
    YDir := -1;

    // Create blank QR code with only guide patterns
    CreateBaseImage(Version, UnmaskedPixels, PreAllocatedPixels);

    // Write all bytes from TotalResult to the QR code
    for b in TotalResult do
    begin
      DrawBit(Boolean(b shr 7));
      DrawBit(Boolean((b shr 6) and 1));
      DrawBit(Boolean((b shr 5) and 1));
      DrawBit(Boolean((b shr 4) and 1));
      DrawBit(Boolean((b shr 3) and 1));
      DrawBit(Boolean((b shr 2) and 1));
      DrawBit(Boolean((b shr 1) and 1));
      DrawBit(Boolean(b and 1));
    end;
  finally
    TotalResult.Free();
  end;

  // Apply and rate masks
  BestMaskedPixels := ApplyMask(0, ECLevel, UnmaskedPixels, PreAllocatedPixels);
  BestRating := RateMask(BestMaskedPixels);
  for i := 1 to 7 do
  begin
    TempMaskedPixels := ApplyMask(i, ECLevel, UnmaskedPixels, PreAllocatedPixels);
    TempRating := RateMask(TempMaskedPixels);
    if TempRating < BestRating then
    begin
      BestRating := TempRating;
      BestMaskedPixels := TempMaskedPixels;
    end;
  end;

  // Create image with best mask
  LoadFromBoolean2D(BestMaskedPixels);
end;

class function TRedeemerQR.RateMask(const Pixels: TBoolean2D): Cardinal;
var
  EdgeEnd: Byte;
function RateMask1(): Cardinal;
var
  i, j: Byte;
  Lastj: Byte;
  LastState: Boolean;
begin
  // Give len-2 rating for horizontal and vertical consecutive identical blocks of length len>=5
  Result := 0;
  // Horizontal
  for i := 0 to EdgeEnd do
  begin
    lastj := 0;
    LastState := Pixels[0,i];
    for j := 0 to EdgeEnd do
    if Pixels[j,i] = LastState then
    case j - Lastj of
      0..3: ;
      4: Inc(Result, 3);
      else Inc(Result);
    end
    else
    begin
      Lastj := j;
      LastState := not LastState;
    end;
  end;
  // Vertical
  for i := 0 to EdgeEnd do
  begin
    lastj := 0;
    LastState := Pixels[i,0];
    for j := 0 to EdgeEnd do
    if Pixels[i,j] = LastState then
    case j - Lastj of
      0..3: ;
      4: Inc(Result, 3);
      else Inc(Result);
    end
    else
    begin
      Lastj := j;
      LastState := not LastState;
    end;
  end;
end;
function RateMask2(): Cardinal;
var
  x, y: Byte;
begin
  // Give 3 rating for each 2x2 block of the same color
  Result := 0;
  for x := 0 to EdgeEnd - 1 do
  for y := 0 to EdgeEnd - 1 do
  if (Pixels[x,y] = Pixels[x,y+1]) and (Pixels[x,y] = Pixels[x+1,y]) and (Pixels[x,y] = Pixels[x+1,y+1]) then
  Inc(Result, 3);
end;
function RateMask3(): Cardinal;
var
  x, y: Byte;
begin
  // Give 40 rating for each 10111010000 or inverse
  Result := 0;
  for x := 0 to EdgeEnd - 10 do
  for y := 0 to EdgeEnd do
  begin
    // 10111010000 horizontally
    if Pixels[x,y] and not Pixels[x+1,y] and Pixels[x+2,y] and Pixels[x+3,y] and Pixels[x+4,y] and not Pixels[x+5,y] and Pixels[x+6,y] and not Pixels[x+7,y] and not Pixels[x+8,y] and not Pixels[x+9,y] and not Pixels[x+10,y] then
    Inc(Result, 40);
    // 00001011101 horizontally
    if Pixels[x+10,y] and not Pixels[x+9,y] and Pixels[x+8,y] and Pixels[x+7,y] and Pixels[x+6,y] and not Pixels[x+5,y] and Pixels[x+4,y] and not Pixels[x+3,y] and not Pixels[x+2,y] and not Pixels[x+1,y] and not Pixels[x,y] then
    Inc(Result, 40);
  end;
  for x := 0 to EdgeEnd do
  for y := 0 to EdgeEnd - 10 do
  begin
    // 10111010000 vertically
    if Pixels[x,y] and not Pixels[x,y+1] and Pixels[x,y+2] and Pixels[x,y+3] and Pixels[x,y+4] and not Pixels[x,y+5] and Pixels[x,y+6] and not Pixels[x,y+7] and not Pixels[x,y+8] and not Pixels[x,y+9] and not Pixels[x,y+10] then
    Inc(Result, 40);
    // 00001011101 vertically
    if Pixels[x,y+10] and not Pixels[x,y+9] and Pixels[x,y+8] and Pixels[x,y+7] and Pixels[x,y+6] and not Pixels[x,y+5] and Pixels[x,y+4] and not Pixels[x,y+3] and not Pixels[x,y+2] and not Pixels[x,y+1] and not Pixels[x,y] then
    Inc(Result, 40);
  end;
end;
function RateMask4(): Cardinal;
var
  x, y: Byte;
  Blacks: Cardinal;
  Rating: Extended;
begin
  // Give rating depending on black/white distribution
  Blacks := 0;
  for x := 0 to EdgeEnd do
  for y := 0 to EdgeEnd do
  if Pixels[x,y] then
  Inc(Blacks);

  Rating := Blacks * 20 / ((EdgeEnd + 1) * (EdgeEnd + 1)) - 10;

  if Rating < 0 then
  Result := Trunc(-Rating) * 10
  else
  Result := Trunc(Rating) * 10;
end;
begin
  EdgeEnd := High(Pixels);
  Result := RateMask1() + RateMask2() + RateMask3() + RateMask4();
end;

{ TRedeemerBitImage }

constructor TRedeemerBitImage.Create;
begin
  inherited;
  Color0 := clWhite;
  Color1 := clBlack;
end;

procedure TRedeemerBitImage.LoadFromBoolean2D(const Data: TBoolean2D);
var
  x, y: Word;
begin
  InitBlankNonPaletteImage(COLOR_RGB, 8, Length(Data[0]), Length(Data));
  for y := 0 to Length(Data) - 1 do
  for x := 0 to Length(Data[0]) - 1 do
  if Data[x, y] then
  Pixels[x, y] := Color1
  else
  Pixels[x, y] := Color0;
end;

end.
