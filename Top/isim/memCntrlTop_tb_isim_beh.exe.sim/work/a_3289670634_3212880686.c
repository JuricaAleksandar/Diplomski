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
static const char *ng0 = "D:/Diplomski/Top/vgaSync.vhd";
extern char *IEEE_P_3620187407;

unsigned char ieee_p_3620187407_sub_2546382208_3965413181(char *, char *, char *, int );
unsigned char ieee_p_3620187407_sub_2546418145_3965413181(char *, char *, char *, int );
unsigned char ieee_p_3620187407_sub_3908131327_3965413181(char *, char *, char *, int );
char *ieee_p_3620187407_sub_436279890_3965413181(char *, char *, char *, char *, int );


static void work_a_3289670634_3212880686_p_0(char *t0)
{
    char t29[16];
    char *t1;
    char *t2;
    unsigned char t3;
    unsigned char t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    unsigned char t11;
    unsigned char t12;
    int t13;
    int t14;
    int t15;
    int t16;
    int t17;
    char *t18;
    int t19;
    int t20;
    int t21;
    unsigned char t22;
    char *t23;
    char *t24;
    char *t25;
    char *t26;
    char *t27;
    char *t28;
    unsigned int t30;
    unsigned int t31;

LAB0:    xsi_set_current_line(62, ng0);
    t1 = (t0 + 684U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = (t3 == (unsigned char)2);
    if (t4 != 0)
        goto LAB2;

LAB4:    t1 = (t0 + 568U);
    t4 = xsi_signal_has_event(t1);
    if (t4 == 1)
        goto LAB7;

LAB8:    t3 = (unsigned char)0;

LAB9:    if (t3 != 0)
        goto LAB5;

LAB6:
LAB3:    t1 = (t0 + 4904);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(63, ng0);
    t1 = xsi_get_transient_memory(11U);
    memset(t1, 0, 11U);
    t5 = t1;
    memset(t5, (unsigned char)2, 11U);
    t6 = (t0 + 5028);
    t7 = (t6 + 32U);
    t8 = *((char **)t7);
    t9 = (t8 + 40U);
    t10 = *((char **)t9);
    memcpy(t10, t1, 11U);
    xsi_driver_first_trans_fast(t6);
    goto LAB3;

LAB5:    xsi_set_current_line(65, ng0);
    t2 = (t0 + 1328U);
    t6 = *((char **)t2);
    t2 = (t0 + 7880U);
    t7 = (t0 + 2236U);
    t8 = *((char **)t7);
    t13 = *((int *)t8);
    t7 = (t0 + 2304U);
    t9 = *((char **)t7);
    t14 = *((int *)t9);
    t15 = (t13 + t14);
    t7 = (t0 + 2372U);
    t10 = *((char **)t7);
    t16 = *((int *)t10);
    t17 = (t15 + t16);
    t7 = (t0 + 2440U);
    t18 = *((char **)t7);
    t19 = *((int *)t18);
    t20 = (t17 + t19);
    t21 = (t20 - 1);
    t22 = ieee_p_3620187407_sub_2546418145_3965413181(IEEE_P_3620187407, t6, t2, t21);
    if (t22 != 0)
        goto LAB10;

LAB12:    xsi_set_current_line(68, ng0);
    t1 = (t0 + 1328U);
    t2 = *((char **)t1);
    t1 = (t0 + 7880U);
    t5 = ieee_p_3620187407_sub_436279890_3965413181(IEEE_P_3620187407, t29, t2, t1, 1);
    t6 = (t29 + 12U);
    t30 = *((unsigned int *)t6);
    t31 = (1U * t30);
    t3 = (11U != t31);
    if (t3 == 1)
        goto LAB13;

LAB14:    t7 = (t0 + 5028);
    t8 = (t7 + 32U);
    t9 = *((char **)t8);
    t10 = (t9 + 40U);
    t18 = *((char **)t10);
    memcpy(t18, t5, 11U);
    xsi_driver_first_trans_fast(t7);

LAB11:    goto LAB3;

LAB7:    t2 = (t0 + 592U);
    t5 = *((char **)t2);
    t11 = *((unsigned char *)t5);
    t12 = (t11 == (unsigned char)3);
    t3 = t12;
    goto LAB9;

LAB10:    xsi_set_current_line(66, ng0);
    t7 = xsi_get_transient_memory(11U);
    memset(t7, 0, 11U);
    t23 = t7;
    memset(t23, (unsigned char)2, 11U);
    t24 = (t0 + 5028);
    t25 = (t24 + 32U);
    t26 = *((char **)t25);
    t27 = (t26 + 40U);
    t28 = *((char **)t27);
    memcpy(t28, t7, 11U);
    xsi_driver_first_trans_fast(t24);
    goto LAB11;

LAB13:    xsi_size_not_matching(11U, t31, 0);
    goto LAB14;

}

static void work_a_3289670634_3212880686_p_1(char *t0)
{
    char t23[16];
    char *t1;
    char *t2;
    unsigned char t3;
    unsigned char t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    unsigned char t11;
    unsigned char t12;
    int t13;
    int t14;
    int t15;
    int t16;
    int t17;
    char *t18;
    int t19;
    int t20;
    int t21;
    unsigned char t22;
    char *t24;
    char *t25;
    char *t26;
    unsigned int t27;
    unsigned int t28;
    unsigned char t29;
    char *t30;
    char *t31;
    char *t32;
    char *t33;
    char *t34;

LAB0:    xsi_set_current_line(74, ng0);
    t1 = (t0 + 684U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = (t3 == (unsigned char)2);
    if (t4 != 0)
        goto LAB2;

LAB4:    t1 = (t0 + 568U);
    t4 = xsi_signal_has_event(t1);
    if (t4 == 1)
        goto LAB7;

LAB8:    t3 = (unsigned char)0;

LAB9:    if (t3 != 0)
        goto LAB5;

LAB6:
LAB3:    t1 = (t0 + 4912);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(75, ng0);
    t1 = xsi_get_transient_memory(11U);
    memset(t1, 0, 11U);
    t5 = t1;
    memset(t5, (unsigned char)2, 11U);
    t6 = (t0 + 5064);
    t7 = (t6 + 32U);
    t8 = *((char **)t7);
    t9 = (t8 + 40U);
    t10 = *((char **)t9);
    memcpy(t10, t1, 11U);
    xsi_driver_first_trans_fast(t6);
    goto LAB3;

LAB5:    xsi_set_current_line(77, ng0);
    t2 = (t0 + 1328U);
    t6 = *((char **)t2);
    t2 = (t0 + 7880U);
    t7 = (t0 + 2236U);
    t8 = *((char **)t7);
    t13 = *((int *)t8);
    t7 = (t0 + 2304U);
    t9 = *((char **)t7);
    t14 = *((int *)t9);
    t15 = (t13 + t14);
    t7 = (t0 + 2372U);
    t10 = *((char **)t7);
    t16 = *((int *)t10);
    t17 = (t15 + t16);
    t7 = (t0 + 2440U);
    t18 = *((char **)t7);
    t19 = *((int *)t18);
    t20 = (t17 + t19);
    t21 = (t20 - 1);
    t22 = ieee_p_3620187407_sub_2546418145_3965413181(IEEE_P_3620187407, t6, t2, t21);
    if (t22 != 0)
        goto LAB10;

LAB12:    t1 = (t0 + 1512U);
    t2 = *((char **)t1);
    t1 = (t0 + 7896U);
    t5 = (t0 + 2508U);
    t6 = *((char **)t5);
    t13 = *((int *)t6);
    t5 = (t0 + 2576U);
    t7 = *((char **)t5);
    t14 = *((int *)t7);
    t15 = (t13 + t14);
    t5 = (t0 + 2644U);
    t8 = *((char **)t5);
    t16 = *((int *)t8);
    t17 = (t15 + t16);
    t5 = (t0 + 2712U);
    t9 = *((char **)t5);
    t19 = *((int *)t9);
    t20 = (t17 + t19);
    t21 = (t20 - 1);
    t3 = ieee_p_3620187407_sub_2546418145_3965413181(IEEE_P_3620187407, t2, t1, t21);
    if (t3 != 0)
        goto LAB15;

LAB16:
LAB11:    goto LAB3;

LAB7:    t2 = (t0 + 592U);
    t5 = *((char **)t2);
    t11 = *((unsigned char *)t5);
    t12 = (t11 == (unsigned char)3);
    t3 = t12;
    goto LAB9;

LAB10:    xsi_set_current_line(78, ng0);
    t7 = (t0 + 1512U);
    t24 = *((char **)t7);
    t7 = (t0 + 7896U);
    t25 = ieee_p_3620187407_sub_436279890_3965413181(IEEE_P_3620187407, t23, t24, t7, 1);
    t26 = (t23 + 12U);
    t27 = *((unsigned int *)t26);
    t28 = (1U * t27);
    t29 = (11U != t28);
    if (t29 == 1)
        goto LAB13;

LAB14:    t30 = (t0 + 5064);
    t31 = (t30 + 32U);
    t32 = *((char **)t31);
    t33 = (t32 + 40U);
    t34 = *((char **)t33);
    memcpy(t34, t25, 11U);
    xsi_driver_first_trans_fast(t30);
    goto LAB11;

LAB13:    xsi_size_not_matching(11U, t28, 0);
    goto LAB14;

LAB15:    xsi_set_current_line(80, ng0);
    t5 = xsi_get_transient_memory(11U);
    memset(t5, 0, 11U);
    t10 = t5;
    memset(t10, (unsigned char)2, 11U);
    t18 = (t0 + 5064);
    t24 = (t18 + 32U);
    t25 = *((char **)t24);
    t26 = (t25 + 40U);
    t30 = *((char **)t26);
    memcpy(t30, t5, 11U);
    xsi_driver_first_trans_fast(t18);
    goto LAB11;

}

static void work_a_3289670634_3212880686_p_2(char *t0)
{
    unsigned char t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    int t6;
    char *t7;
    int t8;
    int t9;
    unsigned char t10;
    char *t11;
    char *t12;
    char *t13;
    int t14;
    char *t15;
    int t16;
    int t17;
    char *t18;
    int t19;
    int t20;
    unsigned char t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    char *t26;
    char *t27;
    char *t28;
    char *t29;
    char *t30;
    char *t31;

LAB0:    xsi_set_current_line(85, ng0);
    t2 = (t0 + 1328U);
    t3 = *((char **)t2);
    t2 = (t0 + 7880U);
    t4 = (t0 + 2236U);
    t5 = *((char **)t4);
    t6 = *((int *)t5);
    t4 = (t0 + 2304U);
    t7 = *((char **)t4);
    t8 = *((int *)t7);
    t9 = (t6 + t8);
    t10 = ieee_p_3620187407_sub_3908131327_3965413181(IEEE_P_3620187407, t3, t2, t9);
    if (t10 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB3;

LAB4:
LAB8:    t26 = (t0 + 5100);
    t27 = (t26 + 32U);
    t28 = *((char **)t27);
    t29 = (t28 + 40U);
    t30 = *((char **)t29);
    *((unsigned char *)t30) = (unsigned char)3;
    xsi_driver_first_trans_fast(t26);

LAB2:    t31 = (t0 + 4920);
    *((int *)t31) = 1;

LAB1:    return;
LAB3:    t12 = (t0 + 5100);
    t22 = (t12 + 32U);
    t23 = *((char **)t22);
    t24 = (t23 + 40U);
    t25 = *((char **)t24);
    *((unsigned char *)t25) = (unsigned char)2;
    xsi_driver_first_trans_fast(t12);
    goto LAB2;

LAB5:    t4 = (t0 + 1328U);
    t11 = *((char **)t4);
    t4 = (t0 + 7880U);
    t12 = (t0 + 2236U);
    t13 = *((char **)t12);
    t14 = *((int *)t13);
    t12 = (t0 + 2304U);
    t15 = *((char **)t12);
    t16 = *((int *)t15);
    t17 = (t14 + t16);
    t12 = (t0 + 2440U);
    t18 = *((char **)t12);
    t19 = *((int *)t18);
    t20 = (t17 + t19);
    t21 = ieee_p_3620187407_sub_2546382208_3965413181(IEEE_P_3620187407, t11, t4, t20);
    t1 = t21;
    goto LAB7;

LAB9:    goto LAB2;

}

static void work_a_3289670634_3212880686_p_3(char *t0)
{
    unsigned char t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    int t6;
    char *t7;
    int t8;
    int t9;
    unsigned char t10;
    char *t11;
    char *t12;
    char *t13;
    int t14;
    char *t15;
    int t16;
    int t17;
    char *t18;
    int t19;
    int t20;
    unsigned char t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    char *t26;
    char *t27;
    char *t28;
    char *t29;
    char *t30;
    char *t31;

LAB0:    xsi_set_current_line(88, ng0);
    t2 = (t0 + 1512U);
    t3 = *((char **)t2);
    t2 = (t0 + 7896U);
    t4 = (t0 + 2508U);
    t5 = *((char **)t4);
    t6 = *((int *)t5);
    t4 = (t0 + 2576U);
    t7 = *((char **)t4);
    t8 = *((int *)t7);
    t9 = (t6 + t8);
    t10 = ieee_p_3620187407_sub_3908131327_3965413181(IEEE_P_3620187407, t3, t2, t9);
    if (t10 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB3;

LAB4:
LAB8:    t26 = (t0 + 5136);
    t27 = (t26 + 32U);
    t28 = *((char **)t27);
    t29 = (t28 + 40U);
    t30 = *((char **)t29);
    *((unsigned char *)t30) = (unsigned char)3;
    xsi_driver_first_trans_fast(t26);

LAB2:    t31 = (t0 + 4928);
    *((int *)t31) = 1;

LAB1:    return;
LAB3:    t12 = (t0 + 5136);
    t22 = (t12 + 32U);
    t23 = *((char **)t22);
    t24 = (t23 + 40U);
    t25 = *((char **)t24);
    *((unsigned char *)t25) = (unsigned char)2;
    xsi_driver_first_trans_fast(t12);
    goto LAB2;

LAB5:    t4 = (t0 + 1512U);
    t11 = *((char **)t4);
    t4 = (t0 + 7896U);
    t12 = (t0 + 2508U);
    t13 = *((char **)t12);
    t14 = *((int *)t13);
    t12 = (t0 + 2576U);
    t15 = *((char **)t12);
    t16 = *((int *)t15);
    t17 = (t14 + t16);
    t12 = (t0 + 2712U);
    t18 = *((char **)t12);
    t19 = *((int *)t18);
    t20 = (t17 + t19);
    t21 = ieee_p_3620187407_sub_2546382208_3965413181(IEEE_P_3620187407, t11, t4, t20);
    t1 = t21;
    goto LAB7;

LAB9:    goto LAB2;

}

static void work_a_3289670634_3212880686_p_4(char *t0)
{
    unsigned char t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    int t6;
    unsigned char t7;
    char *t8;
    char *t9;
    char *t10;
    int t11;
    unsigned char t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;
    char *t20;
    char *t21;
    char *t22;

LAB0:    xsi_set_current_line(91, ng0);
    t2 = (t0 + 1328U);
    t3 = *((char **)t2);
    t2 = (t0 + 7880U);
    t4 = (t0 + 2236U);
    t5 = *((char **)t4);
    t6 = *((int *)t5);
    t7 = ieee_p_3620187407_sub_2546382208_3965413181(IEEE_P_3620187407, t3, t2, t6);
    if (t7 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB3;

LAB4:
LAB8:    t17 = (t0 + 5172);
    t18 = (t17 + 32U);
    t19 = *((char **)t18);
    t20 = (t19 + 40U);
    t21 = *((char **)t20);
    *((unsigned char *)t21) = (unsigned char)2;
    xsi_driver_first_trans_fast(t17);

LAB2:    t22 = (t0 + 4936);
    *((int *)t22) = 1;

LAB1:    return;
LAB3:    t9 = (t0 + 5172);
    t13 = (t9 + 32U);
    t14 = *((char **)t13);
    t15 = (t14 + 40U);
    t16 = *((char **)t15);
    *((unsigned char *)t16) = (unsigned char)3;
    xsi_driver_first_trans_fast(t9);
    goto LAB2;

LAB5:    t4 = (t0 + 1512U);
    t8 = *((char **)t4);
    t4 = (t0 + 7896U);
    t9 = (t0 + 2508U);
    t10 = *((char **)t9);
    t11 = *((int *)t10);
    t12 = ieee_p_3620187407_sub_2546382208_3965413181(IEEE_P_3620187407, t8, t4, t11);
    t1 = t12;
    goto LAB7;

LAB9:    goto LAB2;

}

static void work_a_3289670634_3212880686_p_5(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    unsigned char t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    unsigned char t11;
    unsigned char t12;

LAB0:    xsi_set_current_line(95, ng0);
    t1 = (t0 + 684U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = (t3 == (unsigned char)2);
    if (t4 != 0)
        goto LAB2;

LAB4:    t1 = (t0 + 568U);
    t4 = xsi_signal_has_event(t1);
    if (t4 == 1)
        goto LAB7;

LAB8:    t3 = (unsigned char)0;

LAB9:    if (t3 != 0)
        goto LAB5;

LAB6:
LAB3:    t1 = (t0 + 4944);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(96, ng0);
    t1 = xsi_get_transient_memory(11U);
    memset(t1, 0, 11U);
    t5 = t1;
    memset(t5, (unsigned char)2, 11U);
    t6 = (t0 + 5208);
    t7 = (t6 + 32U);
    t8 = *((char **)t7);
    t9 = (t8 + 40U);
    t10 = *((char **)t9);
    memcpy(t10, t1, 11U);
    xsi_driver_first_trans_fast(t6);
    xsi_set_current_line(97, ng0);
    t1 = xsi_get_transient_memory(11U);
    memset(t1, 0, 11U);
    t2 = t1;
    memset(t2, (unsigned char)2, 11U);
    t5 = (t0 + 5244);
    t6 = (t5 + 32U);
    t7 = *((char **)t6);
    t8 = (t7 + 40U);
    t9 = *((char **)t8);
    memcpy(t9, t1, 11U);
    xsi_driver_first_trans_fast(t5);
    xsi_set_current_line(98, ng0);
    t1 = (t0 + 5280);
    t2 = (t1 + 32U);
    t5 = *((char **)t2);
    t6 = (t5 + 40U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = (unsigned char)3;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(99, ng0);
    t1 = (t0 + 5316);
    t2 = (t1 + 32U);
    t5 = *((char **)t2);
    t6 = (t5 + 40U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = (unsigned char)3;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(100, ng0);
    t1 = (t0 + 5352);
    t2 = (t1 + 32U);
    t5 = *((char **)t2);
    t6 = (t5 + 40U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = (unsigned char)2;
    xsi_driver_first_trans_fast(t1);
    goto LAB3;

LAB5:    xsi_set_current_line(102, ng0);
    t2 = (t0 + 1328U);
    t6 = *((char **)t2);
    t2 = (t0 + 5208);
    t7 = (t2 + 32U);
    t8 = *((char **)t7);
    t9 = (t8 + 40U);
    t10 = *((char **)t9);
    memcpy(t10, t6, 11U);
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(103, ng0);
    t1 = (t0 + 1512U);
    t2 = *((char **)t1);
    t1 = (t0 + 5244);
    t5 = (t1 + 32U);
    t6 = *((char **)t5);
    t7 = (t6 + 40U);
    t8 = *((char **)t7);
    memcpy(t8, t2, 11U);
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(104, ng0);
    t1 = (t0 + 1696U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t1 = (t0 + 5280);
    t5 = (t1 + 32U);
    t6 = *((char **)t5);
    t7 = (t6 + 40U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = t3;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(105, ng0);
    t1 = (t0 + 1880U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t1 = (t0 + 5316);
    t5 = (t1 + 32U);
    t6 = *((char **)t5);
    t7 = (t6 + 40U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = t3;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(106, ng0);
    t1 = (t0 + 2064U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t1 = (t0 + 5352);
    t5 = (t1 + 32U);
    t6 = *((char **)t5);
    t7 = (t6 + 40U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = t3;
    xsi_driver_first_trans_fast(t1);
    goto LAB3;

LAB7:    t2 = (t0 + 592U);
    t5 = *((char **)t2);
    t11 = *((unsigned char *)t5);
    t12 = (t11 == (unsigned char)3);
    t3 = t12;
    goto LAB9;

}

static void work_a_3289670634_3212880686_p_6(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:    xsi_set_current_line(110, ng0);

LAB3:    t1 = (t0 + 1236U);
    t2 = *((char **)t1);
    t1 = (t0 + 5388);
    t3 = (t1 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 40U);
    t6 = *((char **)t5);
    memcpy(t6, t2, 11U);
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t7 = (t0 + 4952);
    *((int *)t7) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_3289670634_3212880686_p_7(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:    xsi_set_current_line(111, ng0);

LAB3:    t1 = (t0 + 1420U);
    t2 = *((char **)t1);
    t1 = (t0 + 5424);
    t3 = (t1 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 40U);
    t6 = *((char **)t5);
    memcpy(t6, t2, 11U);
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t7 = (t0 + 4960);
    *((int *)t7) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_3289670634_3212880686_p_8(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;

LAB0:    xsi_set_current_line(112, ng0);

LAB3:    t1 = (t0 + 1972U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t1 = (t0 + 5460);
    t4 = (t1 + 32U);
    t5 = *((char **)t4);
    t6 = (t5 + 40U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = t3;
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t8 = (t0 + 4968);
    *((int *)t8) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_3289670634_3212880686_p_9(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;

LAB0:    xsi_set_current_line(113, ng0);

LAB3:    t1 = (t0 + 1604U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t1 = (t0 + 5496);
    t4 = (t1 + 32U);
    t5 = *((char **)t4);
    t6 = (t5 + 40U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = t3;
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t8 = (t0 + 4976);
    *((int *)t8) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_3289670634_3212880686_p_10(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;

LAB0:    xsi_set_current_line(114, ng0);

LAB3:    t1 = (t0 + 1788U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t1 = (t0 + 5532);
    t4 = (t1 + 32U);
    t5 = *((char **)t4);
    t6 = (t5 + 40U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = t3;
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t8 = (t0 + 4984);
    *((int *)t8) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}


extern void work_a_3289670634_3212880686_init()
{
	static char *pe[] = {(void *)work_a_3289670634_3212880686_p_0,(void *)work_a_3289670634_3212880686_p_1,(void *)work_a_3289670634_3212880686_p_2,(void *)work_a_3289670634_3212880686_p_3,(void *)work_a_3289670634_3212880686_p_4,(void *)work_a_3289670634_3212880686_p_5,(void *)work_a_3289670634_3212880686_p_6,(void *)work_a_3289670634_3212880686_p_7,(void *)work_a_3289670634_3212880686_p_8,(void *)work_a_3289670634_3212880686_p_9,(void *)work_a_3289670634_3212880686_p_10};
	xsi_register_didat("work_a_3289670634_3212880686", "isim/memCntrlTop_tb_isim_beh.exe.sim/work/a_3289670634_3212880686.didat");
	xsi_register_executes(pe);
}
