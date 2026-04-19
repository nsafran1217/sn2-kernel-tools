# 
#/**************************************************************************
# *                                                                        *
# *               Copyright (C) 1989-1999 Silicon Graphics, Inc.           *
# *                                                                        *
# *  These coded instructions, statements, and computer programs  contain  *
# *  unpublished  proprietary  information of Silicon Graphics, Inc., and  *
# *  are protected by Federal copyright law.  They  may  not be disclosed  *
# *  to  third  parties  or copied or duplicated in any form, in whole or  *
# *  in part, without the prior written consent of Silicon Graphics, Inc.  *
# *                                                                        *
# **************************************************************************/
# 
# @(#)$Id: pic_01_mmrs.pm,v 1.2 2003/01/09 21:48:55 beighley Exp $
#
# The file contains PERL source that represents the MMRs from
#    an ASIC hardware register (hwreg) file.
#
# This file was generated using the "hwr2pl" utility.
# HWREG source file : hwreg_pic.hwreg
# ASIC base name    : "pic_01"
#

$pic_01_defined = 1;


##########################################################################
#                                                                        #
#   BUS0_BRIDGE_ID                                                       #
#                                                                        #
##########################################################################

%pic_01_00000_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "REV_NUM"                      => [   1,  28,   4, 0x00000000F0000000, 0x00, 0, 0x0000000000000000, "Revision Number (current revision of the widget)" ],
   "PART_NUM"                     => [   2,  12,  16, 0x000000000FFFF000, 0x00, 0, 0x0000000000000000, "Part Number (0xD1Y2 where Y = bus number 0/1)" ],
   "MFG_NUM"                      => [   3,   1,  11, 0x0000000000000FFE, 0x00, 0, 0x0000000000000000, "Manufacturer Identity (0x024)" ],
   "LSB"                          => [   4,   0,   1, 0x0000000000000001, 0x00, 0, 0x0000000000000000, "Always read as 1" ],
);

%pic_01_00000_def =
( NAME    => "BUS0_BRIDGE_ID",
  ADDRESS => 0x00000000,
  NOTE    => "Identification Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00000_flds
);


##########################################################################
#                                                                        #
#   BUS0_BRIDGE_STAT                                                     #
#                                                                        #
##########################################################################

%pic_01_00001_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  36,  28, 0xFFFFFFF000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PCI_X_SPEED"                  => [   1,  34,   2, 0x0000000C00000000, 0x00, 0, 0x0000000000000000, "Valid if PIC NOT using external clock" ],
   "PCI_X_ACTIVE"                 => [   2,  33,   1, 0x0000000200000000, 0x00, 0, 0x0000000000000000, "1=PCI-X mode, 0=PCI mode" ],
   "RSVD1"                        => [   3,  32,   1, 0x0000000100000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "LLP_REC_CNT"                  => [   4,  24,   8, 0x00000000FF000000, 0x00, 0, 0x0000000000000000, "LLP Receive counter (Check Bit errors only)" ],
   "LLP_TX_CNT"                   => [   5,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "LLP transmit retry counter" ],
   "RX_CREDIT_CNT"                => [   6,  12,   4, 0x000000000000F000, 0x00, 0, 0x0000000000000000, "Receive Credit Count" ],
   "TX_CREDIT_CNT"                => [   7,   8,   4, 0x0000000000000F00, 0x00, 0, 0x0000000000000000, "Transmit Credit Count" ],
   "RSVD2"                        => [   8,   0,   8, 0x00000000000000FF, 0x00, 0, 0x0000000000000000, "Reserved" ],
);

%pic_01_00001_def =
( NAME    => "BUS0_BRIDGE_STAT",
  ADDRESS => 0x00000008,
  NOTE    => "Status Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00001_flds
);


##########################################################################
#                                                                        #
#   BUS0_BRIDGE_ERR_UPPER                                                #
#                                                                        #
##########################################################################

%pic_01_00002_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "UPP_ADDR"                     => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00002_def =
( NAME    => "BUS0_BRIDGE_ERR_UPPER",
  ADDRESS => 0x00000010,
  NOTE    => "Upper Address Holding Register Bus Side Errors",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00002_flds
);


##########################################################################
#                                                                        #
#   BUS0_BRIDGE_ERR_LOWER                                                #
#                                                                        #
##########################################################################

%pic_01_00003_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "UPP_ADDR"                     => [   1,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [   2,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00003_def =
( NAME    => "BUS0_BRIDGE_ERR_LOWER",
  ADDRESS => 0x00000018,
  NOTE    => "Lower Address Holding Register Bus Side Errors",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00003_flds
);


##########################################################################
#                                                                        #
#   BUS0_BRIDGE_CTRL                                                     #
#                                                                        #
##########################################################################

%pic_01_00004_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  63,   1, 0x8000000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "NS"                           => [   1,  62,   1, 0x4000000000000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   2,  61,   1, 0x2000000000000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "RSVD1"                        => [   3,  56,   5, 0x1F00000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_NUM"                      => [   4,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "PCI-X Requester Bus Number" ],
   "DEV_NUM"                      => [   5,  43,   5, 0x0000F80000000000, 0x00, 0, 0x0000000000000000, "PCI-X Requester Device Number" ],
   "FUN_NUM"                      => [   6,  40,   3, 0x0000070000000000, 0x00, 0, 0x0000000000000000, "PCI-X Requester Function Number" ],
   "RSVD2"                        => [   7,  32,   8, 0x000000FF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PARITY_EN_ATE"                => [   8,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Enable Parity Checking internal ATE RAM, 1=On" ],
   "PARITY_EN_RESP"               => [   9,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Enable Parity Checking internal Resp RAM, 1=On" ],
   "PARITY_EN_REQ"                => [  10,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Enable Parity Checking internal Req RAM, 1=On" ],
   "RSVD3"                        => [  11,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RST_PIN_N(3:0)"               => [  12,  24,   4, 0x000000000F000000, 0x00, 0, 0x0000000000000000, "Software programmable reset pins" ],
   "RSVD4"                        => [  13,  23,   1, 0x0000000000800000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MEM_SWAP"                     => [  14,  22,   1, 0x0000000000400000, 0x00, 0, 0x0000000000000000, "Memory Enable Swapping (1 => enabled)" ],
   "PAGE_SIZE"                    => [  15,  21,   1, 0x0000000000200000, 0x00, 0, 0x0000000000000000, "Page Size 0 = > 4K 1 => 16K. PCI only" ],
   "RSVD5"                        => [  16,  17,   4, 0x00000000001E0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BAD_PKT"                    => [  17,  16,   1, 0x0000000000010000, 0x00, 0, 0x0000000000000000, "Force Bad LLP Micro-Packet Enable (1 => enabled)" ],
   "LLP_XBAR_CRD"                 => [  18,  12,   4, 0x000000000000F000, 0x00, 0, 0x0000000000000000, "LLP Crossbar Credit" ],
   "CLR_RLLP_CNT"                 => [  19,  11,   1, 0x0000000000000800, 0x00, 0, 0x0000000000000000, "Clear Receive LLP Retry Counter" ],
   "CLR_TLLP_CNT"                 => [  20,  10,   1, 0x0000000000000400, 0x00, 0, 0x0000000000000000, "Clear Transmit LLP Retry Counter" ],
   "SYS_END"                      => [  21,   9,   1, 0x0000000000000200, 0x00, 0, 0x0000000000000000, "System Endianess (1=Big, 0=Little)" ],
   "RSVD6"                        => [  22,   6,   3, 0x00000000000001C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PCI_SPEED"                    => [  23,   4,   2, 0x0000000000000030, 0x00, 0, 0x0000000000000000, "Read Only PCI Speed Select Input" ],
   "WIDGET_ID"                    => [  24,   0,   4, 0x000000000000000F, 0x00, 0, 0x0000000000000000, "Widget ID number." ],
);

%pic_01_00004_def =
( NAME    => "BUS0_BRIDGE_CTRL",
  ADDRESS => 0x00000020,
  NOTE    => "Control Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00004_flds
);


##########################################################################
#                                                                        #
#   BUS0_BRIDGE_REQ_TO                                                   #
#                                                                        #
##########################################################################

%pic_01_00005_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  20,  12, 0x00000000FFF00000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "TIME_OUT"                     => [   2,   0,  20, 0x00000000000FFFFF, 0x00, 0, 0x0000000000000000, "Reload Value for the response time-out counter" ],
);

%pic_01_00005_def =
( NAME    => "BUS0_BRIDGE_REQ_TO",
  ADDRESS => 0x00000028,
  NOTE    => "PCI Request Time-out Value Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00005_flds
);


##########################################################################
#                                                                        #
#   BUS0_BRIDGE_INT_UPPER                                                #
#                                                                        #
##########################################################################

%pic_01_00006_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  20,  12, 0x00000000FFF00000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "TARGET_ID"                    => [   2,  16,   4, 0x00000000000F0000, 0x00, 0, 0x0000000000000000, "Xtalk Target ID Number for error interrupt host" ],
   "UPP_ADDR"                     => [   3,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00006_def =
( NAME    => "BUS0_BRIDGE_INT_UPPER",
  ADDRESS => 0x00000030,
  NOTE    => "Interrupt Destination Upper Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00006_flds
);


##########################################################################
#                                                                        #
#   BUS0_BRIDGE_INT_LOWER                                                #
#                                                                        #
##########################################################################

%pic_01_00007_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  52,  12, 0xFFF0000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "TARGET_ID"                    => [   1,  48,   4, 0x000F000000000000, 0x00, 0, 0x0000000000000000, "Xtalk Target ID Number for error interrupt host" ],
   "UPP_ADDR"                     => [   2,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [   3,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00007_def =
( NAME    => "BUS0_BRIDGE_INT_LOWER",
  ADDRESS => 0x00000038,
  NOTE    => "Interrupt Destination Lower Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00007_flds
);


##########################################################################
#                                                                        #
#   BUS0_CMDWORD_HOLD_REG_BUS                                            #
#                                                                        #
##########################################################################

%pic_01_00008_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "DIDN"                         => [   1,  28,   4, 0x00000000F0000000, 0x00, 0, 0x0000000000000000, "Destination ID Number" ],
   "SIDN"                         => [   2,  24,   4, 0x000000000F000000, 0x00, 0, 0x0000000000000000, "Source ID Number" ],
   "PACTYP"                       => [   3,  20,   4, 0x0000000000F00000, 0x00, 0, 0x0000000000000000, "Packet Type" ],
   "TNUM"                         => [   4,  15,   5, 0x00000000000F8000, 0x00, 0, 0x0000000000000000, "Transaction number" ],
   "COHERENT"                     => [   5,  14,   1, 0x0000000000004000, 0x00, 0, 0x0000000000000000, "Coherent Transaction" ],
   "DS"                           => [   6,  12,   2, 0x0000000000003000, 0x00, 0, 0x0000000000000000, "Data Size" ],
   "GBR"                          => [   7,  11,   1, 0x0000000000000800, 0x00, 0, 0x0000000000000000, "Guaranteed Bandwidth Ring enable" ],
   "VBPM"                         => [   8,  10,   1, 0x0000000000000400, 0x00, 0, 0x0000000000000000, "Virtual Backplane Message" ],
   "ERROR"                        => [   9,   9,   1, 0x0000000000000200, 0x00, 0, 0x0000000000000000, "Error Occurred" ],
   "BARRIER"                      => [  10,   8,   1, 0x0000000000000100, 0x00, 0, 0x0000000000000000, "Barrier" ],
   "RSVD1"                        => [  11,   0,   8, 0x00000000000000FF, 0x00, 0, 0x0000000000000000, "Reserved" ],
);

%pic_01_00008_def =
( NAME    => "BUS0_CMDWORD_HOLD_REG_BUS",
  ADDRESS => 0x00000040,
  NOTE    => "Command Word Holding Register Bus Side Errors",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00008_flds
);


##########################################################################
#                                                                        #
#   BUS0_BRIDGE_LLP_CONFIG                                               #
#                                                                        #
##########################################################################

%pic_01_00009_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  26,   6, 0x00000000FC000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "LLP_MAXRETRY"                 => [   2,  16,  10, 0x0000000003FF0000, 0x00, 0, 0x0000000000000000, "LLP Max retry count." ],
   "LLP_NULLTIMEOUT"              => [   3,  10,   6, 0x000000000000FC00, 0x00, 0, 0x0000000000000000, "Null Time-out value" ],
   "LLP_MAXBURST"                 => [   4,   0,  10, 0x00000000000003FF, 0x00, 0, 0x0000000000000000, "LLP Max burst count." ],
);

%pic_01_00009_def =
( NAME    => "BUS0_BRIDGE_LLP_CONFIG",
  ADDRESS => 0x00000048,
  NOTE    => "LLP Configuration Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00009_flds
);


##########################################################################
#                                                                        #
#   BUS0_BRIDGE_TARG_FLUSH                                               #
#                                                                        #
##########################################################################

%pic_01_00010_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "STATUS"                       => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Flush status" ],
);

%pic_01_00010_def =
( NAME    => "BUS0_BRIDGE_TARG_FLUSH",
  ADDRESS => 0x00000050,
  NOTE    => "PCI/PCI-X Target Flush Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00010_flds
);


##########################################################################
#                                                                        #
#   BUS0_CMDWORD_HOLD_REG_LINK_SIDE                                      #
#                                                                        #
##########################################################################

%pic_01_00011_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "DIDN"                         => [   1,  28,   4, 0x00000000F0000000, 0x00, 0, 0x0000000000000000, "Destination ID Number" ],
   "SIDN"                         => [   2,  24,   4, 0x000000000F000000, 0x00, 0, 0x0000000000000000, "Source ID Number" ],
   "PACTYP"                       => [   3,  20,   4, 0x0000000000F00000, 0x00, 0, 0x0000000000000000, "Packet Type" ],
   "TNUM"                         => [   4,  15,   5, 0x00000000000F8000, 0x00, 0, 0x0000000000000000, "Transaction number" ],
   "COHERENT"                     => [   5,  14,   1, 0x0000000000004000, 0x00, 0, 0x0000000000000000, "Coherent Transaction" ],
   "DS"                           => [   6,  12,   2, 0x0000000000003000, 0x00, 0, 0x0000000000000000, "Data Size" ],
   "GBR"                          => [   7,  11,   1, 0x0000000000000800, 0x00, 0, 0x0000000000000000, "Guaranteed Bandwidth Ring enable" ],
   "VBPM"                         => [   8,  10,   1, 0x0000000000000400, 0x00, 0, 0x0000000000000000, "Virtual Backplane Message" ],
   "ERROR"                        => [   9,   9,   1, 0x0000000000000200, 0x00, 0, 0x0000000000000000, "Error Occurred" ],
   "BARRIER"                      => [  10,   8,   1, 0x0000000000000100, 0x00, 0, 0x0000000000000000, "Barrier" ],
   "RSVD1"                        => [  11,   0,   8, 0x00000000000000FF, 0x00, 0, 0x0000000000000000, "Reserved" ],
);

%pic_01_00011_def =
( NAME    => "BUS0_CMDWORD_HOLD_REG_LINK_SIDE",
  ADDRESS => 0x00000058,
  NOTE    => "Command Word Holding Register Link Side Errors",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00011_flds
);


##########################################################################
#                                                                        #
#   BUS0_BRIDGE_RESP_UPPER                                               #
#                                                                        #
##########################################################################

%pic_01_00012_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "COMMAND"                      => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Crosstalk Command Word" ],
   "RSVD1"                        => [   1,  23,   9, 0x00000000FF800000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "DEV_NUM"                      => [   2,  20,   3, 0x0000000000700000, 0x00, 0, 0x0000000000000000, "Device Number" ],
   "BUFF_NUM"                     => [   3,  16,   4, 0x00000000000F0000, 0x00, 0, 0x0000000000000000, "Buffer Number" ],
   "UPP_ADDR"                     => [   4,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00012_def =
( NAME    => "BUS0_BRIDGE_RESP_UPPER",
  ADDRESS => 0x00000060,
  NOTE    => "PCI Response Buffer Error Upper Address Holding Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00012_flds
);


##########################################################################
#                                                                        #
#   BUS0_BRIDGE_RESP_LOWER                                               #
#                                                                        #
##########################################################################

%pic_01_00013_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  55,   9, 0xFF80000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "DEV_NUM"                      => [   1,  52,   3, 0x0070000000000000, 0x00, 0, 0x0000000000000000, "Device Number" ],
   "BUFF_NUM"                     => [   2,  48,   4, 0x000F000000000000, 0x00, 0, 0x0000000000000000, "Buffer Number" ],
   "UPP_ADDR"                     => [   3,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [   4,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00013_def =
( NAME    => "BUS0_BRIDGE_RESP_LOWER",
  ADDRESS => 0x00000068,
  NOTE    => "PCI Response Buffer Error Lower Address Holding Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00013_flds
);


##########################################################################
#                                                                        #
#   BUS0_DEBUG_PORT_CTRL                                                 #
#                                                                        #
##########################################################################

%pic_01_00014_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  24,  40, 0xFFFFFFFFFF000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "DEBUG_SEL_U"                  => [   1,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Upper Selection (32 bit debug vector within module)" ],
   "DEBUG_M_U"                    => [   2,  12,   4, 0x000000000000F000, 0x00, 0, 0x0000000000000000, "Module Select Port 1 - Upper" ],
   "DEBUG_SEL_L"                  => [   3,   4,   8, 0x0000000000000FF0, 0x00, 0, 0x0000000000000000, "Lower Selection (32 bit debug vector within module)" ],
   "DEBUG_M_L"                    => [   4,   0,   4, 0x000000000000000F, 0x00, 0, 0x0000000000000000, "Module Select Port 0 - Lower" ],
);

%pic_01_00014_def =
( NAME    => "BUS0_DEBUG_PORT_CTRL",
  ADDRESS => 0x00000070,
  NOTE    => "Test Pin Control Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00014_flds
);


##########################################################################
#                                                                        #
#   BUS0_ADDR_HOLD_REG_LINK_SIDE                                         #
#                                                                        #
##########################################################################

%pic_01_00015_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "UPP_ADDR"                     => [   1,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [   2,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00015_def =
( NAME    => "BUS0_ADDR_HOLD_REG_LINK_SIDE",
  ADDRESS => 0x00000078,
  NOTE    => "Address Holding Register Link Side Errors",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00015_flds
);


##########################################################################
#                                                                        #
#   BUS0_DIR_MAP                                                         #
#                                                                        #
##########################################################################

%pic_01_00016_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  24,   8, 0x00000000FF000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "DIR_W_ID"                     => [   2,  20,   4, 0x0000000000F00000, 0x00, 0, 0x0000000000000000, "Direct space target widget ID" ],
   "RSVD2"                        => [   3,  18,   2, 0x00000000000C0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "DIR_ADD512"                   => [   4,  17,   1, 0x0000000000020000, 0x00, 0, 0x0000000000000000, "Direct add 512MB offset only when DIR_OFF = 0x000" ],
   "DIR_OFF"                      => [   5,   0,  17, 0x000000000001FFFF, 0x00, 0, 0x0000000000000000, "Direct Map Offset" ],
);

%pic_01_00016_def =
( NAME    => "BUS0_DIR_MAP",
  ADDRESS => 0x00000080,
  NOTE    => "PCI Direct Mapping Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00016_flds
);


##########################################################################
#                                                                        #
#   BUS0_MAP_FAULT_ADDR_                                                 #
#                                                                        #
##########################################################################

%pic_01_00017_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  22,  10, 0x00000000FFC00000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PCI"                          => [   2,   0,   1, 0x0000000000000001, 0x00, 0, 0x0000000000000000, "0 PCI Address bit 29:12" ],
   "RSVD2"                        => [   3,   3,   1, 0x0000000000000008, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PCI_DEV_NUM"                  => [   4,   0,   3, 0x0000000000000007, 0x00, 0, 0x0000000000000000, "PCI Device Number" ],
);

%pic_01_00017_def =
( NAME    => "BUS0_MAP_FAULT_ADDR_",
  ADDRESS => 0x00000090,
  NOTE    => "PCI Page Map Fault Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00017_flds
);


##########################################################################
#                                                                        #
#   BUS0_ARB_PRIORITY                                                    #
#                                                                        #
##########################################################################

%pic_01_00018_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  24,   8, 0x00000000FF000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "DEV_BROKE"                    => [   2,  20,   4, 0x0000000000F00000, 0x00, 0, 0x0000000000000000, "Device Broke" ],
   "RSVD2"                        => [   3,  18,   2, 0x00000000000C0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "REQ_WAIT_TICK"                => [   4,  16,   2, 0x0000000000030000, 0x00, 0, 0x0000000000000000, "Time period used by the arbiter request wait circuit" ],
   "RSVD3"                        => [   5,  12,   4, 0x000000000000F000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "REQ_WAIT_EN"                  => [   6,   8,   4, 0x0000000000000F00, 0x00, 0, 0x0000000000000000, "Enable the arbiter to delay issuing bus grants" ],
   "RSVD4"                        => [   7,   7,   1, 0x0000000000000080, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "FREEZE_GNT"                   => [   8,   6,   1, 0x0000000000000040, 0x00, 0, 0x0000000000000000, "No grant to the PCI devices and PIC internal circuit" ],
   "RSVD5"                        => [   9,   5,   1, 0x0000000000000020, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "EN_BRIDGE_HI"                 => [  10,   3,   2, 0x0000000000000018, 0x00, 0, 0x0000000000000000, "Enable PIC to request the bus in the high priority ring" ],
   "RSVD6"                        => [  11,   2,   1, 0x0000000000000004, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "EN_BRIDGE_LO"                 => [  12,   0,   2, 0x0000000000000003, 0x00, 0, 0x0000000000000000, "Enable PIC to request the bus in the low priority ring" ],
);

%pic_01_00018_def =
( NAME    => "BUS0_ARB_PRIORITY",
  ADDRESS => 0x000000A0,
  NOTE    => "Arbitration Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00018_flds
);


##########################################################################
#                                                                        #
#   BUS0_INT_RAM_PERR                                                    #
#                                                                        #
##########################################################################

%pic_01_00019_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  55,   9, 0xFF80000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "ADDR_ATE"                     => [   1,  48,  10, 0x03FF000000000000, 0x00, 0, 0x0000000000000000, "ATE Ram Error Address" ],
   "RSVD1"                        => [   2,  41,   7, 0x0000FE0000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "ADDR_RESP"                    => [   3,  32,   9, 0x000001FF00000000, 0x00, 0, 0x0000000000000000, "Read Response Ram Error Address" ],
   "ADDR_REQ"                     => [   4,  24,   8, 0x00000000FF000000, 0x00, 0, 0x0000000000000000, "Write Request Ram Error Address" ],
   "RSVD2"                        => [   5,  22,   2, 0x0000000000C00000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "WRT_ERR_ATE"                  => [   6,  21,   1, 0x0000000000200000, 0x00, 0, 0x0000000000000000, "ATE RAM error" ],
   "WRT_ERR_RESP"                 => [   7,  20,   1, 0x0000000000100000, 0x00, 0, 0x0000000000000000, "Read Response RAM error" ],
   "WRT_ERR_REQ"                  => [   8,  19,   1, 0x0000000000080000, 0x00, 0, 0x0000000000000000, "Write Request RAM error" ],
   "RSVD3"                        => [   9,  17,   2, 0x0000000000060000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "DBE_RESP"                     => [  10,  16,   1, 0x0000000000010000, 0x00, 0, 0x0000000000000000, "Indicates the dw in error of the Read Resp Ram" ],
   "DBE_REQ"                      => [  11,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Indicates the byte in error Write Request Ram" ],
);

%pic_01_00019_def =
( NAME    => "BUS0_INT_RAM_PERR",
  ADDRESS => 0x000000B0,
  NOTE    => "Internal Ram Parity Error Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00019_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_TOUT                                                        #
#                                                                        #
##########################################################################

%pic_01_00020_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  21,  11, 0x00000000FFE00000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PCI_RETRY_HLD"                => [   2,  16,   5, 0x00000000001F0000, 0x00, 0, 0x0000000000000000, "PCI retry hold" ],
   "RSVD2"                        => [   3,  10,   6, 0x000000000000FC00, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PCI_RETRY_CNT"                => [   4,   0,  10, 0x00000000000003FF, 0x00, 0, 0x0000000000000000, "PCI retry count" ],
);

%pic_01_00020_def =
( NAME    => "BUS0_PCI_TOUT",
  ADDRESS => 0x000000C0,
  NOTE    => "PCI/PCI-X Time-out Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00020_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_TYPE1_CONFIG                                                #
#                                                                        #
##########################################################################

%pic_01_00021_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  24,   8, 0x00000000FF000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_NUM"                      => [   2,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Bus Number (select 1 of 256 buses)" ],
   "DEV_NUM"                      => [   3,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "Device Number (select 1 of 32 devices)" ],
   "RSVD2"                        => [   4,   0,  11, 0x00000000000007FF, 0x00, 0, 0x0000000000000000, "Reserved" ],
);

%pic_01_00021_def =
( NAME    => "BUS0_PCI_TYPE1_CONFIG",
  ADDRESS => 0x000000C8,
  NOTE    => "PCI/PCI-X Type 1 Configuration Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00021_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_ERR_UPPER_ADDR                                              #
#                                                                        #
##########################################################################

%pic_01_00022_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  28,   4, 0x00000000F0000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PCI_XTALK_DID"                => [   2,  24,   4, 0x000000000F000000, 0x00, 0, 0x0000000000000000, "Target Xtalk ID" ],
   "RSVD2"                        => [   3,  22,   2, 0x0000000000C00000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PCI_DAC"                      => [   4,  21,   1, 0x0000000000200000, 0x00, 0, 0x0000000000000000, "Dual Address Cycle" ],
   "PCI_DEV_MASTER"               => [   5,  20,   1, 0x0000000000100000, 0x00, 0, 0x0000000000000000, "PIC was not PCI master when the error occurred" ],
   "PCI_VDEV"                     => [   6,  19,   1, 0x0000000000080000, 0x00, 0, 0x0000000000000000, "Value of the Virtual Request." ],
   "PCI_DEV_NUM"                  => [   7,  16,   3, 0x0000000000070000, 0x00, 0, 0x0000000000000000, "DEVNUM of PCI master when the error occurred" ],
   "PCI_UADDR_ERR"                => [   8,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address of the PCI bus command (PCI address 47:32)" ],
);

%pic_01_00022_def =
( NAME    => "BUS0_PCI_ERR_UPPER_ADDR",
  ADDRESS => 0x000000D0,
  NOTE    => "PCI Bus Error Upper Address Holding Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00022_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_ERR_LOWER_ADDR                                              #
#                                                                        #
##########################################################################

%pic_01_00023_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  60,   4, 0xF000000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PCI_XTALK_DID"                => [   1,  56,   4, 0x0F00000000000000, 0x00, 0, 0x0000000000000000, "Target Xtalk ID" ],
   "RSVD1"                        => [   2,  54,   2, 0x00C0000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PCI_DAC"                      => [   3,  53,   1, 0x0020000000000000, 0x00, 0, 0x0000000000000000, "Dual Address Cycle" ],
   "PCI_DEV_MASTER"               => [   4,  52,   1, 0x0010000000000000, 0x00, 0, 0x0000000000000000, "PIC was not PCI master when the error occurred" ],
   "PCI_VDEV"                     => [   5,  51,   1, 0x0008000000000000, 0x00, 0, 0x0000000000000000, "Value of the Virtual Request." ],
   "PCI_DEV_NUM"                  => [   6,  48,   3, 0x0007000000000000, 0x00, 0, 0x0000000000000000, "DEVNUM of PCI master when the error occurred" ],
   "PCI_UADDR_ERR"                => [   7,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address of the PCI bus command (PCI address 47:32)" ],
   "PCI_LADDR_ERR"                => [   8,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address of the PCI bus command (PCI address 31:0)" ],
);

%pic_01_00023_def =
( NAME    => "BUS0_PCI_ERR_LOWER_ADDR",
  ADDRESS => 0x000000D8,
  NOTE    => "PCI Bus Error Lower Address Holding Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00023_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_ERR_ADDR                                                  #
#                                                                        #
##########################################################################

%pic_01_00024_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "PCIX_ERR_ADDR"                => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "PCI-X Error Address" ],
);

%pic_01_00024_def =
( NAME    => "BUS0_PCI_X_ERR_ADDR",
  ADDRESS => 0x00000600,
  NOTE    => "PCI-X Error Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00024_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_ERR_ATTR                                                  #
#                                                                        #
##########################################################################

%pic_01_00025_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  49,  15, 0xFFFE000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "DAC"                          => [   1,  48,   1, 0x0001000000000000, 0x00, 0, 0x0000000000000000, "1=PCI-X Dual Address Cycle, 0=PCI-X Single Address Cycle" ],
   "BUS_CMD"                      => [   2,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   3,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "RSVD1"                        => [   4,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "NS"                           => [   5,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   6,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   7,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   8,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requester Bus Number" ],
   "DEV_NUM"                      => [   9,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requester Device Number" ],
   "FUN_NUM"                      => [  10,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requester Function Number" ],
   "L_BYTE_CNT"                   => [  11,   0,   8, 0x00000000000000FF, 0x00, 0, 0x0000000000000000, "PCI-X Lower Byte Count" ],
);

%pic_01_00025_def =
( NAME    => "BUS0_PCI_X_ERR_ATTR",
  ADDRESS => 0x00000608,
  NOTE    => "PCI-X Error Attribute Register Dword/Burst Definitions",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00025_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_ERR_DATA                                                  #
#                                                                        #
##########################################################################

%pic_01_00026_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "PCIX_ERR_DATA"                => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "PCI-X Error Data" ],
);

%pic_01_00026_def =
( NAME    => "BUS0_PCI_X_ERR_DATA",
  ADDRESS => 0x00000610,
  NOTE    => "PCI-X Error Data Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00026_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_PIO_SPLIT_ERR_ADDR                                        #
#                                                                        #
##########################################################################

%pic_01_00027_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PCIX_ERR_ADDR"                => [   1,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "PCI-X Error Address" ],
);

%pic_01_00027_def =
( NAME    => "BUS0_PCI_X_PIO_SPLIT_ERR_ADDR",
  ADDRESS => 0x00000618,
  NOTE    => "PCI-X PIO Split Request Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00027_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_PIO_SPLIT_ERR_ATTR                                        #
#                                                                        #
##########################################################################

%pic_01_00028_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  36,  28, 0xFFFFFFF000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUSCMD"                       => [   1,  32,   4, 0x0000000F00000000, 0x00, 0, 0x0000000000000000, "Command Encoding" ],
   "RSVD1"                        => [   2,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "NS"                           => [   3,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   4,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   5,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   6,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requester Bus Number" ],
   "DEV_NUM"                      => [   7,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requester Device Number" ],
   "FUN_NUM"                      => [   8,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requester Function Number" ],
   "LOWER_BYTE_CNT"               => [   9,   0,   8, 0x00000000000000FF, 0x00, 0, 0x0000000000000000, "PCI-X Byte Count" ],
);

%pic_01_00028_def =
( NAME    => "BUS0_PCI_X_PIO_SPLIT_ERR_ATTR",
  ADDRESS => 0x00000620,
  NOTE    => "PCI-X PIO Split Request Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00028_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_DMA_ERR_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00029_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  53,  11, 0xFFE0000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "XDMA_ERR_EVT_CODE"            => [   1,  49,   4, 0x001E000000000000, 0x00, 0, 0x0000000000000000, "Event Code" ],
   "XDMA_ERR_OP_INDEX"            => [   2,  45,   4, 0x0001E00000000000, 0x00, 0, 0x0000000000000000, "Entry index into the OP Table" ],
   "XDMA_ERR_CL_INDEX"            => [   3,  39,   6, 0x00001F8000000000, 0x00, 0, 0x0000000000000000, "Cache Line index for which the error occurred" ],
   "XDMA_ERR_NS"                  => [   4,  38,   1, 0x0000004000000000, 0x00, 0, 0x0000000000000000, "Op Info - No Snoop" ],
   "XDMA_ERR_DEV_NUM_L"           => [   5,  36,   2, 0x0000003000000000, 0x00, 0, 0x0000000000000000, "Op Info - Device Number Low Bits (PIC supports 0-3)" ],
   "XDMA_ERR_D64"                 => [   6,  35,   1, 0x0000000800000000, 0x00, 0, 0x0000000000000000, "Op Info - PCI-X Data 64 Mode" ],
   "XDMA_ERR_RD_IS_DW"            => [   7,  34,   1, 0x0000000400000000, 0x00, 0, 0x0000000000000000, "Op Info - PCI-X Double Word Read" ],
   "XDMA_ERR_BYTE_CNT"            => [   8,  22,  12, 0x00000003FFC00000, 0x00, 0, 0x0000000000000000, "Op Info - PCI-X Byte Count" ],
   "XDMA_ERR_RO"                  => [   9,  21,   1, 0x0000000000200000, 0x00, 0, 0x0000000000000000, "Op Info - PCI-X Relaxed Ordering" ],
   "XDMA_ERR_TAG"                 => [  10,  16,   5, 0x00000000001F0000, 0x00, 0, 0x0000000000000000, "Op Info - PCI-X TAG" ],
   "XDMA_ERR_BUS_NUM"             => [  11,   8,   8, 0x000000000000FF00, 0x00, 0, 0x0000000000000000, "Op Info - PCI-X Requester Bus Number" ],
   "XDMA_ERR_DEV_NUM"             => [  12,   3,   5, 0x00000000000000F8, 0x00, 0, 0x0000000000000000, "Op Info - PCI-X Requester Device Number" ],
   "XDMA_ERR_FUN_NUM"             => [  13,   0,   3, 0x0000000000000007, 0x00, 0, 0x0000000000000000, "Op Info - PCI-X Requester Function Number" ],
);

%pic_01_00029_def =
( NAME    => "BUS0_PCI_X_DMA_ERR_ATTR",
  ADDRESS => 0x00000628,
  NOTE    => "PCI-X DMA Request Error Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00029_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_DMA_ERR_ADDR                                              #
#                                                                        #
##########################################################################

%pic_01_00030_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "XDMA_ERR_ADDR"                => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "PCI-X Address" ],
);

%pic_01_00030_def =
( NAME    => "BUS0_PCI_X_DMA_ERR_ADDR",
  ADDRESS => 0x00000630,
  NOTE    => "PCI-X DMA Request Error Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00030_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_READ_REQ_TOUT                                             #
#                                                                        #
##########################################################################

%pic_01_00031_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  20,  44, 0xFFFFFFFFFFF00000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "TIME_OUT"                     => [   1,   0,  20, 0x00000000000FFFFF, 0x00, 0, 0x0000000000000000, "Reload Value (0x00000 is an ILLEGAL setting and must not be used!)" ],
);

%pic_01_00031_def =
( NAME    => "BUS0_PCI_X_READ_REQ_TOUT",
  ADDRESS => 0x00000638,
  NOTE    => "PCI-X Timeout Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00031_flds
);


##########################################################################
#                                                                        #
#   BUS0_INT_STATUS                                                      #
#                                                                        #
##########################################################################

%pic_01_00032_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  46,  18, 0xFFFFC00000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PCI_X_SPLIT_MES_PE"           => [   1,  45,   1, 0x0000200000000000, 0x00, 0, 0x0000000000000000, "PCI-X Split Completion Message Parity Error" ],
   "PCI_X_SPLIT_EMESS"            => [   2,  44,   1, 0x0000100000000000, 0x00, 0, 0x0000000000000000, "PCI-X Split Completion Error Message" ],
   "PCI_X_SPLIT_TO"               => [   3,  43,   1, 0x0000080000000000, 0x00, 0, 0x0000000000000000, "PCI-X Split Completion Timeout" ],
   "PCI_X_UNEX_COMP"              => [   4,  42,   1, 0x0000040000000000, 0x00, 0, 0x0000000000000000, "PCI-X Unexpected Completion cycle to master" ],
   "INT_RAM_PERR"                 => [   5,  41,   1, 0x0000020000000000, 0x00, 0, 0x0000000000000000, "Internal Ram Parity Error" ],
   "PCI_X_ARB_ERR"                => [   6,  40,   1, 0x0000010000000000, 0x00, 0, 0x0000000000000000, "PCI-X Device Requesting Arb Error" ],
   "PCI_X_REQ_TOUT"               => [   7,  39,   1, 0x0000008000000000, 0x00, 0, 0x0000000000000000, "PCI-X Read Request Time Out" ],
   "PCI_X_TABORT"                 => [   8,  38,   1, 0x0000004000000000, 0x00, 0, 0x0000000000000000, "PCI-X Target Abort" ],
   "PCI_X_PERR"                   => [   9,  37,   1, 0x0000002000000000, 0x00, 0, 0x0000000000000000, "PCI-X PERR" ],
   "PCI_X_SERR"                   => [  10,  36,   1, 0x0000001000000000, 0x00, 0, 0x0000000000000000, "PCI-X SERR" ],
   "PCI_X_MRETRY"                 => [  11,  35,   1, 0x0000000800000000, 0x00, 0, 0x0000000000000000, "PCI-X pio retry counter exhausted" ],
   "PCI_X_MTOUT"                  => [  12,  34,   1, 0x0000000400000000, 0x00, 0, 0x0000000000000000, "PCI-X Master Timeout" ],
   "PCI_X_DA_PARITY"              => [  13,  33,   1, 0x0000000200000000, 0x00, 0, 0x0000000000000000, "PCI-X Data cycle parity error detected by PIC" ],
   "PCI_X_AD_PARITY"              => [  14,  32,   1, 0x0000000100000000, 0x00, 0, 0x0000000000000000, "PCI-X Address or Attribute cycle parity error" ],
   "RSVD1"                        => [  15,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PMU_PAGE_FAULT"               => [  16,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Indicates an Invalid PCI Page Access" ],
   "UNEXPECTED_RESP"              => [  17,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "This bit indicates that an unexpected response arrived" ],
   "BAD_XRESP_PACKET"             => [  18,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Data size in command word of a response did not match" ],
   "BAD_XREQ_PACKET"              => [  19,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Data size in command word of a request did not match" ],
   "RESP_XTALK_ERROR"             => [  20,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Response packet had error bit set or invalid sideband" ],
   "REQ_XTALK_ERROR"              => [  21,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Request packet had error bit set or invalid sideband" ],
   "INVALID_ACCESS"               => [  22,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Packet contains an invalid address/access type" ],
   "UNSUPPORTED_XOP"              => [  23,  23,   1, 0x0000000000800000, 0x00, 0, 0x0000000000000000, "Request operation is not supported by PIC" ],
   "XREQ_FIFO_OFLOW"              => [  24,  22,   1, 0x0000000000400000, 0x00, 0, 0x0000000000000000, "Request packet overflow" ],
   "LLP_REC_SNERROR"              => [  25,  21,   1, 0x0000000000200000, 0x00, 0, 0x0000000000000000, "LLP Receiver Sequence Number Error" ],
   "LLP_REC_CBERROR"              => [  26,  20,   1, 0x0000000000100000, 0x00, 0, 0x0000000000000000, "LLP Receiver Check Bit Error" ],
   "LLP_RCTY"                     => [  27,  19,   1, 0x0000000000080000, 0x00, 0, 0x0000000000000000, "LLP Receiver Retry Count Interrupt" ],
   "LLP_TX_RETRY"                 => [  28,  18,   1, 0x0000000000040000, 0x00, 0, 0x0000000000000000, "LLP Transmitter Retry" ],
   "LLP_TCTY"                     => [  29,  17,   1, 0x0000000000020000, 0x00, 0, 0x0000000000000000, "LLP Transmitter Retry Count Interrupt" ],
   "RSVD2"                        => [  30,  16,   1, 0x0000000000010000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PCI_ABORT"                    => [  31,  15,   1, 0x0000000000008000, 0x00, 0, 0x0000000000000000, "Status of PCI slave abort condition interrupt" ],
   "PCI_PARITY"                   => [  32,  14,   1, 0x0000000000004000, 0x00, 0, 0x0000000000000000, "Indicates the PIC detected a parity error." ],
   "PCI_SERR"                     => [  33,  13,   1, 0x0000000000002000, 0x00, 0, 0x0000000000000000, "Status PCI Address/CMD parity error interrupt" ],
   "PCI_PERR"                     => [  34,  12,   1, 0x0000000000001000, 0x00, 0, 0x0000000000000000, "Status of PCI parity error interrupt" ],
   "PCI_MASTER_TOUT"              => [  35,  11,   1, 0x0000000000000800, 0x00, 0, 0x0000000000000000, "Indicates a device select timeout on the PCI bus." ],
   "PCI_RETRY_CNT"                => [  36,  10,   1, 0x0000000000000400, 0x00, 0, 0x0000000000000000, "PCI retry operation count exhausted." ],
   "XREAD_REQ_TOUT"               => [  37,   9,   1, 0x0000000000000200, 0x00, 0, 0x0000000000000000, "PCI to Crosstalk read request timeout." ],
   "RSVD3"                        => [  38,   8,   1, 0x0000000000000100, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT_STATE"                    => [  39,   0,   8, 0x00000000000000FF, 0x00, 0, 0x0000000000000000, "Status of INT_N[7:0]. A 1 means INT_N is low." ],
);

%pic_01_00032_def =
( NAME    => "BUS0_INT_STATUS",
  ADDRESS => 0x00000100,
  NOTE    => "Interrupt Status Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00032_flds
);


##########################################################################
#                                                                        #
#   BUS0_INT_ENABLE                                                      #
#                                                                        #
##########################################################################

%pic_01_00033_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  46,  18, 0xFFFFC00000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "EN_PCI_X_SPLIT_MES_PE"        => [   1,  45,   1, 0x0000200000000000, 0x00, 0, 0x0000000000000000, "PCI-X Split Completion Message Parity Error" ],
   "EN_PCI_X_SPLIT_EMESS"         => [   2,  44,   1, 0x0000100000000000, 0x00, 0, 0x0000000000000000, "PCI-X Split Completion Error Message" ],
   "EN_PCI_X_SPLIT_TO"            => [   3,  43,   1, 0x0000080000000000, 0x00, 0, 0x0000000000000000, "PCI-X Split Completion Timeout" ],
   "EN_PCI_X_UNEX_COMP"           => [   4,  42,   1, 0x0000040000000000, 0x00, 0, 0x0000000000000000, "PCI-X Unexpected Completion" ],
   "EN_INT_RAM_PERR"              => [   5,  41,   1, 0x0000020000000000, 0x00, 0, 0x0000000000000000, "Internal Ram Parity Error" ],
   "EN_PCI_X_ARB_ERR"             => [   6,  40,   1, 0x0000010000000000, 0x00, 0, 0x0000000000000000, "PCI-X Arb Error" ],
   "EN_PCI_X_REQ_TOUT"            => [   7,  39,   1, 0x0000008000000000, 0x00, 0, 0x0000000000000000, "PCI-X Read Request Time Out" ],
   "EN_PCI_X_TABORT"              => [   8,  38,   1, 0x0000004000000000, 0x00, 0, 0x0000000000000000, "PCI-X Target Abort" ],
   "EN_PCI_X_PERR"                => [   9,  37,   1, 0x0000002000000000, 0x00, 0, 0x0000000000000000, "PCI-X PERR" ],
   "EN_PCI_X_SERR"                => [  10,  36,   1, 0x0000001000000000, 0x00, 0, 0x0000000000000000, "PCI-X SERR" ],
   "EN_PCI_X_MRETRY"              => [  11,  35,   1, 0x0000000800000000, 0x00, 0, 0x0000000000000000, "PCI-X pio retry counter exhausted" ],
   "EN_PCI_X_MTOUT"               => [  12,  34,   1, 0x0000000400000000, 0x00, 0, 0x0000000000000000, "PCI-X Master Timeout" ],
   "EN_PCI_X_DA_PARITY"           => [  13,  33,   1, 0x0000000200000000, 0x00, 0, 0x0000000000000000, "PCI-X Data cycle parity error detected by PIC" ],
   "EN_PCI_X_AD_PARITY"           => [  14,  32,   1, 0x0000000100000000, 0x00, 0, 0x0000000000000000, "PCI-X Address or Attribute cycle parity error" ],
   "RSVD1"                        => [  15,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "EN_PMU_PAGE_FAULT"            => [  16,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Indicates an Invalid Page Access" ],
   "EN_UNEXPECTED_RESP"           => [  17,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Enables unexpected response interrupt." ],
   "EN_BAD_XRESP_PACKET"          => [  18,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Enables bad Crosstalk packet interrupt." ],
   "EN_BAD_XREQ_PACKET"           => [  19,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Enables bad Crosstalk packet interrupt." ],
   "EN_RESP_XTALK_ERROR"          => [  20,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Enables Crosstalk error interrupt." ],
   "EN_REQ_XTALK_ERROR"           => [  21,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Enables Crosstalk error interrupt." ],
   "EN_INVALID_ACCESS"            => [  22,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Enables invalid address/datasize/access error interrupt." ],
   "EN_UNSUPPORTED_XOP"           => [  23,  23,   1, 0x0000000000800000, 0x00, 0, 0x0000000000000000, "Enables unsupported operation error." ],
   "EN_XREQ_FIFO_OFLOW"           => [  24,  22,   1, 0x0000000000400000, 0x00, 0, 0x0000000000000000, "Enables Crosstalk request fifo overflow interrupt." ],
   "EN_LLP_REC_SNERROR"           => [  25,  21,   1, 0x0000000000200000, 0x00, 0, 0x0000000000000000, "Enables LLP Receiver Sequence Number Error interrupt." ],
   "EN_LLP_REC_CBERROR"           => [  26,  20,   1, 0x0000000000100000, 0x00, 0, 0x0000000000000000, "Enables LLP Receiver Check Bit Error interrupt." ],
   "EN_LLP_RCTY"                  => [  27,  19,   1, 0x0000000000080000, 0x00, 0, 0x0000000000000000, "Enables Receiver Retry Count interrupt." ],
   "EN_LLP_TX_RETRY"              => [  28,  18,   1, 0x0000000000040000, 0x00, 0, 0x0000000000000000, "Enables LLP Transmitter Retry interrupt." ],
   "EN_LLP_TCTY"                  => [  29,  17,   1, 0x0000000000020000, 0x00, 0, 0x0000000000000000, "Enables Crosstalk LLP Transmitter Retry Count interrupt." ],
   "RSVD2"                        => [  30,  16,   1, 0x0000000000010000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "EN_PCI_ABORT"                 => [  31,  15,   1, 0x0000000000008000, 0x00, 0, 0x0000000000000000, "Enables PCI master/slave abort condition interrupt" ],
   "EN_PCI_PARITY"                => [  32,  14,   1, 0x0000000000004000, 0x00, 0, 0x0000000000000000, "Enables PCI parity error interrupt." ],
   "EN_PCI_SERR"                  => [  33,  13,   1, 0x0000000000002000, 0x00, 0, 0x0000000000000000, "Enables PCI Address/CMD parity error interrupt" ],
   "EN_PCI_PERR"                  => [  34,  12,   1, 0x0000000000001000, 0x00, 0, 0x0000000000000000, "Enables PCI parity error interrupt" ],
   "EN_PCI_MASTER_TOUT"           => [  35,  11,   1, 0x0000000000000800, 0x00, 0, 0x0000000000000000, "Enables PCI master timeout interrupt." ],
   "EN_PCI_RETRY_CNT"             => [  36,  10,   1, 0x0000000000000400, 0x00, 0, 0x0000000000000000, "Enables PCI retry count interrupt." ],
   "EN_XREAD_REQ_TOUT"            => [  37,   9,   1, 0x0000000000000200, 0x00, 0, 0x0000000000000000, "Enables Crosstalk read request timeout interrupt." ],
   "RSVD3"                        => [  38,   8,   1, 0x0000000000000100, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "EN_INT_STATE"                 => [  39,   0,   8, 0x00000000000000FF, 0x00, 0, 0x0000000000000000, "Enables INT_N[7:0]." ],
);

%pic_01_00033_def =
( NAME    => "BUS0_INT_ENABLE",
  ADDRESS => 0x00000108,
  NOTE    => "Interrupt Enable Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00033_flds
);


##########################################################################
#                                                                        #
#   BUS0_RESET_INT_STATUS                                                #
#                                                                        #
##########################################################################

%pic_01_00034_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  46,  18, 0xFFFFC00000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "LOGV_PCI_X_SPLIT_MES_PE"      => [   1,  45,   1, 0x0000200000000000, 0x00, 0, 0x0000000000000000, "PCI-X Split Completion Message Parity Error" ],
   "LOGV_PCI_X_SPLIT_EMESS"       => [   2,  44,   1, 0x0000100000000000, 0x00, 0, 0x0000000000000000, "PCI-X Split Completion Error Message" ],
   "LOGV_PCI_X_SPLIT_TO"          => [   3,  43,   1, 0x0000080000000000, 0x00, 0, 0x0000000000000000, "PCI-X Split Completion Timeout" ],
   "LOGV_PCI_X_UNEX_COMP"         => [   4,  42,   1, 0x0000040000000000, 0x00, 0, 0x0000000000000000, "PCI-X Unexpected Completion cycle to master" ],
   "LOGV_INT_RAM_PERR"            => [   5,  41,   1, 0x0000020000000000, 0x00, 0, 0x0000000000000000, "Internal Ram Parity Error" ],
   "LOGV_PCI_X_ARB_ERR"           => [   6,  40,   1, 0x0000010000000000, 0x00, 0, 0x0000000000000000, "PCI-X Arb Error" ],
   "LOGV_PCI_X_REQ_TOUT"          => [   7,  39,   1, 0x0000008000000000, 0x00, 0, 0x0000000000000000, "PCI-X Read Request Time Out" ],
   "LOGV_PCI_X_TABORT"            => [   8,  38,   1, 0x0000004000000000, 0x00, 0, 0x0000000000000000, "PCI-X Target Abort" ],
   "LOGV_PCI_X_PERR"              => [   9,  37,   1, 0x0000002000000000, 0x00, 0, 0x0000000000000000, "PCI-X PERR" ],
   "LOGV_PCI_X_SERR"              => [  10,  36,   1, 0x0000001000000000, 0x00, 0, 0x0000000000000000, "PCI-X SERR" ],
   "LOGV_PCI_X_MRETRY"            => [  11,  35,   1, 0x0000000800000000, 0x00, 0, 0x0000000000000000, "PCI-X pio retry counter exhausted" ],
   "LOGV_PCI_X_MTOUT"             => [  12,  34,   1, 0x0000000400000000, 0x00, 0, 0x0000000000000000, "PCI-X Master Timeout" ],
   "LOGV_PCI_X_DA_PARITY"         => [  13,  33,   1, 0x0000000200000000, 0x00, 0, 0x0000000000000000, "PCI-X Data cycle parity error detected by PIC" ],
   "LOGV_PCI_X_AD_PARITY"         => [  14,  32,   1, 0x0000000100000000, 0x00, 0, 0x0000000000000000, "PCI-X Address or Attribute cycle parity error detected by PIC" ],
   "RSVD1"                        => [  15,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "LOGV_PMU_PAGE_FAULT"          => [  16,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Indicates an Invalid Page Access" ],
   "LOGV_UNEXPECTED_RESP"         => [  17,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Enables unexpected response interrupt." ],
   "LOGV_BAD_XRESP_PACKET"        => [  18,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Enables bad Crosstalk packet interrupt." ],
   "LOGV_BAD_XREQ_PACKET"         => [  19,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Enables bad Crosstalk packet interrupt." ],
   "LOGV_RESP_XTALK_ERROR"        => [  20,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Enables Crosstalk error interrupt." ],
   "LOGV_REQ_XTALK_ERROR"         => [  21,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Enables Crosstalk error interrupt." ],
   "LOGV_INVALID_ACCESS"          => [  22,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Enables invalid address/datasize/access error interrupt." ],
   "LOGV_UNSUPPORTED_XOP"         => [  23,  23,   1, 0x0000000000800000, 0x00, 0, 0x0000000000000000, "Enables unsupported operation error." ],
   "LOGV_XREQ_FIFO_OFLOW"         => [  24,  22,   1, 0x0000000000400000, 0x00, 0, 0x0000000000000000, "Enables Crosstalk request fifo overflow interrupt." ],
   "LOGV_LLP_REC_SNERROR"         => [  25,  21,   1, 0x0000000000200000, 0x00, 0, 0x0000000000000000, "Enables LLP Receiver Sequence Number Error interrupt." ],
   "LOGV_LLP_REC_CBERROR"         => [  26,  20,   1, 0x0000000000100000, 0x00, 0, 0x0000000000000000, "Enables LLP Receiver Check Bit Error interrupt." ],
   "LOGV_LLP_RCTY"                => [  27,  19,   1, 0x0000000000080000, 0x00, 0, 0x0000000000000000, "Enables Receiver Retry Count interrupt." ],
   "LOGV_LLP_TX_RETRY"            => [  28,  18,   1, 0x0000000000040000, 0x00, 0, 0x0000000000000000, "Enables LLP Transmitter Retry interrupt." ],
   "LOGV_LLP_TCTY"                => [  29,  17,   1, 0x0000000000020000, 0x00, 0, 0x0000000000000000, "Enables Crosstalk LLP Transmitter Retry Count interrupt." ],
   "RSVD2"                        => [  30,  16,   1, 0x0000000000010000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "LOGV_PCI_ABORT"               => [  31,  15,   1, 0x0000000000008000, 0x00, 0, 0x0000000000000000, "Enables PCI master/slave abort condition interrupt" ],
   "LOGV_PCI_PARITY"              => [  32,  14,   1, 0x0000000000004000, 0x00, 0, 0x0000000000000000, "Enables PCI parity error interrupt." ],
   "LOGV_PCI_SERR"                => [  33,  13,   1, 0x0000000000002000, 0x00, 0, 0x0000000000000000, "Enables PCI Address/CMD parity error interrupt" ],
   "LOGV_PCI_PERR"                => [  34,  12,   1, 0x0000000000001000, 0x00, 0, 0x0000000000000000, "Enables PCI parity error interrupt" ],
   "LOGV_PCI_MASTER_TOUT"         => [  35,  11,   1, 0x0000000000000800, 0x00, 0, 0x0000000000000000, "Enables PCI master timeout interrupt." ],
   "LOGV_PCI_RETRY_CNT"           => [  36,  10,   1, 0x0000000000000400, 0x00, 0, 0x0000000000000000, "Enables PCI retry count interrupt." ],
   "LOGV_XREAD_REQ_TOUT"          => [  37,   9,   1, 0x0000000000000200, 0x00, 0, 0x0000000000000000, "Enables Crosstalk read request timeout interrupt." ],
   "RSVD3"                        => [  38,   7,   2, 0x0000000000000180, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MULTI_CLR"                    => [  39,   6,   1, 0x0000000000000040, 0x00, 0, 0x0000000000000000, "ERROR_VIEW" ],
   "CRP_GRP_CLR"                  => [  40,   5,   1, 0x0000000000000020, 0x00, 0, 0x0000000000000000, "UNEXPECTED_RESP, XREQ_FIFO_OFLOW" ],
   "RESP_BUF_GRP_CLR"             => [  41,   4,   1, 0x0000000000000010, 0x00, 0, 0x0000000000000000, "BAD_XRESP_PACKET, RESP_XTALK_ERROR, XREAD_REQ_TOUT" ],
   "REQ_DSP_GRP_CLR"              => [  42,   3,   1, 0x0000000000000008, 0x00, 0, 0x0000000000000000, "UNSUPPORTED_XOP, BAD_XREQ_PACKET, REQ_XTALK_ERROR, INVALID_ADDRESS" ],
   "LLP_GRP_CLR"                  => [  43,   2,   1, 0x0000000000000004, 0x00, 0, 0x0000000000000000, "LLP_REC_SNERROR, LLP_REC_CBERROR, LLP_RCTY, LLP_TX_RETRY, LLP_TCTY" ],
   "PMU_PAGE_FAULT"               => [  44,   1,   1, 0x0000000000000002, 0x00, 0, 0x0000000000000000, "Page_Fault" ],
   "PCI_GRP_CLR"                  => [  45,   0,   1, 0x0000000000000001, 0x00, 0, 0x0000000000000000, "ABORT, PARITY, SERR, PERR, MASTER_TOUT, RETRY_CNT" ],
);

%pic_01_00034_def =
( NAME    => "BUS0_RESET_INT_STATUS",
  ADDRESS => 0x00000110,
  NOTE    => "Reset Interrupt Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00034_flds
);


##########################################################################
#                                                                        #
#   BUS0_INT_MODE                                                        #
#                                                                        #
##########################################################################

%pic_01_00035_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,   8,  56, 0xFFFFFFFFFFFFFF00, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "EN_CLR_PKT"                   => [   1,   0,   8, 0x00000000000000FF, 0x00, 0, 0x0000000000000000, "EN_CLR_PKT[i]=1 enables PIC to send an interrupt clear packet" ],
);

%pic_01_00035_def =
( NAME    => "BUS0_INT_MODE",
  ADDRESS => 0x00000118,
  NOTE    => "Interrupt Mode Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00035_flds
);


##########################################################################
#                                                                        #
#   BUS0_INT_DEV                                                         #
#                                                                        #
##########################################################################

%pic_01_00036_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD7"                        => [   0,  23,  41, 0xFFFFFFFFFF800000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT7_DEV"                     => [   1,  21,   2, 0x0000000000600000, 0x00, 0, 0x0000000000000000, "Binary number of the device for interrupt 7 (INT7)." ],
   "RSVD6"                        => [   2,  20,   1, 0x0000000000100000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT6_DEV"                     => [   3,  18,   2, 0x00000000000C0000, 0x00, 0, 0x0000000000000000, "Binary number of the device for interrupt 6 (INT6)." ],
   "RSVD5"                        => [   4,  17,   1, 0x0000000000020000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT5_DEV"                     => [   5,  15,   2, 0x0000000000018000, 0x00, 0, 0x0000000000000000, "Binary number of the device for interrupt 5 (INT5)." ],
   "RSVD4"                        => [   6,  14,   1, 0x0000000000004000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT4_DEV"                     => [   7,  12,   2, 0x0000000000003000, 0x00, 0, 0x0000000000000000, "Binary number of the device for interrupt 4 (INT4)." ],
   "RSVD3"                        => [   8,  11,   1, 0x0000000000000800, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT3_DEV"                     => [   9,   9,   2, 0x0000000000000600, 0x00, 0, 0x0000000000000000, "Binary number of the device for interrupt 3 (INT3)." ],
   "RSVD2"                        => [  10,   8,   1, 0x0000000000000100, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT2_DEV"                     => [  11,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Binary number of the device for interrupt 2 (INT2)." ],
   "RSVD1"                        => [  12,   5,   1, 0x0000000000000020, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT1_DEV"                     => [  13,   3,   2, 0x0000000000000018, 0x00, 0, 0x0000000000000000, "Binary number of the device for interrupt 1 (INT1)." ],
   "RSVD0"                        => [  14,   2,   1, 0x0000000000000004, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT0_DEV"                     => [  15,   0,   2, 0x0000000000000003, 0x00, 0, 0x0000000000000000, "Binary number of the device for interrupt 0 (INT0)." ],
);

%pic_01_00036_def =
( NAME    => "BUS0_INT_DEV",
  ADDRESS => 0x00000120,
  NOTE    => "Interrupt Device Select Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00036_flds
);


##########################################################################
#                                                                        #
#   BUS0_HOST_ERR_FIELD                                                  #
#                                                                        #
##########################################################################

%pic_01_00037_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,   8,  56, 0xFFFFFFFFFFFFFF00, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BRIDGE_ERR_FLD"               => [   1,   0,   8, 0x00000000000000FF, 0x00, 0, 0x0000000000000000, "Bit location of PCI Bridge error in host interrupt register." ],
);

%pic_01_00037_def =
( NAME    => "BUS0_HOST_ERR_FIELD",
  ADDRESS => 0x00000128,
  NOTE    => "Host Error Interrupt Field Register (Crosstalk)",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00037_flds
);


##########################################################################
#                                                                        #
#   BUS0_INT0_HOST_ADDR                                                  #
#                                                                        #
##########################################################################

%pic_01_00038_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  56,   8, 0xFF00000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT_FLD"                      => [   1,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Bit location of INT_N_X in Host interrupt register" ],
   "INT_ADDR"                     => [   2,   0,  48, 0x0000FFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Contains the host address field for interrupt X" ],
);

%pic_01_00038_def =
( NAME    => "BUS0_INT0_HOST_ADDR",
  ADDRESS => 0x00000130,
  NOTE    => "Interrupt X Host register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00038_flds
);


##########################################################################
#                                                                        #
#   BUS0_INT1_HOST_ADDR                                                  #
#                                                                        #
##########################################################################

%pic_01_00039_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  56,   8, 0xFF00000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT_FLD"                      => [   1,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Bit location of INT_N_1 in Host interrupt register" ],
   "INT_ADDR"                     => [   2,   0,  48, 0x0000FFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Contains the host address field for interrupt 1" ],
);

%pic_01_00039_def =
( NAME    => "BUS0_INT1_HOST_ADDR",
  ADDRESS => 0x00000138,
  NOTE    => "Interrupt 1 Host register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00039_flds
);


##########################################################################
#                                                                        #
#   BUS0_INT2_HOST_ADDR                                                  #
#                                                                        #
##########################################################################

%pic_01_00040_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  56,   8, 0xFF00000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT_FLD"                      => [   1,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Bit location of INT_N_2 in Host interrupt register" ],
   "INT_ADDR"                     => [   2,   0,  48, 0x0000FFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Contains the host address field for interrupt 2" ],
);

%pic_01_00040_def =
( NAME    => "BUS0_INT2_HOST_ADDR",
  ADDRESS => 0x00000140,
  NOTE    => "Interrupt 2 Host register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00040_flds
);


##########################################################################
#                                                                        #
#   BUS0_INT3_HOST_ADDR                                                  #
#                                                                        #
##########################################################################

%pic_01_00041_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  56,   8, 0xFF00000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT_FLD"                      => [   1,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Bit location of INT_N_3 in Host interrupt register" ],
   "INT_ADDR"                     => [   2,   0,  48, 0x0000FFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Contains the host address field for interrupt 3" ],
);

%pic_01_00041_def =
( NAME    => "BUS0_INT3_HOST_ADDR",
  ADDRESS => 0x00000148,
  NOTE    => "Interrupt 3 Host register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00041_flds
);


##########################################################################
#                                                                        #
#   BUS0_INT4_HOST_ADDR                                                  #
#                                                                        #
##########################################################################

%pic_01_00042_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  56,   8, 0xFF00000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT_FLD"                      => [   1,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Bit location of INT_N_4 in Host interrupt register" ],
   "INT_ADDR"                     => [   2,   0,  48, 0x0000FFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Contains the host address field for interrupt 4" ],
);

%pic_01_00042_def =
( NAME    => "BUS0_INT4_HOST_ADDR",
  ADDRESS => 0x00000150,
  NOTE    => "Interrupt 4 Host register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00042_flds
);


##########################################################################
#                                                                        #
#   BUS0_INT5_HOST_ADDR                                                  #
#                                                                        #
##########################################################################

%pic_01_00043_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  56,   8, 0xFF00000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT_FLD"                      => [   1,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Bit location of INT_N_5 in Host interrupt register" ],
   "INT_ADDR"                     => [   2,   0,  48, 0x0000FFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Contains the host address field for interrupt 5" ],
);

%pic_01_00043_def =
( NAME    => "BUS0_INT5_HOST_ADDR",
  ADDRESS => 0x00000158,
  NOTE    => "Interrupt 5 Host register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00043_flds
);


##########################################################################
#                                                                        #
#   BUS0_INT6_HOST_ADDR                                                  #
#                                                                        #
##########################################################################

%pic_01_00044_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  56,   8, 0xFF00000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT_FLD"                      => [   1,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Bit location of INT_N_6 in Host interrupt register" ],
   "INT_ADDR"                     => [   2,   0,  48, 0x0000FFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Contains the host address field for interrupt 6" ],
);

%pic_01_00044_def =
( NAME    => "BUS0_INT6_HOST_ADDR",
  ADDRESS => 0x00000160,
  NOTE    => "Interrupt 6 Host register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00044_flds
);


##########################################################################
#                                                                        #
#   BUS0_INT7_HOST_ADDR                                                  #
#                                                                        #
##########################################################################

%pic_01_00045_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  56,   8, 0xFF00000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT_FLD"                      => [   1,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Bit location of INT_N_7 in Host interrupt register" ],
   "INT_ADDR"                     => [   2,   0,  48, 0x0000FFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Contains the host address field for interrupt 7" ],
);

%pic_01_00045_def =
( NAME    => "BUS0_INT7_HOST_ADDR",
  ADDRESS => 0x00000168,
  NOTE    => "Interrupt 7 Host register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00045_flds
);


##########################################################################
#                                                                        #
#   BUS0_ERR_INT_VIEW                                                    #
#                                                                        #
##########################################################################

%pic_01_00046_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  46,  18, 0xFFFFC00000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PCI_X_SPLIT_MES_PE"           => [   1,  45,   1, 0x0000200000000000, 0x00, 0, 0x0000000000000000, "PCI-X Split Completion Message Parity Error" ],
   "PCI_X_SPLIT_EMESS"            => [   2,  44,   1, 0x0000100000000000, 0x00, 0, 0x0000000000000000, "PCI-X Split Completion Error Message" ],
   "PCI_X_SPLIT_TO"               => [   3,  43,   1, 0x0000080000000000, 0x00, 0, 0x0000000000000000, "PCI-X Split Completion Timeout" ],
   "PCI_X_UNEX_COMP"              => [   4,  42,   1, 0x0000040000000000, 0x00, 0, 0x0000000000000000, "PCI-X Unexpected Completion cycle to master" ],
   "INT_RAM_PERR"                 => [   5,  41,   1, 0x0000020000000000, 0x00, 0, 0x0000000000000000, "Internal Ram Parity Error" ],
   "PCI_X_ARB_ERR"                => [   6,  40,   1, 0x0000010000000000, 0x00, 0, 0x0000000000000000, "PCI-X Arb Error" ],
   "PCI_X_REQ_TOUT"               => [   7,  39,   1, 0x0000008000000000, 0x00, 0, 0x0000000000000000, "PCI-X Read Request Time Out" ],
   "PCI_X_TABORT"                 => [   8,  38,   1, 0x0000004000000000, 0x00, 0, 0x0000000000000000, "PCI-X Target Abort" ],
   "PCI_X_PERR"                   => [   9,  37,   1, 0x0000002000000000, 0x00, 0, 0x0000000000000000, "PCI-X PERR" ],
   "PCI_X_SERR"                   => [  10,  36,   1, 0x0000001000000000, 0x00, 0, 0x0000000000000000, "PCI-X SERR" ],
   "PCI_X_MRETRY"                 => [  11,  35,   1, 0x0000000800000000, 0x00, 0, 0x0000000000000000, "PCI-X pio retry counter exhausted" ],
   "PCI_X_MTOUT"                  => [  12,  34,   1, 0x0000000400000000, 0x00, 0, 0x0000000000000000, "PCI-X Master Timeout" ],
   "PCI_X_DA_PARITY"              => [  13,  33,   1, 0x0000000200000000, 0x00, 0, 0x0000000000000000, "PCI-X Data cycle parity error" ],
   "PCI_X_AD_PARITY"              => [  14,  32,   1, 0x0000000100000000, 0x00, 0, 0x0000000000000000, "PCI-X Address or Attribute cycle parity error" ],
   "RSVD1"                        => [  15,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PMU_PAGE_FAULT"               => [  16,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Indicates an Invalid Page Access" ],
   "UNEXPECTED_RESP"              => [  17,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "This bit indicates that an unexpected response arrived." ],
   "BAD_XRESP_PACKET"             => [  18,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Data size in command word of a response did not match" ],
   "BAD_XREQ_PACKET"              => [  19,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Data size in command word of a request did not match" ],
   "RESP_XTALK_ERROR"             => [  20,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Packet had command error bit set or the invalid sideband" ],
   "REQ_XTALK_ERROR"              => [  21,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Packet had command error bit set or the invalid sideband" ],
   "INVALID_ACCESS"               => [  22,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Request packet contains an invalid address/datasize/access" ],
   "UNSUPPORTED_XOP"              => [  23,  23,   1, 0x0000000000800000, 0x00, 0, 0x0000000000000000, "Request operation is not supported by PIC" ],
   "XREQ_FIFO_OFLOW"              => [  24,  22,   1, 0x0000000000400000, 0x00, 0, 0x0000000000000000, "Request packet overflow" ],
   "LLP_REC_SNERROR"              => [  25,  21,   1, 0x0000000000200000, 0x00, 0, 0x0000000000000000, "LLP Receiver Sequence Number Error" ],
   "LLP_REC_CBERROR"              => [  26,  20,   1, 0x0000000000100000, 0x00, 0, 0x0000000000000000, "LLP Receiver Check Bit Error" ],
   "LLP_RCTY"                     => [  27,  19,   1, 0x0000000000080000, 0x00, 0, 0x0000000000000000, "LLP Receiver Retry Count Interrupt" ],
   "LLP_TX_RETRY"                 => [  28,  18,   1, 0x0000000000040000, 0x00, 0, 0x0000000000000000, "LLP Transmitter Retry" ],
   "LLP_TCTY"                     => [  29,  17,   1, 0x0000000000020000, 0x00, 0, 0x0000000000000000, "LLP Transmitter Retry Count Interrupt" ],
   "RSVD2"                        => [  30,  16,   1, 0x0000000000010000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PCI_ABORT"                    => [  31,  15,   1, 0x0000000000008000, 0x00, 0, 0x0000000000000000, "Status of PCI slave abort condition interrupt" ],
   "PCI_PARITY"                   => [  32,  14,   1, 0x0000000000004000, 0x00, 0, 0x0000000000000000, "Indicates the PIC detected a parity error." ],
   "PCI_SERR"                     => [  33,  13,   1, 0x0000000000002000, 0x00, 0, 0x0000000000000000, "Status PCI Address/CMD parity error interrupt" ],
   "PCI_PERR"                     => [  34,  12,   1, 0x0000000000001000, 0x00, 0, 0x0000000000000000, "Status of PCI parity error interrupt" ],
   "PCI_MASTER_TOUT"              => [  35,  11,   1, 0x0000000000000800, 0x00, 0, 0x0000000000000000, "Indicates a device select timeout" ],
   "PCI_RETRY_CNT"                => [  36,  10,   1, 0x0000000000000400, 0x00, 0, 0x0000000000000000, "PCI retry operation count exhausted." ],
   "XREAD_REQ_TOUT"               => [  37,   9,   1, 0x0000000000000200, 0x00, 0, 0x0000000000000000, "PCI to Crosstalk read request timeout." ],
   "RSVD3"                        => [  38,   0,   9, 0x00000000000001FF, 0x00, 0, 0x0000000000000000, "Reserved" ],
);

%pic_01_00046_def =
( NAME    => "BUS0_ERR_INT_VIEW",
  ADDRESS => 0x00000170,
  NOTE    => "Error Interrupt View Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00046_flds
);


##########################################################################
#                                                                        #
#   BUS0_MULT_INT                                                        #
#                                                                        #
##########################################################################

%pic_01_00047_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  46,  18, 0xFFFFC00000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PCI_X_SPLIT_MES_PE"           => [   1,  45,   1, 0x0000200000000000, 0x00, 0, 0x0000000000000000, "PCI-X Split Completion Message Parity Error" ],
   "PCI_X_SPLIT_EMESS"            => [   2,  44,   1, 0x0000100000000000, 0x00, 0, 0x0000000000000000, "PCI-X Split Completion Error Message" ],
   "PCI_X_SPLIT_TO"               => [   3,  43,   1, 0x0000080000000000, 0x00, 0, 0x0000000000000000, "PCI-X Split Completion Timeout" ],
   "PCI_X_UNEX_COMP"              => [   4,  42,   1, 0x0000040000000000, 0x00, 0, 0x0000000000000000, "PCI-X Unexpected Completion cycle to master" ],
   "INT_RAM_PERR"                 => [   5,  41,   1, 0x0000020000000000, 0x00, 0, 0x0000000000000000, "Internal Ram Parity Error" ],
   "PCI_X_ARB_ERR"                => [   6,  40,   1, 0x0000010000000000, 0x00, 0, 0x0000000000000000, "PCI-X Arb Error" ],
   "PCI_X_REQ_TOUT"               => [   7,  39,   1, 0x0000008000000000, 0x00, 0, 0x0000000000000000, "PCI-X Read Request Time Out" ],
   "PCI_X_TABORT"                 => [   8,  38,   1, 0x0000004000000000, 0x00, 0, 0x0000000000000000, "PCI-X Target Abort" ],
   "PCI_X_PERR"                   => [   9,  37,   1, 0x0000002000000000, 0x00, 0, 0x0000000000000000, "PCI-X PERR" ],
   "PCI_X_SERR"                   => [  10,  36,   1, 0x0000001000000000, 0x00, 0, 0x0000000000000000, "PCI-X SERR" ],
   "PCI_X_MRETRY"                 => [  11,  35,   1, 0x0000000800000000, 0x00, 0, 0x0000000000000000, "PCI-X pio retry counter exhausted" ],
   "PCI_X_MTOUT"                  => [  12,  34,   1, 0x0000000400000000, 0x00, 0, 0x0000000000000000, "PCI-X Master Timeout, PCI target device did not respond with devsel." ],
   "PCI_X_DA_PARITY"              => [  13,  33,   1, 0x0000000200000000, 0x00, 0, 0x0000000000000000, "PCI-X Data cycle parity error detected by PIC" ],
   "PCI_X_AD_PARITY"              => [  14,  32,   1, 0x0000000100000000, 0x00, 0, 0x0000000000000000, "PCI-X Address or Attribute cycle parity error detected by PIC" ],
   "RSVD1"                        => [  15,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PMU_PAGE_FAULT"               => [  16,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Indicates an Invalid Page Access" ],
   "UNEXPECTED_RESP"              => [  17,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "This bit indicates that an unexpected response arrived." ],
   "BAD_XRESP_PACKET"             => [  18,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "" ],
   "BAD_XREQ_PACKET"              => [  19,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "" ],
   "RESP_XTALK_ERROR"             => [  20,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "" ],
   "REQ_XTALK_ERROR"              => [  21,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "" ],
   "INVALID_ACCESS"               => [  22,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "" ],
   "UNSUPPORTED_XOP"              => [  23,  23,   1, 0x0000000000800000, 0x00, 0, 0x0000000000000000, "Request operation is not supported by PIC" ],
   "XREQ_FIFO_OFLOW"              => [  24,  22,   1, 0x0000000000400000, 0x00, 0, 0x0000000000000000, "Request packet overflow" ],
   "LLP_REC_SNERROR"              => [  25,  21,   1, 0x0000000000200000, 0x00, 0, 0x0000000000000000, "LLP Receiver Sequence Number Error" ],
   "LLP_REC_CBERROR"              => [  26,  20,   1, 0x0000000000100000, 0x00, 0, 0x0000000000000000, "LLP Receiver Check Bit Error" ],
   "LLP_RCTY"                     => [  27,  19,   1, 0x0000000000080000, 0x00, 0, 0x0000000000000000, "LLP Receiver Retry Count Interrupt" ],
   "LLP_TX_RETRY"                 => [  28,  18,   1, 0x0000000000040000, 0x00, 0, 0x0000000000000000, "LLP Transmitter Retry" ],
   "LLP_TCTY"                     => [  29,  17,   1, 0x0000000000020000, 0x00, 0, 0x0000000000000000, "LLP Transmitter Retry Count Interrupt" ],
   "RSVD2"                        => [  30,  16,   1, 0x0000000000010000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PCI_ABORT"                    => [  31,  15,   1, 0x0000000000008000, 0x00, 0, 0x0000000000000000, "Status of PCI slave abort condition interrupt" ],
   "PCI_PARITY"                   => [  32,  14,   1, 0x0000000000004000, 0x00, 0, 0x0000000000000000, "Indicates the PIC detected a parity error." ],
   "PCI_SERR"                     => [  33,  13,   1, 0x0000000000002000, 0x00, 0, 0x0000000000000000, "Status PCI Address/CMD parity error interrupt" ],
   "PCI_PERR"                     => [  34,  12,   1, 0x0000000000001000, 0x00, 0, 0x0000000000000000, "Status of PCI parity error interrupt" ],
   "PCI_MASTER_TOUT"              => [  35,  11,   1, 0x0000000000000800, 0x00, 0, 0x0000000000000000, "Indicates a device select timeout" ],
   "PCI_RETRY_CNT"                => [  36,  10,   1, 0x0000000000000400, 0x00, 0, 0x0000000000000000, "PCI retry operation count exhausted." ],
   "XREAD_REQ_TOUT"               => [  37,   9,   1, 0x0000000000000200, 0x00, 0, 0x0000000000000000, "PCI to Crosstalk read request timeout." ],
   "RSVD3"                        => [  38,   8,   1, 0x0000000000000100, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT_STATE"                    => [  39,   0,   8, 0x00000000000000FF, 0x00, 0, 0x0000000000000000, "Status of INT_N[7:0]. A 1 means INT_N is low." ],
);

%pic_01_00047_def =
( NAME    => "BUS0_MULT_INT",
  ADDRESS => 0x00000178,
  NOTE    => "PIC INT_STATUS Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00047_flds
);


##########################################################################
#                                                                        #
#   BUS0_INT0_FORCE_ALWAYS                                               #
#                                                                        #
##########################################################################

%pic_01_00048_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00048_def =
( NAME    => "BUS0_INT0_FORCE_ALWAYS",
  ADDRESS => 0x00000180,
  NOTE    => "Force Always Interrupt 0 Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00048_flds
);


##########################################################################
#                                                                        #
#   BUS0_INT1_FORCE_ALWAYS                                               #
#                                                                        #
##########################################################################

%pic_01_00049_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00049_def =
( NAME    => "BUS0_INT1_FORCE_ALWAYS",
  ADDRESS => 0x00000188,
  NOTE    => "Force Always Interrupt 1 Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00049_flds
);


##########################################################################
#                                                                        #
#   BUS0_INT2_FORCE_ALWAYS                                               #
#                                                                        #
##########################################################################

%pic_01_00050_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00050_def =
( NAME    => "BUS0_INT2_FORCE_ALWAYS",
  ADDRESS => 0x00000190,
  NOTE    => "Force Always Interrupt 2 Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00050_flds
);


##########################################################################
#                                                                        #
#   BUS0_INT3_FORCE_ALWAYS                                               #
#                                                                        #
##########################################################################

%pic_01_00051_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00051_def =
( NAME    => "BUS0_INT3_FORCE_ALWAYS",
  ADDRESS => 0x00000198,
  NOTE    => "Force Always Interrupt 3 Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00051_flds
);


##########################################################################
#                                                                        #
#   BUS0_INT4_FORCE_ALWAYS                                               #
#                                                                        #
##########################################################################

%pic_01_00052_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00052_def =
( NAME    => "BUS0_INT4_FORCE_ALWAYS",
  ADDRESS => 0x000001A0,
  NOTE    => "Force Always Interrupt 4 Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00052_flds
);


##########################################################################
#                                                                        #
#   BUS0_INT5_FORCE_ALWAYS                                               #
#                                                                        #
##########################################################################

%pic_01_00053_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00053_def =
( NAME    => "BUS0_INT5_FORCE_ALWAYS",
  ADDRESS => 0x000001A8,
  NOTE    => "Force Always Interrupt 5 Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00053_flds
);


##########################################################################
#                                                                        #
#   BUS0_INT6_FORCE_ALWAYS                                               #
#                                                                        #
##########################################################################

%pic_01_00054_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00054_def =
( NAME    => "BUS0_INT6_FORCE_ALWAYS",
  ADDRESS => 0x000001B0,
  NOTE    => "Force Always Interrupt 6 Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00054_flds
);


##########################################################################
#                                                                        #
#   BUS0_INT7_FORCE_ALWAYS                                               #
#                                                                        #
##########################################################################

%pic_01_00055_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00055_def =
( NAME    => "BUS0_INT7_FORCE_ALWAYS",
  ADDRESS => 0x000001B8,
  NOTE    => "Force Always Interrupt 7 Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00055_flds
);


##########################################################################
#                                                                        #
#   BUS0_INT0_FORCE_PIN_REG                                              #
#                                                                        #
##########################################################################

%pic_01_00056_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00056_def =
( NAME    => "BUS0_INT0_FORCE_PIN_REG",
  ADDRESS => 0x000001C0,
  NOTE    => "Force Interrupt 0 Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00056_flds
);


##########################################################################
#                                                                        #
#   BUS0_INT1_FORCE_PIN_REG                                              #
#                                                                        #
##########################################################################

%pic_01_00057_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00057_def =
( NAME    => "BUS0_INT1_FORCE_PIN_REG",
  ADDRESS => 0x000001C8,
  NOTE    => "Force Interrupt 1 Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00057_flds
);


##########################################################################
#                                                                        #
#   BUS0_INT2_FORCE_PIN_REG                                              #
#                                                                        #
##########################################################################

%pic_01_00058_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00058_def =
( NAME    => "BUS0_INT2_FORCE_PIN_REG",
  ADDRESS => 0x000001D0,
  NOTE    => "Force Interrupt 2 Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00058_flds
);


##########################################################################
#                                                                        #
#   BUS0_INT3_FORCE_PIN_REG                                              #
#                                                                        #
##########################################################################

%pic_01_00059_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00059_def =
( NAME    => "BUS0_INT3_FORCE_PIN_REG",
  ADDRESS => 0x000001D8,
  NOTE    => "Force Interrupt 3 Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00059_flds
);


##########################################################################
#                                                                        #
#   BUS0_INT4_FORCE_PIN_REG                                              #
#                                                                        #
##########################################################################

%pic_01_00060_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00060_def =
( NAME    => "BUS0_INT4_FORCE_PIN_REG",
  ADDRESS => 0x000001E0,
  NOTE    => "Force Interrupt 4 Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00060_flds
);


##########################################################################
#                                                                        #
#   BUS0_INT5_FORCE_PIN_REG                                              #
#                                                                        #
##########################################################################

%pic_01_00061_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00061_def =
( NAME    => "BUS0_INT5_FORCE_PIN_REG",
  ADDRESS => 0x000001E8,
  NOTE    => "Force Interrupt 5 Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00061_flds
);


##########################################################################
#                                                                        #
#   BUS0_INT6_FORCE_PIN_REG                                              #
#                                                                        #
##########################################################################

%pic_01_00062_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00062_def =
( NAME    => "BUS0_INT6_FORCE_PIN_REG",
  ADDRESS => 0x000001F0,
  NOTE    => "Force Interrupt 6 Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00062_flds
);


##########################################################################
#                                                                        #
#   BUS0_INT7_FORCE_PIN_REG                                              #
#                                                                        #
##########################################################################

%pic_01_00063_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00063_def =
( NAME    => "BUS0_INT7_FORCE_PIN_REG",
  ADDRESS => 0x000001F8,
  NOTE    => "Force Interrupt 7 Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00063_flds
);


##########################################################################
#                                                                        #
#   BUS0_DEV0_REG                                                        #
#                                                                        #
##########################################################################

%pic_01_00064_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  29,   3, 0x00000000E0000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "EN_ERROR_LOCK"                => [   2,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Enable the Error Lock" ],
   "EN_PAGE_CHK"                  => [   3,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Enable Prefetcher Page Cross Checking" ],
   "FORCE_PCI_PAR"                => [   4,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Force a PCI parity error" ],
   "EN_VIRTUAL"                   => [   5,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Enable Virtual Device" ],
   "RSVD2"                        => [   6,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "DIR_WRT_GEN"                  => [   7,  23,   1, 0x0000000000800000, 0x00, 0, 0x0000000000000000, "Direct Mapped Write Gather Enable" ],
   "DEV_SIZE"                     => [   8,  22,   1, 0x0000000000400000, 0x00, 0, 0x0000000000000000, "Device Size" ],
   "REAL_TIME"                    => [   9,  21,   1, 0x0000000000200000, 0x00, 0, 0x0000000000000000, "Real Time Device Enable (1 => enabled)" ],
   "RSVD3"                        => [  10,  20,   1, 0x0000000000100000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "SWAP_DIRECT"                  => [  11,  19,   1, 0x0000000000080000, 0x00, 0, 0x0000000000000000, "Enable Swapping in Direct Map Mode (1 => enabled)" ],
   "PREFETCH"                     => [  12,  18,   1, 0x0000000000040000, 0x00, 0, 0x0000000000000000, "Prefetcher Enable" ],
   "PRECISE"                      => [  13,  17,   1, 0x0000000000020000, 0x00, 0, 0x0000000000000000, "Precise Transaction" ],
   "COHERENT"                     => [  14,  16,   1, 0x0000000000010000, 0x00, 0, 0x0000000000000000, "Coherent Transaction (1 => coherent)" ],
   "BARRIER"                      => [  15,  15,   1, 0x0000000000008000, 0x00, 0, 0x0000000000000000, "Barrier Transaction (1 => barrier)" ],
   "GBR"                          => [  16,  14,   1, 0x0000000000004000, 0x00, 0, 0x0000000000000000, "GBR Enable (1 => enabled)" ],
   "DEV_SWAP"                     => [  17,  13,   1, 0x0000000000002000, 0x00, 0, 0x0000000000000000, "Device Enable Swapping (1 => enabled)" ],
   "DEV_IO_MEM"                   => [  18,  12,   1, 0x0000000000001000, 0x00, 0, 0x0000000000000000, "Enable Device Memory or I/O Space" ],
   "DEV_OFF"                      => [  19,   0,  12, 0x0000000000000FFF, 0x00, 0, 0x0000000000000000, "Device Offset Address Bits 31:20" ],
);

%pic_01_00064_def =
( NAME    => "BUS0_DEV0_REG",
  ADDRESS => 0x00000200,
  NOTE    => "Device 0 Registers",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00064_flds
);


##########################################################################
#                                                                        #
#   BUS0_DEV1_REG                                                        #
#                                                                        #
##########################################################################

%pic_01_00065_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  29,   3, 0x00000000E0000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "EN_ERROR_LOCK"                => [   2,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Enable the Error Lock" ],
   "EN_PAGE_CHK"                  => [   3,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Enable Prefetcher Page Cross Checking" ],
   "FORCE_PCI_PAR"                => [   4,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Force a PCI parity error" ],
   "EN_VIRTUAL"                   => [   5,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Enable Virtual Device" ],
   "RSVD2"                        => [   6,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "DIR_WRT_GEN"                  => [   7,  23,   1, 0x0000000000800000, 0x00, 0, 0x0000000000000000, "Direct Mapped Write Gather Enable" ],
   "DEV_SIZE"                     => [   8,  22,   1, 0x0000000000400000, 0x00, 0, 0x0000000000000000, "Device Size" ],
   "REAL_TIME"                    => [   9,  21,   1, 0x0000000000200000, 0x00, 0, 0x0000000000000000, "Real Time Device Enable (1 => enabled)" ],
   "RSVD3"                        => [  10,  20,   1, 0x0000000000100000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "SWAP_DIRECT"                  => [  11,  19,   1, 0x0000000000080000, 0x00, 0, 0x0000000000000000, "Enable Swapping in Direct Map Mode (1 => enabled)" ],
   "PREFETCH"                     => [  12,  18,   1, 0x0000000000040000, 0x00, 0, 0x0000000000000000, "Prefetcher Enable" ],
   "PRECISE"                      => [  13,  17,   1, 0x0000000000020000, 0x00, 0, 0x0000000000000000, "Precise Transaction" ],
   "COHERENT"                     => [  14,  16,   1, 0x0000000000010000, 0x00, 0, 0x0000000000000000, "Coherent Transaction (1 => coherent)" ],
   "BARRIER"                      => [  15,  15,   1, 0x0000000000008000, 0x00, 0, 0x0000000000000000, "Barrier Transaction (1 => barrier)" ],
   "GBR"                          => [  16,  14,   1, 0x0000000000004000, 0x00, 0, 0x0000000000000000, "GBR Enable (1 => enabled)" ],
   "DEV_SWAP"                     => [  17,  13,   1, 0x0000000000002000, 0x00, 0, 0x0000000000000000, "Device Enable Swapping (1 => enabled)" ],
   "DEV_IO_MEM"                   => [  18,  12,   1, 0x0000000000001000, 0x00, 0, 0x0000000000000000, "Enable Device Memory or I/O Space" ],
   "DEV_OFF"                      => [  19,   0,  12, 0x0000000000000FFF, 0x00, 0, 0x0000000000000000, "Device Offset Address Bits 31:20" ],
);

%pic_01_00065_def =
( NAME    => "BUS0_DEV1_REG",
  ADDRESS => 0x00000208,
  NOTE    => "Device 1 Registers",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00065_flds
);


##########################################################################
#                                                                        #
#   BUS0_DEV2_REG                                                        #
#                                                                        #
##########################################################################

%pic_01_00066_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  29,   3, 0x00000000E0000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "EN_ERROR_LOCK"                => [   2,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Enable the Error Lock" ],
   "EN_PAGE_CHK"                  => [   3,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Enable Prefetcher Page Cross Checking" ],
   "FORCE_PCI_PAR"                => [   4,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Force a PCI parity error" ],
   "EN_VIRTUAL"                   => [   5,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Enable Virtual Device" ],
   "RSVD2"                        => [   6,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "DIR_WRT_GEN"                  => [   7,  23,   1, 0x0000000000800000, 0x00, 0, 0x0000000000000000, "Direct Mapped Write Gather Enable" ],
   "DEV_SIZE"                     => [   8,  22,   1, 0x0000000000400000, 0x00, 0, 0x0000000000000000, "Device Size" ],
   "REAL_TIME"                    => [   9,  21,   1, 0x0000000000200000, 0x00, 0, 0x0000000000000000, "Real Time Device Enable (1 => enabled)" ],
   "RSVD3"                        => [  10,  20,   1, 0x0000000000100000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "SWAP_DIRECT"                  => [  11,  19,   1, 0x0000000000080000, 0x00, 0, 0x0000000000000000, "Enable Swapping in Direct Map Mode (1 => enabled)" ],
   "PREFETCH"                     => [  12,  18,   1, 0x0000000000040000, 0x00, 0, 0x0000000000000000, "Prefetcher Enable" ],
   "PRECISE"                      => [  13,  17,   1, 0x0000000000020000, 0x00, 0, 0x0000000000000000, "Precise Transaction" ],
   "COHERENT"                     => [  14,  16,   1, 0x0000000000010000, 0x00, 0, 0x0000000000000000, "Coherent Transaction (1 => coherent)" ],
   "BARRIER"                      => [  15,  15,   1, 0x0000000000008000, 0x00, 0, 0x0000000000000000, "Barrier Transaction (1 => barrier)" ],
   "GBR"                          => [  16,  14,   1, 0x0000000000004000, 0x00, 0, 0x0000000000000000, "GBR Enable (1 => enabled)" ],
   "DEV_SWAP"                     => [  17,  13,   1, 0x0000000000002000, 0x00, 0, 0x0000000000000000, "Device Enable Swapping (1 => enabled)" ],
   "DEV_IO_MEM"                   => [  18,  12,   1, 0x0000000000001000, 0x00, 0, 0x0000000000000000, "Enable Device Memory or I/O Space" ],
   "DEV_OFF"                      => [  19,   0,  12, 0x0000000000000FFF, 0x00, 0, 0x0000000000000000, "Device Offset Address Bits 31:20" ],
);

%pic_01_00066_def =
( NAME    => "BUS0_DEV2_REG",
  ADDRESS => 0x00000210,
  NOTE    => "Device 2 Registers",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00066_flds
);


##########################################################################
#                                                                        #
#   BUS0_DEV3_REG                                                        #
#                                                                        #
##########################################################################

%pic_01_00067_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  29,   3, 0x00000000E0000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "EN_ERROR_LOCK"                => [   2,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Enable the Error Lock" ],
   "EN_PAGE_CHK"                  => [   3,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Enable Prefetcher Page Cross Checking" ],
   "FORCE_PCI_PAR"                => [   4,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Force a PCI parity error" ],
   "EN_VIRTUAL"                   => [   5,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Enable Virtual Device" ],
   "RSVD2"                        => [   6,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "DIR_WRT_GEN"                  => [   7,  23,   1, 0x0000000000800000, 0x00, 0, 0x0000000000000000, "Direct Mapped Write Gather Enable" ],
   "DEV_SIZE"                     => [   8,  22,   1, 0x0000000000400000, 0x00, 0, 0x0000000000000000, "Device Size" ],
   "REAL_TIME"                    => [   9,  21,   1, 0x0000000000200000, 0x00, 0, 0x0000000000000000, "Real Time Device Enable (1 => enabled)" ],
   "RSVD3"                        => [  10,  20,   1, 0x0000000000100000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "SWAP_DIRECT"                  => [  11,  19,   1, 0x0000000000080000, 0x00, 0, 0x0000000000000000, "Enable Swapping in Direct Map Mode (1 => enabled)" ],
   "PREFETCH"                     => [  12,  18,   1, 0x0000000000040000, 0x00, 0, 0x0000000000000000, "Prefetcher Enable" ],
   "PRECISE"                      => [  13,  17,   1, 0x0000000000020000, 0x00, 0, 0x0000000000000000, "Precise Transaction" ],
   "COHERENT"                     => [  14,  16,   1, 0x0000000000010000, 0x00, 0, 0x0000000000000000, "Coherent Transaction (1 => coherent)" ],
   "BARRIER"                      => [  15,  15,   1, 0x0000000000008000, 0x00, 0, 0x0000000000000000, "Barrier Transaction (1 => barrier)" ],
   "GBR"                          => [  16,  14,   1, 0x0000000000004000, 0x00, 0, 0x0000000000000000, "GBR Enable (1 => enabled)" ],
   "DEV_SWAP"                     => [  17,  13,   1, 0x0000000000002000, 0x00, 0, 0x0000000000000000, "Device Enable Swapping (1 => enabled)" ],
   "DEV_IO_MEM"                   => [  18,  12,   1, 0x0000000000001000, 0x00, 0, 0x0000000000000000, "Enable Device Memory or I/O Space" ],
   "DEV_OFF"                      => [  19,   0,  12, 0x0000000000000FFF, 0x00, 0, 0x0000000000000000, "Device Offset Address Bits 31:20" ],
);

%pic_01_00067_def =
( NAME    => "BUS0_DEV3_REG",
  ADDRESS => 0x00000218,
  NOTE    => "Device 3 Registers",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00067_flds
);


##########################################################################
#                                                                        #
#   BUS0_DEV0_WR_FLUSH                                                   #
#                                                                        #
##########################################################################

%pic_01_00068_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00068_def =
( NAME    => "BUS0_DEV0_WR_FLUSH",
  ADDRESS => 0x00000240,
  NOTE    => "Device 0 Write Request Buffer Flush",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00068_flds
);


##########################################################################
#                                                                        #
#   BUS0_DEV1_WR_FLUSH                                                   #
#                                                                        #
##########################################################################

%pic_01_00069_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00069_def =
( NAME    => "BUS0_DEV1_WR_FLUSH",
  ADDRESS => 0x00000248,
  NOTE    => "Device 1 Write Request Buffer Flush",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00069_flds
);


##########################################################################
#                                                                        #
#   BUS0_DEV2_WR_FLUSH                                                   #
#                                                                        #
##########################################################################

%pic_01_00070_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00070_def =
( NAME    => "BUS0_DEV2_WR_FLUSH",
  ADDRESS => 0x00000250,
  NOTE    => "Device 2 Write Request Buffer Flush",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00070_flds
);


##########################################################################
#                                                                        #
#   BUS0_DEV3_WR_FLUSH                                                   #
#                                                                        #
##########################################################################

%pic_01_00071_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00071_def =
( NAME    => "BUS0_DEV3_WR_FLUSH",
  ADDRESS => 0x00000258,
  NOTE    => "Device 3 Write Request Buffer Flush",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00071_flds
);


##########################################################################
#                                                                        #
#   BUS0_E_DEV_RSP_BUF                                                   #
#                                                                        #
##########################################################################

%pic_01_00072_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUFF_14_EN"                   => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Enable buffer 14" ],
   "BUFF_14_VDEV"                 => [   2,  29,   2, 0x0000000060000000, 0x00, 0, 0x0000000000000000, "Virtual device select for buffer 14." ],
   "BUFF_14_PDEV"                 => [   3,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Upper bit of device number for buffer 14." ],
   "BUFF_12_EN"                   => [   4,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Enable buffer 12" ],
   "BUFF_12_VDEV"                 => [   5,  25,   2, 0x0000000006000000, 0x00, 0, 0x0000000000000000, "Virtual device select for buffer 12." ],
   "BUFF_12_PDEV"                 => [   6,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Upper bit of device number for buffer 12." ],
   "BUFF_10_EN"                   => [   7,  23,   1, 0x0000000000800000, 0x00, 0, 0x0000000000000000, "Enable buffer 10" ],
   "BUFF_10_VDEV"                 => [   8,  21,   2, 0x0000000000600000, 0x00, 0, 0x0000000000000000, "Virtual device select for buffer 10." ],
   "BUFF_10_PDEV"                 => [   9,  20,   1, 0x0000000000100000, 0x00, 0, 0x0000000000000000, "Upper bit of device number for buffer 10." ],
   "BUFF_8_EN"                    => [  10,  19,   1, 0x0000000000080000, 0x00, 0, 0x0000000000000000, "Enable buffer 8" ],
   "BUFF_8_VDEV"                  => [  11,  17,   2, 0x0000000000060000, 0x00, 0, 0x0000000000000000, "Virtual device select for buffer 8." ],
   "BUFF_8_PDEV"                  => [  12,  16,   1, 0x0000000000010000, 0x00, 0, 0x0000000000000000, "Upper bit of device number for buffer 8." ],
   "BUFF_6_EN"                    => [  13,  15,   1, 0x0000000000008000, 0x00, 0, 0x0000000000000000, "Enable buffer 6" ],
   "BUFF_6_VDEV"                  => [  14,  13,   2, 0x0000000000006000, 0x00, 0, 0x0000000000000000, "Virtual device select for buffer 6." ],
   "BUFF_6_PDEV"                  => [  15,  12,   1, 0x0000000000001000, 0x00, 0, 0x0000000000000000, "Upper bit of device number for buffer 6." ],
   "BUFF_4_EN"                    => [  16,  11,   1, 0x0000000000000800, 0x00, 0, 0x0000000000000000, "Enable buffer 4" ],
   "BUFF_4_VDEV"                  => [  17,   9,   2, 0x0000000000000600, 0x00, 0, 0x0000000000000000, "Virtual device select for buffer 4." ],
   "BUFF_4_PDEV"                  => [  18,   8,   1, 0x0000000000000100, 0x00, 0, 0x0000000000000000, "Upper bit of device number for buffer 4." ],
   "BUFF_2_EN"                    => [  19,   7,   1, 0x0000000000000080, 0x00, 0, 0x0000000000000000, "Enable buffer 2" ],
   "BUFF_2_VDEV"                  => [  20,   5,   2, 0x0000000000000060, 0x00, 0, 0x0000000000000000, "Virtual device select for buffer 2." ],
   "BUFF_2_PDEV"                  => [  21,   4,   1, 0x0000000000000010, 0x00, 0, 0x0000000000000000, "Upper bit of device number for buffer 2." ],
   "BUFF_0_EN"                    => [  22,   3,   1, 0x0000000000000008, 0x00, 0, 0x0000000000000000, "Enable buffer 0" ],
   "BUFF_0_VDEV"                  => [  23,   1,   2, 0x0000000000000006, 0x00, 0, 0x0000000000000000, "Virtual device select for buffer 0." ],
   "BUFF_0_PDEV"                  => [  24,   0,   1, 0x0000000000000001, 0x00, 0, 0x0000000000000000, "Upper bit of device number for buffer 0." ],
);

%pic_01_00072_def =
( NAME    => "BUS0_E_DEV_RSP_BUF",
  ADDRESS => 0x00000280,
  NOTE    => "Even Device Read Response Buffer Register (PCI Only)",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00072_flds
);


##########################################################################
#                                                                        #
#   BUS0_O_DEV_RSP_BUF                                                   #
#                                                                        #
##########################################################################

%pic_01_00073_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUFF_15_EN"                   => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Enable buffer 15" ],
   "BUFF_15_VDEV"                 => [   2,  29,   2, 0x0000000060000000, 0x00, 0, 0x0000000000000000, "Virtual device select for buffer 15." ],
   "BUFF_15_PDEV"                 => [   3,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Upper bit of device number for buffer 15." ],
   "BUFF_13_EN"                   => [   4,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Enable buffer 13" ],
   "BUFF_13_VDEV"                 => [   5,  25,   2, 0x0000000006000000, 0x00, 0, 0x0000000000000000, "Virtual device select for buffer 13." ],
   "BUFF_13_PDEV"                 => [   6,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Upper bit of device number for buffer 13." ],
   "BUFF_11_EN"                   => [   7,  23,   1, 0x0000000000800000, 0x00, 0, 0x0000000000000000, "Enable buffer 11" ],
   "BUFF_11_VDEV"                 => [   8,  21,   2, 0x0000000000600000, 0x00, 0, 0x0000000000000000, "Virtual device select for buffer 11." ],
   "BUFF_11_PDEV"                 => [   9,  20,   1, 0x0000000000100000, 0x00, 0, 0x0000000000000000, "Upper two bits of device number for buffer 11." ],
   "BUFF_9_EN"                    => [  10,  19,   1, 0x0000000000080000, 0x00, 0, 0x0000000000000000, "Enable buffer 9" ],
   "BUFF_9_VDEV"                  => [  11,  17,   2, 0x0000000000060000, 0x00, 0, 0x0000000000000000, "Virtual device select for buffer 9." ],
   "BUFF_9_PDEV"                  => [  12,  16,   1, 0x0000000000010000, 0x00, 0, 0x0000000000000000, "Upper bit of device number for buffer 9." ],
   "BUFF_7_EN"                    => [  13,  15,   1, 0x0000000000008000, 0x00, 0, 0x0000000000000000, "Enable buffer 7" ],
   "BUFF_7_VDEV"                  => [  14,  13,   2, 0x0000000000006000, 0x00, 0, 0x0000000000000000, "Virtual device select for buffer 7." ],
   "BUFF_7_PDEV"                  => [  15,  12,   1, 0x0000000000001000, 0x00, 0, 0x0000000000000000, "Upper bit of device number for buffer 7." ],
   "BUFF_5_EN"                    => [  16,  11,   1, 0x0000000000000800, 0x00, 0, 0x0000000000000000, "Enable buffer 5" ],
   "BUFF_5_VDEV"                  => [  17,   9,   2, 0x0000000000000600, 0x00, 0, 0x0000000000000000, "Virtual device select for buffer 5." ],
   "BUFF_5_PDEV"                  => [  18,   8,   1, 0x0000000000000100, 0x00, 0, 0x0000000000000000, "Upper bit of device number for buffer 5." ],
   "BUFF_3_EN"                    => [  19,   7,   1, 0x0000000000000080, 0x00, 0, 0x0000000000000000, "Enable buffer 3" ],
   "BUFF_3_VDEV"                  => [  20,   5,   2, 0x0000000000000060, 0x00, 0, 0x0000000000000000, "Virtual device select for buffer 3." ],
   "BUFF_3_PDEV"                  => [  21,   4,   1, 0x0000000000000010, 0x00, 0, 0x0000000000000000, "Upper bit of device number for buffer 3." ],
   "BUFF_1_EN"                    => [  22,   3,   1, 0x0000000000000008, 0x00, 0, 0x0000000000000000, "Enable buffer 1" ],
   "BUFF_1_VDEV"                  => [  23,   1,   2, 0x0000000000000006, 0x00, 0, 0x0000000000000000, "Virtual device select for buffer 1." ],
   "BUFF_1_PDEV"                  => [  24,   0,   1, 0x0000000000000001, 0x00, 0, 0x0000000000000000, "Upper bit of device number for buffer 1." ],
);

%pic_01_00073_def =
( NAME    => "BUS0_O_DEV_RSP_BUF",
  ADDRESS => 0x00000288,
  NOTE    => "Odd Device Read Response Buffer Register (PCI Only)",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00073_flds
);


##########################################################################
#                                                                        #
#   BUS0_RR_BUFF_STATUS                                                  #
#                                                                        #
##########################################################################

%pic_01_00074_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RRB_VALID"                    => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Read Response Buffer VALID bits" ],
   "RRB_INUSE"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Read Response Buffer INUSE bits" ],
);

%pic_01_00074_def =
( NAME    => "BUS0_RR_BUFF_STATUS",
  ADDRESS => 0x00000290,
  NOTE    => "Read Response Buffer Status Register (PCI Only)",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00074_flds
);


##########################################################################
#                                                                        #
#   BUS0_RR_BUFF_CLR                                                     #
#                                                                        #
##########################################################################

%pic_01_00075_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RRB_CLEAR"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Read Response Buffer CLEAR bits" ],
);

%pic_01_00075_def =
( NAME    => "BUS0_RR_BUFF_CLR",
  ADDRESS => 0x00000298,
  NOTE    => "Read Response Buffer Clear Register (PCI Only)",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00075_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_RD_RESP0_UPP                                                #
#                                                                        #
##########################################################################

%pic_01_00076_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "FILLED"                       => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Buffer has valid data" ],
   "ARMED"                        => [   2,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   3,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   4,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error" ],
   "PKTERR"                       => [   5,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   6,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   7,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   8,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   9,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [  10,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00076_def =
( NAME    => "BUS0_PCI_RD_RESP0_UPP",
  ADDRESS => 0x00000300,
  NOTE    => "PCI Read Response Buffer 0 Upper address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00076_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_RD_RESP1_UPP                                                #
#                                                                        #
##########################################################################

%pic_01_00077_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "FILLED"                       => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Buffer has valid data" ],
   "ARMED"                        => [   2,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   3,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   4,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error" ],
   "PKTERR"                       => [   5,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   6,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   7,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   8,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   9,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [  10,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00077_def =
( NAME    => "BUS0_PCI_RD_RESP1_UPP",
  ADDRESS => 0x00000310,
  NOTE    => "PCI Read Response Buffer 1 Upper address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00077_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_RD_RESP2_UPP                                                #
#                                                                        #
##########################################################################

%pic_01_00078_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "FILLED"                       => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Buffer has valid data" ],
   "ARMED"                        => [   2,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   3,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   4,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error" ],
   "PKTERR"                       => [   5,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   6,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   7,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   8,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   9,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [  10,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00078_def =
( NAME    => "BUS0_PCI_RD_RESP2_UPP",
  ADDRESS => 0x00000320,
  NOTE    => "PCI Read Response Buffer 2 Upper address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00078_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_RD_RESP3_UPP                                                #
#                                                                        #
##########################################################################

%pic_01_00079_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "FILLED"                       => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Buffer has valid data" ],
   "ARMED"                        => [   2,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   3,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   4,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error" ],
   "PKTERR"                       => [   5,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   6,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   7,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   8,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   9,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [  10,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00079_def =
( NAME    => "BUS0_PCI_RD_RESP3_UPP",
  ADDRESS => 0x00000330,
  NOTE    => "PCI Read Response Buffer 3 Upper address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00079_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_RD_RESP4_UPP                                                #
#                                                                        #
##########################################################################

%pic_01_00080_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "FILLED"                       => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Buffer has valid data" ],
   "ARMED"                        => [   2,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   3,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   4,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error" ],
   "PKTERR"                       => [   5,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   6,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   7,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   8,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   9,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [  10,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00080_def =
( NAME    => "BUS0_PCI_RD_RESP4_UPP",
  ADDRESS => 0x00000340,
  NOTE    => "PCI Read Response Buffer 4 Upper address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00080_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_RD_RESP5_UPP                                                #
#                                                                        #
##########################################################################

%pic_01_00081_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "FILLED"                       => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Buffer has valid data" ],
   "ARMED"                        => [   2,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   3,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   4,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error" ],
   "PKTERR"                       => [   5,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   6,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   7,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   8,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   9,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [  10,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00081_def =
( NAME    => "BUS0_PCI_RD_RESP5_UPP",
  ADDRESS => 0x00000350,
  NOTE    => "PCI Read Response Buffer 5 Upper address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00081_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_RD_RESP6_UPP                                                #
#                                                                        #
##########################################################################

%pic_01_00082_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "FILLED"                       => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Buffer has valid data" ],
   "ARMED"                        => [   2,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   3,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   4,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error" ],
   "PKTERR"                       => [   5,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   6,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   7,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   8,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   9,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [  10,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00082_def =
( NAME    => "BUS0_PCI_RD_RESP6_UPP",
  ADDRESS => 0x00000360,
  NOTE    => "PCI Read Response Buffer 6 Upper address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00082_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_RD_RESP7_UPP                                                #
#                                                                        #
##########################################################################

%pic_01_00083_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "FILLED"                       => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Buffer has valid data" ],
   "ARMED"                        => [   2,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   3,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   4,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error" ],
   "PKTERR"                       => [   5,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   6,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   7,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   8,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   9,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [  10,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00083_def =
( NAME    => "BUS0_PCI_RD_RESP7_UPP",
  ADDRESS => 0x00000370,
  NOTE    => "PCI Read Response Buffer 7 Upper address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00083_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_RD_RESP8_UPP                                                #
#                                                                        #
##########################################################################

%pic_01_00084_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "FILLED"                       => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Buffer has valid data" ],
   "ARMED"                        => [   2,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   3,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   4,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error" ],
   "PKTERR"                       => [   5,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   6,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   7,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   8,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   9,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [  10,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00084_def =
( NAME    => "BUS0_PCI_RD_RESP8_UPP",
  ADDRESS => 0x00000380,
  NOTE    => "PCI Read Response Buffer 8 Upper address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00084_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_RD_RESP9_UPP                                                #
#                                                                        #
##########################################################################

%pic_01_00085_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "FILLED"                       => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Buffer has valid data" ],
   "ARMED"                        => [   2,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   3,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   4,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error" ],
   "PKTERR"                       => [   5,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   6,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   7,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   8,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   9,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [  10,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00085_def =
( NAME    => "BUS0_PCI_RD_RESP9_UPP",
  ADDRESS => 0x00000390,
  NOTE    => "PCI Read Response Buffer 9 Upper address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00085_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_RD_RESP10_UPP                                               #
#                                                                        #
##########################################################################

%pic_01_00086_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "FILLED"                       => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Buffer has valid data" ],
   "ARMED"                        => [   2,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   3,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   4,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error" ],
   "PKTERR"                       => [   5,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   6,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   7,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   8,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   9,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [  10,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00086_def =
( NAME    => "BUS0_PCI_RD_RESP10_UPP",
  ADDRESS => 0x000003A0,
  NOTE    => "PCI Read Response Buffer 10 Upper address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00086_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_RD_RESP11_UPP                                               #
#                                                                        #
##########################################################################

%pic_01_00087_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "FILLED"                       => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Buffer has valid data" ],
   "ARMED"                        => [   2,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   3,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   4,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error" ],
   "PKTERR"                       => [   5,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   6,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   7,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   8,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   9,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [  10,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00087_def =
( NAME    => "BUS0_PCI_RD_RESP11_UPP",
  ADDRESS => 0x000003B0,
  NOTE    => "PCI Read Response Buffer 11 Upper address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00087_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_RD_RESP12_UPP                                               #
#                                                                        #
##########################################################################

%pic_01_00088_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "FILLED"                       => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Buffer has valid data" ],
   "ARMED"                        => [   2,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   3,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   4,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error" ],
   "PKTERR"                       => [   5,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   6,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   7,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   8,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   9,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [  10,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00088_def =
( NAME    => "BUS0_PCI_RD_RESP12_UPP",
  ADDRESS => 0x000003C0,
  NOTE    => "PCI Read Response Buffer 12 Upper address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00088_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_RD_RESP13_UPP                                               #
#                                                                        #
##########################################################################

%pic_01_00089_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "FILLED"                       => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Buffer has valid data" ],
   "ARMED"                        => [   2,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   3,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   4,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error" ],
   "PKTERR"                       => [   5,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   6,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   7,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   8,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   9,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [  10,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00089_def =
( NAME    => "BUS0_PCI_RD_RESP13_UPP",
  ADDRESS => 0x000003D0,
  NOTE    => "PCI Read Response Buffer 13 Upper address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00089_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_RD_RESP14_UPP                                               #
#                                                                        #
##########################################################################

%pic_01_00090_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "FILLED"                       => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Buffer has valid data" ],
   "ARMED"                        => [   2,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   3,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   4,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error" ],
   "PKTERR"                       => [   5,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   6,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   7,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   8,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   9,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [  10,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00090_def =
( NAME    => "BUS0_PCI_RD_RESP14_UPP",
  ADDRESS => 0x000003E0,
  NOTE    => "PCI Read Response Buffer 14 Upper address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00090_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_RD_RESP15_UPP                                               #
#                                                                        #
##########################################################################

%pic_01_00091_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "FILLED"                       => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Buffer has valid data" ],
   "ARMED"                        => [   2,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   3,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   4,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error" ],
   "PKTERR"                       => [   5,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   6,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   7,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   8,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   9,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [  10,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00091_def =
( NAME    => "BUS0_PCI_RD_RESP15_UPP",
  ADDRESS => 0x000003F0,
  NOTE    => "PCI Read Response Buffer 15 Upper address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00091_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_RD_RESP0_LOW                                                #
#                                                                        #
##########################################################################

%pic_01_00092_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "FILLED"                       => [   0,  63,   1, 0x8000000000000000, 0x00, 0, 0x0000000000000000, "Filled indicates that the buffer has valid data" ],
   "ARMED"                        => [   1,  62,   1, 0x4000000000000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   2,  61,   1, 0x2000000000000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   3,  60,   1, 0x1000000000000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error occurred" ],
   "PKTERR"                       => [   4,  59,   1, 0x0800000000000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   5,  58,   1, 0x0400000000000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   6,  57,   1, 0x0200000000000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   7,  56,   1, 0x0100000000000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   8,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [   9,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [  10,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00092_def =
( NAME    => "BUS0_PCI_RD_RESP0_LOW",
  ADDRESS => 0x00000308,
  NOTE    => "PCI Read Response Buffer 0 Lower Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00092_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_RD_RESP1_LOW                                                #
#                                                                        #
##########################################################################

%pic_01_00093_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "FILLED"                       => [   0,  63,   1, 0x8000000000000000, 0x00, 0, 0x0000000000000000, "Filled indicates that the buffer has valid data" ],
   "ARMED"                        => [   1,  62,   1, 0x4000000000000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   2,  61,   1, 0x2000000000000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   3,  60,   1, 0x1000000000000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error occurred" ],
   "PKTERR"                       => [   4,  59,   1, 0x0800000000000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   5,  58,   1, 0x0400000000000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   6,  57,   1, 0x0200000000000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   7,  56,   1, 0x0100000000000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   8,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [   9,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [  10,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00093_def =
( NAME    => "BUS0_PCI_RD_RESP1_LOW",
  ADDRESS => 0x00000318,
  NOTE    => "PCI Read Response Buffer 1 Lower Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00093_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_RD_RESP2_LOW                                                #
#                                                                        #
##########################################################################

%pic_01_00094_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "FILLED"                       => [   0,  63,   1, 0x8000000000000000, 0x00, 0, 0x0000000000000000, "Filled indicates that the buffer has valid data" ],
   "ARMED"                        => [   1,  62,   1, 0x4000000000000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   2,  61,   1, 0x2000000000000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   3,  60,   1, 0x1000000000000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error occurred" ],
   "PKTERR"                       => [   4,  59,   1, 0x0800000000000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   5,  58,   1, 0x0400000000000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   6,  57,   1, 0x0200000000000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   7,  56,   1, 0x0100000000000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   8,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [   9,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [  10,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00094_def =
( NAME    => "BUS0_PCI_RD_RESP2_LOW",
  ADDRESS => 0x00000328,
  NOTE    => "PCI Read Response Buffer 2 Lower Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00094_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_RD_RESP3_LOW                                                #
#                                                                        #
##########################################################################

%pic_01_00095_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "FILLED"                       => [   0,  63,   1, 0x8000000000000000, 0x00, 0, 0x0000000000000000, "Filled indicates that the buffer has valid data" ],
   "ARMED"                        => [   1,  62,   1, 0x4000000000000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   2,  61,   1, 0x2000000000000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   3,  60,   1, 0x1000000000000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error occurred" ],
   "PKTERR"                       => [   4,  59,   1, 0x0800000000000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   5,  58,   1, 0x0400000000000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   6,  57,   1, 0x0200000000000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   7,  56,   1, 0x0100000000000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   8,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [   9,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [  10,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00095_def =
( NAME    => "BUS0_PCI_RD_RESP3_LOW",
  ADDRESS => 0x00000338,
  NOTE    => "PCI Read Response Buffer 3 Lower Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00095_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_RD_RESP4_LOW                                                #
#                                                                        #
##########################################################################

%pic_01_00096_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "FILLED"                       => [   0,  63,   1, 0x8000000000000000, 0x00, 0, 0x0000000000000000, "Filled indicates that the buffer has valid data" ],
   "ARMED"                        => [   1,  62,   1, 0x4000000000000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   2,  61,   1, 0x2000000000000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   3,  60,   1, 0x1000000000000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error occurred" ],
   "PKTERR"                       => [   4,  59,   1, 0x0800000000000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   5,  58,   1, 0x0400000000000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   6,  57,   1, 0x0200000000000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   7,  56,   1, 0x0100000000000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   8,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [   9,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [  10,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00096_def =
( NAME    => "BUS0_PCI_RD_RESP4_LOW",
  ADDRESS => 0x00000348,
  NOTE    => "PCI Read Response Buffer 4 Lower Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00096_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_RD_RESP5_LOW                                                #
#                                                                        #
##########################################################################

%pic_01_00097_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "FILLED"                       => [   0,  63,   1, 0x8000000000000000, 0x00, 0, 0x0000000000000000, "Filled indicates that the buffer has valid data" ],
   "ARMED"                        => [   1,  62,   1, 0x4000000000000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   2,  61,   1, 0x2000000000000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   3,  60,   1, 0x1000000000000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error occurred" ],
   "PKTERR"                       => [   4,  59,   1, 0x0800000000000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   5,  58,   1, 0x0400000000000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   6,  57,   1, 0x0200000000000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   7,  56,   1, 0x0100000000000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   8,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [   9,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [  10,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00097_def =
( NAME    => "BUS0_PCI_RD_RESP5_LOW",
  ADDRESS => 0x00000358,
  NOTE    => "PCI Read Response Buffer 5 Lower Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00097_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_RD_RESP6_LOW                                                #
#                                                                        #
##########################################################################

%pic_01_00098_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "FILLED"                       => [   0,  63,   1, 0x8000000000000000, 0x00, 0, 0x0000000000000000, "Filled indicates that the buffer has valid data" ],
   "ARMED"                        => [   1,  62,   1, 0x4000000000000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   2,  61,   1, 0x2000000000000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   3,  60,   1, 0x1000000000000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error occurred" ],
   "PKTERR"                       => [   4,  59,   1, 0x0800000000000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   5,  58,   1, 0x0400000000000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   6,  57,   1, 0x0200000000000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   7,  56,   1, 0x0100000000000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   8,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [   9,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [  10,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00098_def =
( NAME    => "BUS0_PCI_RD_RESP6_LOW",
  ADDRESS => 0x00000368,
  NOTE    => "PCI Read Response Buffer 6 Lower Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00098_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_RD_RESP7_LOW                                                #
#                                                                        #
##########################################################################

%pic_01_00099_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "FILLED"                       => [   0,  63,   1, 0x8000000000000000, 0x00, 0, 0x0000000000000000, "Filled indicates that the buffer has valid data" ],
   "ARMED"                        => [   1,  62,   1, 0x4000000000000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   2,  61,   1, 0x2000000000000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   3,  60,   1, 0x1000000000000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error occurred" ],
   "PKTERR"                       => [   4,  59,   1, 0x0800000000000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   5,  58,   1, 0x0400000000000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   6,  57,   1, 0x0200000000000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   7,  56,   1, 0x0100000000000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   8,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [   9,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [  10,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00099_def =
( NAME    => "BUS0_PCI_RD_RESP7_LOW",
  ADDRESS => 0x00000378,
  NOTE    => "PCI Read Response Buffer 7 Lower Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00099_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_RD_RESP8_LOW                                                #
#                                                                        #
##########################################################################

%pic_01_00100_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "FILLED"                       => [   0,  63,   1, 0x8000000000000000, 0x00, 0, 0x0000000000000000, "Filled indicates that the buffer has valid data" ],
   "ARMED"                        => [   1,  62,   1, 0x4000000000000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   2,  61,   1, 0x2000000000000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   3,  60,   1, 0x1000000000000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error occurred" ],
   "PKTERR"                       => [   4,  59,   1, 0x0800000000000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   5,  58,   1, 0x0400000000000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   6,  57,   1, 0x0200000000000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   7,  56,   1, 0x0100000000000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   8,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [   9,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [  10,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00100_def =
( NAME    => "BUS0_PCI_RD_RESP8_LOW",
  ADDRESS => 0x00000388,
  NOTE    => "PCI Read Response Buffer 8 Lower Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00100_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_RD_RESP9_LOW                                                #
#                                                                        #
##########################################################################

%pic_01_00101_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "FILLED"                       => [   0,  63,   1, 0x8000000000000000, 0x00, 0, 0x0000000000000000, "Filled indicates that the buffer has valid data" ],
   "ARMED"                        => [   1,  62,   1, 0x4000000000000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   2,  61,   1, 0x2000000000000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   3,  60,   1, 0x1000000000000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error occurred" ],
   "PKTERR"                       => [   4,  59,   1, 0x0800000000000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   5,  58,   1, 0x0400000000000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   6,  57,   1, 0x0200000000000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   7,  56,   1, 0x0100000000000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   8,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [   9,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [  10,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00101_def =
( NAME    => "BUS0_PCI_RD_RESP9_LOW",
  ADDRESS => 0x00000398,
  NOTE    => "PCI Read Response Buffer 9 Lower Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00101_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_RD_RESP10_LOW                                               #
#                                                                        #
##########################################################################

%pic_01_00102_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "FILLED"                       => [   0,  63,   1, 0x8000000000000000, 0x00, 0, 0x0000000000000000, "Filled indicates that the buffer has valid data" ],
   "ARMED"                        => [   1,  62,   1, 0x4000000000000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   2,  61,   1, 0x2000000000000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   3,  60,   1, 0x1000000000000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error occurred" ],
   "PKTERR"                       => [   4,  59,   1, 0x0800000000000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   5,  58,   1, 0x0400000000000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   6,  57,   1, 0x0200000000000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   7,  56,   1, 0x0100000000000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   8,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [   9,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [  10,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00102_def =
( NAME    => "BUS0_PCI_RD_RESP10_LOW",
  ADDRESS => 0x000003A8,
  NOTE    => "PCI Read Response Buffer 10 Lower Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00102_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_RD_RESP11_LOW                                               #
#                                                                        #
##########################################################################

%pic_01_00103_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "FILLED"                       => [   0,  63,   1, 0x8000000000000000, 0x00, 0, 0x0000000000000000, "Filled indicates that the buffer has valid data" ],
   "ARMED"                        => [   1,  62,   1, 0x4000000000000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   2,  61,   1, 0x2000000000000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   3,  60,   1, 0x1000000000000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error occurred" ],
   "PKTERR"                       => [   4,  59,   1, 0x0800000000000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   5,  58,   1, 0x0400000000000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   6,  57,   1, 0x0200000000000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   7,  56,   1, 0x0100000000000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   8,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [   9,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [  10,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00103_def =
( NAME    => "BUS0_PCI_RD_RESP11_LOW",
  ADDRESS => 0x000003B8,
  NOTE    => "PCI Read Response Buffer 11 Lower Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00103_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_RD_RESP12_LOW                                               #
#                                                                        #
##########################################################################

%pic_01_00104_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "FILLED"                       => [   0,  63,   1, 0x8000000000000000, 0x00, 0, 0x0000000000000000, "Filled indicates that the buffer has valid data" ],
   "ARMED"                        => [   1,  62,   1, 0x4000000000000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   2,  61,   1, 0x2000000000000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   3,  60,   1, 0x1000000000000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error occurred" ],
   "PKTERR"                       => [   4,  59,   1, 0x0800000000000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   5,  58,   1, 0x0400000000000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   6,  57,   1, 0x0200000000000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   7,  56,   1, 0x0100000000000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   8,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [   9,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [  10,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00104_def =
( NAME    => "BUS0_PCI_RD_RESP12_LOW",
  ADDRESS => 0x000003C8,
  NOTE    => "PCI Read Response Buffer 12 Lower Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00104_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_RD_RESP13_LOW                                               #
#                                                                        #
##########################################################################

%pic_01_00105_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "FILLED"                       => [   0,  63,   1, 0x8000000000000000, 0x00, 0, 0x0000000000000000, "Filled indicates that the buffer has valid data" ],
   "ARMED"                        => [   1,  62,   1, 0x4000000000000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   2,  61,   1, 0x2000000000000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   3,  60,   1, 0x1000000000000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error occurred" ],
   "PKTERR"                       => [   4,  59,   1, 0x0800000000000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   5,  58,   1, 0x0400000000000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   6,  57,   1, 0x0200000000000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   7,  56,   1, 0x0100000000000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   8,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [   9,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [  10,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00105_def =
( NAME    => "BUS0_PCI_RD_RESP13_LOW",
  ADDRESS => 0x000003D8,
  NOTE    => "PCI Read Response Buffer 13 Lower Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00105_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_RD_RESP14_LOW                                               #
#                                                                        #
##########################################################################

%pic_01_00106_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "FILLED"                       => [   0,  63,   1, 0x8000000000000000, 0x00, 0, 0x0000000000000000, "Filled indicates that the buffer has valid data" ],
   "ARMED"                        => [   1,  62,   1, 0x4000000000000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   2,  61,   1, 0x2000000000000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   3,  60,   1, 0x1000000000000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error occurred" ],
   "PKTERR"                       => [   4,  59,   1, 0x0800000000000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   5,  58,   1, 0x0400000000000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   6,  57,   1, 0x0200000000000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   7,  56,   1, 0x0100000000000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   8,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [   9,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [  10,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00106_def =
( NAME    => "BUS0_PCI_RD_RESP14_LOW",
  ADDRESS => 0x000003E8,
  NOTE    => "PCI Read Response Buffer 14 Lower Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00106_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_RD_RESP15_LOW                                               #
#                                                                        #
##########################################################################

%pic_01_00107_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "FILLED"                       => [   0,  63,   1, 0x8000000000000000, 0x00, 0, 0x0000000000000000, "Filled indicates that the buffer has valid data" ],
   "ARMED"                        => [   1,  62,   1, 0x4000000000000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   2,  61,   1, 0x2000000000000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   3,  60,   1, 0x1000000000000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error occurred" ],
   "PKTERR"                       => [   4,  59,   1, 0x0800000000000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   5,  58,   1, 0x0400000000000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   6,  57,   1, 0x0200000000000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   7,  56,   1, 0x0100000000000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   8,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [   9,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [  10,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00107_def =
( NAME    => "BUS0_PCI_RD_RESP15_LOW",
  ADDRESS => 0x000003F8,
  NOTE    => "PCI Read Response Buffer 15 Lower Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00107_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF0_FLUSH_CNT_DATA_TOUCH                                       #
#                                                                        #
##########################################################################

%pic_01_00108_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "TOUCH_CNT"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Count of Buffer Flushes with Data Touch" ],
);

%pic_01_00108_def =
( NAME    => "BUS0_BUF0_FLUSH_CNT_DATA_TOUCH",
  ADDRESS => 0x00000400,
  NOTE    => "PCI Buffer 0 Flush Count with Data Touch Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00108_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF1_FLUSH_CNT_DATA_TOUCH                                       #
#                                                                        #
##########################################################################

%pic_01_00109_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "TOUCH_CNT"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Count of Buffer Flushes with Data Touch" ],
);

%pic_01_00109_def =
( NAME    => "BUS0_BUF1_FLUSH_CNT_DATA_TOUCH",
  ADDRESS => 0x00000440,
  NOTE    => "PCI Buffer 1 Flush Count with Data Touch Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00109_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF2_FLUSH_CNT_DATA_TOUCH                                       #
#                                                                        #
##########################################################################

%pic_01_00110_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "TOUCH_CNT"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Count of Buffer Flushes with Data Touch" ],
);

%pic_01_00110_def =
( NAME    => "BUS0_BUF2_FLUSH_CNT_DATA_TOUCH",
  ADDRESS => 0x00000480,
  NOTE    => "PCI Buffer 2 Flush Count with Data Touch Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00110_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF3_FLUSH_CNT_DATA_TOUCH                                       #
#                                                                        #
##########################################################################

%pic_01_00111_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "TOUCH_CNT"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Count of Buffer Flushes with Data Touch" ],
);

%pic_01_00111_def =
( NAME    => "BUS0_BUF3_FLUSH_CNT_DATA_TOUCH",
  ADDRESS => 0x000004C0,
  NOTE    => "PCI Buffer 3 Flush Count with Data Touch Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00111_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF4_FLUSH_CNT_DATA_TOUCH                                       #
#                                                                        #
##########################################################################

%pic_01_00112_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "TOUCH_CNT"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Count of Buffer Flushes with Data Touch" ],
);

%pic_01_00112_def =
( NAME    => "BUS0_BUF4_FLUSH_CNT_DATA_TOUCH",
  ADDRESS => 0x00000500,
  NOTE    => "PCI Buffer 4 Flush Count with Data Touch Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00112_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF5_FLUSH_CNT_DATA_TOUCH                                       #
#                                                                        #
##########################################################################

%pic_01_00113_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "TOUCH_CNT"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Count of Buffer Flushes with Data Touch" ],
);

%pic_01_00113_def =
( NAME    => "BUS0_BUF5_FLUSH_CNT_DATA_TOUCH",
  ADDRESS => 0x00000540,
  NOTE    => "PCI Buffer 5 Flush Count with Data Touch Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00113_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF6_FLUSH_CNT_DATA_TOUCH                                       #
#                                                                        #
##########################################################################

%pic_01_00114_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "TOUCH_CNT"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Count of Buffer Flushes with Data Touch" ],
);

%pic_01_00114_def =
( NAME    => "BUS0_BUF6_FLUSH_CNT_DATA_TOUCH",
  ADDRESS => 0x00000580,
  NOTE    => "PCI Buffer 6 Flush Count with Data Touch Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00114_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF7_FLUSH_CNT_DATA_TOUCH                                       #
#                                                                        #
##########################################################################

%pic_01_00115_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "TOUCH_CNT"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Count of Buffer Flushes with Data Touch" ],
);

%pic_01_00115_def =
( NAME    => "BUS0_BUF7_FLUSH_CNT_DATA_TOUCH",
  ADDRESS => 0x000005C0,
  NOTE    => "PCI Buffer 7 Flush Count with Data Touch Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00115_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF0_FLUSH_CNT_NO_DATA_TOUCH                                     #
#                                                                        #
##########################################################################

%pic_01_00116_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "NOTOUCH_CNT"                  => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Count of Buffer Flushes without Data Touch" ],
);

%pic_01_00116_def =
( NAME    => "BUS0_BUF0_FLUSH_CNT_NO_DATA_TOUCH",
  ADDRESS => 0x00000408,
  NOTE    => "PCI Buffer 0 Flush Count without Data Touch Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00116_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF1_FLUSH_CNT_NO_DATA_TOUCH                                     #
#                                                                        #
##########################################################################

%pic_01_00117_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "NOTOUCH_CNT"                  => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Count of Buffer Flushes without Data Touch" ],
);

%pic_01_00117_def =
( NAME    => "BUS0_BUF1_FLUSH_CNT_NO_DATA_TOUCH",
  ADDRESS => 0x00000448,
  NOTE    => "PCI Buffer 1 Flush Count without Data Touch Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00117_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF2_FLUSH_CNT_NO_DATA_TOUCH                                     #
#                                                                        #
##########################################################################

%pic_01_00118_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "NOTOUCH_CNT"                  => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Count of Buffer Flushes without Data Touch" ],
);

%pic_01_00118_def =
( NAME    => "BUS0_BUF2_FLUSH_CNT_NO_DATA_TOUCH",
  ADDRESS => 0x00000488,
  NOTE    => "PCI Buffer 2 Flush Count without Data Touch Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00118_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF3_FLUSH_CNT_NO_DATA_TOUCH                                     #
#                                                                        #
##########################################################################

%pic_01_00119_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "NOTOUCH_CNT"                  => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Count of Buffer Flushes without Data Touch" ],
);

%pic_01_00119_def =
( NAME    => "BUS0_BUF3_FLUSH_CNT_NO_DATA_TOUCH",
  ADDRESS => 0x000004C8,
  NOTE    => "PCI Buffer 3 Flush Count without Data Touch Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00119_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF4_FLUSH_CNT_NO_DATA_TOUCH                                     #
#                                                                        #
##########################################################################

%pic_01_00120_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "NOTOUCH_CNT"                  => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Count of Buffer Flushes without Data Touch" ],
);

%pic_01_00120_def =
( NAME    => "BUS0_BUF4_FLUSH_CNT_NO_DATA_TOUCH",
  ADDRESS => 0x00000508,
  NOTE    => "PCI Buffer 4 Flush Count without Data Touch Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00120_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF5_FLUSH_CNT_NO_DATA_TOUCH                                     #
#                                                                        #
##########################################################################

%pic_01_00121_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "NOTOUCH_CNT"                  => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Count of Buffer Flushes without Data Touch" ],
);

%pic_01_00121_def =
( NAME    => "BUS0_BUF5_FLUSH_CNT_NO_DATA_TOUCH",
  ADDRESS => 0x00000548,
  NOTE    => "PCI Buffer 5 Flush Count without Data Touch Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00121_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF6_FLUSH_CNT_NO_DATA_TOUCH                                     #
#                                                                        #
##########################################################################

%pic_01_00122_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "NOTOUCH_CNT"                  => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Count of Buffer Flushes without Data Touch" ],
);

%pic_01_00122_def =
( NAME    => "BUS0_BUF6_FLUSH_CNT_NO_DATA_TOUCH",
  ADDRESS => 0x00000588,
  NOTE    => "PCI Buffer 6 Flush Count without Data Touch Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00122_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF7_FLUSH_CNT_NO_DATA_TOUCH                                     #
#                                                                        #
##########################################################################

%pic_01_00123_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "NOTOUCH_CNT"                  => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Count of Buffer Flushes without Data Touch" ],
);

%pic_01_00123_def =
( NAME    => "BUS0_BUF7_FLUSH_CNT_NO_DATA_TOUCH",
  ADDRESS => 0x000005C8,
  NOTE    => "PCI Buffer 7 Flush Count without Data Touch Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00123_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF0_REQ_FLIGHT_CNT                                             #
#                                                                        #
##########################################################################

%pic_01_00124_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INFLIGHT_CNT"                 => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "In-flight Count" ],
);

%pic_01_00124_def =
( NAME    => "BUS0_BUF0_REQ_FLIGHT_CNT",
  ADDRESS => 0x00000410,
  NOTE    => "PCI Buffer 0 Request In-flight Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00124_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF1_REQ_FLIGHT_CNT                                             #
#                                                                        #
##########################################################################

%pic_01_00125_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INFLIGHT_CNT"                 => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "In-flight Count" ],
);

%pic_01_00125_def =
( NAME    => "BUS0_BUF1_REQ_FLIGHT_CNT",
  ADDRESS => 0x00000450,
  NOTE    => "PCI Buffer 1 Request In-flight Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00125_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF2_REQ_FLIGHT_CNT                                             #
#                                                                        #
##########################################################################

%pic_01_00126_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INFLIGHT_CNT"                 => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "In-flight Count" ],
);

%pic_01_00126_def =
( NAME    => "BUS0_BUF2_REQ_FLIGHT_CNT",
  ADDRESS => 0x00000490,
  NOTE    => "PCI Buffer 2 Request In-flight Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00126_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF3_REQ_FLIGHT_CNT                                             #
#                                                                        #
##########################################################################

%pic_01_00127_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INFLIGHT_CNT"                 => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "In-flight Count" ],
);

%pic_01_00127_def =
( NAME    => "BUS0_BUF3_REQ_FLIGHT_CNT",
  ADDRESS => 0x000004D0,
  NOTE    => "PCI Buffer 3 Request In-flight Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00127_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF4_REQ_FLIGHT_CNT                                             #
#                                                                        #
##########################################################################

%pic_01_00128_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INFLIGHT_CNT"                 => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "In-flight Count" ],
);

%pic_01_00128_def =
( NAME    => "BUS0_BUF4_REQ_FLIGHT_CNT",
  ADDRESS => 0x00000510,
  NOTE    => "PCI Buffer 4 Request In-flight Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00128_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF5_REQ_FLIGHT_CNT                                             #
#                                                                        #
##########################################################################

%pic_01_00129_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INFLIGHT_CNT"                 => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "In-flight Count" ],
);

%pic_01_00129_def =
( NAME    => "BUS0_BUF5_REQ_FLIGHT_CNT",
  ADDRESS => 0x00000550,
  NOTE    => "PCI Buffer 5 Request In-flight Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00129_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF6_REQ_FLIGHT_CNT                                             #
#                                                                        #
##########################################################################

%pic_01_00130_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INFLIGHT_CNT"                 => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "In-flight Count" ],
);

%pic_01_00130_def =
( NAME    => "BUS0_BUF6_REQ_FLIGHT_CNT",
  ADDRESS => 0x00000590,
  NOTE    => "PCI Buffer 6 Request In-flight Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00130_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF7_REQ_FLIGHT_CNT                                             #
#                                                                        #
##########################################################################

%pic_01_00131_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INFLIGHT_CNT"                 => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "In-flight Count" ],
);

%pic_01_00131_def =
( NAME    => "BUS0_BUF7_REQ_FLIGHT_CNT",
  ADDRESS => 0x000005D0,
  NOTE    => "PCI Buffer 7 Request In-flight Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00131_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF0_PREFETCH_REQ_CNT                                           #
#                                                                        #
##########################################################################

%pic_01_00132_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PREFETCH_CNT"                 => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Prefetch Count" ],
);

%pic_01_00132_def =
( NAME    => "BUS0_BUF0_PREFETCH_REQ_CNT",
  ADDRESS => 0x00000418,
  NOTE    => "PCI Buffer 0 Prefetch Request Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00132_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF1_PREFETCH_REQ_CNT                                           #
#                                                                        #
##########################################################################

%pic_01_00133_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PREFETCH_CNT"                 => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Prefetch Count" ],
);

%pic_01_00133_def =
( NAME    => "BUS0_BUF1_PREFETCH_REQ_CNT",
  ADDRESS => 0x00000458,
  NOTE    => "PCI Buffer 1 Prefetch Request Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00133_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF2_PREFETCH_REQ_CNT                                           #
#                                                                        #
##########################################################################

%pic_01_00134_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PREFETCH_CNT"                 => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Prefetch Count" ],
);

%pic_01_00134_def =
( NAME    => "BUS0_BUF2_PREFETCH_REQ_CNT",
  ADDRESS => 0x00000498,
  NOTE    => "PCI Buffer 2 Prefetch Request Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00134_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF3_PREFETCH_REQ_CNT                                           #
#                                                                        #
##########################################################################

%pic_01_00135_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PREFETCH_CNT"                 => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Prefetch Count" ],
);

%pic_01_00135_def =
( NAME    => "BUS0_BUF3_PREFETCH_REQ_CNT",
  ADDRESS => 0x000004D8,
  NOTE    => "PCI Buffer 3 Prefetch Request Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00135_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF4_PREFETCH_REQ_CNT                                           #
#                                                                        #
##########################################################################

%pic_01_00136_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PREFETCH_CNT"                 => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Prefetch Count" ],
);

%pic_01_00136_def =
( NAME    => "BUS0_BUF4_PREFETCH_REQ_CNT",
  ADDRESS => 0x00000518,
  NOTE    => "PCI Buffer 4 Prefetch Request Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00136_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF5_PREFETCH_REQ_CNT                                           #
#                                                                        #
##########################################################################

%pic_01_00137_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PREFETCH_CNT"                 => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Prefetch Count" ],
);

%pic_01_00137_def =
( NAME    => "BUS0_BUF5_PREFETCH_REQ_CNT",
  ADDRESS => 0x00000558,
  NOTE    => "PCI Buffer 5 Prefetch Request Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00137_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF6_PREFETCH_REQ_CNT                                           #
#                                                                        #
##########################################################################

%pic_01_00138_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PREFETCH_CNT"                 => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Prefetch Count" ],
);

%pic_01_00138_def =
( NAME    => "BUS0_BUF6_PREFETCH_REQ_CNT",
  ADDRESS => 0x00000598,
  NOTE    => "PCI Buffer 6 Prefetch Request Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00138_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF7_PREFETCH_REQ_CNT                                           #
#                                                                        #
##########################################################################

%pic_01_00139_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PREFETCH_CNT"                 => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Prefetch Count" ],
);

%pic_01_00139_def =
( NAME    => "BUS0_BUF7_PREFETCH_REQ_CNT",
  ADDRESS => 0x000005D8,
  NOTE    => "PCI Buffer 7 Prefetch Request Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00139_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF0_TOT_PCI_RETRY_CNT                                          #
#                                                                        #
##########################################################################

%pic_01_00140_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RETRY_CNT"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Retry Count" ],
);

%pic_01_00140_def =
( NAME    => "BUS0_BUF0_TOT_PCI_RETRY_CNT",
  ADDRESS => 0x00000420,
  NOTE    => "PCI Buffer 0 Total Retry Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00140_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF1_TOT_PCI_RETRY_CNT                                          #
#                                                                        #
##########################################################################

%pic_01_00141_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RETRY_CNT"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Retry Count" ],
);

%pic_01_00141_def =
( NAME    => "BUS0_BUF1_TOT_PCI_RETRY_CNT",
  ADDRESS => 0x00000460,
  NOTE    => "PCI Buffer 1 Total Retry Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00141_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF2_TOT_PCI_RETRY_CNT                                          #
#                                                                        #
##########################################################################

%pic_01_00142_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RETRY_CNT"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Retry Count" ],
);

%pic_01_00142_def =
( NAME    => "BUS0_BUF2_TOT_PCI_RETRY_CNT",
  ADDRESS => 0x000004A0,
  NOTE    => "PCI Buffer 2 Total Retry Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00142_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF3_TOT_PCI_RETRY_CNT                                          #
#                                                                        #
##########################################################################

%pic_01_00143_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RETRY_CNT"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Retry Count" ],
);

%pic_01_00143_def =
( NAME    => "BUS0_BUF3_TOT_PCI_RETRY_CNT",
  ADDRESS => 0x000004E0,
  NOTE    => "PCI Buffer 3 Total Retry Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00143_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF4_TOT_PCI_RETRY_CNT                                          #
#                                                                        #
##########################################################################

%pic_01_00144_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RETRY_CNT"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Retry Count" ],
);

%pic_01_00144_def =
( NAME    => "BUS0_BUF4_TOT_PCI_RETRY_CNT",
  ADDRESS => 0x00000520,
  NOTE    => "PCI Buffer 4 Total Retry Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00144_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF5_TOT_PCI_RETRY_CNT                                          #
#                                                                        #
##########################################################################

%pic_01_00145_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RETRY_CNT"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Retry Count" ],
);

%pic_01_00145_def =
( NAME    => "BUS0_BUF5_TOT_PCI_RETRY_CNT",
  ADDRESS => 0x00000560,
  NOTE    => "PCI Buffer 5 Total Retry Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00145_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF6_TOT_PCI_RETRY_CNT                                          #
#                                                                        #
##########################################################################

%pic_01_00146_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RETRY_CNT"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Retry Count" ],
);

%pic_01_00146_def =
( NAME    => "BUS0_BUF6_TOT_PCI_RETRY_CNT",
  ADDRESS => 0x000005A0,
  NOTE    => "PCI Buffer 6 Total Retry Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00146_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF7_TOT_PCI_RETRY_CNT                                          #
#                                                                        #
##########################################################################

%pic_01_00147_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RETRY_CNT"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Retry Count" ],
);

%pic_01_00147_def =
( NAME    => "BUS0_BUF7_TOT_PCI_RETRY_CNT",
  ADDRESS => 0x000005E0,
  NOTE    => "PCI Buffer 7 Total Retry Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00147_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF0_MAX_PCI_RETRY_CNT                                          #
#                                                                        #
##########################################################################

%pic_01_00148_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MAX_RETRY_CNT"                => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Max Retry Count" ],
);

%pic_01_00148_def =
( NAME    => "BUS0_BUF0_MAX_PCI_RETRY_CNT",
  ADDRESS => 0x00000428,
  NOTE    => "PCI Buffer 0 Max PCI Retry Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00148_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF1_MAX_PCI_RETRY_CNT                                          #
#                                                                        #
##########################################################################

%pic_01_00149_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MAX_RETRY_CNT"                => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Max Retry Count" ],
);

%pic_01_00149_def =
( NAME    => "BUS0_BUF1_MAX_PCI_RETRY_CNT",
  ADDRESS => 0x00000468,
  NOTE    => "PCI Buffer 1 Max PCI Retry Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00149_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF2_MAX_PCI_RETRY_CNT                                          #
#                                                                        #
##########################################################################

%pic_01_00150_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MAX_RETRY_CNT"                => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Max Retry Count" ],
);

%pic_01_00150_def =
( NAME    => "BUS0_BUF2_MAX_PCI_RETRY_CNT",
  ADDRESS => 0x000004A8,
  NOTE    => "PCI Buffer 2 Max PCI Retry Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00150_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF3_MAX_PCI_RETRY_CNT                                          #
#                                                                        #
##########################################################################

%pic_01_00151_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MAX_RETRY_CNT"                => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Max Retry Count" ],
);

%pic_01_00151_def =
( NAME    => "BUS0_BUF3_MAX_PCI_RETRY_CNT",
  ADDRESS => 0x000004E8,
  NOTE    => "PCI Buffer 3 Max PCI Retry Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00151_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF4_MAX_PCI_RETRY_CNT                                          #
#                                                                        #
##########################################################################

%pic_01_00152_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MAX_RETRY_CNT"                => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Max Retry Count" ],
);

%pic_01_00152_def =
( NAME    => "BUS0_BUF4_MAX_PCI_RETRY_CNT",
  ADDRESS => 0x00000528,
  NOTE    => "PCI Buffer 4 Max PCI Retry Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00152_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF5_MAX_PCI_RETRY_CNT                                          #
#                                                                        #
##########################################################################

%pic_01_00153_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MAX_RETRY_CNT"                => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Max Retry Count" ],
);

%pic_01_00153_def =
( NAME    => "BUS0_BUF5_MAX_PCI_RETRY_CNT",
  ADDRESS => 0x00000568,
  NOTE    => "PCI Buffer 5 Max PCI Retry Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00153_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF6_MAX_PCI_RETRY_CNT                                          #
#                                                                        #
##########################################################################

%pic_01_00154_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MAX_RETRY_CNT"                => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Max Retry Count" ],
);

%pic_01_00154_def =
( NAME    => "BUS0_BUF6_MAX_PCI_RETRY_CNT",
  ADDRESS => 0x000005A8,
  NOTE    => "PCI Buffer 6 Max PCI Retry Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00154_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF7_MAX_PCI_RETRY_CNT                                          #
#                                                                        #
##########################################################################

%pic_01_00155_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MAX_RETRY_CNT"                => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Max Retry Count" ],
);

%pic_01_00155_def =
( NAME    => "BUS0_BUF7_MAX_PCI_RETRY_CNT",
  ADDRESS => 0x000005E8,
  NOTE    => "PCI Buffer 7 Max PCI Retry Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00155_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF0_MAX_LAT_CNT_REG                                            #
#                                                                        #
##########################################################################

%pic_01_00156_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MAX_LATENCY_CNT"              => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Max Latency Count" ],
);

%pic_01_00156_def =
( NAME    => "BUS0_BUF0_MAX_LAT_CNT_REG",
  ADDRESS => 0x00000430,
  NOTE    => "PCI Buffer 0 Max Latency Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00156_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF1_MAX_LAT_CNT_REG                                            #
#                                                                        #
##########################################################################

%pic_01_00157_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MAX_LATENCY_CNT"              => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Max Latency Count" ],
);

%pic_01_00157_def =
( NAME    => "BUS0_BUF1_MAX_LAT_CNT_REG",
  ADDRESS => 0x00000470,
  NOTE    => "PCI Buffer 1 Max Latency Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00157_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF2_MAX_LAT_CNT_REG                                            #
#                                                                        #
##########################################################################

%pic_01_00158_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MAX_LATENCY_CNT"              => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Max Latency Count" ],
);

%pic_01_00158_def =
( NAME    => "BUS0_BUF2_MAX_LAT_CNT_REG",
  ADDRESS => 0x000004B0,
  NOTE    => "PCI Buffer 2 Max Latency Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00158_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF3_MAX_LAT_CNT_REG                                            #
#                                                                        #
##########################################################################

%pic_01_00159_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MAX_LATENCY_CNT"              => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Max Latency Count" ],
);

%pic_01_00159_def =
( NAME    => "BUS0_BUF3_MAX_LAT_CNT_REG",
  ADDRESS => 0x000004F0,
  NOTE    => "PCI Buffer 3 Max Latency Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00159_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF4_MAX_LAT_CNT_REG                                            #
#                                                                        #
##########################################################################

%pic_01_00160_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MAX_LATENCY_CNT"              => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Max Latency Count" ],
);

%pic_01_00160_def =
( NAME    => "BUS0_BUF4_MAX_LAT_CNT_REG",
  ADDRESS => 0x00000530,
  NOTE    => "PCI Buffer 4 Max Latency Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00160_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF5_MAX_LAT_CNT_REG                                            #
#                                                                        #
##########################################################################

%pic_01_00161_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MAX_LATENCY_CNT"              => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Max Latency Count" ],
);

%pic_01_00161_def =
( NAME    => "BUS0_BUF5_MAX_LAT_CNT_REG",
  ADDRESS => 0x00000570,
  NOTE    => "PCI Buffer 5 Max Latency Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00161_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF6_MAX_LAT_CNT_REG                                            #
#                                                                        #
##########################################################################

%pic_01_00162_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MAX_LATENCY_CNT"              => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Max Latency Count" ],
);

%pic_01_00162_def =
( NAME    => "BUS0_BUF6_MAX_LAT_CNT_REG",
  ADDRESS => 0x000005B0,
  NOTE    => "PCI Buffer 6 Max Latency Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00162_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF7_MAX_LAT_CNT_REG                                            #
#                                                                        #
##########################################################################

%pic_01_00163_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MAX_LATENCY_CNT"              => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Max Latency Count" ],
);

%pic_01_00163_def =
( NAME    => "BUS0_BUF7_MAX_LAT_CNT_REG",
  ADDRESS => 0x000005F0,
  NOTE    => "PCI Buffer 7 Max Latency Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00163_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF0_MAX_LAT_CNT                                                #
#                                                                        #
##########################################################################

%pic_01_00164_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "VALUE"                        => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Clears all the count values for the 0 registers" ],
);

%pic_01_00164_def =
( NAME    => "BUS0_BUF0_MAX_LAT_CNT",
  ADDRESS => 0x00000438,
  NOTE    => "PCI Buffer 0 Clear All Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00164_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF1_MAX_LAT_CNT                                                #
#                                                                        #
##########################################################################

%pic_01_00165_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "VALUE"                        => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Clears all the count values for the 1 registers" ],
);

%pic_01_00165_def =
( NAME    => "BUS0_BUF1_MAX_LAT_CNT",
  ADDRESS => 0x00000478,
  NOTE    => "PCI Buffer 1 Clear All Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00165_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF2_MAX_LAT_CNT                                                #
#                                                                        #
##########################################################################

%pic_01_00166_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "VALUE"                        => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Clears all the count values for the 2 registers" ],
);

%pic_01_00166_def =
( NAME    => "BUS0_BUF2_MAX_LAT_CNT",
  ADDRESS => 0x000004B8,
  NOTE    => "PCI Buffer 2 Clear All Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00166_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF3_MAX_LAT_CNT                                                #
#                                                                        #
##########################################################################

%pic_01_00167_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "VALUE"                        => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Clears all the count values for the 3 registers" ],
);

%pic_01_00167_def =
( NAME    => "BUS0_BUF3_MAX_LAT_CNT",
  ADDRESS => 0x000004F8,
  NOTE    => "PCI Buffer 3 Clear All Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00167_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF4_MAX_LAT_CNT                                                #
#                                                                        #
##########################################################################

%pic_01_00168_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "VALUE"                        => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Clears all the count values for the 4 registers" ],
);

%pic_01_00168_def =
( NAME    => "BUS0_BUF4_MAX_LAT_CNT",
  ADDRESS => 0x00000538,
  NOTE    => "PCI Buffer 4 Clear All Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00168_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF5_MAX_LAT_CNT                                                #
#                                                                        #
##########################################################################

%pic_01_00169_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "VALUE"                        => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Clears all the count values for the 5 registers" ],
);

%pic_01_00169_def =
( NAME    => "BUS0_BUF5_MAX_LAT_CNT",
  ADDRESS => 0x00000578,
  NOTE    => "PCI Buffer 5 Clear All Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00169_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF6_MAX_LAT_CNT                                                #
#                                                                        #
##########################################################################

%pic_01_00170_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "VALUE"                        => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Clears all the count values for the 6 registers" ],
);

%pic_01_00170_def =
( NAME    => "BUS0_BUF6_MAX_LAT_CNT",
  ADDRESS => 0x000005B8,
  NOTE    => "PCI Buffer 6 Clear All Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00170_flds
);


##########################################################################
#                                                                        #
#   BUS0_BUF7_MAX_LAT_CNT                                                #
#                                                                        #
##########################################################################

%pic_01_00171_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "VALUE"                        => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Clears all the count values for the 7 registers" ],
);

%pic_01_00171_def =
( NAME    => "BUS0_BUF7_MAX_LAT_CNT",
  ADDRESS => 0x000005F8,
  NOTE    => "PCI Buffer 7 Clear All Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00171_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_RD_BUF0_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00172_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00172_def =
( NAME    => "BUS0_PCI_X_RD_BUF0_ATTR",
  ADDRESS => 0x00000A08,
  NOTE    => "PCI-X Read Buffer 0 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00172_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_RD_BUF1_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00173_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00173_def =
( NAME    => "BUS0_PCI_X_RD_BUF1_ATTR",
  ADDRESS => 0x00000A18,
  NOTE    => "PCI-X Read Buffer 1 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00173_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_RD_BUF2_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00174_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00174_def =
( NAME    => "BUS0_PCI_X_RD_BUF2_ATTR",
  ADDRESS => 0x00000A28,
  NOTE    => "PCI-X Read Buffer 2 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00174_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_RD_BUF3_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00175_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00175_def =
( NAME    => "BUS0_PCI_X_RD_BUF3_ATTR",
  ADDRESS => 0x00000A38,
  NOTE    => "PCI-X Read Buffer 3 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00175_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_RD_BUF4_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00176_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00176_def =
( NAME    => "BUS0_PCI_X_RD_BUF4_ATTR",
  ADDRESS => 0x00000A48,
  NOTE    => "PCI-X Read Buffer 4 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00176_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_RD_BUF5_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00177_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00177_def =
( NAME    => "BUS0_PCI_X_RD_BUF5_ATTR",
  ADDRESS => 0x00000A58,
  NOTE    => "PCI-X Read Buffer 5 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00177_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_RD_BUF6_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00178_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00178_def =
( NAME    => "BUS0_PCI_X_RD_BUF6_ATTR",
  ADDRESS => 0x00000A68,
  NOTE    => "PCI-X Read Buffer 6 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00178_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_RD_BUF7_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00179_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00179_def =
( NAME    => "BUS0_PCI_X_RD_BUF7_ATTR",
  ADDRESS => 0x00000A78,
  NOTE    => "PCI-X Read Buffer 7 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00179_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_RD_BUF8_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00180_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00180_def =
( NAME    => "BUS0_PCI_X_RD_BUF8_ATTR",
  ADDRESS => 0x00000A88,
  NOTE    => "PCI-X Read Buffer 8 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00180_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_RD_BUF9_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00181_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00181_def =
( NAME    => "BUS0_PCI_X_RD_BUF9_ATTR",
  ADDRESS => 0x00000A98,
  NOTE    => "PCI-X Read Buffer 9 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00181_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_RD_BUF10_ATTR                                             #
#                                                                        #
##########################################################################

%pic_01_00182_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00182_def =
( NAME    => "BUS0_PCI_X_RD_BUF10_ATTR",
  ADDRESS => 0x00000AA8,
  NOTE    => "PCI-X Read Buffer 10 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00182_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_RD_BUF11_ATTR                                             #
#                                                                        #
##########################################################################

%pic_01_00183_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00183_def =
( NAME    => "BUS0_PCI_X_RD_BUF11_ATTR",
  ADDRESS => 0x00000AB8,
  NOTE    => "PCI-X Read Buffer 11 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00183_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_RD_BUF12_ATTR                                             #
#                                                                        #
##########################################################################

%pic_01_00184_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00184_def =
( NAME    => "BUS0_PCI_X_RD_BUF12_ATTR",
  ADDRESS => 0x00000AC8,
  NOTE    => "PCI-X Read Buffer 12 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00184_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_RD_BUF13_ATTR                                             #
#                                                                        #
##########################################################################

%pic_01_00185_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00185_def =
( NAME    => "BUS0_PCI_X_RD_BUF13_ATTR",
  ADDRESS => 0x00000AD8,
  NOTE    => "PCI-X Read Buffer 13 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00185_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_RD_BUF14_ATTR                                             #
#                                                                        #
##########################################################################

%pic_01_00186_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00186_def =
( NAME    => "BUS0_PCI_X_RD_BUF14_ATTR",
  ADDRESS => 0x00000AE8,
  NOTE    => "PCI-X Read Buffer 14 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00186_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_RD_BUF15_ATTR                                             #
#                                                                        #
##########################################################################

%pic_01_00187_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00187_def =
( NAME    => "BUS0_PCI_X_RD_BUF15_ATTR",
  ADDRESS => 0x00000AF8,
  NOTE    => "PCI-X Read Buffer 15 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00187_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_WR_BUF0_ADDR                                              #
#                                                                        #
##########################################################################

%pic_01_00188_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "PCIX_ERR_ADDR"                => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "PCI-X Error Address" ],
);

%pic_01_00188_def =
( NAME    => "BUS0_PCI_X_WR_BUF0_ADDR",
  ADDRESS => 0x00000B00,
  NOTE    => "PCI-X Write Buffer 0 Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00188_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_WR_BUF1_ADDR                                              #
#                                                                        #
##########################################################################

%pic_01_00189_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "PCIX_ERR_ADDR"                => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "PCI-X Error Address" ],
);

%pic_01_00189_def =
( NAME    => "BUS0_PCI_X_WR_BUF1_ADDR",
  ADDRESS => 0x00000B20,
  NOTE    => "PCI-X Write Buffer 1 Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00189_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_WR_BUF2_ADDR                                              #
#                                                                        #
##########################################################################

%pic_01_00190_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "PCIX_ERR_ADDR"                => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "PCI-X Error Address" ],
);

%pic_01_00190_def =
( NAME    => "BUS0_PCI_X_WR_BUF2_ADDR",
  ADDRESS => 0x00000B40,
  NOTE    => "PCI-X Write Buffer 2 Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00190_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_WR_BUF3_ADDR                                              #
#                                                                        #
##########################################################################

%pic_01_00191_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "PCIX_ERR_ADDR"                => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "PCI-X Error Address" ],
);

%pic_01_00191_def =
( NAME    => "BUS0_PCI_X_WR_BUF3_ADDR",
  ADDRESS => 0x00000B60,
  NOTE    => "PCI-X Write Buffer 3 Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00191_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_WR_BUF4_ADDR                                              #
#                                                                        #
##########################################################################

%pic_01_00192_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "PCIX_ERR_ADDR"                => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "PCI-X Error Address" ],
);

%pic_01_00192_def =
( NAME    => "BUS0_PCI_X_WR_BUF4_ADDR",
  ADDRESS => 0x00000B80,
  NOTE    => "PCI-X Write Buffer 4 Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00192_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_WR_BUF5_ADDR                                              #
#                                                                        #
##########################################################################

%pic_01_00193_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "PCIX_ERR_ADDR"                => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "PCI-X Error Address" ],
);

%pic_01_00193_def =
( NAME    => "BUS0_PCI_X_WR_BUF5_ADDR",
  ADDRESS => 0x00000BA0,
  NOTE    => "PCI-X Write Buffer 5 Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00193_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_WR_BUF6_ADDR                                              #
#                                                                        #
##########################################################################

%pic_01_00194_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "PCIX_ERR_ADDR"                => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "PCI-X Error Address" ],
);

%pic_01_00194_def =
( NAME    => "BUS0_PCI_X_WR_BUF6_ADDR",
  ADDRESS => 0x00000BC0,
  NOTE    => "PCI-X Write Buffer 6 Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00194_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_WR_BUF7_ADDR                                              #
#                                                                        #
##########################################################################

%pic_01_00195_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "PCIX_ERR_ADDR"                => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "PCI-X Error Address" ],
);

%pic_01_00195_def =
( NAME    => "BUS0_PCI_X_WR_BUF7_ADDR",
  ADDRESS => 0x00000BE0,
  NOTE    => "PCI-X Write Buffer 7 Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00195_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_WR_BUF0_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00196_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00196_def =
( NAME    => "BUS0_PCI_X_WR_BUF0_ATTR",
  ADDRESS => 0x00000B08,
  NOTE    => "PCI-X Write Buffer 0 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00196_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_WR_BUF1_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00197_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00197_def =
( NAME    => "BUS0_PCI_X_WR_BUF1_ATTR",
  ADDRESS => 0x00000B28,
  NOTE    => "PCI-X Write Buffer 1 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00197_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_WR_BUF2_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00198_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00198_def =
( NAME    => "BUS0_PCI_X_WR_BUF2_ATTR",
  ADDRESS => 0x00000B48,
  NOTE    => "PCI-X Write Buffer 2 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00198_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_WR_BUF3_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00199_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00199_def =
( NAME    => "BUS0_PCI_X_WR_BUF3_ATTR",
  ADDRESS => 0x00000B68,
  NOTE    => "PCI-X Write Buffer 3 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00199_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_WR_BUF4_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00200_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00200_def =
( NAME    => "BUS0_PCI_X_WR_BUF4_ATTR",
  ADDRESS => 0x00000B88,
  NOTE    => "PCI-X Write Buffer 4 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00200_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_WR_BUF5_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00201_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00201_def =
( NAME    => "BUS0_PCI_X_WR_BUF5_ATTR",
  ADDRESS => 0x00000BA8,
  NOTE    => "PCI-X Write Buffer 5 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00201_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_WR_BUF6_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00202_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00202_def =
( NAME    => "BUS0_PCI_X_WR_BUF6_ATTR",
  ADDRESS => 0x00000BC8,
  NOTE    => "PCI-X Write Buffer 6 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00202_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_WR_BUF7_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00203_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00203_def =
( NAME    => "BUS0_PCI_X_WR_BUF7_ATTR",
  ADDRESS => 0x00000BE8,
  NOTE    => "PCI-X Write Buffer 7 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00203_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_WR_BUF0_VALID                                             #
#                                                                        #
##########################################################################

%pic_01_00204_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "WRT_VALID_BUFF"               => [   1,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Valid Buffers" ],
);

%pic_01_00204_def =
( NAME    => "BUS0_PCI_X_WR_BUF0_VALID",
  ADDRESS => 0x00000B10,
  NOTE    => "PCI-X Write Buffer 0 Valid Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00204_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_WR_BUF1_VALID                                             #
#                                                                        #
##########################################################################

%pic_01_00205_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "WRT_VALID_BUFF"               => [   1,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Valid Buffers" ],
);

%pic_01_00205_def =
( NAME    => "BUS0_PCI_X_WR_BUF1_VALID",
  ADDRESS => 0x00000B30,
  NOTE    => "PCI-X Write Buffer 1 Valid Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00205_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_WR_BUF2_VALID                                             #
#                                                                        #
##########################################################################

%pic_01_00206_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "WRT_VALID_BUFF"               => [   1,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Valid Buffers" ],
);

%pic_01_00206_def =
( NAME    => "BUS0_PCI_X_WR_BUF2_VALID",
  ADDRESS => 0x00000B50,
  NOTE    => "PCI-X Write Buffer 2 Valid Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00206_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_WR_BUF3_VALID                                             #
#                                                                        #
##########################################################################

%pic_01_00207_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "WRT_VALID_BUFF"               => [   1,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Valid Buffers" ],
);

%pic_01_00207_def =
( NAME    => "BUS0_PCI_X_WR_BUF3_VALID",
  ADDRESS => 0x00000B70,
  NOTE    => "PCI-X Write Buffer 3 Valid Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00207_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_WR_BUF4_VALID                                             #
#                                                                        #
##########################################################################

%pic_01_00208_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "WRT_VALID_BUFF"               => [   1,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Valid Buffers" ],
);

%pic_01_00208_def =
( NAME    => "BUS0_PCI_X_WR_BUF4_VALID",
  ADDRESS => 0x00000B90,
  NOTE    => "PCI-X Write Buffer 4 Valid Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00208_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_WR_BUF5_VALID                                             #
#                                                                        #
##########################################################################

%pic_01_00209_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "WRT_VALID_BUFF"               => [   1,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Valid Buffers" ],
);

%pic_01_00209_def =
( NAME    => "BUS0_PCI_X_WR_BUF5_VALID",
  ADDRESS => 0x00000BB0,
  NOTE    => "PCI-X Write Buffer 5 Valid Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00209_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_WR_BUF6_VALID                                             #
#                                                                        #
##########################################################################

%pic_01_00210_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "WRT_VALID_BUFF"               => [   1,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Valid Buffers" ],
);

%pic_01_00210_def =
( NAME    => "BUS0_PCI_X_WR_BUF6_VALID",
  ADDRESS => 0x00000BD0,
  NOTE    => "PCI-X Write Buffer 6 Valid Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00210_flds
);


##########################################################################
#                                                                        #
#   BUS0_PCI_X_WR_BUF7_VALID                                             #
#                                                                        #
##########################################################################

%pic_01_00211_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "WRT_VALID_BUFF"               => [   1,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Valid Buffers" ],
);

%pic_01_00211_def =
( NAME    => "BUS0_PCI_X_WR_BUF7_VALID",
  ADDRESS => 0x00000BF0,
  NOTE    => "PCI-X Write Buffer 7 Valid Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00211_flds
);


##########################################################################
#                                                                        #
#   BUS1_BRIDGE_ID                                                       #
#                                                                        #
##########################################################################

%pic_01_00212_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "REV_NUM"                      => [   1,  28,   4, 0x00000000F0000000, 0x00, 0, 0x0000000000000000, "Revision Number (current revision of the widget)" ],
   "PART_NUM"                     => [   2,  12,  16, 0x000000000FFFF000, 0x00, 0, 0x0000000000000000, "Part Number (0xD1Y2 where Y = bus number 0/1)" ],
   "MFG_NUM"                      => [   3,   1,  11, 0x0000000000000FFE, 0x00, 0, 0x0000000000000000, "Manufacturer Identity (0x024)" ],
   "LSB"                          => [   4,   0,   1, 0x0000000000000001, 0x00, 0, 0x0000000000000000, "Always read as 1" ],
);

%pic_01_00212_def =
( NAME    => "BUS1_BRIDGE_ID",
  ADDRESS => 0x00800000,
  NOTE    => "Identification Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00212_flds
);


##########################################################################
#                                                                        #
#   BUS1_BRIDGE_STAT                                                     #
#                                                                        #
##########################################################################

%pic_01_00213_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  36,  28, 0xFFFFFFF000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PCI_X_SPEED"                  => [   1,  34,   2, 0x0000000C00000000, 0x00, 0, 0x0000000000000000, "Valid if PIC NOT using external clock" ],
   "PCI_X_ACTIVE"                 => [   2,  33,   1, 0x0000000200000000, 0x00, 0, 0x0000000000000000, "1=PCI-X mode, 0=PCI mode" ],
   "RSVD1"                        => [   3,  32,   1, 0x0000000100000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "LLP_REC_CNT"                  => [   4,  24,   8, 0x00000000FF000000, 0x00, 0, 0x0000000000000000, "LLP Receive counter (Check Bit errors only)" ],
   "LLP_TX_CNT"                   => [   5,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "LLP transmit retry counter" ],
   "RX_CREDIT_CNT"                => [   6,  12,   4, 0x000000000000F000, 0x00, 0, 0x0000000000000000, "Receive Credit Count" ],
   "TX_CREDIT_CNT"                => [   7,   8,   4, 0x0000000000000F00, 0x00, 0, 0x0000000000000000, "Transmit Credit Count" ],
   "RSVD2"                        => [   8,   0,   8, 0x00000000000000FF, 0x00, 0, 0x0000000000000000, "Reserved" ],
);

%pic_01_00213_def =
( NAME    => "BUS1_BRIDGE_STAT",
  ADDRESS => 0x00800008,
  NOTE    => "Status Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00213_flds
);


##########################################################################
#                                                                        #
#   BUS1_BRIDGE_ERR_UPPER                                                #
#                                                                        #
##########################################################################

%pic_01_00214_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "UPP_ADDR"                     => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00214_def =
( NAME    => "BUS1_BRIDGE_ERR_UPPER",
  ADDRESS => 0x00800010,
  NOTE    => "Upper Address Holding Register Bus Side Errors",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00214_flds
);


##########################################################################
#                                                                        #
#   BUS1_BRIDGE_ERR_LOWER                                                #
#                                                                        #
##########################################################################

%pic_01_00215_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "UPP_ADDR"                     => [   1,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [   2,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00215_def =
( NAME    => "BUS1_BRIDGE_ERR_LOWER",
  ADDRESS => 0x00800018,
  NOTE    => "Lower Address Holding Register Bus Side Errors",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00215_flds
);


##########################################################################
#                                                                        #
#   BUS1_BRIDGE_CTRL                                                     #
#                                                                        #
##########################################################################

%pic_01_00216_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  63,   1, 0x8000000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "NS"                           => [   1,  62,   1, 0x4000000000000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   2,  61,   1, 0x2000000000000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "RSVD1"                        => [   3,  56,   5, 0x1F00000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_NUM"                      => [   4,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "PCI-X Requester Bus Number" ],
   "DEV_NUM"                      => [   5,  43,   5, 0x0000F80000000000, 0x00, 0, 0x0000000000000000, "PCI-X Requester Device Number" ],
   "FUN_NUM"                      => [   6,  40,   3, 0x0000070000000000, 0x00, 0, 0x0000000000000000, "PCI-X Requester Function Number" ],
   "RSVD2"                        => [   7,  32,   8, 0x000000FF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PARITY_EN_ATE"                => [   8,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Enable Parity Checking internal ATE RAM, 1=On" ],
   "PARITY_EN_RESP"               => [   9,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Enable Parity Checking internal Resp RAM, 1=On" ],
   "PARITY_EN_REQ"                => [  10,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Enable Parity Checking internal Req RAM, 1=On" ],
   "RSVD3"                        => [  11,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RST_PIN_N(3:0)"               => [  12,  24,   4, 0x000000000F000000, 0x00, 0, 0x0000000000000000, "Software programmable reset pins" ],
   "RSVD4"                        => [  13,  23,   1, 0x0000000000800000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MEM_SWAP"                     => [  14,  22,   1, 0x0000000000400000, 0x00, 0, 0x0000000000000000, "Memory Enable Swapping (1 => enabled)" ],
   "PAGE_SIZE"                    => [  15,  21,   1, 0x0000000000200000, 0x00, 0, 0x0000000000000000, "Page Size 0 = > 4K 1 => 16K. PCI only" ],
   "RSVD5"                        => [  16,  17,   4, 0x00000000001E0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BAD_PKT"                    => [  17,  16,   1, 0x0000000000010000, 0x00, 0, 0x0000000000000000, "Force Bad LLP Micro-Packet Enable (1 => enabled)" ],
   "LLP_XBAR_CRD"                 => [  18,  12,   4, 0x000000000000F000, 0x00, 0, 0x0000000000000000, "LLP Crossbar Credit" ],
   "CLR_RLLP_CNT"                 => [  19,  11,   1, 0x0000000000000800, 0x00, 0, 0x0000000000000000, "Clear Receive LLP Retry Counter" ],
   "CLR_TLLP_CNT"                 => [  20,  10,   1, 0x0000000000000400, 0x00, 0, 0x0000000000000000, "Clear Transmit LLP Retry Counter" ],
   "SYS_END"                      => [  21,   9,   1, 0x0000000000000200, 0x00, 0, 0x0000000000000000, "System Endianess (1=Big, 0=Little)" ],
   "RSVD6"                        => [  22,   6,   3, 0x00000000000001C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PCI_SPEED"                    => [  23,   4,   2, 0x0000000000000030, 0x00, 0, 0x0000000000000000, "Read Only PCI Speed Select Input" ],
   "WIDGET_ID"                    => [  24,   0,   4, 0x000000000000000F, 0x00, 0, 0x0000000000000000, "Widget ID number." ],
);

%pic_01_00216_def =
( NAME    => "BUS1_BRIDGE_CTRL",
  ADDRESS => 0x00800020,
  NOTE    => "Control Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00216_flds
);


##########################################################################
#                                                                        #
#   BUS1_BRIDGE_REQ_TO                                                   #
#                                                                        #
##########################################################################

%pic_01_00217_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  20,  12, 0x00000000FFF00000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "TIME_OUT"                     => [   2,   0,  20, 0x00000000000FFFFF, 0x00, 0, 0x0000000000000000, "Reload Value for the response time-out counter" ],
);

%pic_01_00217_def =
( NAME    => "BUS1_BRIDGE_REQ_TO",
  ADDRESS => 0x00800028,
  NOTE    => "PCI Request Time-out Value Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00217_flds
);


##########################################################################
#                                                                        #
#   BUS1_BRIDGE_INT_UPPER                                                #
#                                                                        #
##########################################################################

%pic_01_00218_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  20,  12, 0x00000000FFF00000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "TARGET_ID"                    => [   2,  16,   4, 0x00000000000F0000, 0x00, 0, 0x0000000000000000, "Xtalk Target ID Number for error interrupt host" ],
   "UPP_ADDR"                     => [   3,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00218_def =
( NAME    => "BUS1_BRIDGE_INT_UPPER",
  ADDRESS => 0x00800030,
  NOTE    => "Interrupt Destination Upper Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00218_flds
);


##########################################################################
#                                                                        #
#   BUS1_BRIDGE_INT_LOWER                                                #
#                                                                        #
##########################################################################

%pic_01_00219_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  52,  12, 0xFFF0000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "TARGET_ID"                    => [   1,  48,   4, 0x000F000000000000, 0x00, 0, 0x0000000000000000, "Xtalk Target ID Number for error interrupt host" ],
   "UPP_ADDR"                     => [   2,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [   3,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00219_def =
( NAME    => "BUS1_BRIDGE_INT_LOWER",
  ADDRESS => 0x00800038,
  NOTE    => "Interrupt Destination Lower Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00219_flds
);


##########################################################################
#                                                                        #
#   BUS1_CMDWORD_HOLD_REG_BUS                                            #
#                                                                        #
##########################################################################

%pic_01_00220_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "DIDN"                         => [   1,  28,   4, 0x00000000F0000000, 0x00, 0, 0x0000000000000000, "Destination ID Number" ],
   "SIDN"                         => [   2,  24,   4, 0x000000000F000000, 0x00, 0, 0x0000000000000000, "Source ID Number" ],
   "PACTYP"                       => [   3,  20,   4, 0x0000000000F00000, 0x00, 0, 0x0000000000000000, "Packet Type" ],
   "TNUM"                         => [   4,  15,   5, 0x00000000000F8000, 0x00, 0, 0x0000000000000000, "Transaction number" ],
   "COHERENT"                     => [   5,  14,   1, 0x0000000000004000, 0x00, 0, 0x0000000000000000, "Coherent Transaction" ],
   "DS"                           => [   6,  12,   2, 0x0000000000003000, 0x00, 0, 0x0000000000000000, "Data Size" ],
   "GBR"                          => [   7,  11,   1, 0x0000000000000800, 0x00, 0, 0x0000000000000000, "Guaranteed Bandwidth Ring enable" ],
   "VBPM"                         => [   8,  10,   1, 0x0000000000000400, 0x00, 0, 0x0000000000000000, "Virtual Backplane Message" ],
   "ERROR"                        => [   9,   9,   1, 0x0000000000000200, 0x00, 0, 0x0000000000000000, "Error Occurred" ],
   "BARRIER"                      => [  10,   8,   1, 0x0000000000000100, 0x00, 0, 0x0000000000000000, "Barrier" ],
   "RSVD1"                        => [  11,   0,   8, 0x00000000000000FF, 0x00, 0, 0x0000000000000000, "Reserved" ],
);

%pic_01_00220_def =
( NAME    => "BUS1_CMDWORD_HOLD_REG_BUS",
  ADDRESS => 0x00800040,
  NOTE    => "Command Word Holding Register Bus Side Errors",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00220_flds
);


##########################################################################
#                                                                        #
#   BUS1_BRIDGE_LLP_CONFIG                                               #
#                                                                        #
##########################################################################

%pic_01_00221_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  26,   6, 0x00000000FC000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "LLP_MAXRETRY"                 => [   2,  16,  10, 0x0000000003FF0000, 0x00, 0, 0x0000000000000000, "LLP Max retry count." ],
   "LLP_NULLTIMEOUT"              => [   3,  10,   6, 0x000000000000FC00, 0x00, 0, 0x0000000000000000, "Null Time-out value" ],
   "LLP_MAXBURST"                 => [   4,   0,  10, 0x00000000000003FF, 0x00, 0, 0x0000000000000000, "LLP Max burst count." ],
);

%pic_01_00221_def =
( NAME    => "BUS1_BRIDGE_LLP_CONFIG",
  ADDRESS => 0x00800048,
  NOTE    => "LLP Configuration Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00221_flds
);


##########################################################################
#                                                                        #
#   BUS1_BRIDGE_TARG_FLUSH                                               #
#                                                                        #
##########################################################################

%pic_01_00222_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "STATUS"                       => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Flush status" ],
);

%pic_01_00222_def =
( NAME    => "BUS1_BRIDGE_TARG_FLUSH",
  ADDRESS => 0x00800050,
  NOTE    => "PCI/PCI-X Target Flush Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00222_flds
);


##########################################################################
#                                                                        #
#   BUS1_CMDWORD_HOLD_REG_LINK_SIDE                                      #
#                                                                        #
##########################################################################

%pic_01_00223_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "DIDN"                         => [   1,  28,   4, 0x00000000F0000000, 0x00, 0, 0x0000000000000000, "Destination ID Number" ],
   "SIDN"                         => [   2,  24,   4, 0x000000000F000000, 0x00, 0, 0x0000000000000000, "Source ID Number" ],
   "PACTYP"                       => [   3,  20,   4, 0x0000000000F00000, 0x00, 0, 0x0000000000000000, "Packet Type" ],
   "TNUM"                         => [   4,  15,   5, 0x00000000000F8000, 0x00, 0, 0x0000000000000000, "Transaction number" ],
   "COHERENT"                     => [   5,  14,   1, 0x0000000000004000, 0x00, 0, 0x0000000000000000, "Coherent Transaction" ],
   "DS"                           => [   6,  12,   2, 0x0000000000003000, 0x00, 0, 0x0000000000000000, "Data Size" ],
   "GBR"                          => [   7,  11,   1, 0x0000000000000800, 0x00, 0, 0x0000000000000000, "Guaranteed Bandwidth Ring enable" ],
   "VBPM"                         => [   8,  10,   1, 0x0000000000000400, 0x00, 0, 0x0000000000000000, "Virtual Backplane Message" ],
   "ERROR"                        => [   9,   9,   1, 0x0000000000000200, 0x00, 0, 0x0000000000000000, "Error Occurred" ],
   "BARRIER"                      => [  10,   8,   1, 0x0000000000000100, 0x00, 0, 0x0000000000000000, "Barrier" ],
   "RSVD1"                        => [  11,   0,   8, 0x00000000000000FF, 0x00, 0, 0x0000000000000000, "Reserved" ],
);

%pic_01_00223_def =
( NAME    => "BUS1_CMDWORD_HOLD_REG_LINK_SIDE",
  ADDRESS => 0x00800058,
  NOTE    => "Command Word Holding Register Link Side Errors",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00223_flds
);


##########################################################################
#                                                                        #
#   BUS1_BRIDGE_RESP_UPPER                                               #
#                                                                        #
##########################################################################

%pic_01_00224_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "COMMAND"                      => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Crosstalk Command Word" ],
   "RSVD1"                        => [   1,  23,   9, 0x00000000FF800000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "DEV_NUM"                      => [   2,  20,   3, 0x0000000000700000, 0x00, 0, 0x0000000000000000, "Device Number" ],
   "BUFF_NUM"                     => [   3,  16,   4, 0x00000000000F0000, 0x00, 0, 0x0000000000000000, "Buffer Number" ],
   "UPP_ADDR"                     => [   4,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00224_def =
( NAME    => "BUS1_BRIDGE_RESP_UPPER",
  ADDRESS => 0x00800060,
  NOTE    => "PCI Response Buffer Error Upper Address Holding Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00224_flds
);


##########################################################################
#                                                                        #
#   BUS1_BRIDGE_RESP_LOWER                                               #
#                                                                        #
##########################################################################

%pic_01_00225_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  55,   9, 0xFF80000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "DEV_NUM"                      => [   1,  52,   3, 0x0070000000000000, 0x00, 0, 0x0000000000000000, "Device Number" ],
   "BUFF_NUM"                     => [   2,  48,   4, 0x000F000000000000, 0x00, 0, 0x0000000000000000, "Buffer Number" ],
   "UPP_ADDR"                     => [   3,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [   4,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00225_def =
( NAME    => "BUS1_BRIDGE_RESP_LOWER",
  ADDRESS => 0x00800068,
  NOTE    => "PCI Response Buffer Error Lower Address Holding Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00225_flds
);


##########################################################################
#                                                                        #
#   BUS1_DEBUG_PORT_CTRL                                                 #
#                                                                        #
##########################################################################

%pic_01_00226_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  24,  40, 0xFFFFFFFFFF000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "DEBUG_SEL_U"                  => [   1,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Upper Selection (32 bit debug vector within module)" ],
   "DEBUG_M_U"                    => [   2,  12,   4, 0x000000000000F000, 0x00, 0, 0x0000000000000000, "Module Select Port 1 - Upper" ],
   "DEBUG_SEL_L"                  => [   3,   4,   8, 0x0000000000000FF0, 0x00, 0, 0x0000000000000000, "Lower Selection (32 bit debug vector within module)" ],
   "DEBUG_M_L"                    => [   4,   0,   4, 0x000000000000000F, 0x00, 0, 0x0000000000000000, "Module Select Port 0 - Lower" ],
);

%pic_01_00226_def =
( NAME    => "BUS1_DEBUG_PORT_CTRL",
  ADDRESS => 0x00800070,
  NOTE    => "Test Pin Control Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00226_flds
);


##########################################################################
#                                                                        #
#   BUS1_ADDR_HOLD_REG_LINK_SIDE                                         #
#                                                                        #
##########################################################################

%pic_01_00227_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "UPP_ADDR"                     => [   1,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [   2,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00227_def =
( NAME    => "BUS1_ADDR_HOLD_REG_LINK_SIDE",
  ADDRESS => 0x00800078,
  NOTE    => "Address Holding Register Link Side Errors",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00227_flds
);


##########################################################################
#                                                                        #
#   BUS1_DIR_MAP                                                         #
#                                                                        #
##########################################################################

%pic_01_00228_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  24,   8, 0x00000000FF000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "DIR_W_ID"                     => [   2,  20,   4, 0x0000000000F00000, 0x00, 0, 0x0000000000000000, "Direct space target widget ID" ],
   "RSVD2"                        => [   3,  18,   2, 0x00000000000C0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "DIR_ADD512"                   => [   4,  17,   1, 0x0000000000020000, 0x00, 0, 0x0000000000000000, "Direct add 512MB offset only when DIR_OFF = 0x000" ],
   "DIR_OFF"                      => [   5,   0,  17, 0x000000000001FFFF, 0x00, 0, 0x0000000000000000, "Direct Map Offset" ],
);

%pic_01_00228_def =
( NAME    => "BUS1_DIR_MAP",
  ADDRESS => 0x00800080,
  NOTE    => "PCI Direct Mapping Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00228_flds
);


##########################################################################
#                                                                        #
#   BUS1_MAP_FAULT_ADDR_                                                 #
#                                                                        #
##########################################################################

%pic_01_00229_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  22,  10, 0x00000000FFC00000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PCI"                          => [   2,   0,   1, 0x0000000000000001, 0x00, 0, 0x0000000000000000, "0 PCI Address bit 29:12" ],
   "RSVD2"                        => [   3,   3,   1, 0x0000000000000008, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PCI_DEV_NUM"                  => [   4,   0,   3, 0x0000000000000007, 0x00, 0, 0x0000000000000000, "PCI Device Number" ],
);

%pic_01_00229_def =
( NAME    => "BUS1_MAP_FAULT_ADDR_",
  ADDRESS => 0x00800090,
  NOTE    => "PCI Page Map Fault Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00229_flds
);


##########################################################################
#                                                                        #
#   BUS1_ARB_PRIORITY                                                    #
#                                                                        #
##########################################################################

%pic_01_00230_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  24,   8, 0x00000000FF000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "DEV_BROKE"                    => [   2,  20,   4, 0x0000000000F00000, 0x00, 0, 0x0000000000000000, "Device Broke" ],
   "RSVD2"                        => [   3,  18,   2, 0x00000000000C0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "REQ_WAIT_TICK"                => [   4,  16,   2, 0x0000000000030000, 0x00, 0, 0x0000000000000000, "Time period used by the arbiter request wait circuit" ],
   "RSVD3"                        => [   5,  12,   4, 0x000000000000F000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "REQ_WAIT_EN"                  => [   6,   8,   4, 0x0000000000000F00, 0x00, 0, 0x0000000000000000, "Enable the arbiter to delay issuing bus grants" ],
   "RSVD4"                        => [   7,   7,   1, 0x0000000000000080, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "FREEZE_GNT"                   => [   8,   6,   1, 0x0000000000000040, 0x00, 0, 0x0000000000000000, "No grant to the PCI devices and PIC internal circuit" ],
   "RSVD5"                        => [   9,   5,   1, 0x0000000000000020, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "EN_BRIDGE_HI"                 => [  10,   3,   2, 0x0000000000000018, 0x00, 0, 0x0000000000000000, "Enable PIC to request the bus in the high priority ring" ],
   "RSVD6"                        => [  11,   2,   1, 0x0000000000000004, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "EN_BRIDGE_LO"                 => [  12,   0,   2, 0x0000000000000003, 0x00, 0, 0x0000000000000000, "Enable PIC to request the bus in the low priority ring" ],
);

%pic_01_00230_def =
( NAME    => "BUS1_ARB_PRIORITY",
  ADDRESS => 0x008000A0,
  NOTE    => "Arbitration Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00230_flds
);


##########################################################################
#                                                                        #
#   BUS1_INT_RAM_PERR                                                    #
#                                                                        #
##########################################################################

%pic_01_00231_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  55,   9, 0xFF80000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "ADDR_ATE"                     => [   1,  48,  10, 0x03FF000000000000, 0x00, 0, 0x0000000000000000, "ATE Ram Error Address" ],
   "RSVD1"                        => [   2,  41,   7, 0x0000FE0000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "ADDR_RESP"                    => [   3,  32,   9, 0x000001FF00000000, 0x00, 0, 0x0000000000000000, "Read Response Ram Error Address" ],
   "ADDR_REQ"                     => [   4,  24,   8, 0x00000000FF000000, 0x00, 0, 0x0000000000000000, "Write Request Ram Error Address" ],
   "RSVD2"                        => [   5,  22,   2, 0x0000000000C00000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "WRT_ERR_ATE"                  => [   6,  21,   1, 0x0000000000200000, 0x00, 0, 0x0000000000000000, "ATE RAM error" ],
   "WRT_ERR_RESP"                 => [   7,  20,   1, 0x0000000000100000, 0x00, 0, 0x0000000000000000, "Read Response RAM error" ],
   "WRT_ERR_REQ"                  => [   8,  19,   1, 0x0000000000080000, 0x00, 0, 0x0000000000000000, "Write Request RAM error" ],
   "RSVD3"                        => [   9,  17,   2, 0x0000000000060000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "DBE_RESP"                     => [  10,  16,   1, 0x0000000000010000, 0x00, 0, 0x0000000000000000, "Indicates the dw in error of the Read Resp Ram" ],
   "DBE_REQ"                      => [  11,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Indicates the byte in error Write Request Ram" ],
);

%pic_01_00231_def =
( NAME    => "BUS1_INT_RAM_PERR",
  ADDRESS => 0x008000B0,
  NOTE    => "Internal Ram Parity Error Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00231_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_TOUT                                                        #
#                                                                        #
##########################################################################

%pic_01_00232_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  21,  11, 0x00000000FFE00000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PCI_RETRY_HLD"                => [   2,  16,   5, 0x00000000001F0000, 0x00, 0, 0x0000000000000000, "PCI retry hold" ],
   "RSVD2"                        => [   3,  10,   6, 0x000000000000FC00, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PCI_RETRY_CNT"                => [   4,   0,  10, 0x00000000000003FF, 0x00, 0, 0x0000000000000000, "PCI retry count" ],
);

%pic_01_00232_def =
( NAME    => "BUS1_PCI_TOUT",
  ADDRESS => 0x008000C0,
  NOTE    => "PCI/PCI-X Time-out Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00232_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_TYPE1_CONFIG                                                #
#                                                                        #
##########################################################################

%pic_01_00233_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  24,   8, 0x00000000FF000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_NUM"                      => [   2,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Bus Number (select 1 of 256 buses)" ],
   "DEV_NUM"                      => [   3,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "Device Number (select 1 of 32 devices)" ],
   "RSVD2"                        => [   4,   0,  11, 0x00000000000007FF, 0x00, 0, 0x0000000000000000, "Reserved" ],
);

%pic_01_00233_def =
( NAME    => "BUS1_PCI_TYPE1_CONFIG",
  ADDRESS => 0x008000C8,
  NOTE    => "PCI/PCI-X Type 1 Configuration Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00233_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_ERR_UPPER_ADDR                                              #
#                                                                        #
##########################################################################

%pic_01_00234_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  28,   4, 0x00000000F0000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PCI_XTALK_DID"                => [   2,  24,   4, 0x000000000F000000, 0x00, 0, 0x0000000000000000, "Target Xtalk ID" ],
   "RSVD2"                        => [   3,  22,   2, 0x0000000000C00000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PCI_DAC"                      => [   4,  21,   1, 0x0000000000200000, 0x00, 0, 0x0000000000000000, "Dual Address Cycle" ],
   "PCI_DEV_MASTER"               => [   5,  20,   1, 0x0000000000100000, 0x00, 0, 0x0000000000000000, "PIC was not PCI master when the error occurred" ],
   "PCI_VDEV"                     => [   6,  19,   1, 0x0000000000080000, 0x00, 0, 0x0000000000000000, "Value of the Virtual Request." ],
   "PCI_DEV_NUM"                  => [   7,  16,   3, 0x0000000000070000, 0x00, 0, 0x0000000000000000, "DEVNUM of PCI master when the error occurred" ],
   "PCI_UADDR_ERR"                => [   8,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address of the PCI bus command (PCI address 47:32)" ],
);

%pic_01_00234_def =
( NAME    => "BUS1_PCI_ERR_UPPER_ADDR",
  ADDRESS => 0x008000D0,
  NOTE    => "PCI Bus Error Upper Address Holding Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00234_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_ERR_LOWER_ADDR                                              #
#                                                                        #
##########################################################################

%pic_01_00235_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  60,   4, 0xF000000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PCI_XTALK_DID"                => [   1,  56,   4, 0x0F00000000000000, 0x00, 0, 0x0000000000000000, "Target Xtalk ID" ],
   "RSVD1"                        => [   2,  54,   2, 0x00C0000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PCI_DAC"                      => [   3,  53,   1, 0x0020000000000000, 0x00, 0, 0x0000000000000000, "Dual Address Cycle" ],
   "PCI_DEV_MASTER"               => [   4,  52,   1, 0x0010000000000000, 0x00, 0, 0x0000000000000000, "PIC was not PCI master when the error occurred" ],
   "PCI_VDEV"                     => [   5,  51,   1, 0x0008000000000000, 0x00, 0, 0x0000000000000000, "Value of the Virtual Request." ],
   "PCI_DEV_NUM"                  => [   6,  48,   3, 0x0007000000000000, 0x00, 0, 0x0000000000000000, "DEVNUM of PCI master when the error occurred" ],
   "PCI_UADDR_ERR"                => [   7,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address of the PCI bus command (PCI address 47:32)" ],
   "PCI_LADDR_ERR"                => [   8,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address of the PCI bus command (PCI address 31:0)" ],
);

%pic_01_00235_def =
( NAME    => "BUS1_PCI_ERR_LOWER_ADDR",
  ADDRESS => 0x008000D8,
  NOTE    => "PCI Bus Error Lower Address Holding Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00235_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_ERR_ADDR                                                  #
#                                                                        #
##########################################################################

%pic_01_00236_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "PCIX_ERR_ADDR"                => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "PCI-X Error Address" ],
);

%pic_01_00236_def =
( NAME    => "BUS1_PCI_X_ERR_ADDR",
  ADDRESS => 0x00800600,
  NOTE    => "PCI-X Error Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00236_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_ERR_ATTR                                                  #
#                                                                        #
##########################################################################

%pic_01_00237_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  49,  15, 0xFFFE000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "DAC"                          => [   1,  48,   1, 0x0001000000000000, 0x00, 0, 0x0000000000000000, "1=PCI-X Dual Address Cycle, 0=PCI-X Single Address Cycle" ],
   "BUS_CMD"                      => [   2,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   3,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "RSVD1"                        => [   4,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "NS"                           => [   5,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   6,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   7,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   8,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requester Bus Number" ],
   "DEV_NUM"                      => [   9,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requester Device Number" ],
   "FUN_NUM"                      => [  10,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requester Function Number" ],
   "L_BYTE_CNT"                   => [  11,   0,   8, 0x00000000000000FF, 0x00, 0, 0x0000000000000000, "PCI-X Lower Byte Count" ],
);

%pic_01_00237_def =
( NAME    => "BUS1_PCI_X_ERR_ATTR",
  ADDRESS => 0x00800608,
  NOTE    => "PCI-X Error Attribute Register Dword/Burst Definitions",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00237_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_ERR_DATA                                                  #
#                                                                        #
##########################################################################

%pic_01_00238_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "PCIX_ERR_DATA"                => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "PCI-X Error Data" ],
);

%pic_01_00238_def =
( NAME    => "BUS1_PCI_X_ERR_DATA",
  ADDRESS => 0x00800610,
  NOTE    => "PCI-X Error Data Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00238_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_PIO_SPLIT_ERR_ADDR                                        #
#                                                                        #
##########################################################################

%pic_01_00239_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PCIX_ERR_ADDR"                => [   1,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "PCI-X Error Address" ],
);

%pic_01_00239_def =
( NAME    => "BUS1_PCI_X_PIO_SPLIT_ERR_ADDR",
  ADDRESS => 0x00800618,
  NOTE    => "PCI-X PIO Split Request Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00239_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_PIO_SPLIT_ERR_ATTR                                        #
#                                                                        #
##########################################################################

%pic_01_00240_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  36,  28, 0xFFFFFFF000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUSCMD"                       => [   1,  32,   4, 0x0000000F00000000, 0x00, 0, 0x0000000000000000, "Command Encoding" ],
   "RSVD1"                        => [   2,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "NS"                           => [   3,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   4,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   5,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   6,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requester Bus Number" ],
   "DEV_NUM"                      => [   7,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requester Device Number" ],
   "FUN_NUM"                      => [   8,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requester Function Number" ],
   "LOWER_BYTE_CNT"               => [   9,   0,   8, 0x00000000000000FF, 0x00, 0, 0x0000000000000000, "PCI-X Byte Count" ],
);

%pic_01_00240_def =
( NAME    => "BUS1_PCI_X_PIO_SPLIT_ERR_ATTR",
  ADDRESS => 0x00800620,
  NOTE    => "PCI-X PIO Split Request Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00240_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_DMA_ERR_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00241_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  53,  11, 0xFFE0000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "XDMA_ERR_EVT_CODE"            => [   1,  49,   4, 0x001E000000000000, 0x00, 0, 0x0000000000000000, "Event Code" ],
   "XDMA_ERR_OP_INDEX"            => [   2,  45,   4, 0x0001E00000000000, 0x00, 0, 0x0000000000000000, "Entry index into the OP Table" ],
   "XDMA_ERR_CL_INDEX"            => [   3,  39,   6, 0x00001F8000000000, 0x00, 0, 0x0000000000000000, "Cache Line index for which the error occurred" ],
   "XDMA_ERR_NS"                  => [   4,  38,   1, 0x0000004000000000, 0x00, 0, 0x0000000000000000, "Op Info - No Snoop" ],
   "XDMA_ERR_DEV_NUM_L"           => [   5,  36,   2, 0x0000003000000000, 0x00, 0, 0x0000000000000000, "Op Info - Device Number Low Bits (PIC supports 0-3)" ],
   "XDMA_ERR_D64"                 => [   6,  35,   1, 0x0000000800000000, 0x00, 0, 0x0000000000000000, "Op Info - PCI-X Data 64 Mode" ],
   "XDMA_ERR_RD_IS_DW"            => [   7,  34,   1, 0x0000000400000000, 0x00, 0, 0x0000000000000000, "Op Info - PCI-X Double Word Read" ],
   "XDMA_ERR_BYTE_CNT"            => [   8,  22,  12, 0x00000003FFC00000, 0x00, 0, 0x0000000000000000, "Op Info - PCI-X Byte Count" ],
   "XDMA_ERR_RO"                  => [   9,  21,   1, 0x0000000000200000, 0x00, 0, 0x0000000000000000, "Op Info - PCI-X Relaxed Ordering" ],
   "XDMA_ERR_TAG"                 => [  10,  16,   5, 0x00000000001F0000, 0x00, 0, 0x0000000000000000, "Op Info - PCI-X TAG" ],
   "XDMA_ERR_BUS_NUM"             => [  11,   8,   8, 0x000000000000FF00, 0x00, 0, 0x0000000000000000, "Op Info - PCI-X Requester Bus Number" ],
   "XDMA_ERR_DEV_NUM"             => [  12,   3,   5, 0x00000000000000F8, 0x00, 0, 0x0000000000000000, "Op Info - PCI-X Requester Device Number" ],
   "XDMA_ERR_FUN_NUM"             => [  13,   0,   3, 0x0000000000000007, 0x00, 0, 0x0000000000000000, "Op Info - PCI-X Requester Function Number" ],
);

%pic_01_00241_def =
( NAME    => "BUS1_PCI_X_DMA_ERR_ATTR",
  ADDRESS => 0x00800628,
  NOTE    => "PCI-X DMA Request Error Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00241_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_DMA_ERR_ADDR                                              #
#                                                                        #
##########################################################################

%pic_01_00242_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "XDMA_ERR_ADDR"                => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "PCI-X Address" ],
);

%pic_01_00242_def =
( NAME    => "BUS1_PCI_X_DMA_ERR_ADDR",
  ADDRESS => 0x00800630,
  NOTE    => "PCI-X DMA Request Error Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00242_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_READ_REQ_TOUT                                             #
#                                                                        #
##########################################################################

%pic_01_00243_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  20,  44, 0xFFFFFFFFFFF00000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "TIME_OUT"                     => [   1,   0,  20, 0x00000000000FFFFF, 0x00, 0, 0x0000000000000000, "Reload Value (0x00000 is an ILLEGAL setting and must not be used!)" ],
);

%pic_01_00243_def =
( NAME    => "BUS1_PCI_X_READ_REQ_TOUT",
  ADDRESS => 0x00800638,
  NOTE    => "PCI-X Timeout Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00243_flds
);


##########################################################################
#                                                                        #
#   BUS1_INT_STATUS                                                      #
#                                                                        #
##########################################################################

%pic_01_00244_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  46,  18, 0xFFFFC00000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PCI_X_SPLIT_MES_PE"           => [   1,  45,   1, 0x0000200000000000, 0x00, 0, 0x0000000000000000, "PCI-X Split Completion Message Parity Error" ],
   "PCI_X_SPLIT_EMESS"            => [   2,  44,   1, 0x0000100000000000, 0x00, 0, 0x0000000000000000, "PCI-X Split Completion Error Message" ],
   "PCI_X_SPLIT_TO"               => [   3,  43,   1, 0x0000080000000000, 0x00, 0, 0x0000000000000000, "PCI-X Split Completion Timeout" ],
   "PCI_X_UNEX_COMP"              => [   4,  42,   1, 0x0000040000000000, 0x00, 0, 0x0000000000000000, "PCI-X Unexpected Completion cycle to master" ],
   "INT_RAM_PERR"                 => [   5,  41,   1, 0x0000020000000000, 0x00, 0, 0x0000000000000000, "Internal Ram Parity Error" ],
   "PCI_X_ARB_ERR"                => [   6,  40,   1, 0x0000010000000000, 0x00, 0, 0x0000000000000000, "PCI-X Device Requesting Arb Error" ],
   "PCI_X_REQ_TOUT"               => [   7,  39,   1, 0x0000008000000000, 0x00, 0, 0x0000000000000000, "PCI-X Read Request Time Out" ],
   "PCI_X_TABORT"                 => [   8,  38,   1, 0x0000004000000000, 0x00, 0, 0x0000000000000000, "PCI-X Target Abort" ],
   "PCI_X_PERR"                   => [   9,  37,   1, 0x0000002000000000, 0x00, 0, 0x0000000000000000, "PCI-X PERR" ],
   "PCI_X_SERR"                   => [  10,  36,   1, 0x0000001000000000, 0x00, 0, 0x0000000000000000, "PCI-X SERR" ],
   "PCI_X_MRETRY"                 => [  11,  35,   1, 0x0000000800000000, 0x00, 0, 0x0000000000000000, "PCI-X pio retry counter exhausted" ],
   "PCI_X_MTOUT"                  => [  12,  34,   1, 0x0000000400000000, 0x00, 0, 0x0000000000000000, "PCI-X Master Timeout" ],
   "PCI_X_DA_PARITY"              => [  13,  33,   1, 0x0000000200000000, 0x00, 0, 0x0000000000000000, "PCI-X Data cycle parity error detected by PIC" ],
   "PCI_X_AD_PARITY"              => [  14,  32,   1, 0x0000000100000000, 0x00, 0, 0x0000000000000000, "PCI-X Address or Attribute cycle parity error" ],
   "RSVD1"                        => [  15,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PMU_PAGE_FAULT"               => [  16,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Indicates an Invalid PCI Page Access" ],
   "UNEXPECTED_RESP"              => [  17,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "This bit indicates that an unexpected response arrived" ],
   "BAD_XRESP_PACKET"             => [  18,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Data size in command word of a response did not match" ],
   "BAD_XREQ_PACKET"              => [  19,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Data size in command word of a request did not match" ],
   "RESP_XTALK_ERROR"             => [  20,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Response packet had error bit set or invalid sideband" ],
   "REQ_XTALK_ERROR"              => [  21,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Request packet had error bit set or invalid sideband" ],
   "INVALID_ACCESS"               => [  22,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Packet contains an invalid address/access type" ],
   "UNSUPPORTED_XOP"              => [  23,  23,   1, 0x0000000000800000, 0x00, 0, 0x0000000000000000, "Request operation is not supported by PIC" ],
   "XREQ_FIFO_OFLOW"              => [  24,  22,   1, 0x0000000000400000, 0x00, 0, 0x0000000000000000, "Request packet overflow" ],
   "LLP_REC_SNERROR"              => [  25,  21,   1, 0x0000000000200000, 0x00, 0, 0x0000000000000000, "LLP Receiver Sequence Number Error" ],
   "LLP_REC_CBERROR"              => [  26,  20,   1, 0x0000000000100000, 0x00, 0, 0x0000000000000000, "LLP Receiver Check Bit Error" ],
   "LLP_RCTY"                     => [  27,  19,   1, 0x0000000000080000, 0x00, 0, 0x0000000000000000, "LLP Receiver Retry Count Interrupt" ],
   "LLP_TX_RETRY"                 => [  28,  18,   1, 0x0000000000040000, 0x00, 0, 0x0000000000000000, "LLP Transmitter Retry" ],
   "LLP_TCTY"                     => [  29,  17,   1, 0x0000000000020000, 0x00, 0, 0x0000000000000000, "LLP Transmitter Retry Count Interrupt" ],
   "RSVD2"                        => [  30,  16,   1, 0x0000000000010000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PCI_ABORT"                    => [  31,  15,   1, 0x0000000000008000, 0x00, 0, 0x0000000000000000, "Status of PCI slave abort condition interrupt" ],
   "PCI_PARITY"                   => [  32,  14,   1, 0x0000000000004000, 0x00, 0, 0x0000000000000000, "Indicates the PIC detected a parity error." ],
   "PCI_SERR"                     => [  33,  13,   1, 0x0000000000002000, 0x00, 0, 0x0000000000000000, "Status PCI Address/CMD parity error interrupt" ],
   "PCI_PERR"                     => [  34,  12,   1, 0x0000000000001000, 0x00, 0, 0x0000000000000000, "Status of PCI parity error interrupt" ],
   "PCI_MASTER_TOUT"              => [  35,  11,   1, 0x0000000000000800, 0x00, 0, 0x0000000000000000, "Indicates a device select timeout on the PCI bus." ],
   "PCI_RETRY_CNT"                => [  36,  10,   1, 0x0000000000000400, 0x00, 0, 0x0000000000000000, "PCI retry operation count exhausted." ],
   "XREAD_REQ_TOUT"               => [  37,   9,   1, 0x0000000000000200, 0x00, 0, 0x0000000000000000, "PCI to Crosstalk read request timeout." ],
   "RSVD3"                        => [  38,   8,   1, 0x0000000000000100, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT_STATE"                    => [  39,   0,   8, 0x00000000000000FF, 0x00, 0, 0x0000000000000000, "Status of INT_N[7:0]. A 1 means INT_N is low." ],
);

%pic_01_00244_def =
( NAME    => "BUS1_INT_STATUS",
  ADDRESS => 0x00800100,
  NOTE    => "Interrupt Status Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00244_flds
);


##########################################################################
#                                                                        #
#   BUS1_INT_ENABLE                                                      #
#                                                                        #
##########################################################################

%pic_01_00245_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  46,  18, 0xFFFFC00000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "EN_PCI_X_SPLIT_MES_PE"        => [   1,  45,   1, 0x0000200000000000, 0x00, 0, 0x0000000000000000, "PCI-X Split Completion Message Parity Error" ],
   "EN_PCI_X_SPLIT_EMESS"         => [   2,  44,   1, 0x0000100000000000, 0x00, 0, 0x0000000000000000, "PCI-X Split Completion Error Message" ],
   "EN_PCI_X_SPLIT_TO"            => [   3,  43,   1, 0x0000080000000000, 0x00, 0, 0x0000000000000000, "PCI-X Split Completion Timeout" ],
   "EN_PCI_X_UNEX_COMP"           => [   4,  42,   1, 0x0000040000000000, 0x00, 0, 0x0000000000000000, "PCI-X Unexpected Completion" ],
   "EN_INT_RAM_PERR"              => [   5,  41,   1, 0x0000020000000000, 0x00, 0, 0x0000000000000000, "Internal Ram Parity Error" ],
   "EN_PCI_X_ARB_ERR"             => [   6,  40,   1, 0x0000010000000000, 0x00, 0, 0x0000000000000000, "PCI-X Arb Error" ],
   "EN_PCI_X_REQ_TOUT"            => [   7,  39,   1, 0x0000008000000000, 0x00, 0, 0x0000000000000000, "PCI-X Read Request Time Out" ],
   "EN_PCI_X_TABORT"              => [   8,  38,   1, 0x0000004000000000, 0x00, 0, 0x0000000000000000, "PCI-X Target Abort" ],
   "EN_PCI_X_PERR"                => [   9,  37,   1, 0x0000002000000000, 0x00, 0, 0x0000000000000000, "PCI-X PERR" ],
   "EN_PCI_X_SERR"                => [  10,  36,   1, 0x0000001000000000, 0x00, 0, 0x0000000000000000, "PCI-X SERR" ],
   "EN_PCI_X_MRETRY"              => [  11,  35,   1, 0x0000000800000000, 0x00, 0, 0x0000000000000000, "PCI-X pio retry counter exhausted" ],
   "EN_PCI_X_MTOUT"               => [  12,  34,   1, 0x0000000400000000, 0x00, 0, 0x0000000000000000, "PCI-X Master Timeout" ],
   "EN_PCI_X_DA_PARITY"           => [  13,  33,   1, 0x0000000200000000, 0x00, 0, 0x0000000000000000, "PCI-X Data cycle parity error detected by PIC" ],
   "EN_PCI_X_AD_PARITY"           => [  14,  32,   1, 0x0000000100000000, 0x00, 0, 0x0000000000000000, "PCI-X Address or Attribute cycle parity error" ],
   "RSVD1"                        => [  15,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "EN_PMU_PAGE_FAULT"            => [  16,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Indicates an Invalid Page Access" ],
   "EN_UNEXPECTED_RESP"           => [  17,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Enables unexpected response interrupt." ],
   "EN_BAD_XRESP_PACKET"          => [  18,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Enables bad Crosstalk packet interrupt." ],
   "EN_BAD_XREQ_PACKET"           => [  19,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Enables bad Crosstalk packet interrupt." ],
   "EN_RESP_XTALK_ERROR"          => [  20,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Enables Crosstalk error interrupt." ],
   "EN_REQ_XTALK_ERROR"           => [  21,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Enables Crosstalk error interrupt." ],
   "EN_INVALID_ACCESS"            => [  22,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Enables invalid address/datasize/access error interrupt." ],
   "EN_UNSUPPORTED_XOP"           => [  23,  23,   1, 0x0000000000800000, 0x00, 0, 0x0000000000000000, "Enables unsupported operation error." ],
   "EN_XREQ_FIFO_OFLOW"           => [  24,  22,   1, 0x0000000000400000, 0x00, 0, 0x0000000000000000, "Enables Crosstalk request fifo overflow interrupt." ],
   "EN_LLP_REC_SNERROR"           => [  25,  21,   1, 0x0000000000200000, 0x00, 0, 0x0000000000000000, "Enables LLP Receiver Sequence Number Error interrupt." ],
   "EN_LLP_REC_CBERROR"           => [  26,  20,   1, 0x0000000000100000, 0x00, 0, 0x0000000000000000, "Enables LLP Receiver Check Bit Error interrupt." ],
   "EN_LLP_RCTY"                  => [  27,  19,   1, 0x0000000000080000, 0x00, 0, 0x0000000000000000, "Enables Receiver Retry Count interrupt." ],
   "EN_LLP_TX_RETRY"              => [  28,  18,   1, 0x0000000000040000, 0x00, 0, 0x0000000000000000, "Enables LLP Transmitter Retry interrupt." ],
   "EN_LLP_TCTY"                  => [  29,  17,   1, 0x0000000000020000, 0x00, 0, 0x0000000000000000, "Enables Crosstalk LLP Transmitter Retry Count interrupt." ],
   "RSVD2"                        => [  30,  16,   1, 0x0000000000010000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "EN_PCI_ABORT"                 => [  31,  15,   1, 0x0000000000008000, 0x00, 0, 0x0000000000000000, "Enables PCI master/slave abort condition interrupt" ],
   "EN_PCI_PARITY"                => [  32,  14,   1, 0x0000000000004000, 0x00, 0, 0x0000000000000000, "Enables PCI parity error interrupt." ],
   "EN_PCI_SERR"                  => [  33,  13,   1, 0x0000000000002000, 0x00, 0, 0x0000000000000000, "Enables PCI Address/CMD parity error interrupt" ],
   "EN_PCI_PERR"                  => [  34,  12,   1, 0x0000000000001000, 0x00, 0, 0x0000000000000000, "Enables PCI parity error interrupt" ],
   "EN_PCI_MASTER_TOUT"           => [  35,  11,   1, 0x0000000000000800, 0x00, 0, 0x0000000000000000, "Enables PCI master timeout interrupt." ],
   "EN_PCI_RETRY_CNT"             => [  36,  10,   1, 0x0000000000000400, 0x00, 0, 0x0000000000000000, "Enables PCI retry count interrupt." ],
   "EN_XREAD_REQ_TOUT"            => [  37,   9,   1, 0x0000000000000200, 0x00, 0, 0x0000000000000000, "Enables Crosstalk read request timeout interrupt." ],
   "RSVD3"                        => [  38,   8,   1, 0x0000000000000100, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "EN_INT_STATE"                 => [  39,   0,   8, 0x00000000000000FF, 0x00, 0, 0x0000000000000000, "Enables INT_N[7:0]." ],
);

%pic_01_00245_def =
( NAME    => "BUS1_INT_ENABLE",
  ADDRESS => 0x00800108,
  NOTE    => "Interrupt Enable Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00245_flds
);


##########################################################################
#                                                                        #
#   BUS1_RESET_INT_STATUS                                                #
#                                                                        #
##########################################################################

%pic_01_00246_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  46,  18, 0xFFFFC00000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "LOGV_PCI_X_SPLIT_MES_PE"      => [   1,  45,   1, 0x0000200000000000, 0x00, 0, 0x0000000000000000, "PCI-X Split Completion Message Parity Error" ],
   "LOGV_PCI_X_SPLIT_EMESS"       => [   2,  44,   1, 0x0000100000000000, 0x00, 0, 0x0000000000000000, "PCI-X Split Completion Error Message" ],
   "LOGV_PCI_X_SPLIT_TO"          => [   3,  43,   1, 0x0000080000000000, 0x00, 0, 0x0000000000000000, "PCI-X Split Completion Timeout" ],
   "LOGV_PCI_X_UNEX_COMP"         => [   4,  42,   1, 0x0000040000000000, 0x00, 0, 0x0000000000000000, "PCI-X Unexpected Completion cycle to master" ],
   "LOGV_INT_RAM_PERR"            => [   5,  41,   1, 0x0000020000000000, 0x00, 0, 0x0000000000000000, "Internal Ram Parity Error" ],
   "LOGV_PCI_X_ARB_ERR"           => [   6,  40,   1, 0x0000010000000000, 0x00, 0, 0x0000000000000000, "PCI-X Arb Error" ],
   "LOGV_PCI_X_REQ_TOUT"          => [   7,  39,   1, 0x0000008000000000, 0x00, 0, 0x0000000000000000, "PCI-X Read Request Time Out" ],
   "LOGV_PCI_X_TABORT"            => [   8,  38,   1, 0x0000004000000000, 0x00, 0, 0x0000000000000000, "PCI-X Target Abort" ],
   "LOGV_PCI_X_PERR"              => [   9,  37,   1, 0x0000002000000000, 0x00, 0, 0x0000000000000000, "PCI-X PERR" ],
   "LOGV_PCI_X_SERR"              => [  10,  36,   1, 0x0000001000000000, 0x00, 0, 0x0000000000000000, "PCI-X SERR" ],
   "LOGV_PCI_X_MRETRY"            => [  11,  35,   1, 0x0000000800000000, 0x00, 0, 0x0000000000000000, "PCI-X pio retry counter exhausted" ],
   "LOGV_PCI_X_MTOUT"             => [  12,  34,   1, 0x0000000400000000, 0x00, 0, 0x0000000000000000, "PCI-X Master Timeout" ],
   "LOGV_PCI_X_DA_PARITY"         => [  13,  33,   1, 0x0000000200000000, 0x00, 0, 0x0000000000000000, "PCI-X Data cycle parity error detected by PIC" ],
   "LOGV_PCI_X_AD_PARITY"         => [  14,  32,   1, 0x0000000100000000, 0x00, 0, 0x0000000000000000, "PCI-X Address or Attribute cycle parity error detected by PIC" ],
   "RSVD1"                        => [  15,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "LOGV_PMU_PAGE_FAULT"          => [  16,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Indicates an Invalid Page Access" ],
   "LOGV_UNEXPECTED_RESP"         => [  17,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Enables unexpected response interrupt." ],
   "LOGV_BAD_XRESP_PACKET"        => [  18,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Enables bad Crosstalk packet interrupt." ],
   "LOGV_BAD_XREQ_PACKET"         => [  19,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Enables bad Crosstalk packet interrupt." ],
   "LOGV_RESP_XTALK_ERROR"        => [  20,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Enables Crosstalk error interrupt." ],
   "LOGV_REQ_XTALK_ERROR"         => [  21,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Enables Crosstalk error interrupt." ],
   "LOGV_INVALID_ACCESS"          => [  22,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Enables invalid address/datasize/access error interrupt." ],
   "LOGV_UNSUPPORTED_XOP"         => [  23,  23,   1, 0x0000000000800000, 0x00, 0, 0x0000000000000000, "Enables unsupported operation error." ],
   "LOGV_XREQ_FIFO_OFLOW"         => [  24,  22,   1, 0x0000000000400000, 0x00, 0, 0x0000000000000000, "Enables Crosstalk request fifo overflow interrupt." ],
   "LOGV_LLP_REC_SNERROR"         => [  25,  21,   1, 0x0000000000200000, 0x00, 0, 0x0000000000000000, "Enables LLP Receiver Sequence Number Error interrupt." ],
   "LOGV_LLP_REC_CBERROR"         => [  26,  20,   1, 0x0000000000100000, 0x00, 0, 0x0000000000000000, "Enables LLP Receiver Check Bit Error interrupt." ],
   "LOGV_LLP_RCTY"                => [  27,  19,   1, 0x0000000000080000, 0x00, 0, 0x0000000000000000, "Enables Receiver Retry Count interrupt." ],
   "LOGV_LLP_TX_RETRY"            => [  28,  18,   1, 0x0000000000040000, 0x00, 0, 0x0000000000000000, "Enables LLP Transmitter Retry interrupt." ],
   "LOGV_LLP_TCTY"                => [  29,  17,   1, 0x0000000000020000, 0x00, 0, 0x0000000000000000, "Enables Crosstalk LLP Transmitter Retry Count interrupt." ],
   "RSVD2"                        => [  30,  16,   1, 0x0000000000010000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "LOGV_PCI_ABORT"               => [  31,  15,   1, 0x0000000000008000, 0x00, 0, 0x0000000000000000, "Enables PCI master/slave abort condition interrupt" ],
   "LOGV_PCI_PARITY"              => [  32,  14,   1, 0x0000000000004000, 0x00, 0, 0x0000000000000000, "Enables PCI parity error interrupt." ],
   "LOGV_PCI_SERR"                => [  33,  13,   1, 0x0000000000002000, 0x00, 0, 0x0000000000000000, "Enables PCI Address/CMD parity error interrupt" ],
   "LOGV_PCI_PERR"                => [  34,  12,   1, 0x0000000000001000, 0x00, 0, 0x0000000000000000, "Enables PCI parity error interrupt" ],
   "LOGV_PCI_MASTER_TOUT"         => [  35,  11,   1, 0x0000000000000800, 0x00, 0, 0x0000000000000000, "Enables PCI master timeout interrupt." ],
   "LOGV_PCI_RETRY_CNT"           => [  36,  10,   1, 0x0000000000000400, 0x00, 0, 0x0000000000000000, "Enables PCI retry count interrupt." ],
   "LOGV_XREAD_REQ_TOUT"          => [  37,   9,   1, 0x0000000000000200, 0x00, 0, 0x0000000000000000, "Enables Crosstalk read request timeout interrupt." ],
   "RSVD3"                        => [  38,   7,   2, 0x0000000000000180, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MULTI_CLR"                    => [  39,   6,   1, 0x0000000000000040, 0x00, 0, 0x0000000000000000, "ERROR_VIEW" ],
   "CRP_GRP_CLR"                  => [  40,   5,   1, 0x0000000000000020, 0x00, 0, 0x0000000000000000, "UNEXPECTED_RESP, XREQ_FIFO_OFLOW" ],
   "RESP_BUF_GRP_CLR"             => [  41,   4,   1, 0x0000000000000010, 0x00, 0, 0x0000000000000000, "BAD_XRESP_PACKET, RESP_XTALK_ERROR, XREAD_REQ_TOUT" ],
   "REQ_DSP_GRP_CLR"              => [  42,   3,   1, 0x0000000000000008, 0x00, 0, 0x0000000000000000, "UNSUPPORTED_XOP, BAD_XREQ_PACKET, REQ_XTALK_ERROR, INVALID_ADDRESS" ],
   "LLP_GRP_CLR"                  => [  43,   2,   1, 0x0000000000000004, 0x00, 0, 0x0000000000000000, "LLP_REC_SNERROR, LLP_REC_CBERROR, LLP_RCTY, LLP_TX_RETRY, LLP_TCTY" ],
   "PMU_PAGE_FAULT"               => [  44,   1,   1, 0x0000000000000002, 0x00, 0, 0x0000000000000000, "Page_Fault" ],
   "PCI_GRP_CLR"                  => [  45,   0,   1, 0x0000000000000001, 0x00, 0, 0x0000000000000000, "ABORT, PARITY, SERR, PERR, MASTER_TOUT, RETRY_CNT" ],
);

%pic_01_00246_def =
( NAME    => "BUS1_RESET_INT_STATUS",
  ADDRESS => 0x00800110,
  NOTE    => "Reset Interrupt Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00246_flds
);


##########################################################################
#                                                                        #
#   BUS1_INT_MODE                                                        #
#                                                                        #
##########################################################################

%pic_01_00247_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,   8,  56, 0xFFFFFFFFFFFFFF00, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "EN_CLR_PKT"                   => [   1,   0,   8, 0x00000000000000FF, 0x00, 0, 0x0000000000000000, "EN_CLR_PKT[i]=1 enables PIC to send an interrupt clear packet" ],
);

%pic_01_00247_def =
( NAME    => "BUS1_INT_MODE",
  ADDRESS => 0x00800118,
  NOTE    => "Interrupt Mode Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00247_flds
);


##########################################################################
#                                                                        #
#   BUS1_INT_DEV                                                         #
#                                                                        #
##########################################################################

%pic_01_00248_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD7"                        => [   0,  23,  41, 0xFFFFFFFFFF800000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT7_DEV"                     => [   1,  21,   2, 0x0000000000600000, 0x00, 0, 0x0000000000000000, "Binary number of the device for interrupt 7 (INT7)." ],
   "RSVD6"                        => [   2,  20,   1, 0x0000000000100000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT6_DEV"                     => [   3,  18,   2, 0x00000000000C0000, 0x00, 0, 0x0000000000000000, "Binary number of the device for interrupt 6 (INT6)." ],
   "RSVD5"                        => [   4,  17,   1, 0x0000000000020000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT5_DEV"                     => [   5,  15,   2, 0x0000000000018000, 0x00, 0, 0x0000000000000000, "Binary number of the device for interrupt 5 (INT5)." ],
   "RSVD4"                        => [   6,  14,   1, 0x0000000000004000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT4_DEV"                     => [   7,  12,   2, 0x0000000000003000, 0x00, 0, 0x0000000000000000, "Binary number of the device for interrupt 4 (INT4)." ],
   "RSVD3"                        => [   8,  11,   1, 0x0000000000000800, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT3_DEV"                     => [   9,   9,   2, 0x0000000000000600, 0x00, 0, 0x0000000000000000, "Binary number of the device for interrupt 3 (INT3)." ],
   "RSVD2"                        => [  10,   8,   1, 0x0000000000000100, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT2_DEV"                     => [  11,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Binary number of the device for interrupt 2 (INT2)." ],
   "RSVD1"                        => [  12,   5,   1, 0x0000000000000020, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT1_DEV"                     => [  13,   3,   2, 0x0000000000000018, 0x00, 0, 0x0000000000000000, "Binary number of the device for interrupt 1 (INT1)." ],
   "RSVD0"                        => [  14,   2,   1, 0x0000000000000004, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT0_DEV"                     => [  15,   0,   2, 0x0000000000000003, 0x00, 0, 0x0000000000000000, "Binary number of the device for interrupt 0 (INT0)." ],
);

%pic_01_00248_def =
( NAME    => "BUS1_INT_DEV",
  ADDRESS => 0x00800120,
  NOTE    => "Interrupt Device Select Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00248_flds
);


##########################################################################
#                                                                        #
#   BUS1_HOST_ERR_FIELD                                                  #
#                                                                        #
##########################################################################

%pic_01_00249_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,   8,  56, 0xFFFFFFFFFFFFFF00, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BRIDGE_ERR_FLD"               => [   1,   0,   8, 0x00000000000000FF, 0x00, 0, 0x0000000000000000, "Bit location of PCI Bridge error in host interrupt register." ],
);

%pic_01_00249_def =
( NAME    => "BUS1_HOST_ERR_FIELD",
  ADDRESS => 0x00800128,
  NOTE    => "Host Error Interrupt Field Register (Crosstalk)",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00249_flds
);


##########################################################################
#                                                                        #
#   BUS1_INT0_HOST_ADDR                                                  #
#                                                                        #
##########################################################################

%pic_01_00250_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  56,   8, 0xFF00000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT_FLD"                      => [   1,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Bit location of INT_N_X in Host interrupt register" ],
   "INT_ADDR"                     => [   2,   0,  48, 0x0000FFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Contains the host address field for interrupt X" ],
);

%pic_01_00250_def =
( NAME    => "BUS1_INT0_HOST_ADDR",
  ADDRESS => 0x00800130,
  NOTE    => "Interrupt X Host register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00250_flds
);


##########################################################################
#                                                                        #
#   BUS1_INT1_HOST_ADDR                                                  #
#                                                                        #
##########################################################################

%pic_01_00251_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  56,   8, 0xFF00000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT_FLD"                      => [   1,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Bit location of INT_N_1 in Host interrupt register" ],
   "INT_ADDR"                     => [   2,   0,  48, 0x0000FFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Contains the host address field for interrupt 1" ],
);

%pic_01_00251_def =
( NAME    => "BUS1_INT1_HOST_ADDR",
  ADDRESS => 0x00800138,
  NOTE    => "Interrupt 1 Host register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00251_flds
);


##########################################################################
#                                                                        #
#   BUS1_INT2_HOST_ADDR                                                  #
#                                                                        #
##########################################################################

%pic_01_00252_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  56,   8, 0xFF00000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT_FLD"                      => [   1,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Bit location of INT_N_2 in Host interrupt register" ],
   "INT_ADDR"                     => [   2,   0,  48, 0x0000FFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Contains the host address field for interrupt 2" ],
);

%pic_01_00252_def =
( NAME    => "BUS1_INT2_HOST_ADDR",
  ADDRESS => 0x00800140,
  NOTE    => "Interrupt 2 Host register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00252_flds
);


##########################################################################
#                                                                        #
#   BUS1_INT3_HOST_ADDR                                                  #
#                                                                        #
##########################################################################

%pic_01_00253_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  56,   8, 0xFF00000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT_FLD"                      => [   1,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Bit location of INT_N_3 in Host interrupt register" ],
   "INT_ADDR"                     => [   2,   0,  48, 0x0000FFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Contains the host address field for interrupt 3" ],
);

%pic_01_00253_def =
( NAME    => "BUS1_INT3_HOST_ADDR",
  ADDRESS => 0x00800148,
  NOTE    => "Interrupt 3 Host register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00253_flds
);


##########################################################################
#                                                                        #
#   BUS1_INT4_HOST_ADDR                                                  #
#                                                                        #
##########################################################################

%pic_01_00254_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  56,   8, 0xFF00000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT_FLD"                      => [   1,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Bit location of INT_N_4 in Host interrupt register" ],
   "INT_ADDR"                     => [   2,   0,  48, 0x0000FFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Contains the host address field for interrupt 4" ],
);

%pic_01_00254_def =
( NAME    => "BUS1_INT4_HOST_ADDR",
  ADDRESS => 0x00800150,
  NOTE    => "Interrupt 4 Host register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00254_flds
);


##########################################################################
#                                                                        #
#   BUS1_INT5_HOST_ADDR                                                  #
#                                                                        #
##########################################################################

%pic_01_00255_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  56,   8, 0xFF00000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT_FLD"                      => [   1,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Bit location of INT_N_5 in Host interrupt register" ],
   "INT_ADDR"                     => [   2,   0,  48, 0x0000FFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Contains the host address field for interrupt 5" ],
);

%pic_01_00255_def =
( NAME    => "BUS1_INT5_HOST_ADDR",
  ADDRESS => 0x00800158,
  NOTE    => "Interrupt 5 Host register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00255_flds
);


##########################################################################
#                                                                        #
#   BUS1_INT6_HOST_ADDR                                                  #
#                                                                        #
##########################################################################

%pic_01_00256_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  56,   8, 0xFF00000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT_FLD"                      => [   1,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Bit location of INT_N_6 in Host interrupt register" ],
   "INT_ADDR"                     => [   2,   0,  48, 0x0000FFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Contains the host address field for interrupt 6" ],
);

%pic_01_00256_def =
( NAME    => "BUS1_INT6_HOST_ADDR",
  ADDRESS => 0x00800160,
  NOTE    => "Interrupt 6 Host register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00256_flds
);


##########################################################################
#                                                                        #
#   BUS1_INT7_HOST_ADDR                                                  #
#                                                                        #
##########################################################################

%pic_01_00257_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  56,   8, 0xFF00000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT_FLD"                      => [   1,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Bit location of INT_N_7 in Host interrupt register" ],
   "INT_ADDR"                     => [   2,   0,  48, 0x0000FFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Contains the host address field for interrupt 7" ],
);

%pic_01_00257_def =
( NAME    => "BUS1_INT7_HOST_ADDR",
  ADDRESS => 0x00800168,
  NOTE    => "Interrupt 7 Host register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00257_flds
);


##########################################################################
#                                                                        #
#   BUS1_ERR_INT_VIEW                                                    #
#                                                                        #
##########################################################################

%pic_01_00258_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  46,  18, 0xFFFFC00000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PCI_X_SPLIT_MES_PE"           => [   1,  45,   1, 0x0000200000000000, 0x00, 0, 0x0000000000000000, "PCI-X Split Completion Message Parity Error" ],
   "PCI_X_SPLIT_EMESS"            => [   2,  44,   1, 0x0000100000000000, 0x00, 0, 0x0000000000000000, "PCI-X Split Completion Error Message" ],
   "PCI_X_SPLIT_TO"               => [   3,  43,   1, 0x0000080000000000, 0x00, 0, 0x0000000000000000, "PCI-X Split Completion Timeout" ],
   "PCI_X_UNEX_COMP"              => [   4,  42,   1, 0x0000040000000000, 0x00, 0, 0x0000000000000000, "PCI-X Unexpected Completion cycle to master" ],
   "INT_RAM_PERR"                 => [   5,  41,   1, 0x0000020000000000, 0x00, 0, 0x0000000000000000, "Internal Ram Parity Error" ],
   "PCI_X_ARB_ERR"                => [   6,  40,   1, 0x0000010000000000, 0x00, 0, 0x0000000000000000, "PCI-X Arb Error" ],
   "PCI_X_REQ_TOUT"               => [   7,  39,   1, 0x0000008000000000, 0x00, 0, 0x0000000000000000, "PCI-X Read Request Time Out" ],
   "PCI_X_TABORT"                 => [   8,  38,   1, 0x0000004000000000, 0x00, 0, 0x0000000000000000, "PCI-X Target Abort" ],
   "PCI_X_PERR"                   => [   9,  37,   1, 0x0000002000000000, 0x00, 0, 0x0000000000000000, "PCI-X PERR" ],
   "PCI_X_SERR"                   => [  10,  36,   1, 0x0000001000000000, 0x00, 0, 0x0000000000000000, "PCI-X SERR" ],
   "PCI_X_MRETRY"                 => [  11,  35,   1, 0x0000000800000000, 0x00, 0, 0x0000000000000000, "PCI-X pio retry counter exhausted" ],
   "PCI_X_MTOUT"                  => [  12,  34,   1, 0x0000000400000000, 0x00, 0, 0x0000000000000000, "PCI-X Master Timeout" ],
   "PCI_X_DA_PARITY"              => [  13,  33,   1, 0x0000000200000000, 0x00, 0, 0x0000000000000000, "PCI-X Data cycle parity error" ],
   "PCI_X_AD_PARITY"              => [  14,  32,   1, 0x0000000100000000, 0x00, 0, 0x0000000000000000, "PCI-X Address or Attribute cycle parity error" ],
   "RSVD1"                        => [  15,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PMU_PAGE_FAULT"               => [  16,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Indicates an Invalid Page Access" ],
   "UNEXPECTED_RESP"              => [  17,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "This bit indicates that an unexpected response arrived." ],
   "BAD_XRESP_PACKET"             => [  18,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Data size in command word of a response did not match" ],
   "BAD_XREQ_PACKET"              => [  19,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Data size in command word of a request did not match" ],
   "RESP_XTALK_ERROR"             => [  20,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Packet had command error bit set or the invalid sideband" ],
   "REQ_XTALK_ERROR"              => [  21,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Packet had command error bit set or the invalid sideband" ],
   "INVALID_ACCESS"               => [  22,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Request packet contains an invalid address/datasize/access" ],
   "UNSUPPORTED_XOP"              => [  23,  23,   1, 0x0000000000800000, 0x00, 0, 0x0000000000000000, "Request operation is not supported by PIC" ],
   "XREQ_FIFO_OFLOW"              => [  24,  22,   1, 0x0000000000400000, 0x00, 0, 0x0000000000000000, "Request packet overflow" ],
   "LLP_REC_SNERROR"              => [  25,  21,   1, 0x0000000000200000, 0x00, 0, 0x0000000000000000, "LLP Receiver Sequence Number Error" ],
   "LLP_REC_CBERROR"              => [  26,  20,   1, 0x0000000000100000, 0x00, 0, 0x0000000000000000, "LLP Receiver Check Bit Error" ],
   "LLP_RCTY"                     => [  27,  19,   1, 0x0000000000080000, 0x00, 0, 0x0000000000000000, "LLP Receiver Retry Count Interrupt" ],
   "LLP_TX_RETRY"                 => [  28,  18,   1, 0x0000000000040000, 0x00, 0, 0x0000000000000000, "LLP Transmitter Retry" ],
   "LLP_TCTY"                     => [  29,  17,   1, 0x0000000000020000, 0x00, 0, 0x0000000000000000, "LLP Transmitter Retry Count Interrupt" ],
   "RSVD2"                        => [  30,  16,   1, 0x0000000000010000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PCI_ABORT"                    => [  31,  15,   1, 0x0000000000008000, 0x00, 0, 0x0000000000000000, "Status of PCI slave abort condition interrupt" ],
   "PCI_PARITY"                   => [  32,  14,   1, 0x0000000000004000, 0x00, 0, 0x0000000000000000, "Indicates the PIC detected a parity error." ],
   "PCI_SERR"                     => [  33,  13,   1, 0x0000000000002000, 0x00, 0, 0x0000000000000000, "Status PCI Address/CMD parity error interrupt" ],
   "PCI_PERR"                     => [  34,  12,   1, 0x0000000000001000, 0x00, 0, 0x0000000000000000, "Status of PCI parity error interrupt" ],
   "PCI_MASTER_TOUT"              => [  35,  11,   1, 0x0000000000000800, 0x00, 0, 0x0000000000000000, "Indicates a device select timeout" ],
   "PCI_RETRY_CNT"                => [  36,  10,   1, 0x0000000000000400, 0x00, 0, 0x0000000000000000, "PCI retry operation count exhausted." ],
   "XREAD_REQ_TOUT"               => [  37,   9,   1, 0x0000000000000200, 0x00, 0, 0x0000000000000000, "PCI to Crosstalk read request timeout." ],
   "RSVD3"                        => [  38,   0,   9, 0x00000000000001FF, 0x00, 0, 0x0000000000000000, "Reserved" ],
);

%pic_01_00258_def =
( NAME    => "BUS1_ERR_INT_VIEW",
  ADDRESS => 0x00800170,
  NOTE    => "Error Interrupt View Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00258_flds
);


##########################################################################
#                                                                        #
#   BUS1_MULT_INT                                                        #
#                                                                        #
##########################################################################

%pic_01_00259_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  46,  18, 0xFFFFC00000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PCI_X_SPLIT_MES_PE"           => [   1,  45,   1, 0x0000200000000000, 0x00, 0, 0x0000000000000000, "PCI-X Split Completion Message Parity Error" ],
   "PCI_X_SPLIT_EMESS"            => [   2,  44,   1, 0x0000100000000000, 0x00, 0, 0x0000000000000000, "PCI-X Split Completion Error Message" ],
   "PCI_X_SPLIT_TO"               => [   3,  43,   1, 0x0000080000000000, 0x00, 0, 0x0000000000000000, "PCI-X Split Completion Timeout" ],
   "PCI_X_UNEX_COMP"              => [   4,  42,   1, 0x0000040000000000, 0x00, 0, 0x0000000000000000, "PCI-X Unexpected Completion cycle to master" ],
   "INT_RAM_PERR"                 => [   5,  41,   1, 0x0000020000000000, 0x00, 0, 0x0000000000000000, "Internal Ram Parity Error" ],
   "PCI_X_ARB_ERR"                => [   6,  40,   1, 0x0000010000000000, 0x00, 0, 0x0000000000000000, "PCI-X Arb Error" ],
   "PCI_X_REQ_TOUT"               => [   7,  39,   1, 0x0000008000000000, 0x00, 0, 0x0000000000000000, "PCI-X Read Request Time Out" ],
   "PCI_X_TABORT"                 => [   8,  38,   1, 0x0000004000000000, 0x00, 0, 0x0000000000000000, "PCI-X Target Abort" ],
   "PCI_X_PERR"                   => [   9,  37,   1, 0x0000002000000000, 0x00, 0, 0x0000000000000000, "PCI-X PERR" ],
   "PCI_X_SERR"                   => [  10,  36,   1, 0x0000001000000000, 0x00, 0, 0x0000000000000000, "PCI-X SERR" ],
   "PCI_X_MRETRY"                 => [  11,  35,   1, 0x0000000800000000, 0x00, 0, 0x0000000000000000, "PCI-X pio retry counter exhausted" ],
   "PCI_X_MTOUT"                  => [  12,  34,   1, 0x0000000400000000, 0x00, 0, 0x0000000000000000, "PCI-X Master Timeout, PCI target device did not respond with devsel." ],
   "PCI_X_DA_PARITY"              => [  13,  33,   1, 0x0000000200000000, 0x00, 0, 0x0000000000000000, "PCI-X Data cycle parity error detected by PIC" ],
   "PCI_X_AD_PARITY"              => [  14,  32,   1, 0x0000000100000000, 0x00, 0, 0x0000000000000000, "PCI-X Address or Attribute cycle parity error detected by PIC" ],
   "RSVD1"                        => [  15,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PMU_PAGE_FAULT"               => [  16,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Indicates an Invalid Page Access" ],
   "UNEXPECTED_RESP"              => [  17,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "This bit indicates that an unexpected response arrived." ],
   "BAD_XRESP_PACKET"             => [  18,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "" ],
   "BAD_XREQ_PACKET"              => [  19,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "" ],
   "RESP_XTALK_ERROR"             => [  20,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "" ],
   "REQ_XTALK_ERROR"              => [  21,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "" ],
   "INVALID_ACCESS"               => [  22,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "" ],
   "UNSUPPORTED_XOP"              => [  23,  23,   1, 0x0000000000800000, 0x00, 0, 0x0000000000000000, "Request operation is not supported by PIC" ],
   "XREQ_FIFO_OFLOW"              => [  24,  22,   1, 0x0000000000400000, 0x00, 0, 0x0000000000000000, "Request packet overflow" ],
   "LLP_REC_SNERROR"              => [  25,  21,   1, 0x0000000000200000, 0x00, 0, 0x0000000000000000, "LLP Receiver Sequence Number Error" ],
   "LLP_REC_CBERROR"              => [  26,  20,   1, 0x0000000000100000, 0x00, 0, 0x0000000000000000, "LLP Receiver Check Bit Error" ],
   "LLP_RCTY"                     => [  27,  19,   1, 0x0000000000080000, 0x00, 0, 0x0000000000000000, "LLP Receiver Retry Count Interrupt" ],
   "LLP_TX_RETRY"                 => [  28,  18,   1, 0x0000000000040000, 0x00, 0, 0x0000000000000000, "LLP Transmitter Retry" ],
   "LLP_TCTY"                     => [  29,  17,   1, 0x0000000000020000, 0x00, 0, 0x0000000000000000, "LLP Transmitter Retry Count Interrupt" ],
   "RSVD2"                        => [  30,  16,   1, 0x0000000000010000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PCI_ABORT"                    => [  31,  15,   1, 0x0000000000008000, 0x00, 0, 0x0000000000000000, "Status of PCI slave abort condition interrupt" ],
   "PCI_PARITY"                   => [  32,  14,   1, 0x0000000000004000, 0x00, 0, 0x0000000000000000, "Indicates the PIC detected a parity error." ],
   "PCI_SERR"                     => [  33,  13,   1, 0x0000000000002000, 0x00, 0, 0x0000000000000000, "Status PCI Address/CMD parity error interrupt" ],
   "PCI_PERR"                     => [  34,  12,   1, 0x0000000000001000, 0x00, 0, 0x0000000000000000, "Status of PCI parity error interrupt" ],
   "PCI_MASTER_TOUT"              => [  35,  11,   1, 0x0000000000000800, 0x00, 0, 0x0000000000000000, "Indicates a device select timeout" ],
   "PCI_RETRY_CNT"                => [  36,  10,   1, 0x0000000000000400, 0x00, 0, 0x0000000000000000, "PCI retry operation count exhausted." ],
   "XREAD_REQ_TOUT"               => [  37,   9,   1, 0x0000000000000200, 0x00, 0, 0x0000000000000000, "PCI to Crosstalk read request timeout." ],
   "RSVD3"                        => [  38,   8,   1, 0x0000000000000100, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INT_STATE"                    => [  39,   0,   8, 0x00000000000000FF, 0x00, 0, 0x0000000000000000, "Status of INT_N[7:0]. A 1 means INT_N is low." ],
);

%pic_01_00259_def =
( NAME    => "BUS1_MULT_INT",
  ADDRESS => 0x00800178,
  NOTE    => "PIC INT_STATUS Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00259_flds
);


##########################################################################
#                                                                        #
#   BUS1_INT0_FORCE_ALWAYS                                               #
#                                                                        #
##########################################################################

%pic_01_00260_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00260_def =
( NAME    => "BUS1_INT0_FORCE_ALWAYS",
  ADDRESS => 0x00800180,
  NOTE    => "Force Always Interrupt 0 Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00260_flds
);


##########################################################################
#                                                                        #
#   BUS1_INT1_FORCE_ALWAYS                                               #
#                                                                        #
##########################################################################

%pic_01_00261_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00261_def =
( NAME    => "BUS1_INT1_FORCE_ALWAYS",
  ADDRESS => 0x00800188,
  NOTE    => "Force Always Interrupt 1 Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00261_flds
);


##########################################################################
#                                                                        #
#   BUS1_INT2_FORCE_ALWAYS                                               #
#                                                                        #
##########################################################################

%pic_01_00262_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00262_def =
( NAME    => "BUS1_INT2_FORCE_ALWAYS",
  ADDRESS => 0x00800190,
  NOTE    => "Force Always Interrupt 2 Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00262_flds
);


##########################################################################
#                                                                        #
#   BUS1_INT3_FORCE_ALWAYS                                               #
#                                                                        #
##########################################################################

%pic_01_00263_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00263_def =
( NAME    => "BUS1_INT3_FORCE_ALWAYS",
  ADDRESS => 0x00800198,
  NOTE    => "Force Always Interrupt 3 Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00263_flds
);


##########################################################################
#                                                                        #
#   BUS1_INT4_FORCE_ALWAYS                                               #
#                                                                        #
##########################################################################

%pic_01_00264_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00264_def =
( NAME    => "BUS1_INT4_FORCE_ALWAYS",
  ADDRESS => 0x008001A0,
  NOTE    => "Force Always Interrupt 4 Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00264_flds
);


##########################################################################
#                                                                        #
#   BUS1_INT5_FORCE_ALWAYS                                               #
#                                                                        #
##########################################################################

%pic_01_00265_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00265_def =
( NAME    => "BUS1_INT5_FORCE_ALWAYS",
  ADDRESS => 0x008001A8,
  NOTE    => "Force Always Interrupt 5 Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00265_flds
);


##########################################################################
#                                                                        #
#   BUS1_INT6_FORCE_ALWAYS                                               #
#                                                                        #
##########################################################################

%pic_01_00266_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00266_def =
( NAME    => "BUS1_INT6_FORCE_ALWAYS",
  ADDRESS => 0x008001B0,
  NOTE    => "Force Always Interrupt 6 Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00266_flds
);


##########################################################################
#                                                                        #
#   BUS1_INT7_FORCE_ALWAYS                                               #
#                                                                        #
##########################################################################

%pic_01_00267_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00267_def =
( NAME    => "BUS1_INT7_FORCE_ALWAYS",
  ADDRESS => 0x008001B8,
  NOTE    => "Force Always Interrupt 7 Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00267_flds
);


##########################################################################
#                                                                        #
#   BUS1_INT0_FORCE_PIN_REG                                              #
#                                                                        #
##########################################################################

%pic_01_00268_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00268_def =
( NAME    => "BUS1_INT0_FORCE_PIN_REG",
  ADDRESS => 0x008001C0,
  NOTE    => "Force Interrupt 0 Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00268_flds
);


##########################################################################
#                                                                        #
#   BUS1_INT1_FORCE_PIN_REG                                              #
#                                                                        #
##########################################################################

%pic_01_00269_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00269_def =
( NAME    => "BUS1_INT1_FORCE_PIN_REG",
  ADDRESS => 0x008001C8,
  NOTE    => "Force Interrupt 1 Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00269_flds
);


##########################################################################
#                                                                        #
#   BUS1_INT2_FORCE_PIN_REG                                              #
#                                                                        #
##########################################################################

%pic_01_00270_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00270_def =
( NAME    => "BUS1_INT2_FORCE_PIN_REG",
  ADDRESS => 0x008001D0,
  NOTE    => "Force Interrupt 2 Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00270_flds
);


##########################################################################
#                                                                        #
#   BUS1_INT3_FORCE_PIN_REG                                              #
#                                                                        #
##########################################################################

%pic_01_00271_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00271_def =
( NAME    => "BUS1_INT3_FORCE_PIN_REG",
  ADDRESS => 0x008001D8,
  NOTE    => "Force Interrupt 3 Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00271_flds
);


##########################################################################
#                                                                        #
#   BUS1_INT4_FORCE_PIN_REG                                              #
#                                                                        #
##########################################################################

%pic_01_00272_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00272_def =
( NAME    => "BUS1_INT4_FORCE_PIN_REG",
  ADDRESS => 0x008001E0,
  NOTE    => "Force Interrupt 4 Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00272_flds
);


##########################################################################
#                                                                        #
#   BUS1_INT5_FORCE_PIN_REG                                              #
#                                                                        #
##########################################################################

%pic_01_00273_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00273_def =
( NAME    => "BUS1_INT5_FORCE_PIN_REG",
  ADDRESS => 0x008001E8,
  NOTE    => "Force Interrupt 5 Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00273_flds
);


##########################################################################
#                                                                        #
#   BUS1_INT6_FORCE_PIN_REG                                              #
#                                                                        #
##########################################################################

%pic_01_00274_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00274_def =
( NAME    => "BUS1_INT6_FORCE_PIN_REG",
  ADDRESS => 0x008001F0,
  NOTE    => "Force Interrupt 6 Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00274_flds
);


##########################################################################
#                                                                        #
#   BUS1_INT7_FORCE_PIN_REG                                              #
#                                                                        #
##########################################################################

%pic_01_00275_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00275_def =
( NAME    => "BUS1_INT7_FORCE_PIN_REG",
  ADDRESS => 0x008001F8,
  NOTE    => "Force Interrupt 7 Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00275_flds
);


##########################################################################
#                                                                        #
#   BUS1_DEV0_REG                                                        #
#                                                                        #
##########################################################################

%pic_01_00276_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  29,   3, 0x00000000E0000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "EN_ERROR_LOCK"                => [   2,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Enable the Error Lock" ],
   "EN_PAGE_CHK"                  => [   3,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Enable Prefetcher Page Cross Checking" ],
   "FORCE_PCI_PAR"                => [   4,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Force a PCI parity error" ],
   "EN_VIRTUAL"                   => [   5,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Enable Virtual Device" ],
   "RSVD2"                        => [   6,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "DIR_WRT_GEN"                  => [   7,  23,   1, 0x0000000000800000, 0x00, 0, 0x0000000000000000, "Direct Mapped Write Gather Enable" ],
   "DEV_SIZE"                     => [   8,  22,   1, 0x0000000000400000, 0x00, 0, 0x0000000000000000, "Device Size" ],
   "REAL_TIME"                    => [   9,  21,   1, 0x0000000000200000, 0x00, 0, 0x0000000000000000, "Real Time Device Enable (1 => enabled)" ],
   "RSVD3"                        => [  10,  20,   1, 0x0000000000100000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "SWAP_DIRECT"                  => [  11,  19,   1, 0x0000000000080000, 0x00, 0, 0x0000000000000000, "Enable Swapping in Direct Map Mode (1 => enabled)" ],
   "PREFETCH"                     => [  12,  18,   1, 0x0000000000040000, 0x00, 0, 0x0000000000000000, "Prefetcher Enable" ],
   "PRECISE"                      => [  13,  17,   1, 0x0000000000020000, 0x00, 0, 0x0000000000000000, "Precise Transaction" ],
   "COHERENT"                     => [  14,  16,   1, 0x0000000000010000, 0x00, 0, 0x0000000000000000, "Coherent Transaction (1 => coherent)" ],
   "BARRIER"                      => [  15,  15,   1, 0x0000000000008000, 0x00, 0, 0x0000000000000000, "Barrier Transaction (1 => barrier)" ],
   "GBR"                          => [  16,  14,   1, 0x0000000000004000, 0x00, 0, 0x0000000000000000, "GBR Enable (1 => enabled)" ],
   "DEV_SWAP"                     => [  17,  13,   1, 0x0000000000002000, 0x00, 0, 0x0000000000000000, "Device Enable Swapping (1 => enabled)" ],
   "DEV_IO_MEM"                   => [  18,  12,   1, 0x0000000000001000, 0x00, 0, 0x0000000000000000, "Enable Device Memory or I/O Space" ],
   "DEV_OFF"                      => [  19,   0,  12, 0x0000000000000FFF, 0x00, 0, 0x0000000000000000, "Device Offset Address Bits 31:20" ],
);

%pic_01_00276_def =
( NAME    => "BUS1_DEV0_REG",
  ADDRESS => 0x00800200,
  NOTE    => "Device 0 Registers",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00276_flds
);


##########################################################################
#                                                                        #
#   BUS1_DEV1_REG                                                        #
#                                                                        #
##########################################################################

%pic_01_00277_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  29,   3, 0x00000000E0000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "EN_ERROR_LOCK"                => [   2,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Enable the Error Lock" ],
   "EN_PAGE_CHK"                  => [   3,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Enable Prefetcher Page Cross Checking" ],
   "FORCE_PCI_PAR"                => [   4,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Force a PCI parity error" ],
   "EN_VIRTUAL"                   => [   5,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Enable Virtual Device" ],
   "RSVD2"                        => [   6,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "DIR_WRT_GEN"                  => [   7,  23,   1, 0x0000000000800000, 0x00, 0, 0x0000000000000000, "Direct Mapped Write Gather Enable" ],
   "DEV_SIZE"                     => [   8,  22,   1, 0x0000000000400000, 0x00, 0, 0x0000000000000000, "Device Size" ],
   "REAL_TIME"                    => [   9,  21,   1, 0x0000000000200000, 0x00, 0, 0x0000000000000000, "Real Time Device Enable (1 => enabled)" ],
   "RSVD3"                        => [  10,  20,   1, 0x0000000000100000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "SWAP_DIRECT"                  => [  11,  19,   1, 0x0000000000080000, 0x00, 0, 0x0000000000000000, "Enable Swapping in Direct Map Mode (1 => enabled)" ],
   "PREFETCH"                     => [  12,  18,   1, 0x0000000000040000, 0x00, 0, 0x0000000000000000, "Prefetcher Enable" ],
   "PRECISE"                      => [  13,  17,   1, 0x0000000000020000, 0x00, 0, 0x0000000000000000, "Precise Transaction" ],
   "COHERENT"                     => [  14,  16,   1, 0x0000000000010000, 0x00, 0, 0x0000000000000000, "Coherent Transaction (1 => coherent)" ],
   "BARRIER"                      => [  15,  15,   1, 0x0000000000008000, 0x00, 0, 0x0000000000000000, "Barrier Transaction (1 => barrier)" ],
   "GBR"                          => [  16,  14,   1, 0x0000000000004000, 0x00, 0, 0x0000000000000000, "GBR Enable (1 => enabled)" ],
   "DEV_SWAP"                     => [  17,  13,   1, 0x0000000000002000, 0x00, 0, 0x0000000000000000, "Device Enable Swapping (1 => enabled)" ],
   "DEV_IO_MEM"                   => [  18,  12,   1, 0x0000000000001000, 0x00, 0, 0x0000000000000000, "Enable Device Memory or I/O Space" ],
   "DEV_OFF"                      => [  19,   0,  12, 0x0000000000000FFF, 0x00, 0, 0x0000000000000000, "Device Offset Address Bits 31:20" ],
);

%pic_01_00277_def =
( NAME    => "BUS1_DEV1_REG",
  ADDRESS => 0x00800208,
  NOTE    => "Device 1 Registers",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00277_flds
);


##########################################################################
#                                                                        #
#   BUS1_DEV2_REG                                                        #
#                                                                        #
##########################################################################

%pic_01_00278_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  29,   3, 0x00000000E0000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "EN_ERROR_LOCK"                => [   2,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Enable the Error Lock" ],
   "EN_PAGE_CHK"                  => [   3,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Enable Prefetcher Page Cross Checking" ],
   "FORCE_PCI_PAR"                => [   4,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Force a PCI parity error" ],
   "EN_VIRTUAL"                   => [   5,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Enable Virtual Device" ],
   "RSVD2"                        => [   6,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "DIR_WRT_GEN"                  => [   7,  23,   1, 0x0000000000800000, 0x00, 0, 0x0000000000000000, "Direct Mapped Write Gather Enable" ],
   "DEV_SIZE"                     => [   8,  22,   1, 0x0000000000400000, 0x00, 0, 0x0000000000000000, "Device Size" ],
   "REAL_TIME"                    => [   9,  21,   1, 0x0000000000200000, 0x00, 0, 0x0000000000000000, "Real Time Device Enable (1 => enabled)" ],
   "RSVD3"                        => [  10,  20,   1, 0x0000000000100000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "SWAP_DIRECT"                  => [  11,  19,   1, 0x0000000000080000, 0x00, 0, 0x0000000000000000, "Enable Swapping in Direct Map Mode (1 => enabled)" ],
   "PREFETCH"                     => [  12,  18,   1, 0x0000000000040000, 0x00, 0, 0x0000000000000000, "Prefetcher Enable" ],
   "PRECISE"                      => [  13,  17,   1, 0x0000000000020000, 0x00, 0, 0x0000000000000000, "Precise Transaction" ],
   "COHERENT"                     => [  14,  16,   1, 0x0000000000010000, 0x00, 0, 0x0000000000000000, "Coherent Transaction (1 => coherent)" ],
   "BARRIER"                      => [  15,  15,   1, 0x0000000000008000, 0x00, 0, 0x0000000000000000, "Barrier Transaction (1 => barrier)" ],
   "GBR"                          => [  16,  14,   1, 0x0000000000004000, 0x00, 0, 0x0000000000000000, "GBR Enable (1 => enabled)" ],
   "DEV_SWAP"                     => [  17,  13,   1, 0x0000000000002000, 0x00, 0, 0x0000000000000000, "Device Enable Swapping (1 => enabled)" ],
   "DEV_IO_MEM"                   => [  18,  12,   1, 0x0000000000001000, 0x00, 0, 0x0000000000000000, "Enable Device Memory or I/O Space" ],
   "DEV_OFF"                      => [  19,   0,  12, 0x0000000000000FFF, 0x00, 0, 0x0000000000000000, "Device Offset Address Bits 31:20" ],
);

%pic_01_00278_def =
( NAME    => "BUS1_DEV2_REG",
  ADDRESS => 0x00800210,
  NOTE    => "Device 2 Registers",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00278_flds
);


##########################################################################
#                                                                        #
#   BUS1_DEV3_REG                                                        #
#                                                                        #
##########################################################################

%pic_01_00279_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  29,   3, 0x00000000E0000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "EN_ERROR_LOCK"                => [   2,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Enable the Error Lock" ],
   "EN_PAGE_CHK"                  => [   3,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Enable Prefetcher Page Cross Checking" ],
   "FORCE_PCI_PAR"                => [   4,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Force a PCI parity error" ],
   "EN_VIRTUAL"                   => [   5,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Enable Virtual Device" ],
   "RSVD2"                        => [   6,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "DIR_WRT_GEN"                  => [   7,  23,   1, 0x0000000000800000, 0x00, 0, 0x0000000000000000, "Direct Mapped Write Gather Enable" ],
   "DEV_SIZE"                     => [   8,  22,   1, 0x0000000000400000, 0x00, 0, 0x0000000000000000, "Device Size" ],
   "REAL_TIME"                    => [   9,  21,   1, 0x0000000000200000, 0x00, 0, 0x0000000000000000, "Real Time Device Enable (1 => enabled)" ],
   "RSVD3"                        => [  10,  20,   1, 0x0000000000100000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "SWAP_DIRECT"                  => [  11,  19,   1, 0x0000000000080000, 0x00, 0, 0x0000000000000000, "Enable Swapping in Direct Map Mode (1 => enabled)" ],
   "PREFETCH"                     => [  12,  18,   1, 0x0000000000040000, 0x00, 0, 0x0000000000000000, "Prefetcher Enable" ],
   "PRECISE"                      => [  13,  17,   1, 0x0000000000020000, 0x00, 0, 0x0000000000000000, "Precise Transaction" ],
   "COHERENT"                     => [  14,  16,   1, 0x0000000000010000, 0x00, 0, 0x0000000000000000, "Coherent Transaction (1 => coherent)" ],
   "BARRIER"                      => [  15,  15,   1, 0x0000000000008000, 0x00, 0, 0x0000000000000000, "Barrier Transaction (1 => barrier)" ],
   "GBR"                          => [  16,  14,   1, 0x0000000000004000, 0x00, 0, 0x0000000000000000, "GBR Enable (1 => enabled)" ],
   "DEV_SWAP"                     => [  17,  13,   1, 0x0000000000002000, 0x00, 0, 0x0000000000000000, "Device Enable Swapping (1 => enabled)" ],
   "DEV_IO_MEM"                   => [  18,  12,   1, 0x0000000000001000, 0x00, 0, 0x0000000000000000, "Enable Device Memory or I/O Space" ],
   "DEV_OFF"                      => [  19,   0,  12, 0x0000000000000FFF, 0x00, 0, 0x0000000000000000, "Device Offset Address Bits 31:20" ],
);

%pic_01_00279_def =
( NAME    => "BUS1_DEV3_REG",
  ADDRESS => 0x00800218,
  NOTE    => "Device 3 Registers",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00279_flds
);


##########################################################################
#                                                                        #
#   BUS1_DEV0_WR_FLUSH                                                   #
#                                                                        #
##########################################################################

%pic_01_00280_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00280_def =
( NAME    => "BUS1_DEV0_WR_FLUSH",
  ADDRESS => 0x00800240,
  NOTE    => "Device 0 Write Request Buffer Flush",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00280_flds
);


##########################################################################
#                                                                        #
#   BUS1_DEV1_WR_FLUSH                                                   #
#                                                                        #
##########################################################################

%pic_01_00281_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00281_def =
( NAME    => "BUS1_DEV1_WR_FLUSH",
  ADDRESS => 0x00800248,
  NOTE    => "Device 1 Write Request Buffer Flush",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00281_flds
);


##########################################################################
#                                                                        #
#   BUS1_DEV2_WR_FLUSH                                                   #
#                                                                        #
##########################################################################

%pic_01_00282_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00282_def =
( NAME    => "BUS1_DEV2_WR_FLUSH",
  ADDRESS => 0x00800250,
  NOTE    => "Device 2 Write Request Buffer Flush",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00282_flds
);


##########################################################################
#                                                                        #
#   BUS1_DEV3_WR_FLUSH                                                   #
#                                                                        #
##########################################################################

%pic_01_00283_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "DATA"                         => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Force a set interrupt to occur" ],
);

%pic_01_00283_def =
( NAME    => "BUS1_DEV3_WR_FLUSH",
  ADDRESS => 0x00800258,
  NOTE    => "Device 3 Write Request Buffer Flush",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00283_flds
);


##########################################################################
#                                                                        #
#   BUS1_E_DEV_RSP_BUF                                                   #
#                                                                        #
##########################################################################

%pic_01_00284_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUFF_14_EN"                   => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Enable buffer 14" ],
   "BUFF_14_VDEV"                 => [   2,  29,   2, 0x0000000060000000, 0x00, 0, 0x0000000000000000, "Virtual device select for buffer 14." ],
   "BUFF_14_PDEV"                 => [   3,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Upper bit of device number for buffer 14." ],
   "BUFF_12_EN"                   => [   4,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Enable buffer 12" ],
   "BUFF_12_VDEV"                 => [   5,  25,   2, 0x0000000006000000, 0x00, 0, 0x0000000000000000, "Virtual device select for buffer 12." ],
   "BUFF_12_PDEV"                 => [   6,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Upper bit of device number for buffer 12." ],
   "BUFF_10_EN"                   => [   7,  23,   1, 0x0000000000800000, 0x00, 0, 0x0000000000000000, "Enable buffer 10" ],
   "BUFF_10_VDEV"                 => [   8,  21,   2, 0x0000000000600000, 0x00, 0, 0x0000000000000000, "Virtual device select for buffer 10." ],
   "BUFF_10_PDEV"                 => [   9,  20,   1, 0x0000000000100000, 0x00, 0, 0x0000000000000000, "Upper bit of device number for buffer 10." ],
   "BUFF_8_EN"                    => [  10,  19,   1, 0x0000000000080000, 0x00, 0, 0x0000000000000000, "Enable buffer 8" ],
   "BUFF_8_VDEV"                  => [  11,  17,   2, 0x0000000000060000, 0x00, 0, 0x0000000000000000, "Virtual device select for buffer 8." ],
   "BUFF_8_PDEV"                  => [  12,  16,   1, 0x0000000000010000, 0x00, 0, 0x0000000000000000, "Upper bit of device number for buffer 8." ],
   "BUFF_6_EN"                    => [  13,  15,   1, 0x0000000000008000, 0x00, 0, 0x0000000000000000, "Enable buffer 6" ],
   "BUFF_6_VDEV"                  => [  14,  13,   2, 0x0000000000006000, 0x00, 0, 0x0000000000000000, "Virtual device select for buffer 6." ],
   "BUFF_6_PDEV"                  => [  15,  12,   1, 0x0000000000001000, 0x00, 0, 0x0000000000000000, "Upper bit of device number for buffer 6." ],
   "BUFF_4_EN"                    => [  16,  11,   1, 0x0000000000000800, 0x00, 0, 0x0000000000000000, "Enable buffer 4" ],
   "BUFF_4_VDEV"                  => [  17,   9,   2, 0x0000000000000600, 0x00, 0, 0x0000000000000000, "Virtual device select for buffer 4." ],
   "BUFF_4_PDEV"                  => [  18,   8,   1, 0x0000000000000100, 0x00, 0, 0x0000000000000000, "Upper bit of device number for buffer 4." ],
   "BUFF_2_EN"                    => [  19,   7,   1, 0x0000000000000080, 0x00, 0, 0x0000000000000000, "Enable buffer 2" ],
   "BUFF_2_VDEV"                  => [  20,   5,   2, 0x0000000000000060, 0x00, 0, 0x0000000000000000, "Virtual device select for buffer 2." ],
   "BUFF_2_PDEV"                  => [  21,   4,   1, 0x0000000000000010, 0x00, 0, 0x0000000000000000, "Upper bit of device number for buffer 2." ],
   "BUFF_0_EN"                    => [  22,   3,   1, 0x0000000000000008, 0x00, 0, 0x0000000000000000, "Enable buffer 0" ],
   "BUFF_0_VDEV"                  => [  23,   1,   2, 0x0000000000000006, 0x00, 0, 0x0000000000000000, "Virtual device select for buffer 0." ],
   "BUFF_0_PDEV"                  => [  24,   0,   1, 0x0000000000000001, 0x00, 0, 0x0000000000000000, "Upper bit of device number for buffer 0." ],
);

%pic_01_00284_def =
( NAME    => "BUS1_E_DEV_RSP_BUF",
  ADDRESS => 0x00800280,
  NOTE    => "Even Device Read Response Buffer Register (PCI Only)",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00284_flds
);


##########################################################################
#                                                                        #
#   BUS1_O_DEV_RSP_BUF                                                   #
#                                                                        #
##########################################################################

%pic_01_00285_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUFF_15_EN"                   => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Enable buffer 15" ],
   "BUFF_15_VDEV"                 => [   2,  29,   2, 0x0000000060000000, 0x00, 0, 0x0000000000000000, "Virtual device select for buffer 15." ],
   "BUFF_15_PDEV"                 => [   3,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Upper bit of device number for buffer 15." ],
   "BUFF_13_EN"                   => [   4,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Enable buffer 13" ],
   "BUFF_13_VDEV"                 => [   5,  25,   2, 0x0000000006000000, 0x00, 0, 0x0000000000000000, "Virtual device select for buffer 13." ],
   "BUFF_13_PDEV"                 => [   6,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Upper bit of device number for buffer 13." ],
   "BUFF_11_EN"                   => [   7,  23,   1, 0x0000000000800000, 0x00, 0, 0x0000000000000000, "Enable buffer 11" ],
   "BUFF_11_VDEV"                 => [   8,  21,   2, 0x0000000000600000, 0x00, 0, 0x0000000000000000, "Virtual device select for buffer 11." ],
   "BUFF_11_PDEV"                 => [   9,  20,   1, 0x0000000000100000, 0x00, 0, 0x0000000000000000, "Upper two bits of device number for buffer 11." ],
   "BUFF_9_EN"                    => [  10,  19,   1, 0x0000000000080000, 0x00, 0, 0x0000000000000000, "Enable buffer 9" ],
   "BUFF_9_VDEV"                  => [  11,  17,   2, 0x0000000000060000, 0x00, 0, 0x0000000000000000, "Virtual device select for buffer 9." ],
   "BUFF_9_PDEV"                  => [  12,  16,   1, 0x0000000000010000, 0x00, 0, 0x0000000000000000, "Upper bit of device number for buffer 9." ],
   "BUFF_7_EN"                    => [  13,  15,   1, 0x0000000000008000, 0x00, 0, 0x0000000000000000, "Enable buffer 7" ],
   "BUFF_7_VDEV"                  => [  14,  13,   2, 0x0000000000006000, 0x00, 0, 0x0000000000000000, "Virtual device select for buffer 7." ],
   "BUFF_7_PDEV"                  => [  15,  12,   1, 0x0000000000001000, 0x00, 0, 0x0000000000000000, "Upper bit of device number for buffer 7." ],
   "BUFF_5_EN"                    => [  16,  11,   1, 0x0000000000000800, 0x00, 0, 0x0000000000000000, "Enable buffer 5" ],
   "BUFF_5_VDEV"                  => [  17,   9,   2, 0x0000000000000600, 0x00, 0, 0x0000000000000000, "Virtual device select for buffer 5." ],
   "BUFF_5_PDEV"                  => [  18,   8,   1, 0x0000000000000100, 0x00, 0, 0x0000000000000000, "Upper bit of device number for buffer 5." ],
   "BUFF_3_EN"                    => [  19,   7,   1, 0x0000000000000080, 0x00, 0, 0x0000000000000000, "Enable buffer 3" ],
   "BUFF_3_VDEV"                  => [  20,   5,   2, 0x0000000000000060, 0x00, 0, 0x0000000000000000, "Virtual device select for buffer 3." ],
   "BUFF_3_PDEV"                  => [  21,   4,   1, 0x0000000000000010, 0x00, 0, 0x0000000000000000, "Upper bit of device number for buffer 3." ],
   "BUFF_1_EN"                    => [  22,   3,   1, 0x0000000000000008, 0x00, 0, 0x0000000000000000, "Enable buffer 1" ],
   "BUFF_1_VDEV"                  => [  23,   1,   2, 0x0000000000000006, 0x00, 0, 0x0000000000000000, "Virtual device select for buffer 1." ],
   "BUFF_1_PDEV"                  => [  24,   0,   1, 0x0000000000000001, 0x00, 0, 0x0000000000000000, "Upper bit of device number for buffer 1." ],
);

%pic_01_00285_def =
( NAME    => "BUS1_O_DEV_RSP_BUF",
  ADDRESS => 0x00800288,
  NOTE    => "Odd Device Read Response Buffer Register (PCI Only)",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00285_flds
);


##########################################################################
#                                                                        #
#   BUS1_RR_BUFF_STATUS                                                  #
#                                                                        #
##########################################################################

%pic_01_00286_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RRB_VALID"                    => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Read Response Buffer VALID bits" ],
   "RRB_INUSE"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Read Response Buffer INUSE bits" ],
);

%pic_01_00286_def =
( NAME    => "BUS1_RR_BUFF_STATUS",
  ADDRESS => 0x00800290,
  NOTE    => "Read Response Buffer Status Register (PCI Only)",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00286_flds
);


##########################################################################
#                                                                        #
#   BUS1_RR_BUFF_CLR                                                     #
#                                                                        #
##########################################################################

%pic_01_00287_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RRB_CLEAR"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Read Response Buffer CLEAR bits" ],
);

%pic_01_00287_def =
( NAME    => "BUS1_RR_BUFF_CLR",
  ADDRESS => 0x00800298,
  NOTE    => "Read Response Buffer Clear Register (PCI Only)",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00287_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_RD_RESP0_UPP                                                #
#                                                                        #
##########################################################################

%pic_01_00288_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "FILLED"                       => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Buffer has valid data" ],
   "ARMED"                        => [   2,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   3,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   4,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error" ],
   "PKTERR"                       => [   5,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   6,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   7,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   8,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   9,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [  10,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00288_def =
( NAME    => "BUS1_PCI_RD_RESP0_UPP",
  ADDRESS => 0x00800300,
  NOTE    => "PCI Read Response Buffer 0 Upper address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00288_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_RD_RESP1_UPP                                                #
#                                                                        #
##########################################################################

%pic_01_00289_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "FILLED"                       => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Buffer has valid data" ],
   "ARMED"                        => [   2,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   3,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   4,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error" ],
   "PKTERR"                       => [   5,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   6,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   7,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   8,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   9,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [  10,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00289_def =
( NAME    => "BUS1_PCI_RD_RESP1_UPP",
  ADDRESS => 0x00800310,
  NOTE    => "PCI Read Response Buffer 1 Upper address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00289_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_RD_RESP2_UPP                                                #
#                                                                        #
##########################################################################

%pic_01_00290_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "FILLED"                       => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Buffer has valid data" ],
   "ARMED"                        => [   2,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   3,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   4,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error" ],
   "PKTERR"                       => [   5,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   6,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   7,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   8,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   9,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [  10,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00290_def =
( NAME    => "BUS1_PCI_RD_RESP2_UPP",
  ADDRESS => 0x00800320,
  NOTE    => "PCI Read Response Buffer 2 Upper address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00290_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_RD_RESP3_UPP                                                #
#                                                                        #
##########################################################################

%pic_01_00291_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "FILLED"                       => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Buffer has valid data" ],
   "ARMED"                        => [   2,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   3,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   4,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error" ],
   "PKTERR"                       => [   5,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   6,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   7,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   8,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   9,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [  10,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00291_def =
( NAME    => "BUS1_PCI_RD_RESP3_UPP",
  ADDRESS => 0x00800330,
  NOTE    => "PCI Read Response Buffer 3 Upper address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00291_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_RD_RESP4_UPP                                                #
#                                                                        #
##########################################################################

%pic_01_00292_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "FILLED"                       => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Buffer has valid data" ],
   "ARMED"                        => [   2,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   3,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   4,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error" ],
   "PKTERR"                       => [   5,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   6,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   7,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   8,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   9,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [  10,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00292_def =
( NAME    => "BUS1_PCI_RD_RESP4_UPP",
  ADDRESS => 0x00800340,
  NOTE    => "PCI Read Response Buffer 4 Upper address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00292_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_RD_RESP5_UPP                                                #
#                                                                        #
##########################################################################

%pic_01_00293_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "FILLED"                       => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Buffer has valid data" ],
   "ARMED"                        => [   2,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   3,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   4,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error" ],
   "PKTERR"                       => [   5,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   6,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   7,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   8,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   9,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [  10,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00293_def =
( NAME    => "BUS1_PCI_RD_RESP5_UPP",
  ADDRESS => 0x00800350,
  NOTE    => "PCI Read Response Buffer 5 Upper address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00293_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_RD_RESP6_UPP                                                #
#                                                                        #
##########################################################################

%pic_01_00294_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "FILLED"                       => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Buffer has valid data" ],
   "ARMED"                        => [   2,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   3,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   4,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error" ],
   "PKTERR"                       => [   5,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   6,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   7,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   8,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   9,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [  10,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00294_def =
( NAME    => "BUS1_PCI_RD_RESP6_UPP",
  ADDRESS => 0x00800360,
  NOTE    => "PCI Read Response Buffer 6 Upper address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00294_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_RD_RESP7_UPP                                                #
#                                                                        #
##########################################################################

%pic_01_00295_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "FILLED"                       => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Buffer has valid data" ],
   "ARMED"                        => [   2,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   3,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   4,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error" ],
   "PKTERR"                       => [   5,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   6,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   7,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   8,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   9,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [  10,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00295_def =
( NAME    => "BUS1_PCI_RD_RESP7_UPP",
  ADDRESS => 0x00800370,
  NOTE    => "PCI Read Response Buffer 7 Upper address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00295_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_RD_RESP8_UPP                                                #
#                                                                        #
##########################################################################

%pic_01_00296_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "FILLED"                       => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Buffer has valid data" ],
   "ARMED"                        => [   2,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   3,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   4,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error" ],
   "PKTERR"                       => [   5,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   6,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   7,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   8,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   9,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [  10,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00296_def =
( NAME    => "BUS1_PCI_RD_RESP8_UPP",
  ADDRESS => 0x00800380,
  NOTE    => "PCI Read Response Buffer 8 Upper address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00296_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_RD_RESP9_UPP                                                #
#                                                                        #
##########################################################################

%pic_01_00297_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "FILLED"                       => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Buffer has valid data" ],
   "ARMED"                        => [   2,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   3,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   4,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error" ],
   "PKTERR"                       => [   5,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   6,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   7,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   8,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   9,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [  10,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00297_def =
( NAME    => "BUS1_PCI_RD_RESP9_UPP",
  ADDRESS => 0x00800390,
  NOTE    => "PCI Read Response Buffer 9 Upper address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00297_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_RD_RESP10_UPP                                               #
#                                                                        #
##########################################################################

%pic_01_00298_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "FILLED"                       => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Buffer has valid data" ],
   "ARMED"                        => [   2,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   3,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   4,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error" ],
   "PKTERR"                       => [   5,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   6,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   7,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   8,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   9,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [  10,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00298_def =
( NAME    => "BUS1_PCI_RD_RESP10_UPP",
  ADDRESS => 0x008003A0,
  NOTE    => "PCI Read Response Buffer 10 Upper address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00298_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_RD_RESP11_UPP                                               #
#                                                                        #
##########################################################################

%pic_01_00299_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "FILLED"                       => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Buffer has valid data" ],
   "ARMED"                        => [   2,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   3,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   4,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error" ],
   "PKTERR"                       => [   5,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   6,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   7,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   8,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   9,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [  10,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00299_def =
( NAME    => "BUS1_PCI_RD_RESP11_UPP",
  ADDRESS => 0x008003B0,
  NOTE    => "PCI Read Response Buffer 11 Upper address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00299_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_RD_RESP12_UPP                                               #
#                                                                        #
##########################################################################

%pic_01_00300_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "FILLED"                       => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Buffer has valid data" ],
   "ARMED"                        => [   2,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   3,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   4,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error" ],
   "PKTERR"                       => [   5,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   6,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   7,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   8,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   9,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [  10,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00300_def =
( NAME    => "BUS1_PCI_RD_RESP12_UPP",
  ADDRESS => 0x008003C0,
  NOTE    => "PCI Read Response Buffer 12 Upper address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00300_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_RD_RESP13_UPP                                               #
#                                                                        #
##########################################################################

%pic_01_00301_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "FILLED"                       => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Buffer has valid data" ],
   "ARMED"                        => [   2,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   3,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   4,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error" ],
   "PKTERR"                       => [   5,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   6,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   7,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   8,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   9,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [  10,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00301_def =
( NAME    => "BUS1_PCI_RD_RESP13_UPP",
  ADDRESS => 0x008003D0,
  NOTE    => "PCI Read Response Buffer 13 Upper address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00301_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_RD_RESP14_UPP                                               #
#                                                                        #
##########################################################################

%pic_01_00302_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "FILLED"                       => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Buffer has valid data" ],
   "ARMED"                        => [   2,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   3,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   4,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error" ],
   "PKTERR"                       => [   5,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   6,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   7,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   8,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   9,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [  10,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00302_def =
( NAME    => "BUS1_PCI_RD_RESP14_UPP",
  ADDRESS => 0x008003E0,
  NOTE    => "PCI Read Response Buffer 14 Upper address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00302_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_RD_RESP15_UPP                                               #
#                                                                        #
##########################################################################

%pic_01_00303_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "FILLED"                       => [   1,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Buffer has valid data" ],
   "ARMED"                        => [   2,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   3,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   4,  28,   1, 0x0000000010000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error" ],
   "PKTERR"                       => [   5,  27,   1, 0x0000000008000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   6,  26,   1, 0x0000000004000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   7,  25,   1, 0x0000000002000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   8,  24,   1, 0x0000000001000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   9,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [  10,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
);

%pic_01_00303_def =
( NAME    => "BUS1_PCI_RD_RESP15_UPP",
  ADDRESS => 0x008003F0,
  NOTE    => "PCI Read Response Buffer 15 Upper address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00303_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_RD_RESP0_LOW                                                #
#                                                                        #
##########################################################################

%pic_01_00304_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "FILLED"                       => [   0,  63,   1, 0x8000000000000000, 0x00, 0, 0x0000000000000000, "Filled indicates that the buffer has valid data" ],
   "ARMED"                        => [   1,  62,   1, 0x4000000000000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   2,  61,   1, 0x2000000000000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   3,  60,   1, 0x1000000000000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error occurred" ],
   "PKTERR"                       => [   4,  59,   1, 0x0800000000000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   5,  58,   1, 0x0400000000000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   6,  57,   1, 0x0200000000000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   7,  56,   1, 0x0100000000000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   8,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [   9,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [  10,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00304_def =
( NAME    => "BUS1_PCI_RD_RESP0_LOW",
  ADDRESS => 0x00800308,
  NOTE    => "PCI Read Response Buffer 0 Lower Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00304_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_RD_RESP1_LOW                                                #
#                                                                        #
##########################################################################

%pic_01_00305_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "FILLED"                       => [   0,  63,   1, 0x8000000000000000, 0x00, 0, 0x0000000000000000, "Filled indicates that the buffer has valid data" ],
   "ARMED"                        => [   1,  62,   1, 0x4000000000000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   2,  61,   1, 0x2000000000000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   3,  60,   1, 0x1000000000000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error occurred" ],
   "PKTERR"                       => [   4,  59,   1, 0x0800000000000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   5,  58,   1, 0x0400000000000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   6,  57,   1, 0x0200000000000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   7,  56,   1, 0x0100000000000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   8,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [   9,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [  10,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00305_def =
( NAME    => "BUS1_PCI_RD_RESP1_LOW",
  ADDRESS => 0x00800318,
  NOTE    => "PCI Read Response Buffer 1 Lower Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00305_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_RD_RESP2_LOW                                                #
#                                                                        #
##########################################################################

%pic_01_00306_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "FILLED"                       => [   0,  63,   1, 0x8000000000000000, 0x00, 0, 0x0000000000000000, "Filled indicates that the buffer has valid data" ],
   "ARMED"                        => [   1,  62,   1, 0x4000000000000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   2,  61,   1, 0x2000000000000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   3,  60,   1, 0x1000000000000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error occurred" ],
   "PKTERR"                       => [   4,  59,   1, 0x0800000000000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   5,  58,   1, 0x0400000000000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   6,  57,   1, 0x0200000000000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   7,  56,   1, 0x0100000000000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   8,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [   9,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [  10,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00306_def =
( NAME    => "BUS1_PCI_RD_RESP2_LOW",
  ADDRESS => 0x00800328,
  NOTE    => "PCI Read Response Buffer 2 Lower Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00306_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_RD_RESP3_LOW                                                #
#                                                                        #
##########################################################################

%pic_01_00307_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "FILLED"                       => [   0,  63,   1, 0x8000000000000000, 0x00, 0, 0x0000000000000000, "Filled indicates that the buffer has valid data" ],
   "ARMED"                        => [   1,  62,   1, 0x4000000000000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   2,  61,   1, 0x2000000000000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   3,  60,   1, 0x1000000000000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error occurred" ],
   "PKTERR"                       => [   4,  59,   1, 0x0800000000000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   5,  58,   1, 0x0400000000000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   6,  57,   1, 0x0200000000000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   7,  56,   1, 0x0100000000000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   8,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [   9,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [  10,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00307_def =
( NAME    => "BUS1_PCI_RD_RESP3_LOW",
  ADDRESS => 0x00800338,
  NOTE    => "PCI Read Response Buffer 3 Lower Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00307_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_RD_RESP4_LOW                                                #
#                                                                        #
##########################################################################

%pic_01_00308_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "FILLED"                       => [   0,  63,   1, 0x8000000000000000, 0x00, 0, 0x0000000000000000, "Filled indicates that the buffer has valid data" ],
   "ARMED"                        => [   1,  62,   1, 0x4000000000000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   2,  61,   1, 0x2000000000000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   3,  60,   1, 0x1000000000000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error occurred" ],
   "PKTERR"                       => [   4,  59,   1, 0x0800000000000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   5,  58,   1, 0x0400000000000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   6,  57,   1, 0x0200000000000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   7,  56,   1, 0x0100000000000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   8,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [   9,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [  10,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00308_def =
( NAME    => "BUS1_PCI_RD_RESP4_LOW",
  ADDRESS => 0x00800348,
  NOTE    => "PCI Read Response Buffer 4 Lower Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00308_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_RD_RESP5_LOW                                                #
#                                                                        #
##########################################################################

%pic_01_00309_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "FILLED"                       => [   0,  63,   1, 0x8000000000000000, 0x00, 0, 0x0000000000000000, "Filled indicates that the buffer has valid data" ],
   "ARMED"                        => [   1,  62,   1, 0x4000000000000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   2,  61,   1, 0x2000000000000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   3,  60,   1, 0x1000000000000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error occurred" ],
   "PKTERR"                       => [   4,  59,   1, 0x0800000000000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   5,  58,   1, 0x0400000000000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   6,  57,   1, 0x0200000000000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   7,  56,   1, 0x0100000000000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   8,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [   9,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [  10,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00309_def =
( NAME    => "BUS1_PCI_RD_RESP5_LOW",
  ADDRESS => 0x00800358,
  NOTE    => "PCI Read Response Buffer 5 Lower Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00309_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_RD_RESP6_LOW                                                #
#                                                                        #
##########################################################################

%pic_01_00310_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "FILLED"                       => [   0,  63,   1, 0x8000000000000000, 0x00, 0, 0x0000000000000000, "Filled indicates that the buffer has valid data" ],
   "ARMED"                        => [   1,  62,   1, 0x4000000000000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   2,  61,   1, 0x2000000000000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   3,  60,   1, 0x1000000000000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error occurred" ],
   "PKTERR"                       => [   4,  59,   1, 0x0800000000000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   5,  58,   1, 0x0400000000000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   6,  57,   1, 0x0200000000000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   7,  56,   1, 0x0100000000000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   8,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [   9,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [  10,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00310_def =
( NAME    => "BUS1_PCI_RD_RESP6_LOW",
  ADDRESS => 0x00800368,
  NOTE    => "PCI Read Response Buffer 6 Lower Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00310_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_RD_RESP7_LOW                                                #
#                                                                        #
##########################################################################

%pic_01_00311_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "FILLED"                       => [   0,  63,   1, 0x8000000000000000, 0x00, 0, 0x0000000000000000, "Filled indicates that the buffer has valid data" ],
   "ARMED"                        => [   1,  62,   1, 0x4000000000000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   2,  61,   1, 0x2000000000000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   3,  60,   1, 0x1000000000000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error occurred" ],
   "PKTERR"                       => [   4,  59,   1, 0x0800000000000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   5,  58,   1, 0x0400000000000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   6,  57,   1, 0x0200000000000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   7,  56,   1, 0x0100000000000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   8,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [   9,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [  10,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00311_def =
( NAME    => "BUS1_PCI_RD_RESP7_LOW",
  ADDRESS => 0x00800378,
  NOTE    => "PCI Read Response Buffer 7 Lower Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00311_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_RD_RESP8_LOW                                                #
#                                                                        #
##########################################################################

%pic_01_00312_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "FILLED"                       => [   0,  63,   1, 0x8000000000000000, 0x00, 0, 0x0000000000000000, "Filled indicates that the buffer has valid data" ],
   "ARMED"                        => [   1,  62,   1, 0x4000000000000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   2,  61,   1, 0x2000000000000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   3,  60,   1, 0x1000000000000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error occurred" ],
   "PKTERR"                       => [   4,  59,   1, 0x0800000000000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   5,  58,   1, 0x0400000000000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   6,  57,   1, 0x0200000000000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   7,  56,   1, 0x0100000000000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   8,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [   9,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [  10,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00312_def =
( NAME    => "BUS1_PCI_RD_RESP8_LOW",
  ADDRESS => 0x00800388,
  NOTE    => "PCI Read Response Buffer 8 Lower Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00312_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_RD_RESP9_LOW                                                #
#                                                                        #
##########################################################################

%pic_01_00313_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "FILLED"                       => [   0,  63,   1, 0x8000000000000000, 0x00, 0, 0x0000000000000000, "Filled indicates that the buffer has valid data" ],
   "ARMED"                        => [   1,  62,   1, 0x4000000000000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   2,  61,   1, 0x2000000000000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   3,  60,   1, 0x1000000000000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error occurred" ],
   "PKTERR"                       => [   4,  59,   1, 0x0800000000000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   5,  58,   1, 0x0400000000000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   6,  57,   1, 0x0200000000000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   7,  56,   1, 0x0100000000000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   8,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [   9,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [  10,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00313_def =
( NAME    => "BUS1_PCI_RD_RESP9_LOW",
  ADDRESS => 0x00800398,
  NOTE    => "PCI Read Response Buffer 9 Lower Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00313_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_RD_RESP10_LOW                                               #
#                                                                        #
##########################################################################

%pic_01_00314_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "FILLED"                       => [   0,  63,   1, 0x8000000000000000, 0x00, 0, 0x0000000000000000, "Filled indicates that the buffer has valid data" ],
   "ARMED"                        => [   1,  62,   1, 0x4000000000000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   2,  61,   1, 0x2000000000000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   3,  60,   1, 0x1000000000000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error occurred" ],
   "PKTERR"                       => [   4,  59,   1, 0x0800000000000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   5,  58,   1, 0x0400000000000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   6,  57,   1, 0x0200000000000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   7,  56,   1, 0x0100000000000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   8,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [   9,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [  10,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00314_def =
( NAME    => "BUS1_PCI_RD_RESP10_LOW",
  ADDRESS => 0x008003A8,
  NOTE    => "PCI Read Response Buffer 10 Lower Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00314_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_RD_RESP11_LOW                                               #
#                                                                        #
##########################################################################

%pic_01_00315_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "FILLED"                       => [   0,  63,   1, 0x8000000000000000, 0x00, 0, 0x0000000000000000, "Filled indicates that the buffer has valid data" ],
   "ARMED"                        => [   1,  62,   1, 0x4000000000000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   2,  61,   1, 0x2000000000000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   3,  60,   1, 0x1000000000000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error occurred" ],
   "PKTERR"                       => [   4,  59,   1, 0x0800000000000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   5,  58,   1, 0x0400000000000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   6,  57,   1, 0x0200000000000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   7,  56,   1, 0x0100000000000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   8,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [   9,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [  10,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00315_def =
( NAME    => "BUS1_PCI_RD_RESP11_LOW",
  ADDRESS => 0x008003B8,
  NOTE    => "PCI Read Response Buffer 11 Lower Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00315_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_RD_RESP12_LOW                                               #
#                                                                        #
##########################################################################

%pic_01_00316_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "FILLED"                       => [   0,  63,   1, 0x8000000000000000, 0x00, 0, 0x0000000000000000, "Filled indicates that the buffer has valid data" ],
   "ARMED"                        => [   1,  62,   1, 0x4000000000000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   2,  61,   1, 0x2000000000000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   3,  60,   1, 0x1000000000000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error occurred" ],
   "PKTERR"                       => [   4,  59,   1, 0x0800000000000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   5,  58,   1, 0x0400000000000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   6,  57,   1, 0x0200000000000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   7,  56,   1, 0x0100000000000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   8,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [   9,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [  10,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00316_def =
( NAME    => "BUS1_PCI_RD_RESP12_LOW",
  ADDRESS => 0x008003C8,
  NOTE    => "PCI Read Response Buffer 12 Lower Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00316_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_RD_RESP13_LOW                                               #
#                                                                        #
##########################################################################

%pic_01_00317_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "FILLED"                       => [   0,  63,   1, 0x8000000000000000, 0x00, 0, 0x0000000000000000, "Filled indicates that the buffer has valid data" ],
   "ARMED"                        => [   1,  62,   1, 0x4000000000000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   2,  61,   1, 0x2000000000000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   3,  60,   1, 0x1000000000000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error occurred" ],
   "PKTERR"                       => [   4,  59,   1, 0x0800000000000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   5,  58,   1, 0x0400000000000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   6,  57,   1, 0x0200000000000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   7,  56,   1, 0x0100000000000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   8,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [   9,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [  10,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00317_def =
( NAME    => "BUS1_PCI_RD_RESP13_LOW",
  ADDRESS => 0x008003D8,
  NOTE    => "PCI Read Response Buffer 13 Lower Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00317_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_RD_RESP14_LOW                                               #
#                                                                        #
##########################################################################

%pic_01_00318_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "FILLED"                       => [   0,  63,   1, 0x8000000000000000, 0x00, 0, 0x0000000000000000, "Filled indicates that the buffer has valid data" ],
   "ARMED"                        => [   1,  62,   1, 0x4000000000000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   2,  61,   1, 0x2000000000000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   3,  60,   1, 0x1000000000000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error occurred" ],
   "PKTERR"                       => [   4,  59,   1, 0x0800000000000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   5,  58,   1, 0x0400000000000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   6,  57,   1, 0x0200000000000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   7,  56,   1, 0x0100000000000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   8,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [   9,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [  10,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00318_def =
( NAME    => "BUS1_PCI_RD_RESP14_LOW",
  ADDRESS => 0x008003E8,
  NOTE    => "PCI Read Response Buffer 14 Lower Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00318_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_RD_RESP15_LOW                                               #
#                                                                        #
##########################################################################

%pic_01_00319_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "FILLED"                       => [   0,  63,   1, 0x8000000000000000, 0x00, 0, 0x0000000000000000, "Filled indicates that the buffer has valid data" ],
   "ARMED"                        => [   1,  62,   1, 0x4000000000000000, 0x00, 0, 0x0000000000000000, "Request has been sent but data has not arrived" ],
   "FLUSH"                        => [   2,  61,   1, 0x2000000000000000, 0x00, 0, 0x0000000000000000, "Current outstanding buffer is marked to be flushed" ],
   "XERR"                         => [   3,  60,   1, 0x1000000000000000, 0x00, 0, 0x0000000000000000, "Xtalk cw error bit or invalid sideband error occurred" ],
   "PKTERR"                       => [   4,  59,   1, 0x0800000000000000, 0x00, 0, 0x0000000000000000, "Incoming packet was the wrong size" ],
   "TIMEOUT"                      => [   5,  58,   1, 0x0400000000000000, 0x00, 0, 0x0000000000000000, "Response has not arrived within the time limits" ],
   "PREFETCH"                     => [   6,  57,   1, 0x0200000000000000, 0x00, 0, 0x0000000000000000, "Request type Prefetch" ],
   "PRECISE"                      => [   7,  56,   1, 0x0100000000000000, 0x00, 0, 0x0000000000000000, "Request type Precise" ],
   "DW_BE"                        => [   8,  48,   8, 0x00FF000000000000, 0x00, 0, 0x0000000000000000, "Byte Enables used for precise transactions." ],
   "UPP_ADDR"                     => [   9,  32,  16, 0x0000FFFF00000000, 0x00, 0, 0x0000000000000000, "Address Bits 47:32" ],
   "LOW_ADDR"                     => [  10,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Address Bits 31:0" ],
);

%pic_01_00319_def =
( NAME    => "BUS1_PCI_RD_RESP15_LOW",
  ADDRESS => 0x008003F8,
  NOTE    => "PCI Read Response Buffer 15 Lower Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00319_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF0_FLUSH_CNT_DATA_TOUCH                                       #
#                                                                        #
##########################################################################

%pic_01_00320_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "TOUCH_CNT"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Count of Buffer Flushes with Data Touch" ],
);

%pic_01_00320_def =
( NAME    => "BUS1_BUF0_FLUSH_CNT_DATA_TOUCH",
  ADDRESS => 0x00800400,
  NOTE    => "PCI Buffer 0 Flush Count with Data Touch Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00320_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF1_FLUSH_CNT_DATA_TOUCH                                       #
#                                                                        #
##########################################################################

%pic_01_00321_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "TOUCH_CNT"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Count of Buffer Flushes with Data Touch" ],
);

%pic_01_00321_def =
( NAME    => "BUS1_BUF1_FLUSH_CNT_DATA_TOUCH",
  ADDRESS => 0x00800440,
  NOTE    => "PCI Buffer 1 Flush Count with Data Touch Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00321_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF2_FLUSH_CNT_DATA_TOUCH                                       #
#                                                                        #
##########################################################################

%pic_01_00322_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "TOUCH_CNT"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Count of Buffer Flushes with Data Touch" ],
);

%pic_01_00322_def =
( NAME    => "BUS1_BUF2_FLUSH_CNT_DATA_TOUCH",
  ADDRESS => 0x00800480,
  NOTE    => "PCI Buffer 2 Flush Count with Data Touch Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00322_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF3_FLUSH_CNT_DATA_TOUCH                                       #
#                                                                        #
##########################################################################

%pic_01_00323_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "TOUCH_CNT"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Count of Buffer Flushes with Data Touch" ],
);

%pic_01_00323_def =
( NAME    => "BUS1_BUF3_FLUSH_CNT_DATA_TOUCH",
  ADDRESS => 0x008004C0,
  NOTE    => "PCI Buffer 3 Flush Count with Data Touch Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00323_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF4_FLUSH_CNT_DATA_TOUCH                                       #
#                                                                        #
##########################################################################

%pic_01_00324_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "TOUCH_CNT"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Count of Buffer Flushes with Data Touch" ],
);

%pic_01_00324_def =
( NAME    => "BUS1_BUF4_FLUSH_CNT_DATA_TOUCH",
  ADDRESS => 0x00800500,
  NOTE    => "PCI Buffer 4 Flush Count with Data Touch Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00324_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF5_FLUSH_CNT_DATA_TOUCH                                       #
#                                                                        #
##########################################################################

%pic_01_00325_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "TOUCH_CNT"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Count of Buffer Flushes with Data Touch" ],
);

%pic_01_00325_def =
( NAME    => "BUS1_BUF5_FLUSH_CNT_DATA_TOUCH",
  ADDRESS => 0x00800540,
  NOTE    => "PCI Buffer 5 Flush Count with Data Touch Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00325_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF6_FLUSH_CNT_DATA_TOUCH                                       #
#                                                                        #
##########################################################################

%pic_01_00326_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "TOUCH_CNT"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Count of Buffer Flushes with Data Touch" ],
);

%pic_01_00326_def =
( NAME    => "BUS1_BUF6_FLUSH_CNT_DATA_TOUCH",
  ADDRESS => 0x00800580,
  NOTE    => "PCI Buffer 6 Flush Count with Data Touch Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00326_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF7_FLUSH_CNT_DATA_TOUCH                                       #
#                                                                        #
##########################################################################

%pic_01_00327_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "TOUCH_CNT"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Count of Buffer Flushes with Data Touch" ],
);

%pic_01_00327_def =
( NAME    => "BUS1_BUF7_FLUSH_CNT_DATA_TOUCH",
  ADDRESS => 0x008005C0,
  NOTE    => "PCI Buffer 7 Flush Count with Data Touch Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00327_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF0_FLUSH_CNT_NO_DATA_TOUCH                                     #
#                                                                        #
##########################################################################

%pic_01_00328_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "NOTOUCH_CNT"                  => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Count of Buffer Flushes without Data Touch" ],
);

%pic_01_00328_def =
( NAME    => "BUS1_BUF0_FLUSH_CNT_NO_DATA_TOUCH",
  ADDRESS => 0x00800408,
  NOTE    => "PCI Buffer 0 Flush Count without Data Touch Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00328_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF1_FLUSH_CNT_NO_DATA_TOUCH                                     #
#                                                                        #
##########################################################################

%pic_01_00329_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "NOTOUCH_CNT"                  => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Count of Buffer Flushes without Data Touch" ],
);

%pic_01_00329_def =
( NAME    => "BUS1_BUF1_FLUSH_CNT_NO_DATA_TOUCH",
  ADDRESS => 0x00800448,
  NOTE    => "PCI Buffer 1 Flush Count without Data Touch Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00329_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF2_FLUSH_CNT_NO_DATA_TOUCH                                     #
#                                                                        #
##########################################################################

%pic_01_00330_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "NOTOUCH_CNT"                  => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Count of Buffer Flushes without Data Touch" ],
);

%pic_01_00330_def =
( NAME    => "BUS1_BUF2_FLUSH_CNT_NO_DATA_TOUCH",
  ADDRESS => 0x00800488,
  NOTE    => "PCI Buffer 2 Flush Count without Data Touch Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00330_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF3_FLUSH_CNT_NO_DATA_TOUCH                                     #
#                                                                        #
##########################################################################

%pic_01_00331_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "NOTOUCH_CNT"                  => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Count of Buffer Flushes without Data Touch" ],
);

%pic_01_00331_def =
( NAME    => "BUS1_BUF3_FLUSH_CNT_NO_DATA_TOUCH",
  ADDRESS => 0x008004C8,
  NOTE    => "PCI Buffer 3 Flush Count without Data Touch Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00331_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF4_FLUSH_CNT_NO_DATA_TOUCH                                     #
#                                                                        #
##########################################################################

%pic_01_00332_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "NOTOUCH_CNT"                  => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Count of Buffer Flushes without Data Touch" ],
);

%pic_01_00332_def =
( NAME    => "BUS1_BUF4_FLUSH_CNT_NO_DATA_TOUCH",
  ADDRESS => 0x00800508,
  NOTE    => "PCI Buffer 4 Flush Count without Data Touch Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00332_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF5_FLUSH_CNT_NO_DATA_TOUCH                                     #
#                                                                        #
##########################################################################

%pic_01_00333_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "NOTOUCH_CNT"                  => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Count of Buffer Flushes without Data Touch" ],
);

%pic_01_00333_def =
( NAME    => "BUS1_BUF5_FLUSH_CNT_NO_DATA_TOUCH",
  ADDRESS => 0x00800548,
  NOTE    => "PCI Buffer 5 Flush Count without Data Touch Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00333_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF6_FLUSH_CNT_NO_DATA_TOUCH                                     #
#                                                                        #
##########################################################################

%pic_01_00334_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "NOTOUCH_CNT"                  => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Count of Buffer Flushes without Data Touch" ],
);

%pic_01_00334_def =
( NAME    => "BUS1_BUF6_FLUSH_CNT_NO_DATA_TOUCH",
  ADDRESS => 0x00800588,
  NOTE    => "PCI Buffer 6 Flush Count without Data Touch Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00334_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF7_FLUSH_CNT_NO_DATA_TOUCH                                     #
#                                                                        #
##########################################################################

%pic_01_00335_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "NOTOUCH_CNT"                  => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Count of Buffer Flushes without Data Touch" ],
);

%pic_01_00335_def =
( NAME    => "BUS1_BUF7_FLUSH_CNT_NO_DATA_TOUCH",
  ADDRESS => 0x008005C8,
  NOTE    => "PCI Buffer 7 Flush Count without Data Touch Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00335_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF0_REQ_FLIGHT_CNT                                             #
#                                                                        #
##########################################################################

%pic_01_00336_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INFLIGHT_CNT"                 => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "In-flight Count" ],
);

%pic_01_00336_def =
( NAME    => "BUS1_BUF0_REQ_FLIGHT_CNT",
  ADDRESS => 0x00800410,
  NOTE    => "PCI Buffer 0 Request In-flight Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00336_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF1_REQ_FLIGHT_CNT                                             #
#                                                                        #
##########################################################################

%pic_01_00337_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INFLIGHT_CNT"                 => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "In-flight Count" ],
);

%pic_01_00337_def =
( NAME    => "BUS1_BUF1_REQ_FLIGHT_CNT",
  ADDRESS => 0x00800450,
  NOTE    => "PCI Buffer 1 Request In-flight Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00337_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF2_REQ_FLIGHT_CNT                                             #
#                                                                        #
##########################################################################

%pic_01_00338_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INFLIGHT_CNT"                 => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "In-flight Count" ],
);

%pic_01_00338_def =
( NAME    => "BUS1_BUF2_REQ_FLIGHT_CNT",
  ADDRESS => 0x00800490,
  NOTE    => "PCI Buffer 2 Request In-flight Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00338_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF3_REQ_FLIGHT_CNT                                             #
#                                                                        #
##########################################################################

%pic_01_00339_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INFLIGHT_CNT"                 => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "In-flight Count" ],
);

%pic_01_00339_def =
( NAME    => "BUS1_BUF3_REQ_FLIGHT_CNT",
  ADDRESS => 0x008004D0,
  NOTE    => "PCI Buffer 3 Request In-flight Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00339_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF4_REQ_FLIGHT_CNT                                             #
#                                                                        #
##########################################################################

%pic_01_00340_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INFLIGHT_CNT"                 => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "In-flight Count" ],
);

%pic_01_00340_def =
( NAME    => "BUS1_BUF4_REQ_FLIGHT_CNT",
  ADDRESS => 0x00800510,
  NOTE    => "PCI Buffer 4 Request In-flight Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00340_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF5_REQ_FLIGHT_CNT                                             #
#                                                                        #
##########################################################################

%pic_01_00341_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INFLIGHT_CNT"                 => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "In-flight Count" ],
);

%pic_01_00341_def =
( NAME    => "BUS1_BUF5_REQ_FLIGHT_CNT",
  ADDRESS => 0x00800550,
  NOTE    => "PCI Buffer 5 Request In-flight Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00341_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF6_REQ_FLIGHT_CNT                                             #
#                                                                        #
##########################################################################

%pic_01_00342_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INFLIGHT_CNT"                 => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "In-flight Count" ],
);

%pic_01_00342_def =
( NAME    => "BUS1_BUF6_REQ_FLIGHT_CNT",
  ADDRESS => 0x00800590,
  NOTE    => "PCI Buffer 6 Request In-flight Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00342_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF7_REQ_FLIGHT_CNT                                             #
#                                                                        #
##########################################################################

%pic_01_00343_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "INFLIGHT_CNT"                 => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "In-flight Count" ],
);

%pic_01_00343_def =
( NAME    => "BUS1_BUF7_REQ_FLIGHT_CNT",
  ADDRESS => 0x008005D0,
  NOTE    => "PCI Buffer 7 Request In-flight Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00343_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF0_PREFETCH_REQ_CNT                                           #
#                                                                        #
##########################################################################

%pic_01_00344_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PREFETCH_CNT"                 => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Prefetch Count" ],
);

%pic_01_00344_def =
( NAME    => "BUS1_BUF0_PREFETCH_REQ_CNT",
  ADDRESS => 0x00800418,
  NOTE    => "PCI Buffer 0 Prefetch Request Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00344_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF1_PREFETCH_REQ_CNT                                           #
#                                                                        #
##########################################################################

%pic_01_00345_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PREFETCH_CNT"                 => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Prefetch Count" ],
);

%pic_01_00345_def =
( NAME    => "BUS1_BUF1_PREFETCH_REQ_CNT",
  ADDRESS => 0x00800458,
  NOTE    => "PCI Buffer 1 Prefetch Request Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00345_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF2_PREFETCH_REQ_CNT                                           #
#                                                                        #
##########################################################################

%pic_01_00346_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PREFETCH_CNT"                 => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Prefetch Count" ],
);

%pic_01_00346_def =
( NAME    => "BUS1_BUF2_PREFETCH_REQ_CNT",
  ADDRESS => 0x00800498,
  NOTE    => "PCI Buffer 2 Prefetch Request Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00346_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF3_PREFETCH_REQ_CNT                                           #
#                                                                        #
##########################################################################

%pic_01_00347_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PREFETCH_CNT"                 => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Prefetch Count" ],
);

%pic_01_00347_def =
( NAME    => "BUS1_BUF3_PREFETCH_REQ_CNT",
  ADDRESS => 0x008004D8,
  NOTE    => "PCI Buffer 3 Prefetch Request Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00347_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF4_PREFETCH_REQ_CNT                                           #
#                                                                        #
##########################################################################

%pic_01_00348_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PREFETCH_CNT"                 => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Prefetch Count" ],
);

%pic_01_00348_def =
( NAME    => "BUS1_BUF4_PREFETCH_REQ_CNT",
  ADDRESS => 0x00800518,
  NOTE    => "PCI Buffer 4 Prefetch Request Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00348_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF5_PREFETCH_REQ_CNT                                           #
#                                                                        #
##########################################################################

%pic_01_00349_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PREFETCH_CNT"                 => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Prefetch Count" ],
);

%pic_01_00349_def =
( NAME    => "BUS1_BUF5_PREFETCH_REQ_CNT",
  ADDRESS => 0x00800558,
  NOTE    => "PCI Buffer 5 Prefetch Request Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00349_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF6_PREFETCH_REQ_CNT                                           #
#                                                                        #
##########################################################################

%pic_01_00350_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PREFETCH_CNT"                 => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Prefetch Count" ],
);

%pic_01_00350_def =
( NAME    => "BUS1_BUF6_PREFETCH_REQ_CNT",
  ADDRESS => 0x00800598,
  NOTE    => "PCI Buffer 6 Prefetch Request Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00350_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF7_PREFETCH_REQ_CNT                                           #
#                                                                        #
##########################################################################

%pic_01_00351_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "PREFETCH_CNT"                 => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Prefetch Count" ],
);

%pic_01_00351_def =
( NAME    => "BUS1_BUF7_PREFETCH_REQ_CNT",
  ADDRESS => 0x008005D8,
  NOTE    => "PCI Buffer 7 Prefetch Request Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00351_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF0_TOT_PCI_RETRY_CNT                                          #
#                                                                        #
##########################################################################

%pic_01_00352_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RETRY_CNT"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Retry Count" ],
);

%pic_01_00352_def =
( NAME    => "BUS1_BUF0_TOT_PCI_RETRY_CNT",
  ADDRESS => 0x00800420,
  NOTE    => "PCI Buffer 0 Total Retry Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00352_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF1_TOT_PCI_RETRY_CNT                                          #
#                                                                        #
##########################################################################

%pic_01_00353_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RETRY_CNT"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Retry Count" ],
);

%pic_01_00353_def =
( NAME    => "BUS1_BUF1_TOT_PCI_RETRY_CNT",
  ADDRESS => 0x00800460,
  NOTE    => "PCI Buffer 1 Total Retry Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00353_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF2_TOT_PCI_RETRY_CNT                                          #
#                                                                        #
##########################################################################

%pic_01_00354_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RETRY_CNT"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Retry Count" ],
);

%pic_01_00354_def =
( NAME    => "BUS1_BUF2_TOT_PCI_RETRY_CNT",
  ADDRESS => 0x008004A0,
  NOTE    => "PCI Buffer 2 Total Retry Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00354_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF3_TOT_PCI_RETRY_CNT                                          #
#                                                                        #
##########################################################################

%pic_01_00355_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RETRY_CNT"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Retry Count" ],
);

%pic_01_00355_def =
( NAME    => "BUS1_BUF3_TOT_PCI_RETRY_CNT",
  ADDRESS => 0x008004E0,
  NOTE    => "PCI Buffer 3 Total Retry Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00355_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF4_TOT_PCI_RETRY_CNT                                          #
#                                                                        #
##########################################################################

%pic_01_00356_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RETRY_CNT"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Retry Count" ],
);

%pic_01_00356_def =
( NAME    => "BUS1_BUF4_TOT_PCI_RETRY_CNT",
  ADDRESS => 0x00800520,
  NOTE    => "PCI Buffer 4 Total Retry Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00356_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF5_TOT_PCI_RETRY_CNT                                          #
#                                                                        #
##########################################################################

%pic_01_00357_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RETRY_CNT"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Retry Count" ],
);

%pic_01_00357_def =
( NAME    => "BUS1_BUF5_TOT_PCI_RETRY_CNT",
  ADDRESS => 0x00800560,
  NOTE    => "PCI Buffer 5 Total Retry Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00357_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF6_TOT_PCI_RETRY_CNT                                          #
#                                                                        #
##########################################################################

%pic_01_00358_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RETRY_CNT"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Retry Count" ],
);

%pic_01_00358_def =
( NAME    => "BUS1_BUF6_TOT_PCI_RETRY_CNT",
  ADDRESS => 0x008005A0,
  NOTE    => "PCI Buffer 6 Total Retry Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00358_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF7_TOT_PCI_RETRY_CNT                                          #
#                                                                        #
##########################################################################

%pic_01_00359_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RETRY_CNT"                    => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Retry Count" ],
);

%pic_01_00359_def =
( NAME    => "BUS1_BUF7_TOT_PCI_RETRY_CNT",
  ADDRESS => 0x008005E0,
  NOTE    => "PCI Buffer 7 Total Retry Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00359_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF0_MAX_PCI_RETRY_CNT                                          #
#                                                                        #
##########################################################################

%pic_01_00360_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MAX_RETRY_CNT"                => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Max Retry Count" ],
);

%pic_01_00360_def =
( NAME    => "BUS1_BUF0_MAX_PCI_RETRY_CNT",
  ADDRESS => 0x00800428,
  NOTE    => "PCI Buffer 0 Max PCI Retry Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00360_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF1_MAX_PCI_RETRY_CNT                                          #
#                                                                        #
##########################################################################

%pic_01_00361_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MAX_RETRY_CNT"                => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Max Retry Count" ],
);

%pic_01_00361_def =
( NAME    => "BUS1_BUF1_MAX_PCI_RETRY_CNT",
  ADDRESS => 0x00800468,
  NOTE    => "PCI Buffer 1 Max PCI Retry Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00361_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF2_MAX_PCI_RETRY_CNT                                          #
#                                                                        #
##########################################################################

%pic_01_00362_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MAX_RETRY_CNT"                => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Max Retry Count" ],
);

%pic_01_00362_def =
( NAME    => "BUS1_BUF2_MAX_PCI_RETRY_CNT",
  ADDRESS => 0x008004A8,
  NOTE    => "PCI Buffer 2 Max PCI Retry Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00362_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF3_MAX_PCI_RETRY_CNT                                          #
#                                                                        #
##########################################################################

%pic_01_00363_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MAX_RETRY_CNT"                => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Max Retry Count" ],
);

%pic_01_00363_def =
( NAME    => "BUS1_BUF3_MAX_PCI_RETRY_CNT",
  ADDRESS => 0x008004E8,
  NOTE    => "PCI Buffer 3 Max PCI Retry Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00363_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF4_MAX_PCI_RETRY_CNT                                          #
#                                                                        #
##########################################################################

%pic_01_00364_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MAX_RETRY_CNT"                => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Max Retry Count" ],
);

%pic_01_00364_def =
( NAME    => "BUS1_BUF4_MAX_PCI_RETRY_CNT",
  ADDRESS => 0x00800528,
  NOTE    => "PCI Buffer 4 Max PCI Retry Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00364_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF5_MAX_PCI_RETRY_CNT                                          #
#                                                                        #
##########################################################################

%pic_01_00365_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MAX_RETRY_CNT"                => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Max Retry Count" ],
);

%pic_01_00365_def =
( NAME    => "BUS1_BUF5_MAX_PCI_RETRY_CNT",
  ADDRESS => 0x00800568,
  NOTE    => "PCI Buffer 5 Max PCI Retry Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00365_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF6_MAX_PCI_RETRY_CNT                                          #
#                                                                        #
##########################################################################

%pic_01_00366_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MAX_RETRY_CNT"                => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Max Retry Count" ],
);

%pic_01_00366_def =
( NAME    => "BUS1_BUF6_MAX_PCI_RETRY_CNT",
  ADDRESS => 0x008005A8,
  NOTE    => "PCI Buffer 6 Max PCI Retry Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00366_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF7_MAX_PCI_RETRY_CNT                                          #
#                                                                        #
##########################################################################

%pic_01_00367_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MAX_RETRY_CNT"                => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Max Retry Count" ],
);

%pic_01_00367_def =
( NAME    => "BUS1_BUF7_MAX_PCI_RETRY_CNT",
  ADDRESS => 0x008005E8,
  NOTE    => "PCI Buffer 7 Max PCI Retry Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00367_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF0_MAX_LAT_CNT_REG                                            #
#                                                                        #
##########################################################################

%pic_01_00368_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MAX_LATENCY_CNT"              => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Max Latency Count" ],
);

%pic_01_00368_def =
( NAME    => "BUS1_BUF0_MAX_LAT_CNT_REG",
  ADDRESS => 0x00800430,
  NOTE    => "PCI Buffer 0 Max Latency Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00368_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF1_MAX_LAT_CNT_REG                                            #
#                                                                        #
##########################################################################

%pic_01_00369_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MAX_LATENCY_CNT"              => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Max Latency Count" ],
);

%pic_01_00369_def =
( NAME    => "BUS1_BUF1_MAX_LAT_CNT_REG",
  ADDRESS => 0x00800470,
  NOTE    => "PCI Buffer 1 Max Latency Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00369_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF2_MAX_LAT_CNT_REG                                            #
#                                                                        #
##########################################################################

%pic_01_00370_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MAX_LATENCY_CNT"              => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Max Latency Count" ],
);

%pic_01_00370_def =
( NAME    => "BUS1_BUF2_MAX_LAT_CNT_REG",
  ADDRESS => 0x008004B0,
  NOTE    => "PCI Buffer 2 Max Latency Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00370_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF3_MAX_LAT_CNT_REG                                            #
#                                                                        #
##########################################################################

%pic_01_00371_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MAX_LATENCY_CNT"              => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Max Latency Count" ],
);

%pic_01_00371_def =
( NAME    => "BUS1_BUF3_MAX_LAT_CNT_REG",
  ADDRESS => 0x008004F0,
  NOTE    => "PCI Buffer 3 Max Latency Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00371_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF4_MAX_LAT_CNT_REG                                            #
#                                                                        #
##########################################################################

%pic_01_00372_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MAX_LATENCY_CNT"              => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Max Latency Count" ],
);

%pic_01_00372_def =
( NAME    => "BUS1_BUF4_MAX_LAT_CNT_REG",
  ADDRESS => 0x00800530,
  NOTE    => "PCI Buffer 4 Max Latency Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00372_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF5_MAX_LAT_CNT_REG                                            #
#                                                                        #
##########################################################################

%pic_01_00373_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MAX_LATENCY_CNT"              => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Max Latency Count" ],
);

%pic_01_00373_def =
( NAME    => "BUS1_BUF5_MAX_LAT_CNT_REG",
  ADDRESS => 0x00800570,
  NOTE    => "PCI Buffer 5 Max Latency Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00373_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF6_MAX_LAT_CNT_REG                                            #
#                                                                        #
##########################################################################

%pic_01_00374_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MAX_LATENCY_CNT"              => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Max Latency Count" ],
);

%pic_01_00374_def =
( NAME    => "BUS1_BUF6_MAX_LAT_CNT_REG",
  ADDRESS => 0x008005B0,
  NOTE    => "PCI Buffer 6 Max Latency Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00374_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF7_MAX_LAT_CNT_REG                                            #
#                                                                        #
##########################################################################

%pic_01_00375_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "RSVD1"                        => [   1,  16,  16, 0x00000000FFFF0000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "MAX_LATENCY_CNT"              => [   2,   0,  16, 0x000000000000FFFF, 0x00, 0, 0x0000000000000000, "Max Latency Count" ],
);

%pic_01_00375_def =
( NAME    => "BUS1_BUF7_MAX_LAT_CNT_REG",
  ADDRESS => 0x008005F0,
  NOTE    => "PCI Buffer 7 Max Latency Count Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00375_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF0_MAX_LAT_CNT                                                #
#                                                                        #
##########################################################################

%pic_01_00376_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "VALUE"                        => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Clears all the count values for the 0 registers" ],
);

%pic_01_00376_def =
( NAME    => "BUS1_BUF0_MAX_LAT_CNT",
  ADDRESS => 0x00800438,
  NOTE    => "PCI Buffer 0 Clear All Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00376_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF1_MAX_LAT_CNT                                                #
#                                                                        #
##########################################################################

%pic_01_00377_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "VALUE"                        => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Clears all the count values for the 1 registers" ],
);

%pic_01_00377_def =
( NAME    => "BUS1_BUF1_MAX_LAT_CNT",
  ADDRESS => 0x00800478,
  NOTE    => "PCI Buffer 1 Clear All Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00377_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF2_MAX_LAT_CNT                                                #
#                                                                        #
##########################################################################

%pic_01_00378_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "VALUE"                        => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Clears all the count values for the 2 registers" ],
);

%pic_01_00378_def =
( NAME    => "BUS1_BUF2_MAX_LAT_CNT",
  ADDRESS => 0x008004B8,
  NOTE    => "PCI Buffer 2 Clear All Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00378_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF3_MAX_LAT_CNT                                                #
#                                                                        #
##########################################################################

%pic_01_00379_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "VALUE"                        => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Clears all the count values for the 3 registers" ],
);

%pic_01_00379_def =
( NAME    => "BUS1_BUF3_MAX_LAT_CNT",
  ADDRESS => 0x008004F8,
  NOTE    => "PCI Buffer 3 Clear All Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00379_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF4_MAX_LAT_CNT                                                #
#                                                                        #
##########################################################################

%pic_01_00380_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "VALUE"                        => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Clears all the count values for the 4 registers" ],
);

%pic_01_00380_def =
( NAME    => "BUS1_BUF4_MAX_LAT_CNT",
  ADDRESS => 0x00800538,
  NOTE    => "PCI Buffer 4 Clear All Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00380_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF5_MAX_LAT_CNT                                                #
#                                                                        #
##########################################################################

%pic_01_00381_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "VALUE"                        => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Clears all the count values for the 5 registers" ],
);

%pic_01_00381_def =
( NAME    => "BUS1_BUF5_MAX_LAT_CNT",
  ADDRESS => 0x00800578,
  NOTE    => "PCI Buffer 5 Clear All Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00381_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF6_MAX_LAT_CNT                                                #
#                                                                        #
##########################################################################

%pic_01_00382_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "VALUE"                        => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Clears all the count values for the 6 registers" ],
);

%pic_01_00382_def =
( NAME    => "BUS1_BUF6_MAX_LAT_CNT",
  ADDRESS => 0x008005B8,
  NOTE    => "PCI Buffer 6 Clear All Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00382_flds
);


##########################################################################
#                                                                        #
#   BUS1_BUF7_MAX_LAT_CNT                                                #
#                                                                        #
##########################################################################

%pic_01_00383_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "VALUE"                        => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "Clears all the count values for the 7 registers" ],
);

%pic_01_00383_def =
( NAME    => "BUS1_BUF7_MAX_LAT_CNT",
  ADDRESS => 0x008005F8,
  NOTE    => "PCI Buffer 7 Clear All Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00383_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_RD_BUF0_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00384_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00384_def =
( NAME    => "BUS1_PCI_X_RD_BUF0_ATTR",
  ADDRESS => 0x00800A08,
  NOTE    => "PCI-X Read Buffer 0 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00384_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_RD_BUF1_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00385_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00385_def =
( NAME    => "BUS1_PCI_X_RD_BUF1_ATTR",
  ADDRESS => 0x00800A18,
  NOTE    => "PCI-X Read Buffer 1 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00385_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_RD_BUF2_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00386_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00386_def =
( NAME    => "BUS1_PCI_X_RD_BUF2_ATTR",
  ADDRESS => 0x00800A28,
  NOTE    => "PCI-X Read Buffer 2 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00386_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_RD_BUF3_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00387_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00387_def =
( NAME    => "BUS1_PCI_X_RD_BUF3_ATTR",
  ADDRESS => 0x00800A38,
  NOTE    => "PCI-X Read Buffer 3 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00387_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_RD_BUF4_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00388_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00388_def =
( NAME    => "BUS1_PCI_X_RD_BUF4_ATTR",
  ADDRESS => 0x00800A48,
  NOTE    => "PCI-X Read Buffer 4 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00388_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_RD_BUF5_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00389_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00389_def =
( NAME    => "BUS1_PCI_X_RD_BUF5_ATTR",
  ADDRESS => 0x00800A58,
  NOTE    => "PCI-X Read Buffer 5 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00389_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_RD_BUF6_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00390_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00390_def =
( NAME    => "BUS1_PCI_X_RD_BUF6_ATTR",
  ADDRESS => 0x00800A68,
  NOTE    => "PCI-X Read Buffer 6 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00390_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_RD_BUF7_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00391_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00391_def =
( NAME    => "BUS1_PCI_X_RD_BUF7_ATTR",
  ADDRESS => 0x00800A78,
  NOTE    => "PCI-X Read Buffer 7 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00391_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_RD_BUF8_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00392_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00392_def =
( NAME    => "BUS1_PCI_X_RD_BUF8_ATTR",
  ADDRESS => 0x00800A88,
  NOTE    => "PCI-X Read Buffer 8 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00392_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_RD_BUF9_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00393_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00393_def =
( NAME    => "BUS1_PCI_X_RD_BUF9_ATTR",
  ADDRESS => 0x00800A98,
  NOTE    => "PCI-X Read Buffer 9 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00393_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_RD_BUF10_ATTR                                             #
#                                                                        #
##########################################################################

%pic_01_00394_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00394_def =
( NAME    => "BUS1_PCI_X_RD_BUF10_ATTR",
  ADDRESS => 0x00800AA8,
  NOTE    => "PCI-X Read Buffer 10 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00394_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_RD_BUF11_ATTR                                             #
#                                                                        #
##########################################################################

%pic_01_00395_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00395_def =
( NAME    => "BUS1_PCI_X_RD_BUF11_ATTR",
  ADDRESS => 0x00800AB8,
  NOTE    => "PCI-X Read Buffer 11 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00395_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_RD_BUF12_ATTR                                             #
#                                                                        #
##########################################################################

%pic_01_00396_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00396_def =
( NAME    => "BUS1_PCI_X_RD_BUF12_ATTR",
  ADDRESS => 0x00800AC8,
  NOTE    => "PCI-X Read Buffer 12 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00396_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_RD_BUF13_ATTR                                             #
#                                                                        #
##########################################################################

%pic_01_00397_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00397_def =
( NAME    => "BUS1_PCI_X_RD_BUF13_ATTR",
  ADDRESS => 0x00800AD8,
  NOTE    => "PCI-X Read Buffer 13 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00397_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_RD_BUF14_ATTR                                             #
#                                                                        #
##########################################################################

%pic_01_00398_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00398_def =
( NAME    => "BUS1_PCI_X_RD_BUF14_ATTR",
  ADDRESS => 0x00800AE8,
  NOTE    => "PCI-X Read Buffer 14 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00398_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_RD_BUF15_ATTR                                             #
#                                                                        #
##########################################################################

%pic_01_00399_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00399_def =
( NAME    => "BUS1_PCI_X_RD_BUF15_ATTR",
  ADDRESS => 0x00800AF8,
  NOTE    => "PCI-X Read Buffer 15 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00399_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_WR_BUF0_ADDR                                              #
#                                                                        #
##########################################################################

%pic_01_00400_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "PCIX_ERR_ADDR"                => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "PCI-X Error Address" ],
);

%pic_01_00400_def =
( NAME    => "BUS1_PCI_X_WR_BUF0_ADDR",
  ADDRESS => 0x00800B00,
  NOTE    => "PCI-X Write Buffer 0 Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00400_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_WR_BUF1_ADDR                                              #
#                                                                        #
##########################################################################

%pic_01_00401_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "PCIX_ERR_ADDR"                => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "PCI-X Error Address" ],
);

%pic_01_00401_def =
( NAME    => "BUS1_PCI_X_WR_BUF1_ADDR",
  ADDRESS => 0x00800B20,
  NOTE    => "PCI-X Write Buffer 1 Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00401_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_WR_BUF2_ADDR                                              #
#                                                                        #
##########################################################################

%pic_01_00402_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "PCIX_ERR_ADDR"                => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "PCI-X Error Address" ],
);

%pic_01_00402_def =
( NAME    => "BUS1_PCI_X_WR_BUF2_ADDR",
  ADDRESS => 0x00800B40,
  NOTE    => "PCI-X Write Buffer 2 Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00402_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_WR_BUF3_ADDR                                              #
#                                                                        #
##########################################################################

%pic_01_00403_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "PCIX_ERR_ADDR"                => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "PCI-X Error Address" ],
);

%pic_01_00403_def =
( NAME    => "BUS1_PCI_X_WR_BUF3_ADDR",
  ADDRESS => 0x00800B60,
  NOTE    => "PCI-X Write Buffer 3 Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00403_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_WR_BUF4_ADDR                                              #
#                                                                        #
##########################################################################

%pic_01_00404_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "PCIX_ERR_ADDR"                => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "PCI-X Error Address" ],
);

%pic_01_00404_def =
( NAME    => "BUS1_PCI_X_WR_BUF4_ADDR",
  ADDRESS => 0x00800B80,
  NOTE    => "PCI-X Write Buffer 4 Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00404_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_WR_BUF5_ADDR                                              #
#                                                                        #
##########################################################################

%pic_01_00405_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "PCIX_ERR_ADDR"                => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "PCI-X Error Address" ],
);

%pic_01_00405_def =
( NAME    => "BUS1_PCI_X_WR_BUF5_ADDR",
  ADDRESS => 0x00800BA0,
  NOTE    => "PCI-X Write Buffer 5 Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00405_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_WR_BUF6_ADDR                                              #
#                                                                        #
##########################################################################

%pic_01_00406_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "PCIX_ERR_ADDR"                => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "PCI-X Error Address" ],
);

%pic_01_00406_def =
( NAME    => "BUS1_PCI_X_WR_BUF6_ADDR",
  ADDRESS => 0x00800BC0,
  NOTE    => "PCI-X Write Buffer 6 Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00406_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_WR_BUF7_ADDR                                              #
#                                                                        #
##########################################################################

%pic_01_00407_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "PCIX_ERR_ADDR"                => [   0,   0,  64, 0xFFFFFFFFFFFFFFFF, 0x00, 0, 0x0000000000000000, "PCI-X Error Address" ],
);

%pic_01_00407_def =
( NAME    => "BUS1_PCI_X_WR_BUF7_ADDR",
  ADDRESS => 0x00800BE0,
  NOTE    => "PCI-X Write Buffer 7 Address Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00407_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_WR_BUF0_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00408_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00408_def =
( NAME    => "BUS1_PCI_X_WR_BUF0_ATTR",
  ADDRESS => 0x00800B08,
  NOTE    => "PCI-X Write Buffer 0 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00408_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_WR_BUF1_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00409_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00409_def =
( NAME    => "BUS1_PCI_X_WR_BUF1_ATTR",
  ADDRESS => 0x00800B28,
  NOTE    => "PCI-X Write Buffer 1 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00409_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_WR_BUF2_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00410_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00410_def =
( NAME    => "BUS1_PCI_X_WR_BUF2_ATTR",
  ADDRESS => 0x00800B48,
  NOTE    => "PCI-X Write Buffer 2 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00410_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_WR_BUF3_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00411_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00411_def =
( NAME    => "BUS1_PCI_X_WR_BUF3_ATTR",
  ADDRESS => 0x00800B68,
  NOTE    => "PCI-X Write Buffer 3 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00411_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_WR_BUF4_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00412_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00412_def =
( NAME    => "BUS1_PCI_X_WR_BUF4_ATTR",
  ADDRESS => 0x00800B88,
  NOTE    => "PCI-X Write Buffer 4 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00412_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_WR_BUF5_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00413_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00413_def =
( NAME    => "BUS1_PCI_X_WR_BUF5_ATTR",
  ADDRESS => 0x00800BA8,
  NOTE    => "PCI-X Write Buffer 5 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00413_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_WR_BUF6_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00414_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00414_def =
( NAME    => "BUS1_PCI_X_WR_BUF6_ATTR",
  ADDRESS => 0x00800BC8,
  NOTE    => "PCI-X Write Buffer 6 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00414_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_WR_BUF7_ATTR                                              #
#                                                                        #
##########################################################################

%pic_01_00415_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  48,  16, 0xFFFF000000000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "BUS_CMD"                      => [   1,  44,   4, 0x0000F00000000000, 0x00, 0, 0x0000000000000000, "PCI-X Bus Command" ],
   "BYTE_CNT"                     => [   2,  32,  12, 0x00000FFF00000000, 0x00, 0, 0x0000000000000000, "PCI-X Entire Byte Count" ],
   "ENTRY_VALID"                  => [   3,  31,   1, 0x0000000080000000, 0x00, 0, 0x0000000000000000, "Valid Bit" ],
   "NS"                           => [   4,  30,   1, 0x0000000040000000, 0x00, 0, 0x0000000000000000, "PCI-X No Snoop (Non-Coherent)" ],
   "RO"                           => [   5,  29,   1, 0x0000000020000000, 0x00, 0, 0x0000000000000000, "PCI-X Relaxed Ordering" ],
   "TAG"                          => [   6,  24,   5, 0x000000001F000000, 0x00, 0, 0x0000000000000000, "PCI-X TAG" ],
   "BUS_NUM"                      => [   7,  16,   8, 0x0000000000FF0000, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Bus Number" ],
   "DEV_NUM"                      => [   8,  11,   5, 0x000000000000F800, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Device Number" ],
   "FUN_NUM"                      => [   9,   8,   3, 0x0000000000000700, 0x00, 0, 0x0000000000000000, "PCI-X Requestor Function Number" ],
   "RSVD1"                        => [  10,   6,   2, 0x00000000000000C0, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "F_BUFFER_INDEX"               => [  11,   0,   6, 0x000000000000003F, 0x00, 0, 0x0000000000000000, "First Buffer Index" ],
);

%pic_01_00415_def =
( NAME    => "BUS1_PCI_X_WR_BUF7_ATTR",
  ADDRESS => 0x00800BE8,
  NOTE    => "PCI-X Write Buffer 7 Attribute Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00415_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_WR_BUF0_VALID                                             #
#                                                                        #
##########################################################################

%pic_01_00416_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "WRT_VALID_BUFF"               => [   1,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Valid Buffers" ],
);

%pic_01_00416_def =
( NAME    => "BUS1_PCI_X_WR_BUF0_VALID",
  ADDRESS => 0x00800B10,
  NOTE    => "PCI-X Write Buffer 0 Valid Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00416_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_WR_BUF1_VALID                                             #
#                                                                        #
##########################################################################

%pic_01_00417_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "WRT_VALID_BUFF"               => [   1,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Valid Buffers" ],
);

%pic_01_00417_def =
( NAME    => "BUS1_PCI_X_WR_BUF1_VALID",
  ADDRESS => 0x00800B30,
  NOTE    => "PCI-X Write Buffer 1 Valid Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00417_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_WR_BUF2_VALID                                             #
#                                                                        #
##########################################################################

%pic_01_00418_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "WRT_VALID_BUFF"               => [   1,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Valid Buffers" ],
);

%pic_01_00418_def =
( NAME    => "BUS1_PCI_X_WR_BUF2_VALID",
  ADDRESS => 0x00800B50,
  NOTE    => "PCI-X Write Buffer 2 Valid Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00418_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_WR_BUF3_VALID                                             #
#                                                                        #
##########################################################################

%pic_01_00419_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "WRT_VALID_BUFF"               => [   1,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Valid Buffers" ],
);

%pic_01_00419_def =
( NAME    => "BUS1_PCI_X_WR_BUF3_VALID",
  ADDRESS => 0x00800B70,
  NOTE    => "PCI-X Write Buffer 3 Valid Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00419_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_WR_BUF4_VALID                                             #
#                                                                        #
##########################################################################

%pic_01_00420_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "WRT_VALID_BUFF"               => [   1,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Valid Buffers" ],
);

%pic_01_00420_def =
( NAME    => "BUS1_PCI_X_WR_BUF4_VALID",
  ADDRESS => 0x00800B90,
  NOTE    => "PCI-X Write Buffer 4 Valid Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00420_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_WR_BUF5_VALID                                             #
#                                                                        #
##########################################################################

%pic_01_00421_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "WRT_VALID_BUFF"               => [   1,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Valid Buffers" ],
);

%pic_01_00421_def =
( NAME    => "BUS1_PCI_X_WR_BUF5_VALID",
  ADDRESS => 0x00800BB0,
  NOTE    => "PCI-X Write Buffer 5 Valid Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00421_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_WR_BUF6_VALID                                             #
#                                                                        #
##########################################################################

%pic_01_00422_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "WRT_VALID_BUFF"               => [   1,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Valid Buffers" ],
);

%pic_01_00422_def =
( NAME    => "BUS1_PCI_X_WR_BUF6_VALID",
  ADDRESS => 0x00800BD0,
  NOTE    => "PCI-X Write Buffer 6 Valid Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00422_flds
);


##########################################################################
#                                                                        #
#   BUS1_PCI_X_WR_BUF7_VALID                                             #
#                                                                        #
##########################################################################

%pic_01_00423_flds =
(
#  LABEL                               IND  POS  LEN  FIELD_DATA_MASK     MODE  F  RESET_VALUE         DESCRIPTION
#  ------------------------------      ---  ---  ---  ------------------  ----  -  ------------------  -----------
   "RSVD0"                        => [   0,  32,  32, 0xFFFFFFFF00000000, 0x00, 0, 0x0000000000000000, "Reserved" ],
   "WRT_VALID_BUFF"               => [   1,   0,  32, 0x00000000FFFFFFFF, 0x00, 0, 0x0000000000000000, "Valid Buffers" ],
);

%pic_01_00423_def =
( NAME    => "BUS1_PCI_X_WR_BUF7_VALID",
  ADDRESS => 0x00800BF0,
  NOTE    => "PCI-X Write Buffer 7 Valid Register",
  RESET   => 0x0000000000000000,
  FIELDS  => \%pic_01_00423_flds
);


##########################################################################
#                                                                        #
#   MMR LOOKUP TABLES (BY NAME OR ADDRESS)                               #
#                                                                        #
##########################################################################

%pic_01_mmr_by_name = 
(
   BUS0_BRIDGE_ID               => \%pic_01_00000_def,
   BUS0_BRIDGE_STAT             => \%pic_01_00001_def,
   BUS0_BRIDGE_ERR_UPPER        => \%pic_01_00002_def,
   BUS0_BRIDGE_ERR_LOWER        => \%pic_01_00003_def,
   BUS0_BRIDGE_CTRL             => \%pic_01_00004_def,
   BUS0_BRIDGE_REQ_TO           => \%pic_01_00005_def,
   BUS0_BRIDGE_INT_UPPER        => \%pic_01_00006_def,
   BUS0_BRIDGE_INT_LOWER        => \%pic_01_00007_def,
   BUS0_CMDWORD_HOLD_REG_BUS    => \%pic_01_00008_def,
   BUS0_BRIDGE_LLP_CONFIG       => \%pic_01_00009_def,
   BUS0_BRIDGE_TARG_FLUSH       => \%pic_01_00010_def,
   BUS0_CMDWORD_HOLD_REG_LINK_SIDE => \%pic_01_00011_def,
   BUS0_BRIDGE_RESP_UPPER       => \%pic_01_00012_def,
   BUS0_BRIDGE_RESP_LOWER       => \%pic_01_00013_def,
   BUS0_DEBUG_PORT_CTRL         => \%pic_01_00014_def,
   BUS0_ADDR_HOLD_REG_LINK_SIDE => \%pic_01_00015_def,
   BUS0_DIR_MAP                 => \%pic_01_00016_def,
   BUS0_MAP_FAULT_ADDR_         => \%pic_01_00017_def,
   BUS0_ARB_PRIORITY            => \%pic_01_00018_def,
   BUS0_INT_RAM_PERR            => \%pic_01_00019_def,
   BUS0_PCI_TOUT                => \%pic_01_00020_def,
   BUS0_PCI_TYPE1_CONFIG        => \%pic_01_00021_def,
   BUS0_PCI_ERR_UPPER_ADDR      => \%pic_01_00022_def,
   BUS0_PCI_ERR_LOWER_ADDR      => \%pic_01_00023_def,
   BUS0_PCI_X_ERR_ADDR          => \%pic_01_00024_def,
   BUS0_PCI_X_ERR_ATTR          => \%pic_01_00025_def,
   BUS0_PCI_X_ERR_DATA          => \%pic_01_00026_def,
   BUS0_PCI_X_PIO_SPLIT_ERR_ADDR => \%pic_01_00027_def,
   BUS0_PCI_X_PIO_SPLIT_ERR_ATTR => \%pic_01_00028_def,
   BUS0_PCI_X_DMA_ERR_ATTR      => \%pic_01_00029_def,
   BUS0_PCI_X_DMA_ERR_ADDR      => \%pic_01_00030_def,
   BUS0_PCI_X_READ_REQ_TOUT     => \%pic_01_00031_def,
   BUS0_INT_STATUS              => \%pic_01_00032_def,
   BUS0_INT_ENABLE              => \%pic_01_00033_def,
   BUS0_RESET_INT_STATUS        => \%pic_01_00034_def,
   BUS0_INT_MODE                => \%pic_01_00035_def,
   BUS0_INT_DEV                 => \%pic_01_00036_def,
   BUS0_HOST_ERR_FIELD          => \%pic_01_00037_def,
   BUS0_INT0_HOST_ADDR          => \%pic_01_00038_def,
   BUS0_INT1_HOST_ADDR          => \%pic_01_00039_def,
   BUS0_INT2_HOST_ADDR          => \%pic_01_00040_def,
   BUS0_INT3_HOST_ADDR          => \%pic_01_00041_def,
   BUS0_INT4_HOST_ADDR          => \%pic_01_00042_def,
   BUS0_INT5_HOST_ADDR          => \%pic_01_00043_def,
   BUS0_INT6_HOST_ADDR          => \%pic_01_00044_def,
   BUS0_INT7_HOST_ADDR          => \%pic_01_00045_def,
   BUS0_ERR_INT_VIEW            => \%pic_01_00046_def,
   BUS0_MULT_INT                => \%pic_01_00047_def,
   BUS0_INT0_FORCE_ALWAYS       => \%pic_01_00048_def,
   BUS0_INT1_FORCE_ALWAYS       => \%pic_01_00049_def,
   BUS0_INT2_FORCE_ALWAYS       => \%pic_01_00050_def,
   BUS0_INT3_FORCE_ALWAYS       => \%pic_01_00051_def,
   BUS0_INT4_FORCE_ALWAYS       => \%pic_01_00052_def,
   BUS0_INT5_FORCE_ALWAYS       => \%pic_01_00053_def,
   BUS0_INT6_FORCE_ALWAYS       => \%pic_01_00054_def,
   BUS0_INT7_FORCE_ALWAYS       => \%pic_01_00055_def,
   BUS0_INT0_FORCE_PIN_REG      => \%pic_01_00056_def,
   BUS0_INT1_FORCE_PIN_REG      => \%pic_01_00057_def,
   BUS0_INT2_FORCE_PIN_REG      => \%pic_01_00058_def,
   BUS0_INT3_FORCE_PIN_REG      => \%pic_01_00059_def,
   BUS0_INT4_FORCE_PIN_REG      => \%pic_01_00060_def,
   BUS0_INT5_FORCE_PIN_REG      => \%pic_01_00061_def,
   BUS0_INT6_FORCE_PIN_REG      => \%pic_01_00062_def,
   BUS0_INT7_FORCE_PIN_REG      => \%pic_01_00063_def,
   BUS0_DEV0_REG                => \%pic_01_00064_def,
   BUS0_DEV1_REG                => \%pic_01_00065_def,
   BUS0_DEV2_REG                => \%pic_01_00066_def,
   BUS0_DEV3_REG                => \%pic_01_00067_def,
   BUS0_DEV0_WR_FLUSH           => \%pic_01_00068_def,
   BUS0_DEV1_WR_FLUSH           => \%pic_01_00069_def,
   BUS0_DEV2_WR_FLUSH           => \%pic_01_00070_def,
   BUS0_DEV3_WR_FLUSH           => \%pic_01_00071_def,
   BUS0_E_DEV_RSP_BUF           => \%pic_01_00072_def,
   BUS0_O_DEV_RSP_BUF           => \%pic_01_00073_def,
   BUS0_RR_BUFF_STATUS          => \%pic_01_00074_def,
   BUS0_RR_BUFF_CLR             => \%pic_01_00075_def,
   BUS0_PCI_RD_RESP0_UPP        => \%pic_01_00076_def,
   BUS0_PCI_RD_RESP1_UPP        => \%pic_01_00077_def,
   BUS0_PCI_RD_RESP2_UPP        => \%pic_01_00078_def,
   BUS0_PCI_RD_RESP3_UPP        => \%pic_01_00079_def,
   BUS0_PCI_RD_RESP4_UPP        => \%pic_01_00080_def,
   BUS0_PCI_RD_RESP5_UPP        => \%pic_01_00081_def,
   BUS0_PCI_RD_RESP6_UPP        => \%pic_01_00082_def,
   BUS0_PCI_RD_RESP7_UPP        => \%pic_01_00083_def,
   BUS0_PCI_RD_RESP8_UPP        => \%pic_01_00084_def,
   BUS0_PCI_RD_RESP9_UPP        => \%pic_01_00085_def,
   BUS0_PCI_RD_RESP10_UPP       => \%pic_01_00086_def,
   BUS0_PCI_RD_RESP11_UPP       => \%pic_01_00087_def,
   BUS0_PCI_RD_RESP12_UPP       => \%pic_01_00088_def,
   BUS0_PCI_RD_RESP13_UPP       => \%pic_01_00089_def,
   BUS0_PCI_RD_RESP14_UPP       => \%pic_01_00090_def,
   BUS0_PCI_RD_RESP15_UPP       => \%pic_01_00091_def,
   BUS0_PCI_RD_RESP0_LOW        => \%pic_01_00092_def,
   BUS0_PCI_RD_RESP1_LOW        => \%pic_01_00093_def,
   BUS0_PCI_RD_RESP2_LOW        => \%pic_01_00094_def,
   BUS0_PCI_RD_RESP3_LOW        => \%pic_01_00095_def,
   BUS0_PCI_RD_RESP4_LOW        => \%pic_01_00096_def,
   BUS0_PCI_RD_RESP5_LOW        => \%pic_01_00097_def,
   BUS0_PCI_RD_RESP6_LOW        => \%pic_01_00098_def,
   BUS0_PCI_RD_RESP7_LOW        => \%pic_01_00099_def,
   BUS0_PCI_RD_RESP8_LOW        => \%pic_01_00100_def,
   BUS0_PCI_RD_RESP9_LOW        => \%pic_01_00101_def,
   BUS0_PCI_RD_RESP10_LOW       => \%pic_01_00102_def,
   BUS0_PCI_RD_RESP11_LOW       => \%pic_01_00103_def,
   BUS0_PCI_RD_RESP12_LOW       => \%pic_01_00104_def,
   BUS0_PCI_RD_RESP13_LOW       => \%pic_01_00105_def,
   BUS0_PCI_RD_RESP14_LOW       => \%pic_01_00106_def,
   BUS0_PCI_RD_RESP15_LOW       => \%pic_01_00107_def,
   BUS0_BUF0_FLUSH_CNT_DATA_TOUCH => \%pic_01_00108_def,
   BUS0_BUF1_FLUSH_CNT_DATA_TOUCH => \%pic_01_00109_def,
   BUS0_BUF2_FLUSH_CNT_DATA_TOUCH => \%pic_01_00110_def,
   BUS0_BUF3_FLUSH_CNT_DATA_TOUCH => \%pic_01_00111_def,
   BUS0_BUF4_FLUSH_CNT_DATA_TOUCH => \%pic_01_00112_def,
   BUS0_BUF5_FLUSH_CNT_DATA_TOUCH => \%pic_01_00113_def,
   BUS0_BUF6_FLUSH_CNT_DATA_TOUCH => \%pic_01_00114_def,
   BUS0_BUF7_FLUSH_CNT_DATA_TOUCH => \%pic_01_00115_def,
   BUS0_BUF0_FLUSH_CNT_NO_DATA_TOUCH => \%pic_01_00116_def,
   BUS0_BUF1_FLUSH_CNT_NO_DATA_TOUCH => \%pic_01_00117_def,
   BUS0_BUF2_FLUSH_CNT_NO_DATA_TOUCH => \%pic_01_00118_def,
   BUS0_BUF3_FLUSH_CNT_NO_DATA_TOUCH => \%pic_01_00119_def,
   BUS0_BUF4_FLUSH_CNT_NO_DATA_TOUCH => \%pic_01_00120_def,
   BUS0_BUF5_FLUSH_CNT_NO_DATA_TOUCH => \%pic_01_00121_def,
   BUS0_BUF6_FLUSH_CNT_NO_DATA_TOUCH => \%pic_01_00122_def,
   BUS0_BUF7_FLUSH_CNT_NO_DATA_TOUCH => \%pic_01_00123_def,
   BUS0_BUF0_REQ_FLIGHT_CNT     => \%pic_01_00124_def,
   BUS0_BUF1_REQ_FLIGHT_CNT     => \%pic_01_00125_def,
   BUS0_BUF2_REQ_FLIGHT_CNT     => \%pic_01_00126_def,
   BUS0_BUF3_REQ_FLIGHT_CNT     => \%pic_01_00127_def,
   BUS0_BUF4_REQ_FLIGHT_CNT     => \%pic_01_00128_def,
   BUS0_BUF5_REQ_FLIGHT_CNT     => \%pic_01_00129_def,
   BUS0_BUF6_REQ_FLIGHT_CNT     => \%pic_01_00130_def,
   BUS0_BUF7_REQ_FLIGHT_CNT     => \%pic_01_00131_def,
   BUS0_BUF0_PREFETCH_REQ_CNT   => \%pic_01_00132_def,
   BUS0_BUF1_PREFETCH_REQ_CNT   => \%pic_01_00133_def,
   BUS0_BUF2_PREFETCH_REQ_CNT   => \%pic_01_00134_def,
   BUS0_BUF3_PREFETCH_REQ_CNT   => \%pic_01_00135_def,
   BUS0_BUF4_PREFETCH_REQ_CNT   => \%pic_01_00136_def,
   BUS0_BUF5_PREFETCH_REQ_CNT   => \%pic_01_00137_def,
   BUS0_BUF6_PREFETCH_REQ_CNT   => \%pic_01_00138_def,
   BUS0_BUF7_PREFETCH_REQ_CNT   => \%pic_01_00139_def,
   BUS0_BUF0_TOT_PCI_RETRY_CNT  => \%pic_01_00140_def,
   BUS0_BUF1_TOT_PCI_RETRY_CNT  => \%pic_01_00141_def,
   BUS0_BUF2_TOT_PCI_RETRY_CNT  => \%pic_01_00142_def,
   BUS0_BUF3_TOT_PCI_RETRY_CNT  => \%pic_01_00143_def,
   BUS0_BUF4_TOT_PCI_RETRY_CNT  => \%pic_01_00144_def,
   BUS0_BUF5_TOT_PCI_RETRY_CNT  => \%pic_01_00145_def,
   BUS0_BUF6_TOT_PCI_RETRY_CNT  => \%pic_01_00146_def,
   BUS0_BUF7_TOT_PCI_RETRY_CNT  => \%pic_01_00147_def,
   BUS0_BUF0_MAX_PCI_RETRY_CNT  => \%pic_01_00148_def,
   BUS0_BUF1_MAX_PCI_RETRY_CNT  => \%pic_01_00149_def,
   BUS0_BUF2_MAX_PCI_RETRY_CNT  => \%pic_01_00150_def,
   BUS0_BUF3_MAX_PCI_RETRY_CNT  => \%pic_01_00151_def,
   BUS0_BUF4_MAX_PCI_RETRY_CNT  => \%pic_01_00152_def,
   BUS0_BUF5_MAX_PCI_RETRY_CNT  => \%pic_01_00153_def,
   BUS0_BUF6_MAX_PCI_RETRY_CNT  => \%pic_01_00154_def,
   BUS0_BUF7_MAX_PCI_RETRY_CNT  => \%pic_01_00155_def,
   BUS0_BUF0_MAX_LAT_CNT_REG    => \%pic_01_00156_def,
   BUS0_BUF1_MAX_LAT_CNT_REG    => \%pic_01_00157_def,
   BUS0_BUF2_MAX_LAT_CNT_REG    => \%pic_01_00158_def,
   BUS0_BUF3_MAX_LAT_CNT_REG    => \%pic_01_00159_def,
   BUS0_BUF4_MAX_LAT_CNT_REG    => \%pic_01_00160_def,
   BUS0_BUF5_MAX_LAT_CNT_REG    => \%pic_01_00161_def,
   BUS0_BUF6_MAX_LAT_CNT_REG    => \%pic_01_00162_def,
   BUS0_BUF7_MAX_LAT_CNT_REG    => \%pic_01_00163_def,
   BUS0_BUF0_MAX_LAT_CNT        => \%pic_01_00164_def,
   BUS0_BUF1_MAX_LAT_CNT        => \%pic_01_00165_def,
   BUS0_BUF2_MAX_LAT_CNT        => \%pic_01_00166_def,
   BUS0_BUF3_MAX_LAT_CNT        => \%pic_01_00167_def,
   BUS0_BUF4_MAX_LAT_CNT        => \%pic_01_00168_def,
   BUS0_BUF5_MAX_LAT_CNT        => \%pic_01_00169_def,
   BUS0_BUF6_MAX_LAT_CNT        => \%pic_01_00170_def,
   BUS0_BUF7_MAX_LAT_CNT        => \%pic_01_00171_def,
   BUS0_PCI_X_RD_BUF0_ATTR      => \%pic_01_00172_def,
   BUS0_PCI_X_RD_BUF1_ATTR      => \%pic_01_00173_def,
   BUS0_PCI_X_RD_BUF2_ATTR      => \%pic_01_00174_def,
   BUS0_PCI_X_RD_BUF3_ATTR      => \%pic_01_00175_def,
   BUS0_PCI_X_RD_BUF4_ATTR      => \%pic_01_00176_def,
   BUS0_PCI_X_RD_BUF5_ATTR      => \%pic_01_00177_def,
   BUS0_PCI_X_RD_BUF6_ATTR      => \%pic_01_00178_def,
   BUS0_PCI_X_RD_BUF7_ATTR      => \%pic_01_00179_def,
   BUS0_PCI_X_RD_BUF8_ATTR      => \%pic_01_00180_def,
   BUS0_PCI_X_RD_BUF9_ATTR      => \%pic_01_00181_def,
   BUS0_PCI_X_RD_BUF10_ATTR     => \%pic_01_00182_def,
   BUS0_PCI_X_RD_BUF11_ATTR     => \%pic_01_00183_def,
   BUS0_PCI_X_RD_BUF12_ATTR     => \%pic_01_00184_def,
   BUS0_PCI_X_RD_BUF13_ATTR     => \%pic_01_00185_def,
   BUS0_PCI_X_RD_BUF14_ATTR     => \%pic_01_00186_def,
   BUS0_PCI_X_RD_BUF15_ATTR     => \%pic_01_00187_def,
   BUS0_PCI_X_WR_BUF0_ADDR      => \%pic_01_00188_def,
   BUS0_PCI_X_WR_BUF1_ADDR      => \%pic_01_00189_def,
   BUS0_PCI_X_WR_BUF2_ADDR      => \%pic_01_00190_def,
   BUS0_PCI_X_WR_BUF3_ADDR      => \%pic_01_00191_def,
   BUS0_PCI_X_WR_BUF4_ADDR      => \%pic_01_00192_def,
   BUS0_PCI_X_WR_BUF5_ADDR      => \%pic_01_00193_def,
   BUS0_PCI_X_WR_BUF6_ADDR      => \%pic_01_00194_def,
   BUS0_PCI_X_WR_BUF7_ADDR      => \%pic_01_00195_def,
   BUS0_PCI_X_WR_BUF0_ATTR      => \%pic_01_00196_def,
   BUS0_PCI_X_WR_BUF1_ATTR      => \%pic_01_00197_def,
   BUS0_PCI_X_WR_BUF2_ATTR      => \%pic_01_00198_def,
   BUS0_PCI_X_WR_BUF3_ATTR      => \%pic_01_00199_def,
   BUS0_PCI_X_WR_BUF4_ATTR      => \%pic_01_00200_def,
   BUS0_PCI_X_WR_BUF5_ATTR      => \%pic_01_00201_def,
   BUS0_PCI_X_WR_BUF6_ATTR      => \%pic_01_00202_def,
   BUS0_PCI_X_WR_BUF7_ATTR      => \%pic_01_00203_def,
   BUS0_PCI_X_WR_BUF0_VALID     => \%pic_01_00204_def,
   BUS0_PCI_X_WR_BUF1_VALID     => \%pic_01_00205_def,
   BUS0_PCI_X_WR_BUF2_VALID     => \%pic_01_00206_def,
   BUS0_PCI_X_WR_BUF3_VALID     => \%pic_01_00207_def,
   BUS0_PCI_X_WR_BUF4_VALID     => \%pic_01_00208_def,
   BUS0_PCI_X_WR_BUF5_VALID     => \%pic_01_00209_def,
   BUS0_PCI_X_WR_BUF6_VALID     => \%pic_01_00210_def,
   BUS0_PCI_X_WR_BUF7_VALID     => \%pic_01_00211_def,
   BUS1_BRIDGE_ID               => \%pic_01_00212_def,
   BUS1_BRIDGE_STAT             => \%pic_01_00213_def,
   BUS1_BRIDGE_ERR_UPPER        => \%pic_01_00214_def,
   BUS1_BRIDGE_ERR_LOWER        => \%pic_01_00215_def,
   BUS1_BRIDGE_CTRL             => \%pic_01_00216_def,
   BUS1_BRIDGE_REQ_TO           => \%pic_01_00217_def,
   BUS1_BRIDGE_INT_UPPER        => \%pic_01_00218_def,
   BUS1_BRIDGE_INT_LOWER        => \%pic_01_00219_def,
   BUS1_CMDWORD_HOLD_REG_BUS    => \%pic_01_00220_def,
   BUS1_BRIDGE_LLP_CONFIG       => \%pic_01_00221_def,
   BUS1_BRIDGE_TARG_FLUSH       => \%pic_01_00222_def,
   BUS1_CMDWORD_HOLD_REG_LINK_SIDE => \%pic_01_00223_def,
   BUS1_BRIDGE_RESP_UPPER       => \%pic_01_00224_def,
   BUS1_BRIDGE_RESP_LOWER       => \%pic_01_00225_def,
   BUS1_DEBUG_PORT_CTRL         => \%pic_01_00226_def,
   BUS1_ADDR_HOLD_REG_LINK_SIDE => \%pic_01_00227_def,
   BUS1_DIR_MAP                 => \%pic_01_00228_def,
   BUS1_MAP_FAULT_ADDR_         => \%pic_01_00229_def,
   BUS1_ARB_PRIORITY            => \%pic_01_00230_def,
   BUS1_INT_RAM_PERR            => \%pic_01_00231_def,
   BUS1_PCI_TOUT                => \%pic_01_00232_def,
   BUS1_PCI_TYPE1_CONFIG        => \%pic_01_00233_def,
   BUS1_PCI_ERR_UPPER_ADDR      => \%pic_01_00234_def,
   BUS1_PCI_ERR_LOWER_ADDR      => \%pic_01_00235_def,
   BUS1_PCI_X_ERR_ADDR          => \%pic_01_00236_def,
   BUS1_PCI_X_ERR_ATTR          => \%pic_01_00237_def,
   BUS1_PCI_X_ERR_DATA          => \%pic_01_00238_def,
   BUS1_PCI_X_PIO_SPLIT_ERR_ADDR => \%pic_01_00239_def,
   BUS1_PCI_X_PIO_SPLIT_ERR_ATTR => \%pic_01_00240_def,
   BUS1_PCI_X_DMA_ERR_ATTR      => \%pic_01_00241_def,
   BUS1_PCI_X_DMA_ERR_ADDR      => \%pic_01_00242_def,
   BUS1_PCI_X_READ_REQ_TOUT     => \%pic_01_00243_def,
   BUS1_INT_STATUS              => \%pic_01_00244_def,
   BUS1_INT_ENABLE              => \%pic_01_00245_def,
   BUS1_RESET_INT_STATUS        => \%pic_01_00246_def,
   BUS1_INT_MODE                => \%pic_01_00247_def,
   BUS1_INT_DEV                 => \%pic_01_00248_def,
   BUS1_HOST_ERR_FIELD          => \%pic_01_00249_def,
   BUS1_INT0_HOST_ADDR          => \%pic_01_00250_def,
   BUS1_INT1_HOST_ADDR          => \%pic_01_00251_def,
   BUS1_INT2_HOST_ADDR          => \%pic_01_00252_def,
   BUS1_INT3_HOST_ADDR          => \%pic_01_00253_def,
   BUS1_INT4_HOST_ADDR          => \%pic_01_00254_def,
   BUS1_INT5_HOST_ADDR          => \%pic_01_00255_def,
   BUS1_INT6_HOST_ADDR          => \%pic_01_00256_def,
   BUS1_INT7_HOST_ADDR          => \%pic_01_00257_def,
   BUS1_ERR_INT_VIEW            => \%pic_01_00258_def,
   BUS1_MULT_INT                => \%pic_01_00259_def,
   BUS1_INT0_FORCE_ALWAYS       => \%pic_01_00260_def,
   BUS1_INT1_FORCE_ALWAYS       => \%pic_01_00261_def,
   BUS1_INT2_FORCE_ALWAYS       => \%pic_01_00262_def,
   BUS1_INT3_FORCE_ALWAYS       => \%pic_01_00263_def,
   BUS1_INT4_FORCE_ALWAYS       => \%pic_01_00264_def,
   BUS1_INT5_FORCE_ALWAYS       => \%pic_01_00265_def,
   BUS1_INT6_FORCE_ALWAYS       => \%pic_01_00266_def,
   BUS1_INT7_FORCE_ALWAYS       => \%pic_01_00267_def,
   BUS1_INT0_FORCE_PIN_REG      => \%pic_01_00268_def,
   BUS1_INT1_FORCE_PIN_REG      => \%pic_01_00269_def,
   BUS1_INT2_FORCE_PIN_REG      => \%pic_01_00270_def,
   BUS1_INT3_FORCE_PIN_REG      => \%pic_01_00271_def,
   BUS1_INT4_FORCE_PIN_REG      => \%pic_01_00272_def,
   BUS1_INT5_FORCE_PIN_REG      => \%pic_01_00273_def,
   BUS1_INT6_FORCE_PIN_REG      => \%pic_01_00274_def,
   BUS1_INT7_FORCE_PIN_REG      => \%pic_01_00275_def,
   BUS1_DEV0_REG                => \%pic_01_00276_def,
   BUS1_DEV1_REG                => \%pic_01_00277_def,
   BUS1_DEV2_REG                => \%pic_01_00278_def,
   BUS1_DEV3_REG                => \%pic_01_00279_def,
   BUS1_DEV0_WR_FLUSH           => \%pic_01_00280_def,
   BUS1_DEV1_WR_FLUSH           => \%pic_01_00281_def,
   BUS1_DEV2_WR_FLUSH           => \%pic_01_00282_def,
   BUS1_DEV3_WR_FLUSH           => \%pic_01_00283_def,
   BUS1_E_DEV_RSP_BUF           => \%pic_01_00284_def,
   BUS1_O_DEV_RSP_BUF           => \%pic_01_00285_def,
   BUS1_RR_BUFF_STATUS          => \%pic_01_00286_def,
   BUS1_RR_BUFF_CLR             => \%pic_01_00287_def,
   BUS1_PCI_RD_RESP0_UPP        => \%pic_01_00288_def,
   BUS1_PCI_RD_RESP1_UPP        => \%pic_01_00289_def,
   BUS1_PCI_RD_RESP2_UPP        => \%pic_01_00290_def,
   BUS1_PCI_RD_RESP3_UPP        => \%pic_01_00291_def,
   BUS1_PCI_RD_RESP4_UPP        => \%pic_01_00292_def,
   BUS1_PCI_RD_RESP5_UPP        => \%pic_01_00293_def,
   BUS1_PCI_RD_RESP6_UPP        => \%pic_01_00294_def,
   BUS1_PCI_RD_RESP7_UPP        => \%pic_01_00295_def,
   BUS1_PCI_RD_RESP8_UPP        => \%pic_01_00296_def,
   BUS1_PCI_RD_RESP9_UPP        => \%pic_01_00297_def,
   BUS1_PCI_RD_RESP10_UPP       => \%pic_01_00298_def,
   BUS1_PCI_RD_RESP11_UPP       => \%pic_01_00299_def,
   BUS1_PCI_RD_RESP12_UPP       => \%pic_01_00300_def,
   BUS1_PCI_RD_RESP13_UPP       => \%pic_01_00301_def,
   BUS1_PCI_RD_RESP14_UPP       => \%pic_01_00302_def,
   BUS1_PCI_RD_RESP15_UPP       => \%pic_01_00303_def,
   BUS1_PCI_RD_RESP0_LOW        => \%pic_01_00304_def,
   BUS1_PCI_RD_RESP1_LOW        => \%pic_01_00305_def,
   BUS1_PCI_RD_RESP2_LOW        => \%pic_01_00306_def,
   BUS1_PCI_RD_RESP3_LOW        => \%pic_01_00307_def,
   BUS1_PCI_RD_RESP4_LOW        => \%pic_01_00308_def,
   BUS1_PCI_RD_RESP5_LOW        => \%pic_01_00309_def,
   BUS1_PCI_RD_RESP6_LOW        => \%pic_01_00310_def,
   BUS1_PCI_RD_RESP7_LOW        => \%pic_01_00311_def,
   BUS1_PCI_RD_RESP8_LOW        => \%pic_01_00312_def,
   BUS1_PCI_RD_RESP9_LOW        => \%pic_01_00313_def,
   BUS1_PCI_RD_RESP10_LOW       => \%pic_01_00314_def,
   BUS1_PCI_RD_RESP11_LOW       => \%pic_01_00315_def,
   BUS1_PCI_RD_RESP12_LOW       => \%pic_01_00316_def,
   BUS1_PCI_RD_RESP13_LOW       => \%pic_01_00317_def,
   BUS1_PCI_RD_RESP14_LOW       => \%pic_01_00318_def,
   BUS1_PCI_RD_RESP15_LOW       => \%pic_01_00319_def,
   BUS1_BUF0_FLUSH_CNT_DATA_TOUCH => \%pic_01_00320_def,
   BUS1_BUF1_FLUSH_CNT_DATA_TOUCH => \%pic_01_00321_def,
   BUS1_BUF2_FLUSH_CNT_DATA_TOUCH => \%pic_01_00322_def,
   BUS1_BUF3_FLUSH_CNT_DATA_TOUCH => \%pic_01_00323_def,
   BUS1_BUF4_FLUSH_CNT_DATA_TOUCH => \%pic_01_00324_def,
   BUS1_BUF5_FLUSH_CNT_DATA_TOUCH => \%pic_01_00325_def,
   BUS1_BUF6_FLUSH_CNT_DATA_TOUCH => \%pic_01_00326_def,
   BUS1_BUF7_FLUSH_CNT_DATA_TOUCH => \%pic_01_00327_def,
   BUS1_BUF0_FLUSH_CNT_NO_DATA_TOUCH => \%pic_01_00328_def,
   BUS1_BUF1_FLUSH_CNT_NO_DATA_TOUCH => \%pic_01_00329_def,
   BUS1_BUF2_FLUSH_CNT_NO_DATA_TOUCH => \%pic_01_00330_def,
   BUS1_BUF3_FLUSH_CNT_NO_DATA_TOUCH => \%pic_01_00331_def,
   BUS1_BUF4_FLUSH_CNT_NO_DATA_TOUCH => \%pic_01_00332_def,
   BUS1_BUF5_FLUSH_CNT_NO_DATA_TOUCH => \%pic_01_00333_def,
   BUS1_BUF6_FLUSH_CNT_NO_DATA_TOUCH => \%pic_01_00334_def,
   BUS1_BUF7_FLUSH_CNT_NO_DATA_TOUCH => \%pic_01_00335_def,
   BUS1_BUF0_REQ_FLIGHT_CNT     => \%pic_01_00336_def,
   BUS1_BUF1_REQ_FLIGHT_CNT     => \%pic_01_00337_def,
   BUS1_BUF2_REQ_FLIGHT_CNT     => \%pic_01_00338_def,
   BUS1_BUF3_REQ_FLIGHT_CNT     => \%pic_01_00339_def,
   BUS1_BUF4_REQ_FLIGHT_CNT     => \%pic_01_00340_def,
   BUS1_BUF5_REQ_FLIGHT_CNT     => \%pic_01_00341_def,
   BUS1_BUF6_REQ_FLIGHT_CNT     => \%pic_01_00342_def,
   BUS1_BUF7_REQ_FLIGHT_CNT     => \%pic_01_00343_def,
   BUS1_BUF0_PREFETCH_REQ_CNT   => \%pic_01_00344_def,
   BUS1_BUF1_PREFETCH_REQ_CNT   => \%pic_01_00345_def,
   BUS1_BUF2_PREFETCH_REQ_CNT   => \%pic_01_00346_def,
   BUS1_BUF3_PREFETCH_REQ_CNT   => \%pic_01_00347_def,
   BUS1_BUF4_PREFETCH_REQ_CNT   => \%pic_01_00348_def,
   BUS1_BUF5_PREFETCH_REQ_CNT   => \%pic_01_00349_def,
   BUS1_BUF6_PREFETCH_REQ_CNT   => \%pic_01_00350_def,
   BUS1_BUF7_PREFETCH_REQ_CNT   => \%pic_01_00351_def,
   BUS1_BUF0_TOT_PCI_RETRY_CNT  => \%pic_01_00352_def,
   BUS1_BUF1_TOT_PCI_RETRY_CNT  => \%pic_01_00353_def,
   BUS1_BUF2_TOT_PCI_RETRY_CNT  => \%pic_01_00354_def,
   BUS1_BUF3_TOT_PCI_RETRY_CNT  => \%pic_01_00355_def,
   BUS1_BUF4_TOT_PCI_RETRY_CNT  => \%pic_01_00356_def,
   BUS1_BUF5_TOT_PCI_RETRY_CNT  => \%pic_01_00357_def,
   BUS1_BUF6_TOT_PCI_RETRY_CNT  => \%pic_01_00358_def,
   BUS1_BUF7_TOT_PCI_RETRY_CNT  => \%pic_01_00359_def,
   BUS1_BUF0_MAX_PCI_RETRY_CNT  => \%pic_01_00360_def,
   BUS1_BUF1_MAX_PCI_RETRY_CNT  => \%pic_01_00361_def,
   BUS1_BUF2_MAX_PCI_RETRY_CNT  => \%pic_01_00362_def,
   BUS1_BUF3_MAX_PCI_RETRY_CNT  => \%pic_01_00363_def,
   BUS1_BUF4_MAX_PCI_RETRY_CNT  => \%pic_01_00364_def,
   BUS1_BUF5_MAX_PCI_RETRY_CNT  => \%pic_01_00365_def,
   BUS1_BUF6_MAX_PCI_RETRY_CNT  => \%pic_01_00366_def,
   BUS1_BUF7_MAX_PCI_RETRY_CNT  => \%pic_01_00367_def,
   BUS1_BUF0_MAX_LAT_CNT_REG    => \%pic_01_00368_def,
   BUS1_BUF1_MAX_LAT_CNT_REG    => \%pic_01_00369_def,
   BUS1_BUF2_MAX_LAT_CNT_REG    => \%pic_01_00370_def,
   BUS1_BUF3_MAX_LAT_CNT_REG    => \%pic_01_00371_def,
   BUS1_BUF4_MAX_LAT_CNT_REG    => \%pic_01_00372_def,
   BUS1_BUF5_MAX_LAT_CNT_REG    => \%pic_01_00373_def,
   BUS1_BUF6_MAX_LAT_CNT_REG    => \%pic_01_00374_def,
   BUS1_BUF7_MAX_LAT_CNT_REG    => \%pic_01_00375_def,
   BUS1_BUF0_MAX_LAT_CNT        => \%pic_01_00376_def,
   BUS1_BUF1_MAX_LAT_CNT        => \%pic_01_00377_def,
   BUS1_BUF2_MAX_LAT_CNT        => \%pic_01_00378_def,
   BUS1_BUF3_MAX_LAT_CNT        => \%pic_01_00379_def,
   BUS1_BUF4_MAX_LAT_CNT        => \%pic_01_00380_def,
   BUS1_BUF5_MAX_LAT_CNT        => \%pic_01_00381_def,
   BUS1_BUF6_MAX_LAT_CNT        => \%pic_01_00382_def,
   BUS1_BUF7_MAX_LAT_CNT        => \%pic_01_00383_def,
   BUS1_PCI_X_RD_BUF0_ATTR      => \%pic_01_00384_def,
   BUS1_PCI_X_RD_BUF1_ATTR      => \%pic_01_00385_def,
   BUS1_PCI_X_RD_BUF2_ATTR      => \%pic_01_00386_def,
   BUS1_PCI_X_RD_BUF3_ATTR      => \%pic_01_00387_def,
   BUS1_PCI_X_RD_BUF4_ATTR      => \%pic_01_00388_def,
   BUS1_PCI_X_RD_BUF5_ATTR      => \%pic_01_00389_def,
   BUS1_PCI_X_RD_BUF6_ATTR      => \%pic_01_00390_def,
   BUS1_PCI_X_RD_BUF7_ATTR      => \%pic_01_00391_def,
   BUS1_PCI_X_RD_BUF8_ATTR      => \%pic_01_00392_def,
   BUS1_PCI_X_RD_BUF9_ATTR      => \%pic_01_00393_def,
   BUS1_PCI_X_RD_BUF10_ATTR     => \%pic_01_00394_def,
   BUS1_PCI_X_RD_BUF11_ATTR     => \%pic_01_00395_def,
   BUS1_PCI_X_RD_BUF12_ATTR     => \%pic_01_00396_def,
   BUS1_PCI_X_RD_BUF13_ATTR     => \%pic_01_00397_def,
   BUS1_PCI_X_RD_BUF14_ATTR     => \%pic_01_00398_def,
   BUS1_PCI_X_RD_BUF15_ATTR     => \%pic_01_00399_def,
   BUS1_PCI_X_WR_BUF0_ADDR      => \%pic_01_00400_def,
   BUS1_PCI_X_WR_BUF1_ADDR      => \%pic_01_00401_def,
   BUS1_PCI_X_WR_BUF2_ADDR      => \%pic_01_00402_def,
   BUS1_PCI_X_WR_BUF3_ADDR      => \%pic_01_00403_def,
   BUS1_PCI_X_WR_BUF4_ADDR      => \%pic_01_00404_def,
   BUS1_PCI_X_WR_BUF5_ADDR      => \%pic_01_00405_def,
   BUS1_PCI_X_WR_BUF6_ADDR      => \%pic_01_00406_def,
   BUS1_PCI_X_WR_BUF7_ADDR      => \%pic_01_00407_def,
   BUS1_PCI_X_WR_BUF0_ATTR      => \%pic_01_00408_def,
   BUS1_PCI_X_WR_BUF1_ATTR      => \%pic_01_00409_def,
   BUS1_PCI_X_WR_BUF2_ATTR      => \%pic_01_00410_def,
   BUS1_PCI_X_WR_BUF3_ATTR      => \%pic_01_00411_def,
   BUS1_PCI_X_WR_BUF4_ATTR      => \%pic_01_00412_def,
   BUS1_PCI_X_WR_BUF5_ATTR      => \%pic_01_00413_def,
   BUS1_PCI_X_WR_BUF6_ATTR      => \%pic_01_00414_def,
   BUS1_PCI_X_WR_BUF7_ATTR      => \%pic_01_00415_def,
   BUS1_PCI_X_WR_BUF0_VALID     => \%pic_01_00416_def,
   BUS1_PCI_X_WR_BUF1_VALID     => \%pic_01_00417_def,
   BUS1_PCI_X_WR_BUF2_VALID     => \%pic_01_00418_def,
   BUS1_PCI_X_WR_BUF3_VALID     => \%pic_01_00419_def,
   BUS1_PCI_X_WR_BUF4_VALID     => \%pic_01_00420_def,
   BUS1_PCI_X_WR_BUF5_VALID     => \%pic_01_00421_def,
   BUS1_PCI_X_WR_BUF6_VALID     => \%pic_01_00422_def,
   BUS1_PCI_X_WR_BUF7_VALID     => \%pic_01_00423_def,
);

%pic_01_mmr_by_addr = 
(
   0x0000000000000000 => \%pic_01_00000_def,
   0x0000000000000008 => \%pic_01_00001_def,
   0x0000000000000010 => \%pic_01_00002_def,
   0x0000000000000018 => \%pic_01_00003_def,
   0x0000000000000020 => \%pic_01_00004_def,
   0x0000000000000028 => \%pic_01_00005_def,
   0x0000000000000030 => \%pic_01_00006_def,
   0x0000000000000038 => \%pic_01_00007_def,
   0x0000000000000040 => \%pic_01_00008_def,
   0x0000000000000048 => \%pic_01_00009_def,
   0x0000000000000050 => \%pic_01_00010_def,
   0x0000000000000058 => \%pic_01_00011_def,
   0x0000000000000060 => \%pic_01_00012_def,
   0x0000000000000068 => \%pic_01_00013_def,
   0x0000000000000070 => \%pic_01_00014_def,
   0x0000000000000078 => \%pic_01_00015_def,
   0x0000000000000080 => \%pic_01_00016_def,
   0x0000000000000090 => \%pic_01_00017_def,
   0x00000000000000A0 => \%pic_01_00018_def,
   0x00000000000000B0 => \%pic_01_00019_def,
   0x00000000000000C0 => \%pic_01_00020_def,
   0x00000000000000C8 => \%pic_01_00021_def,
   0x00000000000000D0 => \%pic_01_00022_def,
   0x00000000000000D8 => \%pic_01_00023_def,
   0x0000000000000600 => \%pic_01_00024_def,
   0x0000000000000608 => \%pic_01_00025_def,
   0x0000000000000610 => \%pic_01_00026_def,
   0x0000000000000618 => \%pic_01_00027_def,
   0x0000000000000620 => \%pic_01_00028_def,
   0x0000000000000628 => \%pic_01_00029_def,
   0x0000000000000630 => \%pic_01_00030_def,
   0x0000000000000638 => \%pic_01_00031_def,
   0x0000000000000100 => \%pic_01_00032_def,
   0x0000000000000108 => \%pic_01_00033_def,
   0x0000000000000110 => \%pic_01_00034_def,
   0x0000000000000118 => \%pic_01_00035_def,
   0x0000000000000120 => \%pic_01_00036_def,
   0x0000000000000128 => \%pic_01_00037_def,
   0x0000000000000130 => \%pic_01_00038_def,
   0x0000000000000138 => \%pic_01_00039_def,
   0x0000000000000140 => \%pic_01_00040_def,
   0x0000000000000148 => \%pic_01_00041_def,
   0x0000000000000150 => \%pic_01_00042_def,
   0x0000000000000158 => \%pic_01_00043_def,
   0x0000000000000160 => \%pic_01_00044_def,
   0x0000000000000168 => \%pic_01_00045_def,
   0x0000000000000170 => \%pic_01_00046_def,
   0x0000000000000178 => \%pic_01_00047_def,
   0x0000000000000180 => \%pic_01_00048_def,
   0x0000000000000188 => \%pic_01_00049_def,
   0x0000000000000190 => \%pic_01_00050_def,
   0x0000000000000198 => \%pic_01_00051_def,
   0x00000000000001A0 => \%pic_01_00052_def,
   0x00000000000001A8 => \%pic_01_00053_def,
   0x00000000000001B0 => \%pic_01_00054_def,
   0x00000000000001B8 => \%pic_01_00055_def,
   0x00000000000001C0 => \%pic_01_00056_def,
   0x00000000000001C8 => \%pic_01_00057_def,
   0x00000000000001D0 => \%pic_01_00058_def,
   0x00000000000001D8 => \%pic_01_00059_def,
   0x00000000000001E0 => \%pic_01_00060_def,
   0x00000000000001E8 => \%pic_01_00061_def,
   0x00000000000001F0 => \%pic_01_00062_def,
   0x00000000000001F8 => \%pic_01_00063_def,
   0x0000000000000200 => \%pic_01_00064_def,
   0x0000000000000208 => \%pic_01_00065_def,
   0x0000000000000210 => \%pic_01_00066_def,
   0x0000000000000218 => \%pic_01_00067_def,
   0x0000000000000240 => \%pic_01_00068_def,
   0x0000000000000248 => \%pic_01_00069_def,
   0x0000000000000250 => \%pic_01_00070_def,
   0x0000000000000258 => \%pic_01_00071_def,
   0x0000000000000280 => \%pic_01_00072_def,
   0x0000000000000288 => \%pic_01_00073_def,
   0x0000000000000290 => \%pic_01_00074_def,
   0x0000000000000298 => \%pic_01_00075_def,
   0x0000000000000300 => \%pic_01_00076_def,
   0x0000000000000310 => \%pic_01_00077_def,
   0x0000000000000320 => \%pic_01_00078_def,
   0x0000000000000330 => \%pic_01_00079_def,
   0x0000000000000340 => \%pic_01_00080_def,
   0x0000000000000350 => \%pic_01_00081_def,
   0x0000000000000360 => \%pic_01_00082_def,
   0x0000000000000370 => \%pic_01_00083_def,
   0x0000000000000380 => \%pic_01_00084_def,
   0x0000000000000390 => \%pic_01_00085_def,
   0x00000000000003A0 => \%pic_01_00086_def,
   0x00000000000003B0 => \%pic_01_00087_def,
   0x00000000000003C0 => \%pic_01_00088_def,
   0x00000000000003D0 => \%pic_01_00089_def,
   0x00000000000003E0 => \%pic_01_00090_def,
   0x00000000000003F0 => \%pic_01_00091_def,
   0x0000000000000308 => \%pic_01_00092_def,
   0x0000000000000318 => \%pic_01_00093_def,
   0x0000000000000328 => \%pic_01_00094_def,
   0x0000000000000338 => \%pic_01_00095_def,
   0x0000000000000348 => \%pic_01_00096_def,
   0x0000000000000358 => \%pic_01_00097_def,
   0x0000000000000368 => \%pic_01_00098_def,
   0x0000000000000378 => \%pic_01_00099_def,
   0x0000000000000388 => \%pic_01_00100_def,
   0x0000000000000398 => \%pic_01_00101_def,
   0x00000000000003A8 => \%pic_01_00102_def,
   0x00000000000003B8 => \%pic_01_00103_def,
   0x00000000000003C8 => \%pic_01_00104_def,
   0x00000000000003D8 => \%pic_01_00105_def,
   0x00000000000003E8 => \%pic_01_00106_def,
   0x00000000000003F8 => \%pic_01_00107_def,
   0x0000000000000400 => \%pic_01_00108_def,
   0x0000000000000440 => \%pic_01_00109_def,
   0x0000000000000480 => \%pic_01_00110_def,
   0x00000000000004C0 => \%pic_01_00111_def,
   0x0000000000000500 => \%pic_01_00112_def,
   0x0000000000000540 => \%pic_01_00113_def,
   0x0000000000000580 => \%pic_01_00114_def,
   0x00000000000005C0 => \%pic_01_00115_def,
   0x0000000000000408 => \%pic_01_00116_def,
   0x0000000000000448 => \%pic_01_00117_def,
   0x0000000000000488 => \%pic_01_00118_def,
   0x00000000000004C8 => \%pic_01_00119_def,
   0x0000000000000508 => \%pic_01_00120_def,
   0x0000000000000548 => \%pic_01_00121_def,
   0x0000000000000588 => \%pic_01_00122_def,
   0x00000000000005C8 => \%pic_01_00123_def,
   0x0000000000000410 => \%pic_01_00124_def,
   0x0000000000000450 => \%pic_01_00125_def,
   0x0000000000000490 => \%pic_01_00126_def,
   0x00000000000004D0 => \%pic_01_00127_def,
   0x0000000000000510 => \%pic_01_00128_def,
   0x0000000000000550 => \%pic_01_00129_def,
   0x0000000000000590 => \%pic_01_00130_def,
   0x00000000000005D0 => \%pic_01_00131_def,
   0x0000000000000418 => \%pic_01_00132_def,
   0x0000000000000458 => \%pic_01_00133_def,
   0x0000000000000498 => \%pic_01_00134_def,
   0x00000000000004D8 => \%pic_01_00135_def,
   0x0000000000000518 => \%pic_01_00136_def,
   0x0000000000000558 => \%pic_01_00137_def,
   0x0000000000000598 => \%pic_01_00138_def,
   0x00000000000005D8 => \%pic_01_00139_def,
   0x0000000000000420 => \%pic_01_00140_def,
   0x0000000000000460 => \%pic_01_00141_def,
   0x00000000000004A0 => \%pic_01_00142_def,
   0x00000000000004E0 => \%pic_01_00143_def,
   0x0000000000000520 => \%pic_01_00144_def,
   0x0000000000000560 => \%pic_01_00145_def,
   0x00000000000005A0 => \%pic_01_00146_def,
   0x00000000000005E0 => \%pic_01_00147_def,
   0x0000000000000428 => \%pic_01_00148_def,
   0x0000000000000468 => \%pic_01_00149_def,
   0x00000000000004A8 => \%pic_01_00150_def,
   0x00000000000004E8 => \%pic_01_00151_def,
   0x0000000000000528 => \%pic_01_00152_def,
   0x0000000000000568 => \%pic_01_00153_def,
   0x00000000000005A8 => \%pic_01_00154_def,
   0x00000000000005E8 => \%pic_01_00155_def,
   0x0000000000000430 => \%pic_01_00156_def,
   0x0000000000000470 => \%pic_01_00157_def,
   0x00000000000004B0 => \%pic_01_00158_def,
   0x00000000000004F0 => \%pic_01_00159_def,
   0x0000000000000530 => \%pic_01_00160_def,
   0x0000000000000570 => \%pic_01_00161_def,
   0x00000000000005B0 => \%pic_01_00162_def,
   0x00000000000005F0 => \%pic_01_00163_def,
   0x0000000000000438 => \%pic_01_00164_def,
   0x0000000000000478 => \%pic_01_00165_def,
   0x00000000000004B8 => \%pic_01_00166_def,
   0x00000000000004F8 => \%pic_01_00167_def,
   0x0000000000000538 => \%pic_01_00168_def,
   0x0000000000000578 => \%pic_01_00169_def,
   0x00000000000005B8 => \%pic_01_00170_def,
   0x00000000000005F8 => \%pic_01_00171_def,
   0x0000000000000A08 => \%pic_01_00172_def,
   0x0000000000000A18 => \%pic_01_00173_def,
   0x0000000000000A28 => \%pic_01_00174_def,
   0x0000000000000A38 => \%pic_01_00175_def,
   0x0000000000000A48 => \%pic_01_00176_def,
   0x0000000000000A58 => \%pic_01_00177_def,
   0x0000000000000A68 => \%pic_01_00178_def,
   0x0000000000000A78 => \%pic_01_00179_def,
   0x0000000000000A88 => \%pic_01_00180_def,
   0x0000000000000A98 => \%pic_01_00181_def,
   0x0000000000000AA8 => \%pic_01_00182_def,
   0x0000000000000AB8 => \%pic_01_00183_def,
   0x0000000000000AC8 => \%pic_01_00184_def,
   0x0000000000000AD8 => \%pic_01_00185_def,
   0x0000000000000AE8 => \%pic_01_00186_def,
   0x0000000000000AF8 => \%pic_01_00187_def,
   0x0000000000000B00 => \%pic_01_00188_def,
   0x0000000000000B20 => \%pic_01_00189_def,
   0x0000000000000B40 => \%pic_01_00190_def,
   0x0000000000000B60 => \%pic_01_00191_def,
   0x0000000000000B80 => \%pic_01_00192_def,
   0x0000000000000BA0 => \%pic_01_00193_def,
   0x0000000000000BC0 => \%pic_01_00194_def,
   0x0000000000000BE0 => \%pic_01_00195_def,
   0x0000000000000B08 => \%pic_01_00196_def,
   0x0000000000000B28 => \%pic_01_00197_def,
   0x0000000000000B48 => \%pic_01_00198_def,
   0x0000000000000B68 => \%pic_01_00199_def,
   0x0000000000000B88 => \%pic_01_00200_def,
   0x0000000000000BA8 => \%pic_01_00201_def,
   0x0000000000000BC8 => \%pic_01_00202_def,
   0x0000000000000BE8 => \%pic_01_00203_def,
   0x0000000000000B10 => \%pic_01_00204_def,
   0x0000000000000B30 => \%pic_01_00205_def,
   0x0000000000000B50 => \%pic_01_00206_def,
   0x0000000000000B70 => \%pic_01_00207_def,
   0x0000000000000B90 => \%pic_01_00208_def,
   0x0000000000000BB0 => \%pic_01_00209_def,
   0x0000000000000BD0 => \%pic_01_00210_def,
   0x0000000000000BF0 => \%pic_01_00211_def,
   0x0000000000800000 => \%pic_01_00212_def,
   0x0000000000800008 => \%pic_01_00213_def,
   0x0000000000800010 => \%pic_01_00214_def,
   0x0000000000800018 => \%pic_01_00215_def,
   0x0000000000800020 => \%pic_01_00216_def,
   0x0000000000800028 => \%pic_01_00217_def,
   0x0000000000800030 => \%pic_01_00218_def,
   0x0000000000800038 => \%pic_01_00219_def,
   0x0000000000800040 => \%pic_01_00220_def,
   0x0000000000800048 => \%pic_01_00221_def,
   0x0000000000800050 => \%pic_01_00222_def,
   0x0000000000800058 => \%pic_01_00223_def,
   0x0000000000800060 => \%pic_01_00224_def,
   0x0000000000800068 => \%pic_01_00225_def,
   0x0000000000800070 => \%pic_01_00226_def,
   0x0000000000800078 => \%pic_01_00227_def,
   0x0000000000800080 => \%pic_01_00228_def,
   0x0000000000800090 => \%pic_01_00229_def,
   0x00000000008000A0 => \%pic_01_00230_def,
   0x00000000008000B0 => \%pic_01_00231_def,
   0x00000000008000C0 => \%pic_01_00232_def,
   0x00000000008000C8 => \%pic_01_00233_def,
   0x00000000008000D0 => \%pic_01_00234_def,
   0x00000000008000D8 => \%pic_01_00235_def,
   0x0000000000800600 => \%pic_01_00236_def,
   0x0000000000800608 => \%pic_01_00237_def,
   0x0000000000800610 => \%pic_01_00238_def,
   0x0000000000800618 => \%pic_01_00239_def,
   0x0000000000800620 => \%pic_01_00240_def,
   0x0000000000800628 => \%pic_01_00241_def,
   0x0000000000800630 => \%pic_01_00242_def,
   0x0000000000800638 => \%pic_01_00243_def,
   0x0000000000800100 => \%pic_01_00244_def,
   0x0000000000800108 => \%pic_01_00245_def,
   0x0000000000800110 => \%pic_01_00246_def,
   0x0000000000800118 => \%pic_01_00247_def,
   0x0000000000800120 => \%pic_01_00248_def,
   0x0000000000800128 => \%pic_01_00249_def,
   0x0000000000800130 => \%pic_01_00250_def,
   0x0000000000800138 => \%pic_01_00251_def,
   0x0000000000800140 => \%pic_01_00252_def,
   0x0000000000800148 => \%pic_01_00253_def,
   0x0000000000800150 => \%pic_01_00254_def,
   0x0000000000800158 => \%pic_01_00255_def,
   0x0000000000800160 => \%pic_01_00256_def,
   0x0000000000800168 => \%pic_01_00257_def,
   0x0000000000800170 => \%pic_01_00258_def,
   0x0000000000800178 => \%pic_01_00259_def,
   0x0000000000800180 => \%pic_01_00260_def,
   0x0000000000800188 => \%pic_01_00261_def,
   0x0000000000800190 => \%pic_01_00262_def,
   0x0000000000800198 => \%pic_01_00263_def,
   0x00000000008001A0 => \%pic_01_00264_def,
   0x00000000008001A8 => \%pic_01_00265_def,
   0x00000000008001B0 => \%pic_01_00266_def,
   0x00000000008001B8 => \%pic_01_00267_def,
   0x00000000008001C0 => \%pic_01_00268_def,
   0x00000000008001C8 => \%pic_01_00269_def,
   0x00000000008001D0 => \%pic_01_00270_def,
   0x00000000008001D8 => \%pic_01_00271_def,
   0x00000000008001E0 => \%pic_01_00272_def,
   0x00000000008001E8 => \%pic_01_00273_def,
   0x00000000008001F0 => \%pic_01_00274_def,
   0x00000000008001F8 => \%pic_01_00275_def,
   0x0000000000800200 => \%pic_01_00276_def,
   0x0000000000800208 => \%pic_01_00277_def,
   0x0000000000800210 => \%pic_01_00278_def,
   0x0000000000800218 => \%pic_01_00279_def,
   0x0000000000800240 => \%pic_01_00280_def,
   0x0000000000800248 => \%pic_01_00281_def,
   0x0000000000800250 => \%pic_01_00282_def,
   0x0000000000800258 => \%pic_01_00283_def,
   0x0000000000800280 => \%pic_01_00284_def,
   0x0000000000800288 => \%pic_01_00285_def,
   0x0000000000800290 => \%pic_01_00286_def,
   0x0000000000800298 => \%pic_01_00287_def,
   0x0000000000800300 => \%pic_01_00288_def,
   0x0000000000800310 => \%pic_01_00289_def,
   0x0000000000800320 => \%pic_01_00290_def,
   0x0000000000800330 => \%pic_01_00291_def,
   0x0000000000800340 => \%pic_01_00292_def,
   0x0000000000800350 => \%pic_01_00293_def,
   0x0000000000800360 => \%pic_01_00294_def,
   0x0000000000800370 => \%pic_01_00295_def,
   0x0000000000800380 => \%pic_01_00296_def,
   0x0000000000800390 => \%pic_01_00297_def,
   0x00000000008003A0 => \%pic_01_00298_def,
   0x00000000008003B0 => \%pic_01_00299_def,
   0x00000000008003C0 => \%pic_01_00300_def,
   0x00000000008003D0 => \%pic_01_00301_def,
   0x00000000008003E0 => \%pic_01_00302_def,
   0x00000000008003F0 => \%pic_01_00303_def,
   0x0000000000800308 => \%pic_01_00304_def,
   0x0000000000800318 => \%pic_01_00305_def,
   0x0000000000800328 => \%pic_01_00306_def,
   0x0000000000800338 => \%pic_01_00307_def,
   0x0000000000800348 => \%pic_01_00308_def,
   0x0000000000800358 => \%pic_01_00309_def,
   0x0000000000800368 => \%pic_01_00310_def,
   0x0000000000800378 => \%pic_01_00311_def,
   0x0000000000800388 => \%pic_01_00312_def,
   0x0000000000800398 => \%pic_01_00313_def,
   0x00000000008003A8 => \%pic_01_00314_def,
   0x00000000008003B8 => \%pic_01_00315_def,
   0x00000000008003C8 => \%pic_01_00316_def,
   0x00000000008003D8 => \%pic_01_00317_def,
   0x00000000008003E8 => \%pic_01_00318_def,
   0x00000000008003F8 => \%pic_01_00319_def,
   0x0000000000800400 => \%pic_01_00320_def,
   0x0000000000800440 => \%pic_01_00321_def,
   0x0000000000800480 => \%pic_01_00322_def,
   0x00000000008004C0 => \%pic_01_00323_def,
   0x0000000000800500 => \%pic_01_00324_def,
   0x0000000000800540 => \%pic_01_00325_def,
   0x0000000000800580 => \%pic_01_00326_def,
   0x00000000008005C0 => \%pic_01_00327_def,
   0x0000000000800408 => \%pic_01_00328_def,
   0x0000000000800448 => \%pic_01_00329_def,
   0x0000000000800488 => \%pic_01_00330_def,
   0x00000000008004C8 => \%pic_01_00331_def,
   0x0000000000800508 => \%pic_01_00332_def,
   0x0000000000800548 => \%pic_01_00333_def,
   0x0000000000800588 => \%pic_01_00334_def,
   0x00000000008005C8 => \%pic_01_00335_def,
   0x0000000000800410 => \%pic_01_00336_def,
   0x0000000000800450 => \%pic_01_00337_def,
   0x0000000000800490 => \%pic_01_00338_def,
   0x00000000008004D0 => \%pic_01_00339_def,
   0x0000000000800510 => \%pic_01_00340_def,
   0x0000000000800550 => \%pic_01_00341_def,
   0x0000000000800590 => \%pic_01_00342_def,
   0x00000000008005D0 => \%pic_01_00343_def,
   0x0000000000800418 => \%pic_01_00344_def,
   0x0000000000800458 => \%pic_01_00345_def,
   0x0000000000800498 => \%pic_01_00346_def,
   0x00000000008004D8 => \%pic_01_00347_def,
   0x0000000000800518 => \%pic_01_00348_def,
   0x0000000000800558 => \%pic_01_00349_def,
   0x0000000000800598 => \%pic_01_00350_def,
   0x00000000008005D8 => \%pic_01_00351_def,
   0x0000000000800420 => \%pic_01_00352_def,
   0x0000000000800460 => \%pic_01_00353_def,
   0x00000000008004A0 => \%pic_01_00354_def,
   0x00000000008004E0 => \%pic_01_00355_def,
   0x0000000000800520 => \%pic_01_00356_def,
   0x0000000000800560 => \%pic_01_00357_def,
   0x00000000008005A0 => \%pic_01_00358_def,
   0x00000000008005E0 => \%pic_01_00359_def,
   0x0000000000800428 => \%pic_01_00360_def,
   0x0000000000800468 => \%pic_01_00361_def,
   0x00000000008004A8 => \%pic_01_00362_def,
   0x00000000008004E8 => \%pic_01_00363_def,
   0x0000000000800528 => \%pic_01_00364_def,
   0x0000000000800568 => \%pic_01_00365_def,
   0x00000000008005A8 => \%pic_01_00366_def,
   0x00000000008005E8 => \%pic_01_00367_def,
   0x0000000000800430 => \%pic_01_00368_def,
   0x0000000000800470 => \%pic_01_00369_def,
   0x00000000008004B0 => \%pic_01_00370_def,
   0x00000000008004F0 => \%pic_01_00371_def,
   0x0000000000800530 => \%pic_01_00372_def,
   0x0000000000800570 => \%pic_01_00373_def,
   0x00000000008005B0 => \%pic_01_00374_def,
   0x00000000008005F0 => \%pic_01_00375_def,
   0x0000000000800438 => \%pic_01_00376_def,
   0x0000000000800478 => \%pic_01_00377_def,
   0x00000000008004B8 => \%pic_01_00378_def,
   0x00000000008004F8 => \%pic_01_00379_def,
   0x0000000000800538 => \%pic_01_00380_def,
   0x0000000000800578 => \%pic_01_00381_def,
   0x00000000008005B8 => \%pic_01_00382_def,
   0x00000000008005F8 => \%pic_01_00383_def,
   0x0000000000800A08 => \%pic_01_00384_def,
   0x0000000000800A18 => \%pic_01_00385_def,
   0x0000000000800A28 => \%pic_01_00386_def,
   0x0000000000800A38 => \%pic_01_00387_def,
   0x0000000000800A48 => \%pic_01_00388_def,
   0x0000000000800A58 => \%pic_01_00389_def,
   0x0000000000800A68 => \%pic_01_00390_def,
   0x0000000000800A78 => \%pic_01_00391_def,
   0x0000000000800A88 => \%pic_01_00392_def,
   0x0000000000800A98 => \%pic_01_00393_def,
   0x0000000000800AA8 => \%pic_01_00394_def,
   0x0000000000800AB8 => \%pic_01_00395_def,
   0x0000000000800AC8 => \%pic_01_00396_def,
   0x0000000000800AD8 => \%pic_01_00397_def,
   0x0000000000800AE8 => \%pic_01_00398_def,
   0x0000000000800AF8 => \%pic_01_00399_def,
   0x0000000000800B00 => \%pic_01_00400_def,
   0x0000000000800B20 => \%pic_01_00401_def,
   0x0000000000800B40 => \%pic_01_00402_def,
   0x0000000000800B60 => \%pic_01_00403_def,
   0x0000000000800B80 => \%pic_01_00404_def,
   0x0000000000800BA0 => \%pic_01_00405_def,
   0x0000000000800BC0 => \%pic_01_00406_def,
   0x0000000000800BE0 => \%pic_01_00407_def,
   0x0000000000800B08 => \%pic_01_00408_def,
   0x0000000000800B28 => \%pic_01_00409_def,
   0x0000000000800B48 => \%pic_01_00410_def,
   0x0000000000800B68 => \%pic_01_00411_def,
   0x0000000000800B88 => \%pic_01_00412_def,
   0x0000000000800BA8 => \%pic_01_00413_def,
   0x0000000000800BC8 => \%pic_01_00414_def,
   0x0000000000800BE8 => \%pic_01_00415_def,
   0x0000000000800B10 => \%pic_01_00416_def,
   0x0000000000800B30 => \%pic_01_00417_def,
   0x0000000000800B50 => \%pic_01_00418_def,
   0x0000000000800B70 => \%pic_01_00419_def,
   0x0000000000800B90 => \%pic_01_00420_def,
   0x0000000000800BB0 => \%pic_01_00421_def,
   0x0000000000800BD0 => \%pic_01_00422_def,
   0x0000000000800BF0 => \%pic_01_00423_def,
);

@pic_01_sorted_mmr_name = 
(
   "BUS0_ADDR_HOLD_REG_LINK_SIDE",
   "BUS0_ARB_PRIORITY",
   "BUS0_BRIDGE_CTRL",
   "BUS0_BRIDGE_ERR_LOWER",
   "BUS0_BRIDGE_ERR_UPPER",
   "BUS0_BRIDGE_ID",
   "BUS0_BRIDGE_INT_LOWER",
   "BUS0_BRIDGE_INT_UPPER",
   "BUS0_BRIDGE_LLP_CONFIG",
   "BUS0_BRIDGE_REQ_TO",
   "BUS0_BRIDGE_RESP_LOWER",
   "BUS0_BRIDGE_RESP_UPPER",
   "BUS0_BRIDGE_STAT",
   "BUS0_BRIDGE_TARG_FLUSH",
   "BUS0_BUF0_FLUSH_CNT_DATA_TOUCH",
   "BUS0_BUF0_FLUSH_CNT_NO_DATA_TOUCH",
   "BUS0_BUF0_MAX_LAT_CNT",
   "BUS0_BUF0_MAX_LAT_CNT_REG",
   "BUS0_BUF0_MAX_PCI_RETRY_CNT",
   "BUS0_BUF0_PREFETCH_REQ_CNT",
   "BUS0_BUF0_REQ_FLIGHT_CNT",
   "BUS0_BUF0_TOT_PCI_RETRY_CNT",
   "BUS0_BUF1_FLUSH_CNT_DATA_TOUCH",
   "BUS0_BUF1_FLUSH_CNT_NO_DATA_TOUCH",
   "BUS0_BUF1_MAX_LAT_CNT",
   "BUS0_BUF1_MAX_LAT_CNT_REG",
   "BUS0_BUF1_MAX_PCI_RETRY_CNT",
   "BUS0_BUF1_PREFETCH_REQ_CNT",
   "BUS0_BUF1_REQ_FLIGHT_CNT",
   "BUS0_BUF1_TOT_PCI_RETRY_CNT",
   "BUS0_BUF2_FLUSH_CNT_DATA_TOUCH",
   "BUS0_BUF2_FLUSH_CNT_NO_DATA_TOUCH",
   "BUS0_BUF2_MAX_LAT_CNT",
   "BUS0_BUF2_MAX_LAT_CNT_REG",
   "BUS0_BUF2_MAX_PCI_RETRY_CNT",
   "BUS0_BUF2_PREFETCH_REQ_CNT",
   "BUS0_BUF2_REQ_FLIGHT_CNT",
   "BUS0_BUF2_TOT_PCI_RETRY_CNT",
   "BUS0_BUF3_FLUSH_CNT_DATA_TOUCH",
   "BUS0_BUF3_FLUSH_CNT_NO_DATA_TOUCH",
   "BUS0_BUF3_MAX_LAT_CNT",
   "BUS0_BUF3_MAX_LAT_CNT_REG",
   "BUS0_BUF3_MAX_PCI_RETRY_CNT",
   "BUS0_BUF3_PREFETCH_REQ_CNT",
   "BUS0_BUF3_REQ_FLIGHT_CNT",
   "BUS0_BUF3_TOT_PCI_RETRY_CNT",
   "BUS0_BUF4_FLUSH_CNT_DATA_TOUCH",
   "BUS0_BUF4_FLUSH_CNT_NO_DATA_TOUCH",
   "BUS0_BUF4_MAX_LAT_CNT",
   "BUS0_BUF4_MAX_LAT_CNT_REG",
   "BUS0_BUF4_MAX_PCI_RETRY_CNT",
   "BUS0_BUF4_PREFETCH_REQ_CNT",
   "BUS0_BUF4_REQ_FLIGHT_CNT",
   "BUS0_BUF4_TOT_PCI_RETRY_CNT",
   "BUS0_BUF5_FLUSH_CNT_DATA_TOUCH",
   "BUS0_BUF5_FLUSH_CNT_NO_DATA_TOUCH",
   "BUS0_BUF5_MAX_LAT_CNT",
   "BUS0_BUF5_MAX_LAT_CNT_REG",
   "BUS0_BUF5_MAX_PCI_RETRY_CNT",
   "BUS0_BUF5_PREFETCH_REQ_CNT",
   "BUS0_BUF5_REQ_FLIGHT_CNT",
   "BUS0_BUF5_TOT_PCI_RETRY_CNT",
   "BUS0_BUF6_FLUSH_CNT_DATA_TOUCH",
   "BUS0_BUF6_FLUSH_CNT_NO_DATA_TOUCH",
   "BUS0_BUF6_MAX_LAT_CNT",
   "BUS0_BUF6_MAX_LAT_CNT_REG",
   "BUS0_BUF6_MAX_PCI_RETRY_CNT",
   "BUS0_BUF6_PREFETCH_REQ_CNT",
   "BUS0_BUF6_REQ_FLIGHT_CNT",
   "BUS0_BUF6_TOT_PCI_RETRY_CNT",
   "BUS0_BUF7_FLUSH_CNT_DATA_TOUCH",
   "BUS0_BUF7_FLUSH_CNT_NO_DATA_TOUCH",
   "BUS0_BUF7_MAX_LAT_CNT",
   "BUS0_BUF7_MAX_LAT_CNT_REG",
   "BUS0_BUF7_MAX_PCI_RETRY_CNT",
   "BUS0_BUF7_PREFETCH_REQ_CNT",
   "BUS0_BUF7_REQ_FLIGHT_CNT",
   "BUS0_BUF7_TOT_PCI_RETRY_CNT",
   "BUS0_CMDWORD_HOLD_REG_BUS",
   "BUS0_CMDWORD_HOLD_REG_LINK_SIDE",
   "BUS0_DEBUG_PORT_CTRL",
   "BUS0_DEV0_REG",
   "BUS0_DEV0_WR_FLUSH",
   "BUS0_DEV1_REG",
   "BUS0_DEV1_WR_FLUSH",
   "BUS0_DEV2_REG",
   "BUS0_DEV2_WR_FLUSH",
   "BUS0_DEV3_REG",
   "BUS0_DEV3_WR_FLUSH",
   "BUS0_DIR_MAP",
   "BUS0_ERR_INT_VIEW",
   "BUS0_E_DEV_RSP_BUF",
   "BUS0_HOST_ERR_FIELD",
   "BUS0_INT0_FORCE_ALWAYS",
   "BUS0_INT0_FORCE_PIN_REG",
   "BUS0_INT0_HOST_ADDR",
   "BUS0_INT1_FORCE_ALWAYS",
   "BUS0_INT1_FORCE_PIN_REG",
   "BUS0_INT1_HOST_ADDR",
   "BUS0_INT2_FORCE_ALWAYS",
   "BUS0_INT2_FORCE_PIN_REG",
   "BUS0_INT2_HOST_ADDR",
   "BUS0_INT3_FORCE_ALWAYS",
   "BUS0_INT3_FORCE_PIN_REG",
   "BUS0_INT3_HOST_ADDR",
   "BUS0_INT4_FORCE_ALWAYS",
   "BUS0_INT4_FORCE_PIN_REG",
   "BUS0_INT4_HOST_ADDR",
   "BUS0_INT5_FORCE_ALWAYS",
   "BUS0_INT5_FORCE_PIN_REG",
   "BUS0_INT5_HOST_ADDR",
   "BUS0_INT6_FORCE_ALWAYS",
   "BUS0_INT6_FORCE_PIN_REG",
   "BUS0_INT6_HOST_ADDR",
   "BUS0_INT7_FORCE_ALWAYS",
   "BUS0_INT7_FORCE_PIN_REG",
   "BUS0_INT7_HOST_ADDR",
   "BUS0_INT_DEV",
   "BUS0_INT_ENABLE",
   "BUS0_INT_MODE",
   "BUS0_INT_RAM_PERR",
   "BUS0_INT_STATUS",
   "BUS0_MAP_FAULT_ADDR_",
   "BUS0_MULT_INT",
   "BUS0_O_DEV_RSP_BUF",
   "BUS0_PCI_ERR_LOWER_ADDR",
   "BUS0_PCI_ERR_UPPER_ADDR",
   "BUS0_PCI_RD_RESP0_LOW",
   "BUS0_PCI_RD_RESP0_UPP",
   "BUS0_PCI_RD_RESP10_LOW",
   "BUS0_PCI_RD_RESP10_UPP",
   "BUS0_PCI_RD_RESP11_LOW",
   "BUS0_PCI_RD_RESP11_UPP",
   "BUS0_PCI_RD_RESP12_LOW",
   "BUS0_PCI_RD_RESP12_UPP",
   "BUS0_PCI_RD_RESP13_LOW",
   "BUS0_PCI_RD_RESP13_UPP",
   "BUS0_PCI_RD_RESP14_LOW",
   "BUS0_PCI_RD_RESP14_UPP",
   "BUS0_PCI_RD_RESP15_LOW",
   "BUS0_PCI_RD_RESP15_UPP",
   "BUS0_PCI_RD_RESP1_LOW",
   "BUS0_PCI_RD_RESP1_UPP",
   "BUS0_PCI_RD_RESP2_LOW",
   "BUS0_PCI_RD_RESP2_UPP",
   "BUS0_PCI_RD_RESP3_LOW",
   "BUS0_PCI_RD_RESP3_UPP",
   "BUS0_PCI_RD_RESP4_LOW",
   "BUS0_PCI_RD_RESP4_UPP",
   "BUS0_PCI_RD_RESP5_LOW",
   "BUS0_PCI_RD_RESP5_UPP",
   "BUS0_PCI_RD_RESP6_LOW",
   "BUS0_PCI_RD_RESP6_UPP",
   "BUS0_PCI_RD_RESP7_LOW",
   "BUS0_PCI_RD_RESP7_UPP",
   "BUS0_PCI_RD_RESP8_LOW",
   "BUS0_PCI_RD_RESP8_UPP",
   "BUS0_PCI_RD_RESP9_LOW",
   "BUS0_PCI_RD_RESP9_UPP",
   "BUS0_PCI_TOUT",
   "BUS0_PCI_TYPE1_CONFIG",
   "BUS0_PCI_X_DMA_ERR_ADDR",
   "BUS0_PCI_X_DMA_ERR_ATTR",
   "BUS0_PCI_X_ERR_ADDR",
   "BUS0_PCI_X_ERR_ATTR",
   "BUS0_PCI_X_ERR_DATA",
   "BUS0_PCI_X_PIO_SPLIT_ERR_ADDR",
   "BUS0_PCI_X_PIO_SPLIT_ERR_ATTR",
   "BUS0_PCI_X_RD_BUF0_ATTR",
   "BUS0_PCI_X_RD_BUF10_ATTR",
   "BUS0_PCI_X_RD_BUF11_ATTR",
   "BUS0_PCI_X_RD_BUF12_ATTR",
   "BUS0_PCI_X_RD_BUF13_ATTR",
   "BUS0_PCI_X_RD_BUF14_ATTR",
   "BUS0_PCI_X_RD_BUF15_ATTR",
   "BUS0_PCI_X_RD_BUF1_ATTR",
   "BUS0_PCI_X_RD_BUF2_ATTR",
   "BUS0_PCI_X_RD_BUF3_ATTR",
   "BUS0_PCI_X_RD_BUF4_ATTR",
   "BUS0_PCI_X_RD_BUF5_ATTR",
   "BUS0_PCI_X_RD_BUF6_ATTR",
   "BUS0_PCI_X_RD_BUF7_ATTR",
   "BUS0_PCI_X_RD_BUF8_ATTR",
   "BUS0_PCI_X_RD_BUF9_ATTR",
   "BUS0_PCI_X_READ_REQ_TOUT",
   "BUS0_PCI_X_WR_BUF0_ADDR",
   "BUS0_PCI_X_WR_BUF0_ATTR",
   "BUS0_PCI_X_WR_BUF0_VALID",
   "BUS0_PCI_X_WR_BUF1_ADDR",
   "BUS0_PCI_X_WR_BUF1_ATTR",
   "BUS0_PCI_X_WR_BUF1_VALID",
   "BUS0_PCI_X_WR_BUF2_ADDR",
   "BUS0_PCI_X_WR_BUF2_ATTR",
   "BUS0_PCI_X_WR_BUF2_VALID",
   "BUS0_PCI_X_WR_BUF3_ADDR",
   "BUS0_PCI_X_WR_BUF3_ATTR",
   "BUS0_PCI_X_WR_BUF3_VALID",
   "BUS0_PCI_X_WR_BUF4_ADDR",
   "BUS0_PCI_X_WR_BUF4_ATTR",
   "BUS0_PCI_X_WR_BUF4_VALID",
   "BUS0_PCI_X_WR_BUF5_ADDR",
   "BUS0_PCI_X_WR_BUF5_ATTR",
   "BUS0_PCI_X_WR_BUF5_VALID",
   "BUS0_PCI_X_WR_BUF6_ADDR",
   "BUS0_PCI_X_WR_BUF6_ATTR",
   "BUS0_PCI_X_WR_BUF6_VALID",
   "BUS0_PCI_X_WR_BUF7_ADDR",
   "BUS0_PCI_X_WR_BUF7_ATTR",
   "BUS0_PCI_X_WR_BUF7_VALID",
   "BUS0_RESET_INT_STATUS",
   "BUS0_RR_BUFF_CLR",
   "BUS0_RR_BUFF_STATUS",
   "BUS1_ADDR_HOLD_REG_LINK_SIDE",
   "BUS1_ARB_PRIORITY",
   "BUS1_BRIDGE_CTRL",
   "BUS1_BRIDGE_ERR_LOWER",
   "BUS1_BRIDGE_ERR_UPPER",
   "BUS1_BRIDGE_ID",
   "BUS1_BRIDGE_INT_LOWER",
   "BUS1_BRIDGE_INT_UPPER",
   "BUS1_BRIDGE_LLP_CONFIG",
   "BUS1_BRIDGE_REQ_TO",
   "BUS1_BRIDGE_RESP_LOWER",
   "BUS1_BRIDGE_RESP_UPPER",
   "BUS1_BRIDGE_STAT",
   "BUS1_BRIDGE_TARG_FLUSH",
   "BUS1_BUF0_FLUSH_CNT_DATA_TOUCH",
   "BUS1_BUF0_FLUSH_CNT_NO_DATA_TOUCH",
   "BUS1_BUF0_MAX_LAT_CNT",
   "BUS1_BUF0_MAX_LAT_CNT_REG",
   "BUS1_BUF0_MAX_PCI_RETRY_CNT",
   "BUS1_BUF0_PREFETCH_REQ_CNT",
   "BUS1_BUF0_REQ_FLIGHT_CNT",
   "BUS1_BUF0_TOT_PCI_RETRY_CNT",
   "BUS1_BUF1_FLUSH_CNT_DATA_TOUCH",
   "BUS1_BUF1_FLUSH_CNT_NO_DATA_TOUCH",
   "BUS1_BUF1_MAX_LAT_CNT",
   "BUS1_BUF1_MAX_LAT_CNT_REG",
   "BUS1_BUF1_MAX_PCI_RETRY_CNT",
   "BUS1_BUF1_PREFETCH_REQ_CNT",
   "BUS1_BUF1_REQ_FLIGHT_CNT",
   "BUS1_BUF1_TOT_PCI_RETRY_CNT",
   "BUS1_BUF2_FLUSH_CNT_DATA_TOUCH",
   "BUS1_BUF2_FLUSH_CNT_NO_DATA_TOUCH",
   "BUS1_BUF2_MAX_LAT_CNT",
   "BUS1_BUF2_MAX_LAT_CNT_REG",
   "BUS1_BUF2_MAX_PCI_RETRY_CNT",
   "BUS1_BUF2_PREFETCH_REQ_CNT",
   "BUS1_BUF2_REQ_FLIGHT_CNT",
   "BUS1_BUF2_TOT_PCI_RETRY_CNT",
   "BUS1_BUF3_FLUSH_CNT_DATA_TOUCH",
   "BUS1_BUF3_FLUSH_CNT_NO_DATA_TOUCH",
   "BUS1_BUF3_MAX_LAT_CNT",
   "BUS1_BUF3_MAX_LAT_CNT_REG",
   "BUS1_BUF3_MAX_PCI_RETRY_CNT",
   "BUS1_BUF3_PREFETCH_REQ_CNT",
   "BUS1_BUF3_REQ_FLIGHT_CNT",
   "BUS1_BUF3_TOT_PCI_RETRY_CNT",
   "BUS1_BUF4_FLUSH_CNT_DATA_TOUCH",
   "BUS1_BUF4_FLUSH_CNT_NO_DATA_TOUCH",
   "BUS1_BUF4_MAX_LAT_CNT",
   "BUS1_BUF4_MAX_LAT_CNT_REG",
   "BUS1_BUF4_MAX_PCI_RETRY_CNT",
   "BUS1_BUF4_PREFETCH_REQ_CNT",
   "BUS1_BUF4_REQ_FLIGHT_CNT",
   "BUS1_BUF4_TOT_PCI_RETRY_CNT",
   "BUS1_BUF5_FLUSH_CNT_DATA_TOUCH",
   "BUS1_BUF5_FLUSH_CNT_NO_DATA_TOUCH",
   "BUS1_BUF5_MAX_LAT_CNT",
   "BUS1_BUF5_MAX_LAT_CNT_REG",
   "BUS1_BUF5_MAX_PCI_RETRY_CNT",
   "BUS1_BUF5_PREFETCH_REQ_CNT",
   "BUS1_BUF5_REQ_FLIGHT_CNT",
   "BUS1_BUF5_TOT_PCI_RETRY_CNT",
   "BUS1_BUF6_FLUSH_CNT_DATA_TOUCH",
   "BUS1_BUF6_FLUSH_CNT_NO_DATA_TOUCH",
   "BUS1_BUF6_MAX_LAT_CNT",
   "BUS1_BUF6_MAX_LAT_CNT_REG",
   "BUS1_BUF6_MAX_PCI_RETRY_CNT",
   "BUS1_BUF6_PREFETCH_REQ_CNT",
   "BUS1_BUF6_REQ_FLIGHT_CNT",
   "BUS1_BUF6_TOT_PCI_RETRY_CNT",
   "BUS1_BUF7_FLUSH_CNT_DATA_TOUCH",
   "BUS1_BUF7_FLUSH_CNT_NO_DATA_TOUCH",
   "BUS1_BUF7_MAX_LAT_CNT",
   "BUS1_BUF7_MAX_LAT_CNT_REG",
   "BUS1_BUF7_MAX_PCI_RETRY_CNT",
   "BUS1_BUF7_PREFETCH_REQ_CNT",
   "BUS1_BUF7_REQ_FLIGHT_CNT",
   "BUS1_BUF7_TOT_PCI_RETRY_CNT",
   "BUS1_CMDWORD_HOLD_REG_BUS",
   "BUS1_CMDWORD_HOLD_REG_LINK_SIDE",
   "BUS1_DEBUG_PORT_CTRL",
   "BUS1_DEV0_REG",
   "BUS1_DEV0_WR_FLUSH",
   "BUS1_DEV1_REG",
   "BUS1_DEV1_WR_FLUSH",
   "BUS1_DEV2_REG",
   "BUS1_DEV2_WR_FLUSH",
   "BUS1_DEV3_REG",
   "BUS1_DEV3_WR_FLUSH",
   "BUS1_DIR_MAP",
   "BUS1_ERR_INT_VIEW",
   "BUS1_E_DEV_RSP_BUF",
   "BUS1_HOST_ERR_FIELD",
   "BUS1_INT0_FORCE_ALWAYS",
   "BUS1_INT0_FORCE_PIN_REG",
   "BUS1_INT0_HOST_ADDR",
   "BUS1_INT1_FORCE_ALWAYS",
   "BUS1_INT1_FORCE_PIN_REG",
   "BUS1_INT1_HOST_ADDR",
   "BUS1_INT2_FORCE_ALWAYS",
   "BUS1_INT2_FORCE_PIN_REG",
   "BUS1_INT2_HOST_ADDR",
   "BUS1_INT3_FORCE_ALWAYS",
   "BUS1_INT3_FORCE_PIN_REG",
   "BUS1_INT3_HOST_ADDR",
   "BUS1_INT4_FORCE_ALWAYS",
   "BUS1_INT4_FORCE_PIN_REG",
   "BUS1_INT4_HOST_ADDR",
   "BUS1_INT5_FORCE_ALWAYS",
   "BUS1_INT5_FORCE_PIN_REG",
   "BUS1_INT5_HOST_ADDR",
   "BUS1_INT6_FORCE_ALWAYS",
   "BUS1_INT6_FORCE_PIN_REG",
   "BUS1_INT6_HOST_ADDR",
   "BUS1_INT7_FORCE_ALWAYS",
   "BUS1_INT7_FORCE_PIN_REG",
   "BUS1_INT7_HOST_ADDR",
   "BUS1_INT_DEV",
   "BUS1_INT_ENABLE",
   "BUS1_INT_MODE",
   "BUS1_INT_RAM_PERR",
   "BUS1_INT_STATUS",
   "BUS1_MAP_FAULT_ADDR_",
   "BUS1_MULT_INT",
   "BUS1_O_DEV_RSP_BUF",
   "BUS1_PCI_ERR_LOWER_ADDR",
   "BUS1_PCI_ERR_UPPER_ADDR",
   "BUS1_PCI_RD_RESP0_LOW",
   "BUS1_PCI_RD_RESP0_UPP",
   "BUS1_PCI_RD_RESP10_LOW",
   "BUS1_PCI_RD_RESP10_UPP",
   "BUS1_PCI_RD_RESP11_LOW",
   "BUS1_PCI_RD_RESP11_UPP",
   "BUS1_PCI_RD_RESP12_LOW",
   "BUS1_PCI_RD_RESP12_UPP",
   "BUS1_PCI_RD_RESP13_LOW",
   "BUS1_PCI_RD_RESP13_UPP",
   "BUS1_PCI_RD_RESP14_LOW",
   "BUS1_PCI_RD_RESP14_UPP",
   "BUS1_PCI_RD_RESP15_LOW",
   "BUS1_PCI_RD_RESP15_UPP",
   "BUS1_PCI_RD_RESP1_LOW",
   "BUS1_PCI_RD_RESP1_UPP",
   "BUS1_PCI_RD_RESP2_LOW",
   "BUS1_PCI_RD_RESP2_UPP",
   "BUS1_PCI_RD_RESP3_LOW",
   "BUS1_PCI_RD_RESP3_UPP",
   "BUS1_PCI_RD_RESP4_LOW",
   "BUS1_PCI_RD_RESP4_UPP",
   "BUS1_PCI_RD_RESP5_LOW",
   "BUS1_PCI_RD_RESP5_UPP",
   "BUS1_PCI_RD_RESP6_LOW",
   "BUS1_PCI_RD_RESP6_UPP",
   "BUS1_PCI_RD_RESP7_LOW",
   "BUS1_PCI_RD_RESP7_UPP",
   "BUS1_PCI_RD_RESP8_LOW",
   "BUS1_PCI_RD_RESP8_UPP",
   "BUS1_PCI_RD_RESP9_LOW",
   "BUS1_PCI_RD_RESP9_UPP",
   "BUS1_PCI_TOUT",
   "BUS1_PCI_TYPE1_CONFIG",
   "BUS1_PCI_X_DMA_ERR_ADDR",
   "BUS1_PCI_X_DMA_ERR_ATTR",
   "BUS1_PCI_X_ERR_ADDR",
   "BUS1_PCI_X_ERR_ATTR",
   "BUS1_PCI_X_ERR_DATA",
   "BUS1_PCI_X_PIO_SPLIT_ERR_ADDR",
   "BUS1_PCI_X_PIO_SPLIT_ERR_ATTR",
   "BUS1_PCI_X_RD_BUF0_ATTR",
   "BUS1_PCI_X_RD_BUF10_ATTR",
   "BUS1_PCI_X_RD_BUF11_ATTR",
   "BUS1_PCI_X_RD_BUF12_ATTR",
   "BUS1_PCI_X_RD_BUF13_ATTR",
   "BUS1_PCI_X_RD_BUF14_ATTR",
   "BUS1_PCI_X_RD_BUF15_ATTR",
   "BUS1_PCI_X_RD_BUF1_ATTR",
   "BUS1_PCI_X_RD_BUF2_ATTR",
   "BUS1_PCI_X_RD_BUF3_ATTR",
   "BUS1_PCI_X_RD_BUF4_ATTR",
   "BUS1_PCI_X_RD_BUF5_ATTR",
   "BUS1_PCI_X_RD_BUF6_ATTR",
   "BUS1_PCI_X_RD_BUF7_ATTR",
   "BUS1_PCI_X_RD_BUF8_ATTR",
   "BUS1_PCI_X_RD_BUF9_ATTR",
   "BUS1_PCI_X_READ_REQ_TOUT",
   "BUS1_PCI_X_WR_BUF0_ADDR",
   "BUS1_PCI_X_WR_BUF0_ATTR",
   "BUS1_PCI_X_WR_BUF0_VALID",
   "BUS1_PCI_X_WR_BUF1_ADDR",
   "BUS1_PCI_X_WR_BUF1_ATTR",
   "BUS1_PCI_X_WR_BUF1_VALID",
   "BUS1_PCI_X_WR_BUF2_ADDR",
   "BUS1_PCI_X_WR_BUF2_ATTR",
   "BUS1_PCI_X_WR_BUF2_VALID",
   "BUS1_PCI_X_WR_BUF3_ADDR",
   "BUS1_PCI_X_WR_BUF3_ATTR",
   "BUS1_PCI_X_WR_BUF3_VALID",
   "BUS1_PCI_X_WR_BUF4_ADDR",
   "BUS1_PCI_X_WR_BUF4_ATTR",
   "BUS1_PCI_X_WR_BUF4_VALID",
   "BUS1_PCI_X_WR_BUF5_ADDR",
   "BUS1_PCI_X_WR_BUF5_ATTR",
   "BUS1_PCI_X_WR_BUF5_VALID",
   "BUS1_PCI_X_WR_BUF6_ADDR",
   "BUS1_PCI_X_WR_BUF6_ATTR",
   "BUS1_PCI_X_WR_BUF6_VALID",
   "BUS1_PCI_X_WR_BUF7_ADDR",
   "BUS1_PCI_X_WR_BUF7_ATTR",
   "BUS1_PCI_X_WR_BUF7_VALID",
   "BUS1_RESET_INT_STATUS",
   "BUS1_RR_BUFF_CLR",
   "BUS1_RR_BUFF_STATUS",
);

@pic_01_sorted_mmr_addr = 
(
   0x0000000000000000,
   0x0000000000000008,
   0x0000000000000010,
   0x0000000000000018,
   0x0000000000000020,
   0x0000000000000028,
   0x0000000000000030,
   0x0000000000000038,
   0x0000000000000040,
   0x0000000000000048,
   0x0000000000000050,
   0x0000000000000058,
   0x0000000000000060,
   0x0000000000000068,
   0x0000000000000070,
   0x0000000000000078,
   0x0000000000000080,
   0x0000000000000090,
   0x00000000000000A0,
   0x00000000000000B0,
   0x00000000000000C0,
   0x00000000000000C8,
   0x00000000000000D0,
   0x00000000000000D8,
   0x0000000000000100,
   0x0000000000000108,
   0x0000000000000110,
   0x0000000000000118,
   0x0000000000000120,
   0x0000000000000128,
   0x0000000000000130,
   0x0000000000000138,
   0x0000000000000140,
   0x0000000000000148,
   0x0000000000000150,
   0x0000000000000158,
   0x0000000000000160,
   0x0000000000000168,
   0x0000000000000170,
   0x0000000000000178,
   0x0000000000000180,
   0x0000000000000188,
   0x0000000000000190,
   0x0000000000000198,
   0x00000000000001A0,
   0x00000000000001A8,
   0x00000000000001B0,
   0x00000000000001B8,
   0x00000000000001C0,
   0x00000000000001C8,
   0x00000000000001D0,
   0x00000000000001D8,
   0x00000000000001E0,
   0x00000000000001E8,
   0x00000000000001F0,
   0x00000000000001F8,
   0x0000000000000200,
   0x0000000000000208,
   0x0000000000000210,
   0x0000000000000218,
   0x0000000000000240,
   0x0000000000000248,
   0x0000000000000250,
   0x0000000000000258,
   0x0000000000000280,
   0x0000000000000288,
   0x0000000000000290,
   0x0000000000000298,
   0x0000000000000300,
   0x0000000000000308,
   0x0000000000000310,
   0x0000000000000318,
   0x0000000000000320,
   0x0000000000000328,
   0x0000000000000330,
   0x0000000000000338,
   0x0000000000000340,
   0x0000000000000348,
   0x0000000000000350,
   0x0000000000000358,
   0x0000000000000360,
   0x0000000000000368,
   0x0000000000000370,
   0x0000000000000378,
   0x0000000000000380,
   0x0000000000000388,
   0x0000000000000390,
   0x0000000000000398,
   0x00000000000003A0,
   0x00000000000003A8,
   0x00000000000003B0,
   0x00000000000003B8,
   0x00000000000003C0,
   0x00000000000003C8,
   0x00000000000003D0,
   0x00000000000003D8,
   0x00000000000003E0,
   0x00000000000003E8,
   0x00000000000003F0,
   0x00000000000003F8,
   0x0000000000000400,
   0x0000000000000408,
   0x0000000000000410,
   0x0000000000000418,
   0x0000000000000420,
   0x0000000000000428,
   0x0000000000000430,
   0x0000000000000438,
   0x0000000000000440,
   0x0000000000000448,
   0x0000000000000450,
   0x0000000000000458,
   0x0000000000000460,
   0x0000000000000468,
   0x0000000000000470,
   0x0000000000000478,
   0x0000000000000480,
   0x0000000000000488,
   0x0000000000000490,
   0x0000000000000498,
   0x00000000000004A0,
   0x00000000000004A8,
   0x00000000000004B0,
   0x00000000000004B8,
   0x00000000000004C0,
   0x00000000000004C8,
   0x00000000000004D0,
   0x00000000000004D8,
   0x00000000000004E0,
   0x00000000000004E8,
   0x00000000000004F0,
   0x00000000000004F8,
   0x0000000000000500,
   0x0000000000000508,
   0x0000000000000510,
   0x0000000000000518,
   0x0000000000000520,
   0x0000000000000528,
   0x0000000000000530,
   0x0000000000000538,
   0x0000000000000540,
   0x0000000000000548,
   0x0000000000000550,
   0x0000000000000558,
   0x0000000000000560,
   0x0000000000000568,
   0x0000000000000570,
   0x0000000000000578,
   0x0000000000000580,
   0x0000000000000588,
   0x0000000000000590,
   0x0000000000000598,
   0x00000000000005A0,
   0x00000000000005A8,
   0x00000000000005B0,
   0x00000000000005B8,
   0x00000000000005C0,
   0x00000000000005C8,
   0x00000000000005D0,
   0x00000000000005D8,
   0x00000000000005E0,
   0x00000000000005E8,
   0x00000000000005F0,
   0x00000000000005F8,
   0x0000000000000600,
   0x0000000000000608,
   0x0000000000000610,
   0x0000000000000618,
   0x0000000000000620,
   0x0000000000000628,
   0x0000000000000630,
   0x0000000000000638,
   0x0000000000000A08,
   0x0000000000000A18,
   0x0000000000000A28,
   0x0000000000000A38,
   0x0000000000000A48,
   0x0000000000000A58,
   0x0000000000000A68,
   0x0000000000000A78,
   0x0000000000000A88,
   0x0000000000000A98,
   0x0000000000000AA8,
   0x0000000000000AB8,
   0x0000000000000AC8,
   0x0000000000000AD8,
   0x0000000000000AE8,
   0x0000000000000AF8,
   0x0000000000000B00,
   0x0000000000000B08,
   0x0000000000000B10,
   0x0000000000000B20,
   0x0000000000000B28,
   0x0000000000000B30,
   0x0000000000000B40,
   0x0000000000000B48,
   0x0000000000000B50,
   0x0000000000000B60,
   0x0000000000000B68,
   0x0000000000000B70,
   0x0000000000000B80,
   0x0000000000000B88,
   0x0000000000000B90,
   0x0000000000000BA0,
   0x0000000000000BA8,
   0x0000000000000BB0,
   0x0000000000000BC0,
   0x0000000000000BC8,
   0x0000000000000BD0,
   0x0000000000000BE0,
   0x0000000000000BE8,
   0x0000000000000BF0,
   0x0000000000800000,
   0x0000000000800008,
   0x0000000000800010,
   0x0000000000800018,
   0x0000000000800020,
   0x0000000000800028,
   0x0000000000800030,
   0x0000000000800038,
   0x0000000000800040,
   0x0000000000800048,
   0x0000000000800050,
   0x0000000000800058,
   0x0000000000800060,
   0x0000000000800068,
   0x0000000000800070,
   0x0000000000800078,
   0x0000000000800080,
   0x0000000000800090,
   0x00000000008000A0,
   0x00000000008000B0,
   0x00000000008000C0,
   0x00000000008000C8,
   0x00000000008000D0,
   0x00000000008000D8,
   0x0000000000800100,
   0x0000000000800108,
   0x0000000000800110,
   0x0000000000800118,
   0x0000000000800120,
   0x0000000000800128,
   0x0000000000800130,
   0x0000000000800138,
   0x0000000000800140,
   0x0000000000800148,
   0x0000000000800150,
   0x0000000000800158,
   0x0000000000800160,
   0x0000000000800168,
   0x0000000000800170,
   0x0000000000800178,
   0x0000000000800180,
   0x0000000000800188,
   0x0000000000800190,
   0x0000000000800198,
   0x00000000008001A0,
   0x00000000008001A8,
   0x00000000008001B0,
   0x00000000008001B8,
   0x00000000008001C0,
   0x00000000008001C8,
   0x00000000008001D0,
   0x00000000008001D8,
   0x00000000008001E0,
   0x00000000008001E8,
   0x00000000008001F0,
   0x00000000008001F8,
   0x0000000000800200,
   0x0000000000800208,
   0x0000000000800210,
   0x0000000000800218,
   0x0000000000800240,
   0x0000000000800248,
   0x0000000000800250,
   0x0000000000800258,
   0x0000000000800280,
   0x0000000000800288,
   0x0000000000800290,
   0x0000000000800298,
   0x0000000000800300,
   0x0000000000800308,
   0x0000000000800310,
   0x0000000000800318,
   0x0000000000800320,
   0x0000000000800328,
   0x0000000000800330,
   0x0000000000800338,
   0x0000000000800340,
   0x0000000000800348,
   0x0000000000800350,
   0x0000000000800358,
   0x0000000000800360,
   0x0000000000800368,
   0x0000000000800370,
   0x0000000000800378,
   0x0000000000800380,
   0x0000000000800388,
   0x0000000000800390,
   0x0000000000800398,
   0x00000000008003A0,
   0x00000000008003A8,
   0x00000000008003B0,
   0x00000000008003B8,
   0x00000000008003C0,
   0x00000000008003C8,
   0x00000000008003D0,
   0x00000000008003D8,
   0x00000000008003E0,
   0x00000000008003E8,
   0x00000000008003F0,
   0x00000000008003F8,
   0x0000000000800400,
   0x0000000000800408,
   0x0000000000800410,
   0x0000000000800418,
   0x0000000000800420,
   0x0000000000800428,
   0x0000000000800430,
   0x0000000000800438,
   0x0000000000800440,
   0x0000000000800448,
   0x0000000000800450,
   0x0000000000800458,
   0x0000000000800460,
   0x0000000000800468,
   0x0000000000800470,
   0x0000000000800478,
   0x0000000000800480,
   0x0000000000800488,
   0x0000000000800490,
   0x0000000000800498,
   0x00000000008004A0,
   0x00000000008004A8,
   0x00000000008004B0,
   0x00000000008004B8,
   0x00000000008004C0,
   0x00000000008004C8,
   0x00000000008004D0,
   0x00000000008004D8,
   0x00000000008004E0,
   0x00000000008004E8,
   0x00000000008004F0,
   0x00000000008004F8,
   0x0000000000800500,
   0x0000000000800508,
   0x0000000000800510,
   0x0000000000800518,
   0x0000000000800520,
   0x0000000000800528,
   0x0000000000800530,
   0x0000000000800538,
   0x0000000000800540,
   0x0000000000800548,
   0x0000000000800550,
   0x0000000000800558,
   0x0000000000800560,
   0x0000000000800568,
   0x0000000000800570,
   0x0000000000800578,
   0x0000000000800580,
   0x0000000000800588,
   0x0000000000800590,
   0x0000000000800598,
   0x00000000008005A0,
   0x00000000008005A8,
   0x00000000008005B0,
   0x00000000008005B8,
   0x00000000008005C0,
   0x00000000008005C8,
   0x00000000008005D0,
   0x00000000008005D8,
   0x00000000008005E0,
   0x00000000008005E8,
   0x00000000008005F0,
   0x00000000008005F8,
   0x0000000000800600,
   0x0000000000800608,
   0x0000000000800610,
   0x0000000000800618,
   0x0000000000800620,
   0x0000000000800628,
   0x0000000000800630,
   0x0000000000800638,
   0x0000000000800A08,
   0x0000000000800A18,
   0x0000000000800A28,
   0x0000000000800A38,
   0x0000000000800A48,
   0x0000000000800A58,
   0x0000000000800A68,
   0x0000000000800A78,
   0x0000000000800A88,
   0x0000000000800A98,
   0x0000000000800AA8,
   0x0000000000800AB8,
   0x0000000000800AC8,
   0x0000000000800AD8,
   0x0000000000800AE8,
   0x0000000000800AF8,
   0x0000000000800B00,
   0x0000000000800B08,
   0x0000000000800B10,
   0x0000000000800B20,
   0x0000000000800B28,
   0x0000000000800B30,
   0x0000000000800B40,
   0x0000000000800B48,
   0x0000000000800B50,
   0x0000000000800B60,
   0x0000000000800B68,
   0x0000000000800B70,
   0x0000000000800B80,
   0x0000000000800B88,
   0x0000000000800B90,
   0x0000000000800BA0,
   0x0000000000800BA8,
   0x0000000000800BB0,
   0x0000000000800BC0,
   0x0000000000800BC8,
   0x0000000000800BD0,
   0x0000000000800BE0,
   0x0000000000800BE8,
   0x0000000000800BF0,
);


##########################################################################
#                                                                        #
#   REGISTER SEARCH SUBROUTINES (BY NAME OR ADDRESS)                     #
#                                                                        #
##########################################################################

sub pic_01_mmr_search_name
{  my $rptr = 0;
   return($rptr) if ( $#_ != 0 );
   $rptr = $pic_01_mmr_by_name{$_[0]} if ( exists $pic_01_mmr_by_name{$_[0]} );
   return($rptr);
}

sub pic_01_mmr_search_addr
{  my $rptr = 0;
   return($rptr) if ( $#_ != 0 );
   $rptr = $pic_01_mmr_by_addr{$_[0]} if ( exists $pic_01_mmr_by_addr{$_[0]} );
   return($rptr);
}

1;
