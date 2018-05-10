/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x8ef4fb42 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static unsigned int ng0[] = {0U, 0U};
static unsigned int ng1[] = {1U, 0U};



static void Gate_20_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;

LAB0:    t1 = (t0 + 2328U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = ((char*)((ng0)));
    t3 = (t0 + 1024U);
    t4 = *((char **)t3);
    t3 = (t0 + 4544);
    t5 = (t3 + 32U);
    t6 = *((char **)t5);
    t7 = (t6 + 40U);
    t8 = *((char **)t7);
    xsi_vlog_nmosSwitch(t8, t2, t4);
    t9 = (t0 + 4544);
    t10 = (t9 + 32U);
    xsi_vlog_switch_set_trans_strength(*((char **)t10), 0, 0, 0, 0);
    t11 = (t0 + 4544);
    xsi_driver_vfirst_trans_bufif_delayed(t11, 0, 0, 1LL, 0);
    t12 = (t0 + 4396);
    *((int *)t12) = 1;

LAB1:    return;
}

static void Gate_21_1(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;

LAB0:    t1 = (t0 + 2472U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = ((char*)((ng0)));
    t3 = (t0 + 1116U);
    t4 = *((char **)t3);
    t3 = (t0 + 4580);
    t5 = (t3 + 32U);
    t6 = *((char **)t5);
    t7 = (t6 + 40U);
    t8 = *((char **)t7);
    xsi_vlog_nmosSwitch(t8, t2, t4);
    t9 = (t0 + 4580);
    t10 = (t9 + 32U);
    xsi_vlog_switch_set_trans_strength(*((char **)t10), 0, 0, 0, 0);
    t11 = (t0 + 4580);
    xsi_driver_vfirst_trans_bufif_delayed(t11, 0, 0, 1LL, 0);
    t12 = (t0 + 4404);
    *((int *)t12) = 1;

LAB1:    return;
}

static void Gate_22_2(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;

LAB0:    t1 = (t0 + 2616U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = ((char*)((ng0)));
    t3 = (t0 + 932U);
    t4 = *((char **)t3);
    t3 = (t0 + 4616);
    t5 = (t3 + 32U);
    t6 = *((char **)t5);
    t7 = (t6 + 40U);
    t8 = *((char **)t7);
    xsi_vlog_nmosSwitch(t8, t2, t4);
    t9 = (t0 + 4616);
    t10 = (t9 + 32U);
    xsi_vlog_switch_set_trans_strength(*((char **)t10), 0, 0, 0, 0);
    t11 = (t0 + 4616);
    xsi_driver_vfirst_trans_bufif_delayed(t11, 0, 0, 1LL, 0);
    t12 = (t0 + 4412);
    *((int *)t12) = 1;

LAB1:    return;
}

static void Gate_23_3(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;

LAB0:    t1 = (t0 + 2760U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = ((char*)((ng0)));
    t3 = (t0 + 932U);
    t4 = *((char **)t3);
    t3 = (t0 + 4652);
    t5 = (t3 + 32U);
    t6 = *((char **)t5);
    t7 = (t6 + 40U);
    t8 = *((char **)t7);
    xsi_vlog_nmosSwitch(t8, t2, t4);
    t9 = (t0 + 4652);
    t10 = (t9 + 32U);
    xsi_vlog_switch_set_trans_strength(*((char **)t10), 0, 0, 0, 0);
    t11 = (t0 + 4652);
    xsi_driver_vfirst_trans_bufif_delayed(t11, 0, 0, 1LL, 0);
    t12 = (t0 + 4420);
    *((int *)t12) = 1;

LAB1:    return;
}

static void Gate_24_4(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;

LAB0:    t1 = (t0 + 2904U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 1208U);
    t3 = *((char **)t2);
    t2 = (t0 + 932U);
    t4 = *((char **)t2);
    t2 = (t0 + 4688);
    t5 = (t2 + 32U);
    t6 = *((char **)t5);
    t7 = (t6 + 40U);
    t8 = *((char **)t7);
    t9 = (t0 + 1184U);
    xsi_vlog_nmosSwitch_new(t8, t9, 0, 0, t4);
    t10 = (t0 + 4688);
    t11 = (t10 + 32U);
    t12 = (t0 + 1184U);
    xsi_vlog_switch_set_trans_strength(*((char **)t11), t12, 0, 0, 0);
    t13 = (t0 + 4688);
    xsi_driver_vfirst_trans_bufif_delayed(t13, 0, 0, 1LL, 0);
    t14 = (t0 + 4428);
    *((int *)t14) = 1;

LAB1:    return;
}

static void Gate_25_5(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;

LAB0:    t1 = (t0 + 3048U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = ((char*)((ng0)));
    t3 = (t0 + 932U);
    t4 = *((char **)t3);
    t3 = (t0 + 4724);
    t5 = (t3 + 32U);
    t6 = *((char **)t5);
    t7 = (t6 + 40U);
    t8 = *((char **)t7);
    xsi_vlog_nmosSwitch(t8, t2, t4);
    t9 = (t0 + 4724);
    t10 = (t9 + 32U);
    xsi_vlog_switch_set_trans_strength(*((char **)t10), 0, 0, 0, 0);
    t11 = (t0 + 4724);
    xsi_driver_vfirst_trans_bufif_delayed(t11, 0, 0, 1LL, 0);
    t12 = (t0 + 4436);
    *((int *)t12) = 1;

LAB1:    return;
}

static void Gate_26_6(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;

LAB0:    t1 = (t0 + 3192U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = ((char*)((ng1)));
    t3 = (t0 + 1024U);
    t4 = *((char **)t3);
    t3 = (t0 + 4760);
    t5 = (t3 + 32U);
    t6 = *((char **)t5);
    t7 = (t6 + 40U);
    t8 = *((char **)t7);
    xsi_vlog_pmosSwitch(t8, t2, t4);
    t9 = (t0 + 4760);
    t10 = (t9 + 32U);
    xsi_vlog_switch_set_trans_strength(*((char **)t10), 0, 0, 0, 0);
    t11 = (t0 + 4760);
    xsi_driver_vfirst_trans_bufif_delayed(t11, 0, 0, 1LL, 0);
    t12 = (t0 + 4444);
    *((int *)t12) = 1;

LAB1:    return;
}

static void Gate_27_7(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;

LAB0:    t1 = (t0 + 3336U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = ((char*)((ng1)));
    t3 = (t0 + 1116U);
    t4 = *((char **)t3);
    t3 = (t0 + 4796);
    t5 = (t3 + 32U);
    t6 = *((char **)t5);
    t7 = (t6 + 40U);
    t8 = *((char **)t7);
    xsi_vlog_pmosSwitch(t8, t2, t4);
    t9 = (t0 + 4796);
    t10 = (t9 + 32U);
    xsi_vlog_switch_set_trans_strength(*((char **)t10), 0, 0, 0, 0);
    t11 = (t0 + 4796);
    xsi_driver_vfirst_trans_bufif_delayed(t11, 0, 0, 1LL, 0);
    t12 = (t0 + 4452);
    *((int *)t12) = 1;

LAB1:    return;
}

static void Gate_28_8(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;

LAB0:    t1 = (t0 + 3480U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = ((char*)((ng1)));
    t3 = (t0 + 932U);
    t4 = *((char **)t3);
    t3 = (t0 + 4832);
    t5 = (t3 + 32U);
    t6 = *((char **)t5);
    t7 = (t6 + 40U);
    t8 = *((char **)t7);
    xsi_vlog_pmosSwitch(t8, t2, t4);
    t9 = (t0 + 4832);
    t10 = (t9 + 32U);
    xsi_vlog_switch_set_trans_strength(*((char **)t10), 0, 0, 0, 0);
    t11 = (t0 + 4832);
    xsi_driver_vfirst_trans_bufif_delayed(t11, 0, 0, 1LL, 0);
    t12 = (t0 + 4460);
    *((int *)t12) = 1;

LAB1:    return;
}

static void Gate_29_9(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;

LAB0:    t1 = (t0 + 3624U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = ((char*)((ng1)));
    t3 = (t0 + 932U);
    t4 = *((char **)t3);
    t3 = (t0 + 4868);
    t5 = (t3 + 32U);
    t6 = *((char **)t5);
    t7 = (t6 + 40U);
    t8 = *((char **)t7);
    xsi_vlog_pmosSwitch(t8, t2, t4);
    t9 = (t0 + 4868);
    t10 = (t9 + 32U);
    xsi_vlog_switch_set_trans_strength(*((char **)t10), 0, 0, 0, 0);
    t11 = (t0 + 4868);
    xsi_driver_vfirst_trans_bufif_delayed(t11, 0, 0, 1LL, 0);
    t12 = (t0 + 4468);
    *((int *)t12) = 1;

LAB1:    return;
}

static void Gate_30_10(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;

LAB0:    t1 = (t0 + 3768U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = ((char*)((ng1)));
    t3 = (t0 + 932U);
    t4 = *((char **)t3);
    t3 = (t0 + 4904);
    t5 = (t3 + 32U);
    t6 = *((char **)t5);
    t7 = (t6 + 40U);
    t8 = *((char **)t7);
    xsi_vlog_pmosSwitch(t8, t2, t4);
    t9 = (t0 + 4904);
    t10 = (t9 + 32U);
    xsi_vlog_switch_set_trans_strength(*((char **)t10), 0, 0, 0, 0);
    t11 = (t0 + 4904);
    xsi_driver_vfirst_trans_bufif_delayed(t11, 0, 0, 1LL, 0);
    t12 = (t0 + 4476);
    *((int *)t12) = 1;

LAB1:    return;
}

static void Gate_31_11(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;

LAB0:    t1 = (t0 + 3912U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = ((char*)((ng1)));
    t3 = (t0 + 932U);
    t4 = *((char **)t3);
    t3 = (t0 + 4940);
    t5 = (t3 + 32U);
    t6 = *((char **)t5);
    t7 = (t6 + 40U);
    t8 = *((char **)t7);
    xsi_vlog_pmosSwitch(t8, t2, t4);
    t9 = (t0 + 4940);
    t10 = (t9 + 32U);
    xsi_vlog_switch_set_trans_strength(*((char **)t10), 0, 0, 0, 0);
    t11 = (t0 + 4940);
    xsi_driver_vfirst_trans_bufif_delayed(t11, 0, 0, 1LL, 0);
    t12 = (t0 + 4484);
    *((int *)t12) = 1;

LAB1:    return;
}

static void Gate_32_12(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;

LAB0:    t1 = (t0 + 4056U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 1484U);
    t3 = *((char **)t2);
    t2 = (t0 + 4976);
    t4 = (t2 + 32U);
    t5 = *((char **)t4);
    t6 = (t5 + 40U);
    t7 = *((char **)t6);
    xsi_vlog_notGate(t7, t3);
    t8 = (t0 + 4976);
    xsi_driver_vfirst_trans_delayed(t8, 0, 0, 1LL, 0);
    t9 = (t0 + 4492);
    *((int *)t9) = 1;

LAB1:    return;
}

static void Gate_33_13(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;

LAB0:    t1 = (t0 + 4200U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 1668U);
    t3 = *((char **)t2);
    t2 = (t0 + 5012);
    t4 = (t2 + 32U);
    t5 = *((char **)t4);
    t6 = (t5 + 40U);
    t7 = *((char **)t6);
    xsi_vlog_notGate(t7, t3);
    t8 = (t0 + 5012);
    xsi_driver_vfirst_trans_delayed(t8, 0, 0, 1LL, 0);
    t9 = (t0 + 4500);
    *((int *)t9) = 1;

LAB1:    return;
}


extern void secureip_m_00000000003326433569_3143510747_init()
{
	static char *pe[] = {(void *)Gate_20_0,(void *)Gate_21_1,(void *)Gate_22_2,(void *)Gate_23_3,(void *)Gate_24_4,(void *)Gate_25_5,(void *)Gate_26_6,(void *)Gate_27_7,(void *)Gate_28_8,(void *)Gate_29_9,(void *)Gate_30_10,(void *)Gate_31_11,(void *)Gate_32_12,(void *)Gate_33_13};
	xsi_register_didat("secureip_m_00000000003326433569_3143510747", "isim/colorBarGenerator_tb_isim_beh.exe.sim/secureip/m_00000000003326433569_3143510747.didat");
	xsi_register_executes(pe);
}
