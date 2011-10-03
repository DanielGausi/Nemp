{=============================================================================
  BASS_FX 2.4 - Copyright (c) 2002-2008 (: JOBnik! :) [Arthur Aminov, ISRAEL]
                                                      [http://www.jobnik.org]

         bugs/suggestions/questions:
           forum  : http://www.un4seen.com/forum/?board=1
                    http://www.jobnik.org/smforum
           e-mail : bass_fx@jobnik.org
        --------------------------------------------------

  BASS_FX unit is based on BASS_FX 1.1 unit:
  ------------------------------------------
  (c) 2002 Roger Johansson. w1dg3r@yahoo.com

  NOTE: This unit will only work with BASS_FX version 2.4
        Check www.un4seen.com or www.jobnik.org for any later versions.

  * Requires BASS 2.4 (available @ www.un4seen.com)

  How to install:
  ---------------
  Copy BASS_FX.PAS & BASS.PAS to the \LIB subdirectory of your Delphi path
  or your project dir.
=============================================================================}

unit BASS_FX;

interface

uses BASS;

const
  // Error codes returned by BASS_ErrorGetCode()
  BASS_ERROR_FX_NODECODE = 4000;    // Not a decoding channel
  BASS_ERROR_FX_BPMINUSE = 4001;    // BPM/Beat detection is in use

  // Tempo / Reverse / BPM / Beat flag
  BASS_FX_FREESOURCE = $10000;      // Free the source handle as well?

// BASS_FX Version
function BASS_FX_GetVersion(): DWORD; stdcall; external 'bass_fx.dll' name 'BASS_FX_GetVersion';

{=============================================================================================
        D S P (Digital Signal Processing)
==============================================================================================}

{
    Multi-channel order of each channel is as follows:
     3 channels       left-front, right-front, center.
     4 channels       left-front, right-front, left-rear/side, right-rear/side.
     6 channels (5.1) left-front, right-front, center, LFE, left-rear/side, right-rear/side.
     8 channels (7.1) left-front, right-front, center, LFE, left-rear/side, right-rear/side, left-rear center, right-rear center.
}

const
  // DSP channels flags
  BASS_BFX_CHANALL  = -1;       // all channels at once (as by default)
  BASS_BFX_CHANNONE = 0;        // disable an effect for all channels
  BASS_BFX_CHAN1    = 1;        // left-front channel
  BASS_BFX_CHAN2    = 2;        // right-front channel
  BASS_BFX_CHAN3    = 4;        // see above info
  BASS_BFX_CHAN4    = 8;        // see above info
  BASS_BFX_CHAN5    = 16;       // see above info
  BASS_BFX_CHAN6    = 32;       // see above info
  BASS_BFX_CHAN7    = 64;       // see above info
  BASS_BFX_CHAN8    = 128;      // see above info

// If you have more than 8 channels, use this macro
//XX//  function BASS_BFX_CHANNEL_N(n: DWORD): DWORD;

// DSP effects
const
  BASS_FX_BFX_ROTATE     = $10000;    // A channels volume ping-pong  / stereo
  BASS_FX_BFX_ECHO       = $10001;    // Echo                         / 2 channels max
  BASS_FX_BFX_FLANGER    = $10002;    // Flanger                      / multi channel
  BASS_FX_BFX_VOLUME     = $10003;    // Volume                       / multi channel
  BASS_FX_BFX_PEAKEQ     = $10004;    // Peaking Equalizer            / multi channel
  BASS_FX_BFX_REVERB     = $10005;    // Reverb                       / 2 channels max
  BASS_FX_BFX_LPF        = $10006;    // Low Pass Filter              / multi channel
  BASS_FX_BFX_MIX        = $10007;    // Swap, remap and mix channels / multi channel
  BASS_FX_BFX_DAMP       = $10008;    // Dynamic Amplification        / multi channel
  BASS_FX_BFX_AUTOWAH    = $10009;    // Auto WAH                     / multi channel
  BASS_FX_BFX_ECHO2      = $1000A;    // Echo 2                       / multi channel
  BASS_FX_BFX_PHASER     = $1000B;    // Phaser                       / multi channel
  BASS_FX_BFX_ECHO3      = $1000C;    // Echo 3                       / multi channel
  BASS_FX_BFX_CHORUS     = $1000D;    // Chorus                       / multi channel
  BASS_FX_BFX_APF        = $1000E;    // All Pass Filter              / multi channel
  BASS_FX_BFX_COMPRESSOR = $1000F;    // Compressor                   / multi channel
  BASS_FX_BFX_DISTORTION = $10010;    // Distortion                   / multi channel

type
// Echo
    BASS_BFX_ECHO = record
        fLevel : FLOAT;              // [0....1....n] linear
        lDelay : Integer;            // [1200..30000]
    end;

// Flanger
    BASS_BFX_FLANGER = record
        fWetDry : FLOAT;             // [0....1....n] linear
        fSpeed : FLOAT;              // [0......0.09]
        lChannel : Integer;          // BASS_BFX_CHANxxx flag/s
    end;

// Volume
    BASS_BFX_VOLUME = record
        lChannel : Integer;          // BASS_BFX_CHANxxx flag/s or 0 for global volume control
        fVolume : FLOAT;             // [0....1....n] linear
    end;

// Peaking Equalizer
    BASS_BFX_PEAKEQ = record
        lBand : Integer;             // [0...............n] more bands means more memory & cpu usage
        fBandwidth : FLOAT;          // [0.1.....4.......n] in octaves - Q is not in use (BW has a priority over Q)
        fQ : FLOAT;                  // [0.......1.......n] the EE kinda definition (linear) (if Bandwidth is not in use)
        fCenter : FLOAT;             // [1Hz..<info.freq/2] in Hz
        fGain : FLOAT;               // [-15dB...0...+15dB] in dB
        lChannel : Integer;          // BASS_BFX_CHANxxx flag/s
    end;

// Reverb
    BASS_BFX_REVERB = record
        fLevel : FLOAT;              // [0....1....n] linear
        lDelay : Integer;            // [1200..10000]
    end;

// Low Pass Filter
    BASS_BFX_LPF = record
        fResonance : FLOAT;          // [0.01............10]
        fCutOffFreq : FLOAT;         // [1Hz....info.freq/2] cutoff frequency
        lChannel : Integer;          // BASS_BFX_CHANxxx flag/s
    end;

// Swap, remap and mix
    PTlChannel = ^TlChannel;
    TlChannel = array[0..maxInt div sizeOf(DWORD) - 1] of DWORD;
    BASS_BFX_MIX = record
        lChannel : PTlChannel;       // a pointer to an array of channels to mix using BASS_BFX_CHANxxx flag/s (lChannel[0] is left channel...)
    end;

// Dynamic Amplification
    BASS_BFX_DAMP = record
        fTarget : FLOAT;             // target volume level                      [0<......1] linear
        fQuiet : FLOAT;              // quiet  volume level                      [0.......1] linear
        fRate : FLOAT;               // amp adjustment rate                      [0.......1] linear
        fGain : FLOAT;               // amplification level                      [0...1...n] linear
        fDelay : FLOAT;              // delay in seconds before increasing level [0.......n] linear
        lChannel : Integer;          // BASS_BFX_CHANxxx flag/s
    end;

// Auto WAH
    BASS_BFX_AUTOWAH = record
        fDryMix : FLOAT;             // dry (unaffected) signal mix              [-2......2]
        fWetMix : FLOAT;             // wet (affected) signal mix                [-2......2]
        fFeedback : FLOAT;           // feedback                                 [-1......1]
        fRate : FLOAT;               // rate of sweep in cycles per second       [0<....<10]
        fRange : FLOAT;              // sweep range in octaves                   [0<....<10]
        fFreq : FLOAT;               // base frequency of sweep Hz               [0<...1000]
        lChannel : Integer;          // BASS_BFX_CHANxxx flag/s
    end;

// Echo 2
    BASS_BFX_ECHO2 = record
        fDryMix : FLOAT;             // dry (unaffected) signal mix              [-2......2]
        fWetMix : FLOAT;             // wet (affected) signal mix                [-2......2]
        fFeedback : FLOAT;           // feedback                                 [-1......1]
        fDelay : FLOAT;              // delay sec                                [0<......6]
        lChannel : Integer;          // BASS_BFX_CHANxxx flag/s
    end;

// Phaser
    BASS_BFX_PHASER = record
        fDryMix : FLOAT;             // dry (unaffected) signal mix              [-2......2]
        fWetMix : FLOAT;             // wet (affected) signal mix                [-2......2]
        fFeedback : FLOAT;           // feedback                                 [-1......1]
        fRate : FLOAT;               // rate of sweep in cycles per second       [0<....<10]
        fRange : FLOAT;              // sweep range in octaves                   [0<....<10]
        fFreq : FLOAT;               // base frequency of sweep                  [0<...1000]
        lChannel : Integer;          // BASS_BFX_CHANxxx flag/s
    end;

// Echo 3
    BASS_BFX_ECHO3 = record
        fDryMix : FLOAT;             // dry (unaffected) signal mix              [-2......2]
        fWetMix : FLOAT;             // wet (affected) signal mix                [-2......2]
        fDelay : FLOAT;              // delay sec                                [0<......6]
        lChannel : Integer;          // BASS_BFX_CHANxxx flag/s
    end;

// Chorus
    BASS_BFX_CHORUS = record
        fDryMix : FLOAT;             // dry (unaffected) signal mix              [-2......2]
        fWetMix : FLOAT;             // wet (affected) signal mix                [-2......2]
        fFeedback : FLOAT;           // feedback                                 [-1......1]
        fMinSweep : FLOAT;           // minimal delay ms                         [0<..<6000]
        fMaxSweep : FLOAT;           // maximum delay ms                         [0<..<6000]
        fRate : FLOAT;               // rate ms/s                                [0<...1000]
        lChannel : Integer;          // BASS_BFX_CHANxxx flag/s
    end;

// All Pass Filter
    BASS_BFX_APF = record
        fGain : FLOAT;               // reverberation time                       [-1=<..<=1]
        fDelay : FLOAT;              // delay sec                                [0<....<=6]
        lChannel : Integer;          // BASS_BFX_CHANxxx flag/s
    end;

// Compressor
    BASS_BFX_COMPRESSOR = record
        fThreshold : FLOAT;          // compressor threshold                     [0<=...<=1]
        fAttacktime : FLOAT;         // attack time ms                           [0<.<=1000]
        fReleasetime : FLOAT;        // release time ms                          [0<.<=5000]
        lChannel : Integer;          // BASS_BFX_CHANxxx flag/s
    end;

// Distortion
    BASS_BFX_DISTORTION = record
        fDrive : FLOAT;              // distortion drive                         [0<=...<=5]
        fDryMix : FLOAT;             // dry (unaffected) signal mix              [-5<=..<=5]
        fWetMix : FLOAT;             // wet (affected) signal mix                [-5<=..<=5]
        fFeedback : FLOAT;           // feedback                                 [-1<=..<=1]
        fVolume : FLOAT;             // distortion volume                        [0=<...<=2]
        lChannel : Integer;          // BASS_BFX_CHANxxx flag/s
    end;

{=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	set dsp fx - BASS_ChannelSetFX
 ============================================================================================
	remove dsp fx - BASS_ChannelRemoveFX
 ============================================================================================
	set parameters - BASS_FXSetParameters
 ============================================================================================
	retrieve parameters - BASS_FXGetParameters
 ============================================================================================
	reset the state - BASS_FXReset
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=}

{=============================================================================================
        TEMPO / PITCH SCALING / SAMPLERATE
==============================================================================================}

// NOTES: 1. Supported ONLY - mono / stereo - channels
//        2. Enable Tempo supported flags in BASS_FX_TempoCreate and the others to source handle.

const
  // tempo attributes (BASS_ChannelSet/GetAttribute)
  BASS_ATTRIB_TEMPO       = $10000;
  BASS_ATTRIB_TEMPO_PITCH = $10001;
  BASS_ATTRIB_TEMPO_FREQ  = $10002;

  // tempo attributes options
  //         [option]                                         [value]
  BASS_ATTRIB_TEMPO_OPTION_USE_AA_FILTER    = $10010;    // TRUE / FALSE
  BASS_ATTRIB_TEMPO_OPTION_AA_FILTER_LENGTH = $10011;    // 32 default (8 .. 128 taps)
  BASS_ATTRIB_TEMPO_OPTION_USE_QUICKALGO    = $10012;    // TRUE / FALSE
  BASS_ATTRIB_TEMPO_OPTION_SEQUENCE_MS      = $10013;    // 82 default
  BASS_ATTRIB_TEMPO_OPTION_SEEKWINDOW_MS    = $10014;    // 14 default
  BASS_ATTRIB_TEMPO_OPTION_OVERLAP_MS       = $10015;    // 12 default

function BASS_FX_TempoCreate(chan, flags: DWORD): HSTREAM; stdcall; external 'bass_fx.dll' name 'BASS_FX_TempoCreate';
//XX//  function BASS_FX_TempoGetSource(chan: HSTREAM): DWORD; stdcall; external 'bass_fx.dll' name 'BASS_FX_TempoGetSource';
//XX//  function BASS_FX_TempoGetRateRatio(chan: HSTREAM): FLOAT; stdcall; external 'bass_fx.dll' name 'BASS_FX_TempoGetRateRatio';

{=============================================================================================
        R E V E R S E
==============================================================================================}

// NOTES: 1. MODs won't load without BASS_MUSIC_PRESCAN flag.
//        2. Enable Reverse supported flags in BASS_FX_ReverseCreate and the others to source handle.

const
  // reverse attribute (BASS_ChannelSet/GetAttribute)
  BASS_ATTRIB_REVERSE_DIR = $11000;

  // playback directions
  BASS_FX_RVS_REVERSE = -1;
  BASS_FX_RVS_FORWARD = 1;

function BASS_FX_ReverseCreate(chan: HSTREAM; dec_block: FLOAT; flags: DWORD): HSTREAM; stdcall; external 'bass_fx.dll' name 'BASS_FX_ReverseCreate';
//XX//  function BASS_FX_ReverseGetSource(chan: HSTREAM): HSTREAM; stdcall; external 'bass_fx.dll' name 'BASS_FX_ReverseGetSource';

{=============================================================================================
        B P M (Beats Per Minute)
=============================================================================================}

// NOTE: Supported only mono or stereo channels.

const
  // bpm flags
  BASS_FX_BPM_BKGRND = 1;   // if in use, then you can do other processing while detection's in progress. (BPM/Beat)
  BASS_FX_BPM_MULT2  = 2;   // if in use, then will auto multiply bpm by 2 (if BPM < MinBPM*2)

  // translation options
  BASS_FX_BPM_TRAN_X2       = 0;     // multiply the original BPM value by 2 (may be called only once & will change the original BPM as well!)
  BASS_FX_BPM_TRAN_2FREQ    = 1;     // BPM value to Frequency
  BASS_FX_BPM_TRAN_FREQ2    = 2;     // Frequency to BPM value
  BASS_FX_BPM_TRAN_2PERCENT = 3;     // BPM value to Percents
  BASS_FX_BPM_TRAN_PERCENT2 = 4;     // Percents to BPM value

//XX//type BPMPROCESSPROC = procedure(chan: DWORD; percent: FLOAT); stdcall;
//XX//type BPMPROC = procedure(handle: DWORD; bpm: FLOAT; user: DWORD); stdcall;

//XX//function BASS_FX_BPM_DecodeGet(chan: DWORD; startSec, endSec: DOUBLE; minMaxBPM, flags: DWORD; proc: BPMPROCESSPROC): FLOAT; stdcall; external 'bass_fx.dll' name 'BASS_FX_BPM_DecodeGet';
//XX//function BASS_FX_BPM_CallbackSet(handle: DWORD; proc: BPMPROC; period: DOUBLE; minMaxBPM, flags, user: DWORD): BOOL; stdcall; external 'bass_fx.dll' name 'BASS_FX_BPM_CallbackSet';
//XX//function BASS_FX_BPM_CallbackReset(handle: DWORD): BOOL; stdcall; external 'bass_fx.dll' name 'BASS_FX_BPM_CallbackReset';
//XX//function BASS_FX_BPM_Translate(handle: DWORD; val2tran: FLOAT; trans: DWORD): FLOAT; stdcall; external 'bass_fx.dll' name 'BASS_FX_BPM_Translate';
//XX//function BASS_FX_BPM_Free(handle: DWORD): BOOL; stdcall; external 'bass_fx.dll' name 'BASS_FX_BPM_Free';

{=============================================================================================
        B E A T
=============================================================================================}

//XX//type BPMBEATPROC = procedure(handle: DWORD; beatpos: DOUBLE; user: DWORD); stdcall;

//XX//function BASS_FX_BPM_BeatCallbackSet(handle: DWORD; proc: BPMBEATPROC; user: DWORD): BOOL; stdcall; external 'bass_fx.dll' name 'BASS_FX_BPM_BeatCallbackSet';
//XX//function BASS_FX_BPM_BeatCallbackReset(handle: DWORD): BOOL; stdcall; external 'bass_fx.dll' name 'BASS_FX_BPM_BeatCallbackReset';
//XX//function BASS_FX_BPM_BeatDecodeGet(chan: DWORD; startSec, endSec: DOUBLE; flags: DWORD; proc: BPMBEATPROC; user: DWORD): BOOL; stdcall; external 'bass_fx.dll' name 'BASS_FX_BPM_BeatDecodeGet';
//XX//function BASS_FX_BPM_BeatSetParameters(handle: DWORD; bandwidth, centerfreq, beat_rtime: FLOAT): BOOL; stdcall; external 'bass_fx.dll' name 'BASS_FX_BPM_BeatSetParameters';
//XX//function BASS_FX_BPM_BeatGetParameters(handle: DWORD; var bandwidth, centerfreq, beat_rtime: FLOAT): BOOL; stdcall; external 'bass_fx.dll' name 'BASS_FX_BPM_BeatGetParameters';
//XX//function BASS_FX_BPM_BeatFree(handle: DWORD): BOOL; stdcall; external 'bass_fx.dll' name 'BASS_FX_BPM_BeatFree';

implementation

function BASS_BFX_CHANNEL_N(n: DWORD): DWORD;
begin
  Result := 1 shl (n-1);
end;

end.
