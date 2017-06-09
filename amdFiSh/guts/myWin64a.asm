; Macroinstructions for defining data structures

macro struct name
 { virtual at 0
   fields@struct equ name
   match child parent, name \{ fields@struct equ child,fields@\#parent \}
   sub@struct equ
   struc db [val] \{ \common define field@struct .,db,<val>
			     fields@struct equ fields@struct,field@struct \}
   struc dw [val] \{ \common define field@struct .,dw,<val>
			     fields@struct equ fields@struct,field@struct \}
   struc du [val] \{ \common define field@struct .,du,<val>
			     fields@struct equ fields@struct,field@struct \}
   struc dd [val] \{ \common define field@struct .,dd,<val>
			     fields@struct equ fields@struct,field@struct \}
   struc dp [val] \{ \common define field@struct .,dp,<val>
			     fields@struct equ fields@struct,field@struct \}
   struc dq [val] \{ \common define field@struct .,dq,<val>
			     fields@struct equ fields@struct,field@struct \}
   struc dt [val] \{ \common define field@struct .,dt,<val>
			     fields@struct equ fields@struct,field@struct \}
   struc rb count \{ define field@struct .,db,count dup (?)
		     fields@struct equ fields@struct,field@struct \}
   struc rw count \{ define field@struct .,dw,count dup (?)
		     fields@struct equ fields@struct,field@struct \}
   struc rd count \{ define field@struct .,dd,count dup (?)
		     fields@struct equ fields@struct,field@struct \}
   struc rp count \{ define field@struct .,dp,count dup (?)
		     fields@struct equ fields@struct,field@struct \}
   struc rq count \{ define field@struct .,dq,count dup (?)
		     fields@struct equ fields@struct,field@struct \}
   struc rt count \{ define field@struct .,dt,count dup (?)
		     fields@struct equ fields@struct,field@struct \}
   macro db [val] \{ \common \local anonymous
		     define field@struct anonymous,db,<val>
		     fields@struct equ fields@struct,field@struct \}
   macro dw [val] \{ \common \local anonymous
		     define field@struct anonymous,dw,<val>
		     fields@struct equ fields@struct,field@struct \}
   macro du [val] \{ \common \local anonymous
		     define field@struct anonymous,du,<val>
		     fields@struct equ fields@struct,field@struct \}
   macro dd [val] \{ \common \local anonymous
		     define field@struct anonymous,dd,<val>
		     fields@struct equ fields@struct,field@struct \}
   macro dp [val] \{ \common \local anonymous
		     define field@struct anonymous,dp,<val>
		     fields@struct equ fields@struct,field@struct \}
   macro dq [val] \{ \common \local anonymous
		     define field@struct anonymous,dq,<val>
		     fields@struct equ fields@struct,field@struct \}
   macro dt [val] \{ \common \local anonymous
		     define field@struct anonymous,dt,<val>
		     fields@struct equ fields@struct,field@struct \}
   macro rb count \{ \local anonymous
		     define field@struct anonymous,db,count dup (?)
		     fields@struct equ fields@struct,field@struct \}
   macro rw count \{ \local anonymous
		     define field@struct anonymous,dw,count dup (?)
		     fields@struct equ fields@struct,field@struct \}
   macro rd count \{ \local anonymous
		     define field@struct anonymous,dd,count dup (?)
		     fields@struct equ fields@struct,field@struct \}
   macro rp count \{ \local anonymous
		     define field@struct anonymous,dp,count dup (?)
		     fields@struct equ fields@struct,field@struct \}
   macro rq count \{ \local anonymous
		     define field@struct anonymous,dq,count dup (?)
		     fields@struct equ fields@struct,field@struct \}
   macro rt count \{ \local anonymous
		     define field@struct anonymous,dt,count dup (?)
		     fields@struct equ fields@struct,field@struct \}
   macro union \{ fields@struct equ fields@struct,,union,<
		  sub@struct equ union \}
   macro struct \{ fields@struct equ fields@struct,,substruct,<
		  sub@struct equ substruct \} }

macro ends
 { match , sub@struct \{ restruc db,dw,du,dd,dp,dq,dt
			 restruc rb,rw,rd,rp,rq,rt
			 purge db,dw,du,dd,dp,dq,dt
			 purge rb,rw,rd,rp,rq,rt
			 purge union,struct
			 match name tail,fields@struct, \\{ if $
							    display 'Error: definition of ',\\`name,' contains illegal instructions.',0Dh,0Ah
							    err
							    end if \\}
			 match name=,fields,fields@struct \\{ fields@struct equ
							      make@struct name,fields
							      define fields@\\#name fields \\}
			 end virtual \}
   match any, sub@struct \{ fields@struct equ fields@struct> \}
   restore sub@struct }

macro make@struct name,[field,type,def]
 { common
    local define
    define equ name
   forward
    local sub
    match , field \{ make@substruct type,name,sub def
		     define equ define,.,sub, \}
    match any, field \{ define equ define,.#field,type,<def> \}
   common
    match fields, define \{ define@struct fields \} }

macro define@struct name,[field,type,def]
 { common
    virtual
    db `name
    load initial@struct byte from 0
    if initial@struct = '.'
    display 'Error: name of structure should not begin with a dot.',0Dh,0Ah
    err
    end if
    end virtual
    local list
    list equ
   forward
    if ~ field eq .
     name#field type def
     sizeof.#name#field = $ - name#field
    else
     label name#.#type
     rb sizeof.#type
    end if
    local value
    match any, list \{ list equ list, \}
    list equ list <value>
   common
    sizeof.#name = $
    restruc name
    match values, list \{
    struc name value \\{ \\local \\..base
    match any, fields@struct \\\{ fields@struct equ fields@struct,.,name,<values> \\\}
    match , fields@struct \\\{ label \\..base
   forward
     match , value \\\\{ field type def \\\\}
     match any, value \\\\{ field type value
			    if ~ field eq .
			     rb sizeof.#name#field - ($-field)
			    end if \\\\}
   common label . at \\..base \\\}
   \\}
    macro name value \\{
    match any, fields@struct \\\{ \\\local anonymous
				  fields@struct equ fields@struct,anonymous,name,<values> \\\}
    match , fields@struct \\\{
   forward
     match , value \\\\{ type def \\\\}
     match any, value \\\\{ \\\\local ..field
			   ..field = $
			   type value
			   if ~ field eq .
			    rb sizeof.#name#field - ($-..field)
			   end if \\\\}
   common \\\} \\} \} }

macro enable@substruct
 { macro make@substruct substruct,parent,name,[field,type,def]
    \{ \common
	\local define
	define equ parent,name
       \forward
	\local sub
	match , field \\{ match any, type \\\{ enable@substruct
					       make@substruct type,parent,sub def
					       purge make@substruct
					       define equ define,.,sub, \\\} \\}
	match any, field \\{ define equ define,.\#field,type,<def> \\}
       \common
	match fields, define \\{ define@\#substruct fields \\} \} }

enable@substruct

macro define@union parent,name,[field,type,def]
 { common
    virtual at parent#.#name
   forward
    if ~ field eq .
     virtual at parent#.#name
      parent#field type def
      sizeof.#parent#field = $ - parent#field
     end virtual
     if sizeof.#parent#field > $ - parent#.#name
      rb sizeof.#parent#field - ($ - parent#.#name)
     end if
    else
     virtual at parent#.#name
      label parent#.#type
      type def
     end virtual
     label name#.#type at parent#.#name
     if sizeof.#type > $ - parent#.#name
      rb sizeof.#type - ($ - parent#.#name)
     end if
    end if
   common
    sizeof.#name = $ - parent#.#name
    end virtual
    struc name [value] \{ \common
    label .\#name
    last@union equ
   forward
    match any, last@union \\{ virtual at .\#name
			       field type def
			      end virtual \\}
    match , last@union \\{ match , value \\\{ field type def \\\}
			   match any, value \\\{ field type value \\\} \\}
    last@union equ field
   common rb sizeof.#name - ($ - .\#name) \}
    macro name [value] \{ \common \local ..anonymous
			  ..anonymous name value \} }

macro define@substruct parent,name,[field,type,def]
 { common
    virtual at parent#.#name
   forward
    if ~ field eq .
     parent#field type def
     sizeof.#parent#field = $ - parent#field
    else
     label parent#.#type
     rb sizeof.#type
    end if
   common
    sizeof.#name = $ - parent#.#name
    end virtual
    struc name value \{
    label .\#name
   forward
     match , value \\{ field type def \\}
     match any, value \\{ field type value
			  if ~ field eq .
			   rb sizeof.#parent#field - ($-field)
			  end if \\}
   common \}
    macro name value \{ \local ..anonymous
			..anonymous name \} }


; Macroinstructions for making import section (64-bit)

macro library [name,string]
 { common
    import.data:
   forward
    local _label
    if defined name#.redundant
     if ~ name#.redundant
      dd RVA name#.lookup,0,0,RVA _label,RVA name#.address
     end if
    end if
    name#.referred = 1
   common
    dd 0,0,0,0,0
   forward
    if defined name#.redundant
     if ~ name#.redundant
      _label db string,0
	     rb RVA $ and 1
     end if
    end if }

macro import name,[label,string]
 { common
    rb (- rva $) and 7
    if defined name#.referred
     name#.lookup:
   forward
     if used label
      if string eqtype ''
       local _label
       dq RVA _label
      else
       dq 8000000000000000h + string
      end if
     end if
   common
     if $ > name#.lookup
      name#.redundant = 0
      dq 0
     else
      name#.redundant = 1
     end if
     name#.address:
   forward
     if used label
      if string eqtype ''
       label dq RVA _label
      else
       label dq 8000000000000000h + string
      end if
     end if
   common
     if ~ name#.redundant
      dq 0
     end if
   forward
     if used label & string eqtype ''
     _label dw 0
	    db string,0
	    rb RVA $ and 1
     end if
   common
    end if }

macro api [name] {}


;include 'macro/export.inc'
;include 'macro/resource.inc'

;struc TCHAR [val] { common match any, val \{ . db val \}
;                           match , val \{ . db ? \} }
;sizeof.TCHAR = 1

;include 'equates/kernel64.inc'


; General constants

NULL  = 0
TRUE  = 1
FALSE = 0

; Maximum path length in characters

MAX_PATH = 260


TOKEN_ADJUST_PRIVILEGES = 0x0020
TOKEN_QUERY = 0x0008
SE_PRIVILEGE_ENABLED = 0x00000002

; Access rights

DELETE_RIGHT		  = 00010000h
READ_CONTROL		  = 00020000h
WRITE_DAC		  = 00040000h
WRITE_OWNER		  = 00080000h
SYNCHRONIZE		  = 00100000h
STANDARD_RIGHTS_READ	  = READ_CONTROL
STANDARD_RIGHTS_WRITE	  = READ_CONTROL
STANDARD_RIGHTS_EXECUTE   = READ_CONTROL
STANDARD_RIGHTS_REQUIRED  = 000F0000h
STANDARD_RIGHTS_ALL	  = 001F0000h
SPECIFIC_RIGHTS_ALL	  = 0000FFFFh
ACCESS_SYSTEM_SECURITY	  = 01000000h
MAXIMUM_ALLOWED 	  = 02000000h
GENERIC_READ		  = 80000000h
GENERIC_WRITE		  = 40000000h
GENERIC_EXECUTE 	  = 20000000h
GENERIC_ALL		  = 10000000h
PROCESS_TERMINATE	  = 00000001h
PROCESS_CREATE_THREAD	  = 00000002h
PROCESS_VM_OPERATION	  = 00000008h
PROCESS_VM_READ 	  = 00000010h
PROCESS_VM_WRITE	  = 00000020h
PROCESS_DUP_HANDLE	  = 00000040h
PROCESS_CREATE_PROCESS	  = 00000080h
PROCESS_SET_QUOTA	  = 00000100h
PROCESS_SET_INFORMATION   = 00000200h
PROCESS_QUERY_INFORMATION = 00000400h
PROCESS_ALL_ACCESS	  = STANDARD_RIGHTS_REQUIRED or SYNCHRONIZE or 0FFFh
FILE_SHARE_READ 	  = 00000001h
FILE_SHARE_WRITE	  = 00000002h
FILE_SHARE_DELETE	  = 00000004h

; CreateFile actions

CREATE_NEW	  = 1
CREATE_ALWAYS	  = 2
OPEN_EXISTING	  = 3
OPEN_ALWAYS	  = 4
TRUNCATE_EXISTING = 5

; OpenFile modes

OF_READ 	    = 0000h
OF_WRITE	    = 0001h
OF_READWRITE	    = 0002h
OF_SHARE_COMPAT     = 0000h
OF_SHARE_EXCLUSIVE  = 0010h
OF_SHARE_DENY_WRITE = 0020h
OF_SHARE_DENY_READ  = 0030h
OF_SHARE_DENY_NONE  = 0040h
OF_PARSE	    = 0100h
OF_DELETE	    = 0200h
OF_VERIFY	    = 0400h
OF_CANCEL	    = 0800h
OF_CREATE	    = 1000h
OF_PROMPT	    = 2000h
OF_EXIST	    = 4000h
OF_REOPEN	    = 8000h

; SetFilePointer methods

FILE_BEGIN   = 0
FILE_CURRENT = 1
FILE_END     = 2

; File attributes

FILE_ATTRIBUTE_READONLY   = 001h
FILE_ATTRIBUTE_HIDDEN	  = 002h
FILE_ATTRIBUTE_SYSTEM	  = 004h
FILE_ATTRIBUTE_DIRECTORY  = 010h
FILE_ATTRIBUTE_ARCHIVE	  = 020h
FILE_ATTRIBUTE_NORMAL	  = 080h
FILE_ATTRIBUTE_TEMPORARY  = 100h
FILE_ATTRIBUTE_COMPRESSED = 800h

; File flags

FILE_FLAG_WRITE_THROUGH    = 80000000h
FILE_FLAG_OVERLAPPED	   = 40000000h
FILE_FLAG_NO_BUFFERING	   = 20000000h
FILE_FLAG_RANDOM_ACCESS    = 10000000h
FILE_FLAG_SEQUENTIAL_SCAN  = 08000000h
FILE_FLAG_DELETE_ON_CLOSE  = 04000000h
FILE_FLAG_BACKUP_SEMANTICS = 02000000h
FILE_FLAG_POSIX_SEMANTICS  = 01000000h

; Notify filters

FILE_NOTIFY_CHANGE_FILE_NAME  = 001h
FILE_NOTIFY_CHANGE_DIR_NAME   = 002h
FILE_NOTIFY_CHANGE_ATTRIBUTES = 004h
FILE_NOTIFY_CHANGE_SIZE       = 008h
FILE_NOTIFY_CHANGE_LAST_WRITE = 010h
FILE_NOTIFY_CHANGE_SECURITY   = 100h

; File types

FILE_TYPE_UNKNOWN = 0
FILE_TYPE_DISK	  = 1
FILE_TYPE_CHAR	  = 2
FILE_TYPE_PIPE	  = 3
FILE_TYPE_REMOTE  = 8000h

; LockFileEx flags

LOCKFILE_FAIL_IMMEDIATELY = 1
LOCKFILE_EXCLUSIVE_LOCK   = 2

; MoveFileEx flags

MOVEFILE_REPLACE_EXISTING   = 1
MOVEFILE_COPY_ALLOWED	    = 2
MOVEFILE_DELAY_UNTIL_REBOOT = 4
MOVEFILE_WRITE_THROUGH	    = 8

; FindFirstFileEx flags

FIND_FIRST_EX_CASE_SENSITIVE = 1

; Device handles

INVALID_HANDLE_VALUE = -1
STD_INPUT_HANDLE     = -10
STD_OUTPUT_HANDLE    = -11
STD_ERROR_HANDLE     = -12

; DuplicateHandle options

DUPLICATE_CLOSE_SOURCE = 1
DUPLICATE_SAME_ACCESS  = 2

; File mapping acccess rights

SECTION_QUERY	    = 01h
SECTION_MAP_WRITE   = 02h
SECTION_MAP_READ    = 04h
SECTION_MAP_EXECUTE = 08h
SECTION_EXTEND_SIZE = 10h
SECTION_ALL_ACCESS  = STANDARD_RIGHTS_REQUIRED or SECTION_QUERY or SECTION_MAP_WRITE or SECTION_MAP_READ or SECTION_MAP_EXECUTE or SECTION_EXTEND_SIZE
FILE_MAP_COPY	    = SECTION_QUERY
FILE_MAP_WRITE	    = SECTION_MAP_WRITE
FILE_MAP_READ	    = SECTION_MAP_READ
FILE_MAP_ALL_ACCESS = SECTION_ALL_ACCESS

; File system flags

FILE_CASE_SENSITIVE_SEARCH = 0001h
FILE_CASE_PRESERVED_NAMES  = 0002h
FILE_UNICODE_ON_DISK	   = 0004h
FILE_PERSISTENT_ACLS	   = 0008h
FILE_FILE_COMPRESSION	   = 0010h
FILE_VOLUME_IS_COMPRESSED  = 8000h
FS_CASE_IS_PRESERVED	   = FILE_CASE_PRESERVED_NAMES
FS_CASE_SENSITIVE	   = FILE_CASE_SENSITIVE_SEARCH
FS_UNICODE_STORED_ON_DISK  = FILE_UNICODE_ON_DISK
FS_PERSISTENT_ACLS	   = FILE_PERSISTENT_ACLS

; Drive types

DRIVE_UNKNOWN	  = 0
DRIVE_NO_ROOT_DIR = 1
DRIVE_REMOVABLE   = 2
DRIVE_FIXED	  = 3
DRIVE_REMOTE	  = 4
DRIVE_CDROM	  = 5
DRIVE_RAMDISK	  = 6

; Pipe modes

PIPE_ACCESS_INBOUND	 = 1
PIPE_ACCESS_OUTBOUND	 = 2
PIPE_ACCESS_DUPLEX	 = 3
PIPE_CLIENT_END 	 = 0
PIPE_SERVER_END 	 = 1
PIPE_WAIT		 = 0
PIPE_NOWAIT		 = 1
PIPE_READMODE_BYTE	 = 0
PIPE_READMODE_MESSAGE	 = 2
PIPE_TYPE_BYTE		 = 0
PIPE_TYPE_MESSAGE	 = 4
PIPE_UNLIMITED_INSTANCES = 255

; Global memory flags

GMEM_FIXED	       = 0000h
GMEM_MOVEABLE	       = 0002h
GMEM_NOCOMPACT	       = 0010h
GMEM_NODISCARD	       = 0020h
GMEM_ZEROINIT	       = 0040h
GMEM_MODIFY	       = 0080h
GMEM_DISCARDABLE       = 0100h
GMEM_NOT_BANKED        = 1000h
GMEM_SHARE	       = 2000h
GMEM_DDESHARE	       = 2000h
GMEM_NOTIFY	       = 4000h
GMEM_LOWER	       = GMEM_NOT_BANKED
GMEM_VALID_FLAGS       = 7F72h
GMEM_INVALID_HANDLE    = 8000h
GMEM_DISCARDED	       = 4000h
GMEM_LOCKCOUNT	       = 0FFh
GHND		       = GMEM_MOVEABLE + GMEM_ZEROINIT
GPTR		       = GMEM_FIXED + GMEM_ZEROINIT

; Local memory flags

LMEM_FIXED	       = 0000h
LMEM_MOVEABLE	       = 0002h
LMEM_NOCOMPACT	       = 0010h
LMEM_NODISCARD	       = 0020h
LMEM_ZEROINIT	       = 0040h
LMEM_MODIFY	       = 0080h
LMEM_DISCARDABLE       = 0F00h
LMEM_VALID_FLAGS       = 0F72h
LMEM_INVALID_HANDLE    = 8000h
LHND		       = LMEM_MOVEABLE + LMEM_ZEROINIT
LPTR		       = LMEM_FIXED + LMEM_ZEROINIT
LMEM_DISCARDED	       = 4000h
LMEM_LOCKCOUNT	       = 00FFh

; Page access flags

PAGE_NOACCESS	       = 001h
PAGE_READONLY	       = 002h
PAGE_READWRITE	       = 004h
PAGE_WRITECOPY	       = 008h
PAGE_EXECUTE	       = 010h
PAGE_EXECUTE_READ      = 020h
PAGE_EXECUTE_READWRITE = 040h
PAGE_EXECUTE_WRITECOPY = 080h
PAGE_GUARD	       = 100h
PAGE_NOCACHE	       = 200h

; Memory allocation flags

MEM_LARGE_PAGES   =  0x20000000
MEM_COMMIT	       = 001000h
MEM_RESERVE	       = 002000h
MEM_DECOMMIT	       = 004000h
MEM_RELEASE	       = 008000h
MEM_FREE	       = 010000h
MEM_PRIVATE	       = 020000h
MEM_MAPPED	       = 040000h
MEM_RESET	       = 080000h
MEM_TOP_DOWN	       = 100000h

; Heap allocation flags

HEAP_NO_SERIALIZE	 = 1
HEAP_GENERATE_EXCEPTIONS = 4
HEAP_ZERO_MEMORY	 = 8

; Platform identifiers

VER_PLATFORM_WIN32s	   = 0
VER_PLATFORM_WIN32_WINDOWS = 1
VER_PLATFORM_WIN32_NT	   = 2

; GetBinaryType return values

SCS_32BIT_BINARY = 0
SCS_DOS_BINARY	 = 1
SCS_WOW_BINARY	 = 2
SCS_PIF_BINARY	 = 3
SCS_POSIX_BINARY = 4
SCS_OS216_BINARY = 5

; CreateProcess flags

DEBUG_PROCESS		 = 001h
DEBUG_ONLY_THIS_PROCESS  = 002h
CREATE_SUSPENDED	 = 004h
DETACHED_PROCESS	 = 008h
CREATE_NEW_CONSOLE	 = 010h
BELOW_NORMAL_PRIORITY_CLASS = 0x00004000
NORMAL_PRIORITY_CLASS	 = 020h
IDLE_PRIORITY_CLASS	 = 040h
HIGH_PRIORITY_CLASS	 = 080h
REALTIME_PRIORITY_CLASS  = 100h
CREATE_NEW_PROCESS_GROUP = 200h
CREATE_SEPARATE_WOW_VDM  = 800h

; Thread priority values

THREAD_BASE_PRIORITY_MIN      = -2
THREAD_BASE_PRIORITY_MAX      = 2
THREAD_BASE_PRIORITY_LOWRT    = 15
THREAD_BASE_PRIORITY_IDLE     = -15
THREAD_PRIORITY_LOWEST	      = THREAD_BASE_PRIORITY_MIN
THREAD_PRIORITY_BELOW_NORMAL  = THREAD_PRIORITY_LOWEST + 1
THREAD_PRIORITY_NORMAL	      = 0
THREAD_PRIORITY_HIGHEST       = THREAD_BASE_PRIORITY_MAX
THREAD_PRIORITY_ABOVE_NORMAL  = THREAD_PRIORITY_HIGHEST - 1
THREAD_PRIORITY_ERROR_RETURN  = 7FFFFFFFh
THREAD_PRIORITY_TIME_CRITICAL = THREAD_BASE_PRIORITY_LOWRT
THREAD_PRIORITY_IDLE	      = THREAD_BASE_PRIORITY_IDLE

; Startup flags

STARTF_USESHOWWINDOW	= 001h
STARTF_USESIZE		= 002h
STARTF_USEPOSITION	= 004h
STARTF_USECOUNTCHARS	= 008h
STARTF_USEFILLATTRIBUTE = 010h
STARTF_RUNFULLSCREEN	= 020h
STARTF_FORCEONFEEDBACK	= 040h
STARTF_FORCEOFFFEEDBACK = 080h
STARTF_USESTDHANDLES	= 100h

; Shutdown flags

SHUTDOWN_NORETRY = 1h

; LoadLibraryEx flags

DONT_RESOLVE_DLL_REFERENCES   = 1
LOAD_LIBRARY_AS_DATAFILE      = 2
LOAD_WITH_ALTERED_SEARCH_PATH = 8

; DLL entry-point calls

DLL_PROCESS_DETACH = 0
DLL_PROCESS_ATTACH = 1
DLL_THREAD_ATTACH  = 2
DLL_THREAD_DETACH  = 3

; Status codes

STATUS_WAIT_0			= 000000000h
STATUS_ABANDONED_WAIT_0 	= 000000080h
STATUS_USER_APC 		= 0000000C0h
STATUS_TIMEOUT			= 000000102h
STATUS_PENDING			= 000000103h
STATUS_DATATYPE_MISALIGNMENT	= 080000002h
STATUS_BREAKPOINT		= 080000003h
STATUS_SINGLE_STEP		= 080000004h
STATUS_ACCESS_VIOLATION 	= 0C0000005h
STATUS_IN_PAGE_ERROR		= 0C0000006h
STATUS_NO_MEMORY		= 0C0000017h
STATUS_ILLEGAL_INSTRUCTION	= 0C000001Dh
STATUS_NONCONTINUABLE_EXCEPTION = 0C0000025h
STATUS_INVALID_DISPOSITION	= 0C0000026h
STATUS_ARRAY_BOUNDS_EXCEEDED	= 0C000008Ch
STATUS_FLOAT_DENORMAL_OPERAND	= 0C000008Dh
STATUS_FLOAT_DIVIDE_BY_ZERO	= 0C000008Eh
STATUS_FLOAT_INEXACT_RESULT	= 0C000008Fh
STATUS_FLOAT_INVALID_OPERATION	= 0C0000090h
STATUS_FLOAT_OVERFLOW		= 0C0000091h
STATUS_FLOAT_STACK_CHECK	= 0C0000092h
STATUS_FLOAT_UNDERFLOW		= 0C0000093h
STATUS_INTEGER_DIVIDE_BY_ZERO	= 0C0000094h
STATUS_INTEGER_OVERFLOW 	= 0C0000095h
STATUS_PRIVILEGED_INSTRUCTION	= 0C0000096h
STATUS_STACK_OVERFLOW		= 0C00000FDh
STATUS_CONTROL_C_EXIT		= 0C000013Ah
WAIT_FAILED			= -1
WAIT_OBJECT_0			= STATUS_WAIT_0
WAIT_ABANDONED			= STATUS_ABANDONED_WAIT_0
WAIT_ABANDONED_0		= STATUS_ABANDONED_WAIT_0
WAIT_TIMEOUT			= STATUS_TIMEOUT
WAIT_IO_COMPLETION		= STATUS_USER_APC
STILL_ACTIVE			= STATUS_PENDING

; Exception codes

EXCEPTION_CONTINUABLE		= 0
EXCEPTION_NONCONTINUABLE	= 1
EXCEPTION_ACCESS_VIOLATION	= STATUS_ACCESS_VIOLATION
EXCEPTION_DATATYPE_MISALIGNMENT = STATUS_DATATYPE_MISALIGNMENT
EXCEPTION_BREAKPOINT		= STATUS_BREAKPOINT
EXCEPTION_SINGLE_STEP		= STATUS_SINGLE_STEP
EXCEPTION_ARRAY_BOUNDS_EXCEEDED = STATUS_ARRAY_BOUNDS_EXCEEDED
EXCEPTION_FLT_DENORMAL_OPERAND	= STATUS_FLOAT_DENORMAL_OPERAND
EXCEPTION_FLT_DIVIDE_BY_ZERO	= STATUS_FLOAT_DIVIDE_BY_ZERO
EXCEPTION_FLT_INEXACT_RESULT	= STATUS_FLOAT_INEXACT_RESULT
EXCEPTION_FLT_INVALID_OPERATION = STATUS_FLOAT_INVALID_OPERATION
EXCEPTION_FLT_OVERFLOW		= STATUS_FLOAT_OVERFLOW
EXCEPTION_FLT_STACK_CHECK	= STATUS_FLOAT_STACK_CHECK
EXCEPTION_FLT_UNDERFLOW 	= STATUS_FLOAT_UNDERFLOW
EXCEPTION_INT_DIVIDE_BY_ZERO	= STATUS_INTEGER_DIVIDE_BY_ZERO
EXCEPTION_INT_OVERFLOW		= STATUS_INTEGER_OVERFLOW
EXCEPTION_ILLEGAL_INSTRUCTION	= STATUS_ILLEGAL_INSTRUCTION
EXCEPTION_PRIV_INSTRUCTION	= STATUS_PRIVILEGED_INSTRUCTION
EXCEPTION_IN_PAGE_ERROR 	= STATUS_IN_PAGE_ERROR

; Registry options

REG_OPTION_RESERVED	       = 0
REG_OPTION_NON_VOLATILE        = 0
REG_OPTION_VOLATILE	       = 1
REG_OPTION_CREATE_LINK	       = 2
REG_OPTION_BACKUP_RESTORE      = 4
REG_CREATED_NEW_KEY	       = 1
REG_OPENED_EXISTING_KEY        = 2
REG_WHOLE_HIVE_VOLATILE        = 1
REG_REFRESH_HIVE	       = 2
REG_NOTIFY_CHANGE_NAME	       = 1
REG_NOTIFY_CHANGE_ATTRIBUTES   = 2
REG_NOTIFY_CHANGE_LAST_SET     = 4
REG_NOTIFY_CHANGE_SECURITY     = 8
REG_LEGAL_CHANGE_FILTER        = REG_NOTIFY_CHANGE_NAME or REG_NOTIFY_CHANGE_ATTRIBUTES or REG_NOTIFY_CHANGE_LAST_SET or REG_NOTIFY_CHANGE_SECURITY
REG_LEGAL_OPTION	       = REG_OPTION_RESERVED or REG_OPTION_NON_VOLATILE or REG_OPTION_VOLATILE or REG_OPTION_CREATE_LINK or REG_OPTION_BACKUP_RESTORE
REG_NONE		       = 0
REG_SZ			       = 1
REG_EXPAND_SZ		       = 2
REG_BINARY		       = 3
REG_DWORD		       = 4
REG_DWORD_LITTLE_ENDIAN        = 4
REG_DWORD_BIG_ENDIAN	       = 5
REG_LINK		       = 6
REG_MULTI_SZ		       = 7
REG_RESOURCE_LIST	       = 8
REG_FULL_RESOURCE_DESCRIPTOR   = 9
REG_RESOURCE_REQUIREMENTS_LIST = 10

; Registry access modes

KEY_QUERY_VALUE 	       = 1
KEY_SET_VALUE		       = 2
KEY_CREATE_SUB_KEY	       = 4
KEY_ENUMERATE_SUB_KEYS	       = 8
KEY_NOTIFY		       = 10h
KEY_CREATE_LINK 	       = 20h
KEY_READ		       = STANDARD_RIGHTS_READ or KEY_QUERY_VALUE or KEY_ENUMERATE_SUB_KEYS or KEY_NOTIFY and not SYNCHRONIZE
KEY_WRITE		       = STANDARD_RIGHTS_WRITE or KEY_SET_VALUE or KEY_CREATE_SUB_KEY and not SYNCHRONIZE
KEY_EXECUTE		       = KEY_READ
KEY_ALL_ACCESS		       = STANDARD_RIGHTS_ALL or KEY_QUERY_VALUE or KEY_SET_VALUE or KEY_CREATE_SUB_KEY or KEY_ENUMERATE_SUB_KEYS or KEY_NOTIFY or KEY_CREATE_LINK and not SYNCHRONIZE

; Predefined registry keys

HKEY_CLASSES_ROOT     = 80000000h
HKEY_CURRENT_USER     = 80000001h
HKEY_LOCAL_MACHINE    = 80000002h
HKEY_USERS	      = 80000003h
HKEY_PERFORMANCE_DATA = 80000004h
HKEY_CURRENT_CONFIG   = 80000005h
HKEY_DYN_DATA	      = 80000006h

; FormatMessage flags

FORMAT_MESSAGE_ALLOCATE_BUFFER = 0100h
FORMAT_MESSAGE_IGNORE_INSERTS  = 0200h
FORMAT_MESSAGE_FROM_STRING     = 0400h
FORMAT_MESSAGE_FROM_HMODULE    = 0800h
FORMAT_MESSAGE_FROM_SYSTEM     = 1000h
FORMAT_MESSAGE_ARGUMENT_ARRAY  = 2000h
FORMAT_MESSAGE_MAX_WIDTH_MASK  = 00FFh

; Language identifiers

LANG_NEUTRAL		     = 00h
LANG_BULGARIAN		     = 02h
LANG_CHINESE		     = 04h
LANG_CROATIAN		     = 1Ah
LANG_CZECH		     = 05h
LANG_DANISH		     = 06h
LANG_DUTCH		     = 13h
LANG_ENGLISH		     = 09h
LANG_FINNISH		     = 0Bh
LANG_FRENCH		     = 0Ch
LANG_GERMAN		     = 07h
LANG_GREEK		     = 08h
LANG_HUNGARIAN		     = 0Eh
LANG_ICELANDIC		     = 0Fh
LANG_ITALIAN		     = 10h
LANG_JAPANESE		     = 11h
LANG_KOREAN		     = 12h
LANG_NORWEGIAN		     = 14h
LANG_POLISH		     = 15h
LANG_PORTUGUESE 	     = 16h
LANG_ROMANIAN		     = 18h
LANG_RUSSIAN		     = 19h
LANG_SLOVAK		     = 1Bh
LANG_SLOVENIAN		     = 24h
LANG_SPANISH		     = 0Ah
LANG_SWEDISH		     = 1Dh
LANG_THAI		     = 1Eh
LANG_TURKISH		     = 1Fh

; Sublanguage identifiers

SUBLANG_NEUTRAL 	     = 00h shl 10
SUBLANG_DEFAULT 	     = 01h shl 10
SUBLANG_SYS_DEFAULT	     = 02h shl 10
SUBLANG_CHINESE_TRADITIONAL  = 01h shl 10
SUBLANG_CHINESE_SIMPLIFIED   = 02h shl 10
SUBLANG_CHINESE_HONGKONG     = 03h shl 10
SUBLANG_CHINESE_SINGAPORE    = 04h shl 10
SUBLANG_DUTCH		     = 01h shl 10
SUBLANG_DUTCH_BELGIAN	     = 02h shl 10
SUBLANG_ENGLISH_US	     = 01h shl 10
SUBLANG_ENGLISH_UK	     = 02h shl 10
SUBLANG_ENGLISH_AUS	     = 03h shl 10
SUBLANG_ENGLISH_CAN	     = 04h shl 10
SUBLANG_ENGLISH_NZ	     = 05h shl 10
SUBLANG_ENGLISH_EIRE	     = 06h shl 10
SUBLANG_FRENCH		     = 01h shl 10
SUBLANG_FRENCH_BELGIAN	     = 02h shl 10
SUBLANG_FRENCH_CANADIAN      = 03h shl 10
SUBLANG_FRENCH_SWISS	     = 04h shl 10
SUBLANG_GERMAN		     = 01h shl 10
SUBLANG_GERMAN_SWISS	     = 02h shl 10
SUBLANG_GERMAN_AUSTRIAN      = 03h shl 10
SUBLANG_ITALIAN 	     = 01h shl 10
SUBLANG_ITALIAN_SWISS	     = 02h shl 10
SUBLANG_NORWEGIAN_BOKMAL     = 01h shl 10
SUBLANG_NORWEGIAN_NYNORSK    = 02h shl 10
SUBLANG_PORTUGUESE	     = 02h shl 10
SUBLANG_PORTUGUESE_BRAZILIAN = 01h shl 10
SUBLANG_SPANISH 	     = 01h shl 10
SUBLANG_SPANISH_MEXICAN      = 02h shl 10
SUBLANG_SPANISH_MODERN	     = 03h shl 10

; Sorting identifiers

SORT_DEFAULT		     = 0 shl 16
SORT_JAPANESE_XJIS	     = 0 shl 16
SORT_JAPANESE_UNICODE	     = 1 shl 16
SORT_CHINESE_BIG5	     = 0 shl 16
SORT_CHINESE_PRCP	     = 0 shl 16
SORT_CHINESE_UNICODE	     = 1 shl 16
SORT_CHINESE_PRC	     = 2 shl 16
SORT_CHINESE_BOPOMOFO	     = 3 shl 16
SORT_KOREAN_KSC 	     = 0 shl 16
SORT_KOREAN_UNICODE	     = 1 shl 16
SORT_GERMAN_PHONE_BOOK	     = 1 shl 16
SORT_HUNGARIAN_DEFAULT	     = 0 shl 16
SORT_HUNGARIAN_TECHNICAL     = 1 shl 16

; Code pages

CP_ACP	      = 0	    ; default to ANSI code page
CP_OEMCP      = 1	    ; default to OEM code page
CP_MACCP      = 2	    ; default to MAC code page
CP_THREAD_ACP = 3	    ; current thread's ANSI code page
CP_SYMBOL     = 42	    ; SYMBOL translations
CP_UTF7       = 65000	    ; UTF-7 translation
CP_UTF8       = 65001	    ; UTF-8 translation

; Resource types

RT_CURSOR	= 1
RT_BITMAP	= 2
RT_ICON 	= 3
RT_MENU 	= 4
RT_DIALOG	= 5
RT_STRING	= 6
RT_FONTDIR	= 7
RT_FONT 	= 8
RT_ACCELERATOR	= 9
RT_RCDATA	= 10
RT_MESSAGETABLE = 11
RT_GROUP_CURSOR = 12
RT_GROUP_ICON	= 14
RT_VERSION	= 16
RT_DLGINCLUDE	= 17
RT_PLUGPLAY	= 19
RT_VXD		= 20
RT_ANICURSOR	= 21
RT_ANIICON	= 22
RT_HTML 	= 23
RT_MANIFEST	= 24

; Clipboard formats

CF_TEXT 	   = 001h
CF_BITMAP	   = 002h
CF_METAFILEPICT    = 003h
CF_SYLK 	   = 004h
CF_DIF		   = 005h
CF_TIFF 	   = 006h
CF_OEMTEXT	   = 007h
CF_DIB		   = 008h
CF_PALETTE	   = 009h
CF_PENDATA	   = 00Ah
CF_RIFF 	   = 00Bh
CF_WAVE 	   = 00Ch
CF_UNICODETEXT	   = 00Dh
CF_ENHMETAFILE	   = 00Eh
CF_HDROP	   = 00Fh
CF_LOCALE	   = 010h
CF_OWNERDISPLAY    = 080h
CF_DSPTEXT	   = 081h
CF_DSPBITMAP	   = 082h
CF_DSPMETAFILEPICT = 083h
CF_DSPENHMETAFILE  = 08Eh
CF_PRIVATEFIRST    = 200h
CF_PRIVATELAST	   = 2FFh
CF_GDIOBJFIRST	   = 300h
CF_GDIOBJLAST	   = 3FFh

; OS types for version info

VOS_UNKNOWN	  = 00000000h
VOS_DOS 	  = 00010000h
VOS_OS216	  = 00020000h
VOS_OS232	  = 00030000h
VOS_NT		  = 00040000h
VOS__BASE	  = 00000000h
VOS__WINDOWS16	  = 00000001h
VOS__PM16	  = 00000002h
VOS__PM32	  = 00000003h
VOS__WINDOWS32	  = 00000004h
VOS_DOS_WINDOWS16 = 00010001h
VOS_DOS_WINDOWS32 = 00010004h
VOS_OS216_PM16	  = 00020002h
VOS_OS232_PM32	  = 00030003h
VOS_NT_WINDOWS32  = 00040004h

; File types for version info

VFT_UNKNOWN    = 00000000h
VFT_APP        = 00000001h
VFT_DLL        = 00000002h
VFT_DRV        = 00000003h
VFT_FONT       = 00000004h
VFT_VXD        = 00000005h
VFT_STATIC_LIB = 00000007h

; File subtypes for version info

VFT2_UNKNOWN		   = 00000000h
VFT2_DRV_PRINTER	   = 00000001h
VFT2_DRV_KEYBOARD	   = 00000002h
VFT2_DRV_LANGUAGE	   = 00000003h
VFT2_DRV_DISPLAY	   = 00000004h
VFT2_DRV_MOUSE		   = 00000005h
VFT2_DRV_NETWORK	   = 00000006h
VFT2_DRV_SYSTEM 	   = 00000007h
VFT2_DRV_INSTALLABLE	   = 00000008h
VFT2_DRV_SOUND		   = 00000009h
VFT2_DRV_COMM		   = 0000000Ah
VFT2_DRV_INPUTMETHOD	   = 0000000Bh
VFT2_DRV_VERSIONED_PRINTER = 0000000Ch
VFT2_FONT_RASTER	   = 00000001h
VFT2_FONT_VECTOR	   = 00000002h
VFT2_FONT_TRUETYPE	   = 00000003h

; Console control signals

CTRL_C_EVENT	    = 0
CTRL_BREAK_EVENT    = 1
CTRL_CLOSE_EVENT    = 2
CTRL_LOGOFF_EVENT   = 5
CTRL_SHUTDOWN_EVENT = 6
















; USER32.DLL structures and constants

struct POINT
  x dd ?
  y dd ?
ends

struct POINTS
  x dw ?
  y dw ?
ends

struct RECT
  left	 dd ?
  top	 dd ?
  right  dd ?
  bottom dd ?
ends

struct WNDCLASS
  style 	dd ?,?
  lpfnWndProc	dq ?
  cbClsExtra	dd ?
  cbWndExtra	dd ?
  hInstance	dq ?
  hIcon 	dq ?
  hCursor	dq ?
  hbrBackground dq ?
  lpszMenuName	dq ?
  lpszClassName dq ?
ends

struct WNDCLASSEX
  cbSize	dd ?
  style 	dd ?
  lpfnWndProc	dq ?
  cbClsExtra	dd ?
  cbWndExtra	dd ?
  hInstance	dq ?
  hIcon 	dq ?
  hCursor	dq ?
  hbrBackground dq ?
  lpszMenuName	dq ?
  lpszClassName dq ?
  hIconSm	dq ?
ends

struct CREATESTRUCT
  lpCreateParams dq ?
  hInstance	 dq ?
  hMenu 	 dq ?
  hwndParent	 dq ?
  cy		 dd ?
  cx		 dd ?
  y		 dd ?
  x		 dd ?
  style 	 dd ?,?
  lpszName	 dq ?
  lpszClass	 dq ?
  dwExStyle	 dd ?,?
ends

struct CLIENTCREATESTRUCT
  hWindowMenu  dq ?
  idFirstChild dd ?
ends

struct MDICREATESTRUCT
  szClass dq ?
  szTitle dq ?
  hOwner  dq ?
  x	  dd ?
  y	  dd ?
  cx	  dd ?
  cy	  dd ?
  style   dd ?
  lParam  dd ?
ends

struct SCROLLINFO
  cbSize    dd ?
  fMask     dd ?
  nMin	    dd ?
  nMax	    dd ?
  nPage     dd ?
  nPos	    dd ?
  nTrackPos dd ?
ends

struct MSG
  hwnd	  dq ?
  message dd ?,?
  wParam  dq ?
  lParam  dq ?
  time	  dd ?
  pt	  POINT
	  dd ?
ends

struct MINMAXINFO
  ptReserved	 POINT
  ptMaxSize	 POINT
  ptMaxPosition  POINT
  ptMinTrackSize POINT
  ptMaxTrackSize POINT
ends

struct WINDOWPLACEMENT
  length	   dd ?
  flags 	   dd ?
  showCmd	   dd ?
  ptMinPosition    POINT
  ptMaxPosition    POINT
  rcNormalPosition RECT
ends

struct WINDOWPOS
  hwnd		  dq ?
  hwndInsertAfter dq ?
  x		  dd ?
  y		  dd ?
  cx		  dd ?
  cy		  dd ?
  flags 	  dd ?
ends

struct NMHDR
  hwndFrom dq ?
  idFrom   dq ?
  code	   dd ?
ends

struct COPYDATASTRUCT
  dwData dq ?
  cbData dd ?
  lpData dq ?
ends

struct ACCEL
  fVirt dw ?
  key	dw ?
  cmd	dw ?
ends

struct PAINTSTRUCT
  hdc	      dq ?
  fErase      dd ?
  rcPaint     RECT
  fRestore    dd ?
  fIncUpdate  dd ?
  rgbReserved db 36 dup (?)
ends

struct DRAWTEXTPARAMS
  cbSize	dd ?
  iTabLength	dd ?
  iLeftMargin	dd ?
  iRightMargin	dd ?
  uiLengthDrawn dd ?,?
ends

struct DRAWITEMSTRUCT
  CtlType    dd ?
  CtlID      dd ?
  itemID     dd ?
  itemAction dd ?
  itemState  dd ?,?
  hwndItem   dq ?
  hDC	     dq ?
  rcItem     RECT
  itemData   dd ?,?
ends

struct MENUITEMINFO
  cbSize	dd ? 
  fMask 	dd ? 
  fType 	dd ? 
  fState	dd ? 
  wID		dd ?,? 
  hSubMenu	dq ? 
  hbmpChecked	dq ? 
  hbmpUnchecked dq ? 
  dwItemData	dq ? 
  dwTypeData	dq ? 
  cch		dd ?,? 
  hbmpItem	dq ? 
ends

struct MEASUREITEMSTRUCT
  CtlType    dd ?
  CtlID      dd ?
  itemID     dd ?
  itemWidth  dd ?
  itemHeight dd ?
  itemData   dd ?
ends

struct MSGBOXPARAMS
  cbSize	     dd ?,?
  hwndOwner	     dq ?
  hInstance	     dq ?
  lpszText	     dd ?
  lpszCaption	     dd ?
  dwStyle	     dd ?,?
  lpszIcon	     dq ?
  dwContextHelpId    dd ?,?
  lpfnMsgBoxCallback dq ?
  dwLanguageId	     dd ?,?
ends

struct GESTURECONFIG
  dwID	  dd ?
  dwWant  dd ?
  dwBlock dd ?
ends

struct GESTUREINFO
  cbSize       dd ?
  dwFlags      dd ?
  dwID	       dd ?
  hwndTarget   dd ?
  ptsLocation  POINTS
  dwInstanceID dd ?
  dwSequenceID dd ?,?
  ullArguments dq ?
  cbExtraArgs  dd ?,?
ends

; MessageBox type flags

MB_OK			= 000000h
MB_OKCANCEL		= 000001h
MB_ABORTRETRYIGNORE	= 000002h
MB_YESNOCANCEL		= 000003h
MB_YESNO		= 000004h
MB_RETRYCANCEL		= 000005h
MB_ICONHAND		= 000010h
MB_ICONQUESTION 	= 000020h
MB_ICONEXCLAMATION	= 000030h
MB_ICONASTERISK 	= 000040h
MB_USERICON		= 000080h
MB_ICONWARNING		= MB_ICONEXCLAMATION
MB_ICONERROR		= MB_ICONHAND
MB_ICONINFORMATION	= MB_ICONASTERISK
MB_ICONSTOP		= MB_ICONHAND
MB_DEFBUTTON1		= 000000h
MB_DEFBUTTON2		= 000100h
MB_DEFBUTTON3		= 000200h
MB_DEFBUTTON4		= 000300h
MB_APPLMODAL		= 000000h
MB_SYSTEMMODAL		= 001000h
MB_TASKMODAL		= 002000h
MB_HELP 		= 004000h
MB_NOFOCUS		= 008000h
MB_SETFOREGROUND	= 010000h
MB_DEFAULT_DESKTOP_ONLY = 020000h
MB_TOPMOST		= 040000h
MB_RIGHT		= 080000h
MB_RTLREADING		= 100000h
MB_SERVICE_NOTIFICATION = 200000h

; Conventional dialog box and message box command IDs

IDOK	 = 1
IDCANCEL = 2
IDABORT  = 3
IDRETRY  = 4
IDIGNORE = 5
IDYES	 = 6
IDNO	 = 7
IDCLOSE  = 8
IDHELP	 = 9

; Class styles

CS_VREDRAW	   = 00001h
CS_HREDRAW	   = 00002h
CS_KEYCVTWINDOW    = 00004h
CS_DBLCLKS	   = 00008h
CS_OWNDC	   = 00020h
CS_CLASSDC	   = 00040h
CS_PARENTDC	   = 00080h
CS_NOKEYCVT	   = 00100h
CS_SAVEBITS	   = 00800h
CS_NOCLOSE	   = 00200h
CS_BYTEALIGNCLIENT = 01000h
CS_BYTEALIGNWINDOW = 02000h
CS_PUBLICCLASS	   = 04000h
CS_GLOBALCLASS	   = CS_PUBLICCLASS
CS_IME		   = 10000h

; Windows styles

WS_OVERLAPPED	= 000000000h
WS_ICONICPOPUP	= 0C0000000h
WS_POPUP	= 080000000h
WS_CHILD	= 040000000h
WS_MINIMIZE	= 020000000h
WS_VISIBLE	= 010000000h
WS_DISABLED	= 008000000h
WS_CLIPSIBLINGS = 004000000h
WS_CLIPCHILDREN = 002000000h
WS_MAXIMIZE	= 001000000h
WS_CAPTION	= 000C00000h
WS_BORDER	= 000800000h
WS_DLGFRAME	= 000400000h
WS_VSCROLL	= 000200000h
WS_HSCROLL	= 000100000h
WS_SYSMENU	= 000080000h
WS_THICKFRAME	= 000040000h
WS_HREDRAW	= 000020000h
WS_VREDRAW	= 000010000h
WS_GROUP	= 000020000h
WS_TABSTOP	= 000010000h
WS_MINIMIZEBOX	= 000020000h
WS_MAXIMIZEBOX	= 000010000h

; Common Window Styles

WS_OVERLAPPEDWINDOW = WS_OVERLAPPED or WS_CAPTION or WS_SYSMENU or WS_THICKFRAME or WS_MINIMIZEBOX or WS_MAXIMIZEBOX
WS_POPUPWINDOW	    = WS_POPUP or WS_BORDER or WS_SYSMENU
WS_CHILDWINDOW	    = WS_CHILD
WS_TILEDWINDOW	    = WS_OVERLAPPEDWINDOW
WS_TILED	    = WS_OVERLAPPED
WS_ICONIC	    = WS_MINIMIZE
WS_SIZEBOX	    = WS_THICKFRAME

; Extended Window Styles

WS_EX_DLGMODALFRAME    = 00001h
WS_EX_DRAGOBJECT       = 00002h
WS_EX_NOPARENTNOTIFY   = 00004h
WS_EX_TOPMOST	       = 00008h
WS_EX_ACCEPTFILES      = 00010h
WS_EX_TRANSPARENT      = 00020h
WS_EX_MDICHILD	       = 00040h
WS_EX_TOOLWINDOW       = 00080h
WS_EX_WINDOWEDGE       = 00100h
WS_EX_CLIENTEDGE       = 00200h
WS_EX_CONTEXTHELP      = 00400h
WS_EX_RIGHT	       = 01000h
WS_EX_LEFT	       = 00000h
WS_EX_RTLREADING       = 02000h
WS_EX_LTRREADING       = 00000h
WS_EX_LEFTSCROLLBAR    = 04000h
WS_EX_RIGHTSCROLLBAR   = 00000h
WS_EX_CONTROLPARENT    = 10000h
WS_EX_STATICEDGE       = 20000h
WS_EX_APPWINDOW        = 40000h
WS_EX_LAYERED	       = 80000h
WS_EX_OVERLAPPEDWINDOW = WS_EX_WINDOWEDGE or WS_EX_CLIENTEDGE
WS_EX_PALETTEWINDOW    = WS_EX_WINDOWEDGE or WS_EX_TOOLWINDOW or WS_EX_TOPMOST

; MDI client style bits

MDIS_ALLCHILDSTYLES = 1

; Special CreateWindow position value

CW_USEDEFAULT = 80000000h

; Predefined window handle

HWND_DESKTOP   = 0

; ShowWindow commands

SW_HIDE 	   = 0
SW_SHOWNORMAL	   = 1
SW_NORMAL	   = 1
SW_SHOWMINIMIZED   = 2
SW_SHOWMAXIMIZED   = 3
SW_MAXIMIZE	   = 3
SW_SHOWNOACTIVATE  = 4
SW_SHOW 	   = 5
SW_MINIMIZE	   = 6
SW_SHOWMINNOACTIVE = 7
SW_SHOWNA	   = 8
SW_RESTORE	   = 9
SW_SHOWDEFAULT	   = 10

; SetWindowPos flags

SWP_NOSIZE	   = 0001h
SWP_NOMOVE	   = 0002h
SWP_NOZORDER	   = 0004h
SWP_NOREDRAW	   = 0008h
SWP_NOACTIVATE	   = 0010h
SWP_DRAWFRAME	   = 0020h
SWP_SHOWWINDOW	   = 0040h
SWP_HIDEWINDOW	   = 0080h
SWP_NOCOPYBITS	   = 0100h
SWP_NOREPOSITION   = 0200h
SWP_DEFERERASE	   = 2000h
SWP_ASYNCWINDOWPOS = 4000h

; SetWindowPos special handle values

HWND_TOP       = 0
HWND_BOTTOM    = 1
HWND_TOPMOST   = -1
HWND_NOTOPMOST = -2

; GetWindow flags

GW_HWNDFIRST = 0
GW_HWNDLAST  = 1
GW_HWNDNEXT  = 2
GW_HWNDPREV  = 3
GW_OWNER     = 4
GW_CHILD     = 5

; RedrawWindow flags

RDW_INVALIDATE	    = 0001h
RDW_INTERNALPAINT   = 0002h
RDW_ERASE	    = 0004h
RDW_VALIDATE	    = 0008h
RDW_NOINTERNALPAINT = 0010h
RDW_NOERASE	    = 0020h
RDW_NOCHILDREN	    = 0040h
RDW_ALLCHILDREN     = 0080h
RDW_UPDATENOW	    = 0100h
RDW_ERASENOW	    = 0200h
RDW_FRAME	    = 0400h
RDW_NOFRAME	    = 0800h

; PeekMessage Options

PM_NOREMOVE = 0000h
PM_REMOVE   = 0001h
PM_NOYIELD  = 0002h

; Window state messages

WM_STATE		  = 0000h
WM_NULL 		  = 0000h
WM_CREATE		  = 0001h
WM_DESTROY		  = 0002h
WM_MOVE 		  = 0003h
WM_SIZE 		  = 0005h
WM_ACTIVATE		  = 0006h
WM_SETFOCUS		  = 0007h
WM_KILLFOCUS		  = 0008h
WM_ENABLE		  = 000Ah
WM_SETREDRAW		  = 000Bh
WM_SETTEXT		  = 000Ch
WM_GETTEXT		  = 000Dh
WM_GETTEXTLENGTH	  = 000Eh
WM_PAINT		  = 000Fh
WM_CLOSE		  = 0010h
WM_QUERYENDSESSION	  = 0011h
WM_QUIT 		  = 0012h
WM_QUERYOPEN		  = 0013h
WM_ERASEBKGND		  = 0014h
WM_SYSCOLORCHANGE	  = 0015h
WM_ENDSESSION		  = 0016h
WM_SYSTEMERROR		  = 0017h
WM_SHOWWINDOW		  = 0018h
WM_CTLCOLOR		  = 0019h
WM_WININICHANGE 	  = 001Ah
WM_DEVMODECHANGE	  = 001Bh
WM_ACTIVATEAPP		  = 001Ch
WM_FONTCHANGE		  = 001Dh
WM_TIMECHANGE		  = 001Eh
WM_CANCELMODE		  = 001Fh
WM_SETCURSOR		  = 0020h
WM_MOUSEACTIVATE	  = 0021h
WM_CHILDACTIVATE	  = 0022h
WM_QUEUESYNC		  = 0023h
WM_GETMINMAXINFO	  = 0024h
WM_PAINTICON		  = 0026h
WM_ICONERASEBKGND	  = 0027h
WM_NEXTDLGCTL		  = 0028h
WM_SPOOLERSTATUS	  = 002Ah
WM_DRAWITEM		  = 002Bh
WM_MEASUREITEM		  = 002Ch
WM_DELETEITEM		  = 002Dh
WM_VKEYTOITEM		  = 002Eh
WM_CHARTOITEM		  = 002Fh
WM_SETFONT		  = 0030h
WM_GETFONT		  = 0031h
WM_SETHOTKEY		  = 0032h
WM_QUERYDRAGICON	  = 0037h
WM_COMPAREITEM		  = 0039h
WM_COMPACTING		  = 0041h
WM_COMMNOTIFY		  = 0044h
WM_WINDOWPOSCHANGING	  = 0046h
WM_WINDOWPOSCHANGED	  = 0047h
WM_POWER		  = 0048h
WM_COPYDATA		  = 004Ah
WM_CANCELJOURNAL	  = 004Bh
WM_NOTIFY		  = 004Eh
WM_INPUTLANGCHANGEREQUEST = 0050h
WM_INPUTLANGCHANGE	  = 0051h
WM_TCARD		  = 0052h
WM_HELP 		  = 0053h
WM_USERCHANGED		  = 0054h
WM_NOTIFYFORMAT 	  = 0055h
WM_CONTEXTMENU		  = 007Bh
WM_STYLECHANGING	  = 007Ch
WM_STYLECHANGED 	  = 007Dh
WM_DISPLAYCHANGE	  = 007Eh
WM_GETICON		  = 007Fh
WM_SETICON		  = 0080h
WM_NCCREATE		  = 0081h
WM_NCDESTROY		  = 0082h
WM_NCCALCSIZE		  = 0083h
WM_NCHITTEST		  = 0084h
WM_NCPAINT		  = 0085h
WM_NCACTIVATE		  = 0086h
WM_GETDLGCODE		  = 0087h
WM_NCMOUSEMOVE		  = 00A0h
WM_NCLBUTTONDOWN	  = 00A1h
WM_NCLBUTTONUP		  = 00A2h
WM_NCLBUTTONDBLCLK	  = 00A3h
WM_NCRBUTTONDOWN	  = 00A4h
WM_NCRBUTTONUP		  = 00A5h
WM_NCRBUTTONDBLCLK	  = 00A6h
WM_NCMBUTTONDOWN	  = 00A7h
WM_NCMBUTTONUP		  = 00A8h
WM_NCMBUTTONDBLCLK	  = 00A9h
WM_KEYFIRST		  = 0100h
WM_KEYDOWN		  = 0100h
WM_KEYUP		  = 0101h
WM_CHAR 		  = 0102h
WM_DEADCHAR		  = 0103h
WM_SYSKEYDOWN		  = 0104h
WM_SYSKEYUP		  = 0105h
WM_SYSCHAR		  = 0106h
WM_SYSDEADCHAR		  = 0107h
WM_KEYLAST		  = 0108h
WM_INITDIALOG		  = 0110h
WM_COMMAND		  = 0111h
WM_SYSCOMMAND		  = 0112h
WM_TIMER		  = 0113h
WM_HSCROLL		  = 0114h
WM_VSCROLL		  = 0115h
WM_INITMENU		  = 0116h
WM_INITMENUPOPUP	  = 0117h
WM_GESTURE		  = 0119h
WM_GESTURENOTIFY	  = 011Ah
WM_MENUSELECT		  = 011Fh
WM_MENUCHAR		  = 0120h
WM_ENTERIDLE		  = 0121h
WM_MENURBUTTONUP	  = 0122h
WM_MENUDRAG		  = 0123h
WM_MENUGETOBJECT	  = 0124h
WM_UNINITMENUPOPUP	  = 0125h
WM_MENUCOMMAND		  = 0126h
WM_CTLCOLORMSGBOX	  = 0132h
WM_CTLCOLOREDIT 	  = 0133h
WM_CTLCOLORLISTBOX	  = 0134h
WM_CTLCOLORBTN		  = 0135h
WM_CTLCOLORDLG		  = 0136h
WM_CTLCOLORSCROLLBAR	  = 0137h
WM_CTLCOLORSTATIC	  = 0138h
WM_MOUSEFIRST		  = 0200h
WM_MOUSEMOVE		  = 0200h
WM_LBUTTONDOWN		  = 0201h
WM_LBUTTONUP		  = 0202h
WM_LBUTTONDBLCLK	  = 0203h
WM_RBUTTONDOWN		  = 0204h
WM_RBUTTONUP		  = 0205h
WM_RBUTTONDBLCLK	  = 0206h
WM_MBUTTONDOWN		  = 0207h
WM_MBUTTONUP		  = 0208h
WM_MBUTTONDBLCLK	  = 0209h
WM_MOUSEWHEEL		  = 020Ah
WM_MOUSELAST		  = 020Ah
WM_PARENTNOTIFY 	  = 0210h
WM_ENTERMENULOOP	  = 0211h
WM_EXITMENULOOP 	  = 0212h
WM_NEXTMENU		  = 0213h
WM_SIZING		  = 0214h
WM_CAPTURECHANGED	  = 0215h
WM_MOVING		  = 0216h
WM_POWERBROADCAST	  = 0218h
WM_DEVICECHANGE 	  = 0219h
WM_MDICREATE		  = 0220h
WM_MDIDESTROY		  = 0221h
WM_MDIACTIVATE		  = 0222h
WM_MDIRESTORE		  = 0223h
WM_MDINEXT		  = 0224h
WM_MDIMAXIMIZE		  = 0225h
WM_MDITILE		  = 0226h
WM_MDICASCADE		  = 0227h
WM_MDIICONARRANGE	  = 0228h
WM_MDIGETACTIVE 	  = 0229h
WM_MDISETMENU		  = 0230h
WM_ENTERSIZEMOVE	  = 0231h
WM_EXITSIZEMOVE 	  = 0232h
WM_DROPFILES		  = 0233h
WM_MDIREFRESHMENU	  = 0234h
WM_IME_SETCONTEXT	  = 0281h
WM_IME_NOTIFY		  = 0282h
WM_IME_CONTROL		  = 0283h
WM_IME_COMPOSITIONFULL	  = 0284h
WM_IME_SELECT		  = 0285h
WM_IME_CHAR		  = 0286h
WM_IME_KEYDOWN		  = 0290h
WM_IME_KEYUP		  = 0291h
WM_MOUSEHOVER		  = 02A1h
WM_MOUSELEAVE		  = 02A3h
WM_CUT			  = 0300h
WM_COPY 		  = 0301h
WM_PASTE		  = 0302h
WM_CLEAR		  = 0303h
WM_UNDO 		  = 0304h
WM_RENDERFORMAT 	  = 0305h
WM_RENDERALLFORMATS	  = 0306h
WM_DESTROYCLIPBOARD	  = 0307h
WM_DRAWCLIPBOARD	  = 0308h
WM_PAINTCLIPBOARD	  = 0309h
WM_VSCROLLCLIPBOARD	  = 030Ah
WM_SIZECLIPBOARD	  = 030Bh
WM_ASKCBFORMATNAME	  = 030Ch
WM_CHANGECBCHAIN	  = 030Dh
WM_HSCROLLCLIPBOARD	  = 030Eh
WM_QUERYNEWPALETTE	  = 030Fh
WM_PALETTEISCHANGING	  = 0310h
WM_PALETTECHANGED	  = 0311h
WM_HOTKEY		  = 0312h
WM_PRINT		  = 0317h
WM_PRINTCLIENT		  = 0318h
WM_HANDHELDFIRST	  = 0358h
WM_HANDHELDLAST 	  = 035Fh
WM_AFXFIRST		  = 0360h
WM_AFXLAST		  = 037Fh
WM_PENWINFIRST		  = 0380h
WM_PENWINLAST		  = 038Fh
WM_COALESCE_FIRST	  = 0390h
WM_COALESCE_LAST	  = 039Fh
WM_USER 		  = 0400h

; WM_SIZE commands

SIZE_RESTORED  = 0
SIZE_MINIMIZED = 1
SIZE_MAXIMIZED = 2
SIZE_MAXSHOW   = 3
SIZE_MAXHIDE   = 4

; WM_ACTIVATE states

WA_INACTIVE    = 0
WA_ACTIVE      = 1
WA_CLICKACTIVE = 2

; WM_SHOWWINDOW identifiers

SW_PARENTCLOSING = 1
SW_OTHERZOOM	 = 2
SW_PARENTOPENING = 3
SW_OTHERUNZOOM	 = 4

; WM_MOUSEACTIVATE return codes

MA_ACTIVATE	    = 1
MA_ACTIVATEANDEAT   = 2
MA_NOACTIVATE	    = 3
MA_NOACTIVATEANDEAT = 4

; WM_MDITILE flags

MDITILE_VERTICAL     = 0
MDITILE_HORIZONTAL   = 1
MDITILE_SKIPDISABLED = 2

; WM_NOTIFY codes

NM_OUTOFMEMORY = -1
NM_CLICK       = -2
NM_DBLCLICK    = -3
NM_RETURN      = -4
NM_RCLICK      = -5
NM_RDBLCLK     = -6
NM_SETFOCUS    = -7
NM_KILLFOCUS   = -8

; WM_SETICON types

ICON_SMALL = 0
ICON_BIG   = 1

; WM_HOTKEY commands

HOTKEYF_SHIFT	= 01h
HOTKEYF_CONTROL = 02h
HOTKEYF_ALT	= 04h
HOTKEYF_EXT	= 08h

; Keystroke flags

KF_EXTENDED = 0100h
KF_DLGMODE  = 0800h
KF_MENUMODE = 1000h
KF_ALTDOWN  = 2000h
KF_REPEAT   = 4000h
KF_UP	    = 8000h

; Key state masks for mouse messages

MK_LBUTTON = 01h
MK_RBUTTON = 02h
MK_SHIFT   = 04h
MK_CONTROL = 08h
MK_MBUTTON = 10h

; WM_SIZING codes

WMSZ_LEFT	 = 1
WMSZ_RIGHT	 = 2
WMSZ_TOP	 = 3
WMSZ_TOPLEFT	 = 4
WMSZ_TOPRIGHT	 = 5
WMSZ_BOTTOM	 = 6
WMSZ_BOTTOMLEFT  = 7
WMSZ_BOTTOMRIGHT = 8

; WM_HOTKEY modifiers

MOD_ALT     = 1
MOD_CONTROL = 2
MOD_SHIFT   = 4
MOD_WIN     = 8

; WM_PRINT flags

PRF_CHECKVISIBLE = 01h
PRF_NONCLIENT	 = 02h
PRF_CLIENT	 = 04h
PRF_ERASEBKGND	 = 08h
PRF_CHILDREN	 = 10h
PRF_OWNED	 = 20h

; Virtual key codes

VK_LBUTTON   = 001h
VK_CANCEL    = 003h
VK_RBUTTON   = 002h
VK_MBUTTON   = 004h
VK_BACK      = 008h
VK_TAB	     = 009h
VK_CLEAR     = 00Ch
VK_RETURN    = 00Dh
VK_SHIFT     = 010h
VK_CONTROL   = 011h
VK_MENU      = 012h
VK_PAUSE     = 013h
VK_CAPITAL   = 014h
VK_ESCAPE    = 01Bh
VK_SPACE     = 020h
VK_PRIOR     = 021h
VK_PGUP      = 021h
VK_PGDN      = 022h
VK_NEXT      = 022h
VK_END	     = 023h
VK_HOME      = 024h
VK_LEFT      = 025h
VK_UP	     = 026h
VK_RIGHT     = 027h
VK_DOWN      = 028h
VK_SELECT    = 029h
VK_PRINT     = 02Ah
VK_EXECUTE   = 02Bh
VK_SNAPSHOT  = 02Ch
VK_INSERT    = 02Dh
VK_DELETE    = 02Eh
VK_HELP      = 02Fh
VK_LWIN      = 05Bh
VK_RWIN      = 05Ch
VK_APPS      = 05Dh
VK_NUMPAD0   = 060h
VK_NUMPAD1   = 061h
VK_NUMPAD2   = 062h
VK_NUMPAD3   = 063h
VK_NUMPAD4   = 064h
VK_NUMPAD5   = 065h
VK_NUMPAD6   = 066h
VK_NUMPAD7   = 067h
VK_NUMPAD8   = 068h
VK_NUMPAD9   = 069h
VK_MULTIPLY  = 06Ah
VK_ADD	     = 06Bh
VK_SEPARATOR = 06Ch
VK_SUBTRACT  = 06Dh
VK_DECIMAL   = 06Eh
VK_DIVIDE    = 06Fh
VK_F1	     = 070h
VK_F2	     = 071h
VK_F3	     = 072h
VK_F4	     = 073h
VK_F5	     = 074h
VK_F6	     = 075h
VK_F7	     = 076h
VK_F8	     = 077h
VK_F9	     = 078h
VK_F10	     = 079h
VK_F11	     = 07Ah
VK_F12	     = 07Bh
VK_F13	     = 07Ch
VK_F14	     = 07Dh
VK_F15	     = 07Eh
VK_F16	     = 07Fh
VK_F17	     = 080h
VK_F18	     = 081h
VK_F19	     = 082h
VK_F20	     = 083h
VK_F21	     = 084h
VK_F22	     = 085h
VK_F23	     = 086h
VK_F24	     = 087h
VK_NUMLOCK   = 090h
VK_SCROLL    = 091h
VK_LSHIFT    = 0A0h
VK_RSHIFT    = 0A1h
VK_LCONTROL  = 0A2h
VK_RCONTROL  = 0A3h
VK_LMENU     = 0A4h
VK_RMENU     = 0A5h
VK_ATTN      = 0F6h
VK_CRSEL     = 0F7h
VK_EXSEL     = 0F8h
VK_EREOF     = 0F9h
VK_PLAY      = 0FAh
VK_ZOOM      = 0FBh
VK_NONAME    = 0FCh
VK_PA1	     = 0FDh
VK_OEM_CLEAR = 0FEh

; Accelerator flags

FVIRTKEY  = 01h
FNOINVERT = 02h
FSHIFT	  = 04h
FCONTROL  = 08h
FALT	  = 10h

; GetClassLong offsets

GCL_MENUNAME	  = -8
GCL_HBRBACKGROUND = -10
GCL_HCURSOR	  = -12
GCL_HICON	  = -14
GCL_HMODULE	  = -16
GCL_CBWNDEXTRA	  = -18
GCL_CBCLSEXTRA	  = -20
GCL_WNDPROC	  = -24
GCL_STYLE	  = -26
GCW_ATOM	  = -32
GCL_HICONSM	  = -34

; WNDCLASS parameters

DLGWINDOWEXTRA = 30

; GetWindowLong offsets

GWL_WNDPROC	  = -4
GWL_HINSTANCE	  = -6
GWL_HWNDPARENT	  = -8
GWL_STYLE	  = -16
GWL_EXSTYLE	  = -20
GWL_USERDATA	  = -21
GWL_ID		  = -12
DWL_MSGRESULT	  = 0
DWL_DLGPROC	  = 4
DWL_USER	  = 8

; GetSystemMetrics codes

SM_CXSCREEN	     = 0
SM_CYSCREEN	     = 1
SM_CXVSCROLL	     = 2
SM_CYHSCROLL	     = 3
SM_CYCAPTION	     = 4
SM_CXBORDER	     = 5
SM_CYBORDER	     = 6
SM_CXDLGFRAME	     = 7
SM_CYDLGFRAME	     = 8
SM_CYVTHUMB	     = 9
SM_CXHTHUMB	     = 10
SM_CXICON	     = 11
SM_CYICON	     = 12
SM_CXCURSOR	     = 13
SM_CYCURSOR	     = 14
SM_CYMENU	     = 15
SM_CXFULLSCREEN      = 16
SM_CYFULLSCREEN      = 17
SM_CYKANJIWINDOW     = 18
SM_MOUSEPRESENT      = 19
SM_CYVSCROLL	     = 20
SM_CXHSCROLL	     = 21
SM_DEBUG	     = 22
SM_SWAPBUTTON	     = 23
SM_RESERVED1	     = 24
SM_RESERVED2	     = 25
SM_RESERVED3	     = 26
SM_RESERVED4	     = 27
SM_CXMIN	     = 28
SM_CYMIN	     = 29
SM_CXSIZE	     = 30
SM_CYSIZE	     = 31
SM_CXFRAME	     = 32
SM_CYFRAME	     = 33
SM_CXMINTRACK	     = 34
SM_CYMINTRACK	     = 35
SM_CXDOUBLECLK	     = 36
SM_CYDOUBLECLK	     = 37
SM_CXICONSPACING     = 38
SM_CYICONSPACING     = 39
SM_MENUDROPALIGNMENT = 40
SM_PENWINDOWS	     = 41
SM_DBCSENABLED	     = 42
SM_CMOUSEBUTTONS     = 43
SM_CXFIXEDFRAME      = SM_CXDLGFRAME
SM_CYFIXEDFRAME      = SM_CYDLGFRAME
SM_CXSIZEFRAME	     = SM_CXFRAME
SM_CYSIZEFRAME	     = SM_CYFRAME
SM_SECURE	     = 44
SM_CXEDGE	     = 45
SM_CYEDGE	     = 46
SM_CXMINSPACING      = 47
SM_CYMINSPACING      = 48
SM_CXSMICON	     = 49
SM_CYSMICON	     = 50
SM_CYSMCAPTION	     = 51
SM_CXSMSIZE	     = 52
SM_CYSMSIZE	     = 53
SM_CXMENUSIZE	     = 54
SM_CYMENUSIZE	     = 55
SM_ARRANGE	     = 56
SM_CXMINIMIZED	     = 57
SM_CYMINIMIZED	     = 58
SM_CXMAXTRACK	     = 59
SM_CYMAXTRACK	     = 60
SM_CXMAXIMIZED	     = 61
SM_CYMAXIMIZED	     = 62
SM_NETWORK	     = 63
SM_CLEANBOOT	     = 67
SM_CXDRAG	     = 68
SM_CYDRAG	     = 69
SM_SHOWSOUNDS	     = 70
SM_CXMENUCHECK	     = 71
SM_CYMENUCHECK	     = 72
SM_SLOWMACHINE	     = 73
SM_MIDEASTENABLED    = 74
SM_MOUSEWHEELPRESENT = 75
SM_CMETRICS	     = 76

; Predefined cursor identifiers

IDC_ARROW	= 32512
IDC_IBEAM	= 32513
IDC_WAIT	= 32514
IDC_CROSS	= 32515
IDC_UPARROW	= 32516
IDC_SIZE	= 32640
IDC_ICON	= 32641
IDC_SIZENWSE	= 32642
IDC_SIZENESW	= 32643
IDC_SIZEWE	= 32644
IDC_SIZENS	= 32645
IDC_NO		= 32648
IDC_HAND	= 32649
IDC_APPSTARTING = 32650
IDC_HELP	= 32651

; Predefined icon identifiers

IDI_APPLICATION = 32512
IDI_HAND	= 32513
IDI_QUESTION	= 32514
IDI_EXCLAMATION = 32515
IDI_ASTERISK	= 32516
IDI_WINLOGO	= 32517

; System colors

COLOR_SCROLLBAR 	      = 0
COLOR_BACKGROUND	      = 1
COLOR_ACTIVECAPTION	      = 2
COLOR_INACTIVECAPTION	      = 3
COLOR_MENU		      = 4
COLOR_WINDOW		      = 5
COLOR_WINDOWFRAME	      = 6
COLOR_MENUTEXT		      = 7
COLOR_WINDOWTEXT	      = 8
COLOR_CAPTIONTEXT	      = 9
COLOR_ACTIVEBORDER	      = 10
COLOR_INACTIVEBORDER	      = 11
COLOR_APPWORKSPACE	      = 12
COLOR_HIGHLIGHT 	      = 13
COLOR_HIGHLIGHTTEXT	      = 14
COLOR_BTNFACE		      = 15
COLOR_BTNSHADOW 	      = 16
COLOR_GRAYTEXT		      = 17
COLOR_BTNTEXT		      = 18
COLOR_INACTIVECAPTIONTEXT     = 19
COLOR_BTNHIGHLIGHT	      = 20
COLOR_3DDKSHADOW	      = 21
COLOR_3DLIGHT		      = 22
COLOR_INFOTEXT		      = 23
COLOR_INFOBK		      = 24
COLOR_HOTLIGHT		      = 26
COLOR_GRADIENTACTIVECAPTION   = 27
COLOR_GRADIENTINACTIVECAPTION = 28

; Button messages

BM_GETCHECK = 00F0h
BM_SETCHECK = 00F1h
BM_GETSTATE = 00F2h
BM_SETSTATE = 00F3h
BM_SETSTYLE = 00F4h
BM_CLICK    = 00F5h
BM_GETIMAGE = 00F6h
BM_SETIMAGE = 00F7h

; Button notifications

BN_CLICKED	 = 0
BN_PAINT	 = 1
BN_HILITE	 = 2
BN_UNHILITE	 = 3
BN_DISABLE	 = 4
BN_DOUBLECLICKED = 5
BN_SETFOCUS	 = 6
BN_KILLFOCUS	 = 7
BN_PUSHED	 = BN_HILITE
BN_UNPUSHED	 = BN_UNHILITE
BN_DBLCLK	 = BN_DOUBLECLICKED

; Button styles

BS_PUSHBUTTON	   = 0000h
BS_DEFPUSHBUTTON   = 0001h
BS_CHECKBOX	   = 0002h
BS_AUTOCHECKBOX    = 0003h
BS_RADIOBUTTON	   = 0004h
BS_3STATE	   = 0005h
BS_AUTO3STATE	   = 0006h
BS_GROUPBOX	   = 0007h
BS_USERBUTTON	   = 0008h
BS_AUTORADIOBUTTON = 0009h
BS_OWNERDRAW	   = 000Bh
BS_TEXT 	   = 0000h
BS_LEFTTEXT	   = 0020h
BS_RIGHTBUTTON	   = BS_LEFTTEXT
BS_ICON 	   = 0040h
BS_BITMAP	   = 0080h
BS_LEFT 	   = 0100h
BS_RIGHT	   = 0200h
BS_CENTER	   = 0300h
BS_TOP		   = 0400h
BS_BOTTOM	   = 0800h
BS_VCENTER	   = 0C00h
BS_PUSHLIKE	   = 1000h
BS_MULTILINE	   = 2000h
BS_NOTIFY	   = 4000h
BS_FLAT 	   = 8000h

; Button states

BST_UNCHECKED	  = 0
BST_CHECKED	  = 1
BST_INDETERMINATE = 2
BST_PUSHED	  = 4
BST_FOCUS	  = 8

; List box messages

LB_ADDSTRING	       = 0180h
LB_INSERTSTRING        = 0181h
LB_DELETESTRING        = 0182h
LB_SELITEMRANGEEX      = 0183h
LB_RESETCONTENT        = 0184h
LB_SETSEL	       = 0185h
LB_SETCURSEL	       = 0186h
LB_GETSEL	       = 0187h
LB_GETCURSEL	       = 0188h
LB_GETTEXT	       = 0189h
LB_GETTEXTLEN	       = 018Ah
LB_GETCOUNT	       = 018Bh
LB_SELECTSTRING        = 018Ch
LB_DIR		       = 018Dh
LB_GETTOPINDEX	       = 018Eh
LB_FINDSTRING	       = 018Fh
LB_GETSELCOUNT	       = 0190h
LB_GETSELITEMS	       = 0191h
LB_SETTABSTOPS	       = 0192h
LB_GETHORIZONTALEXTENT = 0193h
LB_SETHORIZONTALEXTENT = 0194h
LB_SETCOLUMNWIDTH      = 0195h
LB_ADDFILE	       = 0196h
LB_SETTOPINDEX	       = 0197h
LB_GETITEMRECT	       = 0198h
LB_GETITEMDATA	       = 0199h
LB_SETITEMDATA	       = 019Ah
LB_SELITEMRANGE        = 019Bh
LB_SETANCHORINDEX      = 019Ch
LB_GETANCHORINDEX      = 019Dh
LB_SETCARETINDEX       = 019Eh
LB_GETCARETINDEX       = 019Fh
LB_SETITEMHEIGHT       = 01A0h
LB_GETITEMHEIGHT       = 01A1h
LB_FINDSTRINGEXACT     = 01A2h
LB_SETLOCALE	       = 01A5h
LB_GETLOCALE	       = 01A6h
LB_SETCOUNT	       = 01A7h
LB_INITSTORAGE	       = 01A8h
LB_ITEMFROMPOINT       = 01A9h

; List box notifications

LBN_ERRSPACE  = -2
LBN_SELCHANGE = 1
LBN_DBLCLK    = 2
LBN_SELCANCEL = 3
LBN_SETFOCUS  = 4
LBN_KILLFOCUS = 5

; List box styles

LBS_NOTIFY	      = 0001h
LBS_SORT	      = 0002h
LBS_NOREDRAW	      = 0004h
LBS_MULTIPLESEL       = 0008h
LBS_OWNERDRAWFIXED    = 0010h
LBS_OWNERDRAWVARIABLE = 0020h
LBS_HASSTRINGS	      = 0040h
LBS_USETABSTOPS       = 0080h
LBS_NOINTEGRALHEIGHT  = 0100h
LBS_MULTICOLUMN       = 0200h
LBS_WANTKEYBOARDINPUT = 0400h
LBS_EXTENDEDSEL       = 0800h
LBS_DISABLENOSCROLL   = 1000h
LBS_NODATA	      = 2000h
LBS_NOSEL	      = 4000h
LBS_STANDARD	      = LBS_NOTIFY or LBS_SORT or WS_VSCROLL or WS_BORDER

; List box return values

LB_OKAY     = 0
LB_ERR	    = -1
LB_ERRSPACE = -2

; Combo box messages

CB_GETEDITSEL		 = 0140h
CB_LIMITTEXT		 = 0141h
CB_SETEDITSEL		 = 0142h
CB_ADDSTRING		 = 0143h
CB_DELETESTRING 	 = 0144h
CB_DIR			 = 0145h
CB_GETCOUNT		 = 0146h
CB_GETCURSEL		 = 0147h
CB_GETLBTEXT		 = 0148h
CB_GETLBTEXTLEN 	 = 0149h
CB_INSERTSTRING 	 = 014Ah
CB_RESETCONTENT 	 = 014Bh
CB_FINDSTRING		 = 014Ch
CB_SELECTSTRING 	 = 014Dh
CB_SETCURSEL		 = 014Eh
CB_SHOWDROPDOWN 	 = 014Fh
CB_GETITEMDATA		 = 0150h
CB_SETITEMDATA		 = 0151h
CB_GETDROPPEDCONTROLRECT = 0152h
CB_SETITEMHEIGHT	 = 0153h
CB_GETITEMHEIGHT	 = 0154h
CB_SETEXTENDEDUI	 = 0155h
CB_GETEXTENDEDUI	 = 0156h
CB_GETDROPPEDSTATE	 = 0157h
CB_FINDSTRINGEXACT	 = 0158h
CB_SETLOCALE		 = 0159h
CB_GETLOCALE		 = 015Ah
CB_GETTOPINDEX		 = 015Bh
CB_SETTOPINDEX		 = 015Ch
CB_GETHORIZONTALEXTENT	 = 015Dh
CB_SETHORIZONTALEXTENT	 = 015Eh
CB_GETDROPPEDWIDTH	 = 015Fh
CB_SETDROPPEDWIDTH	 = 0160h
CB_INITSTORAGE		 = 0161h

; Combo box notifications

CBN_ERRSPACE	 = -1
CBN_SELCHANGE	 = 1
CBN_DBLCLK	 = 2
CBN_SETFOCUS	 = 3
CBN_KILLFOCUS	 = 4
CBN_EDITCHANGE	 = 5
CBN_EDITUPDATE	 = 6
CBN_DROPDOWN	 = 7
CBN_CLOSEUP	 = 8
CBN_SELENDOK	 = 9
CBN_SELENDCANCEL = 10

; Combo box styles

CBS_SIMPLE	      = 0001h
CBS_DROPDOWN	      = 0002h
CBS_DROPDOWNLIST      = 0003h
CBS_OWNERDRAWFIXED    = 0010h
CBS_OWNERDRAWVARIABLE = 0020h
CBS_AUTOHSCROLL       = 0040h
CBS_OEMCONVERT	      = 0080h
CBS_SORT	      = 0100h
CBS_HASSTRINGS	      = 0200h
CBS_NOINTEGRALHEIGHT  = 0400h
CBS_DISABLENOSCROLL   = 0800h
CBS_UPPERCASE	      = 2000h
CBS_LOWERCASE	      = 4000h

; Combo box return values

CB_OKAY     = 0
CB_ERR	    = -1
CB_ERRSPACE = -2

; Edit control messages

EM_GETSEL	       = 00B0h
EM_SETSEL	       = 00B1h
EM_GETRECT	       = 00B2h
EM_SETRECT	       = 00B3h
EM_SETRECTNP	       = 00B4h
EM_SCROLL	       = 00B5h
EM_LINESCROLL	       = 00B6h
EM_SCROLLCARET	       = 00B7h
EM_GETMODIFY	       = 00B8h
EM_SETMODIFY	       = 00B9h
EM_GETLINECOUNT        = 00BAh
EM_LINEINDEX	       = 00BBh
EM_SETHANDLE	       = 00BCh
EM_GETHANDLE	       = 00BDh
EM_GETTHUMB	       = 00BEh
EM_LINELENGTH	       = 00C1h
EM_REPLACESEL	       = 00C2h
EM_GETLINE	       = 00C4h
EM_LIMITTEXT	       = 00C5h
EM_CANUNDO	       = 00C6h
EM_UNDO 	       = 00C7h
EM_FMTLINES	       = 00C8h
EM_LINEFROMCHAR        = 00C9h
EM_SETTABSTOPS	       = 00CBh
EM_SETPASSWORDCHAR     = 00CCh
EM_EMPTYUNDOBUFFER     = 00CDh
EM_GETFIRSTVISIBLELINE = 00CEh
EM_SETREADONLY	       = 00CFh
EM_SETWORDBREAKPROC    = 00D0h
EM_GETWORDBREAKPROC    = 00D1h
EM_GETPASSWORDCHAR     = 00D2h
EM_SETMARGINS	       = 00D3h
EM_GETMARGINS	       = 00D4h
EM_SETLIMITTEXT        = EM_LIMITTEXT
EM_GETLIMITTEXT        = 00D5h
EM_POSFROMCHAR	       = 00D6h
EM_CHARFROMPOS	       = 00D7h

; Edit control EM_SETMARGIN parameters

EC_LEFTMARGIN  = 1
EC_RIGHTMARGIN = 2
EC_USEFONTINFO = 0FFFFh

; Edit control notifications

EN_SETFOCUS  = 0100h
EN_KILLFOCUS = 0200h
EN_CHANGE    = 0300h
EN_UPDATE    = 0400h
EN_ERRSPACE  = 0500h
EN_MAXTEXT   = 0501h
EN_HSCROLL   = 0601h
EN_VSCROLL   = 0602h

; Edit control styles

ES_LEFT        = 0000h
ES_CENTER      = 0001h
ES_RIGHT       = 0002h
ES_MULTILINE   = 0004h
ES_UPPERCASE   = 0008h
ES_LOWERCASE   = 0010h
ES_PASSWORD    = 0020h
ES_AUTOVSCROLL = 0040h
ES_AUTOHSCROLL = 0080h
ES_NOHIDESEL   = 0100h
ES_OEMCONVERT  = 0400h
ES_READONLY    = 0800h
ES_WANTRETURN  = 1000h
ES_NUMBER      = 2000h

; Static window messages

STM_SETICON  = 0170h
STM_GETICON  = 0171h
STM_SETIMAGE = 0172h
STM_GETIMAGE = 0173h

; Static window notifications

STN_CLICKED = 0
STN_DBLCLK  = 1
STN_ENABLE  = 2
STN_DISABLE = 3

; Static window styles

SS_LEFT 	  = 0000h
SS_CENTER	  = 0001h
SS_RIGHT	  = 0002h
SS_ICON 	  = 0003h
SS_BLACKRECT	  = 0004h
SS_GRAYRECT	  = 0005h
SS_WHITERECT	  = 0006h
SS_BLACKFRAME	  = 0007h
SS_GRAYFRAME	  = 0008h
SS_WHITEFRAME	  = 0009h
SS_USERITEM	  = 000Ah
SS_SIMPLE	  = 000Bh
SS_LEFTNOWORDWRAP = 000Ch
SS_BITMAP	  = 000Eh
SS_OWNERDRAW	  = 000Dh
SS_ENHMETAFILE	  = 000Fh
SS_ETCHEDHORZ	  = 0010h
SS_ETCHEDVERT	  = 0011h
SS_ETCHEDFRAME	  = 0012h
SS_TYPEMASK	  = 001Fh
SS_NOPREFIX	  = 0080h
SS_NOTIFY	  = 0100h
SS_CENTERIMAGE	  = 0200h
SS_RIGHTJUST	  = 0400h
SS_REALSIZEIMAGE  = 0800h
SS_SUNKEN	  = 1000h

; Scroll bar constants

SB_HORZ 	 = 0
SB_VERT 	 = 1
SB_CTL		 = 2
SB_BOTH 	 = 3

; Scroll bar messages

SBM_SETPOS	   = 00E0h
SBM_GETPOS	   = 00E1h
SBM_SETRANGE	   = 00E2h
SBM_SETRANGEREDRAW = 00E6h
SBM_GETRANGE	   = 00E3h
SBM_ENABLE_ARROWS  = 00E4h
SBM_SETSCROLLINFO  = 00E9h
SBM_GETSCROLLINFO  = 00EAh

; Scroll bar commands

SB_LINEUP	 = 0
SB_LINELEFT	 = 0
SB_LINEDOWN	 = 1
SB_LINERIGHT	 = 1
SB_PAGEUP	 = 2
SB_PAGELEFT	 = 2
SB_PAGEDOWN	 = 3
SB_PAGERIGHT	 = 3
SB_THUMBPOSITION = 4
SB_THUMBTRACK	 = 5
SB_TOP		 = 6
SB_LEFT 	 = 6
SB_BOTTOM	 = 7
SB_RIGHT	 = 7
SB_ENDSCROLL	 = 8

; Scroll bar styles

SBS_HORZ		    = 0000h
SBS_VERT		    = 0001h
SBS_TOPALIGN		    = 0002h
SBS_LEFTALIGN		    = 0002h
SBS_BOTTOMALIGN 	    = 0004h
SBS_RIGHTALIGN		    = 0004h
SBS_SIZEBOXTOPLEFTALIGN     = 0002h
SBS_SIZEBOXBOTTOMRIGHTALIGN = 0004h
SBS_SIZEBOX		    = 0008h
SBS_SIZEGRIP		    = 0010h

; Scroll bar info flags

SIF_RANGE	    = 0001h
SIF_PAGE	    = 0002h
SIF_POS 	    = 0004h
SIF_DISABLENOSCROLL = 0008h
SIF_TRACKPOS	    = 0010h
SIF_ALL 	    = SIF_RANGE or SIF_PAGE or SIF_POS or SIF_TRACKPOS

; Dialog styles

DS_ABSALIGN	 = 0001h
DS_SYSMODAL	 = 0002h
DS_3DLOOK	 = 0004h
DS_FIXEDSYS	 = 0008h
DS_NOFAILCREATE  = 0010h
DS_LOCALEDIT	 = 0020h
DS_SETFONT	 = 0040h
DS_MODALFRAME	 = 0080h
DS_NOIDLEMSG	 = 0100h
DS_SETFOREGROUND = 0200h
DS_CONTROL	 = 0400h
DS_CENTER	 = 0800h
DS_CENTERMOUSE	 = 1000h
DS_CONTEXTHELP	 = 2000h

; Dialog codes

DLGC_WANTARROWS      = 0001h
DLGC_WANTTAB	     = 0002h
DLGC_WANTALLKEYS     = 0004h
DLGC_WANTMESSAGE     = 0004h
DLGC_HASSETSEL	     = 0008h
DLGC_DEFPUSHBUTTON   = 0010h
DLGC_UNDEFPUSHBUTTON = 0020h
DLGC_RADIOBUTTON     = 0040h
DLGC_WANTCHARS	     = 0080h
DLGC_STATIC	     = 0100h
DLGC_BUTTON	     = 2000h

; Menu flags

MF_INSERT	   = 0000h
MF_CHANGE	   = 0080h
MF_APPEND	   = 0100h
MF_DELETE	   = 0200h
MF_REMOVE	   = 1000h
MF_BYCOMMAND	   = 0000h
MF_BYPOSITION	   = 0400h
MF_SEPARATOR	   = 0800h
MF_UNCHECKED	   = 0000h
MF_ENABLED	   = 0000h
MF_GRAYED	   = 0001h
MF_DISABLED	   = 0002h
MF_CHECKED	   = 0008h
MF_USECHECKBITMAPS = 0200h
MF_STRING	   = 0000h
MF_BITMAP	   = 0004h
MF_OWNERDRAW	   = 0100h
MF_POPUP	   = 0010h
MF_MENUBARBREAK    = 0020h
MF_MENUBREAK	   = 0040h
MF_UNHILITE	   = 0000h
MF_HILITE	   = 0080h
MF_DEFAULT	   = 1000h
MF_SYSMENU	   = 2000h
MF_HELP 	   = 4000h
MF_RIGHTJUSTIFY    = 4000h
MF_MOUSESELECT	   = 8000h
MF_END		   = 0080h
MFT_STRING	   = MF_STRING
MFT_BITMAP	   = MF_BITMAP
MFT_MENUBARBREAK   = MF_MENUBARBREAK
MFT_MENUBREAK	   = MF_MENUBREAK
MFT_OWNERDRAW	   = MF_OWNERDRAW
MFT_RADIOCHECK	   = 0200h
MFT_SEPARATOR	   = MF_SEPARATOR
MFT_RIGHTORDER	   = 2000h
MFT_RIGHTJUSTIFY   = MF_RIGHTJUSTIFY
MFS_GRAYED	   = 0003h
MFS_DISABLED	   = MFS_GRAYED
MFS_CHECKED	   = MF_CHECKED
MFS_HILITE	   = MF_HILITE
MFS_ENABLED	   = MF_ENABLED
MFS_UNCHECKED	   = MF_UNCHECKED
MFS_UNHILITE	   = MF_UNHILITE
MFS_DEFAULT	   = MF_DEFAULT
MFR_POPUP	   = 0001h
MFR_END 	   = MF_END

; System menu command values

SC_SIZE 	= 61440
SC_MOVE 	= 61456
SC_MINIMIZE	= 61472
SC_MAXIMIZE	= 61488
SC_NEXTWINDOW	= 61504
SC_PREVWINDOW	= 61520
SC_CLOSE	= 61536
SC_VSCROLL	= 61552
SC_HSCROLL	= 61568
SC_MOUSEMENU	= 61584
SC_KEYMENU	= 61696
SC_ARRANGE	= 61712
SC_RESTORE	= 61728
SC_TASKLIST	= 61744
SC_SCREENSAVE	= 61760
SC_HOTKEY	= 61776
SC_DEFAULT	= 61792
SC_MONITORPOWER = 61808
SC_CONTEXTHELP	= 61824
SC_SEPARATOR	= 61455

; Border types

BDR_RAISEDOUTER = 01h
BDR_SUNKENOUTER = 02h
BDR_RAISEDINNER = 04h
BDR_SUNKENINNER = 08h
BDR_OUTER	= 03h
BDR_INNER	= 0Ch
BDR_RAISED	= 05h
BDR_SUNKEN	= 0Ah
EDGE_RAISED	= BDR_RAISEDOUTER or BDR_RAISEDINNER
EDGE_SUNKEN	= BDR_SUNKENOUTER or BDR_SUNKENINNER
EDGE_ETCHED	= BDR_SUNKENOUTER or BDR_RAISEDINNER
EDGE_BUMP	= BDR_RAISEDOUTER or BDR_SUNKENINNER

; Border flags

BF_LEFT 		   = 0001h
BF_TOP			   = 0002h
BF_RIGHT		   = 0004h
BF_BOTTOM		   = 0008h
BF_TOPLEFT		   = BF_TOP or BF_LEFT
BF_TOPRIGHT		   = BF_TOP or BF_RIGHT
BF_BOTTOMLEFT		   = BF_BOTTOM or BF_LEFT
BF_BOTTOMRIGHT		   = BF_BOTTOM or BF_RIGHT
BF_RECT 		   = BF_LEFT or BF_TOP or BF_RIGHT or BF_BOTTOM
BF_DIAGONAL		   = 0010h
BF_DIAGONAL_ENDTOPRIGHT    = BF_DIAGONAL or BF_TOP or BF_RIGHT
BF_DIAGONAL_ENDTOPLEFT	   = BF_DIAGONAL or BF_TOP or BF_LEFT
BF_DIAGONAL_ENDBOTTOMLEFT  = BF_DIAGONAL or BF_BOTTOM or BF_LEFT
BF_DIAGONAL_ENDBOTTOMRIGHT = BF_DIAGONAL or BF_BOTTOM or BF_RIGHT
BF_MIDDLE		   = 0800h
BF_SOFT 		   = 1000h
BF_ADJUST		   = 2000h
BF_FLAT 		   = 4000h
BF_MONO 		   = 8000h

; Frame control types

DFC_CAPTION   = 1
DFC_MENU      = 2
DFC_SCROLL    = 3
DFC_BUTTON    = 4
DFC_POPUPMENU = 5

; Frame control states

DFCS_CAPTIONCLOSE	 = 0000h
DFCS_CAPTIONMIN 	 = 0001h
DFCS_CAPTIONMAX 	 = 0002h
DFCS_CAPTIONRESTORE	 = 0003h
DFCS_CAPTIONHELP	 = 0004h
DFCS_MENUARROW		 = 0000h
DFCS_MENUCHECK		 = 0001h
DFCS_MENUBULLET 	 = 0002h
DFCS_MENUARROWRIGHT	 = 0004h
DFCS_SCROLLUP		 = 0000h
DFCS_SCROLLDOWN 	 = 0001h
DFCS_SCROLLLEFT 	 = 0002h
DFCS_SCROLLRIGHT	 = 0003h
DFCS_SCROLLCOMBOBOX	 = 0005h
DFCS_SCROLLSIZEGRIP	 = 0008h
DFCS_SCROLLSIZEGRIPRIGHT = 0010h
DFCS_BUTTONCHECK	 = 0000h
DFCS_BUTTONRADIOIMAGE	 = 0001h
DFCS_BUTTONRADIOMASK	 = 0002h
DFCS_BUTTONRADIO	 = 0004h
DFCS_BUTTON3STATE	 = 0008h
DFCS_BUTTONPUSH 	 = 0010h
DFCS_INACTIVE		 = 0100h
DFCS_PUSHED		 = 0200h
DFCS_CHECKED		 = 0400h
DFCS_TRANSPARENT	 = 0800h
DFCS_HOT		 = 1000h
DFCS_ADJUSTRECT 	 = 2000h
DFCS_FLAT		 = 4000h
DFCS_MONO		 = 8000h

; DrawCaption flags

DC_ACTIVE   = 01h
DC_SMALLCAP = 02h
DC_ICON     = 04h
DC_TEXT     = 08h
DC_INBUTTON = 10h

; DrawIconEx options

DI_MASK        = 1
DI_IMAGE       = 2
DI_NORMAL      = 3
DI_COMPAT      = 4
DI_DEFAULTSIZE = 8

; DrawText parameters

DT_TOP		   = 00000h
DT_LEFT 	   = 00000h
DT_CENTER	   = 00001h
DT_RIGHT	   = 00002h
DT_VCENTER	   = 00004h
DT_BOTTOM	   = 00008h
DT_WORDBREAK	   = 00010h
DT_SINGLELINE	   = 00020h
DT_EXPANDTABS	   = 00040h
DT_TABSTOP	   = 00080h
DT_NOCLIP	   = 00100h
DT_EXTERNALLEADING = 00200h
DT_CALCRECT	   = 00400h
DT_NOPREFIX	   = 00800h
DT_INTERNAL	   = 01000h
DT_EDITCONTROL	   = 02000h
DT_PATH_ELLIPSIS   = 04000h
DT_END_ELLIPSIS    = 08000h
DT_MODIFYSTRING    = 10000h
DT_RTLREADING	   = 20000h
DT_WORD_ELLIPSIS   = 40000h

; GetDCEx flags

DCX_WINDOW	     = 000001h
DCX_CACHE	     = 000002h
DCX_NORESETATTRS     = 000004h
DCX_CLIPCHILDREN     = 000008h
DCX_CLIPSIBLINGS     = 000010h
DCX_PARENTCLIP	     = 000020h
DCX_EXCLUDERGN	     = 000040h
DCX_INTERSECTRGN     = 000080h
DCX_EXCLUDEUPDATE    = 000100h
DCX_INTERSECTUPDATE  = 000200h
DCX_LOCKWINDOWUPDATE = 000400h
DCX_VALIDATE	     = 200000h

; SetWindowsHook codes

WH_MSGFILTER	   = -1
WH_JOURNALRECORD   = 0
WH_JOURNALPLAYBACK = 1
WH_KEYBOARD	   = 2
WH_GETMESSAGE	   = 3
WH_CALLWNDPROC	   = 4
WH_CBT		   = 5
WH_SYSMSGFILTER    = 6
WH_MOUSE	   = 7
WH_HARDWARE	   = 8
WH_DEBUG	   = 9
WH_SHELL	   = 10
WH_FOREGROUNDIDLE  = 11
WH_CALLWNDPROCRET  = 12
WH_KEYBOARD_LL	   = 13
WH_MOUSE_LL	   = 14

; Hook codes

HC_ACTION      = 0
HC_GETNEXT     = 1
HC_SKIP        = 2
HC_NOREMOVE    = 3
HC_SYSMODALON  = 4
HC_SYSMODALOFF = 5

; CBT hook codes

HCBT_MOVESIZE	  = 0
HCBT_MINMAX	  = 1
HCBT_QS 	  = 2
HCBT_CREATEWND	  = 3
HCBT_DESTROYWND   = 4
HCBT_ACTIVATE	  = 5
HCBT_CLICKSKIPPED = 6
HCBT_KEYSKIPPED   = 7
HCBT_SYSCOMMAND   = 8
HCBT_SETFOCUS	  = 9

; ExitWindowsEx flags

EWX_LOGOFF   = 0
EWX_SHUTDOWN = 1
EWX_REBOOT   = 2
EWX_FORCE    = 4
EWX_POWEROFF = 8

; WinHelp commands

HELP_CONTEXT	  = 001h
HELP_QUIT	  = 002h
HELP_INDEX	  = 003h
HELP_CONTENTS	  = 003h
HELP_HELPONHELP   = 004h
HELP_SETINDEX	  = 005h
HELP_SETCONTENTS  = 005h
HELP_CONTEXTPOPUP = 008h
HELP_FORCEFILE	  = 009h
HELP_CONTEXTMENU  = 00Ah
HELP_FINDER	  = 00Bh
HELP_WM_HELP	  = 00Ch
HELP_SETPOPUP_POS = 00Dh
HELP_KEY	  = 101h
HELP_COMMAND	  = 102h
HELP_PARTIALKEY   = 105h
HELP_MULTIKEY	  = 201h
HELP_SETWINPOS	  = 203h

; keybd_event flags

KEYEVENTF_EXTENDEDKEY = 1h
KEYEVENTF_KEYUP       = 2h

; mouse_event flags

MOUSEEVENTF_MOVE       = 0001h
MOUSEEVENTF_LEFTDOWN   = 0002h
MOUSEEVENTF_LEFTUP     = 0004h
MOUSEEVENTF_RIGHTDOWN  = 0008h
MOUSEEVENTF_RIGHTUP    = 0010h
MOUSEEVENTF_MIDDLEDOWN = 0020h
MOUSEEVENTF_MIDDLEUP   = 0040h
MOUSEEVENTF_WHEEL      = 0800h
MOUSEEVENTF_ABSOLUTE   = 8000h

; TrackPopupMenu flags

TPM_LEFTBUTTON	    = 0000h
TPM_RIGHTBUTTON     = 0002h
TPM_LEFTALIGN	    = 0000h
TPM_CENTERALIGN     = 0004h
TPM_RIGHTALIGN	    = 0008h
TPM_TOPALIGN	    = 0000h
TPM_VCENTERALIGN    = 0010h
TPM_BOTTOMALIGN     = 0020h
TPM_HORIZONTAL	    = 0000h
TPM_VERTICAL	    = 0040h
TPM_NONOTIFY	    = 0080h
TPM_RETURNCMD	    = 0100h
TPM_RECURSE	    = 0001h
TPM_HORPOSANIMATION = 0400h
TPM_HORNEGANIMATION = 0800h
TPM_VERPOSANIMATION = 1000h
TPM_VERNEGANIMATION = 2000h
TPM_NOANIMATION     = 4000h
TPM_LAYOUTRTL	    = 8000h

; Menu item info mask values

MIIM_STATE	= 001h
MIIM_ID 	= 002h
MIIM_SUBMENU	= 004h
MIIM_CHECKMARKS = 008h
MIIM_TYPE	= 010h
MIIM_DATA	= 020h
MIIM_STRING	= 040h
MIIM_BITMAP	= 080h
MIIM_FTYPE	= 100h

; DRAWITEMSTRUCT control types

ODT_MENU     = 1
ODT_LISTBOX  = 2
ODT_COMBOBOX = 3
ODT_BUTTON   = 4
ODT_STATIC   = 5

; DRAWITEMSTRUCT actions

ODA_DRAWENTIRE = 1
ODA_SELECT     = 2
ODA_FOCUS      = 4

; DRAWITEMSTRUCT states

ODS_SELECTED	 = 0001h
ODS_GRAYED	 = 0002h
ODS_DISABLED	 = 0004h
ODS_CHECKED	 = 0008h
ODS_FOCUS	 = 0010h
ODS_DEFAULT	 = 0020h
ODS_COMBOBOXEDIT = 1000h
ODS_HOTLIGHT	 = 0040h
ODS_INACTIVE	 = 0080h

; WINDOWPLACEMENT flags

WPF_SETMINPOSITION     = 1
WPF_RESTORETOMAXIMIZED = 2

; Layered window attributes

LWA_COLORKEY = 1
LWA_ALPHA    = 2

; UpdateLayeredWindow flags

ULW_COLORKEY = 1
ULW_ALPHA    = 2
ULW_OPAQUE   = 4

; SystemParametersInfo parameters

SPI_GETACCESSTIMEOUT	  = 60
SPI_GETANIMATION	  = 72
SPI_GETBEEP		  = 1
SPI_GETBORDER		  = 5
SPI_GETDEFAULTINPUTLANG   = 89
SPI_GETDRAGFULLWINDOWS	  = 38
SPI_GETFASTTASKSWITCH	  = 35
SPI_GETFILTERKEYS	  = 50
SPI_GETFONTSMOOTHING	  = 74
SPI_GETGRIDGRANULARITY	  = 18
SPI_GETHIGHCONTRAST	  = 66
SPI_GETICONMETRICS	  = 45
SPI_GETICONTITLELOGFONT   = 31
SPI_GETICONTITLEWRAP	  = 25
SPI_GETKEYBOARDDELAY	  = 22
SPI_GETKEYBOARDPREF	  = 68
SPI_GETKEYBOARDSPEED	  = 10
SPI_GETLOWPOWERACTIVE	  = 83
SPI_GETLOWPOWERTIMEOUT	  = 79
SPI_GETMENUDROPALIGNMENT  = 27
SPI_GETMINIMIZEDMETRICS   = 43
SPI_GETMOUSE		  = 3
SPI_GETMOUSEKEYS	  = 54
SPI_GETMOUSETRAILS	  = 94
SPI_GETNONCLIENTMETRICS   = 41
SPI_GETPOWEROFFACTIVE	  = 84
SPI_GETPOWEROFFTIMEOUT	  = 80
SPI_GETSCREENREADER	  = 70
SPI_GETSCREENSAVEACTIVE   = 16
SPI_GETSCREENSAVETIMEOUT  = 14
SPI_GETSERIALKEYS	  = 62
SPI_GETSHOWSOUNDS	  = 56
SPI_GETSOUNDSENTRY	  = 64
SPI_GETSTICKYKEYS	  = 58
SPI_GETTOGGLEKEYS	  = 52
SPI_GETWINDOWSEXTENSION   = 92
SPI_GETWORKAREA 	  = 48
SPI_ICONHORIZONTALSPACING = 13
SPI_ICONVERTICALSPACING   = 24
SPI_LANGDRIVER		  = 12
SPI_SCREENSAVERRUNNING	  = 97
SPI_SETACCESSTIMEOUT	  = 61
SPI_SETANIMATION	  = 73
SPI_SETBEEP		  = 2
SPI_SETBORDER		  = 6
SPI_SETDEFAULTINPUTLANG   = 90
SPI_SETDESKPATTERN	  = 21
SPI_SETDESKWALLPAPER	  = 20
SPI_SETDOUBLECLICKTIME	  = 32
SPI_SETDOUBLECLKHEIGHT	  = 30
SPI_SETDOUBLECLKWIDTH	  = 29
SPI_SETDRAGFULLWINDOWS	  = 37
SPI_SETDRAGHEIGHT	  = 77
SPI_SETDRAGWIDTH	  = 76
SPI_SETFASTTASKSWITCH	  = 36
SPI_SETFILTERKEYS	  = 51
SPI_SETFONTSMOOTHING	  = 75
SPI_SETGRIDGRANULARITY	  = 19
SPI_SETHANDHELD 	  = 78
SPI_SETHIGHCONTRAST	  = 67
SPI_SETICONMETRICS	  = 46
SPI_SETICONTITLELOGFONT   = 34
SPI_SETICONTITLEWRAP	  = 26
SPI_SETKEYBOARDDELAY	  = 23
SPI_SETKEYBOARDPREF	  = 69
SPI_SETKEYBOARDSPEED	  = 11
SPI_SETLANGTOGGLE	  = 91
SPI_SETLOWPOWERACTIVE	  = 85
SPI_SETLOWPOWERTIMEOUT	  = 81
SPI_SETMENUDROPALIGNMENT  = 28
SPI_SETMINIMIZEDMETRICS   = 44
SPI_SETMOUSE		  = 4
SPI_SETMOUSEBUTTONSWAP	  = 33
SPI_SETMOUSEKEYS	  = 55
SPI_SETMOUSETRAILS	  = 93
SPI_SETNONCLIENTMETRICS   = 42
SPI_SETPENWINDOWS	  = 49
SPI_SETPOWEROFFACTIVE	  = 86
SPI_SETPOWEROFFTIMEOUT	  = 82
SPI_SETSCREENREADER	  = 71
SPI_SETSCREENSAVEACTIVE   = 17
SPI_SETSCREENSAVERRUNNING = 97
SPI_SETSCREENSAVETIMEOUT  = 15
SPI_SETSERIALKEYS	  = 63
SPI_SETSHOWSOUNDS	  = 57
SPI_SETSOUNDSENTRY	  = 65
SPI_SETSTICKYKEYS	  = 59
SPI_SETTOGGLEKEYS	  = 53
SPI_SETWORKAREA 	  = 47

; SystemParametersInfo flags

SPIF_UPDATEINIFILE	  = 1
SPIF_SENDWININICHANGE	  = 2

; Gesture Information Flags

GF_BEGIN   = 1
GF_INERTIA = 2
GF_END	   = 4

; Gesture IDs

GID_BEGIN	 = 1
GID_END 	 = 2
GID_ZOOM	 = 3
GID_PAN 	 = 4
GID_ROTATE	 = 5
GID_TWOFINGERTAP = 6
GID_PRESSANDTAP  = 7
GID_ROLLOVER	 = GID_PRESSANDTAP

; Zoom Gesture Confiration Flags

GC_ZOOM = 0x00000001

; Pan Gesture Configuration Flags

GC_PAN				       = 0x00000001
GC_PAN_WITH_SINGLE_FINGER_VERTICALLY   = 0x00000002
GC_PAN_WITH_SINGLE_FINGER_HORIZONTALLY = 0x00000004
GC_PAN_WITH_GUTTER		       = 0x00000008
GC_PAN_WITH_INERTIA		       = 0x00000010

; Rotate Gesture Configuration Flags

GC_ROTATE = 0x00000001

; Two finger tap configuration flags

GC_TWOFINGERTAP = 0x00000001

; Press and tap Configuration Flags

GC_PRESSANDTAP = 0x00000001
GC_ROLLOVER    = GC_PRESSANDTAP


macro api [name] { if used name
		    label name qword at name#A
		   end if }



; Maximum path length in characters

MAX_PATH = 260

; Access rights

DELETE_RIGHT		  = 00010000h
READ_CONTROL		  = 00020000h
WRITE_DAC		  = 00040000h
WRITE_OWNER		  = 00080000h
SYNCHRONIZE		  = 00100000h
STANDARD_RIGHTS_READ	  = READ_CONTROL
STANDARD_RIGHTS_WRITE	  = READ_CONTROL
STANDARD_RIGHTS_EXECUTE   = READ_CONTROL
STANDARD_RIGHTS_REQUIRED  = 000F0000h
STANDARD_RIGHTS_ALL	  = 001F0000h
SPECIFIC_RIGHTS_ALL	  = 0000FFFFh
ACCESS_SYSTEM_SECURITY	  = 01000000h
MAXIMUM_ALLOWED 	  = 02000000h
GENERIC_READ		  = 80000000h
GENERIC_WRITE		  = 40000000h
GENERIC_EXECUTE 	  = 20000000h
GENERIC_ALL		  = 10000000h
PROCESS_TERMINATE	  = 00000001h
PROCESS_CREATE_THREAD	  = 00000002h
PROCESS_VM_OPERATION	  = 00000008h
PROCESS_VM_READ 	  = 00000010h
PROCESS_VM_WRITE	  = 00000020h
PROCESS_DUP_HANDLE	  = 00000040h
PROCESS_CREATE_PROCESS	  = 00000080h
PROCESS_SET_QUOTA	  = 00000100h
PROCESS_SET_INFORMATION   = 00000200h
PROCESS_QUERY_INFORMATION = 00000400h
PROCESS_ALL_ACCESS	  = STANDARD_RIGHTS_REQUIRED or SYNCHRONIZE or 0FFFh
FILE_SHARE_READ 	  = 00000001h
FILE_SHARE_WRITE	  = 00000002h
FILE_SHARE_DELETE	  = 00000004h

; CreateFile actions

CREATE_NEW	  = 1
CREATE_ALWAYS	  = 2
OPEN_EXISTING	  = 3
OPEN_ALWAYS	  = 4
TRUNCATE_EXISTING = 5

; OpenFile modes

OF_READ 	    = 0000h
OF_WRITE	    = 0001h
OF_READWRITE	    = 0002h
OF_SHARE_COMPAT     = 0000h
OF_SHARE_EXCLUSIVE  = 0010h
OF_SHARE_DENY_WRITE = 0020h
OF_SHARE_DENY_READ  = 0030h
OF_SHARE_DENY_NONE  = 0040h
OF_PARSE	    = 0100h
OF_DELETE	    = 0200h
OF_VERIFY	    = 0400h
OF_CANCEL	    = 0800h
OF_CREATE	    = 1000h
OF_PROMPT	    = 2000h
OF_EXIST	    = 4000h
OF_REOPEN	    = 8000h

; SetFilePointer methods

FILE_BEGIN   = 0
FILE_CURRENT = 1
FILE_END     = 2

; File attributes

FILE_ATTRIBUTE_READONLY   = 001h
FILE_ATTRIBUTE_HIDDEN	  = 002h
FILE_ATTRIBUTE_SYSTEM	  = 004h
FILE_ATTRIBUTE_DIRECTORY  = 010h
FILE_ATTRIBUTE_ARCHIVE	  = 020h
FILE_ATTRIBUTE_NORMAL	  = 080h
FILE_ATTRIBUTE_TEMPORARY  = 100h
FILE_ATTRIBUTE_COMPRESSED = 800h

; File flags

FILE_FLAG_WRITE_THROUGH    = 80000000h
FILE_FLAG_OVERLAPPED	   = 40000000h
FILE_FLAG_NO_BUFFERING	   = 20000000h
FILE_FLAG_RANDOM_ACCESS    = 10000000h
FILE_FLAG_SEQUENTIAL_SCAN  = 08000000h
FILE_FLAG_DELETE_ON_CLOSE  = 04000000h
FILE_FLAG_BACKUP_SEMANTICS = 02000000h
FILE_FLAG_POSIX_SEMANTICS  = 01000000h

; Notify filters

FILE_NOTIFY_CHANGE_FILE_NAME  = 001h
FILE_NOTIFY_CHANGE_DIR_NAME   = 002h
FILE_NOTIFY_CHANGE_ATTRIBUTES = 004h
FILE_NOTIFY_CHANGE_SIZE       = 008h
FILE_NOTIFY_CHANGE_LAST_WRITE = 010h
FILE_NOTIFY_CHANGE_SECURITY   = 100h

; File types

FILE_TYPE_UNKNOWN = 0
FILE_TYPE_DISK	  = 1
FILE_TYPE_CHAR	  = 2
FILE_TYPE_PIPE	  = 3
FILE_TYPE_REMOTE  = 8000h

; LockFileEx flags

LOCKFILE_FAIL_IMMEDIATELY = 1
LOCKFILE_EXCLUSIVE_LOCK   = 2

; MoveFileEx flags

MOVEFILE_REPLACE_EXISTING   = 1
MOVEFILE_COPY_ALLOWED	    = 2
MOVEFILE_DELAY_UNTIL_REBOOT = 4
MOVEFILE_WRITE_THROUGH	    = 8

; FindFirstFileEx flags

FIND_FIRST_EX_CASE_SENSITIVE = 1

; Device handles

INVALID_HANDLE_VALUE = -1
STD_INPUT_HANDLE     = -10
STD_OUTPUT_HANDLE    = -11
STD_ERROR_HANDLE     = -12

; DuplicateHandle options

DUPLICATE_CLOSE_SOURCE = 1
DUPLICATE_SAME_ACCESS  = 2

; File mapping acccess rights

SECTION_QUERY	    = 01h
SECTION_MAP_WRITE   = 02h
SECTION_MAP_READ    = 04h
SECTION_MAP_EXECUTE = 08h
SECTION_EXTEND_SIZE = 10h
SECTION_ALL_ACCESS  = STANDARD_RIGHTS_REQUIRED or SECTION_QUERY or SECTION_MAP_WRITE or SECTION_MAP_READ or SECTION_MAP_EXECUTE or SECTION_EXTEND_SIZE
FILE_MAP_COPY	    = SECTION_QUERY
FILE_MAP_WRITE	    = SECTION_MAP_WRITE
FILE_MAP_READ	    = SECTION_MAP_READ
FILE_MAP_ALL_ACCESS = SECTION_ALL_ACCESS

; File system flags

FILE_CASE_SENSITIVE_SEARCH = 0001h
FILE_CASE_PRESERVED_NAMES  = 0002h
FILE_UNICODE_ON_DISK	   = 0004h
FILE_PERSISTENT_ACLS	   = 0008h
FILE_FILE_COMPRESSION	   = 0010h
FILE_VOLUME_IS_COMPRESSED  = 8000h
FS_CASE_IS_PRESERVED	   = FILE_CASE_PRESERVED_NAMES
FS_CASE_SENSITIVE	   = FILE_CASE_SENSITIVE_SEARCH
FS_UNICODE_STORED_ON_DISK  = FILE_UNICODE_ON_DISK
FS_PERSISTENT_ACLS	   = FILE_PERSISTENT_ACLS

; Drive types

DRIVE_UNKNOWN	  = 0
DRIVE_NO_ROOT_DIR = 1
DRIVE_REMOVABLE   = 2
DRIVE_FIXED	  = 3
DRIVE_REMOTE	  = 4
DRIVE_CDROM	  = 5
DRIVE_RAMDISK	  = 6

; Pipe modes

PIPE_ACCESS_INBOUND	 = 1
PIPE_ACCESS_OUTBOUND	 = 2
PIPE_ACCESS_DUPLEX	 = 3
PIPE_CLIENT_END 	 = 0
PIPE_SERVER_END 	 = 1
PIPE_WAIT		 = 0
PIPE_NOWAIT		 = 1
PIPE_READMODE_BYTE	 = 0
PIPE_READMODE_MESSAGE	 = 2
PIPE_TYPE_BYTE		 = 0
PIPE_TYPE_MESSAGE	 = 4
PIPE_UNLIMITED_INSTANCES = 255

; Global memory flags

GMEM_FIXED	       = 0000h
GMEM_MOVEABLE	       = 0002h
GMEM_NOCOMPACT	       = 0010h
GMEM_NODISCARD	       = 0020h
GMEM_ZEROINIT	       = 0040h
GMEM_MODIFY	       = 0080h
GMEM_DISCARDABLE       = 0100h
GMEM_NOT_BANKED        = 1000h
GMEM_SHARE	       = 2000h
GMEM_DDESHARE	       = 2000h
GMEM_NOTIFY	       = 4000h
GMEM_LOWER	       = GMEM_NOT_BANKED
GMEM_VALID_FLAGS       = 7F72h
GMEM_INVALID_HANDLE    = 8000h
GMEM_DISCARDED	       = 4000h
GMEM_LOCKCOUNT	       = 0FFh
GHND		       = GMEM_MOVEABLE + GMEM_ZEROINIT
GPTR		       = GMEM_FIXED + GMEM_ZEROINIT

; Local memory flags

LMEM_FIXED	       = 0000h
LMEM_MOVEABLE	       = 0002h
LMEM_NOCOMPACT	       = 0010h
LMEM_NODISCARD	       = 0020h
LMEM_ZEROINIT	       = 0040h
LMEM_MODIFY	       = 0080h
LMEM_DISCARDABLE       = 0F00h
LMEM_VALID_FLAGS       = 0F72h
LMEM_INVALID_HANDLE    = 8000h
LHND		       = LMEM_MOVEABLE + LMEM_ZEROINIT
LPTR		       = LMEM_FIXED + LMEM_ZEROINIT
LMEM_DISCARDED	       = 4000h
LMEM_LOCKCOUNT	       = 00FFh

; Page access flags

PAGE_NOACCESS	       = 001h
PAGE_READONLY	       = 002h
PAGE_READWRITE	       = 004h
PAGE_WRITECOPY	       = 008h
PAGE_EXECUTE	       = 010h
PAGE_EXECUTE_READ      = 020h
PAGE_EXECUTE_READWRITE = 040h
PAGE_EXECUTE_WRITECOPY = 080h
PAGE_GUARD	       = 100h
PAGE_NOCACHE	       = 200h

; Memory allocation flags

MEM_COMMIT	       = 001000h
MEM_RESERVE	       = 002000h
MEM_DECOMMIT	       = 004000h
MEM_RELEASE	       = 008000h
MEM_FREE	       = 010000h
MEM_PRIVATE	       = 020000h
MEM_MAPPED	       = 040000h
MEM_RESET	       = 080000h
MEM_TOP_DOWN	       = 100000h

; Heap allocation flags

HEAP_NO_SERIALIZE	 = 1
HEAP_GENERATE_EXCEPTIONS = 4
HEAP_ZERO_MEMORY	 = 8

; Platform identifiers

VER_PLATFORM_WIN32s	   = 0
VER_PLATFORM_WIN32_WINDOWS = 1
VER_PLATFORM_WIN32_NT	   = 2

; GetBinaryType return values

SCS_32BIT_BINARY = 0
SCS_DOS_BINARY	 = 1
SCS_WOW_BINARY	 = 2
SCS_PIF_BINARY	 = 3
SCS_POSIX_BINARY = 4
SCS_OS216_BINARY = 5

; CreateProcess flags

DEBUG_PROCESS		 = 001h
DEBUG_ONLY_THIS_PROCESS  = 002h
CREATE_SUSPENDED	 = 004h
DETACHED_PROCESS	 = 008h
CREATE_NEW_CONSOLE	 = 010h
NORMAL_PRIORITY_CLASS	 = 020h
IDLE_PRIORITY_CLASS	 = 040h
HIGH_PRIORITY_CLASS	 = 080h
REALTIME_PRIORITY_CLASS  = 100h
CREATE_NEW_PROCESS_GROUP = 200h
CREATE_SEPARATE_WOW_VDM  = 800h

; Thread priority values

THREAD_BASE_PRIORITY_MIN      = -2
THREAD_BASE_PRIORITY_MAX      = 2
THREAD_BASE_PRIORITY_LOWRT    = 15
THREAD_BASE_PRIORITY_IDLE     = -15
THREAD_PRIORITY_LOWEST	      = THREAD_BASE_PRIORITY_MIN
THREAD_PRIORITY_BELOW_NORMAL  = THREAD_PRIORITY_LOWEST + 1
THREAD_PRIORITY_NORMAL	      = 0
THREAD_PRIORITY_HIGHEST       = THREAD_BASE_PRIORITY_MAX
THREAD_PRIORITY_ABOVE_NORMAL  = THREAD_PRIORITY_HIGHEST - 1
THREAD_PRIORITY_ERROR_RETURN  = 7FFFFFFFh
THREAD_PRIORITY_TIME_CRITICAL = THREAD_BASE_PRIORITY_LOWRT
THREAD_PRIORITY_IDLE	      = THREAD_BASE_PRIORITY_IDLE

; Startup flags

STARTF_USESHOWWINDOW	= 001h
STARTF_USESIZE		= 002h
STARTF_USEPOSITION	= 004h
STARTF_USECOUNTCHARS	= 008h
STARTF_USEFILLATTRIBUTE = 010h
STARTF_RUNFULLSCREEN	= 020h
STARTF_FORCEONFEEDBACK	= 040h
STARTF_FORCEOFFFEEDBACK = 080h
STARTF_USESTDHANDLES	= 100h

; Shutdown flags

SHUTDOWN_NORETRY = 1h

; LoadLibraryEx flags

DONT_RESOLVE_DLL_REFERENCES   = 1
LOAD_LIBRARY_AS_DATAFILE      = 2
LOAD_WITH_ALTERED_SEARCH_PATH = 8

; DLL entry-point calls

DLL_PROCESS_DETACH = 0
DLL_PROCESS_ATTACH = 1
DLL_THREAD_ATTACH  = 2
DLL_THREAD_DETACH  = 3

; Status codes

STATUS_WAIT_0			= 000000000h
STATUS_ABANDONED_WAIT_0 	= 000000080h
STATUS_USER_APC 		= 0000000C0h
STATUS_TIMEOUT			= 000000102h
STATUS_PENDING			= 000000103h
STATUS_DATATYPE_MISALIGNMENT	= 080000002h
STATUS_BREAKPOINT		= 080000003h
STATUS_SINGLE_STEP		= 080000004h
STATUS_ACCESS_VIOLATION 	= 0C0000005h
STATUS_IN_PAGE_ERROR		= 0C0000006h
STATUS_NO_MEMORY		= 0C0000017h
STATUS_ILLEGAL_INSTRUCTION	= 0C000001Dh
STATUS_NONCONTINUABLE_EXCEPTION = 0C0000025h
STATUS_INVALID_DISPOSITION	= 0C0000026h
STATUS_ARRAY_BOUNDS_EXCEEDED	= 0C000008Ch
STATUS_FLOAT_DENORMAL_OPERAND	= 0C000008Dh
STATUS_FLOAT_DIVIDE_BY_ZERO	= 0C000008Eh
STATUS_FLOAT_INEXACT_RESULT	= 0C000008Fh
STATUS_FLOAT_INVALID_OPERATION	= 0C0000090h
STATUS_FLOAT_OVERFLOW		= 0C0000091h
STATUS_FLOAT_STACK_CHECK	= 0C0000092h
STATUS_FLOAT_UNDERFLOW		= 0C0000093h
STATUS_INTEGER_DIVIDE_BY_ZERO	= 0C0000094h
STATUS_INTEGER_OVERFLOW 	= 0C0000095h
STATUS_PRIVILEGED_INSTRUCTION	= 0C0000096h
STATUS_STACK_OVERFLOW		= 0C00000FDh
STATUS_CONTROL_C_EXIT		= 0C000013Ah
WAIT_FAILED			= -1
WAIT_OBJECT_0			= STATUS_WAIT_0
WAIT_ABANDONED			= STATUS_ABANDONED_WAIT_0
WAIT_ABANDONED_0		= STATUS_ABANDONED_WAIT_0
WAIT_TIMEOUT			= STATUS_TIMEOUT
WAIT_IO_COMPLETION		= STATUS_USER_APC
STILL_ACTIVE			= STATUS_PENDING

; Exception codes

EXCEPTION_CONTINUABLE		= 0
EXCEPTION_NONCONTINUABLE	= 1
EXCEPTION_ACCESS_VIOLATION	= STATUS_ACCESS_VIOLATION
EXCEPTION_DATATYPE_MISALIGNMENT = STATUS_DATATYPE_MISALIGNMENT
EXCEPTION_BREAKPOINT		= STATUS_BREAKPOINT
EXCEPTION_SINGLE_STEP		= STATUS_SINGLE_STEP
EXCEPTION_ARRAY_BOUNDS_EXCEEDED = STATUS_ARRAY_BOUNDS_EXCEEDED
EXCEPTION_FLT_DENORMAL_OPERAND	= STATUS_FLOAT_DENORMAL_OPERAND
EXCEPTION_FLT_DIVIDE_BY_ZERO	= STATUS_FLOAT_DIVIDE_BY_ZERO
EXCEPTION_FLT_INEXACT_RESULT	= STATUS_FLOAT_INEXACT_RESULT
EXCEPTION_FLT_INVALID_OPERATION = STATUS_FLOAT_INVALID_OPERATION
EXCEPTION_FLT_OVERFLOW		= STATUS_FLOAT_OVERFLOW
EXCEPTION_FLT_STACK_CHECK	= STATUS_FLOAT_STACK_CHECK
EXCEPTION_FLT_UNDERFLOW 	= STATUS_FLOAT_UNDERFLOW
EXCEPTION_INT_DIVIDE_BY_ZERO	= STATUS_INTEGER_DIVIDE_BY_ZERO
EXCEPTION_INT_OVERFLOW		= STATUS_INTEGER_OVERFLOW
EXCEPTION_ILLEGAL_INSTRUCTION	= STATUS_ILLEGAL_INSTRUCTION
EXCEPTION_PRIV_INSTRUCTION	= STATUS_PRIVILEGED_INSTRUCTION
EXCEPTION_IN_PAGE_ERROR 	= STATUS_IN_PAGE_ERROR





; MessageBox type flags

MB_OK			= 000000h
MB_OKCANCEL		= 000001h
MB_ABORTRETRYIGNORE	= 000002h
MB_YESNOCANCEL		= 000003h
MB_YESNO		= 000004h
MB_RETRYCANCEL		= 000005h
MB_ICONHAND		= 000010h
MB_ICONQUESTION 	= 000020h
MB_ICONEXCLAMATION	= 000030h
MB_ICONASTERISK 	= 000040h
MB_USERICON		= 000080h
MB_ICONWARNING		= MB_ICONEXCLAMATION
MB_ICONERROR		= MB_ICONHAND
MB_ICONINFORMATION	= MB_ICONASTERISK
MB_ICONSTOP		= MB_ICONHAND
MB_DEFBUTTON1		= 000000h
MB_DEFBUTTON2		= 000100h
MB_DEFBUTTON3		= 000200h
MB_DEFBUTTON4		= 000300h
MB_APPLMODAL		= 000000h
MB_SYSTEMMODAL		= 001000h
MB_TASKMODAL		= 002000h
MB_HELP 		= 004000h
MB_NOFOCUS		= 008000h
MB_SETFOREGROUND	= 010000h
MB_DEFAULT_DESKTOP_ONLY = 020000h
MB_TOPMOST		= 040000h
MB_RIGHT		= 080000h
MB_RTLREADING		= 100000h
MB_SERVICE_NOTIFICATION = 200000h
