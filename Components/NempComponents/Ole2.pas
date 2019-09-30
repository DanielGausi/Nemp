{ *********************************************************************** }
{                                                                         }
{ Delphi Runtime Library                                                  }
{                                                                         }
{ Copyright (c) 1996-2001 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

{*******************************************************}
{       OLE 2 Interface Unit                            }
{*******************************************************}

unit Ole2;

interface

// For CBuilder v1.0 backward compatiblity, OLE2.HPP must include ole2.h
(*$HPPEMIT '#include <ole2.h>'*)

uses Windows;

const
  {$EXTERNALSYM MEMCTX_TASK}
  MEMCTX_TASK    = 1;
  {$EXTERNALSYM MEMCTX_SHARED}
  MEMCTX_SHARED    = 2;
  {$EXTERNALSYM MEMCTX_MACSYSTEM}
  MEMCTX_MACSYSTEM = 3;
  {$EXTERNALSYM MEMCTX_UNKNOWN}
  MEMCTX_UNKNOWN   = -1;
  {$EXTERNALSYM MEMCTX_SAME}
  MEMCTX_SAME    = -2;

  {$EXTERNALSYM ROTFLAGS_REGISTRATIONKEEPSALIVE}
  ROTFLAGS_REGISTRATIONKEEPSALIVE = 1;

  {$EXTERNALSYM CLSCTX_INPROC_SERVER}
  CLSCTX_INPROC_SERVER   = 1;
  {$EXTERNALSYM CLSCTX_INPROC_HANDLER}
  CLSCTX_INPROC_HANDLER  = 2;
  {$EXTERNALSYM CLSCTX_LOCAL_SERVER}
  CLSCTX_LOCAL_SERVER  = 4;
  {$EXTERNALSYM CLSCTX_INPROC_SERVER16}
  CLSCTX_INPROC_SERVER16 = 8;

  {$EXTERNALSYM CLSCTX_ALL}
  CLSCTX_ALL    = CLSCTX_INPROC_SERVER or CLSCTX_INPROC_HANDLER or
                  CLSCTX_LOCAL_SERVER;
  {$EXTERNALSYM CLSCTX_INPROC}
  CLSCTX_INPROC = CLSCTX_INPROC_SERVER or CLSCTX_INPROC_HANDLER;
  {$EXTERNALSYM CLSCTX_SERVER}
  CLSCTX_SERVER = CLSCTX_INPROC_SERVER or CLSCTX_LOCAL_SERVER;

  {$EXTERNALSYM MSHLFLAGS_NORMAL}
  MSHLFLAGS_NORMAL  = 0;
  {$EXTERNALSYM MSHLFLAGS_TABLESTRONG}
  MSHLFLAGS_TABLESTRONG = 1;
  {$EXTERNALSYM MSHLFLAGS_TABLEWEAK}
  MSHLFLAGS_TABLEWEAK = 2;

  {$EXTERNALSYM MSHCTX_LOCAL}
  MSHCTX_LOCAL            = 0;
  {$EXTERNALSYM MSHCTX_NOSHAREDMEM}
  MSHCTX_NOSHAREDMEM    = 1;
  {$EXTERNALSYM MSHCTX_DIFFERENTMACHINE}
  MSHCTX_DIFFERENTMACHINE = 2;
  {$EXTERNALSYM MSHCTX_INPROC}
  MSHCTX_INPROC           = 3;

  {$EXTERNALSYM DVASPECT_CONTENT}
  DVASPECT_CONTENT   = 1;
  {$EXTERNALSYM DVASPECT_THUMBNAIL}
  DVASPECT_THUMBNAIL = 2;
  {$EXTERNALSYM DVASPECT_ICON}
  DVASPECT_ICON      = 4;
  {$EXTERNALSYM DVASPECT_DOCPRINT}
  DVASPECT_DOCPRINT  = 8;

  {$EXTERNALSYM STGC_DEFAULT}
  STGC_DEFAULT                            = 0;
  {$EXTERNALSYM STGC_OVERWRITE}
  STGC_OVERWRITE                    = 1;
  {$EXTERNALSYM STGC_ONLYIFCURRENT}
  STGC_ONLYIFCURRENT                    = 2;
  {$EXTERNALSYM STGC_DANGEROUSLYCOMMITMERELYTODISKCACHE}
  STGC_DANGEROUSLYCOMMITMERELYTODISKCACHE = 4;

  {$EXTERNALSYM STGMOVE_MOVE}
  STGMOVE_MOVE = 0;
  {$EXTERNALSYM STGMOVE_COPY}
  STGMOVE_COPY = 1;

  {$EXTERNALSYM STATFLAG_DEFAULT}
  STATFLAG_DEFAULT = 0;
  {$EXTERNALSYM STATFLAG_NONAME}
  STATFLAG_NONAME  = 1;

  {$EXTERNALSYM BIND_MAYBOTHERUSER}
  BIND_MAYBOTHERUSER   = 1;
  {$EXTERNALSYM BIND_JUSTTESTEXISTENCE}
  BIND_JUSTTESTEXISTENCE = 2;

  {$EXTERNALSYM MKSYS_NONE}
  MKSYS_NONE           = 0;
  {$EXTERNALSYM MKSYS_GENERICCOMPOSITE}
  MKSYS_GENERICCOMPOSITE = 1;
  {$EXTERNALSYM MKSYS_FILEMONIKER}
  MKSYS_FILEMONIKER  = 2;
  {$EXTERNALSYM MKSYS_ANTIMONIKER}
  MKSYS_ANTIMONIKER  = 3;
  {$EXTERNALSYM MKSYS_ITEMMONIKER}
  MKSYS_ITEMMONIKER  = 4;
  {$EXTERNALSYM MKSYS_POINTERMONIKER}
  MKSYS_POINTERMONIKER   = 5;

  {$EXTERNALSYM MKRREDUCE_ONE}
  MKRREDUCE_ONE         = 3 shl 16;
  {$EXTERNALSYM MKRREDUCE_TOUSER}
  MKRREDUCE_TOUSER  = 2 shl 16;
  {$EXTERNALSYM MKRREDUCE_THROUGHUSER}
  MKRREDUCE_THROUGHUSER = 1 shl 16;
  {$EXTERNALSYM MKRREDUCE_ALL}
  MKRREDUCE_ALL         = 0;

  {$EXTERNALSYM STGTY_STORAGE}
  STGTY_STORAGE   = 1;
  {$EXTERNALSYM STGTY_STREAM}
  STGTY_STREAM    = 2;
  {$EXTERNALSYM STGTY_LOCKBYTES}
  STGTY_LOCKBYTES = 3;
  {$EXTERNALSYM STGTY_PROPERTY}
  STGTY_PROPERTY  = 4;

  {$EXTERNALSYM STREAM_SEEK_SET}
  STREAM_SEEK_SET = 0;
  {$EXTERNALSYM STREAM_SEEK_CUR}
  STREAM_SEEK_CUR = 1;
  {$EXTERNALSYM STREAM_SEEK_END}
  STREAM_SEEK_END = 2;

  {$EXTERNALSYM LOCK_WRITE}
  LOCK_WRITE   = 1;
  {$EXTERNALSYM LOCK_EXCLUSIVE}
  LOCK_EXCLUSIVE = 2;
  {$EXTERNALSYM LOCK_ONLYONCE}
  LOCK_ONLYONCE  = 4;

  {$EXTERNALSYM ADVF_NODATA}
  ADVF_NODATA          = 1;
  {$EXTERNALSYM ADVF_PRIMEFIRST}
  ADVF_PRIMEFIRST  = 2;
  {$EXTERNALSYM ADVF_ONLYONCE}
  ADVF_ONLYONCE          = 4;
  {$EXTERNALSYM ADVF_DATAONSTOP}
  ADVF_DATAONSTOP  = 64;
  {$EXTERNALSYM ADVFCACHE_NOHANDLER}
  ADVFCACHE_NOHANDLER  = 8;
  {$EXTERNALSYM ADVFCACHE_FORCEBUILTIN}
  ADVFCACHE_FORCEBUILTIN = 16;
  {$EXTERNALSYM ADVFCACHE_ONSAVE}
  ADVFCACHE_ONSAVE   = 32;

  {$EXTERNALSYM TYMED_HGLOBAL}
  TYMED_HGLOBAL  = 1;
  {$EXTERNALSYM TYMED_FILE}
  TYMED_FILE     = 2;
  {$EXTERNALSYM TYMED_ISTREAM}
  TYMED_ISTREAM  = 4;
  {$EXTERNALSYM TYMED_ISTORAGE}
  TYMED_ISTORAGE = 8;
  {$EXTERNALSYM TYMED_GDI}
  TYMED_GDI  = 16;
  {$EXTERNALSYM TYMED_MFPICT}
  TYMED_MFPICT   = 32;
  {$EXTERNALSYM TYMED_ENHMF}
  TYMED_ENHMF  = 64;
  {$EXTERNALSYM TYMED_NULL}
  TYMED_NULL   = 0;

  {$EXTERNALSYM DATADIR_GET}
  DATADIR_GET = 1;
  {$EXTERNALSYM DATADIR_SET}
  DATADIR_SET = 2;

  {$EXTERNALSYM CALLTYPE_TOPLEVEL}
  CALLTYPE_TOPLEVEL         = 1;
  {$EXTERNALSYM CALLTYPE_NESTED}
  CALLTYPE_NESTED         = 2;
  {$EXTERNALSYM CALLTYPE_ASYNC}
  CALLTYPE_ASYNC          = 3;
  {$EXTERNALSYM CALLTYPE_TOPLEVEL_CALLPENDING}
  CALLTYPE_TOPLEVEL_CALLPENDING = 4;
  {$EXTERNALSYM CALLTYPE_ASYNC_CALLPENDING}
  CALLTYPE_ASYNC_CALLPENDING  = 5;

  {$EXTERNALSYM SERVERCALL_ISHANDLED}
  SERVERCALL_ISHANDLED  = 0;
  {$EXTERNALSYM SERVERCALL_REJECTED}
  SERVERCALL_REJECTED = 1;
  {$EXTERNALSYM SERVERCALL_RETRYLATER}
  SERVERCALL_RETRYLATER = 2;

  {$EXTERNALSYM PENDINGTYPE_TOPLEVEL}
  PENDINGTYPE_TOPLEVEL = 1;
  {$EXTERNALSYM PENDINGTYPE_NESTED}
  PENDINGTYPE_NESTED   = 2;

  {$EXTERNALSYM PENDINGMSG_CANCELCALL}
  PENDINGMSG_CANCELCALL     = 0;
  {$EXTERNALSYM PENDINGMSG_WAITNOPROCESS}
  PENDINGMSG_WAITNOPROCESS  = 1;
  {$EXTERNALSYM PENDINGMSG_WAITDEFPROCESS}
  PENDINGMSG_WAITDEFPROCESS = 2;

  {$EXTERNALSYM REGCLS_SINGLEUSE}
  REGCLS_SINGLEUSE      = 0;
  {$EXTERNALSYM REGCLS_MULTIPLEUSE}
  REGCLS_MULTIPLEUSE    = 1;
  {$EXTERNALSYM REGCLS_MULTI_SEPARATE}
  REGCLS_MULTI_SEPARATE = 2;

  {$EXTERNALSYM MARSHALINTERFACE_MIN}
  MARSHALINTERFACE_MIN = 500;

  {$EXTERNALSYM CWCSTORAGENAME}
  CWCSTORAGENAME = 32;

  {$EXTERNALSYM STGM_DIRECT}
  STGM_DIRECT           = $00000000;
  {$EXTERNALSYM STGM_TRANSACTED}
  STGM_TRANSACTED       = $00010000;
  {$EXTERNALSYM STGM_SIMPLE}
  STGM_SIMPLE           = $08000000;

  {$EXTERNALSYM STGM_READ}
  STGM_READ             = $00000000;
  {$EXTERNALSYM STGM_WRITE}
  STGM_WRITE            = $00000001;
  {$EXTERNALSYM STGM_READWRITE}
  STGM_READWRITE        = $00000002;

  {$EXTERNALSYM STGM_SHARE_DENY_NONE}
  STGM_SHARE_DENY_NONE  = $00000040;
  {$EXTERNALSYM STGM_SHARE_DENY_READ}
  STGM_SHARE_DENY_READ  = $00000030;
  {$EXTERNALSYM STGM_SHARE_DENY_WRITE}
  STGM_SHARE_DENY_WRITE = $00000020;
  {$EXTERNALSYM STGM_SHARE_EXCLUSIVE}
  STGM_SHARE_EXCLUSIVE  = $00000010;

  {$EXTERNALSYM STGM_PRIORITY}
  STGM_PRIORITY         = $00040000;
  {$EXTERNALSYM STGM_DELETEONRELEASE}
  STGM_DELETEONRELEASE  = $04000000;

  {$EXTERNALSYM STGM_CREATE}
  STGM_CREATE           = $00001000;
  {$EXTERNALSYM STGM_CONVERT}
  STGM_CONVERT          = $00020000;
  {$EXTERNALSYM STGM_FAILIFTHERE}
  STGM_FAILIFTHERE      = $00000000;

  {$EXTERNALSYM FADF_AUTO}
  FADF_AUTO      = $0001;  { array is allocated on the stack }
  {$EXTERNALSYM FADF_STATIC}
  FADF_STATIC    = $0002;  { array is staticly allocated }
  {$EXTERNALSYM FADF_EMBEDDED}
  FADF_EMBEDDED  = $0004;  { array is embedded in a structure }
  {$EXTERNALSYM FADF_FIXEDSIZE}
  FADF_FIXEDSIZE = $0010;  { array may not be resized or reallocated }
  {$EXTERNALSYM FADF_BSTR}
  FADF_BSTR      = $0100;  { an array of BSTRs }
  {$EXTERNALSYM FADF_UNKNOWN}
  FADF_UNKNOWN   = $0200;  { an array of IUnknown }
  {$EXTERNALSYM FADF_DISPATCH}
  FADF_DISPATCH  = $0400;  { an array of IDispatch }
  {$EXTERNALSYM FADF_VARIANT}
  FADF_VARIANT   = $0800;  { an array of VARIANTs }
  {$EXTERNALSYM FADF_RESERVED}
  FADF_RESERVED  = $F0E8;  { bits reserved for future use }

{ VARENUM usage key,

    [V] - may appear in a VARIANT
    [T] - may appear in a TYPEDESC
    [P] - may appear in an OLE property set
    [S] - may appear in a Safe Array }

  {$EXTERNALSYM VT_EMPTY}
  VT_EMPTY           = 0;   { [V]   [P]  nothing                     }
  {$EXTERNALSYM VT_NULL}
  VT_NULL            = 1;   { [V]        SQL style Null              }
  {$EXTERNALSYM VT_I2}
  VT_I2              = 2;   { [V][T][P]  2 byte signed int           }
  {$EXTERNALSYM VT_I4}
  VT_I4              = 3;   { [V][T][P]  4 byte signed int           }
  {$EXTERNALSYM VT_R4}
  VT_R4              = 4;   { [V][T][P]  4 byte real                 }
  {$EXTERNALSYM VT_R8}
  VT_R8              = 5;   { [V][T][P]  8 byte real                 }
  {$EXTERNALSYM VT_CY}
  VT_CY              = 6;   { [V][T][P]  currency                    }
  {$EXTERNALSYM VT_DATE}
  VT_DATE            = 7;   { [V][T][P]  date                        }
  {$EXTERNALSYM VT_BSTR}
  VT_BSTR            = 8;   { [V][T][P]  binary string               }
  {$EXTERNALSYM VT_DISPATCH}
  VT_DISPATCH        = 9;   { [V][T]     IDispatch FAR*              }
  {$EXTERNALSYM VT_ERROR}
  VT_ERROR           = 10;  { [V][T]     SCODE                       }
  {$EXTERNALSYM VT_BOOL}
  VT_BOOL            = 11;  { [V][T][P]  True=-1, False=0            }
  {$EXTERNALSYM VT_VARIANT}
  VT_VARIANT         = 12;  { [V][T][P]  VARIANT FAR*                }
  {$EXTERNALSYM VT_UNKNOWN}
  VT_UNKNOWN         = 13;  { [V][T]     IUnknown FAR*               }

  {$EXTERNALSYM VT_I1}
  VT_I1              = 16;  {    [T]     signed char                 }
  {$EXTERNALSYM VT_UI1}
  VT_UI1             = 17;  {    [T]     unsigned char               }
  {$EXTERNALSYM VT_UI2}
  VT_UI2             = 18;  {    [T]     unsigned short              }
  {$EXTERNALSYM VT_UI4}
  VT_UI4             = 19;  {    [T]     unsigned short              }
  {$EXTERNALSYM VT_I8}
  VT_I8              = 20;  {    [T][P]  signed 64-bit int           }
  {$EXTERNALSYM VT_UI8}
  VT_UI8             = 21;  {    [T]     unsigned 64-bit int         }
  {$EXTERNALSYM VT_INT}
  VT_INT             = 22;  {    [T]     signed machine int          }
  {$EXTERNALSYM VT_UINT}
  VT_UINT            = 23;  {    [T]     unsigned machine int        }
  {$EXTERNALSYM VT_VOID}
  VT_VOID            = 24;  {    [T]     C style void                }
  {$EXTERNALSYM VT_HRESULT}
  VT_HRESULT         = 25;  {    [T]                                 }
  {$EXTERNALSYM VT_PTR}
  VT_PTR             = 26;  {    [T]     pointer type                }
  {$EXTERNALSYM VT_SAFEARRAY}
  VT_SAFEARRAY       = 27;  {    [T]     (use VT_ARRAY in VARIANT)   }
  {$EXTERNALSYM VT_CARRAY}
  VT_CARRAY          = 28;  {    [T]     C style array               }
  {$EXTERNALSYM VT_USERDEFINED}
  VT_USERDEFINED     = 29;  {    [T]     user defined type          }
  {$EXTERNALSYM VT_LPSTR}
  VT_LPSTR           = 30;  {    [T][P]  null terminated string      }
  {$EXTERNALSYM VT_LPWSTR}
  VT_LPWSTR          = 31;  {    [T][P]  wide null terminated string }

  {$EXTERNALSYM VT_FILETIME}
  VT_FILETIME        = 64;  {       [P]  FILETIME                    }
  {$EXTERNALSYM VT_BLOB}
  VT_BLOB            = 65;  {       [P]  Length prefixed bytes       }
  {$EXTERNALSYM VT_STREAM}
  VT_STREAM          = 66;  {       [P]  Name of the stream follows  }
  {$EXTERNALSYM VT_STORAGE}
  VT_STORAGE         = 67;  {       [P]  Name of the storage follows }
  {$EXTERNALSYM VT_STREAMED_OBJECT}
  VT_STREAMED_OBJECT = 68;  {       [P]  Stream contains an object   }
  {$EXTERNALSYM VT_STORED_OBJECT}
  VT_STORED_OBJECT   = 69;  {       [P]  Storage contains an object  }
  {$EXTERNALSYM VT_BLOB_OBJECT}
  VT_BLOB_OBJECT     = 70;  {       [P]  Blob contains an object     }
  {$EXTERNALSYM VT_CF}
  VT_CF              = 71;  {       [P]  Clipboard format            }
  {$EXTERNALSYM VT_CLSID}
  VT_CLSID           = 72;  {       [P]  A Class ID                  }

  {$EXTERNALSYM VT_VECTOR}
  VT_VECTOR       = $1000;  {       [P]  simple counted array        }
  {$EXTERNALSYM VT_ARRAY}
  VT_ARRAY        = $2000;  { [V]        SAFEARRAY*                  }
  {$EXTERNALSYM VT_BYREF}
  VT_BYREF        = $4000;  { [V]                                    }
  {$EXTERNALSYM VT_RESERVED}
  VT_RESERVED     = $8000;

  {$EXTERNALSYM TKIND_ENUM}
  TKIND_ENUM      = 0;
  {$EXTERNALSYM TKIND_RECORD}
  TKIND_RECORD    = 1;
  {$EXTERNALSYM TKIND_MODULE}
  TKIND_MODULE    = 2;
  {$EXTERNALSYM TKIND_INTERFACE}
  TKIND_INTERFACE = 3;
  {$EXTERNALSYM TKIND_DISPATCH}
  TKIND_DISPATCH  = 4;
  {$EXTERNALSYM TKIND_COCLASS}
  TKIND_COCLASS   = 5;
  {$EXTERNALSYM TKIND_ALIAS}
  TKIND_ALIAS     = 6;
  {$EXTERNALSYM TKIND_UNION}
  TKIND_UNION     = 7;
  {$EXTERNALSYM TKIND_MAX}
  TKIND_MAX       = 8;

  {$EXTERNALSYM CC_CDECL}
  CC_CDECL     = 1;
  {$EXTERNALSYM CC_PASCAL}
  CC_PASCAL    = 2;
  {$EXTERNALSYM CC_MACPASCAL}
  CC_MACPASCAL = 3;
  {$EXTERNALSYM CC_STDCALL}
  CC_STDCALL   = 4;
  {$EXTERNALSYM CC_RESERVED}
  CC_RESERVED  = 5;
  {$EXTERNALSYM CC_SYSCALL}
  CC_SYSCALL   = 6;
  {$EXTERNALSYM CC_MPWCDECL}
  CC_MPWCDECL  = 7;
  {$EXTERNALSYM CC_MPWPASCAL}
  CC_MPWPASCAL = 8;
  {$EXTERNALSYM CC_MAX}
  CC_MAX       = 9;

  {$EXTERNALSYM FUNC_VIRTUAL}
  FUNC_VIRTUAL     = 0;
  {$EXTERNALSYM FUNC_PUREVIRTUAL}
  FUNC_PUREVIRTUAL = 1;
  {$EXTERNALSYM FUNC_NONVIRTUAL}
  FUNC_NONVIRTUAL  = 2;
  {$EXTERNALSYM FUNC_STATIC}
  FUNC_STATIC      = 3;
  {$EXTERNALSYM FUNC_DISPATCH}
  FUNC_DISPATCH    = 4;

  {$EXTERNALSYM INVOKE_FUNC}
  INVOKE_FUNC           = 1;
  {$EXTERNALSYM INVOKE_PROPERTYGET}
  INVOKE_PROPERTYGET    = 2;
  {$EXTERNALSYM INVOKE_PROPERTYPUT}
  INVOKE_PROPERTYPUT    = 4;
  {$EXTERNALSYM INVOKE_PROPERTYPUTREF}
  INVOKE_PROPERTYPUTREF = 8;

  {$EXTERNALSYM VAR_PERINSTANCE}
  VAR_PERINSTANCE = 0;
  {$EXTERNALSYM VAR_STATIC}
  VAR_STATIC      = 1;
  {$EXTERNALSYM VAR_CONST}
  VAR_CONST       = 2;
  {$EXTERNALSYM VAR_DISPATCH}
  VAR_DISPATCH    = 3;

  {$EXTERNALSYM IMPLTYPEFLAG_FDEFAULT}
  IMPLTYPEFLAG_FDEFAULT    = 1;
  {$EXTERNALSYM IMPLTYPEFLAG_FSOURCE}
  IMPLTYPEFLAG_FSOURCE     = 2;
  {$EXTERNALSYM IMPLTYPEFLAG_FRESTRICTED}
  IMPLTYPEFLAG_FRESTRICTED = 4;

  {$EXTERNALSYM TYPEFLAG_FAPPOBJECT}
  TYPEFLAG_FAPPOBJECT   = $0001;
  {$EXTERNALSYM TYPEFLAG_FCANCREATE}
  TYPEFLAG_FCANCREATE   = $0002;
  {$EXTERNALSYM TYPEFLAG_FLICENSED}
  TYPEFLAG_FLICENSED    = $0004;
  {$EXTERNALSYM TYPEFLAG_FPREDECLID}
  TYPEFLAG_FPREDECLID   = $0008;
  {$EXTERNALSYM TYPEFLAG_FHIDDEN}
  TYPEFLAG_FHIDDEN    = $0010;
  {$EXTERNALSYM TYPEFLAG_FCONTROL}
  TYPEFLAG_FCONTROL   = $0020;
  {$EXTERNALSYM TYPEFLAG_FDUAL}
  TYPEFLAG_FDUAL    = $0040;
  {$EXTERNALSYM TYPEFLAG_FNONEXTENSIBLE}
  TYPEFLAG_FNONEXTENSIBLE = $0080;
  {$EXTERNALSYM TYPEFLAG_FOLEAUTOMATION}
  TYPEFLAG_FOLEAUTOMATION = $0100;

  {$EXTERNALSYM FUNCFLAG_FRESTRICTED}
  FUNCFLAG_FRESTRICTED  = $0001;
  {$EXTERNALSYM FUNCFLAG_FSOURCE}
  FUNCFLAG_FSOURCE  = $0002;
  {$EXTERNALSYM FUNCFLAG_FBINDABLE}
  FUNCFLAG_FBINDABLE  = $0004;
  {$EXTERNALSYM FUNCFLAG_FREQUESTEDIT}
  FUNCFLAG_FREQUESTEDIT = $0008;
  {$EXTERNALSYM FUNCFLAG_FDISPLAYBIND}
  FUNCFLAG_FDISPLAYBIND = $0010;
  {$EXTERNALSYM FUNCFLAG_FDEFAULTBIND}
  FUNCFLAG_FDEFAULTBIND = $0020;
  {$EXTERNALSYM FUNCFLAG_FHIDDEN}
  FUNCFLAG_FHIDDEN  = $0040;

  {$EXTERNALSYM VARFLAG_FREADONLY}
  VARFLAG_FREADONLY    = $0001;
  {$EXTERNALSYM VARFLAG_FSOURCE}
  VARFLAG_FSOURCE      = $0002;
  {$EXTERNALSYM VARFLAG_FBINDABLE}
  VARFLAG_FBINDABLE    = $0004;
  {$EXTERNALSYM VARFLAG_FREQUESTEDIT}
  VARFLAG_FREQUESTEDIT = $0008;
  {$EXTERNALSYM VARFLAG_FDISPLAYBIND}
  VARFLAG_FDISPLAYBIND = $0010;
  {$EXTERNALSYM VARFLAG_FDEFAULTBIND}
  VARFLAG_FDEFAULTBIND = $0020;
  {$EXTERNALSYM VARFLAG_FHIDDEN}
  VARFLAG_FHIDDEN      = $0040;

  {$EXTERNALSYM DISPID_VALUE}
  DISPID_VALUE       = 0;
  {$EXTERNALSYM DISPID_UNKNOWN}
  DISPID_UNKNOWN     = -1;
  {$EXTERNALSYM DISPID_PROPERTYPUT}
  DISPID_PROPERTYPUT = -3;
  {$EXTERNALSYM DISPID_NEWENUM}
  DISPID_NEWENUM     = -4;
  {$EXTERNALSYM DISPID_EVALUATE}
  DISPID_EVALUATE    = -5;
  {$EXTERNALSYM DISPID_CONSTRUCTOR}
  DISPID_CONSTRUCTOR = -6;
  {$EXTERNALSYM DISPID_DESTRUCTOR}
  DISPID_DESTRUCTOR  = -7;
  {$EXTERNALSYM DISPID_COLLECT}
  DISPID_COLLECT     = -8;

  {$EXTERNALSYM DESCKIND_NONE}
  DESCKIND_NONE = 0;
  {$EXTERNALSYM DESCKIND_FUNCDESC}
  DESCKIND_FUNCDESC = 1;
  {$EXTERNALSYM DESCKIND_VARDESC}
  DESCKIND_VARDESC = 2;
  {$EXTERNALSYM DESCKIND_TYPECOMP}
  DESCKIND_TYPECOMP = 3;
  {$EXTERNALSYM DESCKIND_IMPLICITAPPOBJ}
  DESCKIND_IMPLICITAPPOBJ = 4;
  {$EXTERNALSYM DESCKIND_MAX}
  DESCKIND_MAX = 5;

  {$EXTERNALSYM SYS_WIN16}
  SYS_WIN16 = 0;
  {$EXTERNALSYM SYS_WIN32}
  SYS_WIN32 = 1;
  {$EXTERNALSYM SYS_MAC}
  SYS_MAC   = 2;

  {$EXTERNALSYM LIBFLAG_FRESTRICTED}
  LIBFLAG_FRESTRICTED = 1;
  {$EXTERNALSYM LIBFLAG_FCONTROL}
  LIBFLAG_FCONTROL    = 2;
  {$EXTERNALSYM LIBFLAG_FHIDDEN}
  LIBFLAG_FHIDDEN     = 4;

  {$EXTERNALSYM STDOLE_MAJORVERNUM}
  STDOLE_MAJORVERNUM = 1;
  {$EXTERNALSYM STDOLE_MINORVERNUM}
  STDOLE_MINORVERNUM = 0;

  {$EXTERNALSYM STDOLE_LCID}
  STDOLE_LCID = 0;

  {$EXTERNALSYM VARIANT_NOVALUEPROP}
  VARIANT_NOVALUEPROP = 1;

  {$EXTERNALSYM VAR_TIMEVALUEONLY}
  VAR_TIMEVALUEONLY = 1;
  {$EXTERNALSYM VAR_DATEVALUEONLY}
  VAR_DATEVALUEONLY = 2;

  {$EXTERNALSYM MEMBERID_NIL}
  MEMBERID_NIL = DISPID_UNKNOWN;

  {$EXTERNALSYM ID_DEFAULTINST}
  ID_DEFAULTINST = -2;

  {$EXTERNALSYM IDLFLAG_NONE}
  IDLFLAG_NONE    = 0;
  {$EXTERNALSYM IDLFLAG_FIN}
  IDLFLAG_FIN     = 1;
  {$EXTERNALSYM IDLFLAG_FOUT}
  IDLFLAG_FOUT    = 2;
  {$EXTERNALSYM IDLFLAG_FLCID}
  IDLFLAG_FLCID   = 4;
  {$EXTERNALSYM IDLFLAG_FRETVAL}
  IDLFLAG_FRETVAL = 8;

  {$EXTERNALSYM DISPATCH_METHOD}
  DISPATCH_METHOD         = 1;
  {$EXTERNALSYM DISPATCH_PROPERTYGET}
  DISPATCH_PROPERTYGET    = 2;
  {$EXTERNALSYM DISPATCH_PROPERTYPUT}
  DISPATCH_PROPERTYPUT    = 4;
  {$EXTERNALSYM DISPATCH_PROPERTYPUTREF}
  DISPATCH_PROPERTYPUTREF = 8;

  {$EXTERNALSYM OLEIVERB_PRIMARY}
  OLEIVERB_PRIMARY          = 0;
  {$EXTERNALSYM OLEIVERB_SHOW}
  OLEIVERB_SHOW             = -1;
  {$EXTERNALSYM OLEIVERB_OPEN}
  OLEIVERB_OPEN             = -2;
  {$EXTERNALSYM OLEIVERB_HIDE}
  OLEIVERB_HIDE             = -3;
  {$EXTERNALSYM OLEIVERB_UIACTIVATE}
  OLEIVERB_UIACTIVATE       = -4;
  {$EXTERNALSYM OLEIVERB_INPLACEACTIVATE}
  OLEIVERB_INPLACEACTIVATE  = -5;
  {$EXTERNALSYM OLEIVERB_DISCARDUNDOSTATE}
  OLEIVERB_DISCARDUNDOSTATE = -6;

  {$EXTERNALSYM EMBDHLP_INPROC_HANDLER}
  EMBDHLP_INPROC_HANDLER = $00000000;
  {$EXTERNALSYM EMBDHLP_INPROC_SERVER}
  EMBDHLP_INPROC_SERVER  = $00000001;
  {$EXTERNALSYM EMBDHLP_CREATENOW}
  EMBDHLP_CREATENOW      = $00000000;
  {$EXTERNALSYM EMBDHLP_DELAYCREATE}
  EMBDHLP_DELAYCREATE    = $00010000;

  {$EXTERNALSYM UPDFCACHE_NODATACACHE}
  UPDFCACHE_NODATACACHE = 1;
  {$EXTERNALSYM UPDFCACHE_ONSAVECACHE}
  UPDFCACHE_ONSAVECACHE = 2;
  {$EXTERNALSYM UPDFCACHE_ONSTOPCACHE}
  UPDFCACHE_ONSTOPCACHE = 4;
  {$EXTERNALSYM UPDFCACHE_NORMALCACHE}
  UPDFCACHE_NORMALCACHE = 8;
  {$EXTERNALSYM UPDFCACHE_IFBLANK}
  UPDFCACHE_IFBLANK     = $10;
  {$EXTERNALSYM UPDFCACHE_ONLYIFBLANK}
  UPDFCACHE_ONLYIFBLANK = $80000000;

  {$EXTERNALSYM UPDFCACHE_IFBLANKORONSAVECACHE}
  UPDFCACHE_IFBLANKORONSAVECACHE = UPDFCACHE_IFBLANK or UPDFCACHE_ONSAVECACHE;
  {$EXTERNALSYM UPDFCACHE_ALL}
  UPDFCACHE_ALL                  = not UPDFCACHE_ONLYIFBLANK;
  {$EXTERNALSYM UPDFCACHE_ALLBUTNODATACACHE}
  UPDFCACHE_ALLBUTNODATACACHE    = UPDFCACHE_ALL and not UPDFCACHE_NODATACACHE;

  {$EXTERNALSYM DISCARDCACHE_SAVEIFDIRTY}
  DISCARDCACHE_SAVEIFDIRTY = 0;
  {$EXTERNALSYM DISCARDCACHE_NOSAVE}
  DISCARDCACHE_NOSAVE      = 1;

  {$EXTERNALSYM OLEGETMONIKER_ONLYIFTHERE}
  OLEGETMONIKER_ONLYIFTHERE = 1;
  {$EXTERNALSYM OLEGETMONIKER_FORCEASSIGN}
  OLEGETMONIKER_FORCEASSIGN = 2;
  {$EXTERNALSYM OLEGETMONIKER_UNASSIGN}
  OLEGETMONIKER_UNASSIGN    = 3;
  {$EXTERNALSYM OLEGETMONIKER_TEMPFORUSER}
  OLEGETMONIKER_TEMPFORUSER = 4;

  {$EXTERNALSYM OLEWHICHMK_CONTAINER}
  OLEWHICHMK_CONTAINER = 1;
  {$EXTERNALSYM OLEWHICHMK_OBJREL}
  OLEWHICHMK_OBJREL    = 2;
  {$EXTERNALSYM OLEWHICHMK_OBJFULL}
  OLEWHICHMK_OBJFULL   = 3;

  {$EXTERNALSYM USERCLASSTYPE_FULL}
  USERCLASSTYPE_FULL    = 1;
  {$EXTERNALSYM USERCLASSTYPE_SHORT}
  USERCLASSTYPE_SHORT   = 2;
  {$EXTERNALSYM USERCLASSTYPE_APPNAME}
  USERCLASSTYPE_APPNAME = 3;

  {$EXTERNALSYM OLEMISC_RECOMPOSEONRESIZE}
  OLEMISC_RECOMPOSEONRESIZE        = 1;
  {$EXTERNALSYM OLEMISC_ONLYICONIC}
  OLEMISC_ONLYICONIC                 = 2;
  {$EXTERNALSYM OLEMISC_INSERTNOTREPLACE}
  OLEMISC_INSERTNOTREPLACE         = 4;
  {$EXTERNALSYM OLEMISC_STATIC}
  OLEMISC_STATIC                 = 8;
  {$EXTERNALSYM OLEMISC_CANTLINKINSIDE}
  OLEMISC_CANTLINKINSIDE         = 16;
  {$EXTERNALSYM OLEMISC_CANLINKBYOLE1}
  OLEMISC_CANLINKBYOLE1                = 32;
  {$EXTERNALSYM OLEMISC_ISLINKOBJECT}
  OLEMISC_ISLINKOBJECT                 = 64;
  {$EXTERNALSYM OLEMISC_INSIDEOUT}
  OLEMISC_INSIDEOUT                = 128;
  {$EXTERNALSYM OLEMISC_ACTIVATEWHENVISIBLE}
  OLEMISC_ACTIVATEWHENVISIBLE        = 256;
  {$EXTERNALSYM OLEMISC_RENDERINGISDEVICEINDEPENDENT}
  OLEMISC_RENDERINGISDEVICEINDEPENDENT = 512;

  {$EXTERNALSYM OLECLOSE_SAVEIFDIRTY}
  OLECLOSE_SAVEIFDIRTY = 0;
  {$EXTERNALSYM OLECLOSE_NOSAVE}
  OLECLOSE_NOSAVE      = 1;
  {$EXTERNALSYM OLECLOSE_PROMPTSAVE}
  OLECLOSE_PROMPTSAVE  = 2;

  {$EXTERNALSYM OLERENDER_NONE}
  OLERENDER_NONE   = 0;
  {$EXTERNALSYM OLERENDER_DRAW}
  OLERENDER_DRAW   = 1;
  {$EXTERNALSYM OLERENDER_FORMAT}
  OLERENDER_FORMAT = 2;
  {$EXTERNALSYM OLERENDER_ASIS}
  OLERENDER_ASIS   = 3;

  {$EXTERNALSYM OLEUPDATE_ALWAYS}
  OLEUPDATE_ALWAYS = 1;
  {$EXTERNALSYM OLEUPDATE_ONCALL}
  OLEUPDATE_ONCALL = 3;

  {$EXTERNALSYM OLELINKBIND_EVENIFCLASSDIFF}
  OLELINKBIND_EVENIFCLASSDIFF = 1;

  {$EXTERNALSYM BINDSPEED_INDEFINITE}
  BINDSPEED_INDEFINITE = 1;
  {$EXTERNALSYM BINDSPEED_MODERATE}
  BINDSPEED_MODERATE   = 2;
  {$EXTERNALSYM BINDSPEED_IMMEDIATE}
  BINDSPEED_IMMEDIATE  = 3;

  {$EXTERNALSYM OLECONTF_EMBEDDINGS}
  OLECONTF_EMBEDDINGS  = 1;
  {$EXTERNALSYM OLECONTF_LINKS}
  OLECONTF_LINKS   = 2;
  {$EXTERNALSYM OLECONTF_OTHERS}
  OLECONTF_OTHERS  = 4;
  {$EXTERNALSYM OLECONTF_ONLYUSER}
  OLECONTF_ONLYUSER  = 8;
  {$EXTERNALSYM OLECONTF_ONLYIFRUNNING}
  OLECONTF_ONLYIFRUNNING = 16;

  {$EXTERNALSYM DROPEFFECT_NONE}
  DROPEFFECT_NONE   = 0;
  {$EXTERNALSYM DROPEFFECT_COPY}
  DROPEFFECT_COPY   = 1;
  {$EXTERNALSYM DROPEFFECT_MOVE}
  DROPEFFECT_MOVE   = 2;
  {$EXTERNALSYM DROPEFFECT_LINK}
  DROPEFFECT_LINK   = 4;
  {$EXTERNALSYM DROPEFFECT_SCROLL}
  DROPEFFECT_SCROLL = $80000000;

  {$EXTERNALSYM DD_DEFSCROLLINSET}
  DD_DEFSCROLLINSET    = 11;
  {$EXTERNALSYM DD_DEFSCROLLDELAY}
  DD_DEFSCROLLDELAY    = 50;
  {$EXTERNALSYM DD_DEFSCROLLINTERVAL}
  DD_DEFSCROLLINTERVAL = 50;
  {$EXTERNALSYM DD_DEFDRAGDELAY}
  DD_DEFDRAGDELAY      = 200;
  {$EXTERNALSYM DD_DEFDRAGMINDIST}
  DD_DEFDRAGMINDIST    = 2;

  {$EXTERNALSYM OLEVERBATTRIB_NEVERDIRTIES}
  OLEVERBATTRIB_NEVERDIRTIES    = 1;
  {$EXTERNALSYM OLEVERBATTRIB_ONCONTAINERMENU}
  OLEVERBATTRIB_ONCONTAINERMENU = 2;

type

  PResultList = ^TResultList;
  TResultList = array[0..65535] of HResult;

{ OLE character and string types }

  TOleChar = WideChar;
  POleStr = PWideChar;

  POleStrList = ^TOleStrList;
  TOleStrList = array[0..65535] of POleStr;

{ 64-bit large integer }

  Largeint = Comp;

{ Globally unique ID }

  PGUID = ^TGUID;
  TGUID = record
    D1: LongWord;
    D2: Word;
    D3: Word;
    D4: array[0..7] of Byte;
  end;

{ Interface ID }

  PIID = PGUID;
  TIID = TGUID;

{ Class ID }

  PCLSID = PGUID;
  TCLSID = TGUID;

{ Object ID }

  PObjectID = ^TObjectID;
  {$EXTERNALSYM _OBJECTID}
  _OBJECTID = record
    Lineage: TGUID;
    Uniquifier: Longint;
  end;
  TObjectID = _OBJECTID;
  {$EXTERNALSYM OBJECTID}
  OBJECTID = _OBJECTID;

{ Locale ID }

  TLCID = DWORD;

{ Forward declarations }

  {$EXTERNALSYM IStream}
  IStream = class;
  {$EXTERNALSYM IRunningObjectTable }
  IRunningObjectTable = class;
  {$EXTERNALSYM IEnumString }
  IEnumString = class;
  {$EXTERNALSYM IMoniker}
  IMoniker = class;
  {$EXTERNALSYM IAdviseSink}
  IAdviseSink = class;
  {$EXTERNALSYM IDispatch }
  IDispatch = class;
  {$EXTERNALSYM ITypeInfo}
  ITypeInfo = class;
  {$EXTERNALSYM ITypeComp }
  ITypeComp = class;
  {$EXTERNALSYM ITypeLib}
  ITypeLib = class;
  {$EXTERNALSYM IEnumOleVerb }
  IEnumOleVerb = class;
  {$EXTERNALSYM IOleInPlaceActiveObject}
  IOleInPlaceActiveObject = class;

{ IUnknown interface }

  {$EXTERNALSYM IUnknown }
  IUnknown = class
  public
    function QueryInterface(const iid: TIID; var obj): HResult; virtual; stdcall; abstract;
    function AddRef: Longint; virtual; stdcall; abstract;
    function Release: Longint; virtual; stdcall; abstract;
  end;

{ IClassFactory interface }

  {$EXTERNALSYM IClassFactory }
  IClassFactory = class(IUnknown)
  public
    function CreateInstance(unkOuter: IUnknown; const iid: TIID;
      var obj): HResult; virtual; stdcall; abstract;
    function LockServer(fLock: BOOL): HResult; virtual; stdcall; abstract;
  end;

{ IMarshal interface }

  {$EXTERNALSYM IMarshal }
  IMarshal = class(IUnknown)
  public
    function GetUnmarshalClass(const iid: TIID; pv: Pointer;
      dwDestContext: Longint; pvDestContext: Pointer; mshlflags: Longint;
      var cid: TCLSID): HResult; virtual; stdcall; abstract;
    function GetMarshalSizeMax(const iid: TIID; pv: Pointer;
      dwDestContext: Longint; pvDestContext: Pointer; mshlflags: Longint;
      var size: Longint): HResult; virtual; stdcall; abstract;
    function MarshalInterface(stm: IStream; const iid: TIID; pv: Pointer;
      dwDestContext: Longint; pvDestContext: Pointer;
      mshlflags: Longint): HResult; virtual; stdcall; abstract;
    function UnmarshalInterface(stm: IStream; const iid: TIID;
      var pv): HResult; virtual; stdcall; abstract;
    function ReleaseMarshalData(stm: IStream): HResult;
      virtual; stdcall; abstract;
    function DisconnectObject(dwReserved: Longint): HResult;
      virtual; stdcall; abstract;
  end;

{ IMalloc interface }

  {$EXTERNALSYM IMalloc}
  IMalloc = class(IUnknown)
  public
    function Alloc(cb: Longint): Pointer; virtual; stdcall; abstract;
    function Realloc(pv: Pointer; cb: Longint): Pointer; virtual; stdcall; abstract;
    procedure Free(pv: Pointer); virtual; stdcall; abstract;
    function GetSize(pv: Pointer): Longint; virtual; stdcall; abstract;
    function DidAlloc(pv: Pointer): Integer; virtual; stdcall; abstract;
    procedure HeapMinimize; virtual; stdcall; abstract;
  end;

{ IMallocSpy interface }

  {$EXTERNALSYM IMallocSpy }
  IMallocSpy = class(IUnknown)
  public
    function PreAlloc(cbRequest: Longint): Longint; virtual; stdcall; abstract;
    function PostAlloc(pActual: Pointer): Pointer; virtual; stdcall; abstract;
    function PreFree(pRequest: Pointer; fSpyed: BOOL): Pointer; virtual; stdcall; abstract;
    procedure PostFree(fSpyed: BOOL); virtual; stdcall; abstract;
    function PreRealloc(pRequest: Pointer; cbRequest: Longint;
      var ppNewRequest: Pointer; fSpyed: BOOL): Longint; virtual; stdcall; abstract;
    function PostRealloc(pActual: Pointer; fSpyed: BOOL): Pointer; virtual; stdcall; abstract;
    function PreGetSize(pRequest: Pointer; fSpyed: BOOL): Pointer; virtual; stdcall; abstract;
    function PostGetSize(pActual: Pointer; fSpyed: BOOL): Longint; virtual; stdcall; abstract;
    function PostDidAlloc(pRequest: Pointer; fSpyed: BOOL; fActual: Integer): Integer; virtual; stdcall; abstract;
    procedure PreHeapMinimize; virtual; stdcall; abstract;
    procedure PostHeapMinimize; virtual; stdcall; abstract;
  end;

{ IStdMarshalInfo interface }

  {$EXTERNALSYM IStdMarshalInfo }
  IStdMarshalInfo = class(IUnknown)
  public
    function GetClassForHandler(dwDestContext: Longint; pvDestContext: Pointer;
      var clsid: TCLSID): HResult; virtual; stdcall; abstract;
  end;

{ IExternalConnection interface }

  {$EXTERNALSYM IExternalConnection }
  IExternalConnection = class(IUnknown)
  public
    function AddConnection(extconn: Longint; reserved: Longint): Longint;
      virtual; stdcall; abstract;
    function ReleaseConnection(extconn: Longint; reserved: Longint;
      fLastReleaseCloses: BOOL): Longint; virtual; stdcall; abstract;
  end;

{ IWeakRef interface }

  {$EXTERNALSYM IWeakRef }
  IWeakRef = class(IUnknown)
  public
    function ChangeWeakCount(delta: Longint): Longint; virtual; stdcall; abstract;
    function ReleaseKeepAlive(unkReleased: IUnknown;
      reserved: Longint): Longint; virtual; stdcall; abstract;
  end;

{ IEnumUnknown interface }

  {$EXTERNALSYM IEnumUnknown }
  IEnumUnknown = class(IUnknown)
  public
    function Next(celt: Longint; var elt;
      pceltFetched: PLongint): HResult; virtual; stdcall; abstract;
    function Skip(celt: Longint): HResult; virtual; stdcall; abstract;
    function Reset: HResult; virtual; stdcall; abstract;
    function Clone(var enm: IEnumUnknown): HResult; virtual; stdcall; abstract;
  end;

{ IBindCtx interface }

  PBindOpts = ^TBindOpts;
  {$EXTERNALSYM tagBIND_OPTS}
  tagBIND_OPTS = record
    cbStruct: Longint;
    grfFlags: Longint;
    grfMode: Longint;
    dwTickCountDeadline: Longint;
  end;
  TBindOpts = tagBIND_OPTS;
  {$EXTERNALSYM BIND_OPTS}
  BIND_OPTS = tagBIND_OPTS;

  {$EXTERNALSYM IBindCtx }
  IBindCtx = class(IUnknown)
  public
    function RegisterObjectBound(unk: IUnknown): HResult; virtual; stdcall; abstract;
    function RevokeObjectBound(unk: IUnknown): HResult; virtual; stdcall; abstract;
    function ReleaseBoundObjects: HResult; virtual; stdcall; abstract;
    function SetBindOptions(var bindopts: TBindOpts): HResult; virtual; stdcall; abstract;
    function GetBindOptions(var bindopts: TBindOpts): HResult; virtual; stdcall; abstract;
    function GetRunningObjectTable(var rot: IRunningObjectTable): HResult;
      virtual; stdcall; abstract;
    function RegisterObjectParam(pszKey: POleStr; unk: IUnknown): HResult;
      virtual; stdcall; abstract;
    function GetObjectParam(pszKey: POleStr; var unk: IUnknown): HResult;
      virtual; stdcall; abstract;
    function EnumObjectParam(var Enum: IEnumString): HResult; virtual; stdcall; abstract;
    function RevokeObjectParam(pszKey: POleStr): HResult; virtual; stdcall; abstract;
  end;

{ IEnumMoniker interface }

  {$EXTERNALSYM IEnumMoniker }
  IEnumMoniker = class(IUnknown)
  public
    function Next(celt: Longint; var elt;
      pceltFetched: PLongint): HResult; virtual; stdcall; abstract;
    function Skip(celt: Longint): HResult; virtual; stdcall; abstract;
    function Reset: HResult; virtual; stdcall; abstract;
    function Clone(var enm: IEnumMoniker): HResult; virtual; stdcall; abstract;
  end;

{ IRunnableObject interface }

  {$EXTERNALSYM IRunnableObject }
  IRunnableObject = class(IUnknown)
  public
    function GetRunningClass(var clsid: TCLSID): HResult; virtual; stdcall; abstract;
    function Run(bc: IBindCtx): HResult; virtual; stdcall; abstract;
    function IsRunning: BOOL; virtual; stdcall; abstract;
    function LockRunning(fLock: BOOL; fLastUnlockCloses: BOOL): HResult;
      virtual; stdcall; abstract;
    function SetContainedObject(fContained: BOOL): HResult; virtual; stdcall; abstract;
  end;

{ IRunningObjectTable interface }

  {$EXTERNALSYM IRunningObjectTable }
  IRunningObjectTable = class(IUnknown)
  public
    function Register(grfFlags: Longint; var unkObject: IUnknown;
      mkObjectName: IMoniker; var dwRegister: Longint): HResult; virtual; stdcall; abstract;
    function Revoke(dwRegister: Longint): HResult; virtual; stdcall; abstract;
    function IsRunning(mkObjectName: IMoniker): HResult; virtual; stdcall; abstract;
    function GetObject(mkObjectName: IMoniker;
      var unkObject: IUnknown): HResult; virtual; stdcall; abstract;
    function NoteChangeTime(dwRegister: Longint;
      var filetime: TFileTime): HResult; virtual; stdcall; abstract;
    function GetTimeOfLastChange(mkObjectName: IMoniker;
      var filetime: TFileTime): HResult; virtual; stdcall; abstract;
    function EnumRunning(var enumMoniker: IEnumMoniker): HResult; virtual; stdcall; abstract;
  end;

{ IPersist interface }

  {$EXTERNALSYM IPersist }
  IPersist = class(IUnknown)
  public
    function GetClassID(var classID: TCLSID): HResult; virtual; stdcall; abstract;
  end;

{ IPersistStream interface }

  {$EXTERNALSYM IPersistStream }
  IPersistStream = class(IPersist)
  public
    function IsDirty: HResult; virtual; stdcall; abstract;
    function Load(stm: IStream): HResult; virtual; stdcall; abstract;
    function Save(stm: IStream; fClearDirty: BOOL): HResult; virtual; stdcall; abstract;
    function GetSizeMax(var cbSize: Largeint): HResult; virtual; stdcall; abstract;
  end;

{ IMoniker interface }

  {$EXTERNALSYM IMoniker}
  IMoniker = class(IPersistStream)
  public
    function BindToObject(bc: IBindCtx; mkToLeft: IMoniker;
      const iidResult: TIID; var vResult): HResult; virtual; stdcall; abstract;
    function BindToStorage(bc: IBindCtx; mkToLeft: IMoniker;
      const iid: TIID; var vObj): HResult; virtual; stdcall; abstract;
    function Reduce(bc: IBindCtx; dwReduceHowFar: Longint;
      var mkToLeft: IMoniker; var mkReduced: IMoniker): HResult; virtual; stdcall; abstract;
    function ComposeWith(mkRight: IMoniker; fOnlyIfNotGeneric: BOOL;
      var mkComposite: IMoniker): HResult; virtual; stdcall; abstract;
    function Enum(fForward: BOOL; var enumMoniker: IEnumMoniker): HResult;
      virtual; stdcall; abstract;
    function IsEqual(mkOtherMoniker: IMoniker): HResult; virtual; stdcall; abstract;
    function Hash(var dwHash: Longint): HResult; virtual; stdcall; abstract;
    function IsRunning(bc: IBindCtx; mkToLeft: IMoniker;
      mkNewlyRunning: IMoniker): HResult; virtual; stdcall; abstract;
    function GetTimeOfLastChange(bc: IBindCtx; mkToLeft: IMoniker;
      var filetime: TFileTime): HResult; virtual; stdcall; abstract;
    function Inverse(var mk: IMoniker): HResult; virtual; stdcall; abstract;
    function CommonPrefixWith(mkOther: IMoniker;
      var mkPrefix: IMoniker): HResult; virtual; stdcall; abstract;
    function RelativePathTo(mkOther: IMoniker;
      var mkRelPath: IMoniker): HResult; virtual; stdcall; abstract;
    function GetDisplayName(bc: IBindCtx; mkToLeft: IMoniker;
      var pszDisplayName: POleStr): HResult; virtual; stdcall; abstract;
    function ParseDisplayName(bc: IBindCtx; mkToLeft: IMoniker;
      pszDisplayName: POleStr; var chEaten: Longint;
      var mkOut: IMoniker): HResult; virtual; stdcall; abstract;
    function IsSystemMoniker(var dwMksys: Longint): HResult; virtual; stdcall; abstract;
  end;

{ IEnumString interface }

  {$EXTERNALSYM IEnumString }
  IEnumString = class(IUnknown)
  public
    function Next(celt: Longint; var elt;
      pceltFetched: PLongint): HResult; virtual; stdcall; abstract;
    function Skip(celt: Longint): HResult; virtual; stdcall; abstract;
    function Reset: HResult; virtual; stdcall; abstract;
    function Clone(var enm: IEnumString): HResult; virtual; stdcall; abstract;
  end;

{ IStream interface }

  PStatStg = ^TStatStg;
  {$EXTERNALSYM tagSTATSTG}
  tagSTATSTG = record
    pwcsName: POleStr;
    dwType: Longint;
    cbSize: Largeint;
    mtime: TFileTime;
    ctime: TFileTime;
    atime: TFileTime;
    grfMode: Longint;
    grfLocksSupported: Longint;
    clsid: TCLSID;
    grfStateBits: Longint;
    reserved: Longint;
  end;
  TStatStg = tagSTATSTG;
  {$EXTERNALSYM STATSTG}
  STATSTG = tagSTATSTG;

  {$EXTERNALSYM IStream}
  IStream = class(IUnknown)
  public
    function Read(pv: Pointer; cb: Longint; pcbRead: PLongint): HResult;
      virtual; stdcall; abstract;
    function Write(pv: Pointer; cb: Longint; pcbWritten: PLongint): HResult;
      virtual; stdcall; abstract;
    function Seek(dlibMove: Largeint; dwOrigin: Longint;
      var libNewPosition: Largeint): HResult; virtual; stdcall; abstract;
    function SetSize(libNewSize: Largeint): HResult; virtual; stdcall; abstract;
    function CopyTo(stm: IStream; cb: Largeint; var cbRead: Largeint;
      var cbWritten: Largeint): HResult; virtual; stdcall; abstract;
    function Commit(grfCommitFlags: Longint): HResult; virtual; stdcall; abstract;
    function Revert: HResult; virtual; stdcall; abstract;
    function LockRegion(libOffset: Largeint; cb: Largeint;
      dwLockType: Longint): HResult; virtual; stdcall; abstract;
    function UnlockRegion(libOffset: Largeint; cb: Largeint;
      dwLockType: Longint): HResult; virtual; stdcall; abstract;
    function Stat(var statstg: TStatStg; grfStatFlag: Longint): HResult;
      virtual; stdcall; abstract;
    function Clone(var stm: IStream): HResult; virtual; stdcall; abstract;
  end;

{ IEnumStatStg interface }

  {$EXTERNALSYM IEnumStatStg }
  IEnumStatStg = class(IUnknown)
  public
    function Next(celt: Longint; var elt;
      pceltFetched: PLongint): HResult; virtual; stdcall; abstract;
    function Skip(celt: Longint): HResult; virtual; stdcall; abstract;
    function Reset: HResult; virtual; stdcall; abstract;
    function Clone(var enm: IEnumStatStg): HResult; virtual; stdcall; abstract;
  end;

{ IStorage interface }

  TSNB = ^POleStr;

  {$EXTERNALSYM IStorage}
  IStorage = class(IUnknown)
  public
    function CreateStream(pwcsName: POleStr; grfMode: Longint; reserved1: Longint;
      reserved2: Longint; var stm: IStream): HResult; virtual; stdcall; abstract;
    function OpenStream(pwcsName: POleStr; reserved1: Pointer; grfMode: Longint;
      reserved2: Longint; var stm: IStream): HResult; virtual; stdcall; abstract;
    function CreateStorage(pwcsName: POleStr; grfMode: Longint;
      dwStgFmt: Longint; reserved2: Longint; var stg: IStorage): HResult;
      virtual; stdcall; abstract;
    function OpenStorage(pwcsName: POleStr; stgPriority: IStorage;
      grfMode: Longint; snbExclude: TSNB; reserved: Longint;
      var stg: IStorage): HResult; virtual; stdcall; abstract;
    function CopyTo(ciidExclude: Longint; rgiidExclude: PIID;
      snbExclude: TSNB; stgDest: IStorage): HResult; virtual; stdcall; abstract;
    function MoveElementTo(pwcsName: POleStr; stgDest: IStorage;
      pwcsNewName: POleStr; grfFlags: Longint): HResult; virtual; stdcall; abstract;
    function Commit(grfCommitFlags: Longint): HResult; virtual; stdcall; abstract;
    function Revert: HResult; virtual; stdcall; abstract;
    function EnumElements(reserved1: Longint; reserved2: Pointer; reserved3: Longint;
      var enm: IEnumStatStg): HResult; virtual; stdcall; abstract;
    function DestroyElement(pwcsName: POleStr): HResult; virtual; stdcall; abstract;
    function RenameElement(pwcsOldName: POleStr;
      pwcsNewName: POleStr): HResult; virtual; stdcall; abstract;
    function SetElementTimes(pwcsName: POleStr; const ctime: TFileTime;
      const atime: TFileTime; const mtime: TFileTime): HResult;
      virtual; stdcall; abstract;
    function SetClass(const clsid: TCLSID): HResult; virtual; stdcall; abstract;
    function SetStateBits(grfStateBits: Longint; grfMask: Longint): HResult;
      virtual; stdcall; abstract;
    function Stat(var statstg: TStatStg; grfStatFlag: Longint): HResult;
      virtual; stdcall; abstract;
  end;

{ IPersistFile interface }

  {$EXTERNALSYM IPersistFile }
  IPersistFile = class(IPersist)
  public
    function IsDirty: HResult; virtual; stdcall; abstract;
    function Load(pszFileName: POleStr; dwMode: Longint): HResult;
      virtual; stdcall; abstract;
    function Save(pszFileName: POleStr; fRemember: BOOL): HResult;
      virtual; stdcall; abstract;
    function SaveCompleted(pszFileName: POleStr): HResult;
      virtual; stdcall; abstract;
    function GetCurFile(var pszFileName: POleStr): HResult;
      virtual; stdcall; abstract;
  end;

{ IPersistStorage interface }

  {$EXTERNALSYM IPersistStorage }
  IPersistStorage = class(IPersist)
  public
    function IsDirty: HResult; virtual; stdcall; abstract;
    function InitNew(stg: IStorage): HResult; virtual; stdcall; abstract;
    function Load(stg: IStorage): HResult; virtual; stdcall; abstract;
    function Save(stgSave: IStorage; fSameAsLoad: BOOL): HResult;
      virtual; stdcall; abstract;
    function SaveCompleted(stgNew: IStorage): HResult; virtual; stdcall; abstract;
    function HandsOffStorage: HResult; virtual; stdcall; abstract;
  end;

{ ILockBytes interface }

  {$EXTERNALSYM ILockBytes}
  ILockBytes = class(IUnknown)
  public
    function ReadAt(ulOffset: Largeint; pv: Pointer; cb: Longint;
      pcbRead: PLongint): HResult; virtual; stdcall; abstract;
    function WriteAt(ulOffset: Largeint; pv: Pointer; cb: Longint;
      pcbWritten: PLongint): HResult; virtual; stdcall; abstract;
    function Flush: HResult; virtual; stdcall; abstract;
    function SetSize(cb: Largeint): HResult; virtual; stdcall; abstract;
    function LockRegion(libOffset: Largeint; cb: Largeint;
      dwLockType: Longint): HResult; virtual; stdcall; abstract;
    function UnlockRegion(libOffset: Largeint; cb: Largeint;
      dwLockType: Longint): HResult; virtual; stdcall; abstract;
    function Stat(var statstg: TStatStg; grfStatFlag: Longint): HResult;
      virtual; stdcall; abstract;
  end;

{ IEnumFormatEtc interface }

  PDVTargetDevice = ^TDVTargetDevice;
  {$EXTERNALSYM tagDVTARGETDEVICE}
  tagDVTARGETDEVICE = record
    tdSize: Longint;
    tdDriverNameOffset: Word;
    tdDeviceNameOffset: Word;
    tdPortNameOffset: Word;
    tdExtDevmodeOffset: Word;
    tdData: record end;
  end;
  TDVTargetDevice = tagDVTARGETDEVICE;
  {$EXTERNALSYM DVTARGETDEVICE}
  DVTARGETDEVICE = tagDVTARGETDEVICE;

  PClipFormat = ^TClipFormat;
  TClipFormat = Word;

  PFormatEtc = ^TFormatEtc;
  {$EXTERNALSYM tagFORMATETC}
  tagFORMATETC = record
    cfFormat: TClipFormat;
    ptd: PDVTargetDevice;
    dwAspect: Longint;
    lindex: Longint;
    tymed: Longint;
  end;
  TFormatEtc = tagFORMATETC;
  {$EXTERNALSYM FORMATETC}
  FORMATETC = tagFORMATETC;

  {$EXTERNALSYM IEnumFormatEtc }
  IEnumFormatEtc = class(IUnknown)
  public
    function Next(celt: Longint; var elt;
      pceltFetched: PLongint): HResult; virtual; stdcall; abstract;
    function Skip(celt: Longint): HResult; virtual; stdcall; abstract;
    function Reset: HResult; virtual; stdcall; abstract;
    function Clone(var Enum: IEnumFormatEtc): HResult; virtual; stdcall; abstract;
  end;

{ IEnumStatData interface }

  PStatData = ^TStatData;
  {$EXTERNALSYM tagSTATDATA}
  tagSTATDATA = record
    formatetc: TFormatEtc;
    advf: Longint;
    advSink: IAdviseSink;
    dwConnection: Longint;
  end;
  TStatData = tagSTATDATA;
  {$EXTERNALSYM STATDATA}
  STATDATA = tagSTATDATA;

  {$EXTERNALSYM IEnumStatData }
  IEnumStatData = class(IUnknown)
  public
    function Next(celt: Longint; var elt;
      pceltFetched: PLongint): HResult; virtual; stdcall; abstract;
    function Skip(celt: Longint): HResult; virtual; stdcall; abstract;
    function Reset: HResult; virtual; stdcall; abstract;
    function Clone(var Enum: IEnumStatData): HResult; virtual; stdcall; abstract;
  end;

{ IRootStorage interface }

  {$EXTERNALSYM IRootStorage }
  IRootStorage = class(IUnknown)
  public
    function SwitchToFile(pszFile: POleStr): HResult; virtual; stdcall; abstract;
  end;

{ IAdviseSink interface }

  PRemStgMedium = ^TRemStgMedium;
  {$EXTERNALSYM tagRemSTGMEDIUM}
  tagRemSTGMEDIUM = record
    tymed: Longint;
    dwHandleType: Longint;
    pData: Longint;
    pUnkForRelease: Longint;
    cbData: Longint;
    data: record end;
  end;
  TRemStgMedium = tagRemSTGMEDIUM;
  {$EXTERNALSYM RemSTGMEDIUM}
  RemSTGMEDIUM = tagRemSTGMEDIUM;

  PStgMedium = ^TStgMedium;
  {$EXTERNALSYM tagSTGMEDIUM}
  tagSTGMEDIUM = record
    tymed: Longint;
    case Integer of
      0: (hBitmap: HBitmap; unkForRelease: IUnknown);
      1: (hMetaFilePict: THandle);
      2: (hEnhMetaFile: THandle);
      3: (hGlobal: HGlobal);
      4: (lpszFileName: POleStr);
      5: (stm: IStream);
      6: (stg: IStorage);
  end;
  TStgMedium = tagSTGMEDIUM;
  {$EXTERNALSYM STGMEDIUM}
  STGMEDIUM = tagSTGMEDIUM;

  {$EXTERNALSYM IAdviseSink}
  IAdviseSink = class(IUnknown)
  public
    procedure OnDataChange(var formatetc: TFormatEtc; var stgmed: TStgMedium);
      virtual; stdcall; abstract;
    procedure OnViewChange(dwAspect: Longint; lindex: Longint);
      virtual; stdcall; abstract;
    procedure OnRename(mk: IMoniker); virtual; stdcall; abstract;
    procedure OnSave; virtual; stdcall; abstract;
    procedure OnClose; virtual; stdcall; abstract;
  end;

{ IAdviseSink2 interface }

  {$EXTERNALSYM IAdviseSink2 }
  IAdviseSink2 = class(IAdviseSink)
  public
    procedure OnLinkSrcChange(mk: IMoniker); virtual; stdcall; abstract;
  end;

{ IDataObject interface }

  {$EXTERNALSYM IDataObject}
  IDataObject = class(IUnknown)
  public
    function GetData(var formatetcIn: TFormatEtc; var medium: TStgMedium):
      HResult; virtual; stdcall; abstract;
    function GetDataHere(var formatetc: TFormatEtc; var medium: TStgMedium):
      HResult; virtual; stdcall; abstract;
    function QueryGetData(var formatetc: TFormatEtc): HResult;
      virtual; stdcall; abstract;
    function GetCanonicalFormatEtc(var formatetc: TFormatEtc;
      var formatetcOut: TFormatEtc): HResult; virtual; stdcall; abstract;
    function SetData(var formatetc: TFormatEtc; var medium: TStgMedium;
      fRelease: BOOL): HResult; virtual; stdcall; abstract;
    function EnumFormatEtc(dwDirection: Longint; var enumFormatEtc:
      IEnumFormatEtc): HResult; virtual; stdcall; abstract;
    function DAdvise(var formatetc: TFormatEtc; advf: Longint;
      advSink: IAdviseSink; var dwConnection: Longint): HResult; virtual; stdcall; abstract;
    function DUnadvise(dwConnection: Longint): HResult; virtual; stdcall; abstract;
    function EnumDAdvise(var enumAdvise: IEnumStatData): HResult;
      virtual; stdcall; abstract;
  end;

{ IDataAdviseHolder interface }

  {$EXTERNALSYM IDataAdviseHolder }
  IDataAdviseHolder = class(IUnknown)
  public
    function Advise(dataObject: IDataObject; var fetc: TFormatEtc;
      advf: Longint; advise: IAdviseSink; var pdwConnection: Longint): HResult;
      virtual; stdcall; abstract;
    function Unadvise(dwConnection: Longint): HResult; virtual; stdcall; abstract;
    function EnumAdvise(var enumAdvise: IEnumStatData): HResult; virtual; stdcall; abstract;
    function SendOnDataChange(dataObject: IDataObject; dwReserved: Longint;
      advf: Longint): HResult; virtual; stdcall; abstract;
  end;

{ IMessageFilter interface }

  PInterfaceInfo = ^TInterfaceInfo;
  {$EXTERNALSYM tagINTERFACEINFO}
  tagINTERFACEINFO = record
    unk: IUnknown;
    iid: TIID;
    wMethod: Word;
  end;
  TInterfaceInfo = tagINTERFACEINFO;
  {$EXTERNALSYM INTERFACEINFO}
  INTERFACEINFO = tagINTERFACEINFO;

  {$EXTERNALSYM IMessageFilter }
  IMessageFilter = class(IUnknown)
  public
    function HandleInComingCall(dwCallType: Longint; htaskCaller: HTask;
      dwTickCount: Longint; lpInterfaceInfo: PInterfaceInfo): Longint;
      virtual; stdcall; abstract;
    function RetryRejectedCall(htaskCallee: HTask; dwTickCount: Longint;
      dwRejectType: Longint): Longint; virtual; stdcall; abstract;
    function MessagePending(htaskCallee: HTask; dwTickCount: Longint;
      dwPendingType: Longint): Longint; virtual; stdcall; abstract;
  end;

{ IRpcChannelBuffer interface }

  TRpcOleDataRep = Longint;

  PRpcOleMessage = ^TRpcOleMessage;
  {$EXTERNALSYM tagRPCOLEMESSAGE}
  tagRPCOLEMESSAGE = record
    reserved1: Pointer;
    dataRepresentation: TRpcOleDataRep;
    Buffer: Pointer;
    cbBuffer: Longint;
    iMethod: Longint;
    reserved2: array[0..4] of Pointer;
    rpcFlags: Longint;
  end;
  TRpcOleMessage = tagRPCOLEMESSAGE;
  {$EXTERNALSYM RPCOLEMESSAGE}
  RPCOLEMESSAGE = tagRPCOLEMESSAGE;

  {$EXTERNALSYM IRpcChannelBuffer }
  IRpcChannelBuffer = class(IUnknown)
  public
    function GetBuffer(var message: TRpcOleMessage; iid: TIID): HResult;
      virtual; stdcall; abstract;
    function SendReceive(var message: TRpcOleMessage;
      var status: Longint): HResult; virtual; stdcall; abstract;
    function FreeBuffer(var message: TRpcOleMessage): HResult;
      virtual; stdcall; abstract;
    function GetDestCtx(var dwDestContext: Longint;
      var pvDestContext): HResult; virtual; stdcall; abstract;
    function IsConnected: HResult; virtual; stdcall; abstract;
  end;

{ IRpcProxyBuffer interface }

  {$EXTERNALSYM IRpcProxyBuffer }
  IRpcProxyBuffer = class(IUnknown)
  public
    function Connect(rpcChannelBuffer: IRpcChannelBuffer): HResult;
      virtual; stdcall; abstract;
    procedure Disconnect; virtual; stdcall; abstract;
  end;

{ IRpcStubBuffer interface }

  {$EXTERNALSYM IRpcStubBuffer }
  IRpcStubBuffer = class(IUnknown)
  public
    function Connect(unkServer: IUnknown): HResult; virtual; stdcall; abstract;
    procedure Disconnect; virtual; stdcall; abstract;
    function Invoke(var rpcmsg: TRpcOleMessage; rpcChannelBuffer:
      IRpcChannelBuffer): HResult; virtual; stdcall; abstract;
    function IsIIDSupported(const iid: TIID): IRpcStubBuffer;
      virtual; stdcall; abstract;
    function CountRefs: Longint; virtual; stdcall; abstract;
    function DebugServerQueryInterface(var pv): HResult;
      virtual; stdcall; abstract;
    procedure DebugServerRelease(pv: Pointer); virtual; stdcall; abstract;
  end;

{ IPSFactoryBuffer interface }

  {$EXTERNALSYM IPSFactoryBuffer }
  IPSFactoryBuffer = class(IUnknown)
  public
    function CreateProxy(unkOuter: IUnknown; const iid: TIID;
      var proxy: IRpcProxyBuffer; var pv): HResult; virtual; stdcall; abstract;
    function CreateStub(const iid: TIID; unkServer: IUnknown;
      var stub: IRpcStubBuffer): HResult; virtual; stdcall; abstract;
  end;

{ Automation types }

  PBStr = ^TBStr;
  TBStr = POleStr;

  PBStrList = ^TBStrList;
  TBStrList = array[0..65535] of TBStr;

  PBlob = ^TBlob;
  {$EXTERNALSYM tagBLOB}
  tagBLOB = record
    cbSize: Longint;
    pBlobData: Pointer;
  end;
  {$EXTERNALSYM TBlob}
  TBlob = tagBLOB;
  {$EXTERNALSYM BLOB}
  BLOB = tagBLOB;

  PClipData = ^TClipData;
  {$EXTERNALSYM tagCLIPDATA}
  tagCLIPDATA = record
    cbSize: Longint;
    ulClipFmt: Longint;
    pClipData: Pointer;
  end;
  TClipData = tagCLIPDATA;
  {$EXTERNALSYM CLIPDATA}
  CLIPDATA = tagCLIPDATA;

  PSafeArrayBound = ^TSafeArrayBound;
  {$EXTERNALSYM tagSAFEARRAYBOUND}
  tagSAFEARRAYBOUND = record
    cElements: Longint;
    lLbound: Longint;
  end;
  TSafeArrayBound = tagSAFEARRAYBOUND;
  {$EXTERNALSYM SAFEARRAYBOUND}
  SAFEARRAYBOUND = tagSAFEARRAYBOUND;

  PSafeArray = ^TSafeArray;
  {$EXTERNALSYM tagSAFEARRAY}
  tagSAFEARRAY = record
    cDims: Word;
    fFeatures: Word;
    cbElements: Longint;
    cLocks: Longint;
    pvData: Pointer;
    rgsabound: array[0..0] of TSafeArrayBound;
  end;
  TSafeArray = tagSAFEARRAY;
  {$EXTERNALSYM SAFEARRAY}
  SAFEARRAY = tagSAFEARRAY;

  TOleDate = Double;

  TCurrency = Comp;

  TOleBool = WordBool;

  TVarType = Word;

  PVariantArg = ^TVariantArg;
  {$EXTERNALSYM tagVARIANT}
  tagVARIANT = record
    vt: TVarType;
    wReserved1: Word;
    wReserved2: Word;
    wReserved3: Word;
    case Integer of
      VT_UI1:                  (bVal: Byte);
      VT_I2:                   (iVal: Smallint);
      VT_I4:                   (lVal: Longint);
      VT_R4:                   (fltVal: Single);
      VT_R8:                   (dblVal: Double);
      VT_BOOL:                 (vbool: TOleBool);
      VT_ERROR:                (scode: HResult);
      VT_CY:                   (cyVal: TCurrency);
      VT_DATE:                 (date: TOleDate);
      VT_BSTR:                 (bstrVal: TBStr);
      VT_UNKNOWN:              (unkVal: IUnknown);
      VT_DISPATCH:             (dispVal: IDispatch);
      VT_ARRAY:                (parray: PSafeArray);
      VT_BYREF or VT_UI1:      (pbVal: ^Byte);
      VT_BYREF or VT_I2:       (piVal: ^Smallint);
      VT_BYREF or VT_I4:       (plVal: ^Longint);
      VT_BYREF or VT_R4:       (pfltVal: ^Single);
      VT_BYREF or VT_R8:       (pdblVal: ^Double);
      VT_BYREF or VT_BOOL:     (pbool: ^TOleBool);
      VT_BYREF or VT_ERROR:    (pscode: ^HResult);
      VT_BYREF or VT_CY:       (pcyVal: ^TCurrency);
      VT_BYREF or VT_DATE:     (pdate: ^TOleDate);
      VT_BYREF or VT_BSTR:     (pbstrVal: PBStr);
      VT_BYREF or VT_UNKNOWN:  (punkVal: ^IUnknown);
      VT_BYREF or VT_DISPATCH: (pdispVal: ^IDispatch);
      VT_BYREF or VT_ARRAY:    (pparray: ^PSafeArray);
      VT_BYREF or VT_VARIANT:  (pvarVal: PVariant);
      VT_BYREF:                (byRef: Pointer);
  end;
  TVariantArg = tagVARIANT;
  {$EXTERNALSYM VARIANTARG}
  VARIANTARG = tagVARIANT;

  PVariantArgList = ^TVariantArgList;
  TVariantArgList = array[0..65535] of TVariantArg;

  TDispID = Longint;

  PDispIDList = ^TDispIDList;
  TDispIDList = array[0..65535] of TDispID;

  TMemberID = Longint;

  PMemberIDList = ^TMemberIDList;
  TMemberIDList = array[0..65535] of TMemberID;

  TPropID = Longint;

  HRefType = Longint;

  TTypeKind = Longint;

  PArrayDesc = ^TArrayDesc;

  PTypeDesc= ^TTypeDesc;
  {$EXTERNALSYM tagTYPEDESC}
  tagTYPEDESC = record
    case Integer of
      VT_PTR:         (ptdesc: PTypeDesc; vt: TVarType);
      VT_CARRAY:      (padesc: PArrayDesc);
      VT_USERDEFINED: (hreftype: HRefType);
  end;
  TTypeDesc = tagTYPEDESC;
  {$EXTERNALSYM TYPEDESC}
  TYPEDESC = tagTYPEDESC;

  {$EXTERNALSYM tagARRAYDESC}
  tagARRAYDESC = record
    tdescElem: TTypeDesc;
    cDims: Word;
    rgbounds: array[0..0] of TSafeArrayBound;
  end;
  TArrayDesc = tagARRAYDESC;
  {$EXTERNALSYM ARRAYDESC}
  ARRAYDESC = tagARRAYDESC;

  PIDLDesc = ^TIDLDesc;
  {$EXTERNALSYM tagIDLDESC}
  tagIDLDESC = record
    dwReserved: Longint;
    wIDLFlags: Word;
  end;
  TIDLDesc = tagIDLDESC;
  {$EXTERNALSYM IDLDESC}
  IDLDESC = tagIDLDESC;

  PElemDesc = ^TElemDesc;
  {$EXTERNALSYM tagELEMDESC}
  tagELEMDESC = record
    tdesc: TTypeDesc;
    idldesc: TIDLDesc;
  end;
  TElemDesc = tagELEMDESC;
  {$EXTERNALSYM ELEMDESC}
  ELEMDESC = tagELEMDESC;

  PElemDescList = ^TElemDescList;
  TElemDescList = array[0..65535] of TElemDesc;

  PTypeAttr = ^TTypeAttr;
  {$EXTERNALSYM tagTYPEATTR}
  tagTYPEATTR = record
    guid: TGUID;
    lcid: TLCID;
    dwReserved: Longint;
    memidConstructor: TMemberID;
    memidDestructor: TMemberID;
    lpstrSchema: POleStr;
    cbSizeInstance: Longint;
    typekind: TTypeKind;
    cFuncs: Word;
    cVars: Word;
    cImplTypes: Word;
    cbSizeVft: Word;
    cbAlignment: Word;
    wTypeFlags: Word;
    wMajorVerNum: Word;
    wMinorVerNum: Word;
    tdescAlias: TTypeDesc;
    idldescType: TIDLDesc;
  end;
  TTypeAttr = tagTYPEATTR;
  {$EXTERNALSYM TYPEATTR}
  TYPEATTR = tagTYPEATTR;

  PDispParams = ^TDispParams;
  {$EXTERNALSYM tagDISPPARAMS}
  tagDISPPARAMS = record
    rgvarg: PVariantArgList;
    rgdispidNamedArgs: PDispIDList;
    cArgs: Longint;
    cNamedArgs: Longint;
  end;
  TDispParams = tagDISPPARAMS;
  {$EXTERNALSYM DISPPARAMS}
  DISPPARAMS = tagDISPPARAMS;

  PExcepInfo = ^TExcepInfo;

  TFNDeferredFillIn = function(ExInfo: PExcepInfo): HResult stdcall;

  {$EXTERNALSYM tagEXCEPINFO}
  tagEXCEPINFO = record
    wCode: Word;
    wReserved: Word;
    bstrSource: TBStr;
    bstrDescription: TBStr;
    bstrHelpFile: TBStr;
    dwHelpContext: Longint;
    pvReserved: Pointer;
    pfnDeferredFillIn: TFNDeferredFillIn;
    scode: HResult;
  end;
  TExcepInfo = tagEXCEPINFO;
  {$EXTERNALSYM EXCEPINFO}
  EXCEPINFO = tagEXCEPINFO;

  TFuncKind = Longint;
  TInvokeKind = Longint;
  TCallConv = Longint;

  PFuncDesc = ^TFuncDesc;
  {$EXTERNALSYM tagFUNCDESC}
  tagFUNCDESC = record
    memid: TMemberID;
    lprgscode: PResultList;
    lprgelemdescParam: PElemDescList;
    funckind: TFuncKind;
    invkind: TInvokeKind;
    callconv: TCallConv;
    cParams: Smallint;
    cParamsOpt: Smallint;
    oVft: Smallint;
    cScodes: Smallint;
    elemdescFunc: TElemDesc;
    wFuncFlags: Word;
  end;
  TFuncDesc = tagFUNCDESC;
  {$EXTERNALSYM FUNCDESC}
  FUNCDESC = tagFUNCDESC;

  TVarKind = Longint;

  PVarDesc = ^TVarDesc;
  {$EXTERNALSYM tagVARDESC}
  tagVARDESC = record
    memid: TMemberID;
    lpstrSchema: POleStr;
    case Integer of
      VAR_PERINSTANCE: (
        oInst: Longint;
        elemdescVar: TElemDesc;
        wVarFlags: Word;
        varkind: TVarKind);
      VAR_CONST: (
        lpvarValue: PVariant);
  end;
  TVarDesc = tagVARDESC;
  {$EXTERNALSYM VARDESC}
  VARDESC = tagVARDESC;

{ ICreateTypeInfo interface }

  {$EXTERNALSYM ICreateTypeInfo }
  ICreateTypeInfo = class(IUnknown)
  public
    function SetGuid(const guid: TGUID): HResult; virtual; stdcall; abstract;
    function SetTypeFlags(uTypeFlags: Integer): HResult; virtual; stdcall; abstract;
    function SetDocString(pstrDoc: POleStr): HResult; virtual; stdcall; abstract;
    function SetHelpContext(dwHelpContext: Longint): HResult; virtual; stdcall; abstract;
    function SetVersion(wMajorVerNum: Word; wMinorVerNum: Word): HResult;
      virtual; stdcall; abstract;
    function AddRefTypeInfo(tinfo: ITypeInfo; var reftype: HRefType): HResult;
      virtual; stdcall; abstract;
    function AddFuncDesc(index: Integer; var funcdesc: TFuncDesc): HResult;
      virtual; stdcall; abstract;
    function AddImplType(index: Integer; reftype: HRefType): HResult;
      virtual; stdcall; abstract;
    function SetImplTypeFlags(index: Integer; impltypeflags: Integer): HResult;
      virtual; stdcall; abstract;
    function SetAlignment(cbAlignment: Word): HResult; virtual; stdcall; abstract;
    function SetSchema(lpstrSchema: POleStr): HResult; virtual; stdcall; abstract;
    function AddVarDesc(index: Integer; var vardesc: TVarDesc): HResult;
      virtual; stdcall; abstract;
    function SetFuncAndParamNames(index: Integer; rgszNames: POleStrList;
      cNames: Integer): HResult; virtual; stdcall; abstract;
    function SetVarName(index: Integer; szName: POleStr): HResult; virtual; stdcall; abstract;
    function SetTypeDescAlias(var descAlias: TTypeDesc): HResult; virtual; stdcall; abstract;
    function DefineFuncAsDllEntry(index: Integer; szDllName: POleStr;
      szProcName: POleStr): HResult; virtual; stdcall; abstract;
    function SetFuncDocString(index: Integer; szDocString: POleStr): HResult;
      virtual; stdcall; abstract;
    function SetVarDocString(index: Integer; szDocString: POleStr): HResult;
      virtual; stdcall; abstract;
    function SetFuncHelpContext(index: Integer; dwHelpContext: Longint): HResult;
      virtual; stdcall; abstract;
    function SetVarHelpContext(index: Integer; dwHelpContext: Longint): HResult;
      virtual; stdcall; abstract;
    function SetMops(index: Integer; bstrMops: TBStr): HResult; virtual; stdcall; abstract;
    function SetTypeIdldesc(var idldesc: TIDLDesc): HResult; virtual; stdcall; abstract;
    function LayOut: HResult; virtual; stdcall; abstract;
  end;

{ ICreateTypeLib interface }

  {$EXTERNALSYM ICreateTypeLib }
  ICreateTypeLib = class(IUnknown)
  public
    function CreateTypeInfo(szName: POleStr; tkind: TTypeKind;
      var ictinfo: ICreateTypeInfo): HResult; virtual; stdcall; abstract;
    function SetName(szName: POleStr): HResult; virtual; stdcall; abstract;
    function SetVersion(wMajorVerNum: Word; wMinorVerNum: Word): HResult; virtual; stdcall; abstract;
    function SetGuid(const guid: TGUID): HResult; virtual; stdcall; abstract;
    function SetDocString(szDoc: POleStr): HResult; virtual; stdcall; abstract;
    function SetHelpFileName(szHelpFileName: POleStr): HResult; virtual; stdcall; abstract;
    function SetHelpContext(dwHelpContext: Longint): HResult; virtual; stdcall; abstract;
    function SetLcid(lcid: TLCID): HResult; virtual; stdcall; abstract;
    function SetLibFlags(uLibFlags: Integer): HResult; virtual; stdcall; abstract;
    function SaveAllChanges: HResult; virtual; stdcall; abstract;
  end;

{ IDispatch interface }

  {$EXTERNALSYM IDispatch }
  IDispatch = class(IUnknown)
  public
    function GetTypeInfoCount(var ctinfo: Integer): HResult; virtual; stdcall; abstract;
    function GetTypeInfo(itinfo: Integer; lcid: TLCID; var tinfo: ITypeInfo): HResult; virtual; stdcall; abstract;
    function GetIDsOfNames(const iid: TIID; rgszNames: POleStrList;
      cNames: Integer; lcid: TLCID; rgdispid: PDispIDList): HResult; virtual; stdcall; abstract;
    function Invoke(dispIDMember: TDispID; const iid: TIID; lcid: TLCID;
      flags: Word; var dispParams: TDispParams; varResult: PVariant;
      excepInfo: PExcepInfo; argErr: PInteger): HResult; virtual; stdcall; abstract;
  end;

{ IEnumVariant interface }

  {$EXTERNALSYM IEnumVariant }
  IEnumVariant = class(IUnknown)
  public
    function Next(celt: Longint; var elt;
      var pceltFetched: Longint): HResult; virtual; stdcall; abstract;
    function Skip(celt: Longint): HResult; virtual; stdcall; abstract;
    function Reset: HResult; virtual; stdcall; abstract;
    function Clone(var Enum: IEnumVariant): HResult; virtual; stdcall; abstract;
  end;

{ ITypeComp interface }

  TDescKind = Longint;

  PBindPtr = ^TBindPtr;
  {$EXTERNALSYM tagBINDPTR}
  tagBINDPTR = record
    case Integer of
      0: (lpfuncdesc: PFuncDesc);
      1: (lpvardesc: PVarDesc);
      2: (lptcomp: ITypeComp);
  end;
  TBindPtr = tagBINDPTR;
  {$EXTERNALSYM BINDPTR}
  BINDPTR = tagBINDPTR;

  {$EXTERNALSYM ITypeComp }
  ITypeComp = class(IUnknown)
  public
    function Bind(szName: POleStr; lHashVal: Longint; wflags: Word;
      var tinfo: ITypeInfo; var desckind: TDescKind;
      var bindptr: TBindPtr): HResult; virtual; stdcall; abstract;
    function BindType(szName: POleStr; lHashVal: Longint;
      var tinfo: ITypeInfo; var tcomp: ITypeComp): HResult;
      virtual; stdcall; abstract;
  end;

{ ITypeInfo interface }

  {$EXTERNALSYM ITypeInfo}
  ITypeInfo = class(IUnknown)
  public
    function GetTypeAttr(var ptypeattr: PTypeAttr): HResult; virtual; stdcall; abstract;
    function GetTypeComp(var tcomp: ITypeComp): HResult; virtual; stdcall; abstract;
    function GetFuncDesc(index: Integer; var pfuncdesc: PFuncDesc): HResult;
      virtual; stdcall; abstract;
    function GetVarDesc(index: Integer; var pvardesc: PVarDesc): HResult;
      virtual; stdcall; abstract;
    function GetNames(memid: TMemberID; rgbstrNames: PBStrList;
      cMaxNames: Integer; var cNames: Integer): HResult; virtual; stdcall; abstract;
    function GetRefTypeOfImplType(index: Integer; var reftype: HRefType): HResult;
      virtual; stdcall; abstract;
    function GetImplTypeFlags(index: Integer; var impltypeflags: Integer): HResult;
      virtual; stdcall; abstract;
    function GetIDsOfNames(rgpszNames: POleStrList; cNames: Integer;
      rgmemid: PMemberIDList): HResult; virtual; stdcall; abstract;
    function Invoke(pvInstance: Pointer; memid: TMemberID; flags: Word;
      var dispParams: TDispParams; varResult: PVariant;
      excepInfo: PExcepInfo; argErr: PInteger): HResult; virtual; stdcall; abstract;
    function GetDocumentation(memid: TMemberID; pbstrName: PBStr;
      pbstrDocString: PBStr; pdwHelpContext: PLongint;
      pbstrHelpFile: PBStr): HResult; virtual; stdcall; abstract;
    function GetDllEntry(memid: TMemberID; invkind: TInvokeKind;
      var bstrDllName: TBStr; var bstrName: TBStr; var wOrdinal: Word): HResult;
      virtual; stdcall; abstract;
    function GetRefTypeInfo(reftype: HRefType; var tinfo: ITypeInfo): HResult;
      virtual; stdcall; abstract;
    function AddressOfMember(memid: TMemberID; invkind: TInvokeKind;
      var ppv: Pointer): HResult; virtual; stdcall; abstract;
    function CreateInstance(unkOuter: IUnknown; const iid: TIID;
      var vObj): HResult; virtual; stdcall; abstract;
    function GetMops(memid: TMemberID; var bstrMops: TBStr): HResult;
      virtual; stdcall; abstract;
    function GetContainingTypeLib(var tlib: ITypeLib; var pindex: Integer): HResult;
      virtual; stdcall; abstract;
    procedure ReleaseTypeAttr(ptypeattr: PTypeAttr); virtual; stdcall; abstract;
    procedure ReleaseFuncDesc(pfuncdesc: PFuncDesc); virtual; stdcall; abstract;
    procedure ReleaseVarDesc(pvardesc: PVarDesc); virtual; stdcall; abstract;
  end;

{ ITypeLib interface }

  TSysKind = Longint;

  PTLibAttr = ^TTLibAttr;
  {$EXTERNALSYM tagTLIBATTR}
  tagTLIBATTR = record
    guid: TGUID;
    lcid: TLCID;
    syskind: TSysKind;
    wMajorVerNum: Word;
    wMinorVerNum: Word;
    wLibFlags: Word;
  end;
  TTLibAttr = tagTLIBATTR;
  {$EXTERNALSYM TLIBATTR}
  TLIBATTR = tagTLIBATTR;

  PTypeInfoList = ^TTypeInfoList;
  TTypeInfoList = array[0..65535] of ITypeInfo;

  {$EXTERNALSYM ITypeLib}
  ITypeLib = class(IUnknown)
  public
    function GetTypeInfoCount: Integer; virtual; stdcall; abstract;
    function GetTypeInfo(index: Integer; var tinfo: ITypeInfo): HResult; virtual; stdcall; abstract;
    function GetTypeInfoType(index: Integer; var tkind: TTypeKind): HResult;
      virtual; stdcall; abstract;
    function GetTypeInfoOfGuid(const guid: TGUID; var tinfo: ITypeInfo): HResult;
      virtual; stdcall; abstract;
    function GetLibAttr(var ptlibattr: PTLibAttr): HResult; virtual; stdcall; abstract;
    function GetTypeComp(var tcomp: ITypeComp): HResult; virtual; stdcall; abstract;
    function GetDocumentation(index: Integer; pbstrName: PBStr;
      pbstrDocString: PBStr; pdwHelpContext: PLongint;
      pbstrHelpFile: PBStr): HResult; virtual; stdcall; abstract;
    function IsName(szNameBuf: POleStr; lHashVal: Longint; var fName: BOOL): HResult;
      virtual; stdcall; abstract;
    function FindName(szNameBuf: POleStr; lHashVal: Longint;
      rgptinfo: PTypeInfoList; rgmemid: PMemberIDList;
      var pcFound: Word): HResult; virtual; stdcall; abstract;
    procedure ReleaseTLibAttr(ptlibattr: PTLibAttr); virtual; stdcall; abstract;
  end;

{ IErrorInfo interface }

  {$EXTERNALSYM IErrorInfo }
  IErrorInfo = class(IUnknown)
  public
    function GetGUID(var guid: TGUID): HResult; virtual; stdcall; abstract;
    function GetSource(var bstrSource: TBStr): HResult; virtual; stdcall; abstract;
    function GetDescription(var bstrDescription: TBStr): HResult; virtual; stdcall; abstract;
    function GetHelpFile(var bstrHelpFile: TBStr): HResult; virtual; stdcall; abstract;
    function GetHelpContext(var dwHelpContext: Longint): HResult; virtual; stdcall; abstract;
  end;

{ ICreateErrorInfo interface }

  {$EXTERNALSYM ICreateErrorInfo }
  ICreateErrorInfo = class(IUnknown)
  public
    function SetGUID(const guid: TGUID): HResult; virtual; stdcall; abstract;
    function SetSource(szSource: POleStr): HResult; virtual; stdcall; abstract;
    function SetDescription(szDescription: POleStr): HResult; virtual; stdcall; abstract;
    function SetHelpFile(szHelpFile: POleStr): HResult; virtual; stdcall; abstract;
    function SetHelpContext(dwHelpContext: Longint): HResult; virtual; stdcall; abstract;
  end;

{ ISupportErrorInfo interface }

  {$EXTERNALSYM ISupportErrorInfo }
  ISupportErrorInfo = class(IUnknown)
  public
    function InterfaceSupportsErrorInfo(const iid: TIID): HResult; virtual; stdcall; abstract;
  end;

{ IDispatch implementation support }

  PParamData = ^TParamData;
  {$EXTERNALSYM tagPARAMDATA}
  tagPARAMDATA = record
    szName: POleStr;
    vt: TVarType;
  end;
  TParamData = tagPARAMDATA;
  {$EXTERNALSYM PARAMDATA}
  PARAMDATA = tagPARAMDATA;

  PParamDataList = ^TParamDataList;
  TParamDataList = array[0..65535] of TParamData;

  PMethodData = ^TMethodData;
  {$EXTERNALSYM tagMETHODDATA}
  tagMETHODDATA = record
    szName: POleStr;
    ppdata: PParamDataList;
    dispid: TDispID;
    iMeth: Integer;
    cc: TCallConv;
    cArgs: Integer;
    wFlags: Word;
    vtReturn: TVarType;
  end;
  TMethodData = tagMETHODDATA;
  {$EXTERNALSYM METHODDATA}
  METHODDATA = tagMETHODDATA;

  PMethodDataList = ^TMethodDataList;
  TMethodDataList = array[0..65535] of TMethodData;

  PInterfaceData = ^TInterfaceData;
  {$EXTERNALSYM tagINTERFACEDATA}
  tagINTERFACEDATA = record
    pmethdata: PMethodDataList;
    cMembers: Integer;
  end;
  TInterfaceData = tagINTERFACEDATA;
  {$EXTERNALSYM INTERFACEDATA}
  INTERFACEDATA = tagINTERFACEDATA;

{ IOleAdviseHolder interface }

  {$EXTERNALSYM IOleAdviseHolder}
  IOleAdviseHolder = class(IUnknown)
  public
    function Advise(advise: IAdviseSink; var dwConnection: Longint): HResult;
      virtual; stdcall; abstract;
    function Unadvise(dwConnection: Longint): HResult; virtual; stdcall; abstract;
    function EnumAdvise(var enumAdvise: IEnumStatData): HResult; virtual; stdcall; abstract;
    function SendOnRename(mk: IMoniker): HResult; virtual; stdcall; abstract;
    function SendOnSave: HResult; virtual; stdcall; abstract;
    function SendOnClose: HResult; virtual; stdcall; abstract;
  end;

{ IOleCache interface }

  {$EXTERNALSYM IOleCache }
  IOleCache = class(IUnknown)
  public
    function Cache(var formatetc: TFormatEtc; advf: Longint;
      var dwConnection: Longint): HResult; virtual; stdcall; abstract;
    function Uncache(dwConnection: Longint): HResult; virtual; stdcall; abstract;
    function EnumCache(var enumStatData: IEnumStatData): HResult;
      virtual; stdcall; abstract;
    function InitCache(dataObject: IDataObject): HResult; virtual; stdcall; abstract;
    function SetData(var formatetc: TFormatEtc; var medium: TStgMedium;
      fRelease: BOOL): HResult; virtual; stdcall; abstract;
  end;

{ IOleCache2 interface }

  {$EXTERNALSYM IOleCache2 }
  IOleCache2 = class(IOleCache)
  public
    function UpdateCache(dataObject: IDataObject; grfUpdf: Longint;
      pReserved: Pointer): HResult; virtual; stdcall; abstract;
    function DiscardCache(dwDiscardOptions: Longint): HResult; virtual; stdcall; abstract;
  end;

{ IOleCacheControl interface }

  {$EXTERNALSYM IOleCacheControl }
  IOleCacheControl = class(IUnknown)
  public
    function OnRun(dataObject: IDataObject): HResult; virtual; stdcall; abstract;
    function OnStop: HResult; virtual; stdcall; abstract;
  end;

{ IParseDisplayName interface }

  {$EXTERNALSYM IParseDisplayName }
  IParseDisplayName = class(IUnknown)
  public
    function ParseDisplayName(bc: IBindCtx; pszDisplayName: POleStr;
      var chEaten: Longint; var mkOut: IMoniker): HResult; virtual; stdcall; abstract;
  end;

{ IOleContainer interface }

  {$EXTERNALSYM IOleContainer}
  IOleContainer = class(IParseDisplayName)
  public
    function EnumObjects(grfFlags: Longint; var Enum: IEnumUnknown): HResult;
      virtual; stdcall; abstract;
    function LockContainer(fLock: BOOL): HResult; virtual; stdcall; abstract;
  end;

{ IOleClientSite interface }

  {$EXTERNALSYM IOleClientSite}
  IOleClientSite = class(IUnknown)
  public
    function SaveObject: HResult; virtual; stdcall; abstract;
    function GetMoniker(dwAssign: Longint; dwWhichMoniker: Longint;
      var mk: IMoniker): HResult; virtual; stdcall; abstract;
    function GetContainer(var container: IOleContainer): HResult; virtual; stdcall; abstract;
    function ShowObject: HResult; virtual; stdcall; abstract;
    function OnShowWindow(fShow: BOOL): HResult; virtual; stdcall; abstract;
    function RequestNewObjectLayout: HResult; virtual; stdcall; abstract;
  end;

{ IOleObject interface }

  {$EXTERNALSYM IOleObject}
  IOleObject = class(IUnknown)
  public
    function SetClientSite(clientSite: IOleClientSite): HResult;
      virtual; stdcall; abstract;
    function GetClientSite(var clientSite: IOleClientSite): HResult;
      virtual; stdcall; abstract;
    function SetHostNames(szContainerApp: POleStr;
      szContainerObj: POleStr): HResult; virtual; stdcall; abstract;
    function Close(dwSaveOption: Longint): HResult; virtual; stdcall; abstract;
    function SetMoniker(dwWhichMoniker: Longint; mk: IMoniker): HResult;
      virtual; stdcall; abstract;
    function GetMoniker(dwAssign: Longint; dwWhichMoniker: Longint;
      var mk: IMoniker): HResult; virtual; stdcall; abstract;
    function InitFromData(dataObject: IDataObject; fCreation: BOOL;
      dwReserved: Longint): HResult; virtual; stdcall; abstract;
    function GetClipboardData(dwReserved: Longint;
      var dataObject: IDataObject): HResult; virtual; stdcall; abstract;
    function DoVerb(iVerb: Longint; msg: PMsg; activeSite: IOleClientSite;
      lindex: Longint; hwndParent: HWND; const posRect: TRect): HResult;
      virtual; stdcall; abstract;
    function EnumVerbs(var enumOleVerb: IEnumOleVerb): HResult; virtual; stdcall; abstract;
    function Update: HResult; virtual; stdcall; abstract;
    function IsUpToDate: HResult; virtual; stdcall; abstract;
    function GetUserClassID(var clsid: TCLSID): HResult; virtual; stdcall; abstract;
    function GetUserType(dwFormOfType: Longint; var pszUserType: POleStr): HResult;
      virtual; stdcall; abstract;
    function SetExtent(dwDrawAspect: Longint; const size: TPoint): HResult;
      virtual; stdcall; abstract;
    function GetExtent(dwDrawAspect: Longint; var size: TPoint): HResult;
      virtual; stdcall; abstract;
    function Advise(advSink: IAdviseSink; var dwConnection: Longint): HResult;
      virtual; stdcall; abstract;
    function Unadvise(dwConnection: Longint): HResult; virtual; stdcall; abstract;
    function EnumAdvise(var enumAdvise: IEnumStatData): HResult; virtual; stdcall; abstract;
    function GetMiscStatus(dwAspect: Longint; var dwStatus: Longint): HResult;
      virtual; stdcall; abstract;
    function SetColorScheme(var logpal: TLogPalette): HResult; virtual; stdcall; abstract;
  end;

{ OLE types }

  PObjectDescriptor = ^TObjectDescriptor;
  {$EXTERNALSYM tagOBJECTDESCRIPTOR}
  tagOBJECTDESCRIPTOR = record
    cbSize: Longint;
    clsid: TCLSID;
    dwDrawAspect: Longint;
    size: TPoint;
    point: TPoint;
    dwStatus: Longint;
    dwFullUserTypeName: Longint;
    dwSrcOfCopy: Longint;
  end;
  TObjectDescriptor = tagOBJECTDESCRIPTOR;
  {$EXTERNALSYM OBJECTDESCRIPTOR}
  OBJECTDESCRIPTOR = tagOBJECTDESCRIPTOR;

  PLinkSrcDescriptor = PObjectDescriptor;
  TLinkSrcDescriptor = TObjectDescriptor;

{ IOleWindow interface }

  {$EXTERNALSYM IOleWindow }
  IOleWindow = class(IUnknown)
  public
    function GetWindow(var wnd: HWnd): HResult; virtual; stdcall; abstract;
    function ContextSensitiveHelp(fEnterMode: BOOL): HResult; virtual; stdcall; abstract;
  end;

{ IOleLink interface }

  {$EXTERNALSYM IOleLink }
  IOleLink = class(IUnknown)
  public
    function SetUpdateOptions(dwUpdateOpt: Longint): HResult;
      virtual; stdcall; abstract;
    function GetUpdateOptions(var dwUpdateOpt: Longint): HResult; virtual; stdcall; abstract;
    function SetSourceMoniker(mk: IMoniker; const clsid: TCLSID): HResult;
      virtual; stdcall; abstract;
    function GetSourceMoniker(var mk: IMoniker): HResult; virtual; stdcall; abstract;
    function SetSourceDisplayName(pszDisplayName: POleStr): HResult;
      virtual; stdcall; abstract;
    function GetSourceDisplayName(var pszDisplayName: POleStr): HResult;
      virtual; stdcall; abstract;
    function BindToSource(bindflags: Longint; bc: IBindCtx): HResult;
      virtual; stdcall; abstract;
    function BindIfRunning: HResult; virtual; stdcall; abstract;
    function GetBoundSource(var unk: IUnknown): HResult; virtual; stdcall; abstract;
    function UnbindSource: HResult; virtual; stdcall; abstract;
    function Update(bc: IBindCtx): HResult; virtual; stdcall; abstract;
  end;

{ IOleItemContainer interface }

  {$EXTERNALSYM IOleItemContainer }
  IOleItemContainer = class(IOleContainer)
  public
    function GetObject(pszItem: POleStr; dwSpeedNeeded: Longint;
      bc: IBindCtx; const iid: TIID; var vObject): HResult; virtual; stdcall; abstract;
    function GetObjectStorage(pszItem: POleStr; bc: IBindCtx;
      const iid: TIID; var vStorage): HResult; virtual; stdcall; abstract;
    function IsRunning(pszItem: POleStr): HResult; virtual; stdcall; abstract;
  end;

{ IOleInPlaceUIWindow interface }

  {$EXTERNALSYM IOleInPlaceUIWindow}
  IOleInPlaceUIWindow = class(IOleWindow)
  public
    function GetBorder(var rectBorder: TRect): HResult; virtual; stdcall; abstract;
    function RequestBorderSpace(const borderwidths: TRect): HResult; virtual; stdcall; abstract;
    function SetBorderSpace(pborderwidths: PRect): HResult; virtual; stdcall; abstract;
    function SetActiveObject(activeObject: IOleInPlaceActiveObject;
      pszObjName: POleStr): HResult; virtual; stdcall; abstract;
  end;

{ IOleInPlaceActiveObject interface }

  {$EXTERNALSYM IOleInPlaceActiveObject}
  IOleInPlaceActiveObject = class(IOleWindow)
  public
    function TranslateAccelerator(var msg: TMsg): HResult; virtual; stdcall; abstract;
    function OnFrameWindowActivate(fActivate: BOOL): HResult; virtual; stdcall; abstract;
    function OnDocWindowActivate(fActivate: BOOL): HResult; virtual; stdcall; abstract;
    function ResizeBorder(const rcBorder: TRect; uiWindow: IOleInPlaceUIWindow;
      fFrameWindow: BOOL): HResult; virtual; stdcall; abstract;
    function EnableModeless(fEnable: BOOL): HResult; virtual; stdcall; abstract;
  end;

{ IOleInPlaceFrame interface }

  POleInPlaceFrameInfo = ^TOleInPlaceFrameInfo;
  {$EXTERNALSYM tagOIFI}
  tagOIFI = record
    cb: Integer;
    fMDIApp: BOOL;
    hwndFrame: HWND;
    haccel: HAccel;
    cAccelEntries: Integer;
  end;
  TOleInPlaceFrameInfo = tagOIFI;
  {$EXTERNALSYM OLEINPLACEFRAMEINFO}
  OLEINPLACEFRAMEINFO = tagOIFI;

  POleMenuGroupWidths = ^TOleMenuGroupWidths;
  {$EXTERNALSYM tagOleMenuGroupWidths}
  tagOleMenuGroupWidths = record
    width: array[0..5] of Longint;
  end;
  TOleMenuGroupWidths = tagOleMenuGroupWidths;
  {$EXTERNALSYM OLEMENUGROUPWIDTHS}
  OLEMENUGROUPWIDTHS = tagOleMenuGroupWidths;

  {$EXTERNALSYM IOleInPlaceFrame}
  IOleInPlaceFrame = class(IOleInPlaceUIWindow)
  public
    function InsertMenus(hmenuShared: HMenu;
      var menuWidths: TOleMenuGroupWidths): HResult; virtual; stdcall; abstract;
    function SetMenu(hmenuShared: HMenu; holemenu: HMenu;
      hwndActiveObject: HWnd): HResult; virtual; stdcall; abstract;
    function RemoveMenus(hmenuShared: HMenu): HResult; virtual; stdcall; abstract;
    function SetStatusText(pszStatusText: POleStr): HResult; virtual; stdcall; abstract;
    function EnableModeless(fEnable: BOOL): HResult; virtual; stdcall; abstract;
    function TranslateAccelerator(var msg: TMsg; wID: Word): HResult; virtual; stdcall; abstract;
  end;

{ IOleInPlaceObject interface }

  {$EXTERNALSYM IOleInPlaceObject}
  IOleInPlaceObject = class(IOleWindow)
  public
    function InPlaceDeactivate: HResult; virtual; stdcall; abstract;
    function UIDeactivate: HResult; virtual; stdcall; abstract;
    function SetObjectRects(const rcPosRect: TRect;
      const rcClipRect: TRect): HResult; virtual; stdcall; abstract;
    function ReactivateAndUndo: HResult; virtual; stdcall; abstract;
  end;

{ IOleInPlaceSite interface }

  {$EXTERNALSYM IOleInPlaceSite}
  IOleInPlaceSite = class(IOleWindow)
  public
    function CanInPlaceActivate: HResult; virtual; stdcall; abstract;
    function OnInPlaceActivate: HResult; virtual; stdcall; abstract;
    function OnUIActivate: HResult; virtual; stdcall; abstract;
    function GetWindowContext(var frame: IOleInPlaceFrame;
      var doc: IOleInPlaceUIWindow; var rcPosRect: TRect;
      var rcClipRect: TRect; var frameInfo: TOleInPlaceFrameInfo): HResult;
      virtual; stdcall; abstract;
    function Scroll(scrollExtent: TPoint): HResult; virtual; stdcall; abstract;
    function OnUIDeactivate(fUndoable: BOOL): HResult; virtual; stdcall; abstract;
    function OnInPlaceDeactivate: HResult; virtual; stdcall; abstract;
    function DiscardUndoState: HResult; virtual; stdcall; abstract;
    function DeactivateAndUndo: HResult; virtual; stdcall; abstract;
    function OnPosRectChange(const rcPosRect: TRect): HResult; virtual; stdcall; abstract;
  end;

{ IViewObject interface }

  TContinueFunc = function(dwContinue: Longint): BOOL stdcall;

  {$EXTERNALSYM IViewObject }
  IViewObject = class(IUnknown)
  public
    function Draw(dwDrawAspect: Longint; lindex: Longint; pvAspect: Pointer;
      ptd: PDVTargetDevice; hicTargetDev: HDC; hdcDraw: HDC;
      prcBounds: PRect; prcWBounds: PRect; fnContinue: TContinueFunc;
      dwContinue: Longint): HResult; virtual; stdcall; abstract;
    function GetColorSet(dwDrawAspect: Longint; lindex: Longint;
      pvAspect: Pointer; ptd: PDVTargetDevice; hicTargetDev: HDC;
      var colorSet: PLogPalette): HResult; virtual; stdcall; abstract;
    function Freeze(dwDrawAspect: Longint; lindex: Longint; pvAspect: Pointer;
      var dwFreeze: Longint): HResult; virtual; stdcall; abstract;
    function Unfreeze(dwFreeze: Longint): HResult; virtual; stdcall; abstract;
    function SetAdvise(aspects: Longint; advf: Longint;
      advSink: IAdviseSink): HResult; virtual; stdcall; abstract;
    function GetAdvise(pAspects: PLongint; pAdvf: PLongint;
      var advSink: IAdviseSink): HResult; virtual; stdcall; abstract;
  end;

{ IViewObject2 interface }

  {$EXTERNALSYM IViewObject2 }
  IViewObject2 = class(IViewObject)
  public
    function GetExtent(dwDrawAspect: Longint; lindex: Longint;
      ptd: PDVTargetDevice; var size: TPoint): HResult; virtual; stdcall; abstract;
  end;

{ IDropSource interface }

  {$EXTERNALSYM IDropSource }
  IDropSource = class(IUnknown)
  public
    function QueryContinueDrag(fEscapePressed: BOOL;
      grfKeyState: Longint): HResult; virtual; stdcall; abstract;
    function GiveFeedback(dwEffect: Longint): HResult; virtual; stdcall;  abstract;
  end;

{ IDropTarget interface }

  {$EXTERNALSYM IDropTarget }
  IDropTarget = class(IUnknown)
  public
    function DragEnter(dataObj: IDataObject; grfKeyState: Longint;
      pt: TPoint; var dwEffect: Longint): HResult; virtual; stdcall; abstract;
    function DragOver(grfKeyState: Longint; pt: TPoint;
      var dwEffect: Longint): HResult; virtual; stdcall; abstract;
    function DragLeave: HResult; virtual; stdcall; abstract;
    function Drop(dataObj: IDataObject; grfKeyState: Longint; pt: TPoint;
      var dwEffect: Longint): HResult; virtual; stdcall; abstract;
  end;

{ IEnumOleVerb interface }

  POleVerb = ^TOleVerb;
  {$EXTERNALSYM tagOLEVERB}
  tagOLEVERB = record
    lVerb: Longint;
    lpszVerbName: POleStr;
    fuFlags: Longint;
    grfAttribs: Longint;
  end;
  TOleVerb = tagOLEVERB;
  {$EXTERNALSYM OLEVERB}
  OLEVERB = tagOLEVERB;

  {$EXTERNALSYM IEnumOleVerb }
  IEnumOleVerb = class(IUnknown)
  public
    function Next(celt: Longint; var elt;
      pceltFetched: PLongint): HResult; virtual; stdcall; abstract;
    function Skip(celt: Longint): HResult; virtual; stdcall; abstract;
    function Reset: HResult; virtual; stdcall; abstract;
    function Clone(var enm: IEnumOleVerb): HResult; virtual; stdcall; abstract;
  end;

  {$EXTERNALSYM IOleDocumentView}
  IOleDocumentView = class(IUnknown)
  public
    function SetInPlaceSite(Site: IOleInPlaceSite):HResult; virtual; stdcall; abstract;
    function GetInPlaceSite(var Site: IOleInPlaceSite):HResult; virtual; stdcall; abstract;
    function GetDocument(var P: IUnknown):HResult; virtual; stdcall; abstract;
    function SetRect(const View: TRECT):HResult; virtual; stdcall; abstract;
    function GetRect(var View: TRECT):HResult; virtual; stdcall; abstract;
    function SetRectComplex(const View, HScroll, VScroll, SizeBox):HResult; virtual; stdcall; abstract;
    function Show(fShow: BOOL):HResult; virtual; stdcall; abstract;
    function UIActivate(fUIActivate: BOOL):HResult; virtual; stdcall; abstract;
    function Open:HResult; virtual; stdcall; abstract;
    function CloseView(dwReserved: DWORD):HResult; virtual; stdcall; abstract;
    function SaveViewState(pstm: IStream):HResult; virtual; stdcall; abstract;
    function ApplyViewState(pstm: IStream):HResult; virtual; stdcall; abstract;
    function Clone(NewSite: IOleInPlaceSite; var NewView: IOleDocumentView):HResult; virtual; stdcall; abstract;
  end;

  {$EXTERNALSYM IEnumOleDocumentViews }
  IEnumOleDocumentViews = class(IUnknown)
  public
    function Next(Count: Longint; var View: IOleDocumentView; var Fetched: Longint):HResult; virtual; stdcall; abstract;
    function Skip(Count: Longint):HResult; virtual; stdcall; abstract;
    function Reset:HResult; virtual; stdcall; abstract;
    function Clone(var Enum: IEnumOleDocumentViews):HResult; virtual; stdcall; abstract;
  end;

  {$EXTERNALSYM IOleDocument }
  IOleDocument = class(IUnknown)
  public
    function CreateView(Site: IOleInPlaceSite; Stream: IStream; rsrvd: DWORD;
      var View: IOleDocumentView):HResult; virtual; stdcall; abstract;
    function GetDocMiscStatus(var Status: DWORD):HResult; virtual; stdcall; abstract;
    function EnumViews(var Enum: IEnumOleDocumentViews;
      var View: IOleDocumentView):HResult; virtual; stdcall; abstract;
  end;

  {$EXTERNALSYM IOleDocumentSite }
  IOleDocumentSite = class(IUnknown)
  public
    function ActivateMe(View: IOleDocumentView): HRESULT; virtual; stdcall; abstract;
  end;


const

{ Standard GUIDs }

  {$EXTERNALSYM GUID_NULL}
  GUID_NULL: TGUID = (
    D1:$00000000;D2:$0000;D3:$0000;D4:($00,$00,$00,$00,$00,$00,$00,$00));
  {$EXTERNALSYM IID_IUnknown}
  IID_IUnknown: TGUID = (
    D1:$00000000;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IClassFactory}
  IID_IClassFactory: TGUID = (
    D1:$00000001;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IMarshal}
  IID_IMarshal: TGUID = (
    D1:$00000003;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IMalloc}
  IID_IMalloc: TGUID = (
    D1:$00000002;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IStdMarshalInfo}
  IID_IStdMarshalInfo: TGUID = (
    D1:$00000018;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IExternalConnection}
  IID_IExternalConnection: TGUID = (
    D1:$00000019;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IEnumUnknown}
  IID_IEnumUnknown: TGUID = (
    D1:$00000100;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IBindCtx}
  IID_IBindCtx: TGUID = (
    D1:$0000000E;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IEnumMoniker}
  IID_IEnumMoniker: TGUID = (
    D1:$00000102;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IRunnableObject}
  IID_IRunnableObject: TGUID = (
    D1:$00000126;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IRunningObjectTable}
  IID_IRunningObjectTable: TGUID = (
    D1:$00000010;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IPersist}
  IID_IPersist: TGUID = (
    D1:$0000010C;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IPersistStream}
  IID_IPersistStream: TGUID = (
    D1:$00000109;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IMoniker}
  IID_IMoniker: TGUID = (
    D1:$0000000F;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IEnumString}
  IID_IEnumString: TGUID = (
    D1:$00000101;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IStream}
  IID_IStream: TGUID = (
    D1:$0000000C;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IEnumStatStg}
  IID_IEnumStatStg: TGUID = (
    D1:$0000000D;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IStorage}
  IID_IStorage: TGUID = (
    D1:$0000000B;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IPersistFile}
  IID_IPersistFile: TGUID = (
    D1:$0000010B;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IPersistStorage}
  IID_IPersistStorage: TGUID = (
    D1:$0000010A;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_ILockBytes}
  IID_ILockBytes: TGUID = (
    D1:$0000000A;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IEnumFormatEtc}
  IID_IEnumFormatEtc: TGUID = (
    D1:$00000103;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IEnumStatData}
  IID_IEnumStatData: TGUID = (
    D1:$00000105;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IRootStorage}
  IID_IRootStorage: TGUID = (
    D1:$00000012;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IAdviseSink}
  IID_IAdviseSink: TGUID = (
    D1:$0000010F;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IAdviseSink2}
  IID_IAdviseSink2: TGUID = (
    D1:$00000125;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IDataObject}
  IID_IDataObject: TGUID = (
    D1:$0000010E;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IDataAdviseHolder}
  IID_IDataAdviseHolder: TGUID = (
    D1:$00000110;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IMessageFilter}
  IID_IMessageFilter: TGUID = (
    D1:$00000016;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IRpcChannelBuffer}
  IID_IRpcChannelBuffer: TGUID = (
    D1:$D5F56B60;D2:$593B;D3:$101A;D4:($B5,$69,$08,$00,$2B,$2D,$BF,$7A));
  {$EXTERNALSYM IID_IRpcProxyBuffer}
  IID_IRpcProxyBuffer: TGUID = (
    D1:$D5F56A34;D2:$593B;D3:$101A;D4:($B5,$69,$08,$00,$2B,$2D,$BF,$7A));
  {$EXTERNALSYM IID_IRpcStubBuffer}
  IID_IRpcStubBuffer: TGUID = (
    D1:$D5F56AFC;D2:$593B;D3:$101A;D4:($B5,$69,$08,$00,$2B,$2D,$BF,$7A));
  {$EXTERNALSYM IID_IPSFactoryBuffer}
  IID_IPSFactoryBuffer: TGUID = (
    D1:$D5F569D0;D2:$593B;D3:$101A;D4:($B5,$69,$08,$00,$2B,$2D,$BF,$7A));
  {$EXTERNALSYM IID_ICreateTypeInfo}
  IID_ICreateTypeInfo: TGUID = (
    D1:$00020405;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_ICreateTypeLib}
  IID_ICreateTypeLib: TGUID = (
    D1:$00020406;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IDispatch}
  IID_IDispatch: TGUID = (
    D1:$00020400;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IEnumVariant}
  IID_IEnumVariant: TGUID = (
    D1:$00020404;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_ITypeComp}
  IID_ITypeComp: TGUID = (
    D1:$00020403;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_ITypeInfo}
  IID_ITypeInfo: TGUID = (
    D1:$00020401;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_ITypeLib}
  IID_ITypeLib: TGUID = (
    D1:$00020402;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IErrorInfo}
  IID_IErrorInfo: TGUID = (
    D1:$1CF2B120;D2:$547D;D3:$101B;D4:($8E,$65,$08,$00,$2B,$2B,$D1,$19));
  {$EXTERNALSYM IID_ICreateErrorInfo}
  IID_ICreateErrorInfo: TGUID = (
    D1:$22F03340;D2:$547D;D3:$101B;D4:($8E,$65,$08,$00,$2B,$2B,$D1,$19));
  {$EXTERNALSYM IID_ISupportErrorInfo}
  IID_ISupportErrorInfo: TGUID = (
    D1:$DF0B3D60;D2:$548F;D3:$101B;D4:($8E,$65,$08,$00,$2B,$2B,$D1,$19));
  {$EXTERNALSYM IID_IOleAdviseHolder}
  IID_IOleAdviseHolder: TGUID = (
    D1:$00000111;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IOleCache}
  IID_IOleCache: TGUID = (
    D1:$0000011E;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IOleCache2}
  IID_IOleCache2: TGUID = (
    D1:$00000128;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IOleCacheControl}
  IID_IOleCacheControl: TGUID = (
    D1:$00000129;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IParseDisplayName}
  IID_IParseDisplayName: TGUID = (
    D1:$0000011A;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IOleContainer}
  IID_IOleContainer: TGUID = (
    D1:$0000011B;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IOleClientSite}
  IID_IOleClientSite: TGUID = (
    D1:$00000118;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IOleObject}
  IID_IOleObject: TGUID = (
    D1:$00000112;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IOleWindow}
  IID_IOleWindow: TGUID = (
    D1:$00000114;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IOleLink}
  IID_IOleLink: TGUID = (
    D1:$0000011D;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IOleItemContainer}
  IID_IOleItemContainer: TGUID = (
    D1:$0000011C;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IOleInPlaceUIWindow}
  IID_IOleInPlaceUIWindow: TGUID = (
    D1:$00000115;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IOleInPlaceActiveObject}
  IID_IOleInPlaceActiveObject: TGUID = (
    D1:$00000117;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IOleInPlaceFrame}
  IID_IOleInPlaceFrame: TGUID = (
    D1:$00000116;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IOleInPlaceObject}
  IID_IOleInPlaceObject: TGUID = (
    D1:$00000113;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IOleInPlaceSite}
  IID_IOleInPlaceSite: TGUID = (
    D1:$00000119;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IViewObject}
  IID_IViewObject: TGUID = (
    D1:$0000010D;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IViewObject2}
  IID_IViewObject2: TGUID = (
    D1:$00000127;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IDropSource}
  IID_IDropSource: TGUID = (
    D1:$00000121;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IDropTarget}
  IID_IDropTarget: TGUID = (
    D1:$00000122;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IEnumOleVerb}
  IID_IEnumOleVerb: TGUID = (
    D1:$00000104;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));

{ Additional GUIDs }

  {$EXTERNALSYM IID_IRpcChannel}
  IID_IRpcChannel: TGUID = (
    D1:$00000004;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IRpcStub}
  IID_IRpcStub: TGUID = (
    D1:$00000005;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IStubManager}
  IID_IStubManager: TGUID = (
    D1:$00000006;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IRpcProxy}
  IID_IRpcProxy: TGUID = (
    D1:$00000007;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IProxyManager}
  IID_IProxyManager: TGUID = (
    D1:$00000008;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IPSFactory}
  IID_IPSFactory: TGUID = (
    D1:$00000009;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IInternalMoniker}
  IID_IInternalMoniker: TGUID = (
    D1:$00000011;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM CLSID_StdMarshal}
  CLSID_StdMarshal: TGUID = (
    D1:$00000017;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IEnumGeneric}
  IID_IEnumGeneric: TGUID = (
    D1:$00000106;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IEnumHolder}
  IID_IEnumHolder: TGUID = (
    D1:$00000107;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IEnumCallback}
  IID_IEnumCallback: TGUID = (
    D1:$00000108;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IOleManager}
  IID_IOleManager: TGUID = (
    D1:$0000011F;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IOlePresObj}
  IID_IOlePresObj: TGUID = (
    D1:$00000120;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IDebug}
  IID_IDebug: TGUID = (
    D1:$00000123;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IDebugStream}
  IID_IDebugStream: TGUID = (
    D1:$00000124;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));

  {$EXTERNALSYM IID_IOleDocument}
  IID_IOleDocument: TGUID = (
    D1:$b722bcc5;D2:$4e68;D3:$101b;D4:($a2,$bc,$00,$aa,$00,$40,$47,$70));
  {$EXTERNALSYM IID_IOleDocumentSite}
  IID_IOleDocumentSite: TGUID = (
    D1:$b722bcc7;D2:$4e68;D3:$101b;D4:($a2,$bc,$00,$aa,$00,$40,$47,$70));


{ HResult manipulation routines }

function Succeeded(Res: HResult): Boolean;
function Failed(Res: HResult): Boolean;
function ResultCode(Res: HResult): Integer;
function ResultFacility(Res: HResult): Integer;
function ResultSeverity(Res: HResult): Integer;
{$EXTERNALSYM MakeResult}
function MakeResult(Severity, Facility, Code: Integer): HResult;

{ GUID functions }

{$EXTERNALSYM IsEqualGUID}
function IsEqualGUID(const guid1, guid2: TGUID): Boolean; stdcall;
{$EXTERNALSYM IsEqualIID}
function IsEqualIID(const iid1, iid2: TIID): Boolean; stdcall;
{$EXTERNALSYM IsEqualCLSID}
function IsEqualCLSID(const clsid1, clsid2: TCLSID): Boolean; stdcall;

{ Standard object API functions }

{$EXTERNALSYM CoBuildVersion}
function CoBuildVersion: Longint; stdcall;

{ Init/Uninit }

{$EXTERNALSYM CoInitialize}
function CoInitialize(pvReserved: Pointer): HResult; stdcall;
{$EXTERNALSYM CoUninitialize}
procedure CoUninitialize; stdcall;
{$EXTERNALSYM CoGetMalloc}
function CoGetMalloc(dwMemContext: Longint; var malloc: IMalloc): HResult; stdcall;
{$EXTERNALSYM CoGetCurrentProcess}
function CoGetCurrentProcess: Longint; stdcall;
{$EXTERNALSYM CoRegisterMallocSpy}
function CoRegisterMallocSpy(mallocSpy: IMallocSpy): HResult; stdcall;
{$EXTERNALSYM CoRevokeMallocSpy}
function CoRevokeMallocSpy: HResult stdcall;
{$EXTERNALSYM CoCreateStandardMalloc}
function CoCreateStandardMalloc(memctx: Longint; var malloc: IMalloc): HResult; stdcall;

{ Register, revoke, and get class objects }

{$EXTERNALSYM CoGetClassObject}
function CoGetClassObject(const clsid: TCLSID; dwClsContext: Longint;
  pvReserved: Pointer; const iid: TIID; var pv): HResult; stdcall;
{$EXTERNALSYM CoRegisterClassObject}
function CoRegisterClassObject(const clsid: TCLSID; unk: IUnknown;
  dwClsContext: Longint; flags: Longint; var dwRegister: Longint): HResult; stdcall;
{$EXTERNALSYM CoRevokeClassObject}
function CoRevokeClassObject(dwRegister: Longint): HResult; stdcall;

{ Marshaling interface pointers }

{$EXTERNALSYM CoGetMarshalSizeMax}
function CoGetMarshalSizeMax(var ulSize: Longint; const iid: TIID;
  unk: IUnknown; dwDestContext: Longint; pvDestContext: Pointer;
  mshlflags: Longint): HResult; stdcall;
{$EXTERNALSYM CoMarshalInterface}
function CoMarshalInterface(stm: IStream; const iid: TIID; unk: IUnknown;
  dwDestContext: Longint; pvDestContext: Pointer;
  mshlflags: Longint): HResult; stdcall;
{$EXTERNALSYM CoUnmarshalInterface}
function CoUnmarshalInterface(stm: IStream; const iid: TIID;
  var pv): HResult; stdcall;
{$EXTERNALSYM CoMarshalHResult}
function CoMarshalHResult(stm: IStream; result: HResult): HResult; stdcall;
{$EXTERNALSYM CoUnmarshalHResult}
function CoUnmarshalHResult(stm: IStream; var result: HResult): HResult; stdcall;
{$EXTERNALSYM CoReleaseMarshalData}
function CoReleaseMarshalData(stm: IStream): HResult; stdcall;
{$EXTERNALSYM CoDisconnectObject}
function CoDisconnectObject(unk: IUnknown; dwReserved: Longint): HResult; stdcall;
{$EXTERNALSYM CoLockObjectExternal}
function CoLockObjectExternal(unk: IUnknown; fLock: BOOL;
  fLastUnlockReleases: BOOL): HResult; stdcall;
{$EXTERNALSYM CoGetStandardMarshal}
function CoGetStandardMarshal(const iid: TIID; unk: IUnknown;
  dwDestContext: Longint; pvDestContext: Pointer; mshlflags: Longint;
  var marshal: IMarshal): HResult; stdcall;

{$EXTERNALSYM CoIsHandlerConnected}
function CoIsHandlerConnected(unk: IUnknown): BOOL; stdcall;
{$EXTERNALSYM CoHasStrongExternalConnections}
function CoHasStrongExternalConnections(unk: IUnknown): BOOL; stdcall;

{ Apartment model inter-thread interface passing helpers }

{$EXTERNALSYM CoMarshalInterThreadInterfaceInStream}
function CoMarshalInterThreadInterfaceInStream(const iid: TIID;
  unk: IUnknown; var stm: IStream): HResult; stdcall;
{$EXTERNALSYM CoGetInterfaceAndReleaseStream}
function CoGetInterfaceAndReleaseStream(stm: IStream; const iid: TIID;
  var pv): HResult; stdcall;
{$EXTERNALSYM CoCreateFreeThreadedMarshaler}
function CoCreateFreeThreadedMarshaler(unkOuter: IUnknown;
  var unkMarshal: IUnknown): HResult; stdcall;

{ DLL loading helpers; keeps track of ref counts and unloads all on exit }

{$EXTERNALSYM CoLoadLibrary}
function CoLoadLibrary(pszLibName: POleStr; bAutoFree: BOOL): THandle; stdcall;
{$EXTERNALSYM CoFreeLibrary}
procedure CoFreeLibrary(hInst: THandle); stdcall;
{$EXTERNALSYM CoFreeAllLibraries}
procedure CoFreeAllLibraries; stdcall;
{$EXTERNALSYM CoFreeUnusedLibraries}
procedure CoFreeUnusedLibraries; stdcall;

{ Helper for creating instances }

{$EXTERNALSYM CoCreateInstance}
function CoCreateInstance(const clsid: TCLSID; unkOuter: IUnknown;
  dwClsContext: Longint; const iid: TIID; var pv): HResult; stdcall;

{ Other helpers }

{$EXTERNALSYM StringFromCLSID}
function StringFromCLSID(const clsid: TCLSID; var psz: POleStr): HResult; stdcall;
{$EXTERNALSYM CLSIDFromString}
function CLSIDFromString(psz: POleStr; var clsid: TCLSID): HResult; stdcall;
{$EXTERNALSYM StringFromIID}
function StringFromIID(const iid: TIID; var psz: POleStr): HResult; stdcall;
{$EXTERNALSYM IIDFromString}
function IIDFromString(psz: POleStr; var iid: TIID): HResult; stdcall;
{$EXTERNALSYM CoIsOle1Class}
function CoIsOle1Class(const clsid: TCLSID): BOOL; stdcall;
{$EXTERNALSYM ProgIDFromCLSID}
function ProgIDFromCLSID(const clsid: TCLSID; var pszProgID: POleStr): HResult; stdcall;
{$EXTERNALSYM CLSIDFromProgID}
function CLSIDFromProgID(pszProgID: POleStr; var clsid: TCLSID): HResult; stdcall;
{$EXTERNALSYM StringFromGUID2}
function StringFromGUID2(const guid: TGUID; psz: POleStr; cbMax: Integer): Integer; stdcall;

{$EXTERNALSYM CoCreateGuid}
function CoCreateGuid(var guid: TGUID): HResult; stdcall;

{$EXTERNALSYM CoFileTimeToDosDateTime}
function CoFileTimeToDosDateTime(var filetime: TFileTime; var dosDate: Word;
  var dosTime: Word): BOOL; stdcall;
{$EXTERNALSYM CoDosDateTimeToFileTime}
function CoDosDateTimeToFileTime(nDosDate: Word; nDosTime: Word;
  var filetime: TFileTime): BOOL; stdcall;
{$EXTERNALSYM CoFileTimeNow}
function CoFileTimeNow(var filetime: TFileTime): HResult; stdcall;
{$EXTERNALSYM CoRegisterMessageFilter}
function CoRegisterMessageFilter(messageFilter: IMessageFilter;
  var pMessageFilter: IMessageFilter): HResult; stdcall;

{ TreatAs APIs }

{$EXTERNALSYM CoGetTreatAsClass}
function CoGetTreatAsClass(const clsidOld: TCLSID; var clsidNew: TCLSID): HResult; stdcall;
{$EXTERNALSYM CoTreatAsClass}
function CoTreatAsClass(const clsidOld: TCLSID; const clsidNew: TCLSID): HResult; stdcall;

{ The server DLLs must define their DllGetClassObject and DllCanUnloadNow
  to match these; the typedefs are located here to ensure all are changed at
  the same time }

type
  TDLLGetClassObject = function(const clsid: TCLSID; const iid: TIID;
    var pv): HResult stdcall;
  TDLLCanUnloadNow = function: HResult stdcall;

{ Default memory allocation }

{$EXTERNALSYM CoTaskMemAlloc}
function CoTaskMemAlloc(cb: Longint): Pointer; stdcall;
{$EXTERNALSYM CoTaskMemRealloc}
function CoTaskMemRealloc(pv: Pointer; cb: Longint): Pointer; stdcall;
{$EXTERNALSYM CoTaskMemFree}
procedure CoTaskMemFree(pv: Pointer); stdcall;

{ DV APIs }

{$EXTERNALSYM CreateDataAdviseHolder}
function CreateDataAdviseHolder(var DAHolder: IDataAdviseHolder): HResult; stdcall;
{$EXTERNALSYM CreateDataCache}
function CreateDataCache(unkOuter: IUnknown; const clsid: TCLSID;
  const iid: TIID; var pv): HResult; stdcall;

{ Storage API prototypes }

{$EXTERNALSYM StgCreateDocfile}
function StgCreateDocfile(pwcsName: POleStr; grfMode: Longint;
  reserved: Longint; var stgOpen: IStorage): HResult; stdcall;
{$EXTERNALSYM StgCreateDocfileOnILockBytes}
function StgCreateDocfileOnILockBytes(lkbyt: ILockBytes; grfMode: Longint;
  reserved: Longint; var stgOpen: IStorage): HResult; stdcall;
{$EXTERNALSYM StgOpenStorage}
function StgOpenStorage(pwcsName: POleStr; stgPriority: IStorage;
  grfMode: Longint; snbExclude: TSNB; reserved: Longint;
  var stgOpen: IStorage): HResult; stdcall;
{$EXTERNALSYM StgOpenStorageOnILockBytes}
function StgOpenStorageOnILockBytes(lkbyt: ILockBytes; stgPriority: IStorage;
  grfMode: Longint; snbExclude: TSNB; reserved: Longint;
  var stgOpen: IStorage): HResult; stdcall;
{$EXTERNALSYM StgIsStorageFile}
function StgIsStorageFile(pwcsName: POleStr): HResult; stdcall;
{$EXTERNALSYM StgIsStorageILockBytes}
function StgIsStorageILockBytes(lkbyt: ILockBytes): HResult; stdcall;
{$EXTERNALSYM StgSetTimes}
function StgSetTimes(pszName: POleStr; const ctime: TFileTime;
  const atime: TFileTime; const mtime: TFileTime): HResult; stdcall;

{ Moniker APIs }

{$EXTERNALSYM BindMoniker}
function BindMoniker(mk: IMoniker; grfOpt: Longint; const iidResult: TIID;
  var pvResult): HResult; stdcall;
{$EXTERNALSYM MkParseDisplayName}
function MkParseDisplayName(bc: IBindCtx; szUserName: POleStr;
  var chEaten: Longint; var mk: IMoniker): HResult; stdcall;
{$EXTERNALSYM MonikerRelativePathTo}
function MonikerRelativePathTo(mkSrc: IMoniker; mkDest: IMoniker;
  var mkRelPath: IMoniker; dwReserved: BOOL): HResult; stdcall;
{$EXTERNALSYM MonikerCommonPrefixWith}
function MonikerCommonPrefixWith(mkThis: IMoniker; mkOther: IMoniker;
  var mkCommon: IMoniker): HResult; stdcall;
{$EXTERNALSYM CreateBindCtx}
function CreateBindCtx(reserved: Longint; var bc: IBindCtx): HResult; stdcall;
{$EXTERNALSYM CreateGenericComposite}
function CreateGenericComposite(mkFirst: IMoniker; mkRest: IMoniker;
  var mkComposite: IMoniker): HResult; stdcall;
{$EXTERNALSYM GetClassFile}
function GetClassFile(szFilename: POleStr; var clsid: TCLSID): HResult; stdcall;
{$EXTERNALSYM CreateFileMoniker}
function CreateFileMoniker(pszPathName: POleStr; var mk: IMoniker): HResult; stdcall;
{$EXTERNALSYM CreateItemMoniker}
function CreateItemMoniker(pszDelim: POleStr; pszItem: POleStr;
  var mk: IMoniker): HResult; stdcall;
{$EXTERNALSYM CreateAntiMoniker}
function CreateAntiMoniker(var mk: IMoniker): HResult; stdcall;
{$EXTERNALSYM CreatePointerMoniker}
function CreatePointerMoniker(unk: IUnknown; var mk: IMoniker): HResult; stdcall;
{$EXTERNALSYM GetRunningObjectTable}
function GetRunningObjectTable(reserved: Longint;
  var rot: IRunningObjectTable): HResult; stdcall;

{ TBStr API }

{$EXTERNALSYM SysAllocString}
function SysAllocString(psz: POleStr): TBStr; stdcall;
{$EXTERNALSYM SysReAllocString}
function SysReAllocString(var bstr: TBStr; psz: POleStr): Integer; stdcall;
{$EXTERNALSYM SysAllocStringLen}
function SysAllocStringLen(psz: POleStr; len: Integer): TBStr; stdcall;
{$EXTERNALSYM SysReAllocStringLen}
function SysReAllocStringLen(var bstr: TBStr; psz: POleStr;
  len: Integer): Integer; stdcall;
{$EXTERNALSYM SysFreeString}
procedure SysFreeString(bstr: TBStr); stdcall;
{$EXTERNALSYM SysStringLen}
function SysStringLen(bstr: TBStr): Integer; stdcall;
{$EXTERNALSYM SysStringByteLen}
function SysStringByteLen(bstr: TBStr): Integer; stdcall;
{$EXTERNALSYM SysAllocStringByteLen}
function SysAllocStringByteLen(psz: PChar; len: Integer): TBStr; stdcall;

{ Time API }

{$EXTERNALSYM DosDateTimeToVariantTime}
function DosDateTimeToVariantTime(wDosDate, wDosTime: Word;
  var vtime: TOleDate): Integer; stdcall;
{$EXTERNALSYM VariantTimeToDosDateTime}
function VariantTimeToDosDateTime(vtime: TOleDate; var wDosDate,
  wDosTime: Word): Integer; stdcall;

{ SafeArray API }

{$EXTERNALSYM SafeArrayAllocDescriptor}
function SafeArrayAllocDescriptor(cDims: Integer; var psaOut: PSafeArray): HResult; stdcall;
{$EXTERNALSYM SafeArrayAllocData}
function SafeArrayAllocData(psa: PSafeArray): HResult; stdcall;
{$EXTERNALSYM SafeArrayCreate}
function SafeArrayCreate(vt: TVarType; cDims: Integer; const rgsabound): PSafeArray; stdcall;
{$EXTERNALSYM SafeArrayDestroyDescriptor}
function SafeArrayDestroyDescriptor(psa: PSafeArray): HResult; stdcall;
{$EXTERNALSYM SafeArrayDestroyData}
function SafeArrayDestroyData(psa: PSafeArray): HResult; stdcall;
{$EXTERNALSYM SafeArrayDestroy}
function SafeArrayDestroy(psa: PSafeArray): HResult; stdcall;
{$EXTERNALSYM SafeArrayRedim}
function SafeArrayRedim(psa: PSafeArray; var saboundNew: TSafeArrayBound): HResult; stdcall;
{$EXTERNALSYM SafeArrayGetDim}
function SafeArrayGetDim(psa: PSafeArray): Integer; stdcall;
{$EXTERNALSYM SafeArrayGetElemsize}
function SafeArrayGetElemsize(psa: PSafeArray): Integer; stdcall;
{$EXTERNALSYM SafeArrayGetUBound}
function SafeArrayGetUBound(psa: PSafeArray; nDim: Integer; var lUbound: Longint): HResult; stdcall;
{$EXTERNALSYM SafeArrayGetLBound}
function SafeArrayGetLBound(psa: PSafeArray; nDim: Integer; var lLbound: Longint): HResult; stdcall;
{$EXTERNALSYM SafeArrayLock}
function SafeArrayLock(psa: PSafeArray): HResult; stdcall;
{$EXTERNALSYM SafeArrayUnlock}
function SafeArrayUnlock(psa: PSafeArray): HResult; stdcall;
{$EXTERNALSYM SafeArrayAccessData}
function SafeArrayAccessData(psa: PSafeArray; var pvData: Pointer): HResult; stdcall;
{$EXTERNALSYM SafeArrayUnaccessData}
function SafeArrayUnaccessData(psa: PSafeArray): HResult; stdcall;
{$EXTERNALSYM SafeArrayGetElement}
function SafeArrayGetElement(psa: PSafeArray; const rgIndices; var pv): HResult; stdcall;
{$EXTERNALSYM SafeArrayPutElement}
function SafeArrayPutElement(psa: PSafeArray; const rgIndices; const pv): HResult; stdcall;
{$EXTERNALSYM SafeArrayCopy}
function SafeArrayCopy(psa: PSafeArray; var psaOut: PSafeArray): HResult; stdcall;
{$EXTERNALSYM SafeArrayPtrOfIndex}
function SafeArrayPtrOfIndex(psa: PSafeArray; var rgIndices; var pvData: Pointer): HResult; stdcall;

{ Variant API }

{$EXTERNALSYM VariantInit}
procedure VariantInit(var varg: Variant); stdcall;
{$EXTERNALSYM VariantClear}
function VariantClear(var varg: Variant): HResult; stdcall;
{$EXTERNALSYM VariantCopy}
function VariantCopy(var vargDest: Variant; const vargSrc: Variant): HResult; stdcall;
{$EXTERNALSYM VariantCopyInd}
function VariantCopyInd(var varDest: Variant; const vargSrc: Variant): HResult; stdcall;
{$EXTERNALSYM VariantChangeType}
function VariantChangeType(var vargDest: Variant; const vargSrc: Variant;
  wFlags: Word; vt: TVarType): HResult; stdcall;
{$EXTERNALSYM VariantChangeTypeEx}
function VariantChangeTypeEx(var vargDest: Variant; const vargSrc: Variant;
  lcid: TLCID; wFlags: Word; vt: TVarType): HResult; stdcall;

{ VarType coercion API }

{ Note: The routines that convert from a string are defined
  to take a POleStr rather than a TBStr because no allocation is
  required, and this makes the routines a bit more generic.
  They may of course still be passed a TBStr as the strIn param. }

{ Any of the coersion functions that converts either from or to a string
  takes an additional lcid and dwFlags arguments. The lcid argument allows
  locale specific parsing to occur.  The dwFlags allow additional function
  specific condition to occur.  All function that accept the dwFlags argument
  can include either 0 or LOCALE_NOUSEROVERRIDE flag. In addition, the
  VarDateFromStr functions also accepts the VAR_TIMEVALUEONLY and
  VAR_DATEVALUEONLY flags }

{$EXTERNALSYM VarUI1FromI2}
function VarUI1FromI2(sIn: Smallint; var bOut: Byte): HResult; stdcall;
{$EXTERNALSYM VarUI1FromI4}
function VarUI1FromI4(lIn: Longint; var bOut: Byte): HResult; stdcall;
{$EXTERNALSYM VarUI1FromR4}
function VarUI1FromR4(fltIn: Single; var bOut: Byte): HResult; stdcall;
{$EXTERNALSYM VarUI1FromR8}
function VarUI1FromR8(dblIn: Double; var bOut: Byte): HResult; stdcall;
{$EXTERNALSYM VarUI1FromCy}
function VarUI1FromCy(cyIn: TCurrency; var bOut: Byte): HResult; stdcall;
{$EXTERNALSYM VarUI1FromDate}
function VarUI1FromDate(dateIn: TOleDate; var bOut: Byte): HResult; stdcall;
{$EXTERNALSYM VarUI1FromStr}
function VarUI1FromStr(strIn: TBStr; lcid: TLCID; dwFlags: Longint; var bOut: Byte): HResult; stdcall;
{$EXTERNALSYM VarUI1FromDisp}
function VarUI1FromDisp(dispIn: IDispatch; lcid: TLCID; var bOut: Byte): HResult; stdcall;
{$EXTERNALSYM VarUI1FromBool}
function VarUI1FromBool(boolIn: TOleBool; var bOut: Byte): HResult; stdcall;

{$EXTERNALSYM VarI2FromUI1}
function VarI2FromUI1(bIn: Byte; var sOut: Smallint): HResult; stdcall;
{$EXTERNALSYM VarI2FromI4}
function VarI2FromI4(lIn: Longint; var sOut: Smallint): HResult; stdcall;
{$EXTERNALSYM VarI2FromR4}
function VarI2FromR4(fltIn: Single; var sOut: Smallint): HResult; stdcall;
{$EXTERNALSYM VarI2FromR8}
function VarI2FromR8(dblIn: Double; var sOut: Smallint): HResult; stdcall;
{$EXTERNALSYM VarI2FromCy}
function VarI2FromCy(cyIn: TCurrency; var sOut: Smallint): HResult; stdcall;
{$EXTERNALSYM VarI2FromDate}
function VarI2FromDate(dateIn: TOleDate; var sOut: Smallint): HResult; stdcall;
{$EXTERNALSYM VarI2FromStr}
function VarI2FromStr(strIn: TBStr; lcid: TLCID; dwFlags: Longint; var sOut: Smallint): HResult; stdcall;
{$EXTERNALSYM VarI2FromDisp}
function VarI2FromDisp(dispIn: IDispatch; lcid: TLCID; var sOut: Smallint): HResult; stdcall;
{$EXTERNALSYM VarI2FromBool}
function VarI2FromBool(boolIn: TOleBool; var sOut: Smallint): HResult; stdcall;

{$EXTERNALSYM VarI4FromUI1}
function VarI4FromUI1(bIn: Byte; var lOut: Longint): HResult; stdcall;
{$EXTERNALSYM VarI4FromI2}
function VarI4FromI2(sIn: Smallint; var lOut: Longint): HResult; stdcall;
{$EXTERNALSYM VarI4FromR4}
function VarI4FromR4(fltIn: Single; var lOut: Longint): HResult; stdcall;
{$EXTERNALSYM VarI4FromR8}
function VarI4FromR8(dblIn: Double; var lOut: Longint): HResult; stdcall;
{$EXTERNALSYM VarI4FromCy}
function VarI4FromCy(cyIn: TCurrency; var lOut: Longint): HResult; stdcall;
{$EXTERNALSYM VarI4FromDate}
function VarI4FromDate(dateIn: TOleDate; var lOut: Longint): HResult; stdcall;
{$EXTERNALSYM VarI4FromStr}
function VarI4FromStr(strIn: TBStr; lcid: TLCID; dwFlags: Longint; var lOut: Longint): HResult; stdcall;
{$EXTERNALSYM VarI4FromDisp}
function VarI4FromDisp(dispIn: IDispatch; lcid: TLCID; var lOut: Longint): HResult; stdcall;
{$EXTERNALSYM VarI4FromBool}
function VarI4FromBool(boolIn: TOleBool; var lOut: Longint): HResult; stdcall;

{$EXTERNALSYM VarR4FromUI1}
function VarR4FromUI1(bIn: Byte; var fltOut: Single): HResult; stdcall;
{$EXTERNALSYM VarR4FromI2}
function VarR4FromI2(sIn: Smallint; var fltOut: Single): HResult; stdcall;
{$EXTERNALSYM VarR4FromI4}
function VarR4FromI4(lIn: Longint; var fltOut: Single): HResult; stdcall;
{$EXTERNALSYM VarR4FromR8}
function VarR4FromR8(dblIn: Double; var fltOut: Single): HResult; stdcall;
{$EXTERNALSYM VarR4FromCy}
function VarR4FromCy(cyIn: TCurrency; var fltOut: Single): HResult; stdcall;
{$EXTERNALSYM VarR4FromDate}
function VarR4FromDate(dateIn: TOleDate; var fltOut: Single): HResult; stdcall;
{$EXTERNALSYM VarR4FromStr}
function VarR4FromStr(strIn: TBStr; lcid: TLCID; dwFlags: Longint; var fltOut: Single): HResult; stdcall;
{$EXTERNALSYM VarR4FromDisp}
function VarR4FromDisp(dispIn: IDispatch; lcid: TLCID; var fltOut: Single): HResult; stdcall;
{$EXTERNALSYM VarR4FromBool}
function VarR4FromBool(boolIn: TOleBool; var fltOut: Single): HResult; stdcall;

{$EXTERNALSYM VarR8FromUI1}
function VarR8FromUI1(bIn: Byte; var dblOut: Double): HResult; stdcall;
{$EXTERNALSYM VarR8FromI2}
function VarR8FromI2(sIn: Smallint; var dblOut: Double): HResult; stdcall;
{$EXTERNALSYM VarR8FromI4}
function VarR8FromI4(lIn: Longint; var dblOut: Double): HResult; stdcall;
{$EXTERNALSYM VarR8FromR4}
function VarR8FromR4(fltIn: Single; var dblOut: Double): HResult; stdcall;
{$EXTERNALSYM VarR8FromCy}
function VarR8FromCy(cyIn: TCurrency; var dblOut: Double): HResult; stdcall;
{$EXTERNALSYM VarR8FromDate}
function VarR8FromDate(dateIn: TOleDate; var dblOut: Double): HResult; stdcall;
{$EXTERNALSYM VarR8FromStr}
function VarR8FromStr(strIn: TBStr; lcid: TLCID; dwFlags: Longint; var dblOut: Double): HResult; stdcall;
{$EXTERNALSYM VarR8FromDisp}
function VarR8FromDisp(dispIn: IDispatch; lcid: TLCID; var dblOut: Double): HResult; stdcall;
{$EXTERNALSYM VarR8FromBool}
function VarR8FromBool(boolIn: TOleBool; var dblOut: Double): HResult; stdcall;

{$EXTERNALSYM VarDateFromUI1}
function VarDateFromUI1(bIn: Byte; var dateOut: TOleDate): HResult; stdcall;
{$EXTERNALSYM VarDateFromI2}
function VarDateFromI2(sIn: Smallint; var dateOut: TOleDate): HResult; stdcall;
{$EXTERNALSYM VarDateFromI4}
function VarDateFromI4(lIn: Longint; var dateOut: TOleDate): HResult; stdcall;
{$EXTERNALSYM VarDateFromR4}
function VarDateFromR4(fltIn: Single; var dateOut: TOleDate): HResult; stdcall;
{$EXTERNALSYM VarDateFromR8}
function VarDateFromR8(dblIn: Double; var dateOut: TOleDate): HResult; stdcall;
{$EXTERNALSYM VarDateFromCy}
function VarDateFromCy(cyIn: TCurrency; var dateOut: TOleDate): HResult; stdcall;
{$EXTERNALSYM VarDateFromStr}
function VarDateFromStr(strIn: TBStr; lcid: TLCID; dwFlags: Longint; var dateOut: TOleDate): HResult; stdcall;
{$EXTERNALSYM VarDateFromDisp}
function VarDateFromDisp(dispIn: IDispatch; lcid: TLCID; var dateOut: TOleDate): HResult; stdcall;
{$EXTERNALSYM VarDateFromBool}
function VarDateFromBool(boolIn: TOleBool; var dateOut: TOleDate): HResult; stdcall;

{$EXTERNALSYM VarCyFromUI1}
function VarCyFromUI1(bIn: Byte; var cyOut: TCurrency): HResult; stdcall;
{$EXTERNALSYM VarCyFromI2}
function VarCyFromI2(sIn: Smallint; var cyOut: TCurrency): HResult; stdcall;
{$EXTERNALSYM VarCyFromI4}
function VarCyFromI4(lIn: Longint; var cyOut: TCurrency): HResult; stdcall;
{$EXTERNALSYM VarCyFromR4}
function VarCyFromR4(fltIn: Single; var cyOut: TCurrency): HResult; stdcall;
{$EXTERNALSYM VarCyFromR8}
function VarCyFromR8(dblIn: Double; var cyOut: TCurrency): HResult; stdcall;
{$EXTERNALSYM VarCyFromDate}
function VarCyFromDate(dateIn: TOleDate; var cyOut: TCurrency): HResult; stdcall;
{$EXTERNALSYM VarCyFromStr}
function VarCyFromStr(strIn: TBStr; lcid: TLCID; dwFlags: Longint; var cyOut: TCurrency): HResult; stdcall;
{$EXTERNALSYM VarCyFromDisp}
function VarCyFromDisp(dispIn: IDispatch; lcid: TLCID; var cyOut: TCurrency): HResult; stdcall;
{$EXTERNALSYM VarCyFromBool}
function VarCyFromBool(boolIn: TOleBool; var cyOut: TCurrency): HResult; stdcall;

{$EXTERNALSYM VarBStrFromUI1}
function VarBStrFromUI1(bVal: Byte; lcid: TLCID; dwFlags: Longint; var bstrOut: TBStr): HResult; stdcall;
{$EXTERNALSYM VarBStrFromI2}
function VarBStrFromI2(iVal: Smallint; lcid: TLCID; dwFlags: Longint; var bstrOut: TBStr): HResult; stdcall;
{$EXTERNALSYM VarBStrFromI4}
function VarBStrFromI4(lIn: Longint; lcid: TLCID; dwFlags: Longint; var bstrOut: TBStr): HResult; stdcall;
{$EXTERNALSYM VarBStrFromR4}
function VarBStrFromR4(fltIn: Single; lcid: TLCID; dwFlags: Longint; var bstrOut: TBStr): HResult; stdcall;
{$EXTERNALSYM VarBStrFromR8}
function VarBStrFromR8(dblIn: Double; lcid: TLCID; dwFlags: Longint; var bstrOut: TBStr): HResult; stdcall;
{$EXTERNALSYM VarBStrFromCy}
function VarBStrFromCy(cyIn: TCurrency; lcid: TLCID; dwFlags: Longint; var bstrOut: TBStr): HResult; stdcall;
{$EXTERNALSYM VarBStrFromDate}
function VarBStrFromDate(dateIn: TOleDate; lcid: TLCID; dwFlags: Longint; var bstrOut: TBStr): HResult; stdcall;
{$EXTERNALSYM VarBStrFromDisp}
function VarBStrFromDisp(dispIn: IDispatch; lcid: TLCID; dwFlags: Longint; var bstrOut: TBStr): HResult; stdcall;
{$EXTERNALSYM VarBStrFromBool}
function VarBStrFromBool(boolIn: TOleBool; lcid: TLCID; dwFlags: Longint; var bstrOut: TBStr): HResult; stdcall;

{$EXTERNALSYM VarBoolFromUI1}
function VarBoolFromUI1(bIn: Byte; var boolOut: TOleBool): HResult; stdcall;
{$EXTERNALSYM VarBoolFromI2}
function VarBoolFromI2(sIn: Smallint; var boolOut: TOleBool): HResult; stdcall;
{$EXTERNALSYM VarBoolFromI4}
function VarBoolFromI4(lIn: Longint; var boolOut: TOleBool): HResult; stdcall;
{$EXTERNALSYM VarBoolFromR4}
function VarBoolFromR4(fltIn: Single; var boolOut: TOleBool): HResult; stdcall;
{$EXTERNALSYM VarBoolFromR8}
function VarBoolFromR8(dblIn: Double; var boolOut: TOleBool): HResult; stdcall;
{$EXTERNALSYM VarBoolFromDate}
function VarBoolFromDate(dateIn: TOleDate; var boolOut: TOleBool): HResult; stdcall;
{$EXTERNALSYM VarBoolFromCy}
function VarBoolFromCy(cyIn: TCurrency; var boolOut: TOleBool): HResult; stdcall;
{$EXTERNALSYM VarBoolFromStr}
function VarBoolFromStr(strIn: TBStr; lcid: TLCID; dwFlags: Longint; var boolOut: TOleBool): HResult; stdcall;
{$EXTERNALSYM VarBoolFromDisp}
function VarBoolFromDisp(dispIn: IDispatch; lcid: TLCID; var boolOut: TOleBool): HResult; stdcall;

{ TypeInfo API }

{$EXTERNALSYM LHashValOfNameSys}
function LHashValOfNameSys(syskind: TSysKind; lcid: TLCID;
  szName: POleStr): Longint; stdcall;
{$EXTERNALSYM LHashValOfNameSysA}
function LHashValOfNameSysA(syskind: TSysKind; lcid: TLCID;
  szName: PChar): Longint; stdcall;

{$EXTERNALSYM LHashValOfName}
function LHashValOfName(lcid: TLCID; szName: POleStr): Longint;
{$EXTERNALSYM WHashValOfLHashVal}
function WHashValOfLHashVal(lhashval: Longint): Word;
{$EXTERNALSYM IsHashValCompatible}
function IsHashValCompatible(lhashval1, lhashval2: Longint): Boolean;

{$EXTERNALSYM LoadTypeLib}
function LoadTypeLib(szFile: POleStr; var tlib: ITypeLib): HResult; stdcall;
{$EXTERNALSYM LoadRegTypeLib}
function LoadRegTypeLib(const guid: TGUID; wVerMajor, wVerMinor: Word;
  lcid: TLCID; var tlib: ITypeLib): HResult; stdcall;
{$EXTERNALSYM QueryPathOfRegTypeLib}
function QueryPathOfRegTypeLib(const guid: TGUID; wMaj, wMin: Word;
  lcid: TLCID; var bstrPathName: TBStr): HResult; stdcall;
{$EXTERNALSYM RegisterTypeLib}
function RegisterTypeLib(tlib: ITypeLib; szFullPath, szHelpDir: POleStr): HResult; stdcall;
{$EXTERNALSYM CreateTypeLib}
function CreateTypeLib(syskind: TSysKind; szFile: POleStr;
  var ctlib: ICreateTypeLib): HResult; stdcall;

{ IDispatch implementation support }

{$EXTERNALSYM DispGetParam}
function DispGetParam(var dispparams: TDispParams; position: Integer;
  vtTarg: TVarType; var varResult: Variant; var puArgErr: Integer): HResult; stdcall;
{$EXTERNALSYM DispGetIDsOfNames}
function DispGetIDsOfNames(tinfo: ITypeInfo; var rgszNames; cNames: Integer;
  var rgdispid): HResult; stdcall;
{$EXTERNALSYM DispInvoke}
function DispInvoke(This: Pointer; tinfo: ITypeInfo; dispidMember: TDispID;
  wFlags: Word; var params: TDispParams; var varResult: Variant;
  var excepinfo: TExcepInfo; var puArgErr: Integer): HResult; stdcall;
{$EXTERNALSYM CreateDispTypeInfo}
function CreateDispTypeInfo(var idata: TInterfaceData; lcid: TLCID;
  var tinfo: ITypeInfo): HResult; stdcall;
{$EXTERNALSYM CreateStdDispatch}
function CreateStdDispatch(unkOuter: IUnknown; pvThis: Pointer;
  tinfo: ITypeInfo; var unkStdDisp: IUnknown): HResult; stdcall;

{ Active object registration API }

{$EXTERNALSYM RegisterActiveObject}
function RegisterActiveObject(unk: IUnknown; const clsid: TCLSID;
  dwFlags: Longint; var dwRegister: Longint): HResult; stdcall;
{$EXTERNALSYM RevokeActiveObject}
function RevokeActiveObject(dwRegister: Longint; pvReserved: Pointer): HResult; stdcall;
{$EXTERNALSYM GetActiveObject}
function GetActiveObject(const clsid: TCLSID; pvReserved: Pointer;
  var unk: IUnknown): HResult; stdcall;

{ ErrorInfo API }

{$EXTERNALSYM SetErrorInfo}
function SetErrorInfo(dwReserved: Longint; errinfo: IErrorInfo): HResult; stdcall;
{$EXTERNALSYM GetErrorInfo}
function GetErrorInfo(dwReserved: Longint; var errinfo: IErrorInfo): HResult; stdcall;
{$EXTERNALSYM CreateErrorInfo}
function CreateErrorInfo(var errinfo: ICreateErrorInfo): HResult; stdcall;

{ Misc API }

{$EXTERNALSYM OaBuildVersion}
function OaBuildVersion: Longint; stdcall;

{ OLE API prototypes }

{$EXTERNALSYM OleBuildVersion}
function OleBuildVersion: HResult; stdcall;

{ helper functions }

{$EXTERNALSYM ReadClassStg}
function ReadClassStg(stg: IStorage; var clsid: TCLSID): HResult; stdcall;
{$EXTERNALSYM WriteClassStg}
function WriteClassStg(stg: IStorage; const clsid: TIID): HResult; stdcall;
{$EXTERNALSYM ReadClassStm}
function ReadClassStm(stm: IStream; var clsid: TCLSID): HResult; stdcall;
{$EXTERNALSYM WriteClassStm}
function WriteClassStm(stm: IStream; const clsid: TIID): HResult; stdcall;
{$EXTERNALSYM WriteFmtUserTypeStg}
function WriteFmtUserTypeStg(stg: IStorage; cf: TClipFormat;
  pszUserType: POleStr): HResult; stdcall;
{$EXTERNALSYM ReadFmtUserTypeStg}
function ReadFmtUserTypeStg(stg: IStorage; var cf: TClipFormat;
  var pszUserType: POleStr): HResult; stdcall;

{ Initialization and termination }

{$EXTERNALSYM OleInitialize}
function OleInitialize(pwReserved: Pointer): HResult; stdcall;
{$EXTERNALSYM OleUninitialize}
procedure OleUninitialize; stdcall;

{ APIs to query whether (Embedded/Linked) object can be created from
  the data object }

{$EXTERNALSYM OleQueryLinkFromData}
function OleQueryLinkFromData(srcDataObject: IDataObject): HResult; stdcall;
{$EXTERNALSYM OleQueryCreateFromData}
function OleQueryCreateFromData(srcDataObject: IDataObject): HResult; stdcall;

{ Object creation APIs }

{$EXTERNALSYM OleCreate}
function OleCreate(const clsid: TCLSID; const iid: TIID; renderopt: Longint;
  formatEtc: PFormatEtc; clientSite: IOleClientSite;
  stg: IStorage; var vObj): HResult; stdcall;
{$EXTERNALSYM OleCreateFromData}
function OleCreateFromData(srcDataObj: IDataObject; const iid: TIID;
  renderopt: Longint; formatEtc: PFormatEtc; clientSite: IOleClientSite;
  stg: IStorage; var vObj): HResult; stdcall;
{$EXTERNALSYM OleCreateLinkFromData}
function OleCreateLinkFromData(srcDataObj: IDataObject; const iid: TIID;
  renderopt: Longint; formatEtc: PFormatEtc; clientSite: IOleClientSite;
  stg: IStorage; var vObj): HResult; stdcall;
{$EXTERNALSYM OleCreateStaticFromData}
function OleCreateStaticFromData(srcDataObj: IDataObject; const iid: TIID;
  renderopt: Longint; formatEtc: PFormatEtc; clientSite: IOleClientSite;
  stg: IStorage; var vObj): HResult; stdcall;
{$EXTERNALSYM OleCreateLink}
function OleCreateLink(mkLinkSrc: IMoniker; const iid: TIID;
  renderopt: Longint; formatEtc: PFormatEtc; clientSite: IOleClientSite;
  stg: IStorage; var vObj): HResult; stdcall;
{$EXTERNALSYM OleCreateLinkToFile}
function OleCreateLinkToFile(pszFileName: POleStr; const iid: TIID;
  renderopt: Longint; formatEtc: PFormatEtc; clientSite: IOleClientSite;
  stg: IStorage; var vObj): HResult; stdcall;
{$EXTERNALSYM OleCreateFromFile}
function OleCreateFromFile(const clsid: TCLSID; pszFileName: POleStr;
  const iid: TIID; renderopt: Longint; formatEtc: PFormatEtc;
  clientSite: IOleClientSite; stg: IStorage; var vObj): HResult; stdcall;
{$EXTERNALSYM OleLoad}
function OleLoad(stg: IStorage; const iid: TIID; clientSite: IOleClientSite;
  var vObj): HResult; stdcall;
{$EXTERNALSYM OleSave}
function OleSave(ps: IPersistStorage; stg: IStorage; fSameAsLoad: BOOL): HResult; stdcall;
{$EXTERNALSYM OleLoadFromStream}
function OleLoadFromStream(stm: IStream; const iidInterface: TIID;
  var vObj): HResult; stdcall;
{$EXTERNALSYM OleSaveToStream}
function OleSaveToStream(pstm: IPersistStream; stm: IStream): HResult; stdcall;
{$EXTERNALSYM OleSetContainedObject}
function OleSetContainedObject(unknown: IUnknown; fContained: BOOL): HResult; stdcall;
{$EXTERNALSYM OleNoteObjectVisible}
function OleNoteObjectVisible(unknown: IUnknown; fVisible: BOOL): HResult; stdcall;

{ DragDrop APIs }

{$EXTERNALSYM RegisterDragDrop}
function RegisterDragDrop(wnd: HWnd; dropTarget: IDropTarget): HResult; stdcall;
{$EXTERNALSYM RevokeDragDrop}
function RevokeDragDrop(wnd: HWnd): HResult; stdcall;
{$EXTERNALSYM DoDragDrop}
function DoDragDrop(dataObj: IDataObject; dropSource: IDropSource;
  dwOKEffects: Longint; var dwEffect: Longint): HResult; stdcall;

{ Clipboard APIs }

{$EXTERNALSYM OleSetClipboard}
function OleSetClipboard(dataObj: IDataObject): HResult; stdcall;
{$EXTERNALSYM OleGetClipboard}
function OleGetClipboard(var dataObj: IDataObject): HResult; stdcall;
{$EXTERNALSYM OleFlushClipboard}
function OleFlushClipboard: HResult; stdcall;
{$EXTERNALSYM OleIsCurrentClipboard}
function OleIsCurrentClipboard(dataObj: IDataObject): HResult; stdcall;

{ In-place editing APIs }

{$EXTERNALSYM OleCreateMenuDescriptor}
function OleCreateMenuDescriptor(hmenuCombined: HMenu;
  var menuWidths: TOleMenuGroupWidths): HMenu; stdcall;
{$EXTERNALSYM OleSetMenuDescriptor}
function OleSetMenuDescriptor(holemenu: HMenu; hwndFrame: HWnd;
  hwndActiveObject: HWnd; frame: IOleInPlaceFrame;
  activeObj: IOleInPlaceActiveObject): HResult; stdcall;
{$EXTERNALSYM OleDestroyMenuDescriptor}
function OleDestroyMenuDescriptor(holemenu: HMenu): HResult; stdcall;
{$EXTERNALSYM OleTranslateAccelerator}
function OleTranslateAccelerator(frame: IOleInPlaceFrame;
  var frameInfo: TOleInPlaceFrameInfo; msg: PMsg): HResult; stdcall;

{ Helper APIs }

{$EXTERNALSYM OleDuplicateData}
function OleDuplicateData(hSrc: THandle; cfFormat: TClipFormat;
  uiFlags: Integer): THandle; stdcall;
{$EXTERNALSYM OleDraw}
function OleDraw(unknown: IUnknown; dwAspect: Longint; hdcDraw: HDC;
  const rcBounds: TRect): HResult; stdcall;
{$EXTERNALSYM OleRun}
function OleRun(unknown: IUnknown): HResult; stdcall;
{$EXTERNALSYM OleIsRunning}
function OleIsRunning(obj: IOleObject): BOOL; stdcall;
{$EXTERNALSYM OleLockRunning}
function OleLockRunning(unknown: IUnknown; fLock: BOOL;
  fLastUnlockCloses: BOOL): HResult; stdcall;
{$EXTERNALSYM ReleaseStgMedium}
procedure ReleaseStgMedium(var medium: TStgMedium); stdcall;
{$EXTERNALSYM CreateOleAdviseHolder}
function CreateOleAdviseHolder(var OAHolder: IOleAdviseHolder): HResult; stdcall;
{$EXTERNALSYM OleCreateDefaultHandler}
function OleCreateDefaultHandler(const clsid: TCLSID; unkOuter: IUnknown;
  const iid: TIID; var vObj): HResult; stdcall;
{$EXTERNALSYM OleCreateEmbeddingHelper}
function OleCreateEmbeddingHelper(const clsid: TCLSID; unkOuter: IUnknown;
  flags: Longint; cf: IClassFactory; const iid: TIID; var vObj): HResult; stdcall;
{$EXTERNALSYM IsAccelerator}
function IsAccelerator(accel: HAccel; cAccelEntries: Integer; msg: PMsg;
  var pwCmd: Word): BOOL; stdcall;

{ Icon extraction helper APIs }

{$EXTERNALSYM OleGetIconOfFile}
function OleGetIconOfFile(pszPath: POleStr; fUseFileAsLabel: BOOL): HGlobal; stdcall;
{$EXTERNALSYM OleGetIconOfClass}
function OleGetIconOfClass(const clsid: TCLSID; pszLabel: POleStr;
  fUseTypeAsLabel: BOOL): HGlobal; stdcall;
{$EXTERNALSYM OleMetafilePictFromIconAndLabel}
function OleMetafilePictFromIconAndLabel(icon: HIcon; pszLabel: POleStr;
  pszSourceFile: POleStr; iIconIndex: Integer): HGlobal; stdcall;

{ Registration database helper APIs }

{$EXTERNALSYM OleRegGetUserType}
function OleRegGetUserType(const clsid: TCLSID; dwFormOfType: Longint;
  var pszUserType: POleStr): HResult; stdcall;
{$EXTERNALSYM OleRegGetMiscStatus}
function OleRegGetMiscStatus(const clsid: TCLSID; dwAspect: Longint;
  var dwStatus: Longint): HResult; stdcall;
{$EXTERNALSYM OleRegEnumFormatEtc}
function OleRegEnumFormatEtc(const clsid: TCLSID; dwDirection: Longint;
  var Enum: IEnumFormatEtc): HResult; stdcall;
{$EXTERNALSYM OleRegEnumVerbs}
function OleRegEnumVerbs(const clsid: TCLSID;
  var Enum: IEnumOleVerb): HResult; stdcall;

{ OLE 1.0 conversion APIs }

{$EXTERNALSYM OleConvertIStorageToOLESTREAM}
function OleConvertIStorageToOLESTREAM(stg: IStorage;
  polestm: Pointer): HResult; stdcall;
{$EXTERNALSYM OleConvertOLESTREAMToIStorage}
function OleConvertOLESTREAMToIStorage(polestm: Pointer; stg: IStorage;
  td: PDVTargetDevice): HResult; stdcall;
{$EXTERNALSYM OleConvertIStorageToOLESTREAMEx}
function OleConvertIStorageToOLESTREAMEx(stg: IStorage; cfFormat: TClipFormat;
  lWidth: Longint; lHeight: Longint; dwSize: Longint; var medium: TStgMedium;
  polestm: Pointer): HResult; stdcall;
{$EXTERNALSYM OleConvertOLESTREAMToIStorageEx}
function OleConvertOLESTREAMToIStorageEx(polestm: Pointer; stg: IStorage;
  var cfFormat: TClipFormat; var lWidth: Longint; var lHeight: Longint;
  var dwSize: Longint; var medium: TStgMedium): HResult; stdcall;

{ Storage utility APIs }

{$EXTERNALSYM GetHGlobalFromILockBytes}
function GetHGlobalFromILockBytes(lkbyt: ILockBytes; var hglob: HGlobal): HResult; stdcall;
{$EXTERNALSYM CreateILockBytesOnHGlobal}
function CreateILockBytesOnHGlobal(hglob: HGlobal; fDeleteOnRelease: BOOL;
  var lkbyt: ILockBytes): HResult; stdcall;
{$EXTERNALSYM GetHGlobalFromStream}
function GetHGlobalFromStream(stm: IStream; var hglob: HGlobal): HResult; stdcall;
{$EXTERNALSYM CreateStreamOnHGlobal}
function CreateStreamOnHGlobal(hglob: HGlobal; fDeleteOnRelease: BOOL;
  var stm: IStream): HResult; stdcall;

{ ConvertTo APIs }

{$EXTERNALSYM OleDoAutoConvert}
function OleDoAutoConvert(stg: IStorage; var clsidNew: TCLSID): HResult; stdcall;
{$EXTERNALSYM OleGetAutoConvert}
function OleGetAutoConvert(const clsidOld: TCLSID; var clsidNew: TCLSID): HResult; stdcall;
{$EXTERNALSYM OleSetAutoConvert}
function OleSetAutoConvert(const clsidOld: TCLSID; const clsidNew: TCLSID): HResult; stdcall;
{$EXTERNALSYM GetConvertStg}
function GetConvertStg(stg: IStorage): HResult; stdcall;
{$EXTERNALSYM SetConvertStg}
function SetConvertStg(stg: IStorage; fConvert: BOOL): HResult; stdcall;

implementation

const
  ole32    = 'ole32.dll';
  oleaut32 = 'oleaut32.dll';

{ Externals from ole32.dll }

function IsEqualGUID;                   external ole32 name 'IsEqualGUID';
function IsEqualIID;                    external ole32 name 'IsEqualGUID';
function IsEqualCLSID;                  external ole32 name 'IsEqualGUID';
function CoBuildVersion;                external ole32 name 'CoBuildVersion';
function CoInitialize;                  external ole32 name 'CoInitialize';
procedure CoUninitialize;               external ole32 name 'CoUninitialize';
function CoGetMalloc;                   external ole32 name 'CoGetMalloc';
function CoGetCurrentProcess;           external ole32 name 'CoGetCurrentProcess';
function CoRegisterMallocSpy;           external ole32 name 'CoRegisterMallocSpy';
function CoRevokeMallocSpy;             external ole32 name 'CoRevokeMallocSpy';
function CoCreateStandardMalloc;        external ole32 name 'CoCreateStandardMalloc';
function CoGetClassObject;              external ole32 name 'CoGetClassObject';
function CoRegisterClassObject;         external ole32 name 'CoRegisterClassObject';
function CoRevokeClassObject;           external ole32 name 'CoRevokeClassObject';
function CoGetMarshalSizeMax;           external ole32 name 'CoGetMarshalSizeMax';
function CoMarshalInterface;            external ole32 name 'CoMarshalInterface';
function CoUnmarshalInterface;          external ole32 name 'CoUnmarshalInterface';
function CoMarshalHResult;              external ole32 name 'CoMarshalHResult';
function CoUnmarshalHResult;            external ole32 name 'CoUnmarshalHResult';
function CoReleaseMarshalData;          external ole32 name 'CoReleaseMarshalData';
function CoDisconnectObject;            external ole32 name 'CoDisconnectObject';
function CoLockObjectExternal;          external ole32 name 'CoLockObjectExternal';
function CoGetStandardMarshal;          external ole32 name 'CoGetStandardMarshal';
function CoIsHandlerConnected;          external ole32 name 'CoIsHandlerConnected';
function CoHasStrongExternalConnections; external ole32 name 'CoHasStrongExternalConnections';
function CoMarshalInterThreadInterfaceInStream; external ole32 name 'CoMarshalInterThreadInterfaceInStream';
function CoGetInterfaceAndReleaseStream; external ole32 name 'CoGetInterfaceAndReleaseStream';
function CoCreateFreeThreadedMarshaler; external ole32 name 'CoCreateFreeThreadedMarshaler';
function CoLoadLibrary;                 external ole32 name 'CoLoadLibrary';
procedure CoFreeLibrary;                external ole32 name 'CoFreeLibrary';
procedure CoFreeAllLibraries;           external ole32 name 'CoFreeAllLibraries';
procedure CoFreeUnusedLibraries;        external ole32 name 'CoFreeUnusedLibraries';
function CoCreateInstance;              external ole32 name 'CoCreateInstance';
function StringFromCLSID;               external ole32 name 'StringFromCLSID';
function CLSIDFromString;               external ole32 name 'CLSIDFromString';
function StringFromIID;                 external ole32 name 'StringFromIID';
function IIDFromString;                 external ole32 name 'IIDFromString';
function CoIsOle1Class;                 external ole32 name 'CoIsOle1Class';
function ProgIDFromCLSID;               external ole32 name 'ProgIDFromCLSID';
function CLSIDFromProgID;               external ole32 name 'CLSIDFromProgID';
function StringFromGUID2;               external ole32 name 'StringFromGUID2';
function CoCreateGuid;                  external ole32 name 'CoCreateGuid';
function CoFileTimeToDosDateTime;       external ole32 name 'CoFileTimeToDosDateTime';
function CoDosDateTimeToFileTime;       external ole32 name 'CoDosDateTimeToFileTime';
function CoFileTimeNow;                 external ole32 name 'CoFileTimeNow';
function CoRegisterMessageFilter;       external ole32 name 'CoRegisterMessageFilter';
function CoGetTreatAsClass;             external ole32 name 'CoGetTreatAsClass';
function CoTreatAsClass;                external ole32 name 'CoTreatAsClass';
function CoTaskMemAlloc;                external ole32 name 'CoTaskMemAlloc';
function CoTaskMemRealloc;              external ole32 name 'CoTaskMemRealloc';
procedure CoTaskMemFree;                external ole32 name 'CoTaskMemFree';
function CreateDataAdviseHolder;        external ole32 name 'CreateDataAdviseHolder';
function CreateDataCache;               external ole32 name 'CreateDataCache';
function StgCreateDocfile;              external ole32 name 'StgCreateDocfile';
function StgCreateDocfileOnILockBytes;  external ole32 name 'StgCreateDocfileOnILockBytes';
function StgOpenStorage;                external ole32 name 'StgOpenStorage';
function StgOpenStorageOnILockBytes;    external ole32 name 'StgOpenStorageOnILockBytes';
function StgIsStorageFile;              external ole32 name 'StgIsStorageFile';
function StgIsStorageILockBytes;        external ole32 name 'StgIsStorageILockBytes';
function StgSetTimes;                   external ole32 name 'StgSetTimes';
function BindMoniker;                   external ole32 name 'BindMoniker';
function MkParseDisplayName;            external ole32 name 'MkParseDisplayName';
function MonikerRelativePathTo;         external ole32 name 'MonikerRelativePathTo';
function MonikerCommonPrefixWith;       external ole32 name 'MonikerCommonPrefixWith';
function CreateBindCtx;                 external ole32 name 'CreateBindCtx';
function CreateGenericComposite;        external ole32 name 'CreateGenericComposite';
function GetClassFile;                  external ole32 name 'GetClassFile';
function CreateFileMoniker;             external ole32 name 'CreateFileMoniker';
function CreateItemMoniker;             external ole32 name 'CreateItemMoniker';
function CreateAntiMoniker;             external ole32 name 'CreateAntiMoniker';
function CreatePointerMoniker;          external ole32 name 'CreatePointerMoniker';
function GetRunningObjectTable;         external ole32 name 'GetRunningObjectTable';
function OleBuildVersion;               external ole32 name 'OleBuildVersion';
function ReadClassStg;                  external ole32 name 'ReadClassStg';
function WriteClassStg;                 external ole32 name 'WriteClassStg';
function ReadClassStm;                  external ole32 name 'ReadClassStm';
function WriteClassStm;                 external ole32 name 'WriteClassStm';
function WriteFmtUserTypeStg;           external ole32 name 'WriteFmtUserTypeStg';
function ReadFmtUserTypeStg;            external ole32 name 'ReadFmtUserTypeStg';
function OleInitialize;                 external ole32 name 'OleInitialize';
procedure OleUninitialize;              external ole32 name 'OleUninitialize';
function OleQueryLinkFromData;          external ole32 name 'OleQueryLinkFromData';
function OleQueryCreateFromData;        external ole32 name 'OleQueryCreateFromData';
function OleCreate;                     external ole32 name 'OleCreate';
function OleCreateFromData;             external ole32 name 'OleCreateFromData';
function OleCreateLinkFromData;         external ole32 name 'OleCreateLinkFromData';
function OleCreateStaticFromData;       external ole32 name 'OleCreateStaticFromData';
function OleCreateLink;                 external ole32 name 'OleCreateLink';
function OleCreateLinkToFile;           external ole32 name 'OleCreateLinkToFile';
function OleCreateFromFile;             external ole32 name 'OleCreateFromFile';
function OleLoad;                       external ole32 name 'OleLoad';
function OleSave;                       external ole32 name 'OleSave';
function OleLoadFromStream;             external ole32 name 'OleLoadFromStream';
function OleSaveToStream;               external ole32 name 'OleSaveToStream';
function OleSetContainedObject;         external ole32 name 'OleSetContainedObject';
function OleNoteObjectVisible;          external ole32 name 'OleNoteObjectVisible';
function RegisterDragDrop;              external ole32 name 'RegisterDragDrop';
function RevokeDragDrop;                external ole32 name 'RevokeDragDrop';
function DoDragDrop;                    external ole32 name 'DoDragDrop';
function OleSetClipboard;               external ole32 name 'OleSetClipboard';
function OleGetClipboard;               external ole32 name 'OleGetClipboard';
function OleFlushClipboard ;            external ole32 name 'OleFlushClipboard';
function OleIsCurrentClipboard;         external ole32 name 'OleIsCurrentClipboard';
function OleCreateMenuDescriptor;       external ole32 name 'OleCreateMenuDescriptor';
function OleSetMenuDescriptor;          external ole32 name 'OleSetMenuDescriptor';
function OleDestroyMenuDescriptor;      external ole32 name 'OleDestroyMenuDescriptor';
function OleTranslateAccelerator;       external ole32 name 'OleTranslateAccelerator';
function OleDuplicateData;              external ole32 name 'OleDuplicateData';
function OleDraw;                       external ole32 name 'OleDraw';
function OleRun;                        external ole32 name 'OleRun';
function OleIsRunning;                  external ole32 name 'OleIsRunning';
function OleLockRunning;                external ole32 name 'OleLockRunning';
procedure ReleaseStgMedium;             external ole32 name 'ReleaseStgMedium';
function CreateOleAdviseHolder;         external ole32 name 'CreateOleAdviseHolder';
function OleCreateDefaultHandler;       external ole32 name 'OleCreateDefaultHandler';
function OleCreateEmbeddingHelper;      external ole32 name 'OleCreateEmbeddingHelper';
function IsAccelerator;                 external ole32 name 'IsAccelerator';
function OleGetIconOfFile;              external ole32 name 'OleGetIconOfFile';
function OleGetIconOfClass;             external ole32 name 'OleGetIconOfClass';
function OleMetafilePictFromIconAndLabel; external ole32 name 'OleMetafilePictFromIconAndLabel';
function OleRegGetUserType;             external ole32 name 'OleRegGetUserType';
function OleRegGetMiscStatus;           external ole32 name 'OleRegGetMiscStatus';
function OleRegEnumFormatEtc;           external ole32 name 'OleRegEnumFormatEtc';
function OleRegEnumVerbs;               external ole32 name 'OleRegEnumVerbs';
function OleConvertIStorageToOLESTREAM; external ole32 name 'OleConvertIStorageToOLESTREAM';
function OleConvertOLESTREAMToIStorage; external ole32 name 'OleConvertOLESTREAMToIStorage';
function OleConvertIStorageToOLESTREAMEx; external ole32 name 'OleConvertIStorageToOLESTREAMEx';
function OleConvertOLESTREAMToIStorageEx; external ole32 name 'OleConvertOLESTREAMToIStorageEx';
function GetHGlobalFromILockBytes;      external ole32 name 'GetHGlobalFromILockBytes';
function CreateILockBytesOnHGlobal;     external ole32 name 'CreateILockBytesOnHGlobal';
function GetHGlobalFromStream;          external ole32 name 'GetHGlobalFromStream';
function CreateStreamOnHGlobal;         external ole32 name 'CreateStreamOnHGlobal';
function OleDoAutoConvert;              external ole32 name 'OleDoAutoConvert';
function OleGetAutoConvert;             external ole32 name 'OleGetAutoConvert';
function OleSetAutoConvert;             external ole32 name 'OleSetAutoConvert';
function GetConvertStg;                 external ole32 name 'GetConvertStg';
function SetConvertStg;                 external ole32 name 'SetConvertStg';

{ Externals from oleaut32.dll }

function SysAllocString;                external oleaut32 name 'SysAllocString';
function SysReAllocString;              external oleaut32 name 'SysReAllocString';
function SysAllocStringLen;             external oleaut32 name 'SysAllocStringLen';
function SysReAllocStringLen;           external oleaut32 name 'SysReAllocStringLen';
procedure SysFreeString;                external oleaut32 name 'SysFreeString';
function SysStringLen;                  external oleaut32 name 'SysStringLen';
function SysStringByteLen;              external oleaut32 name 'SysStringByteLen';
function SysAllocStringByteLen;         external oleaut32 name 'SysAllocStringByteLen';
function DosDateTimeToVariantTime;      external oleaut32 name 'DosDateTimeToVariantTime';
function VariantTimeToDosDateTime;      external oleaut32 name 'VariantTimeToDosDateTime';
function SafeArrayAllocDescriptor;      external oleaut32 name 'SafeArrayAllocDescriptor';
function SafeArrayAllocData;            external oleaut32 name 'SafeArrayAllocData';
function SafeArrayCreate;               external oleaut32 name 'SafeArrayCreate';
function SafeArrayDestroyDescriptor;    external oleaut32 name 'SafeArrayDestroyDescriptor';
function SafeArrayDestroyData;          external oleaut32 name 'SafeArrayDestroyData';
function SafeArrayDestroy;              external oleaut32 name 'SafeArrayDestroy';
function SafeArrayRedim;                external oleaut32 name 'SafeArrayRedim';
function SafeArrayGetDim;               external oleaut32 name 'SafeArrayGetDim';
function SafeArrayGetElemsize;          external oleaut32 name 'SafeArrayGetElemsize';
function SafeArrayGetUBound;            external oleaut32 name 'SafeArrayGetUBound';
function SafeArrayGetLBound;            external oleaut32 name 'SafeArrayGetLBound';
function SafeArrayLock;                 external oleaut32 name 'SafeArrayLock';
function SafeArrayUnlock;               external oleaut32 name 'SafeArrayUnlock';
function SafeArrayAccessData;           external oleaut32 name 'SafeArrayAccessData';
function SafeArrayUnaccessData;         external oleaut32 name 'SafeArrayUnaccessData';
function SafeArrayGetElement;           external oleaut32 name 'SafeArrayGetElement';
function SafeArrayPutElement;           external oleaut32 name 'SafeArrayPutElement';
function SafeArrayCopy;                 external oleaut32 name 'SafeArrayCopy';
function SafeArrayPtrOfIndex;           external oleaut32 name 'SafeArrayPtrOfIndex';
procedure VariantInit;                  external oleaut32 name 'VariantInit';
function VariantClear;                  external oleaut32 name 'VariantClear';
function VariantCopy;                   external oleaut32 name 'VariantCopy';
function VariantCopyInd;                external oleaut32 name 'VariantCopyInd';
function VariantChangeType;             external oleaut32 name 'VariantChangeType';
function VariantChangeTypeEx;           external oleaut32 name 'VariantChangeTypeEx';
function VarUI1FromI2;                  external oleaut32 name 'VarUI1FromI2';
function VarUI1FromI4;                  external oleaut32 name 'VarUI1FromI4';
function VarUI1FromR4;                  external oleaut32 name 'VarUI1FromR4';
function VarUI1FromR8;                  external oleaut32 name 'VarUI1FromR8';
function VarUI1FromCy;                  external oleaut32 name 'VarUI1FromCy';
function VarUI1FromDate;                external oleaut32 name 'VarUI1FromDate';
function VarUI1FromStr;                 external oleaut32 name 'VarUI1FromStr';
function VarUI1FromDisp;                external oleaut32 name 'VarUI1FromDisp';
function VarUI1FromBool;                external oleaut32 name 'VarUI1FromBool';
function VarI2FromUI1;                  external oleaut32 name 'VarI2FromUI1';
function VarI2FromI4;                   external oleaut32 name 'VarI2FromI4';
function VarI2FromR4;                   external oleaut32 name 'VarI2FromR4';
function VarI2FromR8;                   external oleaut32 name 'VarI2FromR8';
function VarI2FromCy;                   external oleaut32 name 'VarI2FromCy';
function VarI2FromDate;                 external oleaut32 name 'VarI2FromDate';
function VarI2FromStr;                  external oleaut32 name 'VarI2FromStr';
function VarI2FromDisp;                 external oleaut32 name 'VarI2FromDisp';
function VarI2FromBool;                 external oleaut32 name 'VarI2FromBool';
function VarI4FromUI1;                  external oleaut32 name 'VarI4FromUI1';
function VarI4FromI2;                   external oleaut32 name 'VarI4FromI2';
function VarI4FromR4;                   external oleaut32 name 'VarI4FromR4';
function VarI4FromR8;                   external oleaut32 name 'VarI4FromR8';
function VarI4FromCy;                   external oleaut32 name 'VarI4FromCy';
function VarI4FromDate;                 external oleaut32 name 'VarI4FromDate';
function VarI4FromStr;                  external oleaut32 name 'VarI4FromStr';
function VarI4FromDisp;                 external oleaut32 name 'VarI4FromDisp';
function VarI4FromBool;                 external oleaut32 name 'VarI4FromBool';
function VarR4FromUI1;                  external oleaut32 name 'VarR4FromUI1';
function VarR4FromI2;                   external oleaut32 name 'VarR4FromI2';
function VarR4FromI4;                   external oleaut32 name 'VarR4FromI4';
function VarR4FromR8;                   external oleaut32 name 'VarR4FromR8';
function VarR4FromCy;                   external oleaut32 name 'VarR4FromCy';
function VarR4FromDate;                 external oleaut32 name 'VarR4FromDate';
function VarR4FromStr;                  external oleaut32 name 'VarR4FromStr';
function VarR4FromDisp;                 external oleaut32 name 'VarR4FromDisp';
function VarR4FromBool;                 external oleaut32 name 'VarR4FromBool';
function VarR8FromUI1;                  external oleaut32 name 'VarR8FromUI1';
function VarR8FromI2;                   external oleaut32 name 'VarR8FromI2';
function VarR8FromI4;                   external oleaut32 name 'VarR8FromI4';
function VarR8FromR4;                   external oleaut32 name 'VarR8FromR4';
function VarR8FromCy;                   external oleaut32 name 'VarR8FromCy';
function VarR8FromDate;                 external oleaut32 name 'VarR8FromDate';
function VarR8FromStr;                  external oleaut32 name 'VarR8FromStr';
function VarR8FromDisp;                 external oleaut32 name 'VarR8FromDisp';
function VarR8FromBool;                 external oleaut32 name 'VarR8FromBool';
function VarDateFromUI1;                external oleaut32 name 'VarDateFromUI1';
function VarDateFromI2;                 external oleaut32 name 'VarDateFromI2';
function VarDateFromI4;                 external oleaut32 name 'VarDateFromI4';
function VarDateFromR4;                 external oleaut32 name 'VarDateFromR4';
function VarDateFromR8;                 external oleaut32 name 'VarDateFromR8';
function VarDateFromCy;                 external oleaut32 name 'VarDateFromCy';
function VarDateFromStr;                external oleaut32 name 'VarDateFromStr';
function VarDateFromDisp;               external oleaut32 name 'VarDateFromDisp';
function VarDateFromBool;               external oleaut32 name 'VarDateFromBool';
function VarCyFromUI1;                  external oleaut32 name 'VarCyFromUI1';
function VarCyFromI2;                   external oleaut32 name 'VarCyFromI2';
function VarCyFromI4;                   external oleaut32 name 'VarCyFromI4';
function VarCyFromR4;                   external oleaut32 name 'VarCyFromR4';
function VarCyFromR8;                   external oleaut32 name 'VarCyFromR8';
function VarCyFromDate;                 external oleaut32 name 'VarCyFromDate';
function VarCyFromStr;                  external oleaut32 name 'VarCyFromStr';
function VarCyFromDisp;                 external oleaut32 name 'VarCyFromDisp';
function VarCyFromBool;                 external oleaut32 name 'VarCyFromBool';
function VarBStrFromUI1;                external oleaut32 name 'VarBStrFromUI1';
function VarBStrFromI2;                 external oleaut32 name 'VarBStrFromI2';
function VarBStrFromI4;                 external oleaut32 name 'VarBStrFromI4';
function VarBStrFromR4;                 external oleaut32 name 'VarBStrFromR4';
function VarBStrFromR8;                 external oleaut32 name 'VarBStrFromR8';
function VarBStrFromCy;                 external oleaut32 name 'VarBStrFromCy';
function VarBStrFromDate;               external oleaut32 name 'VarBStrFromDate';
function VarBStrFromDisp;               external oleaut32 name 'VarBStrFromDisp';
function VarBStrFromBool;               external oleaut32 name 'VarBStrFromBool';
function VarBoolFromUI1;                external oleaut32 name 'VarBoolFromUI1';
function VarBoolFromI2;                 external oleaut32 name 'VarBoolFromI2';
function VarBoolFromI4;                 external oleaut32 name 'VarBoolFromI4';
function VarBoolFromR4;                 external oleaut32 name 'VarBoolFromR4';
function VarBoolFromR8;                 external oleaut32 name 'VarBoolFromR8';
function VarBoolFromDate;               external oleaut32 name 'VarBoolFromDate';
function VarBoolFromCy;                 external oleaut32 name 'VarBoolFromCy';
function VarBoolFromStr;                external oleaut32 name 'VarBoolFromStr';
function VarBoolFromDisp;               external oleaut32 name 'VarBoolFromDisp';
function LHashValOfNameSys;             external oleaut32 name 'LHashValOfNameSys';
function LHashValOfNameSysA;            external oleaut32 name 'LHashValOfNameSysA';
function LoadTypeLib;                   external oleaut32 name 'LoadTypeLib';
function LoadRegTypeLib;                external oleaut32 name 'LoadRegTypeLib';
function QueryPathOfRegTypeLib;         external oleaut32 name 'QueryPathOfRegTypeLib';
function RegisterTypeLib;               external oleaut32 name 'RegisterTypeLib';
function CreateTypeLib;                 external oleaut32 name 'CreateTypeLib';
function DispGetParam;                  external oleaut32 name 'DispGetParam';
function DispGetIDsOfNames;             external oleaut32 name 'DispGetIDsOfNames';
function DispInvoke;                    external oleaut32 name 'DispInvoke';
function CreateDispTypeInfo;            external oleaut32 name 'CreateDispTypeInfo';
function CreateStdDispatch;             external oleaut32 name 'CreateStdDispatch';
function RegisterActiveObject;          external oleaut32 name 'RegisterActiveObject';
function RevokeActiveObject;            external oleaut32 name 'RevokeActiveObject';
function GetActiveObject;               external oleaut32 name 'GetActiveObject';
function SetErrorInfo;                  external oleaut32 name 'SetErrorInfo';
function GetErrorInfo;                  external oleaut32 name 'GetErrorInfo';
function CreateErrorInfo;               external oleaut32 name 'CreateErrorInfo';
function OaBuildVersion;                external oleaut32 name 'OaBuildVersion';

{ Helper functions }

function Succeeded(Res: HResult): Boolean;
begin
  Result := Res and $80000000 = 0;
end;

function Failed(Res: HResult): Boolean;
begin
  Result := Res and $80000000 <> 0;
end;

function ResultCode(Res: HResult): Integer;
begin
  Result := Res and $0000FFFF;
end;

function ResultFacility(Res: HResult): Integer;
begin
  Result := (Res shr 16) and $00001FFF;
end;

function ResultSeverity(Res: HResult): Integer;
begin
  Result := Res shr 31;
end;

function MakeResult(Severity, Facility, Code: Integer): HResult;
begin
  Result := (Severity shl 31) or (Facility shl 16) or Code;
end;

function LHashValOfName(lcid: TLCID; szName: POleStr): Longint;
begin
  Result := LHashValOfNameSys(SYS_WIN32, lcid, szName);
end;

function WHashValOfLHashVal(lhashval: Longint): Word;
begin
  Result := lhashval and $0000FFFF;
end;

function IsHashValCompatible(lhashval1, lhashval2: Longint): Boolean;
begin
  Result := lhashval1 and $00FF0000 = lhashval2 and $00FF0000;
end;

end.
