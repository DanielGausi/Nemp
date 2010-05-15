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
    result := StringReplace(result, '&Auml;', 'Ä', [rfReplaceAll]);
    result := StringReplace(result, '&Ouml;', 'Ö', [rfReplaceAll]);
    result := StringReplace(result, '&Uuml;', 'Ü', [rfReplaceAll]);
    result := StringReplace(result, '&auml;', 'ä', [rfReplaceAll]);
    result := StringReplace(result, '&ouml;', 'ö', [rfReplaceAll]);
    result := StringReplace(result, '&uuml;', 'ü', [rfReplaceAll]);
    result := StringReplace(result, '&szlig;','ß', [rfReplaceAll]);
    result := StringReplace(result, '&micro;',  'µ', [rfReplaceAll]);
    result := StringReplace(result, '&deg;',    '°', [rfReplaceAll]);
    result := StringReplace(result, '&plusmn;', '±', [rfReplaceAll]);
    result := StringReplace(result, '&minus;',  '-', [rfReplaceAll]);
    result := StringReplace(result, '&asymp;',  '˜', [rfReplaceAll]);
    result := StringReplace(result, '&sup1;',   '¹', [rfReplaceAll]);
    result := StringReplace(result, '&sup2;',   '²', [rfReplaceAll]);
    result := StringReplace(result, '&sup3;',   '³', [rfReplaceAll]);
    result := StringReplace(result, '&frac14;', '¼', [rfReplaceAll]);
    result := StringReplace(result, '&frac12;', '½', [rfReplaceAll]);
    result := StringReplace(result, '&frac34;', '¾', [rfReplaceAll]);
    result := StringReplace(result, '&Oslash;', 'Ø', [rfReplaceAll]);
    result := StringReplace(result, '&divide;', '÷', [rfReplaceAll]);
    result := StringReplace(result, '&oslash;', 'ø', [rfReplaceAll]);
    result := StringReplace(result, '&permil;', '‰', [rfReplaceAll]);
    result := StringReplace(result, '&prime;',  '''', [rfReplaceAll]);
    result := StringReplace(result, '&sect;',  '§', [rfReplaceAll]);
    result := StringReplace(result, '&copy;',  '©', [rfReplaceAll]);
    result := StringReplace(result, '&reg;',   '®', [rfReplaceAll]);
    result := StringReplace(result, '&trade;', '™', [rfReplaceAll]);
    result := StringReplace(result, '&euro;'   ,'€', [rfReplaceAll]);
    result := StringReplace(result, '&eacute;' ,'é', [rfReplaceAll]);
    result := StringReplace(result, '&egrave;' ,'è', [rfReplaceAll]);
    result := StringReplace(result, '&ecirc;'  ,'ê', [rfReplaceAll]);
    result := StringReplace(result, '&acirc;'  ,'â', [rfReplaceAll]);
    result := StringReplace(result, '&agrave;' , 'à', [rfReplaceAll]);
    result := StringReplace(result, '&aacute;' ,'á', [rfReplaceAll]);
    result := StringReplace(result, '&ucirc;'  ,'û', [rfReplaceAll]);
    result := StringReplace(result, '&uacute;' , 'ú', [rfReplaceAll]);
    result := StringReplace(result, '&ugrave;' ,'ù', [rfReplaceAll]);
    result := StringReplace(result, '&ocirc;'  ,'ô', [rfReplaceAll]);
    result := StringReplace(result, '&Eacute;' ,'É', [rfReplaceAll]);
    result := StringReplace(result, '&Egrave;' ,'È', [rfReplaceAll]);
    result := StringReplace(result, '&Ecirc;'  ,'Ê', [rfReplaceAll]);
    result := StringReplace(result, '&Acirc;'  ,'Â', [rfReplaceAll]);
    result := StringReplace(result, '&Agrave;' ,'À', [rfReplaceAll]);
    result := StringReplace(result, '&Aacute;' ,'Á', [rfReplaceAll]);
    result := StringReplace(result, '&Ucirc;'  , 'Û', [rfReplaceAll]);
    result := StringReplace(result, '&Uacute;' ,'Ú', [rfReplaceAll]);
    result := StringReplace(result, '&Ugrave;' ,'Ù', [rfReplaceAll]);
    result := StringReplace(result, '&Ocirc;'  ,'Ô', [rfReplaceAll]);
    result := StringReplace(result, '&iexcl;'  ,'¡', [rfReplaceAll]);
    result := StringReplace(result, '&cent;'   , '¢', [rfReplaceAll]);
    result := StringReplace(result, '&pound;'  , '£', [rfReplaceAll]);
    result := StringReplace(result, '&curren;' , '¤', [rfReplaceAll]);
    result := StringReplace(result, '&yen;'    ,'¥', [rfReplaceAll]);
    result := StringReplace(result, '&brvbar;' , '¦', [rfReplaceAll]);
    result := StringReplace(result, '&uml;'    , '¨', [rfReplaceAll]);
    result := StringReplace(result, '&ordf;'   , 'ª', [rfReplaceAll]);
    result := StringReplace(result, '&laquo;'  , '«', [rfReplaceAll]);
    result := StringReplace(result, '&not;'    , '¬', [rfReplaceAll]);
    result := StringReplace(result, '&shy;'     ,'' , [rfReplaceAll]);
    result := StringReplace(result, '&macr;'   , '¯', [rfReplaceAll]);
    result := StringReplace(result, '&acute;'  , '´', [rfReplaceAll]);
    result := StringReplace(result, '&para;'   , '¶', [rfReplaceAll]);
    result := StringReplace(result, '&middot;' , '·', [rfReplaceAll]);
    result := StringReplace(result, '&cedil;'  , '¸', [rfReplaceAll]);
    result := StringReplace(result, '&raquo;'  ,'»', [rfReplaceAll]);
    result := StringReplace(result, '&iquest;' , '¿', [rfReplaceAll]);
    result := StringReplace(result, '&Atilde;' , 'Ã', [rfReplaceAll]);
    result := StringReplace(result, '&Auml;'   , 'Ä', [rfReplaceAll]);
    result := StringReplace(result, '&Aring;'  , 'Å', [rfReplaceAll]);
    result := StringReplace(result, '&AElig;'  , 'Æ', [rfReplaceAll]);
    result := StringReplace(result, '&Ccedil;' ,'Ç', [rfReplaceAll]);
    result := StringReplace(result, '&Euml;'   , 'Ë', [rfReplaceAll]);
    result := StringReplace(result, '&Igrave;' , 'Ì', [rfReplaceAll]);
    result := StringReplace(result, '&Iacute;' , 'Í', [rfReplaceAll]);
    result := StringReplace(result, '&Icirc;'  , 'Î', [rfReplaceAll]);
    result := StringReplace(result, '&Iuml;'   , 'Ï', [rfReplaceAll]);
    result := StringReplace(result, '&ETH;'    ,'Ð', [rfReplaceAll]);
    result := StringReplace(result, '&Ntilde;' , 'Ñ', [rfReplaceAll]);
    result := StringReplace(result, '&Ograve;' , 'Ò', [rfReplaceAll]);
    result := StringReplace(result, '&Oacute;' , 'Ó', [rfReplaceAll]);
    result := StringReplace(result, '&Otilde;' , 'Õ', [rfReplaceAll]);
    result := StringReplace(result, '&times;'  , '×', [rfReplaceAll]);
    result := StringReplace(result, '&Yacute;' ,'Ý', [rfReplaceAll]);
    result := StringReplace(result, '&THORN'   , 'Þ', [rfReplaceAll]);
    result := StringReplace(result, '&atilde;' , 'ã', [rfReplaceAll]);
    result := StringReplace(result, '&aring;'  , 'å', [rfReplaceAll]);
    result := StringReplace(result, '&aelig;'  , 'æ', [rfReplaceAll]);
    result := StringReplace(result, '&ccedil;' , 'ç', [rfReplaceAll]);
    result := StringReplace(result, '&euml;'   ,'ë', [rfReplaceAll]);
    result := StringReplace(result, '&igrave;' , 'ì', [rfReplaceAll]);
    result := StringReplace(result, '&iacute;' , 'í', [rfReplaceAll]);
    result := StringReplace(result, '&icirc;'  , 'î', [rfReplaceAll]);
    result := StringReplace(result, '&iuml;'   , 'ï', [rfReplaceAll]);
    result := StringReplace(result, '&eth;'    , 'ð', [rfReplaceAll]);
    result := StringReplace(result, '&ntilde;' ,'ñ', [rfReplaceAll]);
    result := StringReplace(result, '&ograve;' , 'ò', [rfReplaceAll]);
    result := StringReplace(result, '&oacute;' , 'ó', [rfReplaceAll]);
    result := StringReplace(result, '&otilde;' , 'õ', [rfReplaceAll]);
    result := StringReplace(result, '&yacute;' ,'ý', [rfReplaceAll]);
    result := StringReplace(result, '&thorn;'  ,'þ', [rfReplaceAll]);
    result := StringReplace(result, '&yuml;'   ,'ÿ', [rfReplaceAll]);
    result := StringReplace(result, '&bdquo;'  ,'„', [rfReplaceAll]);
end;


function StringToURLStringAnd(aUTF8String: UTF8String): AnsiString;
var i: integer;
begin
    result := '';
    for i := 1 to length(aUTF8String) do
        result := result + '%'  + AnsiString(IntToHex(Ord(aUTF8String[i]),2));
end;


end.
