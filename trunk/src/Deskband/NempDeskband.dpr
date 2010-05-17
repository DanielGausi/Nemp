{*******************************************************}
{                                                       }
{                    Nemp Deskband                      }
{                                                       }
{       Copyright (c) 2007, Daniel Gau�mann             }
{                  www.gausi.de                         }
{                                                       }
{*******************************************************}

{
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following condition
is met:

Redistributions of source code must retain the above
copyright notice, this list of conditions and the following disclaimer.
  
THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS
�AS IS� AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
}

library NempDeskband;

uses
  ComServ,
  DeskBar_TLB in 'DeskBar_TLB.pas',
  unitNempDeskBand in 'unitNempDeskBand.pas',
  FormMainBand in 'FormMainBand.pas' {FormMainBand},
  VolumeUnit in 'VolumeUnit.pas' {Form1},
  InfoUnit in 'InfoUnit.pas' {InfoForm},
  SearchUnit in 'SearchUnit.pas' {SuchForm},
  TaskbarStuff in 'TaskbarStuff.pas',
  PlaylistUnit in 'PlaylistUnit.pas' {PlaylistForm};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
