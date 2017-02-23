
dnl############################################################
dnl##         ZX_CRT_37.M4 - IF2 CARTRIDGE TARGET            ##
dnl############################################################
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                zx spectrum if2 cartridge                  ;;
;;      generated by target/zx/startup/zx_crt_37.m4          ;;
;;                                                           ;;
;;   16k ROM in 0-16k area, ram placement per pragmas        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CRT AND CLIB CONFIGURATION ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include "../crt_defaults.inc"
include "crt_config.inc"
include "../crt_rules.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SET UP MEMORY MODEL ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include "crt_memory_map.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GLOBAL SYMBOLS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include "config_zx_public.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; INSTANTIATE DRIVERS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl
dnl############################################################
dnl## LIST OF AVAILABLE DRIVERS WITH STATIC INSTANTIATORS #####
dnl############################################################
dnl
dnl## input terminals
dnl
dnl#include(`driver/terminal/zx_01_input_kbd_inkey.m4')dnl
dnl#include(`driver/terminal/zx_01_input_kbd_lastk.m4')dnl
dnl
dnl## output terminals
dnl
dnl#include(`driver/terminal/zx_01_output_char_32.m4')dnl
dnl#include(`driver/terminal/zx_01_output_char_32_tty_z88dk.m4')dnl
dnl#include(`driver/terminal/zx_01_output_char_64.m4')dnl
dnl#include(`driver/terminal/zx_01_output_char_64_tty_z88dk.m4')dnl
dnl#include(`driver/terminal/zx_01_output_fzx.m4')dnl
dnl#include(`driver/terminal/zx_01_output_fzx_tty_z88dk.m4')dnl
dnl
dnl## file dup
dnl
dnl#include(`../m4_file_dup.m4')dnl
dnl
dnl## empty fd slot
dnl
dnl#include(`../m4_file_absent.m4')dnl
dnl
dnl############################################################
dnl## INSTANTIATE DRIVERS #####################################
dnl############################################################

ifndef CRT_FONT

   PUBLIC CRT_FONT
   EXTERN _font_4x8_default
   defc CRT_FONT = _font_4x8_default

endif

include(`../clib_instantiate_begin.m4')

include(`driver/terminal/zx_01_input_kbd_inkey.m4')dnl
m4_zx_01_input_kbd_inkey(_stdin, __i_fcntl_fdstruct_1, 0x03b0, 64, 1, 500, 15)dnl

include(`driver/terminal/zx_01_output_char_64_tty_z88dk.m4')dnl
m4_zx_01_output_char_64_tty_z88dk(_stdout, 0x2370, 0, 0, 0, 64, 0, 24, 0, CRT_FONT, 56, 0, 56)dnl

include(`../m4_file_dup.m4')dnl
m4_file_dup(_stderr, 0x80, __i_fcntl_fdstruct_1)dnl

include(`../clib_instantiate_end.m4')

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; STARTUP ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SECTION CODE

PUBLIC __Start, __Exit

EXTERN _main

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; USER PREAMBLE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF __crt_include_preamble

   include "crt_preamble.asm"
   SECTION CODE

ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PAGE ZERO ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF (ASMPC = 0) && (__crt_org_code = 0)

   include "../crt_page_zero.inc"

ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CRT INIT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__Start:

   include "../crt_start_di.inc"

   IF __crt_org_vector_table != 0
   
      EXTERN __code_vector_head
      
      ld a,__code_vector_head/256
      ld i,a
      im 2
      
   ENDIF
	
   include "../crt_start_eidi.inc"
   include "../crt_save_sp.inc"

__Restart:

   include "../crt_init_sp.inc"

   ; command line
   
   IF (__crt_enable_commandline = 1) || (__crt_enable_commandline >= 3)
   
      include "../crt_cmdline_empty.inc"
   
   ENDIF

__Restart_2:

   IF __crt_enable_commandline >= 1

      IF __SDCC | __SDCC_IX | __SDCC_IY
      
         push hl               ; argv
         push bc               ; argc
      
      ELSE
      
         push bc               ; argc
         push hl               ; argv
      
      ENDIF
      
   ENDIF
   
   ; initialize data section

   include "../clib_init_data.inc"

   ; initialize bss section

   include "../clib_init_bss.inc"

   ; enforce code section name
   
   include "../crt_enforce_code_section_name.inc"

SECTION code_crt_init          ; user and library initialization
SECTION code_crt_main

   include "../crt_start_ei.inc"

   ; call user program
   
   call _main                  ; hl = return status

   ; run exit stack

   IF __clib_exit_stack_size > 0
   
      EXTERN asm_exit
      jp asm_exit              ; exit function jumps to __Exit
   
   ENDIF

__Exit:

   IF !((__crt_on_exit & 0x10000) && (__crt_on_exit & 0x8))
   
      ; not restarting
      
      push hl                  ; save return status
   
   ENDIF
   
SECTION code_crt_exit          ; user and library cleanup
SECTION code_crt_return

   ; close files
   
   include "../clib_close.inc"

   ; terminate
      
   include "../crt_exit_eidi.inc"
   include "../crt_restore_sp.inc"
   include "../crt_program_exit.inc"   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RUNTIME VARS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF (__crt_on_exit & 0x10000) && ((__crt_on_exit & 0x6) || ((__crt_on_exit & 0x8) && (__register_sp = -1)))

   SECTION BSS_UNINITIALIZED
   __sp_or_ret:  defw 0

ENDIF

include "../clib_variables.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CLIB STUBS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include "../clib_stubs.inc"
