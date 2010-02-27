{

    Unit StringSearchHelper

    Implements some String-search, that is much faster than Pos and allows
    approximate searching (i.e. allowing errors).

    Note: The String-Search methods here are a little tricky.
          I've written a diploma thesis (in german) about this stuff.
          If you are interested in details about Boyer-Moore-Horspool
          or Filter-Algorithms for approximate search, search the web
          for the original papers or ask me. ;-)

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2009, Daniel Gaussmann
    http://www.gausi.de
    mail@gausi.de
    ---------------------------------------------------------------
    This program is free software; you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by the
    Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful, but
    WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
    for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin St, Fifth Floor, Boston, MA 02110, USA

    Additional permissions

    If you modify this Program, or any covered work, by linking or combining it
    with
        - the bass.dll and it addons
          (including, but not limited to the bass_fx.dll)
        - MadExcept
        - DGL-OpenGL
        - FSPro Windows 7 Taskbar Components
    or a modified version of these libraries, the licensors of this Program
    grant you additional permission to convey the resulting work.

    ---------------------------------------------------------------
}

unit StringSearchHelper;

interface

uses
  Windows, Messages, SysUtils, Classes, math;

type


  TBC_IntArray = Array[Char] of Integer;
  TIntArray = Array of Integer;


// Get the longest UTF8-Encoded String (from a UTF16-encoded Stringlist)
function GetLongestUTF8String(aStringList: TStringList): UTF8String;

// BinIntSearch: Used to get the Index of the AudioFile, which String-Information
// is on Position aValue in the "TotalString"
function BinIntSearch(aArray: TIntArray; aValue: Integer; l,r:integer):integer;

// PreProcessing for the Boyer-Moore-Horspool-Algorithm
function PreProcess_BMH_BC(p: UTF8String): TBC_IntArray;
// The Boyer-Moore-Horspool Algorithm (Ex like in PosEx)
function BoyerMooreHorspoolEx(var t, p: UTF8String; Offset: Integer; var BC: TBC_IntArray): Integer;

// Preprocessing for SearchFilterCountDP
function PreProcess_FilterCount(p: UTF8String): TBC_IntArray;
// Approximate Searching with simple Char-Filter
// used for the "accelerated" search in the "totalString"
function SearchFilterCountDP(t, p: UTF8String; maxError: Integer; Offset: Integer; var A: TBC_IntArray): Integer;

// Computing the Levenshtein-Distance (not used)
function ApproxDistance(const AText, AOther: UTF8String): Integer;
// Approsimate Searching without filter
// used in the verification of every audiofile
// filtering doesnt make really sense there
function SearchDP(t, p: UTF8String; MaxError: Integer): Integer;


implementation


function GetLongestUTF8String(aStringList: TStringList): UTF8String;
var lmax, i: Integer;
begin
  if (aStringList.Count = 1) then
    result := UTF8Encode(AnsiLowerCase(aStringList[0]))
  else
  begin
    lmax := 0;
    result := '';
    for i := 0 to aStringList.Count - 1 do
        if length(aStringList[i]) > lmax then
        begin
            lmax := length(aStringList[i]);
            result := UTF8Encode(AnsiLowerCase(aStringList[i]));
        end;
  end;
end;

function BinIntSearch(aArray: TIntArray; aValue: Integer; l,r:integer):integer;
var m, mValue: integer;
    c:integer;
begin
    if r < l then
    begin
        result := r; //-1;
    end else
    begin
        m := (l + r) DIV 2;
        mValue := aArray[m];
        c := CompareValue(aValue, mValue);
        if l = r then
            // Suche endet. l Zurückgeben - Egal ob das an der Stelle stimmt oder nicht
            result := l
        else
        begin
            if  c = 0 then
                result := m
            else if c > 0 then
                result := BinIntSearch(aArray, aValue, m+1, r)
                else
                    result := BinIntSearch(aArray, aValue, l, m-1);
        end;
    end;
end;


{
    --------------------------------------------------------
    PreProcess_BMH_BC
    - Preprocessing for Boyer-Moore-Horspool
      Main idea: Check, where the letters from the alphabet
           occur in the pattern. These values are used by the
           main algorithm for longer shifts of the pattern.
           So the runtime of BMH is less (!) than O(n), if n
           is the number of chars in the text to be searched.
      Note: This method is faster, when the pattern is longer,
           therefore I identify the longest keyword first. ;-)
    --------------------------------------------------------
}
function PreProcess_BMH_BC(p: UTF8String): TBC_IntArray;
var i, m: Integer;
    c: Char;
begin
  m := Length(p);
  for c := low(Char) to High(Char) do
    result[c] := m;
  for i := 1 to m-1 do     // !! m-1 !!
    result[p[i]] := m-i;
end;

{
    --------------------------------------------------------
    BoyerMooreHorspoolEx
    - Boyer-Moore-Horspool algorithm, which is (almost) a simplified
      Boyer-Moore-Search, i.e. BM without the "Good-Suffix-Rule"
    See
        R.N.Horspool: Practical fast searching in Strings
        Software - Practice and Experience, 1980
    --------------------------------------------------------
}
function BoyerMooreHorspoolEx(var t, p: UTF8String; Offset: Integer; var BC: TBC_IntArray): Integer;
var n, m, k, j, BC_Last, Large: Integer;
begin
        result := 0;
        n := Length(t);
        m := length(p);
        Large := m + n + 1;

        // "echten" BC-Shift merken
        BC_Last := BC[p[m]];
        // BC(lastCh) mit "Large" überschreiben
        BC[p[m]] := Large;

        k := m + Offset;
        while k <= n do
        begin
            //fast loop
            repeat
              k := k + BC[t[k]];
            until k > n;

            //undo
            if k <= Large then
              break         //Muster nicht gefunden
            else
              k := k - Large;

            j := 1;
            // slow loop
            while (j < m) and (p[m-j] = t[k-j]) do
              inc(j);

            if j = m then
            begin
              result := k-j+1;  // Muster gefunden
              break;
            end
            else
            begin
                // Muster verschieben
                if t[k] = p[m] then
                  k := k + BC_last
                else
                  k := k + BC[t[k]];
            end;
        end;
        // Wert zurücksetzen
        BC[p[m]] := BC_Last;
end;

function min3(a,b,c: Integer): Integer;
begin
    result := a;
    if b < result then result := b;
    if c < result then result := c;
end;

{
    --------------------------------------------------------
    PreProcess_FilterCount
    - Preprocessing for SearchFilterCountDP
      Main idea: Count which chars occur how often in the pattern.
         On main algorithm the number of chars within the current
         searchwindow are compared with the result from the
         preprocessing, and only if the numbers matches, a
         (slow/expensive) Levenshtein-distance is done to
         verify the approximate match.
      This is (in general) faster then computing Levenshtein
      every time.
    --------------------------------------------------------
}
function PreProcess_FilterCount(p: UTF8String): TBC_IntArray;
var c: Char;
    m, i: Integer;
begin
    m := Length(p);
    for c := Low(Char) to High(Char) do
        Result[c] := 0;
    for i := 1 to m do
        result[p[i]] := result[p[i]] + 1;
end;

{
    --------------------------------------------------------
    SearchFilterCountDP
    - Approximate Search using "Char counting" as filter
      and Dynamic Programming (levenshtein) for verification
    See
        G.Navarro: Multiple approximate string matching by counting.
        Proceedings of the 4th South American Workshop on String Processing
        (WSP'97), 1997
    --------------------------------------------------------
}
function SearchFilterCountDP(t, p: UTF8String; maxError: Integer; Offset: Integer; var A: TBC_IntArray): Integer;
var n, m, IdxT, count, ib: Integer;
    GoOn: Boolean;
    lact, pC, nC, LastStop: Integer;
    C: Array of Integer;

    function Check(Start, Ende: Integer): Boolean;
    var i, IdxTCheck, s: Integer;
    begin
            result := False;
            if Start > LastStop then
            begin
                // Neue Suche initialisieren
                for i := 0 to m do C[i] := i;
                lact := maxError + 1;
                s := start;
            end else
                s := LastStop + 1;
            // (Weiter-)Suchen
            for IdxTCheck := s to Ende do
            begin
                pC := 0;
                nC := 0;
                for i := 1 to lact do
                begin
                    if p[i] = t[IdxTCheck] then
                      nC := pC
                    else
                      nC := 1 + min3(nC, pC, C[i]);
                    pC := C[i];
                    C[i] := nC;
                end;
                // nächste letzte aktive Zelle suchen
                while C[lact] > maxError do dec(lact);

                if lact = m then
                begin
                    //if result = 0 then result := IdxTCheck;
                    //if assigned(Trefferlist) then
                    //          Trefferlist.Add(TApproxTreffer.Create(IdxTCheck, C[lact]));
                    result := True;
                    break;

                end else
                  inc(lact);
            end;
            LastStop := Ende;
    end;
begin
  n := length(t);
  m := length(p);

  result := 0;

  // Vorbereitung
  // A := PreProcess_FilterCount(p);
  setlength(C, m+1); //(Für die Überprüfung)
  LastStop := -1;
  Count := 0;
  GoOn := True;

  // Suchphase
  // Initiales Suchfenster füllen
  for IdxT := Offset + 1 to Offset + m do
  begin
      if A[t[IdxT]] > 0 then inc(Count);
      A[t[IdxT]] := A[t[IdxT]] - 1;
  end;

  //----------------------
  If Count >= m - maxError then   // Überprüfung starten
  begin
      if Check(Offset + 1, Offset + m) then
      begin
          // Muster gefunden. Array A zurücksetzen und nicht weitermachen
          GoOn := False;
          for iB := Offset + 1 to Offset + m do
              A[t[ib]] := A[t[ib]] + 1;
          result := Offset + m;
      end;
  end;

  if GoOn then
      // Rest des Textes durchlaufen
      For IdxT := Offset + m+1 to n do
      begin
          if A[t[IdxT-m]] >= 0 then dec(Count);
          A[t[IdxT-m]] := A[t[IdxT-m]] + 1;
          if A[t[IdxT]] > 0 then inc(Count);
          A[t[IdxT]] := A[t[IdxT]] - 1;

          If Count >= m - maxError then  // Überprüfung starten/fortsetzen
          begin
              if Check(IdxT-m+1, IdxT) then
              begin
                  for iB := IdxT-m+1 to IdxT do
                      A[t[ib]] := A[t[ib]] + 1;
                  result := IdxT;
                  GoOn := False;
                  break;
              end;
          end;
      end;
      if GoOn then
      begin
          // A aufräumen, damit es auch bei einer nicht erfolgreichen Suche weiterverwendet werden kann
          for iB := n - m+1 to n do
              A[t[ib]] := A[t[ib]] + 1;
      end;
end;

{
    --------------------------------------------------------
    ApproxDistance
    - compute the Levenshtein-distance of the two strings.
      The Levenshtein-Distance is the minimum number of the following
      operations to convert the one string into the other
        * Delete a character
        * Insert a character
        * Replace a character
    --------------------------------------------------------
}
function ApproxDistance(const AText, AOther: UTF8String): Integer;
var i, im, n, m: Integer;
    C: Array of Integer;
    pC, nC: Integer;
begin
  n := length(AText);
  m := length(AOther);

//try
  if m = 0 then
    result := 0 // Achtung - Sonderfall für Nemp: Das leere Otherwort ist erlaubt und ergibt 0 als Distanz!
  else begin
      setlength(C, m+1);
      for i := 0 to m do C[i] := i;

      for i := 1 to n do
      begin
          pC := i-1;
          nC := i;
          for im  := 1 to m do
          begin
              if AText[i] = AOther[im] then
                nC := pC
              else
                nC := 1 + min3(nC, pC, C[im]);
              pC := C[im];
              C[im] := nC;
          end;
      end;
      result := C[m];
  end;
//except
//showmessage('Error on ApproxDistance');
//end;
end;

{
    --------------------------------------------------------
    SearchDP
    - search a pattern in a text allowing MaxError errors
      (an error is one levenshtein-operation)
    Note: a little trick is used to reduce the runtime from
    O(nm) to O(nk), n = length(t), m = length(p), k = MaxError
    See
        W.I.Chang, J.Lampe: Theoretical and empirical comparisions
              of approximate string matching algorithms
        In: Proceedings of the 3rd annual symposium on combinatorical
            pattern matching, number 664,
            in "Lecture Notes in Computer Science", pages 175-184, 1992
    --------------------------------------------------------
}
function SearchDP(t, p: UTF8String; MaxError: Integer): Integer;
var m, n, lact, i, IdxT, pC, nC: Integer;
    C: Array of Integer;
begin
  n := length(t);
  m := length(p);
  // max. erlaubte Fehlerzahl
  // Initialisierung
  setlength(C, m+1);
  for i := 0 to m do C[i] := i;

  //lact := MaxError + 1;

  lact := min(m, MaxError + 1);

//  if n = 0 then
//    result := 1
//  else

    result := 0;

  // Suchen
  for IdxT := 1 to n do
  begin
      pC := 0;
      nC := 0;
      for i := 1 to lact do
      begin
          if p[i] = t[IdxT] then
            nC := pC
          else
            nC := 1 + min3(nC, pC, C[i]);
          pC := C[i];
          C[i] := nC;
      end;
      // nächste letzte aktive Zelle suchen
      while C[lact] > MaxError do dec(lact);

      if lact = m then
      begin
          result := IdxT;
          break;
      end else
        inc(lact);
  end;
end;



end.
