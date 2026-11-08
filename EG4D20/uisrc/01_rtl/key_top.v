/*******************************MILIANKE*******************************
*Company : MiLianKe Electronic Technology Co., Ltd.
*WebSite:https://www.milianke.com
*TechWeb:https://www.uisrc.com
*tmall-shop:https://milianke.tmall.com
*jd-shop:https://milianke.jd.com
*taobao-shop1: https://milianke.taobao.com
*Create Date: 2021/10/15
*Module Name:run_led
*File Name:run_led.v
*Description: 
*The reference demo provided by Milianke is only used for learning. 
*We cannot ensure that the demo itself is free of bugs, so users 
*should be responsible for the technical problems and consequences
*caused by the use of their own products.
*Copyright: Copyright (c) MiLianKe
*All rights reserved.
*Revision: 1.0
*Signal description
*1) _i input
*2) _o output
*6) _n activ low
*4) _dg debug signal 
*5) _r delay or register
*6) _s state mechine
*********************************************************************/

`timescale 1ns / 1ns

module run_led#
(
parameter T_INR_CNT_SET = 62'd24_999_999
)
(
 input  		I_sysclk,
 input  		I_RSTn,
 output [3:0]	O_LED
);

reg [3:0]LED_r;
reg[24:0] T_INR_CNT;

assign O_LED = LED_r;


always @(posedge I_sysclk or negedge I_RSTn)begin
	if(I_RSTn==1'b0)
		T_INR_CNT <= 0;
	else if(T_INR_CNT == T_INR_CNT_SET)
    	T_INR_CNT <= 0;
    else
		T_INR_CNT <= T_INR_CNT + 1'b1;	
end

always @(posedge I_sysclk or negedge I_RSTn)begin
	if(I_RSTn==1'b0)
		LED_r <= 4'b0111;
	else if(T_INR_CNT == 0)
		LED_r <= {LED_r[0],LED_r[3:1]};	
end
 
endmodule	
