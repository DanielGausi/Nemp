// Redeemer's QR Code Encoder (16 and 17 Jan 2020)
// (c) redeemer.biz 2020
// https://www.delphipraxis.net/203147-redeemerqr-qr-code-encoder-klasse-fuer-delphi.html
unit RedeemerInheritablePNG;

interface

uses pngimage;

type TChunkIHDR2 = class(TChunkIHDR); // hole protected-Methode PrepareImageData
type PChunkIHDR2 = ^TChunkIHDR2;

type TRedeemerInheritablePNG = class(TPNGImage)
  public
    procedure InitBlankNonPaletteImage(const ColorType, BitDepth: Cardinal; const cx, cy: Integer);
end;

implementation

{ TRedeemerInheritablePNG }

procedure TRedeemerInheritablePNG.InitBlankNonPaletteImage(const ColorType,
  BitDepth: Cardinal; const cx, cy: Integer);
var
  PHDR: PChunkIHDR2;
  NewIHDR: TChunk;
begin
  // CreateBlank-Methode ohne Create, Überprüfung auf Richtigkeit der Parameter
  // und ohne Unterstützung für Paletten
  InitializeGamma;
  BeingCreated := True;
  Chunks.Add(TChunkIEND);
  NewIHDR := Chunks.Add(TChunkIHDR);
  PHDR := @NewIHDR;
  PHDR^.ColorType := ColorType;
  PHDR^.BitDepth := BitDepth;
  PHDR^.Width := cx;
  PHDR^.Height := cy;
  PHDR^.PrepareImageData;

  Chunks.Add(TChunkIDAT);
  BeingCreated := False;
end;

end.
