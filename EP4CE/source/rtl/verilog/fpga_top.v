module fpga_top(
	input wire clk,
	input wire rst_n,
	output wire led

);

//1.复位
reg [1:0] rst_sync;
 always@(posedge clk or posedge rst_n)begin
	if (rst_n)
		rst_sync <= 2'b11;
	else 
		rst_sync <= {rst_sync[0],1'b0};
	end
	wire cpu_rst;
	assign cpu_rst = rst_sync[1];
	
	
//2 ROM
wire [15:0] rom_addr;
wire [31:0]	rom_data;
wire rom_ack;
wire rom_stb;
wire rom_cyc;
//无rom
//assign rom_data = 32'h00000000;
//assign rom_ack = 1'b0;

//3gpio 
  wire [7:0] p1_out;

  assign led = p1_out[0];
  //assign led = cpu_rst;
  //assign led = 1'b0;
// 4.实例化 8051 内核
// 适用于当前 UART、T0/T1/T2、P0~P3 开启的配置
    oc8051_top u_cpu (
        .wb_clk_i (clk),
        .wb_rst_i (cpu_rst),

        // 程序存储器接口
        .wbi_adr_o (rom_addr),
        .wbi_dat_i (rom_data),
        .wbi_ack_i (rom_ack),
        .wbi_stb_o (rom_stb),
        .wbi_cyc_o (rom_cyc),
        .wbi_err_i (1'b0),

        // 选择外部程序存储器接口
        // “外部”指内核模块之外，ROM 仍可在 FPGA 内
        .ea_in    (1'b0),

        // 外部数据存储器：当前不使用
        // 测试程序暂时不要使用 MOVX
        .wbd_dat_i (8'h00),
        .wbd_ack_i (1'b0),
        .wbd_err_i (1'b0),
        .wbd_dat_o (),
        .wbd_adr_o (),
        .wbd_we_o  (),
        .wbd_stb_o (),
        .wbd_cyc_o (),

        // 外部中断：高电平表示未触发
        .int0_i (1'b1),
        .int1_i (1'b1),

        // GPIO：未接外部输入的端口先固定为高
        .p0_i (8'hFF),
        .p1_i (8'hFF),
        .p2_i (8'hFF),
        .p3_i (8'hFF),

        .p0_o (),
        .p1_o (p1_out),
        .p2_o (),
        .p3_o (),

        // 串口暂不使用，接收端保持空闲高电平
        .rxd_i (1'b1),
        .txd_o (),

        // 外部计数输入暂不使用
        .t0_i   (1'b1),
        .t1_i   (1'b1),
        .t2_i   (1'b1),
        .t2ex_i (1'b1)
    );
	 
	 
	 
	 //
	 // 根据字节地址，返回一个程序字节
function [7:0] program_byte;
    input [15:0] addr;
    begin
        case (addr)
            // MOV P1, #00H
            16'h0000: program_byte = 8'h75;
            16'h0001: program_byte = 8'h90;
            16'h0002: program_byte = 8'h00;

            // SJMP $：停在这里循环
            16'h0003: program_byte = 8'h80;
            16'h0004: program_byte = 8'hFE;

            default: program_byte = 8'h00;
        endcase
    end
endfunction

reg [31:0] rom_data_r;
reg        rom_ack_r;

// 同步读取：数据与应答一起寄存输出
always @(posedge clk or posedge cpu_rst) begin
    if (cpu_rst) begin
        rom_data_r <= 32'h00000000;
        rom_ack_r  <= 1'b0;
    end else begin
        rom_ack_r <= rom_stb && rom_cyc;

        if (rom_stb && rom_cyc) begin
            rom_data_r <= {
                program_byte(rom_addr + 16'd3),
                program_byte(rom_addr + 16'd2),
                program_byte(rom_addr + 16'd1),
                program_byte(rom_addr)
            };
        end
    end
end

assign rom_data = rom_data_r;
assign rom_ack  = rom_ack_r;

endmodule

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	