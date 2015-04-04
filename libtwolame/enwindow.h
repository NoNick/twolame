/*
 *  TwoLAME: an optimized MPEG Audio Layer Two encoder
 *
 *  Copyright (C) 2001-2004 Michael Cheng
 *  Copyright (C) 2004-2006 The TwoLAME Project
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *  License as published by the Free Software Foundation; either
 *  version 2.1 of the License, or (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 *  $Id$
 *
 */


/*static const FLOAT enwindow[512] = { 0.000000000,
    -0.000000477, -0.000000477, -0.000000477, -0.000000477, -0.000000477, -0.000000477,
    -0.000000954, -0.000000954, -0.000000954, -0.000000954, -0.000001431, -0.000001431,
    -0.000001907, -0.000001907, -0.000002384, -0.000002384, -0.000002861, -0.000003338,
    -0.000003338, -0.000003815, -0.000004292, -0.000004768, -0.000005245, -0.000006199,
    -0.000006676, -0.000007629, -0.000008106, -0.000009060, -0.000010014, -0.000011444,
    -0.000012398, -0.000013828, -0.000014782, -0.000016689, -0.000018120, -0.000019550,
    -0.000021458, -0.000023365, -0.000025272, -0.000027657, -0.000030041, -0.000032425,
    -0.000034809, -0.000037670, -0.000040531, -0.000043392, -0.000046253, -0.000049591,
    -0.000052929, -0.000055790, -0.000059605, -0.000062943, -0.000066280, -0.000070095,
    -0.000073433, -0.000076771, -0.000080585, -0.000083923, -0.000087261, -0.000090599,
    -0.000093460, -0.000096321, -0.000099182, 0.000101566, 0.000103951, 0.000105858,
    0.000107288, 0.000108242, 0.000108719, 0.000108719, 0.000108242, 0.000106812,
    0.000105381, 0.000102520, 0.000099182, 0.000095367, 0.000090122, 0.000084400,
    0.000077724, 0.000069618, 0.000060558, 0.000050545, 0.000039577, 0.000027180,
    0.000013828, -0.000000954, -0.000017166, -0.000034332, -0.000052929, -0.000072956,
    -0.000093937, -0.000116348, -0.000140190, -0.000165462, -0.000191212, -0.000218868,
    -0.000247478, -0.000277042, -0.000307560, -0.000339031, -0.000371456, -0.000404358,
    -0.000438213, -0.000472546, -0.000507355, -0.000542164, -0.000576973, -0.000611782,
    -0.000646591, -0.000680923, -0.000714302, -0.000747204, -0.000779152, -0.000809669,
    -0.000838757, -0.000866413, -0.000891685, -0.000915051, -0.000935555, -0.000954151,
    -0.000968933, -0.000980854, -0.000989437, -0.000994205, -0.000995159, -0.000991821,
    -0.000983715, 0.000971317, 0.000953674, 0.000930786, 0.000902653, 0.000868797,
    0.000829220, 0.000783920, 0.000731945, 0.000674248, 0.000610352, 0.000539303,
    0.000462532, 0.000378609, 0.000288486, 0.000191689, 0.000088215, -0.000021458,
    -0.000137329, -0.000259876, -0.000388145, -0.000522137, -0.000661850, -0.000806808,
    -0.000956535, -0.001111031, -0.001269817, -0.001432419, -0.001597881, -0.001766682,
    -0.001937389, -0.002110004, -0.002283096, -0.002457142, -0.002630711, -0.002803326,
    -0.002974033, -0.003141880, -0.003306866, -0.003467083, -0.003622532, -0.003771782,
    -0.003914356, -0.004048824, -0.004174709, -0.004290581, -0.004395962, -0.004489899,
    -0.004570484, -0.004638195, -0.004691124, -0.004728317, -0.004748821, -0.004752159,
    -0.004737377, -0.004703045, -0.004649162, -0.004573822, -0.004477024, -0.004357815,
    -0.004215240, -0.004049301, -0.003858566, -0.003643036, -0.003401756, 0.003134727,
    0.002841473, 0.002521515, 0.002174854, 0.001800537, 0.001399517, 0.000971317,
    0.000515938, 0.000033379, -0.000475883, -0.001011848, -0.001573563, -0.002161503,
    -0.002774239, -0.003411293, -0.004072189, -0.004756451, -0.005462170, -0.006189346,
    -0.006937027, -0.007703304, -0.008487225, -0.009287834, -0.010103703, -0.010933399,
    -0.011775017, -0.012627602, -0.013489246, -0.014358521, -0.015233517, -0.016112804,
    -0.016994476, -0.017876148, -0.018756866, -0.019634247, -0.020506859, -0.021372318,
    -0.022228718, -0.023074150, -0.023907185, -0.024725437, -0.025527000, -0.026310921,
    -0.027073860, -0.027815342, -0.028532982, -0.029224873, -0.029890060, -0.030526638,
    -0.031132698, -0.031706810, -0.032248020, -0.032754898, -0.033225536, -0.033659935,
    -0.034055710, -0.034412861, -0.034730434, -0.035007000, -0.035242081, -0.035435200,
    -0.035586357, -0.035694122, -0.035758972, 0.035780907, 0.035758972, 0.035694122,
    0.035586357, 0.035435200, 0.035242081, 0.035007000, 0.034730434, 0.034412861,
    0.034055710, 0.033659935, 0.033225536, 0.032754898, 0.032248020, 0.031706810,
    0.031132698, 0.030526638, 0.029890060, 0.029224873, 0.028532982, 0.027815342,
    0.027073860, 0.026310921, 0.025527000, 0.024725437, 0.023907185, 0.023074150,
    0.022228718, 0.021372318, 0.020506859, 0.019634247, 0.018756866, 0.017876148,
    0.016994476, 0.016112804, 0.015233517, 0.014358521, 0.013489246, 0.012627602,
    0.011775017, 0.010933399, 0.010103703, 0.009287834, 0.008487225, 0.007703304,
    0.006937027, 0.006189346, 0.005462170, 0.004756451, 0.004072189, 0.003411293,
    0.002774239, 0.002161503, 0.001573563, 0.001011848, 0.000475883, -0.000033379,
    -0.000515938, -0.000971317, -0.001399517, -0.001800537, -0.002174854, -0.002521515,
    -0.002841473, 0.003134727, 0.003401756, 0.003643036, 0.003858566, 0.004049301,
    0.004215240, 0.004357815, 0.004477024, 0.004573822, 0.004649162, 0.004703045,
    0.004737377, 0.004752159, 0.004748821, 0.004728317, 0.004691124, 0.004638195,
    0.004570484, 0.004489899, 0.004395962, 0.004290581, 0.004174709, 0.004048824,
    0.003914356, 0.003771782, 0.003622532, 0.003467083, 0.003306866, 0.003141880,
    0.002974033, 0.002803326, 0.002630711, 0.002457142, 0.002283096, 0.002110004,
    0.001937389, 0.001766682, 0.001597881, 0.001432419, 0.001269817, 0.001111031,
    0.000956535, 0.000806808, 0.000661850, 0.000522137, 0.000388145, 0.000259876,
    0.000137329, 0.000021458, -0.000088215, -0.000191689, -0.000288486, -0.000378609,
    -0.000462532, -0.000539303, -0.000610352, -0.000674248, -0.000731945, -0.000783920,
    -0.000829220, -0.000868797, -0.000902653, -0.000930786, -0.000953674, 0.000971317,
    0.000983715, 0.000991821, 0.000995159, 0.000994205, 0.000989437, 0.000980854,
    0.000968933, 0.000954151, 0.000935555, 0.000915051, 0.000891685, 0.000866413,
    0.000838757, 0.000809669, 0.000779152, 0.000747204, 0.000714302, 0.000680923,
    0.000646591, 0.000611782, 0.000576973, 0.000542164, 0.000507355, 0.000472546,
    0.000438213, 0.000404358, 0.000371456, 0.000339031, 0.000307560, 0.000277042,
    0.000247478, 0.000218868, 0.000191212, 0.000165462, 0.000140190, 0.000116348,
    0.000093937, 0.000072956, 0.000052929, 0.000034332, 0.000017166, 0.000000954,
    -0.000013828, -0.000027180, -0.000039577, -0.000050545, -0.000060558, -0.000069618,
    -0.000077724, -0.000084400, -0.000090122, -0.000095367, -0.000099182, -0.000102520,
    -0.000105381, -0.000106812, -0.000108242, -0.000108719, -0.000108719, -0.000108242,
    -0.000107288, -0.000105858, -0.000103951, 0.000101566, 0.000099182, 0.000096321,
    0.000093460, 0.000090599, 0.000087261, 0.000083923, 0.000080585, 0.000076771,
    0.000073433, 0.000070095, 0.000066280, 0.000062943, 0.000059605, 0.000055790,
    0.000052929, 0.000049591, 0.000046253, 0.000043392, 0.000040531, 0.000037670,
    0.000034809, 0.000032425, 0.000030041, 0.000027657, 0.000025272, 0.000023365,
    0.000021458, 0.000019550, 0.000018120, 0.000016689, 0.000014782, 0.000013828,
    0.000012398, 0.000011444, 0.000010014, 0.000009060, 0.000008106, 0.000007629,
    0.000006676, 0.000006199, 0.000005245, 0.000004768, 0.000004292, 0.000003815,
    0.000003338, 0.000003338, 0.000002861, 0.000002384, 0.000002384, 0.000001907,
    0.000001907, 0.000001431, 0.000001431, 0.000000954, 0.000000954, 0.000000954,
    0.000000954, 0.000000477, 0.000000477, 0.000000477, 0.000000477, 0.000000477,
    0.000000477
};*/

// assume enwindow is 8x64 matrix and transpose it
static const float enwindowT[512] = {
    0.0, 0.000101566, 0.000971317, 0.003134727, 0.035780907, 0.003134727, 0.000971317,
    0.000101566 ,  -4.77e-07, 0.000103951, 0.000953674, 0.002841473, 0.035758972, 0.003401756,
    0.000983715, 9.9182e-05 ,  -4.77e-07, 0.000105858, 0.000930786, 0.002521515, 0.035694122,
    0.003643036, 0.000991821, 9.6321e-05 ,  -4.77e-07, 0.000107288, 0.000902653, 0.002174854,
    0.035586357, 0.003858566, 0.000995159, 9.346e-05 ,  -4.77e-07, 0.000108242, 0.000868797,
    0.001800537, 0.0354352, 0.004049301, 0.000994205, 9.0599e-05 ,  -4.77e-07, 0.000108719,
    0.00082922, 0.001399517, 0.035242081, 0.00421524, 0.000989437, 8.7261e-05 ,  -4.77e-07,
    0.000108719, 0.00078392, 0.000971317, 0.035007, 0.004357815, 0.000980854, 8.3923e-05 ,
     -9.54e-07, 0.000108242, 0.000731945, 0.000515938, 0.034730434, 0.004477024, 0.000968933,
    8.0585e-05 ,  -9.54e-07, 0.000106812, 0.000674248, 3.3379e-05, 0.034412861, 0.004573822,
    0.000954151, 7.6771e-05 ,  -9.54e-07, 0.000105381, 0.000610352, -0.000475883, 0.03405571,
    0.004649162, 0.000935555, 7.3433e-05 ,  -9.54e-07, 0.00010252, 0.000539303, -0.001011848,
    0.033659935, 0.004703045, 0.000915051, 7.0095e-05 ,  -1.431e-06, 9.9182e-05, 0.000462532,
    -0.001573563, 0.033225536, 0.004737377, 0.000891685, 6.628e-05 ,  -1.431e-06, 9.5367e-05,
    0.000378609, -0.002161503, 0.032754898, 0.004752159, 0.000866413, 6.2943e-05 ,  -1.907e-06,
    9.0122e-05, 0.000288486, -0.002774239, 0.03224802, 0.004748821, 0.000838757, 5.9605e-05 ,
     -1.907e-06, 8.44e-05, 0.000191689, -0.003411293, 0.03170681, 0.004728317, 0.000809669,
    5.579e-05 ,  -2.384e-06, 7.7724e-05, 8.8215e-05, -0.004072189, 0.031132698, 0.004691124,
    0.000779152, 5.2929e-05 ,  -2.384e-06, 6.9618e-05, -2.1458e-05, -0.004756451, 0.030526638,
    0.004638195, 0.000747204, 4.9591e-05 ,  -2.861e-06, 6.0558e-05, -0.000137329, -0.00546217,
    0.02989006, 0.004570484, 0.000714302, 4.6253e-05 ,  -3.338e-06, 5.0545e-05, -0.000259876,
    -0.006189346, 0.029224873, 0.004489899, 0.000680923, 4.3392e-05 ,  -3.338e-06, 3.9577e-05,
    -0.000388145, -0.006937027, 0.028532982, 0.004395962, 0.000646591, 4.0531e-05 ,  -3.815e-06,
    2.718e-05, -0.000522137, -0.007703304, 0.027815342, 0.004290581, 0.000611782, 3.767e-05 ,
     -4.292e-06, 1.3828e-05, -0.00066185, -0.008487225, 0.02707386, 0.004174709, 0.000576973,
    3.4809e-05 ,  -4.768e-06, -9.54e-07, -0.000806808, -0.009287834, 0.026310921, 0.004048824,
    0.000542164, 3.2425e-05 ,  -5.245e-06, -1.7166e-05, -0.000956535, -0.010103703, 0.025527,
    0.003914356, 0.000507355, 3.0041e-05 ,  -6.199e-06, -3.4332e-05, -0.001111031, -0.010933399,
    0.024725437, 0.003771782, 0.000472546, 2.7657e-05 ,  -6.676e-06, -5.2929e-05, -0.001269817,
    -0.011775017, 0.023907185, 0.003622532, 0.000438213, 2.5272e-05 ,  -7.629e-06, -7.2956e-05,
    -0.001432419, -0.012627602, 0.02307415, 0.003467083, 0.000404358, 2.3365e-05 ,  -8.106e-06,
    -9.3937e-05, -0.001597881, -0.013489246, 0.022228718, 0.003306866, 0.000371456, 2.1458e-05,
     -9.06e-06, -0.000116348, -0.001766682, -0.014358521, 0.021372318, 0.00314188, 0.000339031,
    1.955e-05 ,  -1.0014e-05, -0.00014019, -0.001937389, -0.015233517, 0.020506859, 0.002974033,
    0.00030756, 1.812e-05 ,  -1.1444e-05, -0.000165462, -0.002110004, -0.016112804, 0.019634247,
    0.002803326, 0.000277042, 1.6689e-05 ,  -1.2398e-05, -0.000191212, -0.002283096,
    -0.016994476, 0.018756866, 0.002630711, 0.000247478, 1.4782e-05 ,  -1.3828e-05, -0.000218868,
    -0.002457142, -0.017876148, 0.017876148, 0.002457142, 0.000218868, 1.3828e-05 ,
     -1.4782e-05, -0.000247478, -0.002630711, -0.018756866, 0.016994476, 0.002283096, 0.000191212,
    1.2398e-05 ,  -1.6689e-05, -0.000277042, -0.002803326, -0.019634247, 0.016112804,
    0.002110004, 0.000165462, 1.1444e-05 ,  -1.812e-05, -0.00030756, -0.002974033, -0.020506859,
    0.015233517, 0.001937389, 0.00014019, 1.0014e-05 ,  -1.955e-05, -0.000339031, -0.00314188,
    -0.021372318, 0.014358521, 0.001766682, 0.000116348, 9.06e-06 ,  -2.1458e-05, -0.000371456,
    -0.003306866, -0.022228718, 0.013489246, 0.001597881, 9.3937e-05, 8.106e-06 ,  -2.3365e-05,
    -0.000404358, -0.003467083, -0.02307415, 0.012627602, 0.001432419, 7.2956e-05, 7.629e-06,
    -2.5272e-05, -0.000438213, -0.003622532, -0.023907185, 0.011775017, 0.001269817, 5.2929e-05,
    6.676e-06 ,  -2.7657e-05, -0.000472546, -0.003771782, -0.024725437, 0.010933399, 0.001111031,
    3.4332e-05, 6.199e-06 ,  -3.0041e-05, -0.000507355, -0.003914356, -0.025527, 0.010103703,
    0.000956535, 1.7166e-05, 5.245e-06 ,  -3.2425e-05, -0.000542164, -0.004048824, -0.026310921,
    0.009287834, 0.000806808, 9.54e-07, 4.768e-06 ,  -3.4809e-05, -0.000576973, -0.004174709,
    -0.02707386, 0.008487225, 0.00066185, -1.3828e-05, 4.292e-06 ,  -3.767e-05, -0.000611782,
    -0.004290581, -0.027815342, 0.007703304, 0.000522137, -2.718e-05, 3.815e-06 ,  -4.0531e-05,
    -0.000646591, -0.004395962, -0.028532982, 0.006937027, 0.000388145, -3.9577e-05, 3.338e-06,
    -4.3392e-05, -0.000680923, -0.004489899, -0.029224873, 0.006189346, 0.000259876,
    -5.0545e-05, 3.338e-06 ,  -4.6253e-05, -0.000714302, -0.004570484, -0.02989006, 0.00546217,
    0.000137329, -6.0558e-05, 2.861e-06 ,  -4.9591e-05, -0.000747204, -0.004638195,
    -0.030526638, 0.004756451, 2.1458e-05, -6.9618e-05, 2.384e-06 ,  -5.2929e-05, -0.000779152,
    -0.004691124, -0.031132698, 0.004072189, -8.8215e-05, -7.7724e-05, 2.384e-06 ,  -5.579e-05,
    -0.000809669, -0.004728317, -0.03170681, 0.003411293, -0.000191689, -8.44e-05, 1.907e-06,
    -5.9605e-05, -0.000838757, -0.004748821, -0.03224802, 0.002774239, -0.000288486,
    -9.0122e-05, 1.907e-06 ,  -6.2943e-05, -0.000866413, -0.004752159, -0.032754898, 0.002161503,
    -0.000378609, -9.5367e-05, 1.431e-06 ,  -6.628e-05, -0.000891685, -0.004737377,
    -0.033225536, 0.001573563, -0.000462532, -9.9182e-05, 1.431e-06 ,  -7.0095e-05, -0.000915051,
    -0.004703045, -0.033659935, 0.001011848, -0.000539303, -0.00010252, 9.54e-07,
     -7.3433e-05, -0.000935555, -0.004649162, -0.03405571, 0.000475883, -0.000610352,
    -0.000105381, 9.54e-07 ,  -7.6771e-05, -0.000954151, -0.004573822, -0.034412861, -3.3379e-05,
    -0.000674248, -0.000106812, 9.54e-07 ,  -8.0585e-05, -0.000968933, -0.004477024, -0.034730434,
    -0.000515938, -0.000731945, -0.000108242, 9.54e-07 ,  -8.3923e-05, -0.000980854,
    -0.004357815, -0.035007, -0.000971317, -0.00078392, -0.000108719, 4.77e-07,  -8.7261e-05,
    -0.000989437, -0.00421524, -0.035242081, -0.001399517, -0.00082922, -0.000108719, 4.77e-07,
     -9.0599e-05, -0.000994205, -0.004049301, -0.0354352, -0.001800537, -0.000868797, -0.000108242,
    4.77e-07 ,  -9.346e-05, -0.000995159, -0.003858566, -0.035586357, -0.002174854,
    -0.000902653, -0.000107288, 4.77e-07 ,  -9.6321e-05, -0.000991821, -0.003643036,
    -0.035694122, -0.002521515, -0.000930786, -0.000105858, 4.77e-07 ,  -9.9182e-05, -0.000983715,
    -0.003401756, -0.035758972, -0.002841473, -0.000953674, -0.000103951, 4.77e-07
};

// vim:ts=4:sw=4:nowrap: 
