//-----------------------------------------------------------------------------
// zobjcopy - manipulate z80asm object files
// Copyright (C) Paulo Custodio, 2011-2018
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#pragma once

#include "utarray.h"
#include "utstring.h"
#include <stdbool.h>
#include <stdio.h>

#define MIN_VERSION		1
#define MAX_VERSION		11
#define CUR_VERSION		MAX_VERSION
#define SIGNATURE_SIZE	8
#define SIGNATURE_OBJ	"Z80RMF"
#define SIGNATURE_LIB	"Z80LMF"
#define SIGNATURE_VERS	"%02d"
#define ALIGN_FILLER	0xFF

struct section_s;

//-----------------------------------------------------------------------------
typedef enum file_type 
{ 
	is_none, 
	is_library, 
	is_object 
} file_type_e;

//-----------------------------------------------------------------------------
// a defined symbol
//-----------------------------------------------------------------------------
typedef struct symbol_s
{
	UT_string	*name;
	char		 scope;
	char		 type;
	int			 value;

	struct section_s *section;		// weak

	UT_string	*filename;
	int			 line_nr;

	struct symbol_s *next, *prev;
} symbol_t;

extern symbol_t *symbol_new();
extern void symbol_free(symbol_t *self);

//-----------------------------------------------------------------------------
// an expression
//-----------------------------------------------------------------------------
typedef struct expr_s
{
	UT_string	*text;
	char		 type;
	int			 asmpc;
	int			 patch_ptr;

	struct section_s *section;		// weak

	UT_string	*target_name;

	UT_string	*filename;
	int			 line_nr;

	struct expr_s *next, *prev;
} expr_t;

extern expr_t *expr_new();
extern void expr_free(expr_t *self);

//-----------------------------------------------------------------------------
// one section
//-----------------------------------------------------------------------------
typedef struct section_s
{
	UT_string	*name;
	UT_array	*data;
	int			 org;
	int			 align;

	symbol_t	*symbols;
	expr_t		*exprs;

	struct section_s *next, *prev;

} section_t;

extern section_t *section_new();
extern void section_free(section_t *self);

//-----------------------------------------------------------------------------
// one object file
//-----------------------------------------------------------------------------
typedef struct objfile_s
{
	UT_string	*filename;
	UT_string	*signature;
	UT_string	*modname;
	int			 version;
	int			 global_org;
	UT_array	*externs;
	section_t	*sections;

	struct objfile_s *next, *prev;
} objfile_t;

extern objfile_t *objfile_new();
extern void objfile_free(objfile_t *obj);
extern void objfile_read(objfile_t *obj, FILE *fp);
extern void objfile_write(objfile_t *obj, FILE *fp);

//-----------------------------------------------------------------------------
// one file - either object or library
//-----------------------------------------------------------------------------
typedef struct file_s
{
	UT_string	*filename;
	UT_string	*signature;
	file_type_e type;
	int			 version;

	objfile_t	*objs;					// either one or multiple object files

} file_t;

extern file_t *file_new();
extern void file_free(file_t *file);
extern void file_read(file_t *file, const char *filename);
extern void file_write(file_t *file, const char *filename);
extern void file_rename_sections(file_t *file, const char *old_regexp, const char *new_name);
extern void file_add_symbol_prefix(file_t *file, const char *regexp, const char *prefix);
