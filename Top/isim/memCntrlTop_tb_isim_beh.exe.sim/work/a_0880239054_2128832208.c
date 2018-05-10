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
static const char *ng0 = "D:/Diplomski/Top/ipcore_dir/memControllerBlock/user_design/rtl/iodrp_controller.vhd";
extern char *IEEE_P_3620187407;
extern char *IEEE_P_2592010699;

unsigned char ieee_p_2592010699_sub_1605435078_503743352(char *, unsigned char , unsigned char );
unsigned char ieee_p_2592010699_sub_1690584930_503743352(char *, unsigned char );
unsigned char ieee_p_2592010699_sub_2545490612_503743352(char *, unsigned char , unsigned char );
char *ieee_p_3620187407_sub_767668596_3965413181(char *, char *, char *, char *, char *, char *);


static void work_a_0880239054_2128832208_p_0(char *t0)
{
    unsigned char t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    char *t8;
    char *t9;
    char *t10;
    unsigned char t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;

LAB0:    xsi_set_current_line(203, ng0);
    t2 = (t0 + 1304U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t2 = (t0 + 8456);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(204, ng0);
    t4 = (t0 + 2708U);
    t8 = *((char **)t4);
    t4 = (t0 + 18436U);
    t9 = (t0 + 3708U);
    t10 = *((char **)t9);
    t9 = (t0 + 17924U);
    t11 = ieee_std_logic_unsigned_equal_stdv_stdv(IEEE_P_3620187407, t8, t4, t10, t9);
    if (t11 != 0)
        goto LAB8;

LAB10:
LAB9:    goto LAB3;

LAB5:    t4 = (t0 + 1328U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    t1 = t7;
    goto LAB7;

LAB8:    xsi_set_current_line(205, ng0);
    t12 = (t0 + 592U);
    t13 = *((char **)t12);
    t12 = (t0 + 8620);
    t14 = (t12 + 32U);
    t15 = *((char **)t14);
    t16 = (t15 + 40U);
    t17 = *((char **)t16);
    memcpy(t17, t13, 8U);
    xsi_driver_first_trans_fast(t12);
    xsi_set_current_line(206, ng0);
    t2 = (t0 + 684U);
    t4 = *((char **)t2);
    t2 = (t0 + 8656);
    t5 = (t2 + 32U);
    t8 = *((char **)t5);
    t9 = (t8 + 40U);
    t10 = *((char **)t9);
    memcpy(t10, t4, 8U);
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(207, ng0);
    t2 = (t0 + 868U);
    t4 = *((char **)t2);
    t1 = *((unsigned char *)t4);
    t2 = (t0 + 8692);
    t5 = (t2 + 32U);
    t8 = *((char **)t5);
    t9 = (t8 + 40U);
    t10 = *((char **)t9);
    *((unsigned char *)t10) = t1;
    xsi_driver_first_trans_fast(t2);
    goto LAB9;

}

static void work_a_0880239054_2128832208_p_1(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    unsigned char t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;

LAB0:    xsi_set_current_line(213, ng0);
    t1 = (t0 + 2708U);
    t2 = *((char **)t1);
    t1 = (t0 + 18436U);
    t3 = (t0 + 3708U);
    t4 = *((char **)t3);
    t3 = (t0 + 17924U);
    t5 = ieee_std_logic_unsigned_equal_stdv_stdv(IEEE_P_3620187407, t2, t1, t4, t3);
    if (t5 != 0)
        goto LAB3;

LAB4:
LAB5:    t11 = (t0 + 8728);
    t12 = (t11 + 32U);
    t13 = *((char **)t12);
    t14 = (t13 + 40U);
    t15 = *((char **)t14);
    *((unsigned char *)t15) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t11);

LAB2:    t16 = (t0 + 8464);
    *((int *)t16) = 1;

LAB1:    return;
LAB3:    t6 = (t0 + 8728);
    t7 = (t6 + 32U);
    t8 = *((char **)t7);
    t9 = (t8 + 40U);
    t10 = *((char **)t9);
    *((unsigned char *)t10) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t6);
    goto LAB2;

LAB6:    goto LAB2;

}

static void work_a_0880239054_2128832208_p_2(char *t0)
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
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;

LAB0:    xsi_set_current_line(215, ng0);
    t1 = (t0 + 2248U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = (t3 == (unsigned char)3);
    if (t4 != 0)
        goto LAB3;

LAB4:
LAB5:    t10 = (t0 + 1972U);
    t11 = *((char **)t10);
    t10 = (t0 + 8764);
    t12 = (t10 + 32U);
    t13 = *((char **)t12);
    t14 = (t13 + 40U);
    t15 = *((char **)t14);
    memcpy(t15, t11, 8U);
    xsi_driver_first_trans_fast(t10);

LAB2:    t16 = (t0 + 8472);
    *((int *)t16) = 1;

LAB1:    return;
LAB3:    t1 = (t0 + 1880U);
    t5 = *((char **)t1);
    t1 = (t0 + 8764);
    t6 = (t1 + 32U);
    t7 = *((char **)t6);
    t8 = (t7 + 40U);
    t9 = *((char **)t8);
    memcpy(t9, t5, 8U);
    xsi_driver_first_trans_fast(t1);
    goto LAB2;

LAB6:    goto LAB2;

}

static void work_a_0880239054_2128832208_p_3(char *t0)
{
    char t20[16];
    char t21[16];
    unsigned char t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    char *t8;
    unsigned char t9;
    unsigned char t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    int t22;
    unsigned int t23;
    char *t24;

LAB0:    xsi_set_current_line(220, ng0);
    t2 = (t0 + 1304U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t2 = (t0 + 8480);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(221, ng0);
    t4 = (t0 + 1236U);
    t8 = *((char **)t4);
    t9 = *((unsigned char *)t8);
    t10 = (t9 == (unsigned char)3);
    if (t10 != 0)
        goto LAB8;

LAB10:    xsi_set_current_line(224, ng0);
    t2 = (t0 + 2156U);
    t4 = *((char **)t2);
    t1 = *((unsigned char *)t4);
    t3 = (t1 == (unsigned char)3);
    if (t3 != 0)
        goto LAB11;

LAB13:    xsi_set_current_line(227, ng0);
    t2 = (t0 + 1788U);
    t4 = *((char **)t2);
    t1 = *((unsigned char *)t4);
    t2 = (t0 + 2064U);
    t5 = *((char **)t2);
    t17 = (7 - 7);
    t18 = (t17 * 1U);
    t19 = (0 + t18);
    t2 = (t5 + t19);
    t11 = ((IEEE_P_2592010699) + 2332);
    t12 = (t21 + 0U);
    t13 = (t12 + 0U);
    *((int *)t13) = 7;
    t13 = (t12 + 4U);
    *((int *)t13) = 1;
    t13 = (t12 + 8U);
    *((int *)t13) = -1;
    t22 = (1 - 7);
    t23 = (t22 * -1);
    t23 = (t23 + 1);
    t13 = (t12 + 12U);
    *((unsigned int *)t13) = t23;
    t8 = xsi_base_array_concat(t8, t20, t11, (char)99, t1, (char)97, t2, t21, (char)101);
    t23 = (1U + 7U);
    t3 = (8U != t23);
    if (t3 == 1)
        goto LAB14;

LAB15:    t13 = (t0 + 8800);
    t14 = (t13 + 32U);
    t15 = *((char **)t14);
    t16 = (t15 + 40U);
    t24 = *((char **)t16);
    memcpy(t24, t8, 8U);
    xsi_driver_first_trans_fast(t13);

LAB12:
LAB9:    goto LAB3;

LAB5:    t4 = (t0 + 1328U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    t1 = t7;
    goto LAB7;

LAB8:    xsi_set_current_line(222, ng0);
    t4 = (t0 + 18962);
    t12 = (t0 + 8800);
    t13 = (t12 + 32U);
    t14 = *((char **)t13);
    t15 = (t14 + 40U);
    t16 = *((char **)t15);
    memcpy(t16, t4, 8U);
    xsi_driver_first_trans_fast(t12);
    goto LAB9;

LAB11:    xsi_set_current_line(225, ng0);
    t2 = (t0 + 2892U);
    t5 = *((char **)t2);
    t2 = (t0 + 8800);
    t8 = (t2 + 32U);
    t11 = *((char **)t8);
    t12 = (t11 + 40U);
    t13 = *((char **)t12);
    memcpy(t13, t5, 8U);
    xsi_driver_first_trans_fast(t2);
    goto LAB12;

LAB14:    xsi_size_not_matching(8U, t23, 0);
    goto LAB15;

}

static void work_a_0880239054_2128832208_p_4(char *t0)
{
    char t24[16];
    char t28[16];
    unsigned char t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    unsigned char t8;
    unsigned char t9;
    char *t10;
    char *t11;
    char *t12;
    unsigned char t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    unsigned char t18;
    char *t19;
    char *t20;
    unsigned char t21;
    unsigned char t22;
    unsigned char t23;
    char *t25;
    char *t26;
    char *t29;
    char *t30;
    int t31;
    unsigned int t32;
    char *t33;
    unsigned int t34;
    unsigned char t35;
    char *t36;
    char *t37;
    char *t38;
    char *t39;
    char *t40;

LAB0:    xsi_set_current_line(236, ng0);
    t2 = (t0 + 1304U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t2 = (t0 + 8488);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(237, ng0);
    t4 = (t0 + 2708U);
    t10 = *((char **)t4);
    t4 = (t0 + 18436U);
    t11 = (t0 + 3844U);
    t12 = *((char **)t11);
    t11 = (t0 + 17956U);
    t13 = ieee_std_logic_unsigned_equal_stdv_stdv(IEEE_P_3620187407, t10, t4, t12, t11);
    if (t13 == 1)
        goto LAB14;

LAB15:    t14 = (t0 + 2708U);
    t15 = *((char **)t14);
    t14 = (t0 + 18436U);
    t16 = (t0 + 4116U);
    t17 = *((char **)t16);
    t16 = (t0 + 18020U);
    t18 = ieee_std_logic_unsigned_equal_stdv_stdv(IEEE_P_3620187407, t15, t14, t17, t16);
    t9 = t18;

LAB16:    if (t9 == 1)
        goto LAB11;

LAB12:    t8 = (unsigned char)0;

LAB13:    if (t8 != 0)
        goto LAB8;

LAB10:    xsi_set_current_line(240, ng0);
    t2 = (t0 + 18973);
    t5 = (t0 + 8836);
    t10 = (t5 + 32U);
    t11 = *((char **)t10);
    t12 = (t11 + 40U);
    t14 = *((char **)t12);
    memcpy(t14, t2, 3U);
    xsi_driver_first_trans_fast(t5);

LAB9:    goto LAB3;

LAB5:    t4 = (t0 + 1328U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    t1 = t7;
    goto LAB7;

LAB8:    xsi_set_current_line(238, ng0);
    t19 = (t0 + 2340U);
    t25 = *((char **)t19);
    t19 = (t0 + 18420U);
    t26 = (t0 + 18970);
    t29 = (t28 + 0U);
    t30 = (t29 + 0U);
    *((int *)t30) = 0;
    t30 = (t29 + 4U);
    *((int *)t30) = 2;
    t30 = (t29 + 8U);
    *((int *)t30) = 1;
    t31 = (2 - 0);
    t32 = (t31 * 1);
    t32 = (t32 + 1);
    t30 = (t29 + 12U);
    *((unsigned int *)t30) = t32;
    t30 = ieee_p_3620187407_sub_767668596_3965413181(IEEE_P_3620187407, t24, t25, t19, t26, t28);
    t33 = (t24 + 12U);
    t32 = *((unsigned int *)t33);
    t34 = (1U * t32);
    t35 = (3U != t34);
    if (t35 == 1)
        goto LAB17;

LAB18:    t36 = (t0 + 8836);
    t37 = (t36 + 32U);
    t38 = *((char **)t37);
    t39 = (t38 + 40U);
    t40 = *((char **)t39);
    memcpy(t40, t30, 3U);
    xsi_driver_first_trans_fast(t36);
    goto LAB9;

LAB11:    t19 = (t0 + 1236U);
    t20 = *((char **)t19);
    t21 = *((unsigned char *)t20);
    t22 = ieee_p_2592010699_sub_1690584930_503743352(IEEE_P_2592010699, t21);
    t23 = (t22 == (unsigned char)3);
    t8 = t23;
    goto LAB13;

LAB14:    t9 = (unsigned char)1;
    goto LAB16;

LAB17:    xsi_size_not_matching(3U, t34, 0);
    goto LAB18;

}

static void work_a_0880239054_2128832208_p_5(char *t0)
{
    unsigned char t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    char *t8;
    unsigned char t9;
    unsigned char t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;

LAB0:    xsi_set_current_line(248, ng0);
    t2 = (t0 + 1304U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t2 = (t0 + 8496);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(249, ng0);
    t4 = (t0 + 1236U);
    t8 = *((char **)t4);
    t9 = *((unsigned char *)t8);
    t10 = (t9 == (unsigned char)3);
    if (t10 != 0)
        goto LAB8;

LAB10:    xsi_set_current_line(255, ng0);
    t2 = (t0 + 2708U);
    t4 = *((char **)t2);
    t2 = (t0 + 18436U);
    t5 = (t0 + 4184U);
    t8 = *((char **)t5);
    t5 = (t0 + 18036U);
    t1 = ieee_std_logic_unsigned_equal_stdv_stdv(IEEE_P_3620187407, t4, t2, t8, t5);
    if (t1 != 0)
        goto LAB11;

LAB13:
LAB12:
LAB9:    goto LAB3;

LAB5:    t4 = (t0 + 1328U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    t1 = t7;
    goto LAB7;

LAB8:    xsi_set_current_line(251, ng0);
    t4 = (t0 + 18976);
    t12 = (t0 + 8872);
    t13 = (t12 + 32U);
    t14 = *((char **)t13);
    t15 = (t14 + 40U);
    t16 = *((char **)t15);
    memcpy(t16, t4, 8U);
    xsi_driver_first_trans_fast_port(t12);
    goto LAB9;

LAB11:    xsi_set_current_line(258, ng0);
    t11 = (t0 + 2064U);
    t12 = *((char **)t11);
    t11 = (t0 + 8872);
    t13 = (t11 + 32U);
    t14 = *((char **)t13);
    t15 = (t14 + 40U);
    t16 = *((char **)t15);
    memcpy(t16, t12, 8U);
    xsi_driver_first_trans_fast_port(t11);
    goto LAB12;

}

static void work_a_0880239054_2128832208_p_6(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    unsigned char t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;

LAB0:    xsi_set_current_line(264, ng0);
    t1 = (t0 + 2708U);
    t2 = *((char **)t1);
    t1 = (t0 + 18436U);
    t3 = (t0 + 4184U);
    t4 = *((char **)t3);
    t3 = (t0 + 18036U);
    t5 = ieee_std_logic_unsigned_equal_stdv_stdv(IEEE_P_3620187407, t2, t1, t4, t3);
    if (t5 != 0)
        goto LAB3;

LAB4:
LAB5:    t11 = (t0 + 8908);
    t12 = (t11 + 32U);
    t13 = *((char **)t12);
    t14 = (t13 + 40U);
    t15 = *((char **)t14);
    *((unsigned char *)t15) = (unsigned char)2;
    xsi_driver_first_trans_fast(t11);

LAB2:    t16 = (t0 + 8504);
    *((int *)t16) = 1;

LAB1:    return;
LAB3:    t6 = (t0 + 8908);
    t7 = (t6 + 32U);
    t8 = *((char **)t7);
    t9 = (t8 + 40U);
    t10 = *((char **)t9);
    *((unsigned char *)t10) = (unsigned char)3;
    xsi_driver_first_trans_fast(t6);
    goto LAB2;

LAB6:    goto LAB2;

}

static void work_a_0880239054_2128832208_p_7(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    unsigned char t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;

LAB0:    xsi_set_current_line(265, ng0);
    t1 = (t0 + 2708U);
    t2 = *((char **)t1);
    t1 = (t0 + 18436U);
    t3 = (t0 + 3844U);
    t4 = *((char **)t3);
    t3 = (t0 + 17956U);
    t5 = ieee_std_logic_unsigned_equal_stdv_stdv(IEEE_P_3620187407, t2, t1, t4, t3);
    if (t5 != 0)
        goto LAB3;

LAB4:
LAB5:    t11 = (t0 + 8944);
    t12 = (t11 + 32U);
    t13 = *((char **)t12);
    t14 = (t13 + 40U);
    t15 = *((char **)t14);
    *((unsigned char *)t15) = (unsigned char)2;
    xsi_driver_first_trans_fast(t11);

LAB2:    t16 = (t0 + 8512);
    *((int *)t16) = 1;

LAB1:    return;
LAB3:    t6 = (t0 + 8944);
    t7 = (t6 + 32U);
    t8 = *((char **)t7);
    t9 = (t8 + 40U);
    t10 = *((char **)t9);
    *((unsigned char *)t10) = (unsigned char)3;
    xsi_driver_first_trans_fast(t6);
    goto LAB2;

LAB6:    goto LAB2;

}

static void work_a_0880239054_2128832208_p_8(char *t0)
{
    char t5[16];
    char *t1;
    char *t2;
    char *t3;
    char *t6;
    char *t7;
    int t8;
    unsigned int t9;
    unsigned char t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;
    char *t20;

LAB0:    xsi_set_current_line(266, ng0);
    t1 = (t0 + 2340U);
    t2 = *((char **)t1);
    t1 = (t0 + 18420U);
    t3 = (t0 + 18984);
    t6 = (t5 + 0U);
    t7 = (t6 + 0U);
    *((int *)t7) = 0;
    t7 = (t6 + 4U);
    *((int *)t7) = 2;
    t7 = (t6 + 8U);
    *((int *)t7) = 1;
    t8 = (2 - 0);
    t9 = (t8 * 1);
    t9 = (t9 + 1);
    t7 = (t6 + 12U);
    *((unsigned int *)t7) = t9;
    t10 = ieee_std_logic_unsigned_equal_stdv_stdv(IEEE_P_3620187407, t2, t1, t3, t5);
    if (t10 != 0)
        goto LAB3;

LAB4:
LAB5:    t15 = (t0 + 8980);
    t16 = (t15 + 32U);
    t17 = *((char **)t16);
    t18 = (t17 + 40U);
    t19 = *((char **)t18);
    *((unsigned char *)t19) = (unsigned char)2;
    xsi_driver_first_trans_fast(t15);

LAB2:    t20 = (t0 + 8520);
    *((int *)t20) = 1;

LAB1:    return;
LAB3:    t7 = (t0 + 8980);
    t11 = (t7 + 32U);
    t12 = *((char **)t11);
    t13 = (t12 + 40U);
    t14 = *((char **)t13);
    *((unsigned char *)t14) = (unsigned char)3;
    xsi_driver_first_trans_fast(t7);
    goto LAB2;

LAB6:    goto LAB2;

}

static void work_a_0880239054_2128832208_p_9(char *t0)
{
    unsigned char t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    char *t8;
    unsigned char t9;
    unsigned char t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;

LAB0:    xsi_set_current_line(270, ng0);
    t2 = (t0 + 1304U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t2 = (t0 + 8528);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(271, ng0);
    t4 = (t0 + 1236U);
    t8 = *((char **)t4);
    t9 = *((unsigned char *)t8);
    t10 = (t9 == (unsigned char)3);
    if (t10 != 0)
        goto LAB8;

LAB10:    xsi_set_current_line(274, ng0);
    t2 = (t0 + 2524U);
    t4 = *((char **)t2);
    t1 = *((unsigned char *)t4);
    t3 = (t1 == (unsigned char)3);
    if (t3 != 0)
        goto LAB11;

LAB13:    xsi_set_current_line(279, ng0);
    t2 = (t0 + 3168U);
    t4 = *((char **)t2);
    t1 = *((unsigned char *)t4);
    t2 = (t0 + 3260U);
    t5 = *((char **)t2);
    t3 = *((unsigned char *)t5);
    t6 = ieee_p_2592010699_sub_1605435078_503743352(IEEE_P_2592010699, t1, t3);
    t2 = (t0 + 9016);
    t8 = (t2 + 32U);
    t11 = *((char **)t8);
    t12 = (t11 + 40U);
    t13 = *((char **)t12);
    *((unsigned char *)t13) = t6;
    xsi_driver_first_trans_fast(t2);

LAB12:
LAB9:    goto LAB3;

LAB5:    t4 = (t0 + 1328U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    t1 = t7;
    goto LAB7;

LAB8:    xsi_set_current_line(272, ng0);
    t4 = (t0 + 9016);
    t11 = (t4 + 32U);
    t12 = *((char **)t11);
    t13 = (t12 + 40U);
    t14 = *((char **)t13);
    *((unsigned char *)t14) = (unsigned char)2;
    xsi_driver_first_trans_fast(t4);
    goto LAB9;

LAB11:    xsi_set_current_line(276, ng0);
    t2 = (t0 + 2524U);
    t5 = *((char **)t2);
    t6 = *((unsigned char *)t5);
    t2 = (t0 + 3076U);
    t8 = *((char **)t2);
    t7 = *((unsigned char *)t8);
    t9 = ieee_p_2592010699_sub_1690584930_503743352(IEEE_P_2592010699, t7);
    t10 = ieee_p_2592010699_sub_1605435078_503743352(IEEE_P_2592010699, t6, t9);
    t2 = (t0 + 9016);
    t11 = (t2 + 32U);
    t12 = *((char **)t11);
    t13 = (t12 + 40U);
    t14 = *((char **)t13);
    *((unsigned char *)t14) = t10;
    xsi_driver_first_trans_fast(t2);
    goto LAB12;

}

static void work_a_0880239054_2128832208_p_10(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    unsigned char t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;

LAB0:    xsi_set_current_line(285, ng0);
    t1 = (t0 + 2800U);
    t2 = *((char **)t1);
    t1 = (t0 + 18452U);
    t3 = (t0 + 3844U);
    t4 = *((char **)t3);
    t3 = (t0 + 17956U);
    t5 = ieee_std_logic_unsigned_equal_stdv_stdv(IEEE_P_3620187407, t2, t1, t4, t3);
    if (t5 != 0)
        goto LAB3;

LAB4:
LAB5:    t11 = (t0 + 9052);
    t12 = (t11 + 32U);
    t13 = *((char **)t12);
    t14 = (t13 + 40U);
    t15 = *((char **)t14);
    *((unsigned char *)t15) = (unsigned char)2;
    xsi_driver_first_trans_fast(t11);

LAB2:    t16 = (t0 + 8536);
    *((int *)t16) = 1;

LAB1:    return;
LAB3:    t6 = (t0 + 9052);
    t7 = (t6 + 32U);
    t8 = *((char **)t7);
    t9 = (t8 + 40U);
    t10 = *((char **)t9);
    *((unsigned char *)t10) = (unsigned char)3;
    xsi_driver_first_trans_fast(t6);
    goto LAB2;

LAB6:    goto LAB2;

}

static void work_a_0880239054_2128832208_p_11(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    unsigned char t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;

LAB0:    xsi_set_current_line(286, ng0);
    t1 = (t0 + 2800U);
    t2 = *((char **)t1);
    t1 = (t0 + 18452U);
    t3 = (t0 + 4116U);
    t4 = *((char **)t3);
    t3 = (t0 + 18020U);
    t5 = ieee_std_logic_unsigned_equal_stdv_stdv(IEEE_P_3620187407, t2, t1, t4, t3);
    if (t5 != 0)
        goto LAB3;

LAB4:
LAB5:    t11 = (t0 + 9088);
    t12 = (t11 + 32U);
    t13 = *((char **)t12);
    t14 = (t13 + 40U);
    t15 = *((char **)t14);
    *((unsigned char *)t15) = (unsigned char)2;
    xsi_driver_first_trans_fast(t11);

LAB2:    t16 = (t0 + 8544);
    *((int *)t16) = 1;

LAB1:    return;
LAB3:    t6 = (t0 + 9088);
    t7 = (t6 + 32U);
    t8 = *((char **)t7);
    t9 = (t8 + 40U);
    t10 = *((char **)t9);
    *((unsigned char *)t10) = (unsigned char)3;
    xsi_driver_first_trans_fast(t6);
    goto LAB2;

LAB6:    goto LAB2;

}

static void work_a_0880239054_2128832208_p_12(char *t0)
{
    unsigned char t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    char *t8;
    unsigned char t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;

LAB0:    xsi_set_current_line(290, ng0);
    t2 = (t0 + 1304U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t2 = (t0 + 8552);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(291, ng0);
    t4 = (t0 + 3352U);
    t8 = *((char **)t4);
    t9 = *((unsigned char *)t8);
    t4 = (t0 + 9124);
    t10 = (t4 + 32U);
    t11 = *((char **)t10);
    t12 = (t11 + 40U);
    t13 = *((char **)t12);
    *((unsigned char *)t13) = t9;
    xsi_driver_first_trans_fast_port(t4);
    xsi_set_current_line(292, ng0);
    t2 = (t0 + 3352U);
    t4 = *((char **)t2);
    t1 = *((unsigned char *)t4);
    t2 = (t0 + 3444U);
    t5 = *((char **)t2);
    t3 = *((unsigned char *)t5);
    t6 = ieee_p_2592010699_sub_2545490612_503743352(IEEE_P_2592010699, t1, t3);
    t2 = (t0 + 9160);
    t8 = (t2 + 32U);
    t10 = *((char **)t8);
    t11 = (t10 + 40U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = t6;
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(293, ng0);
    t2 = (t0 + 2708U);
    t4 = *((char **)t2);
    t2 = (t0 + 18436U);
    t5 = (t0 + 3708U);
    t8 = *((char **)t5);
    t5 = (t0 + 17924U);
    t1 = ieee_std_logic_unsigned_equal_stdv_stdv(IEEE_P_3620187407, t4, t2, t8, t5);
    if (t1 != 0)
        goto LAB8;

LAB10:
LAB9:    goto LAB3;

LAB5:    t4 = (t0 + 1328U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    t1 = t7;
    goto LAB7;

LAB8:    xsi_set_current_line(294, ng0);
    t10 = (t0 + 1144U);
    t11 = *((char **)t10);
    t3 = *((unsigned char *)t11);
    t10 = (t0 + 9196);
    t12 = (t10 + 32U);
    t13 = *((char **)t12);
    t14 = (t13 + 40U);
    t15 = *((char **)t14);
    *((unsigned char *)t15) = t3;
    xsi_driver_first_trans_fast_port(t10);
    goto LAB9;

}

static void work_a_0880239054_2128832208_p_13(char *t0)
{
    char *t1;
    char *t2;
    int t3;
    unsigned int t4;
    unsigned int t5;
    unsigned int t6;
    unsigned char t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;

LAB0:    xsi_set_current_line(302, ng0);

LAB3:    t1 = (t0 + 2064U);
    t2 = *((char **)t1);
    t3 = (0 - 7);
    t4 = (t3 * -1);
    t5 = (1U * t4);
    t6 = (0 + t5);
    t1 = (t2 + t6);
    t7 = *((unsigned char *)t1);
    t8 = (t0 + 9232);
    t9 = (t8 + 32U);
    t10 = *((char **)t9);
    t11 = (t10 + 40U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = t7;
    xsi_driver_first_trans_fast_port(t8);

LAB2:    t13 = (t0 + 8560);
    *((int *)t13) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_0880239054_2128832208_p_14(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    int t6;
    int t7;
    int t8;
    char *t9;
    int t10;
    char *t11;
    int t12;
    char *t13;
    int t14;
    char *t15;
    int t16;
    char *t17;
    int t18;
    char *t19;
    unsigned char t20;
    unsigned char t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    char *t26;
    unsigned char t27;
    unsigned char t28;
    unsigned char t29;
    unsigned char t30;

LAB0:    xsi_set_current_line(306, ng0);
    t1 = (t0 + 9268);
    t2 = (t1 + 32U);
    t3 = *((char **)t2);
    t4 = (t3 + 40U);
    t5 = *((char **)t4);
    *((unsigned char *)t5) = (unsigned char)2;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(307, ng0);
    t1 = (t0 + 9304);
    t2 = (t1 + 32U);
    t3 = *((char **)t2);
    t4 = (t3 + 40U);
    t5 = *((char **)t4);
    *((unsigned char *)t5) = (unsigned char)2;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(308, ng0);
    t1 = (t0 + 2708U);
    t2 = *((char **)t1);
    t1 = (t0 + 3708U);
    t3 = *((char **)t1);
    t6 = xsi_mem_cmp(t3, t2, 3U);
    if (t6 == 1)
        goto LAB3;

LAB12:    t1 = (t0 + 3776U);
    t4 = *((char **)t1);
    t7 = xsi_mem_cmp(t4, t2, 3U);
    if (t7 == 1)
        goto LAB4;

LAB13:    t1 = (t0 + 3844U);
    t5 = *((char **)t1);
    t8 = xsi_mem_cmp(t5, t2, 3U);
    if (t8 == 1)
        goto LAB5;

LAB14:    t1 = (t0 + 3912U);
    t9 = *((char **)t1);
    t10 = xsi_mem_cmp(t9, t2, 3U);
    if (t10 == 1)
        goto LAB6;

LAB15:    t1 = (t0 + 3980U);
    t11 = *((char **)t1);
    t12 = xsi_mem_cmp(t11, t2, 3U);
    if (t12 == 1)
        goto LAB7;

LAB16:    t1 = (t0 + 4048U);
    t13 = *((char **)t1);
    t14 = xsi_mem_cmp(t13, t2, 3U);
    if (t14 == 1)
        goto LAB8;

LAB17:    t1 = (t0 + 4116U);
    t15 = *((char **)t1);
    t16 = xsi_mem_cmp(t15, t2, 3U);
    if (t16 == 1)
        goto LAB9;

LAB18:    t1 = (t0 + 4184U);
    t17 = *((char **)t1);
    t18 = xsi_mem_cmp(t17, t2, 3U);
    if (t18 == 1)
        goto LAB10;

LAB19:
LAB11:    xsi_set_current_line(353, ng0);
    t1 = (t0 + 3708U);
    t2 = *((char **)t1);
    t1 = (t0 + 9340);
    t3 = (t1 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 40U);
    t9 = *((char **)t5);
    memcpy(t9, t2, 3U);
    xsi_driver_first_trans_fast(t1);

LAB2:    t1 = (t0 + 8568);
    *((int *)t1) = 1;

LAB1:    return;
LAB3:    xsi_set_current_line(310, ng0);
    t1 = (t0 + 960U);
    t19 = *((char **)t1);
    t20 = *((unsigned char *)t19);
    t21 = (t20 == (unsigned char)3);
    if (t21 != 0)
        goto LAB21;

LAB23:    xsi_set_current_line(313, ng0);
    t1 = (t0 + 3708U);
    t2 = *((char **)t1);
    t1 = (t0 + 9340);
    t3 = (t1 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 40U);
    t9 = *((char **)t5);
    memcpy(t9, t2, 3U);
    xsi_driver_first_trans_fast(t1);

LAB22:    goto LAB2;

LAB4:    xsi_set_current_line(316, ng0);
    t1 = (t0 + 9304);
    t2 = (t1 + 32U);
    t3 = *((char **)t2);
    t4 = (t3 + 40U);
    t5 = *((char **)t4);
    *((unsigned char *)t5) = (unsigned char)3;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(317, ng0);
    t1 = (t0 + 9268);
    t2 = (t1 + 32U);
    t3 = *((char **)t2);
    t4 = (t3 + 40U);
    t5 = *((char **)t4);
    *((unsigned char *)t5) = (unsigned char)3;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(318, ng0);
    t1 = (t0 + 3844U);
    t2 = *((char **)t1);
    t1 = (t0 + 9340);
    t3 = (t1 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 40U);
    t9 = *((char **)t5);
    memcpy(t9, t2, 3U);
    xsi_driver_first_trans_fast(t1);
    goto LAB2;

LAB5:    xsi_set_current_line(322, ng0);
    t1 = (t0 + 3260U);
    t2 = *((char **)t1);
    t20 = *((unsigned char *)t2);
    t21 = (t20 == (unsigned char)3);
    if (t21 != 0)
        goto LAB24;

LAB26:    xsi_set_current_line(333, ng0);
    t1 = (t0 + 3844U);
    t2 = *((char **)t1);
    t1 = (t0 + 9340);
    t3 = (t1 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 40U);
    t9 = *((char **)t5);
    memcpy(t9, t2, 3U);
    xsi_driver_first_trans_fast(t1);

LAB25:    goto LAB2;

LAB6:    xsi_set_current_line(336, ng0);
    t1 = (t0 + 9304);
    t2 = (t1 + 32U);
    t3 = *((char **)t2);
    t4 = (t3 + 40U);
    t5 = *((char **)t4);
    *((unsigned char *)t5) = (unsigned char)3;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(337, ng0);
    t1 = (t0 + 3980U);
    t2 = *((char **)t1);
    t1 = (t0 + 9340);
    t3 = (t1 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 40U);
    t9 = *((char **)t5);
    memcpy(t9, t2, 3U);
    xsi_driver_first_trans_fast(t1);
    goto LAB2;

LAB7:    xsi_set_current_line(339, ng0);
    t1 = (t0 + 9304);
    t2 = (t1 + 32U);
    t3 = *((char **)t2);
    t4 = (t3 + 40U);
    t5 = *((char **)t4);
    *((unsigned char *)t5) = (unsigned char)3;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(340, ng0);
    t1 = (t0 + 4048U);
    t2 = *((char **)t1);
    t1 = (t0 + 9340);
    t3 = (t1 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 40U);
    t9 = *((char **)t5);
    memcpy(t9, t2, 3U);
    xsi_driver_first_trans_fast(t1);
    goto LAB2;

LAB8:    xsi_set_current_line(342, ng0);
    t1 = (t0 + 9304);
    t2 = (t1 + 32U);
    t3 = *((char **)t2);
    t4 = (t3 + 40U);
    t5 = *((char **)t4);
    *((unsigned char *)t5) = (unsigned char)3;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(343, ng0);
    t1 = (t0 + 4116U);
    t2 = *((char **)t1);
    t1 = (t0 + 9340);
    t3 = (t1 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 40U);
    t9 = *((char **)t5);
    memcpy(t9, t2, 3U);
    xsi_driver_first_trans_fast(t1);
    goto LAB2;

LAB9:    xsi_set_current_line(345, ng0);
    t1 = (t0 + 3260U);
    t2 = *((char **)t1);
    t20 = *((unsigned char *)t2);
    t21 = (t20 == (unsigned char)3);
    if (t21 != 0)
        goto LAB33;

LAB35:    xsi_set_current_line(348, ng0);
    t1 = (t0 + 4116U);
    t2 = *((char **)t1);
    t1 = (t0 + 9340);
    t3 = (t1 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 40U);
    t9 = *((char **)t5);
    memcpy(t9, t2, 3U);
    xsi_driver_first_trans_fast(t1);

LAB34:    goto LAB2;

LAB10:    xsi_set_current_line(351, ng0);
    t1 = (t0 + 3708U);
    t2 = *((char **)t1);
    t1 = (t0 + 9340);
    t3 = (t1 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 40U);
    t9 = *((char **)t5);
    memcpy(t9, t2, 3U);
    xsi_driver_first_trans_fast(t1);
    goto LAB2;

LAB20:;
LAB21:    xsi_set_current_line(311, ng0);
    t1 = (t0 + 3776U);
    t22 = *((char **)t1);
    t1 = (t0 + 9340);
    t23 = (t1 + 32U);
    t24 = *((char **)t23);
    t25 = (t24 + 40U);
    t26 = *((char **)t25);
    memcpy(t26, t22, 3U);
    xsi_driver_first_trans_fast(t1);
    goto LAB22;

LAB24:    xsi_set_current_line(323, ng0);
    t1 = (t0 + 2432U);
    t3 = *((char **)t1);
    t27 = *((unsigned char *)t3);
    t28 = (t27 == (unsigned char)3);
    if (t28 != 0)
        goto LAB27;

LAB29:    xsi_set_current_line(330, ng0);
    t1 = (t0 + 3912U);
    t2 = *((char **)t1);
    t1 = (t0 + 9340);
    t3 = (t1 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 40U);
    t9 = *((char **)t5);
    memcpy(t9, t2, 3U);
    xsi_driver_first_trans_fast(t1);

LAB28:    goto LAB25;

LAB27:    xsi_set_current_line(324, ng0);
    t1 = (t0 + 2524U);
    t4 = *((char **)t1);
    t29 = *((unsigned char *)t4);
    t30 = (t29 == (unsigned char)3);
    if (t30 != 0)
        goto LAB30;

LAB32:    xsi_set_current_line(327, ng0);
    t1 = (t0 + 3776U);
    t2 = *((char **)t1);
    t1 = (t0 + 9340);
    t3 = (t1 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 40U);
    t9 = *((char **)t5);
    memcpy(t9, t2, 3U);
    xsi_driver_first_trans_fast(t1);

LAB31:    goto LAB28;

LAB30:    xsi_set_current_line(325, ng0);
    t1 = (t0 + 4184U);
    t5 = *((char **)t1);
    t1 = (t0 + 9340);
    t9 = (t1 + 32U);
    t11 = *((char **)t9);
    t13 = (t11 + 40U);
    t15 = *((char **)t13);
    memcpy(t15, t5, 3U);
    xsi_driver_first_trans_fast(t1);
    goto LAB31;

LAB33:    xsi_set_current_line(346, ng0);
    t1 = (t0 + 4184U);
    t3 = *((char **)t1);
    t1 = (t0 + 9340);
    t4 = (t1 + 32U);
    t5 = *((char **)t4);
    t9 = (t5 + 40U);
    t11 = *((char **)t9);
    memcpy(t11, t3, 3U);
    xsi_driver_first_trans_fast(t1);
    goto LAB34;

}

static void work_a_0880239054_2128832208_p_15(char *t0)
{
    unsigned char t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    char *t8;
    unsigned char t9;
    unsigned char t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;

LAB0:    xsi_set_current_line(360, ng0);
    t2 = (t0 + 1304U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t2 = (t0 + 8576);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(361, ng0);
    t4 = (t0 + 1236U);
    t8 = *((char **)t4);
    t9 = *((unsigned char *)t8);
    t10 = (t9 == (unsigned char)3);
    if (t10 != 0)
        goto LAB8;

LAB10:    xsi_set_current_line(364, ng0);
    t2 = (t0 + 2800U);
    t4 = *((char **)t2);
    t2 = (t0 + 9376);
    t5 = (t2 + 32U);
    t8 = *((char **)t5);
    t11 = (t8 + 40U);
    t12 = *((char **)t11);
    memcpy(t12, t4, 3U);
    xsi_driver_first_trans_fast(t2);

LAB9:    goto LAB3;

LAB5:    t4 = (t0 + 1328U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    t1 = t7;
    goto LAB7;

LAB8:    xsi_set_current_line(362, ng0);
    t4 = (t0 + 3708U);
    t11 = *((char **)t4);
    t4 = (t0 + 9376);
    t12 = (t4 + 32U);
    t13 = *((char **)t12);
    t14 = (t13 + 40U);
    t15 = *((char **)t14);
    memcpy(t15, t11, 3U);
    xsi_driver_first_trans_fast(t4);
    goto LAB9;

}


extern void work_a_0880239054_2128832208_init()
{
	static char *pe[] = {(void *)work_a_0880239054_2128832208_p_0,(void *)work_a_0880239054_2128832208_p_1,(void *)work_a_0880239054_2128832208_p_2,(void *)work_a_0880239054_2128832208_p_3,(void *)work_a_0880239054_2128832208_p_4,(void *)work_a_0880239054_2128832208_p_5,(void *)work_a_0880239054_2128832208_p_6,(void *)work_a_0880239054_2128832208_p_7,(void *)work_a_0880239054_2128832208_p_8,(void *)work_a_0880239054_2128832208_p_9,(void *)work_a_0880239054_2128832208_p_10,(void *)work_a_0880239054_2128832208_p_11,(void *)work_a_0880239054_2128832208_p_12,(void *)work_a_0880239054_2128832208_p_13,(void *)work_a_0880239054_2128832208_p_14,(void *)work_a_0880239054_2128832208_p_15};
	xsi_register_didat("work_a_0880239054_2128832208", "isim/memCntrlTop_tb_isim_beh.exe.sim/work/a_0880239054_2128832208.didat");
	xsi_register_executes(pe);
}
