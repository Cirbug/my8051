
/*******************************MILIANKE*******************************
*Company : MiLianKe Electronic Technology Co., Ltd.
*WebSite:https://www.milianke.com
*TechWeb:https://www.uisrc.com
*tmall-shop:https://milianke.tmall.com
*jd-shop:https://milianke.jd.com
*taobao-shop1: https://milianke.taobao.com
*Create Date: 2021/10/15
*Module Name:
*File Name:
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
*3) _n activ low
*4) _dg debug signal 
*5) _r delay or register
*6) _s state mechine
*********************************************************************/

`timescale 1ns / 1ns

module tb_key();

reg I_sysclk,I_rstn,I_key1,I_key2;
wire  [3:0]O_LED;

key_top#
(
.REF_CLK(25000000)
)
key_top_inst
(
.I_sysclk(I_sysclk), 
.I_rstn(I_rstn),
.I_key1(I_key1),
.I_key2(I_key2),
.O_LED(O_LED)
);

initial
	begin
		// Initialize Inputs
		I_sysclk = 0;
		I_rstn = 0;
		#100;
		I_rstn =1;
		I_key1 = 1;
		I_key2 = 1;
		#10000;
		forever
			begin
				I_key1 = 0;
				// Wait 100 ns for global reset to finish
				#100;
				I_key1=1; #1000;
				I_key1=0; #1000;
				I_key1=1; #2000;
				I_key1=0; #5000;
				#20000000;
				I_key1=1;
				I_key1=0; #1000;
                I_key1=1; #2000;
                I_key1=0; #1000;
                I_key1=1; #2000;
				#20000000;
				I_key2=1; #1000;
				I_key2=0; #1000;
				I_key2=1; #2000;
				I_key2=0; #5000;
				#20000000;
				I_key2=1;
				I_key2=0; #1000;
                I_key2=1; #2000;
                I_key2=0; #1000;
                I_key2=1; #2000;
				I_key2=0; #1000;	
				#20000000;		
				I_key2=1; #1000;	
			end
	end

always #20 I_sysclk=~I_sysclk;


endmodule
