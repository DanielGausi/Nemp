
{
  Compatibilty to older Delphi Versions:
  Undef USE_SYSTEM_TYPES to not use System.Types
}

{$DEFINE USE_SYSTEM_TYPES}

{
  Compiler-Switch-TNT:
  For reading files with "unicode filenames", some methods/types from the
  "TNT Unicode Controls" can be used:
    - WideFileExists and
    - TTntFileStream
  If you do not want to use this, only Ansi-Filenames are supported
  (in Delphi 2007 or earlier).  
}

{.$DEFINE USE_TNT_COMPOS}



{
  Delphi 2009: Unicode-capable by default. TNTs ar not needed.
               => Deactivate use of TNTs
}


{$IFDEF UNICODE}
    {$UNDEF USE_TNT_COMPOS}
{$ENDIF}


