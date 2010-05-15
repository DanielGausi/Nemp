{

    Unit HtmlHelper

    - some functions dealing with html code and urls

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2010, Daniel Gaussmann
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

    See license.txt for more information

    ---------------------------------------------------------------
}

unit HtmlHelper;

interface

uses Windows, Messages, SysUtils, Variants, Classes,
   StrUtils;


function WordUppercase(s: String): String;
function ReplaceGeneralEntities(s: String): String;
function EscapeHTMLChars(s: String): String;
function StringToURLStringAnd(aUTF8String: UTF8String): AnsiString;


implementation


function WordUppercase(s: String): String;
var
    i: Integer;
    tmp: String;
begin
    s := AnsiLowerCase(s);
    result := s;
    with TStringList.Create do
    try
        Delimiter := ' ';
        DelimitedText := s;
        for i := 0 to Count-1 do
            if (Strings[i] <> '') then
            begin
                tmp := Strings[i];
                tmp[1] := Upcase(tmp[1]);
                Strings[i] := tmp;
            end;
        Delimiter := '_';//#32;
        result := DelimitedText;

    finally
        Free;
    end;
end;


function EscapeHTMLChars(s: String): String;
begin
    result := StringReplace(s, '&', '&amp;', [rfReplaceAll]);
    result := StringReplace(result, '<', '&lt;', [rfReplaceAll]);
    result := StringReplace(result, '>', '&gt;', [rfReplaceAll]);
    result := StringReplace(result, '"', '&quot;', [rfReplaceAll]);
end;


function ReplaceGeneralEntities(s: String): String;
begin
    result := StringReplace(s, '&amp;', '&', [rfReplaceAll]);
    result := StringReplace(result, '&lt;', '<', [rfReplaceAll]);
    result := StringReplace(result, '&gt;', '>', [rfReplaceAll]);
    result := StringReplace(result, '&quot;', '"', [rfReplaceAll]);
    result := StringReplace(result, '&Auml;', '�', [rfReplaceAll]);
    result := StringReplace(result, '&Ouml;', '�', [rfReplaceAll]);
    result := StringReplace(result, '&Uuml;', '�', [rfReplaceAll]);
    result := StringReplace(result, '&auml;', '�', [rfReplaceAll]);
    result := StringReplace(result, '&ouml;', '�', [rfReplaceAll]);
    result := StringReplace(result, '&uuml;', '�', [rfReplaceAll]);
    result := StringReplace(result, '&szlig;','�', [rfReplaceAll]);
    result := StringReplace(result, '&micro;',  '�', [rfReplaceAll]);
    result := StringReplace(result, '&deg;',    '�', [rfReplaceAll]);
    result := StringReplace(result, '&plusmn;', '�', [rfReplaceAll]);
    result := StringReplace(result, '&minus;',  '-', [rfReplaceAll]);
    result := StringReplace(result, '&asymp;',  '�', [rfReplaceAll]);
    result := StringReplace(result, '&sup1;',   '�', [rfReplaceAll]);
    result := StringReplace(result, '&sup2;',   '�', [rfReplaceAll]);
    result := StringReplace(result, '&sup3;',   '�', [rfReplaceAll]);
    result := StringReplace(result, '&frac14;', '�', [rfReplaceAll]);
    result := StringReplace(result, '&frac12;', '�', [rfReplaceAll]);
    result := StringReplace(result, '&frac34;', '�', [rfReplaceAll]);
    result := StringReplace(result, '&Oslash;', '�', [rfReplaceAll]);
    result := StringReplace(result, '&divide;', '�', [rfReplaceAll]);
    result := StringReplace(result, '&oslash;', '�', [rfReplaceAll]);
    result := StringReplace(result, '&permil;', '�', [rfReplaceAll]);
    result := StringReplace(result, '&prime;',  '''', [rfReplaceAll]);
    result := StringReplace(result, '&sect;',  '�', [rfReplaceAll]);
    result := StringReplace(result, '&copy;',  '�', [rfReplaceAll]);
    result := StringReplace(result, '&reg;',   '�', [rfReplaceAll]);
    result := StringReplace(result, '&trade;', '�', [rfReplaceAll]);
    result := StringReplace(result, '&euro;'   ,'�', [rfReplaceAll]);
    result := StringReplace(result, '&eacute;' ,'�', [rfReplaceAll]);
    result := StringReplace(result, '&egrave;' ,'�', [rfReplaceAll]);
    result := StringReplace(result, '&ecirc;'  ,'�', [rfReplaceAll]);
    result := StringReplace(result, '&acirc;'  ,'�', [rfReplaceAll]);
    result := StringReplace(result, '&agrave;' , '�', [rfReplaceAll]);
    result := StringReplace(result, '&aacute;' ,'�', [rfReplaceAll]);
    result := StringReplace(result, '&ucirc;'  ,'�', [rfReplaceAll]);
    result := StringReplace(result, '&uacute;' , '�', [rfReplaceAll]);
    result := StringReplace(result, '&ugrave;' ,'�', [rfReplaceAll]);
    result := StringReplace(result, '&ocirc;'  ,'�', [rfReplaceAll]);
    result := StringReplace(result, '&Eacute;' ,'�', [rfReplaceAll]);
    result := StringReplace(result, '&Egrave;' ,'�', [rfReplaceAll]);
    result := StringReplace(result, '&Ecirc;'  ,'�', [rfReplaceAll]);
    result := StringReplace(result, '&Acirc;'  ,'�', [rfReplaceAll]);
    result := StringReplace(result, '&Agrave;' ,'�', [rfReplaceAll]);
    result := StringReplace(result, '&Aacute;' ,'�', [rfReplaceAll]);
    result := StringReplace(result, '&Ucirc;'  , '�', [rfReplaceAll]);
    result := StringReplace(result, '&Uacute;' ,'�', [rfReplaceAll]);
    result := StringReplace(result, '&Ugrave;' ,'�', [rfReplaceAll]);
    result := StringReplace(result, '&Ocirc;'  ,'�', [rfReplaceAll]);
    result := StringReplace(result, '&iexcl;'  ,'�', [rfReplaceAll]);
    result := StringReplace(result, '&cent;'   , '�', [rfReplaceAll]);
    result := StringReplace(result, '&pound;'  , '�', [rfReplaceAll]);
    result := StringReplace(result, '&curren;' , '�', [rfReplaceAll]);
    result := StringReplace(result, '&yen;'    ,'�', [rfReplaceAll]);
    result := StringReplace(result, '&brvbar;' , '�', [rfReplaceAll]);
    result := StringReplace(result, '&uml;'    , '�', [rfReplaceAll]);
    result := StringReplace(result, '&ordf;'   , '�', [rfReplaceAll]);
    result := StringReplace(result, '&laquo;'  , '�', [rfReplaceAll]);
    result := StringReplace(result, '&not;'    , '�', [rfReplaceAll]);
    result := StringReplace(result, '&shy;'     ,'' , [rfReplaceAll]);
    result := StringReplace(result, '&macr;'   , '�', [rfReplaceAll]);
    result := StringReplace(result, '&acute;'  , '�', [rfReplaceAll]);
    result := StringReplace(result, '&para;'   , '�', [rfReplaceAll]);
    result := StringReplace(result, '&middot;' , '�', [rfReplaceAll]);
    result := StringReplace(result, '&cedil;'  , '�', [rfReplaceAll]);
    result := StringReplace(result, '&raquo;'  ,'�', [rfReplaceAll]);
    result := StringReplace(result, '&iquest;' , '�', [rfReplaceAll]);
    result := StringReplace(result, '&Atilde;' , '�', [rfReplaceAll]);
    result := StringReplace(result, '&Auml;'   , '�', [rfReplaceAll]);
    result := StringReplace(result, '&Aring;'  , '�', [rfReplaceAll]);
    result := StringReplace(result, '&AElig;'  , '�', [rfReplaceAll]);
    result := StringReplace(result, '&Ccedil;' ,'�', [rfReplaceAll]);
    result := StringReplace(result, '&Euml;'   , '�', [rfReplaceAll]);
    result := StringReplace(result, '&Igrave;' , '�', [rfReplaceAll]);
    result := StringReplace(result, '&Iacute;' , '�', [rfReplaceAll]);
    result := StringReplace(result, '&Icirc;'  , '�', [rfReplaceAll]);
    result := StringReplace(result, '&Iuml;'   , '�', [rfReplaceAll]);
    result := StringReplace(result, '&ETH;'    ,'�', [rfReplaceAll]);
    result := StringReplace(result, '&Ntilde;' , '�', [rfReplaceAll]);
    result := StringReplace(result, '&Ograve;' , '�', [rfReplaceAll]);
    result := StringReplace(result, '&Oacute;' , '�', [rfReplaceAll]);
    result := StringReplace(result, '&Otilde;' , '�', [rfReplaceAll]);
    result := StringReplace(result, '&times;'  , '�', [rfReplaceAll]);
    result := StringReplace(result, '&Yacute;' ,'�', [rfReplaceAll]);
    result := StringReplace(result, '&THORN'   , '�', [rfReplaceAll]);
    result := StringReplace(result, '&atilde;' , '�', [rfReplaceAll]);
    result := StringReplace(result, '&aring;'  , '�', [rfReplaceAll]);
    result := StringReplace(result, '&aelig;'  , '�', [rfReplaceAll]);
    result := StringReplace(result, '&ccedil;' , '�', [rfReplaceAll]);
    result := StringReplace(result, '&euml;'   ,'�', [rfReplaceAll]);
    result := StringReplace(result, '&igrave;' , '�', [rfReplaceAll]);
    result := StringReplace(result, '&iacute;' , '�', [rfReplaceAll]);
    result := StringReplace(result, '&icirc;'  , '�', [rfReplaceAll]);
    result := StringReplace(result, '&iuml;'   , '�', [rfReplaceAll]);
    result := StringReplace(result, '&eth;'    , '�', [rfReplaceAll]);
    result := StringReplace(result, '&ntilde;' ,'�', [rfReplaceAll]);
    result := StringReplace(result, '&ograve;' , '�', [rfReplaceAll]);
    result := StringReplace(result, '&oacute;' , '�', [rfReplaceAll]);
    result := StringReplace(result, '&otilde;' , '�', [rfReplaceAll]);
    result := StringReplace(result, '&yacute;' ,'�', [rfReplaceAll]);
    result := StringReplace(result, '&thorn;'  ,'�', [rfReplaceAll]);
    result := StringReplace(result, '&yuml;'   ,'�', [rfReplaceAll]);
    result := StringReplace(result, '&bdquo;'  ,'�', [rfReplaceAll]);
end;


function StringToURLStringAnd(aUTF8String: UTF8String): AnsiString;
var i: integer;
begin
    result := '';
    for i := 1 to length(aUTF8String) do
        result := result + '%'  + AnsiString(IntToHex(Ord(aUTF8String[i]),2));
end;


end.
