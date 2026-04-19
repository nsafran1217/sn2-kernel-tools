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
# @(#)$Id: ii_regs.pm,v 1.27 2007/01/24 16:59:57 meyer Exp $
#-------------------------------------------------------------------------------
#
#  FILE: ii_regs.pm
#
#  DESCRIPTION:  This file contains PERL routines to read II chiplet registers.
#
#  MODIFICATION HISTORY:
#
#     WHEN      WHO             WHAT
#     --------  --------------  -----------------------------------------
#     01/08/03  Gary Meyer      Original source code submitted for release.
#     02/26/03  Gary Meyer  	Added IPRTE timeout checking and IPRTE parsing.
#     03/11/03  Gary Meyer	Added WSTAT, PRB, IXSS, and IXSM error parsing.  Fixed problem w/IPRTE decode.
#     03/31/03  Gary Meyer	Removed unneeded addtional II_IPRTE1_A MMR read. 
#     04/24/03  Gary Meyer	Added decode of IMSG field for IMTP of XTalk in ii_crb_decode function.
#                               Now decoding timed out IPRTE reg's even if IO_PRESENT not set.
#                               Changes to handle doc error with swapped TOVLD and CVLD fields in CRB_E regs.
#     06/10/03  Gary Meyer      Will now abort after 3 consecutive failed read attempts.  Also, not decoding
#                               results of failed reads.
#     06/13/03  Gary Meyer      Added FRU support.
#     07/07/03  Gary Meyer      Added II_IWEL decode.
#     10/28/03  Gary Meyer      Using pktgen_mmr_read().  Fixed typo for Fru Reason message with CRB failure.
#     06/17/04  Gary Meyer      Added II_ILLR decode.
#     09/13/04  Gary Meyer	IPRTE timeout check now will require a successful IXTT read before generating a
#                               message regarding a Time-out indication.  Only adding to fru list one time if
#                               a MMR access fails when doing packet injected II register reads.
#				Upped failed reg read retry_limit from 3 to 8.
#     01/13/05  Gary Meyer	Incorporated retry limit from report_error_func() in errdmp.
#     02/22/05  Gary Meyer	Added fru DEVICE type for each fru entry added.
#     03/24/06  Gary Meyer	Added iidem_decode() to indicate which IO device has been downed by the II.
#     04/04/06  Gary Meyer	Change in iidem_decode() to indicate the proper PCI bus in the Ix or Px brick.
#     04/07/06  Gary Meyer	Update in ii_crb_decode() to improve error definitions, and to better handle
#				the XT_ERR case in regard to FRU reporting.
#     04/19/06  Gary Meyer      Added read of Crossbow registers on connected II's.
#     04/20/06  Gary Meyer      Added decode routines for Crossbow registers.
#     05/17/06  Gary Meyer      Now dumping Widget F PIC registers on Opus bricks.
#     07/24/06  Gary Meyer      Will clear the II's crazy bit if it is set so we can access the PIC registers.
#				Added Crossbow reset fence and link control regs.  
#				Updates for 4 character NASID values.
#     08/02/06  Gary Meyer      Added code to recognize signature for BW 954882.  This will now trip the error mechanism.
#     10/16/06  Gary Meyer      Initialize $SSCOPE_ERR before doing any jtag accesses.
#     01/24/07  Gary Meyer      Added debug code to determine characteristics of data returned.
#
#-------------------------------------------------------------------------------

@II_REG_LIST = ("II_WID",       "0x1400000",
                "II_WCR",       "0x1400020",	#  MUST occur in list BEFORE WSTAT
                "II_WSTAT",     "0x1400008",
                "II_ILAPR",     "0x1400100",
                "II_ILAP0",     "0x1400108",
                "II_IOWA",      "0x1400110",
                "II_IIWA",      "0x1400118",
                "II_IIDEM",     "0x1400120",
                "II_ILCSR",     "0x1400128",
                "II_ILLR",      "0x1400130",
                "II_IIDSR",     "0x1400138",
                "II_ISCR0",     "0x1400150",
                "II_ISCR1",     "0x1400158",
                "II_ITTE1",     "0x1400160",
                "II_ITTE2",     "0x1400168",
                "II_ITTE3",     "0x1400170",
                "II_ITTE4",     "0x1400178",
                "II_ITTE5",     "0x1400180",
                "II_ITTE6",     "0x1400188",
                "II_ITTE7",     "0x1400190",
                "II_IPRB0",     "0x1400198",
                "II_IPRB8",     "0x14001A0",
                "II_IPRB9",     "0x14001A8",
                "II_IPRBA",     "0x14001B0",
                "II_IPRBB",     "0x14001B8",
                "II_IPRBC",     "0x14001C0",
                "II_IPRBD",     "0x14001C8",
                "II_IPRBE",     "0x14001D0",
                "II_IPRBF",     "0x14001D8",
                "II_IXCC",      "0x14001E0",
                "II_IMEM",      "0x14001E8",
                "II_IXTT",      "0x14001F0",
                "II_IECLR",     "0x14001F8",
                "II_IBCR",      "0x1400200",
                "II_IXSS",      "0x1400210",
                "II_IXSM",      "0x1400208",
                "II_IIEPH1",    "0x1400220",
                "II_IIEPH2",    "0x1400228",
                "II_IWI",       "0x1400240",
                "II_IWEL",      "0x1400248",
                "II_IWC",       "0x1400250",
                "II_IWS",       "0x1400258",
                "II_IWEIM",     "0x1400260",
                "II_IPRTE0_A",  "0x1400308",
                "II_IPRTE0_B",  "0x1400348",
                "II_IPRTE1_A",  "0x1400310",
                "II_IPRTE1_B",  "0x1400350",
                "II_IPRTE2_A",  "0x1400318",
                "II_IPRTE2_B",  "0x1400358",
                "II_IPRTE3_A",  "0x1400320",
                "II_IPRTE3_B",  "0x1400360",
                "II_IPRTE4_A",  "0x1400328",
                "II_IPRTE4_B",  "0x1400368",
                "II_IPRTE5_A",  "0x1400330",
                "II_IPRTE5_B",  "0x1400370",
                "II_IPRTE6_A",  "0x1400338",
                "II_IPRTE6_B",  "0x1400378",
                "II_IPRTE7_A",  "0x1400340",
                "II_IPRTE7_B",  "0x1400380",
                "II_IFDR",      "0x1400398",
                "II_IIAP",      "0x14003A0",
                "II_IDBSS",     "0x1400718",
                "II_ICMR",      "0x14003A8",
                "II_ICTO",      "0x14003B8",
                "II_ICTP",      "0x14003C0",
                "II_ICRB0_A",   "0x1400400",
                "II_ICRB0_B",   "0x1400408",
                "II_ICRB0_C",   "0x1400410",
                "II_ICRB0_D",   "0x1400418",
                "II_ICRB0_E",   "0x1400420",
                "II_ICRB1_A",   "0x1400430",
                "II_ICRB1_B",   "0x1400438",
                "II_ICRB1_C",   "0x1400440",
                "II_ICRB1_D",   "0x1400448",
                "II_ICRB1_E",   "0x1400450",
                "II_ICRB2_A",   "0x1400460",
                "II_ICRB2_B",   "0x1400468",
                "II_ICRB2_C",   "0x1400470",
                "II_ICRB2_D",   "0x1400478",
                "II_ICRB2_E",   "0x1400480",
                "II_ICRB3_A",   "0x1400490",
                "II_ICRB3_B",   "0x1400498",
                "II_ICRB3_C",   "0x14004A0",
                "II_ICRB3_D",   "0x14004A8",
                "II_ICRB3_E",   "0x14004B0",
                "II_ICRB4_A",   "0x14004C0",
                "II_ICRB4_B",   "0x14004C8",
                "II_ICRB4_C",   "0x14004D0",
                "II_ICRB4_D",   "0x14004D8",
                "II_ICRB4_E",   "0x14004E0",
                "II_ICRB5_A",   "0x14004F0",
                "II_ICRB5_B",   "0x14004F8",
                "II_ICRB5_C",   "0x1400500",
                "II_ICRB5_D",   "0x1400508",
                "II_ICRB5_E",   "0x1400510",
                "II_ICRB6_A",   "0x1400520",
                "II_ICRB6_B",   "0x1400528",
                "II_ICRB6_C",   "0x1400530",
                "II_ICRB6_D",   "0x1400538",
                "II_ICRB6_E",   "0x1400540",
                "II_ICRB7_A",   "0x1400550",
                "II_ICRB7_B",   "0x1400558",
                "II_ICRB7_C",   "0x1400560",
                "II_ICRB7_D",   "0x1400568",
                "II_ICRB7_E",   "0x1400570",
                "II_ICRB8_A",   "0x1400580",
                "II_ICRB8_B",   "0x1400588",
                "II_ICRB8_C",   "0x1400590",
                "II_ICRB8_D",   "0x1400598",
                "II_ICRB8_E",   "0x14005A0",
                "II_ICRB9_A",   "0x14005B0",
                "II_ICRB9_B",   "0x14005B8",
                "II_ICRB9_C",   "0x14005C0",
                "II_ICRB9_D",   "0x14005C8",
                "II_ICRB9_E",   "0x14005D0",
                "II_ICRBA_A",   "0x14005E0",
                "II_ICRBA_B",   "0x14005E8",
                "II_ICRBA_C",   "0x14005F0",
                "II_ICRBA_D",   "0x14005F8",
                "II_ICRBA_E",   "0x1400600",
                "II_ICRBB_A",   "0x1400610",
                "II_ICRBB_B",   "0x1400618",
                "II_ICRBB_C",   "0x1400620",
                "II_ICRBB_D",   "0x1400628",
                "II_ICRBB_E",   "0x1400630",
                "II_ICRBC_A",   "0x1400640",
                "II_ICRBC_B",   "0x1400648",
                "II_ICRBC_C",   "0x1400650",
                "II_ICRBC_D",   "0x1400658",
                "II_ICRBC_E",   "0x1400660",
                "II_ICRBD_A",   "0x1400670",
                "II_ICRBD_B",   "0x1400678",
                "II_ICRBD_C",   "0x1400680",
                "II_ICRBD_D",   "0x1400688",
                "II_ICRBD_E",   "0x1400690",
                "II_ICRBE_A",   "0x14006A0",
                "II_ICRBE_B",   "0x14006A8",
                "II_ICRBE_C",   "0x14006B0",
                "II_ICRBE_D",   "0x14006B8",
                "II_ICRBE_E",   "0x14006C0",
                "II_ICSML",     "0x1400700",
                "II_ICSMM",     "0x1400708",
                "II_ICSMH",     "0x1400710",
                "II_IBLS0",     "0x1410000",
                "II_IBSA0",     "0x1410008",
                "II_IBDA0",     "0x1410010",
                "II_IBCT0",     "0x1410018",
                "II_IBNA0",     "0x1410020",
                "II_IBIA0",     "0x1410028",
                "II_IBLS1",     "0x1420000",
                "II_IBSA1",     "0x1420008",
                "II_IBDA1",     "0x1420010",
                "II_IBCT1",     "0x1420018",
                "II_IBNA1",     "0x1420020",
                "II_IBIA1",     "0x1420028",
                "II_IPCR",      "0x1430000",
                "II_IPPR",      "0x1430008"
        );


#	This list is used to assign a duplonet command name to 
#	messages received by the CRB from Shub.  This command
#	will have to be translated in some cases to the correct
#	sn2net command.

@duplonet_command_list = (
		"DNET_RDSH",			# Command 0x00
		"DNET_RDEX",
		"DNET_READ",
		"DNET_RSHU",
		"DNET_REXU",
		"DNET_UPGRD",
		"DNET_RLQSH",
		"DNET_RESERVED_07",
		"DNET_IRSHU",
		"DNET_IREXU",
		"DNET_IRDSH",
		"DNET_IRDEX",
		"DNET_IRMVE",
		"DNET_RESERVED_0D",
		"DNET_RESERVED_0E",
		"DNET_INVAL",
		"DNET_PRDH",
		"DNET_PRDI",
		"DNET_PRDM",
		"DNET_PRDU",
		"DNET_PRIHA",
		"DNET_PRIHB",
		"DNET_PRIRA",
		"DNET_PRIRB",
		"DNET_ODONE",
		"DNET_RESERVED_19",
		"DNET_RESERVED_1A",
		"DNET_RESERVED_1B",
		"DNET_PRDB",
		"DNET_BAR",
		"DNET_RESERVED_1E",
		"DNET_RESERVED_1F",
		"DNET_RESERVED_20",
		"DNET_RESERVED_21",
		"DNET_RESERVED_22",
		"DNET_RESERVED_23",
		"DNET_RESERVED_24",
		"DNET_RESERVED_25",
		"DNET_RESERVED_26",
		"DNET_RESERVED_27",
		"DNET_RESERVED_28",
		"DNET_RESERVED_29",
		"DNET_RESERVED_2A",
		"DNET_RESERVED_2B",
		"DNET_RESERVED_2C",
		"DNET_RESERVED_2D",
		"DNET_RESERVED_2E",
		"DNET_LINVAL",
		"DNET_PWRH",
		"DNET_PWRI",
		"DNET_PWRM",
		"DNET_PWRU",
		"DNET_PWIHA",
		"DNET_PWIHB",
		"DNET_PWIRA",
		"DNET_PWIRB",
		"DNET_GFXWS",
		"DNET_RESERVED_39",
		"DNET_RESERVED_3A",
		"DNET_RESERVED_3B",
		"DNET_PWRB",
		"DNET_RESERVED_3D",
		"DNET_RESERVED_3E",
		"DNET_RESERVED_3F",
		"DNET_WB",
		"DNET_WINV",
		"DNET_RESERVED_42",
		"DNET_RESERVED_43",
		"DNET_RESERVED_44",
		"DNET_RESERVED_45",
		"DNET_RESERVED_46",
		"DNET_RESERVED_47",
		"DNET_RESERVED_48",
		"DNET_RESERVED_49",
		"DNET_RESERVED_4A",
		"DNET_RESERVED_4B",
		"DNET_RESERVED_4C",
		"DNET_RESERVED_4D",
		"DNET_RESERVED_4E",
		"DNET_RESERVED_4F",
		"DNET_GFXWL",
		"DNET_PTPWR",
		"DNET_RESERVED_52",
		"DNET_RESERVED_53",
		"DNET_RESERVED_54",
		"DNET_RESERVED_55",
		"DNET_RESERVED_56",
		"DNET_RESERVED_57",
		"DNET_RESERVED_58",
		"DNET_RESERVED_59",
		"DNET_RESERVED_5A",
		"DNET_RESERVED_5B",
		"DNET_RESERVED_5C",
		"DNET_RESERVED_5D",
		"DNET_RESERVED_5E",
		"DNET_RESERVED_5F",
		"DNET_RESERVED_60",
		"DNET_VRD",
		"DNET_VWR",
		"DNET_RESERVED_63",
		"DNET_RESERVED_64",
		"DNET_RESERVED_65",
		"DNET_RESERVED_66",
		"DNET_RESERVED_67",
		"DNET_RESERVED_68",
		"DNET_RESERVED_69",
		"DNET_RESERVED_6A",
		"DNET_RESERVED_6B",
		"DNET_RESERVED_6C",
		"DNET_RESERVED_6D",
		"DNET_RESERVED_6E",
		"DNET_RESERVED_6F",
		"DNET_RESERVED_70",
		"DNET_RESERVED_71",
		"DNET_RESERVED_72",
		"DNET_RESERVED_73",
		"DNET_RESERVED_74",
		"DNET_RESERVED_75",
		"DNET_RESERVED_76",
		"DNET_RESERVED_77",
		"DNET_RESERVED_78",
		"DNET_RESERVED_79",
		"DNET_RESERVED_7A",
		"DNET_RESERVED_7B",
		"DNET_RESERVED_7C",
		"DNET_RESERVED_7D",
		"DNET_RESERVED_7E",
		"DNET_RESERVED_7F",
		"DNET_SACK",
		"DNET_EACK",
		"DNET_UACK",
		"DNET_UPC",
		"DNET_UPACK",
		"DNET_AERR",
		"DNET_PERR",
		"DNET_IVACK",
		"DNET_WERR",
		"DNET_WBEAK",
		"DNET_WBBAK",
		"DNET_DNACK",
		"DNET_SXFER",
		"DNET_PURGE",
		"DNET_DNGRD",
		"DNET_XFER",
		"DNET_PACK",			# Command 0x90
		"DNET_PACKH",
		"DNET_PACKN",
		"DNET_PNKRA",
		"DNET_PNKRB",
		"DNET_GFXCS",
		"DNET_GFXCL",
		"DNET_PTPCR",
		"DNET_WIC",
		"DNET_WACK",
		"DNET_WSPEC",
		"DNET_RACK",
		"DNET_BRMVE",
		"DNET_DERR",
		"DNET_PRERR",
		"DNET_PWERR",
		"DNET_BINV",
		"DNET_RESERVED_A1",
		"DNET_RESERVED_A2",
		"DNET_WTERR",
		"DNET_RTERR",
		"DNET_RESERVED_A5",
		"DNET_RESERVED_A6",
		"DNET_SPRPLY",
		"DNET_ESPRPLY",
		"DNET_RESERVED_A9",
		"DNET_RESERVED_AA",
		"DNET_RESERVED_AB",
		"DNET_RESERVED_AC",
		"DNET_RESERVED_AD",
		"DNET_RESERVED_AE",
		"DNET_RESERVED_AF",
		"DNET_PRPLY",
		"DNET_PNAKW",
		"DNET_PNKWA",
		"DNET_PNKWB",
		"DNET_RESERVED_B4",
		"DNET_RESERVED_B5",
		"DNET_RESERVED_B6",
		"DNET_RESERVED_B7",
		"DNET_RESERVED_B8",
		"DNET_RESERVED_B9",
		"DNET_RESERVED_BA",
		"DNET_RESERVED_BB",
		"DNET_RESERVED_BC",
		"DNET_RESERVED_BD",
		"DNET_RESERVED_BE",
		"DNET_RESERVED_BF",
		"DNET_SRESP",
		"DNET_SRPLY",
		"DNET_SSPEC",
		"DNET_RESERVED_C3",
		"DNET_ERESP",
		"DNET_ERPC",
		"DNET_ERPLY",
		"DNET_ESPEC",
		"DNET_URESP",
		"DNET_URPC",
		"DNET_URPLY",
		"DNET_RESERVED_CB",
		"DNET_SXWB",
		"DNET_PGWB",
		"DNET_SHWB",
		"DNET_RESERVED_CF",
		"DNET_RESERVED_D0",
		"DNET_RESERVED_D1",
		"DNET_RESERVED_D2",
		"DNET_RESERVED_D3",
		"DNET_RESERVED_D4",
		"DNET_RESERVED_D5",
		"DNET_RESERVED_D6",
		"DNET_RESERVED_D7",
		"DNET_BRDSH",
		"DNET_BRDEX",
		"DNET_BRSHU",
		"DNET_BREXU",
		"DNET_RESERVED_DC",
		"DNET_RESERVED_DD",
		"DNET_RESERVED_DE",
		"DNET_RESERVED_DF",
		"DNET_RESERVED_E0",
		"DNET_RESERVED_E1",
		"DNET_RESERVED_E2",
		"DNET_RESERVED_E3",
		"DNET_RESERVED_E4",
		"DNET_RESERVED_E5",
		"DNET_RESERVED_E6",
		"DNET_RESERVED_E7",
		"DNET_RESERVED_E8",
		"DNET_VRPLY",
		"DNET_VWACK",
		"DNET_RESERVED_EB",
		"DNET_RESERVED_EC",
		"DNET_RESERVED_ED",
		"DNET_RESERVED_EE",
		"DNET_RESERVED_EF",
		"DNET_RESERVED_F0",
		"DNET_RESERVED_F1",
		"DNET_RESERVED_F2",
		"DNET_RESERVED_F3",
		"DNET_RESERVED_F4",
		"DNET_RESERVED_F5",
		"DNET_RESERVED_F6",
		"DNET_RESERVED_F7",
		"DNET_RESERVED_F8",
		"DNET_VERRA",
		"DNET_VERRC",
		"DNET_VERRCA",
		"DNET_RESERVED_FC",
		"DNET_RESERVED_FD",
		"DNET_RESERVED_FE",
		"DNET_RESERVED_FF",
		"DNET_PRD",
		"DNET_PWR",
		"DNET_VRQ",
		"DNET_VACK"
	);


#-------------------------------------------------------------------------------
#
#  subroutine:  get_ii_mmrs
#
#    This is the engine used to read II MMR's.  
#    Requires that shub version is 1.1 or greater.
#    Requires that that the MMR target has been selected via mmr_target()
#
#
#  arguments:  nasid value on the current node
#
#
#-------------------------------------------------------------------------------

sub get_ii_mmrs

{
  my $node_number = $_[0];
  my $current_location = "$_[1]";
  my $node_prefix = sprintf ("0x%03X", $node_number);
  my $msg_out = " \n";
  my $failed_read = 0;
  my $retry_limit = 4;
  my $retry_count = 0;
  my $failed_read_fru_added = 0;
  my $crb_read_complete = 0;
  my $xb_msg_printed = 0;
  my $pic_msg_printed = 0;
  my $xb_ctrl_rst = 0;
  my $xb_llp_ctrl_rst = 0;

  $ii_crazy = 0;

  $get_next_iprte_b = 0;		#  This sets when the IPRTEx_B reg needs decoding
  $get_ixsm = 0;		        #  This sets when the IXSM reg needs decoding
  $get_xb_aux_stat = 0;			#  This sets when the XB_LINK_AUX_STAT reg needs decoding

  $target_list[$t_cnt]->{IXTT_TO_VAL} = 0xffff;		# set this to a default value, in case IXTT read fails
  
  @crb_reg_words = (); 

  @final_ii_reg_list = ();
  @final_ii_reg_list = @II_REG_LIST;
#  disable_lb_int();

  my $i = 0;

  while ((defined $final_ii_reg_list[$i]) 
	&& ($failed_read < 3)
	&& ($target_list[$t_cnt]->{XFR_ERR_CNT} < 6)) {
    $ii_reg_mark = "  ";
    print "\nBeginning loop at entry $i in final_ii_reg_list\n"  if ($verbose_mode == 1);
    $reg_name = "$final_ii_reg_list[$i]";
    $i++;
    $reg_addr = hex($final_ii_reg_list[$i]);
    $i++;
    $final_addr = $reg_addr | ($nasid_value << 38);

    $reg_value = 0xdeadbeef;
    $retry_count = 0;

       # Do packet injected reads until a clean value comes back or we exceed the retry limit

    while ((($reg_value & 0xffffffff) == 0xdeadbeef) 
	 && ($retry_count < $retry_limit)
	 && ($target_list[$t_cnt]->{XFR_ERR_CNT} < 6))  { 
      $reg_value = ii_reg_read($final_addr, $nasid_value, $reg_name);        # Do packet injected read using local function
      #  $reg_value = pktgen_mmr_read($reg_addr, $nasid_value);        # Do packet injected read using superscope lib function
      $retry_count++;
      if ($verbose_mode == 1)  {
        if ($reg_value > 0 )  {
	  printf "\n reg value is greater than 0\n";
        }
        elsif ($reg_value < 0 )  {
	  printf "\n reg value is less than 0\n";
        }
        else {
	  printf "\n reg value equals 0\n";
        }
      }
    }

    if (($reg_value & 0xffffffff) == 0xdeadbeef)  {
      $ii_reg_mark = "<<<<<<<  (Unsuccessful packet generated II MMR read)";
      $any_error = 1;
      $failed_read++;
      if ($failed_read_fru_added == 0)  {
        $fru_list[$fru_count]->{NASID}    = $node_number;
 	$fru_list[$fru_count]->{DEVICE}   = "SHUB1";
        $fru_list[$fru_count]->{LOCATION} = $current_location;
        $fru_list[$fru_count]->{REASON}   = sprintf ("Failure when reading II Register: %s", $reg_name);
        printf "\n%s: Added NASID 0x%04X to the FRU list, entry %d.\n", $node_prefix, $node_number, $fru_count;
        $fru_count++;
	$failed_read_fru_added = 1;		#  only need to add this once per node
      }
    }
    else  {		#  read was successful, so go ahead and check contents for errors
      $failed_read = 0;

      if ((ii_reg_chk($reg_name, $reg_value)) == 1)  {			# 0 good   1 bad
        $ii_reg_mark = "<<<<<<<";
        $any_error = 1;
        $target_list[$t_cnt]->{ERROR} = 1;
        $target_list[$t_cnt]->{ERR_SUMM} .= sprintf("\n%s:  %12s   0x%013llX :  0x%016llX ",
          $node_prefix, $reg_name, $final_addr, $reg_value);
        if ($reg_name =~ /ICSM/)  {
	  $target_list[$t_cnt]->{ERR_SUMM} .= icsm_decode($reg_name, $reg_value);
        }
        elsif ($reg_name =~ /IPRTE/)  {
	  $target_list[$t_cnt]->{ERR_SUMM} .= iprte_decode($reg_name, $reg_value);
        }
        elsif ($reg_name =~ /PRB/)  {
	  $target_list[$t_cnt]->{ERR_SUMM} .= prb_decode($reg_name, $reg_value);
        }
        elsif ($reg_name =~ /IXS/)  {
	  $target_list[$t_cnt]->{ERR_SUMM} .= ixs_decode($reg_name, $reg_value);
        }
        elsif ($reg_name =~ /WSTAT/)  {
	  $target_list[$t_cnt]->{ERR_SUMM} .= wstat_decode($reg_name, $reg_value);
        }
        elsif ($reg_name =~ /ILLR/)  {
	  $target_list[$t_cnt]->{ERR_SUMM} .= illr_decode($reg_name, $reg_value);
        }
        elsif ($reg_name =~ /IIDEM/)  {
	  $target_list[$t_cnt]->{ERR_SUMM} .= iidem_decode($reg_name, $reg_value);
        }
        elsif ($reg_name =~ /IWEL/)  {
	  $target_list[$t_cnt]->{ERR_SUMM} .= iwel_decode($reg_name, $reg_value);
        }
        elsif ($reg_name =~ /XB_STAT/)  {
	  $target_list[$t_cnt]->{ERR_SUMM} .= xbstat_decode($reg_name, $reg_value);
        }
        elsif ($reg_name =~ /XB_LINK_STAT/)  {
	  $target_list[$t_cnt]->{ERR_SUMM} .= xblink_stat_decode($reg_name, $reg_value);
	  $get_xb_aux_stat = 1;
        }
        elsif ($reg_name =~ /XB_LINK_AUX_STAT/)  {
	  $target_list[$t_cnt]->{ERR_SUMM} .= xblink_aux_stat_decode($reg_name, $reg_value);
	  $get_xb_aux_stat = 0;
        }
        elsif ($reg_name =~ /^BUS/)  {
	  $target_list[$t_cnt]->{ERR_SUMM} .= pic_mmr_decode($reg_name, $reg_value, $node_prefix, $ii_reg_mark);
        }
	else {
	  $target_list[$t_cnt]->{ERR_SUMM} .= "\n";
	}
      }

      if (  ($reg_name =~ /WSTAT/) 
	 && ($target_list[$t_cnt]->{IO_PRESENT} == 1) 
         && (($reg_value & 0x200) == 0) ) {
          add_xbow_regs();		# add Crossbow regs on connected II ports for reading later on
      }

      if ($reg_name =~ /ICRB/)  {
        ii_crb_decode($reg_name, $reg_value, $node_number);
      }
      if ($reg_name =~ /II_ICRBE_E/)  {
        $crb_read_complete = 1;
      }
    }

    if ($reg_name =~ /^XB_/) {
      if ($xb_msg_printed == 0) {
	$msg_out .= sprintf("\n     PIC Crossbow Registers on connected IO brick\n\n");
	$xb_msg_printed = 1;
      }
      $msg_out .= sprintf("%s:  %18s @ 0x%013llX :  0x%016llX    %s\n",
        $node_prefix, $reg_name, $final_addr, $reg_value, $ii_reg_mark);
    }
    elsif ($reg_name =~ /^BUS/) {
      if ($pic_msg_printed == 0) {
	$msg_out .= sprintf("\n     PIC Widget F Registers on connected IO brick\n\n");
	$pic_msg_printed = 1;
      }
      $msg_out .= pic_mmr_decode($reg_name, $reg_value, $node_prefix, $ii_reg_mark);
    }
    else {
      $msg_out .= sprintf("%s:  %12s @ 0x%013llX :  0x%016llX    %s\n",
          $node_prefix, $reg_name, $final_addr, $reg_value, $ii_reg_mark);
    }

    if (($reg_name =~ /II_IPPR/) && ($ii_crazy == 1)) {
      $msg_out .= "\n II Crazy bit is set in WSTAT reg - clearing it to allow reads to PIC registers.\n";
      my $ieclr_addr = 0x14001F8 | ($nasid_value << 38);
      pktgen_mmr_write($ieclr_addr, 0x10000, $nasid_value, $nasid_value, 0x3); 
    }

    if (($reg_name =~ /^XB_CTRL/) && ($reg_value == 0x80)) {
      $xb_ctrl_rst = 1;
    }
    if (($reg_name =~ /^XB_LLP_CTRL/) && (($reg_value & 0xfff) == 0x810)) {
      $xb_llp_ctrl_rst = 1;
    }

  }
  
#  enable_lb_int();

  if ($target_list[$t_cnt]->{XFR_ERR_CNT} > 5) {
    print "\n\nALERT:  Aborted II register read due to excessive superscope access errors for this node.!\n\n";
  }
  elsif ($failed_read == 6)  {
    print "\n\nALERT:  Aborted II register read.  Consecutive error threshold of 6 exceeded.!\n\n";
  }
  else  {
    if ($crb_read_complete == 1)  {
        $msg_out .= ii_crb_display();
    }
  }

  print "\n$msg_out\n";
 
  if (($xb_ctrl_rst == 1) && ($xb_llp_ctrl_rst == 1)) {
    $fru_list[$fru_count]->{NASID}    = $nasid_value;
    $fru_list[$fru_count]->{DEVICE}   = "SHUB1";
    $fru_list[$fru_count]->{LOCATION} = $current_location;
    $fru_list[$fru_count]->{REASON}   = sprintf ("Crossbow regs in connected PIC indicate spurious Warm Reset problem BW# 954882.");
    printf "\n%s: Added NASID 0x%04X to the FRU list, entry %d.\n", $prefix, $nasid_value, $fru_count;
    $fru_count++;

    $target_list[$t_cnt]->{ERR_SIG} = "\($current_location\) : BW 954882: PIC Spurious Warm Reset Problem."; 
    $target_list[$t_cnt]->{ERR_SUMM} .= "\n    The values in XB_CTRL and XB_LLP_CTRL of connected PIC indicate"; 
    $target_list[$t_cnt]->{ERR_SUMM} .= "\n    a Spurious Warm reset may have occurred. \(BW # 954882\)\n"; 
    $any_error = 1;
    $target_list[$t_cnt]->{ERROR} = 1;

  }

}


#-------------------------------------------------------------------------------
#
#  subroutine:  ii_reg_read
#       Does a packet injected MMR read based on the address and nasid supplied
#       values supplied to the function.
#
#       Return value:  the 64 bit value returned in the PIO read response
#
#  The lb regs are returned from eregs_wait_read_clear() as:
#
#	array element 0,1:  LB_FIRST_ERROR, 	  LB_ERROR_DETAIL_1,
#	array element 2,3:  LB_ERROR_DETAIL_2,    LB_ERROR_DETAIL_3,
#	array element 4,5:  LB_ERROR_DETAIL_4,    LB_ERROR_DETAIL_5,
#   	array element 6,7:  LB_ERROR_SUMMARY,     LB_ERROR_OVERFLOW,
#   	array element 8  :  LB_ERROR_MASK
#
#
#-------------------------------------------------------------------------------

sub ii_reg_read
{
  print "\n In ii_reg_read function\n"  if ($verbose_mode == 1);

  my $req_addr = $_[0];
  my $node_id  = $_[1];
  my $rg_name  = "$_[2]";
  my $lb_bad_cmd = 0;
  my $lb_rp_cmd = 0;
  my $lb_rp_data_err = 1;
  my $suppl = ($reg_name =~ /^XB/) ? 0x0f : 0xff;    # have to treat Crossbow reads as 32 bit reads

  %rq_hdr = chn32hdr_new();
  $rq_hdr{SRC_ID}         = $node_id;
  $rq_hdr{SRC_CHIPLET}    = 1;
  $rq_hdr{DST_ID}         = $node_id;
  $rq_hdr{DST_CHIPLET}    = 3;
  $rq_hdr{ADDR}           = $req_addr;
  $rq_hdr{ECHO}           = 0x1ed;
  $rq_hdr{CMD}            = 0x11;                 # PIO Read
  $rq_hdr{SUPPL}          = $suppl;

  # eregs_initialize(0);    # no errors masked off
  eregs_initialize(2);    # set the LB_ERROR_MASK to mask off the RP_BAD_CMD error
  $mode = $PKTGEN_CNTRL_SET_START | $PKTGEN_WAIT_BUSY;
  $PKTGEN_MAX_BUSY_POLL = 40;      # limit the number of loops in pktgen_wait_if_busy()

  my $xfr_complete = 0;
  my $xfr_f_cnt = 0;
  while (($xfr_complete == 0) && ($xfr_f_cnt < 3) && ($target_list[$t_cnt]->{XFR_ERR_CNT} < 6))  {
    $SSCOPE_ERR = 0;
    pktgen_write($mode, \%rq_hdr);
    if ($SSCOPE_ERR == 1)  {
        $xfr_f_cnt++;
        $target_list[$t_cnt]->{XFR_ERR_CNT}++;
        $SSCOPE_ERR = 0;
    }
    else {
        $xfr_complete = 1;
     }
  }

  @edata = ();
  @edata = eregs_wait_summary_read_clear($EREG_ERROR_MASK_RP_BAD_CMD, 40);
  return if ( $ecode < 0 ); # Return: short-circuit if error detected and returned
  if ( $#edata <= 0 )
  {  $emess = "Packet generated MMR read operation unsuccessful.";
     $emess .= "\nUnable to detect error or clear error reporting registers.";
     $ecode = -1;
     printf "\n\nERROR! $emess\n";
     return (0x10deadbeef);
  }
 
  my $reg_ptr;

  # $reg_ptr = reg_create_mmr_inst("shub_01", 'SH_LB_FIRST_ERROR');
  $reg_ptr = reg_create_mmr_inst("shub_01", 'SH_LB_ERROR_SUMMARY');
  reg_set_value($reg_ptr, $edata[6]);
  $lb_bad_cmd = reg_get_field_value($reg_ptr, 'RP_BAD_CMD');
  if ($lb_bad_cmd != 1)  {
    print "\n\nERROR!  RP_BAD_CMD not set in SH_LB_ERROR_SUMMARY mmr.\n";
    printf "\n LB_ERROR_SUMMARY value:  0x%016llx", $edata[6];
    printf "\n LB_ERROR_MASK value:  0x%016llx", $edata[8];
    return (0xdeadbeef);
  }

  $reg_ptr = reg_create_mmr_inst("shub_01", 'SH_LB_ERROR_DETAIL_1');
  reg_set_value($reg_ptr, $edata[1]);
  $lb_rp_cmd = reg_get_field_value($reg_ptr, 'COMMAND');
  $lb_rp_data_err = reg_get_field_value($reg_ptr, 'DATA_ERR');
  if ($lb_rp_cmd != 0xb4)  {
    print "\n\nERROR!  Expected reply command not found in SH_LB_ERROR_DETAIL_1 mmr.\n";
    printf "     Expected: 0x%02X      Actual: 0x%02X\n\n", 0xb4, $lb_rp_cmd;
    return (0x10deadbeef);
  }
  if ($lb_rp_data_err != 0)  {
    print "\n\nERROR!  Unexpected reply data error found in SH_LB_ERROR_DETAIL_1 mmr.\n";
    return (0x20deadbeef);
  }

  $address_rp = $edata[2] << 3;
  if ($address_rp != $req_addr)  {
    print "\n\nERROR!  Expected reply address not found in SH_LB_ERROR_DETAIL_2 mmr.\n";
    printf "     Expected: 0x%014X      Actual: 0x%014X\n\n", $req_addr, $address_rp;
    return (0x30deadbeef);
  }
        #  The reply packet header info captured looks OK, so return the data
  else  {
    if (($req_addr & 0x8) == 0x8)  {
      return($edata[3]);
    }
    else  { 
      return($edata[4]);
    }
  }
}

#-------------------------------------------------------------------------------
#
#  ii_crb_decode
#	args:   0 - register name (string)
#		1 - register value (64 bit integer)
#
#  register name is in the format: II_ICRB0_A
#
#-------------------------------------------------------------------------------

sub ii_crb_decode
{
  my $crb_reg_name = "$_[0]";
  my $crb_reg_data = $_[1];
  my $node_number  = $_[2];

  my @char_list = split(/\s*/, $crb_reg_name);
  my $crb_num = hex($char_list[7]);
  if (($crb_num < 0) || ($crb_num > 0xE))  {
    printf "\nERROR! In ii_crb_decode:  %s CRB register name value out of range: 0x%x\n", $crb_reg_name, $crb_num;
    return;
  }
  my $crb_slice = $char_list[9];

  if ("$crb_slice" eq "A")  {
    $crb_reg_words[$crb_num]{IOW}   = $crb_reg_data & 0x1;
    $crb_reg_words[$crb_num]{VLD}   = ($crb_reg_data >> 1) & 0x1;
    $crb_reg_words[$crb_num]{ADDR}  = (($crb_reg_data >> 2) & 0x7fffffffffff) << 3;
    $crb_reg_words[$crb_num]{TNUM}  = ($crb_reg_data >> 49) & 0x3f;
    $crb_reg_words[$crb_num]{SIDN}  = ($crb_reg_data >> 54) & 0xf;
  }

  elsif ("$crb_slice" eq "B")  {
    $crb_reg_words[$crb_num]{XTERR} = $crb_reg_data & 0x1;
    $crb_reg_words[$crb_num]{MARK}  = ($crb_reg_data >> 1) & 0x1;
    $crb_reg_words[$crb_num]{LNUCE} = ($crb_reg_data >> 2) & 0x1;
    $crb_reg_words[$crb_num]{ECODE} = ($crb_reg_data >> 3) & 0x7;
    $crb_reg_words[$crb_num]{ERROR} = ($crb_reg_data >> 6) & 0x1;
    $crb_reg_words[$crb_num]{STLB0} = ($crb_reg_data >> 7) & 0x1;
    $crb_reg_words[$crb_num]{STLB1} = ($crb_reg_data >> 8) & 0x1;
    $crb_reg_words[$crb_num]{STLIL} = ($crb_reg_data >> 9) & 0x1;
    $crb_reg_words[$crb_num]{STLIB} = ($crb_reg_data >> 10) & 0x1;
    $crb_reg_words[$crb_num]{INTVN} = ($crb_reg_data >> 11) & 0x1;
    $crb_reg_words[$crb_num]{WB}    = ($crb_reg_data >> 12) & 0x1;
    $crb_reg_words[$crb_num]{HOLD}  = ($crb_reg_data >> 13) & 0x1;
    $crb_reg_words[$crb_num]{ACK}   = ($crb_reg_data >> 14) & 0x1;
    $crb_reg_words[$crb_num]{RESP}  = ($crb_reg_data >> 15) & 0x1;
    $crb_reg_words[$crb_num]{AKCNT} = ($crb_reg_data >> 16) & 0x3ff;
    $crb_reg_words[$crb_num]{EXCL}  = ($crb_reg_data >> 34) & 0x1f;
    $crb_reg_words[$crb_num]{INIT}  = ($crb_reg_data >> 39) & 0x7;
    $crb_reg_words[$crb_num]{IMSG}  = ($crb_reg_data >> 42) & 0xff;
    $crb_reg_words[$crb_num]{IMTP}  = ($crb_reg_data >> 50) & 0x3;
    $crb_reg_words[$crb_num]{UOLD}  = ($crb_reg_data >> 52) & 0x1;
  }

  elsif ("$crb_slice" eq "C")  {
    $crb_reg_words[$crb_num]{SRC}   = $crb_reg_data & 0x3fff;
    $crb_reg_words[$crb_num]{SIZE}  = ($crb_reg_data >> 15) & 0x3;
    $crb_reg_words[$crb_num]{CT}    = ($crb_reg_data >> 17) & 0x1;
    $crb_reg_words[$crb_num]{BTENM} = ($crb_reg_data >> 18) & 0x1;
    $crb_reg_words[$crb_num]{GBR}   = ($crb_reg_data >> 19) & 0x1;
    $crb_reg_words[$crb_num]{RSPRQ} = ($crb_reg_data >> 20) & 0x1;
    $crb_reg_words[$crb_num]{BROP}  = ($crb_reg_data >> 21) & 0x1;
    $crb_reg_words[$crb_num]{SUPPL} = ($crb_reg_data >> 22) & 0x3fff;
  }

  elsif ("$crb_slice" eq "D")  {
    $crb_reg_words[$crb_num]{PA_BE} = $crb_reg_data & 0x3ffffffffff;
    $crb_reg_words[$crb_num]{BTEOP} = ($crb_reg_data >> 43) & 0x1;
    $crb_reg_words[$crb_num]{PRPSC} = ($crb_reg_data >> 44) & 0xf;
    $crb_reg_words[$crb_num]{PRCNT} = ($crb_reg_data >> 48) & 0xf;
    $crb_reg_words[$crb_num]{SLEEP} = ($crb_reg_data >> 52) & 0x1;
  }

  elsif ("$crb_slice" eq "E")  {
    $crb_reg_words[$crb_num]{TOCNT} = $crb_reg_data & 0xff;
    $crb_reg_words[$crb_num]{CNTXT} = ($crb_reg_data >> 8 ) & 0x7fff;
    $crb_reg_words[$crb_num]{CVLD}  = ($crb_reg_data >> 24) & 0x1;
    $crb_reg_words[$crb_num]{TVLD}  = ($crb_reg_data >> 25) & 0x1;
  }
  else {
    printf "\nERROR! In ii_crb_decode:  %s  Bad CRB register name slice: %s\n", $crb_reg_name, $crb_slice;
    return;
  }


  #  Decode some of the values into a more human-readable form

  if ("$crb_slice" eq "B")  {
    my $get_cmd = 0;

    if ($crb_reg_words[$crb_num]{IMTP} == 0 ) {
      $crb_reg_words[$crb_num]{IMTP} = "XTALK";
      $get_cmd = 1;
    }
    elsif ($crb_reg_words[$crb_num]{IMTP} == 1 ) {
      $crb_reg_words[$crb_num]{IMTP} = "  II "; }
    elsif ($crb_reg_words[$crb_num]{IMTP} == 2 ) {
      $get_cmd = 2;
      $crb_reg_words[$crb_num]{IMTP} = "SHUB "; }
    elsif ($crb_reg_words[$crb_num]{IMTP} == 3 ) {
      $crb_reg_words[$crb_num]{IMTP} = " CRB "; }
    else {
      $crb_reg_words[$crb_num]{IMTP} = sprintf (" 0x%X ", $crb_reg_words[$crb_num]{IMTP});
    }

    if ($get_cmd == 1)  {
      my $xtalk_cmd = $crb_reg_words[$crb_num]{IMSG} & 0xAF;
      if ($xtalk_cmd == 0)  {
	$crb_reg_words[$crb_num]{IMSG} = "   PRDC   ";
      }
      elsif ($xtalk_cmd == 2)  {
	$crb_reg_words[$crb_num]{IMSG} = "   PWRC   ";
      }
      elsif ($xtalk_cmd == 6)  {
	$crb_reg_words[$crb_num]{IMSG} = "FETCH & OP";
      }
      elsif ($xtalk_cmd == 8)  {
	$crb_reg_words[$crb_num]{IMSG} = "STORE & OP";
      }
      elsif ($xtalk_cmd == 0x10)  {
	$crb_reg_words[$crb_num]{IMSG} = "  BLK_RD  ";
      }
      elsif ($xtalk_cmd == 0x22)  {
	$crb_reg_words[$crb_num]{IMSG} = "  BLK_WR  ";
      }
      else  {
        $crb_reg_words[$crb_num]{IMSG} = sprintf ("   0x%2X   ", $crb_reg_words[$crb_num]{IMSG});
      }
    }
    elsif ($get_cmd == 2)  {
      $dnet_offset = $crb_reg_words[$crb_num]{IMSG};
      $crb_reg_words[$crb_num]{IMSG} = "$duplonet_command_list[$dnet_offset]";
    }
    else  {
      $crb_reg_words[$crb_num]{IMSG} = sprintf ("   0x%2X   ", $crb_reg_words[$crb_num]{IMSG});
    }

    if ($crb_reg_words[$crb_num]{EXCL} == 0 ) {
      $crb_reg_words[$crb_num]{EXCL} = "PRDC "; }
    elsif ($crb_reg_words[$crb_num]{EXCL} == 1 ) {
      $crb_reg_words[$crb_num]{EXCL} = "BLKRD"; }
    elsif ($crb_reg_words[$crb_num]{EXCL} == 2 ) {
      $crb_reg_words[$crb_num]{EXCL} = "RSVD "; }
    elsif ($crb_reg_words[$crb_num]{EXCL} == 3 ) {
      $crb_reg_words[$crb_num]{EXCL} = "EJPND"; }
    elsif ($crb_reg_words[$crb_num]{EXCL} == 4 ) {
      $crb_reg_words[$crb_num]{EXCL} = "GETF "; }
    elsif ($crb_reg_words[$crb_num]{EXCL} == 5 ) {
      $crb_reg_words[$crb_num]{EXCL} = "REXU "; }
    elsif ($crb_reg_words[$crb_num]{EXCL} == 6 ) {
      $crb_reg_words[$crb_num]{EXCL} = "RDEXC"; }
    elsif ($crb_reg_words[$crb_num]{EXCL} == 7 ) {
      $crb_reg_words[$crb_num]{EXCL} = " PUT "; }
    elsif ($crb_reg_words[$crb_num]{EXCL} == 8 ) {
      $crb_reg_words[$crb_num]{EXCL} = "PRDI "; }
    elsif ($crb_reg_words[$crb_num]{EXCL} == 9 ) {
      $crb_reg_words[$crb_num]{EXCL} = "PWRI "; }
    elsif ($crb_reg_words[$crb_num]{EXCL} == 10 ) {
      $crb_reg_words[$crb_num]{EXCL} = "WRBK "; }
    elsif ($crb_reg_words[$crb_num]{EXCL} == 11 ) {
      $crb_reg_words[$crb_num]{EXCL} = "RSVD "; }
    else {
      $crb_reg_words[$crb_num]{EXCL} = sprintf ("0x%02X ", $crb_reg_words[$crb_num]{EXCL});
    }


    if ($crb_reg_words[$crb_num]{INIT} == 0 ) {
      $crb_reg_words[$crb_num]{INIT} = "XTALK"; }
    elsif ($crb_reg_words[$crb_num]{INIT} == 1 ) {
      $crb_reg_words[$crb_num]{INIT} = " II  "; }
    elsif ($crb_reg_words[$crb_num]{INIT} == 5 ) {
      $crb_reg_words[$crb_num]{INIT} = "BTE_1"; }
    elsif ($crb_reg_words[$crb_num]{INIT} == 2 ) {
      $crb_reg_words[$crb_num]{INIT} = "SHUB "; }
    elsif ($crb_reg_words[$crb_num]{INIT} == 3 ) {
      $crb_reg_words[$crb_num]{INIT} = " CRB "; }
    else {
      $crb_reg_words[$crb_num]{INIT} = sprintf (" 0x%X ", $crb_reg_words[$crb_num]{INIT});
    }
  
    if ($crb_reg_words[$crb_num]{ERROR} == 1 ) {
      my $crb_ecode = $crb_reg_words[$crb_num]{ECODE};
      my $crb_errtype = "Unknown error type.";
      my $crb_dir_err = "";
      if ($crb_ecode == 0 ) {
        $crb_reg_words[$crb_num]{ECODE} = "DERR"; 
	$crb_errtype = "Dropped Request due to downed IO device or Directory MBE caused by II Access.";
	$crb_dir_err = "II_CRB_DERR";
      }
      elsif ($crb_ecode == 1 ) {
        $crb_reg_words[$crb_num]{ECODE} = "PERR"; 
	$crb_errtype = "Poison Error caused by II Access.";
	$crb_dir_err = "II_CRB_PERR";
      }
      elsif ($crb_ecode == 2 ) {
        $crb_reg_words[$crb_num]{ECODE} = "WERR"; 
	$crb_errtype = "Write Access Error caused by II Access.";
	$crb_dir_err = "II_CRB_WERR";
      }
      elsif ($crb_ecode == 3 ) {
        $crb_reg_words[$crb_num]{ECODE} = "AERR"; 
	$crb_errtype = "Read Access Error caused by II Access.";
	$crb_dir_err = "II_CRB_AERR";
      }
      elsif ($crb_ecode == 4 ) {
        $crb_reg_words[$crb_num]{ECODE} = "PWERR"; 
	$crb_errtype = "Error occurred on a Partial Write.";
	$crb_dir_err = "II_CRB_PWERR";
      }
      elsif ($crb_ecode == 5 ) {
        $crb_reg_words[$crb_num]{ECODE} = "PRERR"; 
	$crb_errtype = "Error occurred on a Partial Read.";
	$crb_dir_err = "II_CRB_PRERR";
      }
      elsif ($crb_ecode == 6 ) {
        $crb_reg_words[$crb_num]{ECODE} = "TOERR"; 
	$crb_errtype = "CRB timed out waiting for response from memory.";
	$crb_dir_err = "II_CRB_TOERR";
      }
      elsif ($crb_ecode == 7 ) {
        $crb_reg_words[$crb_num]{ECODE} = "XTERR";
	$crb_errtype = "Corrupted packet received from XTalk IO Widget.";
	$crb_dir_err = "II_CRB_XTERR";
      }
      else {
        $crb_reg_words[$crb_num]{ECODE} = sprintf (" 0x%X ", $crb_reg_words[$crb_num]{ECODE});
      }
	#  Don't attempt to get directory state of the interrupt addresses
      if ((defined $dump_ii_regs) && (($crb_reg_words[$crb_num]{ADDR} & 0xffffffeff) != 0x110000000)) {
	  save_address($prefix, ($crb_reg_words[$crb_num]{ADDR} & 0xfffffff80), 
		(($crb_reg_words[$crb_num]{ADDR} >> 38) & 0x7FF), $crb_dir_err);
      }
      $any_error = 1;
      $target_list[$t_cnt]->{ERROR} = 1;
      $target_list[$t_cnt]->{ERR_SUMM} .= sprintf("\n%s:  II CRB 0x%X  - CRB in ERROR!  Error Code = %s  %s\n",
        $prefix, $crb_num, $crb_reg_words[$crb_num]{ECODE}, $crb_errtype);

      $fru_list[$fru_count]->{NASID}    = $node_number;
      $fru_list[$fru_count]->{DEVICE}   = "SHUB1";
      $fru_list[$fru_count]->{REASON}   = sprintf ("II CRB %X error condition: %s", $crb_num, $crb_errtype);
      $fru_list[$fru_count]->{LOCATION} = $current_location;
      printf "\n%s: Added NASID 0x%04X to the FRU list, entry %d.\n", $prefix, $node_number, $fru_count;
      $fru_count++;

      if ($crb_ecode < 7) {
        $fru_list[$fru_count]->{NASID}    = ($crb_reg_words[$crb_num]{ADDR} >> 38) & 0x7FF;
        $fru_list[$fru_count]->{REASON}   = sprintf ("DMA Target node found in II CRB %X on NASID 0x%04X", $crb_num, $node_number);
        if ($node_number == $fru_list[$fru_count]->{NASID})  {
          $fru_list[$fru_count]->{DEVICE}   = "SHUB1";
          $fru_list[$fru_count]->{LOCATION} = $current_location;
        }
        printf "\n%s: Added NASID 0x%04X to the FRU list, entry %d.\n", $prefix, $fru_list[$fru_count]->{NASID}, $fru_count;
        $fru_count++;
      }

    }
    else {			#  No actual error, so just display in ASCII the value of ECODE
      $crb_reg_words[$crb_num]{ECODE} = sprintf (" 0x%X ", $crb_reg_words[$crb_num]{ECODE});
    }
  }

  if ("$crb_slice" eq "C")  {
    if ($crb_reg_words[$crb_num]{SIZE} == 0 ) {
      $crb_reg_words[$crb_num]{SIZE} = "DWRD"; }
    elsif ($crb_reg_words[$crb_num]{SIZE} == 1 ) {
      $crb_reg_words[$crb_num]{SIZE} = "QCL "; }
    elsif ($crb_reg_words[$crb_num]{SIZE} == 2 ) {
      $crb_reg_words[$crb_num]{SIZE} = "FCL "; 
      if ($crb_reg_words[$crb_num]{IMSG} =~ /PRDC/)  {
        $crb_reg_words[$crb_num]{IMSG} = " IO_READ  ";		#  Convert the partial message type to FCL type
      }
      if ($crb_reg_words[$crb_num]{IMSG} =~ /PWRC/)  {
        $crb_reg_words[$crb_num]{IMSG} = " IO_WRITE ";		#  Convert the partial message type to FCL type
      }
    }
    elsif ($crb_reg_words[$crb_num]{SIZE} == 3 ) {
      $crb_reg_words[$crb_num]{SIZE} = "RSVD"; }
  }

  if ("$crb_slice" eq "D")  {
    if ($crb_reg_words[$crb_num]{BTEOP} == 1)  {
      $crb_reg_words[$crb_num]{PA_BE} = ($crb_reg_words[$crb_num]{PA_BE} << 7);
      if ($crb_reg_words[$crb_num]{INIT} =~ /II/ )  {
	$crb_reg_words[$crb_num]{INIT} = "BTE_0";
      }
      if ($crb_reg_words[$crb_num]{IMTP} =~ /II/ )  {
	$crb_reg_words[$crb_num]{IMTP} = " BTE ";
      }
    }
  }
 
}


#-------------------------------------------------------------------------------
#
#  iprte_decode
#	args:   0 - register name (string)
#		1 - register value (64 bit integer)
#
#  register name is in the format: II_IPRTE?_[A|B]
#
#-------------------------------------------------------------------------------

sub iprte_decode
{
  my $rg_name = "$_[0]";
  my $rg_data = $_[1];
  my $ret_msg = " ";

  if ($rg_name =~ /A/)  {
    my $widget = ($rg_data >> 54) & 0xf;
    my $to_cnt = ($rg_data >> 58) & 0x1f;
    my $valid_bit = ($rg_data >> 63) & 0x1;
   
    $ret_msg = sprintf "\n %s fields:\tDestination Widget: 0x%X \n\t\t\tTime-Out Count: 0x%X \n\t\t\tValid: %d\n",
	$rg_name, $widget, $to_cnt, $valid_bit;
  }

  else {
    my $dest_addr = $rg_data & 0x3ffffffffffff;
    my $init = ($rg_data >> 50) & 0x7;
    my $src_node = ($rg_data >> 53) & 0x7ff;

#  Use Bedrock chiplet decodes

    if ($init == 0)     {  $init_chiplet = "PI";  }		
    elsif ($init == 1)  {  $init_chiplet = "MD";  }
    elsif ($init == 4)  {  $init_chiplet = "LB";  }
    else	        {  $init_chiplet = "??";  }

    $ret_msg = sprintf "\n %s fields:\tAddress: 0x%014llX \n\t\t\tSource Chiplet: %s \n\t\t\tSource Node: 0x%03X \n",
	$rg_name, $dest_addr, $init_chiplet, $src_node;

    $get_next_iprte_b = 0;		#  Completed parsing IPRTE pair, so clear this flag 
  }

  if ($rg_name =~ /A/)  {
    $fru_list[$fru_count]->{NASID}    = $nasid_value;
    $fru_list[$fru_count]->{DEVICE}   = "SHUB1";
    $fru_list[$fru_count]->{LOCATION} = $current_location;
    $fru_list[$fru_count]->{REASON}   = sprintf ("II Register (%s) indicates timed out PIO read", $rg_name);
    printf "\n%s: Added NASID 0x%04X to the FRU list, entry %d.\n", $prefix, $nasid_value, $fru_count;
    $fru_count++;
  }

  return($ret_msg);
}



#-------------------------------------------------------------------------------
#
#  prb_decode
#       args:   0 - register name (string)
#               1 - register value (64 bit integer)
#
#  register name is in the format: II_IPRBx
#
#-------------------------------------------------------------------------------

sub prb_decode
{
  my $rg_name = "$_[0]";
  my $rg_data = $_[1];
  my $ret_msg = " ";
 
  my $widget = "$rg_name";
  $widget =~ s/II_IPRB// ;

  if ((($rg_data >> 48) & 0x1) == 1)		#  Errored write response detected 
  {	$ret_msg .= sprintf "\n $rg_name  <48> = 1    XTalk Write Response with Error Detected on Widget $widget";  }

  if ((($rg_data >> 49) & 0x1) == 1)		#  Read response timeout
  {	$ret_msg .= sprintf "\n %s  <49> = 1    XTalk Read Response Timeout Detected on Widget %s", $rg_name, $widget;  }

  if ((($rg_data >> 50) & 0x1) == 1)		#  Spurious Write response
  {	$ret_msg .= sprintf "\n $rg_name  <50> = 1    XTalk Spurious Write Response Detected on Widget $widget";  }

  if ((($rg_data >> 51) & 0x1) == 1)		#  Spurious Read response
  {	$ret_msg .= sprintf "\n $rg_name  <51> = 1    XTalk Spurious Read Response Detected on Widget $widget";  }

  if ((($rg_data >> 63) & 0x1) == 1)		#  Multiple errors detected
  {	$ret_msg .= sprintf "\n $rg_name  <63> = 1    Multiple XTalk Errors Detected on Widget $widget";  }

  $ret_msg .= "\n\n";

  $fru_list[$fru_count]->{NASID}    = $nasid_value;
  $fru_list[$fru_count]->{DEVICE}   = "SHUB1";
  $fru_list[$fru_count]->{LOCATION} = $current_location;
  $fru_list[$fru_count]->{REASON}   = sprintf ("II Register (%s) indicates PIO error to Widget %s", $rg_name, $widget);
  printf "\n%s: Added NASID 0x%04X to the FRU list, entry %d.\n", $prefix, $nasid_value, $fru_count;
  $fru_count++;

  return($ret_msg);

}




#-------------------------------------------------------------------------------
#
#  ixs_decode
#       args:   0 - register name (string)
#               1 - register value (64 bit integer)
#
#  register name is in the format: II_IXS[M|S]
#
#-------------------------------------------------------------------------------

sub ixs_decode
{
  my $rg_name = "$_[0]";
  my $rg_data = $_[1];
  my $ret_msg = " ";

  if ($rg_name =~ /IXSM/)  {
    my $byte_en  = $rg_data & 0xffffffff;
    my $tag      = ($rg_data >> 33) & 0x7;
    my $alt_pkt  = ($rg_data >> 36) & 0xf;
    my $barr_op  = ($rg_data >> 40) & 1;
    my $err_bit  = ($rg_data >> 41) & 1;
    my $vbpm     = ($rg_data >> 42) & 1;
    my $gbr      = ($rg_data >> 43) & 1;
    my $data_sz  = ($rg_data >> 44) & 3;
    my $ct       = ($rg_data >> 46) & 1;
    my $tnum     = ($rg_data >> 47) & 0x1f;
    my $pkt_type = ($rg_data >> 52) & 0xf;
    my $sidn     = ($rg_data >> 56) & 0xf;
    my $didn     = ($rg_data >> 60) & 0xf;
    $ret_msg = sprintf "\n %s fields:\tDestination Widget: 0x%X \n\t\t\tSource Widget: 0x%X\n\t\t\tPacket Type: %d\n\t\t\tTransaction Number: 0x%X\n\t\t\tCoherent Transaction: %d\n\t\t\tData Size: %d\n\t\t\tGBR: %d\n\t\t\tVBPM: %d \n\t\t\tError: %d\n\t\t\tBarrier Op: %d\n\t\t\tAlternate Packet Type: 0x%X\n\t\t\tTag: %d\n\t\t\tByte Enable: 0x%X\n\n",
	$rg_name, $didn, $sidn, $pkt_type, $tnum, $ct, $data_sz, $gbr, $vbpm, $err_bit, $barr_op, $alt_pkt, $tag, $byte_en;

    $fru_list[$fru_count]->{NASID}    = $nasid_value;
    $fru_list[$fru_count]->{DEVICE}   = "SHUB1";
    $fru_list[$fru_count]->{LOCATION} = $current_location;
    $fru_list[$fru_count]->{REASON}   = sprintf ("II Register (%s) indicates spurious sideband from Widget %s", $rg_name, $sidn);
    printf "\n%s: Added NASID 0x%04X to the FRU list, entry %d.\n", $prefix, $nasid_value, $fru_count;
    $fru_count++;

  }
  else  {
    my $sideband = $rg_data & 0xff;
    my $valid_bit = ($rg_data >> 63) & 1;
    $ret_msg = sprintf "\n %s fields:\tCaptured Sideband: 0x%X \n\t\t\tValid: %d\n\n",
	$rg_name, $sideband, $valid_bit;
  }

  return($ret_msg);
}



#-------------------------------------------------------------------------------
#
#  wstat_decode
#       args:   0 - register name (string)
#               1 - register value (64 bit integer)
#
#  register name II_WSTAT
#
#-------------------------------------------------------------------------------

sub wstat_decode
{
  my $rg_name = "$_[0]";
  my $rg_data = $_[1];
  my $ret_msg = " ";

  my $pending      = $rg_data & 0xf;
  my $xt_crd_to    = ($rg_data >> 4) & 1;
  my $xt_tail_to   = ($rg_data >> 5) & 1;
  my $tx_max_retry = ($rg_data >> 9) & 1;
  my $llp_tx_cnt   = ($rg_data >> 16) & 0xff;
  $ii_crazy        = ($rg_data >> 32) & 0x1;

  $ret_msg = sprintf "\n %s fields:\tPending Requests     : 0x%X \n\t\t\tXTalk Credit Timeout : %d\n\t\t\tXTalk Tail Timeout   : %d\n\t\t\tRetry Timeout        : %d\n\t\t\tRetry Count          : 0x%X\n\t\t\tCrazy Bit            : %d\n\n",
	$rg_name, $pending, $xt_crd_to, $xt_tail_to, $tx_max_retry, $llp_tx_cnt, $ii_crazy;

  $fru_list[$fru_count]->{NASID}    = $nasid_value;
  $fru_list[$fru_count]->{DEVICE}   = "SHUB1";
  $fru_list[$fru_count]->{LOCATION} = $current_location;
  $fru_list[$fru_count]->{REASON}   = sprintf ("II Register (%s) indicates IO cable or IO brick problem", $rg_name);
  printf "\n%s: Added NASID 0x%04X to the FRU list, entry %d.\n", $prefix, $nasid_value, $fru_count;
  $fru_count++;

  return($ret_msg);

}


#-------------------------------------------------------------------------------
#
#  illr_decode
#       args:   0 - register name (string)
#               1 - register value (64 bit integer)
#
#  register name II_ILLR
#
#-------------------------------------------------------------------------------

sub illr_decode
{
  my $rg_name = "$_[0]";
  my $rg_data = $_[1];
  my $ret_msg = " ";

  my $sn_cnt  = $rg_data & 0xffff;
  my $cb_cnt  = ($rg_data >> 16) & 0xffff;

  $ret_msg = sprintf "\n %s fields:\tSequence Number Errors: 0x%X \n\t\t\t      Check Bit Errors: 0x%X\n\n",
	$rg_name, $sn_cnt, $cb_cnt;

  $fru_list[$fru_count]->{NASID}    = $nasid_value;
  $fru_list[$fru_count]->{DEVICE}   = "SHUB1";
  $fru_list[$fru_count]->{LOCATION} = $current_location;
  $fru_list[$fru_count]->{REASON}   = sprintf ("II Register (%s) indicates IO cable or IO brick problem", $rg_name);
  printf "\n%s: Added NASID 0x%04X to the FRU list, entry %d.\n", $prefix, $nasid_value, $fru_count;
  $fru_count++;

  return($ret_msg);

}

#-------------------------------------------------------------------------------
#
#  iidem_decode
#       args:   0 - register name (string)
#               1 - register value (64 bit integer)
#
#  register name II_IIDEM
#
#-------------------------------------------------------------------------------

sub iidem_decode
{
  my $rg_name = "$_[0]";
  my $rg_data = $_[1];

  my $bad_dev = "";
  my $ret_msg = sprintf "\n   The following IO device\(s\) have been disabled by the II:\n";
  my $bad_widget_found = 0;
 
  for (my $widget_field = 0; $widget_field < 8; $widget_field++)  {
    my $shift_val = $widget_field * 8;
    my $io_widget = 8 + $widget_field;
    my $widget_offset = ($io_widget == 0xF) ? 2 : ($io_widget == 0xD) ? 4 : 0;
    my $device_mask = ($rg_data >> $shift_val) & 0xff;
    if ($device_mask != 0xff)  {
      for (my $io_dev = 0; $io_dev < 8; $io_dev++)  {
	if ((($device_mask >> $io_dev) & 1) == 0) {
	  my $pci_bus = ($io_dev < 4) ? (1 + $widget_offset) : (2 + $widget_offset);
	  $ret_msg .= sprintf "\tWidget 0x%X, PCI Bus %d, Device %d\n", $io_widget, $pci_bus, ($io_dev % 4); 
	}
      }
      if ($bad_widget_found == 0) {
	$bad_dev = sprintf "0x%X", $io_widget;
	$bad_widget_found = 1;
      }
      else {
	$bad_dev .= sprintf " and 0x%X", $io_widget;
	$bad_widget_found = 1;
      }
    }
  }

  $fru_list[$fru_count]->{NASID}    = $nasid_value;
  $fru_list[$fru_count]->{DEVICE}   = "SHUB1";
  $fru_list[$fru_count]->{LOCATION} = $current_location;
  $fru_list[$fru_count]->{REASON}   = sprintf ("II Register \(%s\) indicates IO device problem on Widget %s of connected IO brick.", $rg_name, $bad_dev);
  printf "\n%s: Added NASID 0x%04X to the FRU list, entry %d.\n", $prefix, $nasid_value, $fru_count;
  $fru_count++;

  $ret_msg .= "\n";

  return($ret_msg);

}


#-------------------------------------------------------------------------------
#
#  iwel_decode
#       args:   0 - register name (string)
#               1 - register value (64 bit integer)
#
#  register name II_IWEL
#
#-------------------------------------------------------------------------------

sub iwel_decode
{
  my $rg_name = "$_[0]";
  my $rg_data = $_[1];
  my $ret_msg = " ";
  my $fru_gen = 0;

  if (($rg_data & 0x1) == 1)            #  Interrupt timed out
  {     $ret_msg .= sprintf "\n %s   <0>  = 1   A pending Interrupt timed out in the retry queue.", $rg_name;  
	$fru_gen = 1;
  }

  if ((($rg_data >> 8) & 0x1) == 1)            #  Echo cam overflow
  {     $ret_msg .= sprintf "\n %s   <8>  = 1   Echo cam for PIO accesses overflowed", $rg_name;
	$fru_gen = 1;
  }

  if ((($rg_data >> 9) & 0x1) == 1)            #  Echo cam read miss
  {     $ret_msg .= sprintf "\n %s   <9>  = 1   Read miss in Echo cam for outgoing PIO reply", $rg_name;
	$fru_gen = 1;
  }

  if ((($rg_data >> 12) & 0x1) == 1)            #  IOQ_REP_UNDERFLOW
  {     $ret_msg .= sprintf "\n %s  <12>  = 1   IOQ Reply Queue has underflowed ", $rg_name;
	$fru_gen = 1;
  }

  if ((($rg_data >> 13) & 0x1) == 1)            #  IOQ_REQ_UNDERFLOW
  {     $ret_msg .= sprintf "\n %s  <13>  = 1   IOQ Request Queue has underflowed ", $rg_name;
	$fru_gen = 1;
  }

  if ((($rg_data >> 14) & 0x1) == 1)            #  IOQ_REQ_OVERFLOW  - known bug in the II, so won't add to FRU info
  {     $ret_msg .= sprintf "\n %s  <14>  = 1   IOQ Request Queue has Overflowed (wontfixed BW# 887890)", $rg_name;
  }

  if ((($rg_data >> 15) & 0x1) == 1)            #  IOQ_REQ_OVERFLOW  - known bug in the II, so won't add to FRU info
  {     $ret_msg .= sprintf "\n %s  <15>  = 1   IOQ Request Queue has Overflowed (wontfixed BW# 872426)", $rg_name;
  }

  if ((($rg_data >> 16) & 0x1) == 1)            #  IIQ_REP_OVERFLOW
  {     $ret_msg .= sprintf "\n %s  <16>  = 1   IIQ Reply Queue has overflowed ", $rg_name;
	$fru_gen = 1;
  }

  if ((($rg_data >> 17) & 0x1) == 1)            #  IIQ_REQ_OVERFLOW
  {     $ret_msg .= sprintf "\n %s  <17>  = 1   IIQ Request Queue has overflowed ", $rg_name;
	$fru_gen = 1;
  }

  if ((($rg_data >> 24) & 0x1) == 1)            #  II_XN_REP_OVER/UNDERFLOW
  {     $ret_msg .= sprintf "\n %s  <24>  = 1   II_XN Reply credits have overflowed or underflowed ", $rg_name;
	$fru_gen = 1;
  }

  if ((($rg_data >> 25) & 0x1) == 1)            #  II_XN_REQ_OVER/UNDERFLOW
  {     $ret_msg .= sprintf "\n %s  <25>  = 1   II_XN Request credits have overflowed or underflowed ", $rg_name;
	$fru_gen = 1;
  }

  if ((($rg_data >> 32) & 0x1) == 1)            #  II_XN_INVALID_CMD
  {     $ret_msg .= sprintf "\n %s  <32>  = 1   The II has sent a invalid command to the XN. Possible garbage packet.", $rg_name;
	$fru_gen = 1;
  }

  if ((($rg_data >> 33) & 0x1) == 1)            #  XN_II_INVALID_CMD
  {     $ret_msg .= sprintf "\n %s  <32>  = 1   The II has recieved a invalid command from the XN. Possible garbage packet.", $rg_name;
	$fru_gen = 1;
  }


  $ret_msg .= "\n\n";

  if ($fru_gen == 1)  {
    $fru_list[$fru_count]->{NASID}    = $nasid_value;
    $fru_list[$fru_count]->{DEVICE}   = "SHUB1";
    $fru_list[$fru_count]->{LOCATION} = $current_location;
    $fru_list[$fru_count]->{REASON}   = sprintf ("II Register (%s) indicates II wrapper detected error", $rg_name);
    printf "\n%s: Added NASID 0x%04X to the FRU list, entry %d.\n", $prefix, $nasid_value, $fru_count;
    $fru_count++;
  }

  return($ret_msg);

}


#-------------------------------------------------------------------------------
#
#  xbstat_decode
#       args:   0 - register name (string)
#               1 - register value (64 bit integer)
#
#  register name XB_STAT
#
#-------------------------------------------------------------------------------

sub xbstat_decode
{
  my $rg_name = "$_[0]";
  my $rg_data = $_[1];
  my $ret_msg = " ";
  my $fru_gen = 0;

  if (($rg_data & 0x1) == 1)       
  {     $ret_msg .= sprintf "\n\t %s   <0>  = 1   Multiple errors have been detected.", $rg_name;  
	$fru_gen = 1;
  }

  if ((($rg_data >> 1) & 0x1) == 1)           
  {     $ret_msg .= sprintf "\n\t %s   <1>  = 1   Widget 0 Destination Timeout Error", $rg_name;
	$fru_gen = 1;
  }

  if ((($rg_data >> 2) & 0x1) == 1) 
  {     $ret_msg .= sprintf "\n\t %s   <2>  = 1   Crosstalk packet received with sideband error bit or command word error", $rg_name;
	$fru_gen = 1;
  }

  if ((($rg_data >> 3) & 0x1) == 1)    
  {     $ret_msg .= sprintf "\n\t %s   <3>  = 1   Widget 0 Arbiter Time-out Error ", $rg_name;
	$fru_gen = 1;
  }

  if ((($rg_data >> 4) & 0x1) == 1)  
  {     $ret_msg .= sprintf "\n\t %s   <4>  = 1   Widget 0 Receive Time-out Error ", $rg_name;
	$fru_gen = 1;
  }

  if ((($rg_data >> 5) & 0x1) == 1)           
  {     $ret_msg .= sprintf "\n\t %s   <5>  = 1   Register Access Error ", $rg_name;
        $fru_gen = 1;
  }

  if ((($rg_data >> 6) & 0xf) > 0)   
  {     my $src_id = ($rg_data >> 6) & 0xf;
	$ret_msg .= sprintf "\n\t %s  <9:6> = 0x%X   Source ID", $rg_name, $src_id;
  }

  if ((($rg_data >> 23) & 0x1) == 1)
  {     $ret_msg .= sprintf "\n\t %s  <23>  = 1   Widget 0 Error occurred ", $rg_name;
	$fru_gen = 1;
  }

  if ((($rg_data >> 26) & 0x1) == 1) 
  {     $ret_msg .= sprintf "\n\t %s  <26>  = 1   Link A Error occurred ", $rg_name;
	$fru_gen = 1;
  }

  if ((($rg_data >> 27) & 0x1) == 1) 
  {     $ret_msg .= sprintf "\n\t %s  <27>  = 1   Link B Error occurred ", $rg_name;
	$fru_gen = 1;
  }

  if ((($rg_data >> 28) & 0x1) == 1) 
  {     $ret_msg .= sprintf "\n\t %s  <28>  = 1   Link C Error occurred ", $rg_name;
	$fru_gen = 1;
  }

  if ((($rg_data >> 29) & 0x1) == 1) 
  {     $ret_msg .= sprintf "\n\t %s  <29>  = 1   Link D Error occurred ", $rg_name;
	$fru_gen = 1;
  }

  if ((($rg_data >> 31) & 0x1) == 1) 
  {     $ret_msg .= sprintf "\n\t %s  <31>  = 1   Link F Error occurred ", $rg_name;
	$fru_gen = 1;
  }

  $ret_msg .= "\n\n";

  if ($fru_gen == 1)  {
    $fru_list[$fru_count]->{NASID}    = $nasid_value;
    $fru_list[$fru_count]->{DEVICE}   = "SHUB1";
    $fru_list[$fru_count]->{LOCATION} = $current_location;
    $fru_list[$fru_count]->{REASON}   = sprintf ("PIC Register (%s) indicates PIC Crossbow detected error.", $rg_name);
    printf "\n%s: Added NASID 0x%04X to the FRU list, entry %d.\n", $prefix, $nasid_value, $fru_count;
    $fru_count++;
  }

  return($ret_msg);

}


#-------------------------------------------------------------------------------
#
#  xblink_stat_decode
#       args:   0 - register name (string)
#               1 - register value (64 bit integer)
#
#  register name XB_LINK_STAT_?
#
#-------------------------------------------------------------------------------

sub xblink_stat_decode
{
  my $rg_name = "$_[0]";
  my $rg_data = $_[1];
  my $ret_msg = " ";


  if (($rg_data & 0x1) == 1) 
  {     $ret_msg .= sprintf "\n\t %s   <0>  = 1   Receive Crosstalk packet Timed-out from Source ", $rg_name;
  }

  if ((($rg_data >> 1) & 0x1) == 1) 
  {     $ret_msg .= sprintf "\n\t %s   <1>  = 1   Crosstalk protocol error or Request Credit Time-out from Source ", $rg_name;
  }

  if ((($rg_data >> 3) & 0x1) == 1)    
  {     $ret_msg .= sprintf "\n\t %s   <3>  = 1   LLP Transmitter Retry ", $rg_name;
  }

  if ((($rg_data >> 4) & 0x1) == 1)  
  {     $ret_msg .= sprintf "\n\t %s   <4>  = 1   LLP Receiver Error ", $rg_name;
  }

  if ((($rg_data >> 5) & 0x1) == 1)           
  {     $ret_msg .= sprintf "\n\t %s   <5>  = 1   LLP Transmitter Max Retry  ", $rg_name;
  }

  if ((($rg_data >> 6) & 0x1) == 1)           
  {     $ret_msg .= sprintf "\n\t %s   <6>  = 1   LLP Transmit Retry counter overflow ", $rg_name;
  }

  if ((($rg_data >> 7) & 0x1) == 1)           
  {     $ret_msg .= sprintf "\n\t %s   <7>  = 1   LLP Receive Retry counter overflow ", $rg_name;
  }

  if ((($rg_data >> 10) & 0x1) == 1) 
  {     $ret_msg .= sprintf "\n\t %s  <10>  = 1   Link A Bandwidth Allocation Error ", $rg_name;
  }

  if ((($rg_data >> 11) & 0x1) == 1) 
  {     $ret_msg .= sprintf "\n\t %s  <11>  = 1   Link B Bandwidth Allocation Error ", $rg_name;
  }

  if ((($rg_data >> 12) & 0x1) == 1) 
  {     $ret_msg .= sprintf "\n\t %s  <12>  = 1   Link C Bandwidth Allocation Error ", $rg_name;
  }

  if ((($rg_data >> 13) & 0x1) == 1) 
  {     $ret_msg .= sprintf "\n\t %s  <14>  = 1   Link D Bandwidth Allocation Error ", $rg_name;
  }

  if ((($rg_data >> 15) & 0x1) == 1) 
  {     $ret_msg .= sprintf "\n\t %s  <15>  = 1   Link F Bandwidth Allocation Error ", $rg_name;
  }

  if ((($rg_data >> 16) & 0x1) == 1) 
  {     $ret_msg .= sprintf "\n\t %s  <16>  = 1   Input Packet Buffer Overflow Error", $rg_name;
  }

  if ((($rg_data >> 17) & 0x1) == 1) 
  {     $ret_msg .= sprintf "\n\t %s  <17>  = 1   Illegal Destination Error", $rg_name;
  }

  if ((($rg_data >> 18) & 0x1) == 1) 
  {     $ret_msg .= sprintf "\n\t %s  <18>  = 1   Multiple Errors detected", $rg_name;
  }

  if ((($rg_data >> 31) & 0x1) == 1) 
  {     $ret_msg .= sprintf "\n\t %s  <31>  = 1   Link is alive", $rg_name;
  }


  $ret_msg .= "\n\n";

  return($ret_msg);

}


#-------------------------------------------------------------------------------
#
#  xblink_aux_stat_decode
#       args:   0 - register name (string)
#               1 - register value (64 bit integer)
#
#  register name XB_LINK_AUX_STAT_?
#
#-------------------------------------------------------------------------------

sub xblink_aux_stat_decode
{
  my $rg_name = "$_[0]";
  my $rg_data = $_[1];
  my $ret_msg = " ";

  my $bm8_num = ($rg_data >> 4) & 0x1;
  my $bm8_val = ($bm8_num == 0) ? 16 : 8;
  $ret_msg .= sprintf "\n\t %s   <4>  = %d   Link is running in Bit mode %d.", $rg_name, $bm8_num, $bm8_val;  

  my $widget_pres = ($rg_data >> 5) & 0x1;
  $ret_msg .= sprintf "\n\t %s   <5>  = %d   Widget present", $rg_name, $widget_pres;

  my $fail_mode = ($rg_data >> 6) & 0x1;
  my $fail_msg = ($fail_mode == 0) ? "Link Failed while transferring data" : "Link never came out of reset"; 
  $ret_msg .= sprintf "\n\t %s   <6>  = %d   %s", $rg_name, $fail_mode, $fail_msg;

  if ((($rg_data >> 10) & 0x1) == 1)
  {     $ret_msg .= sprintf "\n\t %s  <10>  = 1   Link A Error occurred ", $rg_name;
  }

  if ((($rg_data >> 11) & 0x1) == 1) 
  {     $ret_msg .= sprintf "\n\t %s  <11>  = 1   Link B Error occurred ", $rg_name;
  }

  if ((($rg_data >> 12) & 0x1) == 1) 
  {     $ret_msg .= sprintf "\n\t %s  <12>  = 1   Link C Error occurred ", $rg_name;
  }

  if ((($rg_data >> 13) & 0x1) == 1) 
  {     $ret_msg .= sprintf "\n\t %s  <13>  = 1   Link D Error occurred ", $rg_name;
  }

  if ((($rg_data >> 15) & 0x1) == 1) 
  {     $ret_msg .= sprintf "\n\t %s  <15>  = 1   Link F Error occurred ", $rg_name;
  }

  if ((($rg_data >> 16) & 0xff) > 0)   
  {     my $retry_cnt = ($rg_data >> 16) & 0xff;
	$ret_msg .= sprintf "\n\t %s <23:16> = 0x%X   LLP Transmit Retry Counter: 0x%X", $rg_name, $retry_cnt;
  }

  if ((($rg_data >> 24) & 0xff) > 0)   
  {     my $retry_cnt = ($rg_data >> 24) & 0xff;
	$ret_msg .= sprintf "\n\t %s <31:24> = 0x%X   LLP Receive Retry Counter : 0x%X", $rg_name, $retry_cnt;
  }

  $ret_msg .= "\n\n";

  return($ret_msg);

}



#-------------------------------------------------------------------------------
#
#  icsm_decode
#	args:   0 - register name (string)
#		1 - register value (64 bit integer)
#
#  register name is in the format: ICSM?
#
#-------------------------------------------------------------------------------

sub icsm_decode
{
  my $rg_name = "$_[0]";
  my $rg_data = $_[1];
  my $ret_msg = " ";

  if ($rg_name =~ /ICSML/)  {
    $icsm_addr  = ($rg_data & 0x7fffffffffff) << 3;
    $icsm_suppl = ($rg_data >> 47) & 0x3fff;
    $icsm_ovfl  = ($rg_data >> 63) & 1;
    $ret_msg = sprintf "\n ICSML fields:\t Address : 0x%014llX \n\t\t   Suppl : 0x%04X \n\t\tOverflow : %x\n",
	$icsm_addr, $icsm_suppl, $icsm_ovfl;
  }

  if ($rg_name =~ /ICSMM/)  {
    $icsm_ackcnt = $rg_data;
    $ret_msg = sprintf "\n ICSMM field:  Acknowledge Count:  0x%03X  \n", $icsm_ackcnt;
  }

  if ($rg_name =~ /ICSMH/)  {
    my $get_dnet_cmd = 0;
    $icsm_exc 	   = ($rg_data >> 10) & 0x1f;
    $icsm_imsgtype = ($rg_data >> 32) & 3;
    $icsm_imsg     = ($rg_data >> 24) & 0xff;
    $ioq_rq_depth  = ($rg_data >> 45) & 0xf;
    $ioq_rp_depth  = ($rg_data >> 39) & 0x3f;

  #  Decode some of the values into a more human-readable form

    if ($icsm_imsgtype == 0)  {
      $icsm_imsgtype = "XTALK";  }
    elsif ($icsm_imsgtype == 1)  {
      $icsm_imsgtype = "II"; }
    elsif ($icsm_imsgtype == 2)  {
      $get_dnet_cmd = 1;
      $icsm_imsgtype = "SHUB"; }
    elsif ($icsm_imsgtype == 3)  {
      $icsm_imsgtype = "CRB"; }

    if ($get_dnet_cmd == 1)  {
      my $dnet_offset = $icsm_imsg;
      $icsm_imsg = "$duplonet_command_list[$dnet_offset]";
    }
    else  {
      $icsm_imsg = sprintf ("0x%X      ", $icsm_imsg);
    }

    if ($icsm_exc == 0 ) {
      $icsm_exc = "PRDC"; }
    elsif ($icsm_exc == 1 ) {
      $icsm_exc = "BLKRD"; }
    elsif ($icsm_exc == 2 ) {
      $icsm_exc = "RSVD"; }
    elsif ($icsm_exc == 3 ) {
      $icsm_exc = "EJPND"; }
    elsif ($icsm_exc == 4 ) {
      $icsm_exc = "GETF"; }
    elsif ($icsm_exc == 5 ) {
      $icsm_exc = "REXU"; }
    elsif ($icsm_exc == 6 ) {
      $icsm_exc = "RDEXC"; }
    elsif ($icsm_exc == 7 ) {
      $icsm_exc = " PUT"; }
    elsif ($icsm_exc == 8 ) {
      $icsm_exc = "PRDI"; }
    elsif ($icsm_exc == 9 ) {
      $icsm_exc = "PWRI"; }
    elsif ($icsm_exc == 10 ) {
      $icsm_exc = "WRBK"; }
    elsif ($icsm_exc == 11 ) {
      $icsm_exc = "RSVD"; }
    else {
      $icsm_exc = sprintf ("0x%02X", $icsm_exc);
    }
    $ret_msg = sprintf "\n ICSMH fields:\tRequest type     : %s \n\t\tIncoming Message : %s \n\t\tSource of Imsg   : %s \n\t\tIOQ_RQ           : 0x%X \n\t\tIOQ_RP           : 0x%X\n", 
 	$icsm_exc, $icsm_imsg, $icsm_imsgtype, $ioq_rq_depth, $ioq_rp_depth ;
  }
  
  return($ret_msg);

}

#-------------------------------------------------------------------------------
#
#  ii_crb_display
#
#	Outputs the CRB reg's saved @crb_reg_words hash.
#  
#-------------------------------------------------------------------------------

sub ii_crb_display
{

  my $crb_msg = sprintf "\n\n   II CRB Information for NASID: 0x%04X\n\n", $nasid_value;
  $crb_msg .= sprintf "\nCRB IOW VLD ADDR            TNUM  SIDN XTERR MARK LNUCE ECODE ERR STLB0 STLB1 STLIL STLIB INTVN WB HOLD TOCNT TVLD CNTXT CVLD";
  $crb_msg .= sprintf "\n--- --- --- -------------   ----  ---- ----- ---- ----- ----- --- ----- ----- ----- ----- ----- -- ---- ----- ---- ----- ----\n";

  my $crb_num = 0;
  while (defined  $crb_reg_words[$crb_num])  {

    $crb_msg .= sprintf " %X   %x  %x   0x%012llX  0x%02X  0x%X    %x    %x     %x   %-5s  %x    %x     %x     %x     %x     %x   %x   %x   0x%02x   %x   0x%04x  %x\n",
        $crb_num, 
	$crb_reg_words[$crb_num]{IOW},
        $crb_reg_words[$crb_num]{VLD},
        $crb_reg_words[$crb_num]{ADDR},
        $crb_reg_words[$crb_num]{TNUM},
        $crb_reg_words[$crb_num]{SIDN},
        $crb_reg_words[$crb_num]{XTERR},
        $crb_reg_words[$crb_num]{MARK},
        $crb_reg_words[$crb_num]{LNUCE},
        $crb_reg_words[$crb_num]{ECODE},
        $crb_reg_words[$crb_num]{ERROR},
        $crb_reg_words[$crb_num]{STLB0},
        $crb_reg_words[$crb_num]{STLB1},
        $crb_reg_words[$crb_num]{STLIL},
        $crb_reg_words[$crb_num]{STLIB},
        $crb_reg_words[$crb_num]{INTVN},
        $crb_reg_words[$crb_num]{WB},
        $crb_reg_words[$crb_num]{HOLD},
        $crb_reg_words[$crb_num]{TOCNT},
        $crb_reg_words[$crb_num]{TVLD},
        $crb_reg_words[$crb_num]{CNTXT},
        $crb_reg_words[$crb_num]{CVLD};

    $crb_num++;
  }

  $crb_msg .= sprintf "\n\nCRB ACK RSP AKCNT  EXC  INIT  IMSG       IMTP  UOLD SRC   SIZE CT BTENUM GBR RSPRQ BROP SUPPL PushAddr_BE  BTE_OP PRPSC PRCNT SLP\n";  
  $crb_msg .= sprintf     "--- --- --- -----  ---  ----  ----       ----  ---- ----  ---- -- ------ --- ----- ---- ----- ------------ ------ ----- ----- ---\n";

  $crb_num = 0;
  while (defined  $crb_reg_words[$crb_num])  {

    $crb_msg .= sprintf " %X   %x   %x  0x%03X %-4s %-5s %-10s %-5s  %x  0x%04X %-4s  %x   %x     %x    %x    %x   0x%04X 0x%011x  %x     %x     %x    %x\n",
        $crb_num,
        $crb_reg_words[$crb_num]{ACK},
        $crb_reg_words[$crb_num]{RESP},
        $crb_reg_words[$crb_num]{AKCNT},
        $crb_reg_words[$crb_num]{EXCL},
        $crb_reg_words[$crb_num]{INIT},
        $crb_reg_words[$crb_num]{IMSG},
        $crb_reg_words[$crb_num]{IMTP},
        $crb_reg_words[$crb_num]{UOLD},
        $crb_reg_words[$crb_num]{SRC},
        $crb_reg_words[$crb_num]{SIZE},
        $crb_reg_words[$crb_num]{CT},
        $crb_reg_words[$crb_num]{BTENM},
        $crb_reg_words[$crb_num]{GBR},
        $crb_reg_words[$crb_num]{RSPRQ},
        $crb_reg_words[$crb_num]{BROP},
        $crb_reg_words[$crb_num]{SUPPL},
        $crb_reg_words[$crb_num]{PA_BE},
        $crb_reg_words[$crb_num]{BTEOP},
        $crb_reg_words[$crb_num]{PRPSC},
        $crb_reg_words[$crb_num]{PRCNT},
        $crb_reg_words[$crb_num]{SLEEP};

    $crb_num++;
  }
 
  return ($crb_msg);
}

#-------------------------------------------------------------------------------
#
#  ii_reg_chk subroutine
#
#	Verifies the contents of II registers do or don't contain errors
#	
#  return value:
#	0 = no errors
#	1 = error detected
#  
#-------------------------------------------------------------------------------

sub ii_reg_chk
{
  my $rg_name = "$_[0]";
  my $rg_val  = $_[1];

  my $ret_val = 0;
 
	#  Is the II cabled to a IO brick?
  if (($rg_name =~ /WCR/) && ((($rg_val & 0xf) == 0xa ) || (($rg_val & 0xf) == 0xb )))	 {
    $target_list[$t_cnt]->{IO_PRESENT} = 1;
  }
 
	#  Was a spurious message detected?
  if (($rg_name =~ /ICMR/) && (($rg_val & 1) == 1)) {
    $target_list[$t_cnt]->{SPUR_MSG} = 1;
  }

  if (($rg_name =~ /IEPH1/) && ((($rg_val >> 50) & 1) > 0)) {
    $target_list[$t_cnt]->{INC_ERR} = 1;
  }

       #  Get the PIO read response timeout value
  if ($rg_name =~ /IXTT/)  {
    $target_list[$t_cnt]->{IXTT_TO_VAL} = ($rg_val >> 55) & 0x1f;
    return $ret_val;
  }

  if (     (($rg_name =~ /IWEL/)  && ($rg_val != 0)) 				#  Any bit set in IWEL
	|| (($rg_name =~ /ICMR/)  && (($rg_val & 0x3fff800000001) > 0))		#  Spurious or any Mark bit set
	|| (($rg_name =~ /IEPH1/) && ((($rg_val >> 50) & 1) > 0))		#  Error packet from shub
	|| (($rg_name =~ /IDSR/)  && ((($rg_val >> 28) & 1) > 0))		#  Interrupt sent & not cleared
	|| (($rg_name =~ /IPRB/)  && ((($rg_val >> 48) & 0x800f) > 0))		#  any PRB error
	|| (($rg_name =~ /IIDEM/) && ($rg_val != 0xFFFFFFFFFFFFFFFF))		#  Any device on any widget that's been shut down
	|| (($rg_name =~ /IIWA/)  && ($rg_val != 0xff01))			#  Any widget that's been shut down
	|| (($rg_name =~ /IOWA/)  && ($rg_val != 0xff01))			#  Any widget that's been shut down
	|| (($rg_name =~ /IBLS/)  && ((($rg_val >> 16) & 1) > 0))		#  BTE Error bit
	|| (($rg_name =~ /WSTAT/) && ((($rg_val >> 32) & 1) > 0))		#  Crazy Bit in Widget status reg
        || (($rg_name =~ /ICSM/)  && (defined ($target_list[$t_cnt]->{SPUR_MSG})))  #  Spurious Message Detail is valid
        || (($rg_name =~ /IEPH2/) && (defined ($target_list[$t_cnt]->{INC_ERR})))  #  Incoming error Message Detail is valid
	|| (($rg_name =~ /XB_STAT/) && (($rg_val & 0xbc80003f) > 0))		# Any Crossbow detected error
	|| (($rg_name =~ /XB_LINK_STAT/) && (($rg_val & 0x0007bce3) > 0))	# Any Crossbow Link error
	|| (($rg_name =~ /XB_LINK_AUX_STAT/) && ($get_xb_aux_stat == 1))	# Need to get Aux Link status
	|| (($rg_name =~ /ERR_INT_VIEW/) && ($rg_val != 0))			# Widget F PIC error on OPUS brick
	|| (($rg_name =~ /MULT_INT/) && ($rg_val != 0))				# Widget F PIC error overflow on OPUS brick
  )
  {
    $ret_val = 1;
    if ($verbose_mode == 1)  {
      printf "\n Found a problem with value in %s  : 0x%016llX\n", $rg_name, $rg_val; 
      if ($rg_name =~ /IIDEM/)  {
        my $compare_val = 0xffffffffffffffff;
        my $xor_diff = $compare_val ^ $rg_val;
        printf "       reg value : 0x%016llX \n", $rg_val;   
        printf "   compare value : 0x%016llX \n", $compare_val;   
        printf "  XOR diff value : 0x%016llX \n\n", $xor_diff;   
        my $math_diff = $compare_val - $rg_val;
        printf "\t  Mathematical difference:  0x%016llX\n", $math_diff;
        printf "\n The following comparisons to 0x%016llX are true:\n", $compare_val;
        if ($rg_val != $compare_val) {     printf "\t not equal to\n";   }
        if ($rg_val == $compare_val) {     printf "\t equal to\n";   }
        if ($rg_val > $compare_val) {     printf "\t greater than\n";   }
        if ($rg_val < $compare_val) {     printf "\t less than\n";   }
        if (($rg_val ^ $compare_val) == 0) {     printf "\t XOR equal 0\n";   }
        printf "\n\n";
  
        $compare_val = 0;
        printf "\n The following comparisons to 0 are true:\n";
        if ($rg_val != $compare_val) {     printf "\t not equal to\n";   }
        if ($rg_val == $compare_val) {     printf "\t equal to\n";   }
        if ($rg_val > $compare_val) {     printf "\t greater than\n";   }
        if ($rg_val < $compare_val) {     printf "\t less than\n";   }
        if (($rg_val ^ $compare_val) == 0) {     printf "\t XOR equal 0\n";   }
        printf "\n\n";
      }
    }
   
  }

  if (  ($rg_name =~ /PRTE..A/)  				#   PIO read response timeout in IPRTE?_A
     && ((($rg_val >> 58) & 0x1f) == $target_list[$t_cnt]->{IXTT_TO_VAL}))
  {
    $get_next_iprte_b = 1;
    $ret_val = 1;
  }

  if ( ($rg_name =~ /PRTE..B/) && ($get_next_iprte_b == 1) ) 
  {
    $ret_val = 1;
  }

  if ($target_list[$t_cnt]->{IO_PRESENT} == 1)  {
    if (   (($rg_name =~ /ILLR/)  && (($rg_val & 0xffff) > 100))		#  more than 100 SN errors from XTalk
	|| (($rg_name =~ /ILLR/)  && ((($rg_val >> 16) & 0xffff) > 100))	#  more than 100 CB errors from XTalk
	|| (($rg_name =~ /WSTAT/) && (($rg_val & 0xffffffff) > 0) ) 		#  LLP errors in Widget status reg
       )
    {
      $ret_val = 1;
    }
    if ( ($rg_name =~ /IXSS/) && ((($rg_val >> 63) & 1) > 0) )		#  Spurious Sideband from XTalk
    {
      $get_ixsm = 1;
      $ret_val = 1;
    }
   
    if ( ($rg_name =~ /IXSM/) && ($get_ixsm == 1) )
    {
      $ret_val = 1;
    }

  }

  return $ret_val;

}


sub disable_lb_int
{
  my $int_reg_val = $target_list[$t_cnt]->{LB_INT_REG_DATA} & 0xfffffff7;
  if ($verbose_mode == 1)  {
    printf "\nDisabling LB interrupts by writing 0x%X into 0x%X\n",
	$int_reg_val, $target_list[$t_cnt]->{LB_INT_REG_ADDR};
  }
  mmr_write($target_list[$t_cnt]->{LB_INT_REG_ADDR}, $int_reg_val);
  
}


sub enable_lb_int
{
  mmr_write($target_list[$t_cnt]->{LB_INT_REG_ADDR}, $target_list[$t_cnt]->{LB_INT_REG_DATA});
}

#--------------------------------------------------------------------
#
#  Function to add PIC Crossbow registers to the list of II registers
#  that will be read using packet injected MMR reads.  
#  In the Opus brick case, we will also read PIC mmrs since they aren't
#  accessable via jtag on Opus bricks.
#
#--------------------------------------------------------------------

sub add_xbow_regs
{
	#  Dump PIC registers on OPUS bricks

 if (defined $target_list[$t_cnt]->{OPUS})  {
   push (@final_ii_reg_list,
            "XB_ID",          			"0x0000000",
            "XB_STAT",        			"0x0000008",
            "XB_CTRL",        			"0x0000020",
            "XB_LLP_CTRL",    			"0x0000048",
            "XB_ERR_UPPER",   			"0x0000010",
            "XB_ERR_LOWER",   			"0x0000018",
            "XB_ERR_CMDWORD", 			"0x0000040",
            "XB_LINK_STAT_B", 			"0x00001D0",
            "XB_LINK_AUX_STAT_B", 		"0x00001F8",
            "XB_LINK_STAT_F", 			"0x00002D0",
            "XB_LINK_AUX_STAT_F", 		"0x00002F8",
            "XB_WO_RST_FNC",     		"0x0000078",
            "XB_LA_RST_FNC",     		"0x0000090",
            "XB_LB_RST_FNC",     		"0x0000098",
            "XB_LC_RST_FNC",     		"0x00000A0",
            "XB_LD_RST_FNC",     		"0x00000A8",
            "XB_LF_RST_FNC",     		"0x00000B8",
            "XB_LINK_CTRL_A",     		"0x0000188",
            "XB_LINK_CTRL_B",     		"0x00001C8",
            "XB_LINK_CTRL_C",     		"0x0000208",
            "XB_LINK_CTRL_D",     		"0x0000248",
            "XB_LINK_CTRL_F",     		"0x0000288",

	    "BUS0_BRIDGE_ID",	    		"0xF000000",
	    "BUS0_BRIDGE_STAT",     		"0xF000008",
	    "BUS0_BRIDGE_CTRL",     		"0xF000020",
	    "BUS0_ERR_INT_VIEW",    		"0xF000170",
	    "BUS0_INT_STATUS",     		"0xF000100",
	    "BUS0_MULT_INT",     		"0xF000178",
	    "BUS0_PCI_ERR_LOWER_ADDR",  	"0xF0000D8",
	    "BUS0_PCI_ERR_UPPER_ADDR",  	"0xF0000D0",
	    "BUS0_PCI_X_ERR_ADDR",      	"0xF000600",
	    "BUS0_PCI_X_ERR_ATTR",      	"0xF000608",
	    "BUS0_PCI_X_ERR_DATA",      	"0xF000610",
	    "BUS0_PCI_X_DMA_ERR_ATTR",  	"0xF000628",
	    "BUS0_PCI_X_DMA_ERR_ADDR",  	"0xF000630",
	    "BUS0_PCI_X_PIO_SPLIT_ERR_ADDR",  	"0xF000618",
	    "BUS0_PCI_X_PIO_SPLIT_ERR_ATTR",  	"0xF000620",
	    "BUS0_DEV0_REG",  	 		"0xF000200",
	    "BUS0_DEV1_REG",  	 		"0xF000208",
	    "BUS0_DEV2_REG",  	 		"0xF000210",
	    "BUS0_DEV3_REG",  	 		"0xF000218",

	    "BUS1_BRIDGE_ID",	    		"0xF800000",
	    "BUS1_BRIDGE_STAT",     		"0xF800008",
	    "BUS1_BRIDGE_CTRL",     		"0xF800020",
	    "BUS1_ERR_INT_VIEW",    		"0xF800170",
	    "BUS1_INT_STATUS",     		"0xF800100",
	    "BUS1_MULT_INT",     		"0xF800178",
	    "BUS1_PCI_ERR_LOWER_ADDR",  	"0xF8000D8",
	    "BUS1_PCI_ERR_UPPER_ADDR",  	"0xF8000D0",
	    "BUS1_PCI_X_ERR_ADDR",      	"0xF800600",
	    "BUS1_PCI_X_ERR_ATTR",      	"0xF800608",
	    "BUS1_PCI_X_ERR_DATA",      	"0xF800610",
	    "BUS1_PCI_X_DMA_ERR_ATTR",  	"0xF800628",
	    "BUS1_PCI_X_DMA_ERR_ADDR",  	"0xF800630",
	    "BUS1_PCI_X_PIO_SPLIT_ERR_ADDR",  	"0xF800618",
	    "BUS1_PCI_X_PIO_SPLIT_ERR_ATTR",  	"0xF800620",
	    "BUS1_DEV0_REG",  	 		"0xF800200",
	    "BUS1_DEV1_REG",  	 		"0xF800208",
	    "BUS1_DEV2_REG",  	 		"0xF800210",
	    "BUS1_DEV3_REG",  	 		"0xF800218"  
	);
  }
  else {
    push (@final_ii_reg_list,  
            "XB_ID",          			"0x0000000",
            "XB_STAT",        			"0x0000008",
            "XB_CTRL",        			"0x0000020",
            "XB_LLP_CTRL",    			"0x0000048",
            "XB_ERR_UPPER",   			"0x0000010",
            "XB_ERR_LOWER",   			"0x0000018",
            "XB_ERR_CMDWORD", 			"0x0000040",
            "XB_LINK_STAT_A", 			"0x0000190",
            "XB_LINK_AUX_STAT_A", 		"0x00001B8",
            "XB_LINK_STAT_B", 			"0x00001D0",
            "XB_LINK_AUX_STAT_B", 		"0x00001F8",
            "XB_LINK_STAT_C", 			"0x0000210",
            "XB_LINK_AUX_STAT_C", 		"0x0000238",
            "XB_LINK_STAT_D", 			"0x0000250",
            "XB_LINK_AUX_STAT_D", 		"0x0000278",
            "XB_LINK_STAT_F", 			"0x00002D0",
            "XB_LINK_AUX_STAT_F", 		"0x00002F8",
            "XB_WO_RST_FNC",     		"0x0000078",
            "XB_LA_RST_FNC",     		"0x0000090",
            "XB_LB_RST_FNC",     		"0x0000098",
            "XB_LC_RST_FNC",     		"0x00000A0",
            "XB_LD_RST_FNC",     		"0x00000A8",
            "XB_LF_RST_FNC",     		"0x00000B8",
            "XB_LINK_CTRL_A",     		"0x0000188",
            "XB_LINK_CTRL_B",     		"0x00001C8",
            "XB_LINK_CTRL_C",     		"0x0000208",
            "XB_LINK_CTRL_D",     		"0x0000248",
            "XB_LINK_CTRL_F",     		"0x0000288"
	);
  }

}


#--------------------------------------------------------------------
#
#  Function to decode PIC mmr values using superscope library PIC mmr defs.
#
#--------------------------------------------------------------------

sub pic_mmr_decode {

  my $mmr_name = "$_[0]";
  my $mmr_value = $_[1];
  my $shub_nasid = "$_[2]";
  my $notify = "$_[3]";

  my $reg_ptr = reg_create_mmr_inst("pic_01", $mmr_name);
  if ( !reg_is_valid($reg_ptr) )
  {  $emess = "Unable to create register instance: $mmr_name.\n";
    dsp_error_and_exit($emess);
  }
  reg_set_value ($reg_ptr, $mmr_value);

  my $return_string = lcl_reg_write_value($reg_ptr, 'valid', $shub_nasid, 0, $notify);
  return($return_string);
}


#-------------------------------------------------------------------------------

1;

