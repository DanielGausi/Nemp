{

    Unit ReplayGainAnalysis

    A wrapper class for the ReplayGain.dll by David Robinson and Glen Sawyer

    ---------------------------------------------------------------
    Copyright (C) 2019, Daniel Gaussmann
    http://www.gausi.de
    mail@gausi.de
    ---------------------------------------------------------------

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

    ---------------------------------------------------------------
}

unit ReplayGainAnalysis;

interface

uses System.Classes, ReplayGain, math, bass;

(*
type

    TReplayGainCalculator = class;



    TReplayGainCalculator = class
    private


        fCurrentIndex: Integer;

        // Event handler (description: see properties)
        fOnStreamInit          : TRGEvent;
        fOnError               : TRGEvent;
        fOnStreamProgress      : TRGProgressEvent;
        fOnSingleTrackComplete : TRGCompleteEvent;
        fOnTrackComplete       : TRGCompleteEvent;
        fOnAlbumComplete       : TRGCompleteEvent;


    public
        property PeakTrack: SmallInt read fPeakTrack;
        property PeakAlbum : SmallInt read fPeakAlbum ;
        property TrackGain: TFloat read fTrackGain;
        property AlbumGain: TFloat read fAlbumGain;

        property AlbumGainCalculationFailed: Boolean read fAlbumGainCalculationFailed;
        property SomeCalculationsDone: Boolean read fSomeCalculationsDone;

        property LastErrorCode: Integer read fLastErrorCode;
        property CurrentIndex: Integer read fCurrentIndex;

        

        // the number of files in the AlbumList for CalculateAlbumGain
        property FileCount : Integer read fFileCount;


        ///  some Events triggered during the GainCalculation
        ///  ------------------------------------------------
        ///  OnStreamInit: After creation of a Stream by the BASS.dll
        ///                ErrorCode: 0 if everything is fine,
        ///                           one of the constants used by BASS_ErrorGetCode
        ///  OnError:      (a) The Stream does not match the requirements to be analyses
        ///                    Errorcode contains one of the RG_ERR_** constants defined in this Unit
        ///                (b) Reading sampledata from the stream fails
        ///                    ErrorCode: BASS_ErrorGetCode
        ///                    (Note: BASS_ERROR_ENDED is possible, but that should not be considered as an actual error)
        ///  OnStreamProgress      : Progress of the calculation of the current Title, ranged from 0 to 1
        ///  OnSingleTrackComplete : The TrackGain calculation of a single track has been comleted
        ///  OnTrackComplete       : The TrackGain calculation of one Track during the calculation
        ///                          of the AlbumGain for a list of tracks has been completed
        ///  OnAlbumComplete       : The calculation of AlbumGain has been completed.
        ///                          Note: This is also triggered, when the calculation has been aborted.

        property OnStreamInit          : TRGEvent read fOnStreamInit write fOnStreamInit;
        property OnError               : TRGEvent read fOnError write fOnError;
        property OnStreamProgress      : TRGProgressEvent read fOnStreamProgress write fOnStreamProgress;
        property OnSingleTrackComplete : TRGCompleteEvent read fOnSingleTrackComplete write fOnSingleTrackComplete;
        property OnTrackComplete       : TRGCompleteEvent read fOnTrackComplete write fOnTrackComplete;
        property OnAlbumComplete       : TRGCompleteEvent read fOnAlbumComplete write fOnAlbumComplete;

        constructor create;
        destructor Destroy; Override;
    end;

*)


implementation


(*
{ TReplayGainCalculator }

constructor TReplayGainCalculator.create;
begin
    inherited create;
end;

destructor TReplayGainCalculator.Destroy;
begin
    // free an existing stream, if necessary


    inherited;
end;

*)





end.
