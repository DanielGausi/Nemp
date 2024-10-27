
{
  Compatibilty to older Delphi Versions:
  Undef USE_SYSTEM_TYPES to not use System.Types
  Undef USE_DICTIONARY to use a regular TObjectList instead of TDictionary for registering audiotypes
}

{$DEFINE USE_SYSTEM_TYPES}


{$if CompilerVersion > 20} // Delphi 2009 or later
  {$DEFINE USE_DICTIONARY}
  {$DEFINE USE_GENERICS}
{$ifend}

{
  Compiler-Switch-TNT:
  For reading files with "unicode filenames", some methods/types from the
  "TNT Unicode Controls" can be used:
    - WideFileExists and
    - TTntFileStream
  If you do not want to use this, only Ansi-Filenames are supported
  (in Delphi 2007 or earlier).
}

{$DEFINE USE_TNT_COMPOS}

{
  Delphi 2009: Unicode-capable by default. TNTs ar not needed.
               => Deactivate use of TNTs
}

{$IFDEF UNICODE}
    {$UNDEF USE_TNT_COMPOS}
{$ENDIF}


