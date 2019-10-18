Unit ReplayGain;
(*
 *  ReplayGainAnalysis - analyzes input samples and give the recommended dB change
 *  ------------------------------------------------------------------------------
 *
 *  Copyright (C) 2001 David Robinson and Glen Sawyer
 *  Improvements and optimizations added by Frank Klemm, and by Marcel Müller
 *  Win32 DLL compiled by John Edwards.
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *  License as published by the Free Software Foundation; either
 *  version 2.1 of the License, or (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 *  concept and filter values by David Robinson (David@Robinson.org)
 *    -- blame him if you think the idea is flawed
 *  original coding by Glen Sawyer (mp3gain@hotmail.com)
 *    -- blame him if you think this runs too slowly, or the coding is otherwise flawed
 *
 *  lots of code improvements by Frank Klemm ( http://www.uni-jena.de/~pfk/mpp/ )
 *    -- credit him for all the _good_ programming ;)
 *
 *  For an explanation of the concepts and the basic algorithms involved, go to:
 *    http://www.replaygain.org/
 *
 *
 *
 *  Here's the deal: Call
 *
 *    InitGainAnalysis(SampleFreq);
 *
 *  to initialize everything. Call
 *
 *    AnalyzeSamples(@LeftSamples, @RightSamples, NumSamples, NumChannels);
 *
 *  as many times as you want, with as many or as few samples as you want.
 *  If mono, pass the sample buffer in through left_samples, leave
 *  right_samples NULL, and make sure num_channels = 1.
 *
 *    TrackGain := GetTitleGain()
 *
 *  will return the recommended dB level change for all samples analyzed
 *  SINCE THE LAST TIME you called GetTitleGain() OR InitGainAnalysis().
 *
 *    AlbumGain := GetAlbumGain()
 *
 *  will return the recommended dB level change for all samples analyzed
 *  since InitGainAnalysis() was called and finalized with GetTitleGain().
 *
 *  Pseudo-code to process an album:
 *
 *    const
 *      SampleBufferSize = 4096;
 *
 *    var
 *      LeftSamples  : Array[0..SampleBufferSize-1] of TFloat;
 *      RightSamples : Array[0..SampleBufferSize-1] of TFloat;
 *      NumSamples   : TSize;
 *      NumSongs,i   : Integer;
 *
 *    InitGainAnalysis(44100);
 *    for i:=1 to NumSongs do begin
 *      Repeat
 *        NumSamples := GetSongSamples(Song[i], LeftSamples, RightSamples);
 *        AnalyzeSamples(@LeftSamples, @RightSamples, NumSamples, 2);
 *      until (NumSamples = 0);
 *      Writeln(GetTitleGain);
 *    end;
 *    Writeln(GetAlbumGain);
 *
 *
 *
 *  So here's the main source of potential code confusion:
 *
 *  The filters applied to the incoming samples are IIR filters,
 *  meaning they rely on up to <filter order> number of previous samples
 *  AND up to <filter order> number of previous filtered samples.
 *
 *  I set up the AnalyzeSamples routine to minimize memory usage and interface
 *  complexity. The speed isn't compromised too much (I don't think), but the
 *  internal complexity is higher than it should be for such a relatively
 *  simple routine.
 *
 *  Optimization/clarity suggestions are welcome.
 *
 *  (taken from the original C sources and adapted to Delphi)
 *
 *
 *  DLL-Wrapper by sundance, Nov 10, 2006.
 *  Although this unit was written for Delphi7, it should compile also with
 *  other versions of Delphi (nothing magical done here ;-).
 *)

Interface

Type
  TFloat = Double;            // Float_t
  TSize  = Cardinal;          // size_t

// --- ReplayGain Constants -------------------------------
Const
  INIT_GAIN_ANALYSIS_ERROR = 0;
  INIT_GAIN_ANALYSIS_OK    = 1;
  GAIN_NOT_ENOUGH_SAMPLES  = -24601;
  GAIN_ANALYSIS_ERROR      = 0;
  GAIN_ANALYSIS_OK         = 1;

Const
  ReplayGainDLL = 'dll\replaygain.dll';

(*
  C-Prototypes:
  ---------------------------------------------------------
    int      InitGainAnalysis(long samplefreq);
    int      AnalyzeSamples(const Float_t* left_samples,
                            const Float_t* right_samples,
                            size_t num_samples,
                            int num_channels);
    Float_t  GetTitleGain(void);
    Float_t  GetAlbumGain(void);

  Data Types (Win32):
  ---------------------------------------------------------
    int     = 32 bits signed integer
    long    = 32 bits signed integer
    size_t  = unsigned long
    Float_t = double
*)

// -----------------------------------------------------------------------------
//   Initialize ReplayGain Analysis
// -----------------------------------------------------------------------------
//   SampleFreq : Sampling frequency of the input signal in Hertz
//   returns    : INIT_GAIN_ANALYSIS_OK (success)
//                INIT_GAIN_ANALYSIS_ERROR (error)
//
function InitGainAnalysis(SampleFreq: LongInt): LongInt;
  cdecl;
  external ReplayGainDLL;


// -----------------------------------------------------------------------------
//   Analyze Audio Samples
// -----------------------------------------------------------------------------
//   LeftSamples,
//   RightSamples   : Pointer to an array of TFloat (= double) that hold audio
//                    samples of left/right channels. If the source is mono,
//                    pass all samples to LeftSamples and make sure that
//                    NumChannels = 1.
//   NumSamples     : Number of samples in buffer(s) above
//   NumChannels    : 1 (mono) or 2 (stereo)
//
//   returns        : GAIN_ANALYSIS_OK (success)
//                    GAIN_ANALYSIS_ERROR (error)
//
// If called with NumSamples=0 nothing is done and GAIN_ANALYSIS_OK is returned.
//
function AnalyzeSamples(LeftSamples, RightSamples: Pointer;
                        NumSamples: TSize;
                        NumChannels: LongInt): LongInt;
  cdecl;
  external ReplayGainDLL;


// -----------------------------------------------------------------------------
//   Return ReplayGain_Track
// -----------------------------------------------------------------------------
//   returns        : Track's replay gain value in dB,
//                    i.e. the recommended dB level change for all samples
//                    analyzed SINCE THE LAST TIME GetTitleGain() OR
//                    InitGainAnalysis() was called.
//
function GetTitleGain: TFloat;
  cdecl;
  external ReplayGainDLL;


// -----------------------------------------------------------------------------
//   Return ReplayGain_Album
// -----------------------------------------------------------------------------
//   returns        : Album's replay gain value in dB,
//                    i.e. the recommended dB level change for all samples
//                    analyzed since InitGainAnalysis() was called and finalized
//                    with GetTitleGain()
//
function GetAlbumGain: TFloat;
  cdecl;
  external ReplayGainDLL;


Implementation
End.
