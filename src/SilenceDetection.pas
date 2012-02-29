unit SilenceDetection;

interface

uses  Windows, Classes, SysUtils, Contnrs, math,
      bass, AudioFileClass,  Nemp_ConstantsAndTypes;


type
    TSilenceDetector = class
        private
            fWindowHandle: HWND;
            fThread: Integer;

            fChannel: DWord;
            fMaxLevel: Integer;
            fThreshold: Integer;

            fSilenceStart: Double;

            fFilename: String;
            procedure fGetSilenceLength;

            // aDB: 0 ... - 100
            function fGetThreshHoldfromDB(aDB: Integer): Integer;
            function fGetMaxLevel: Integer;

        public
            property SilenceStart: double read fSilenceStart;

            constructor Create(aHandle: HWND; aFilename: String);
            destructor Destroy; override;

            procedure GetSilenceLength(aThreshold: Integer); // aThreshold in DB

    end;

    procedure DoGetSilenceLength(aSilenceDetector: TSilenceDetector);


implementation

procedure DoGetSilenceLength(aSilenceDetector: TSilenceDetector);
begin
    aSilenceDetector.fGetSilenceLength;
end;


{ TSilenceDetector }

constructor TSilenceDetector.Create(aHandle: HWND; aFilename: String);
begin
    fFilename := aFilename;
    fWindowHandle := aHandle;
    fSilenceStart := 0;
    fChannel := BASS_StreamCreateFile(False, PChar(Pointer(fFilename)), 0, 0,
            BASS_STREAM_PRESCAN OR BASS_UNICODE or BASS_STREAM_DECODE);
end;

destructor TSilenceDetector.Destroy;
begin
    BASS_StreamFree(fChannel);
end;

function TSilenceDetector.fGetMaxLevel: Integer;
var a, b: Integer;
    buf: array[0..50000] of Smallint;
begin
    fMaxLevel := 0;
    if fChannel <> 0 then
    begin
        while Bass_ChannelIsActive(fChannel) <> 0 do
        begin
          b := BASS_ChannelGetData(fChannel, @buf, 100000);
          b := b div 2;
          a := 0;
          while (a < b) do
          begin
              if abs(buf[a]) > fMaxLevel then
                  fMaxLevel := abs(buf[a]);
              inc(a);
          end;
        end;
    end;

    result := fMaxLevel;
end;

function TSilenceDetector.fGetThreshHoldfromDB(aDB: Integer): Integer;
begin
    result := Round(fGetMaxLevel * Power(10.0, aDB / 20.0));
end;


procedure TSilenceDetector.GetSilenceLength(aThreshold: Integer);
var Dummy: Cardinal;
begin
    fThreshold := aThreshold;
    fThread := BeginThread(Nil, 0, @DoGetSilenceLength, Self, 0, Dummy)
end;

procedure TSilenceDetector.fGetSilenceLength;
var IntThreshold: Integer;
    a, b: Integer;

    pos, count: DWORD;
    buf: array[0..100000] of Smallint;
begin

    try
        IntThreshold := fGetThreshHoldfromDB(fThreshold);

        count := 0;

        pos := BASS_ChannelGetLength(fChannel, BASS_POS_BYTE);
        while (pos > count) do
        begin
            if pos < 200000 then
                pos := 0
            else
                pos := pos - 200000;
            BASS_ChannelSetPosition(fChannel, pos, BASS_POS_BYTE);
            b := BASS_ChannelGetData(fChannel, @buf, 200000);
            b := b div 2;
            a := b;
            while (a > 0) and (Abs(buf[a - 1]) <= (IntThreshold{ div 2})) do
                a := a - 1;
            if a > 0 then
            begin
                count := pos + (a * 2);
                Break;
            end;
        end;
        fSilenceStart :=  BASS_ChannelBytes2Seconds(fChannel, Count);
        SendMessage(fWindowHandle, WM_PlayerSilenceDetected, wParam(self), 0);

    finally
        self.Free;
    end;
end;



end.
