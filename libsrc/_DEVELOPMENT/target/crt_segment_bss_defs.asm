
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; crt segment bss defs ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; errno
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   PUBLIC _errno

   _errno:                        defs 2

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; string
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   PUBLIC __strtok_ptr

   __strtok_ptr:                  defs 2

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; alloc
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; balloc's queue table

   IF __crt_cfg_qtbl_size > 0

      __qtbl_address:             defs __crt_cfg_qtbl_size * 2

   ENDIF

   ; malloc's heap

   IF __crt_cfg_heap_size > 14

      __heap_address:             defs __crt_cfg_heap_size

   ENDIF

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; stdlib
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   PUBLIC __exit_stack, __exit_stack_size

   __exit_stack:

   IF __exit_stack_size > 0

      defs 1
      defs __exit_stack_size * 2

   ENDIF

   PUBLIC __quickexit_stack, __quickexit_stack_size

   __quickexit_stack:

   IF __quickexit_stack_size > 0

      defs 1
      defs __quickexit_stack_size * 2
      
   ENDIF

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; stdio
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   IF (__crt_cfg_fopen_max < 128) & (__crt_cfg_fopen_max > 3)

      __file_block:               defs (__CLIB_OPT_STDIO_FILE_EXTRA + 15) * (__crt_cfg_fopen_max - 3)

   ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
