
// automatically generated by m4 from headers in proto subdir


#ifndef __DISKIO_H__
#define __DISKIO_H__

#include <arch.h>
#include <stdint.h>

/*
 * Disk Status Bits DSTATUS (uint8_t)
 *
 */

#define STA_NOINIT		0x01	/* Drive not initialised */
#define STA_NODISK		0x02	/* No medium in the drive */
#define STA_PROTECT		0x04	/* Write protected */

/*
 * Command codes for disk_ioctrl function
 *
 */

/* Generic command (Used by FatFs) */
#define CTRL_SYNC			0	/* Complete pending write process (needed at _FS_READONLY == 0) */
#define GET_SECTOR_COUNT	1	/* Get media size (needed at _USE_MKFS == 1) */
#define GET_SECTOR_SIZE		2	/* Get sector size (needed at _MAX_SS != _MIN_SS) */
#define GET_BLOCK_SIZE		3	/* Get erase block size (needed at _USE_MKFS == 1) */

/* Generic command (not used by FatFs) */
#define CTRL_POWER			5	/* Get/Set power status */
#define CTRL_LOCK			6	/* Lock/Unlock media removal */
#define CTRL_EJECT			7	/* Eject media */
#define CTRL_FORMAT			8	/* Create physical format on the media */

/* MMC/SDC specific ioctl command */
#define MMC_GET_TYPE		10	/* Get card type */
#define MMC_GET_CSD			11	/* Get CSD */
#define MMC_GET_CID			12	/* Get CID */
#define MMC_GET_OCR			13	/* Get OCR */
#define MMC_GET_SDSTAT		14	/* Get SD status */
#define ISDIO_READ			55	/* Read data form SD iSDIO register */
#define ISDIO_WRITE			56	/* Write data to SD iSDIO register */
#define ISDIO_MRITE			57	/* Masked write data to SD iSDIO register */

/* ATA/CF specific ioctl command */
#define ATA_GET_REV			20	/* Get F/W revision */
#define ATA_GET_MODEL		21	/* Get model name */
#define ATA_GET_SN			22	/* Get serial number */

/* NAND specific ioctl command */
#define NAND_FORMAT			30	/* Create physical format */

/* MMC card type flags (MMC_GET_TYPE) */
#define CT_MMC				0x01		/* MMC ver 3 */
#define CT_SD1				0x02		/* SD ver 1 */
#define CT_SD2				0x04		/* SD ver 2 */
#define CT_SDC				(CT_SD1|CT_SD2)	/* SD */
#define CT_BLOCK			0x08		/* Block addressing */



/* Status of Disk Functions */
typedef BYTE DSTATUS;

/* Results of Disk Functions */
typedef enum {
    RES_OK = 0,	    /* 0: Successful */
    RES_ERROR = 1,  /* 1: R/W Error */
    RES_WRPRT = 2,  /* 2: Write Protected */
    RES_NOTRDY = 3, /* 3: Not Ready */
    RES_PARERR = 4  /* 4: Invalid Parameter */
} DRESULT;

//
// IDE DISK COMMANDS (FOUND IN @FEILIPU Z88DK-LIBS)
//

extern DSTATUS disk_initialize(BYTE pdrv);


extern DSTATUS disk_status(BYTE pdrv);


extern DRESULT disk_read(BYTE pdrv,BYTE* buff,DWORD sector,UINT count);


extern DRESULT disk_write(BYTE pdrv,const BYTE* buff,DWORD sector,UINT count);


extern DRESULT disk_ioctl(BYTE pdrv,BYTE cmd,void* buff);



//
// CSIO SD COMMANDS
//

extern void sd_clock(uint8_t);


extern void sd_cs_lower(uint8_t);


extern void sd_cs_raise(void);


extern void sd_write_byte(uint8_t);


extern uint8_t sd_read_byte(void);


extern void sd_write_block(const uint8_t *from);


extern void sd_read_block(uint8_t *to);



#endif