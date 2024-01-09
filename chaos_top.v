`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/10 09:01:59
// Design Name: 
// Module Name: chaos_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module chaos_top(
    input wire clk,
    input wire rst,
    output wire [13:0] x,
    output wire [13:0] y,
    output wire [13:0] z,
    output wire daclk_1,
    output wire daclk_2,
    output wire ws_1,
    output wire ws_2
    );
    

    wire clock_200M;
    wire clk_lock;
    wire en_1;
    wire en_2;
    wire en_3;
    wire en;
    wire comp;
    wire coms;
    wire waitt;
    wire count_start;

    wire [31:0] dx;
    wire [31:0] dy;
    wire [31:0] dz;
    wire [31:0] tanhx;
    wire [31:0] tanhy;
    wire [31:0] tanhz;
    
    wire signal;
    wire signal_1;
    wire signal_2;
    wire signal_3;
   
    
    assign en = en_1 & en_2 & en_3;
    
    NeuralNetwork  chaos0(
    .clk(clock_200M),
    .rst(rst),
    .locked(clk_lock),
    .en(en),
    .rest(0),
    .sig(signal),
    .sig_1(signal_1),
    .sig_2(0),
    .sig_3(signal_3),
    .rst_com(),
    .tanx(tanhx),
    .tany(tanhy),
    .tanz(tanhz),
    .x(x),
    .y(y),
    .z(z),
    .com(comp),
    .ddx(dx), //dx 32
	.ddy(dy), //dy 32		
	.ddz(dz), //
	.wa(waitt),
    .daclk_1(daclk_1),
    .daclk_2(daclk_2),
    .ws_1(ws_1),
    .ws_2(ws_2)
    );

    
    tanhx hx(
    .clk(clock_200M),
    .locked(count_start),
    .rst(rst),
    .wa(waitt),
    .comp(comp),
    .ox(dx),
    .tanh(tanhx),
    .en(en_1)
    );
    
    tanhy hy(
    .clk(clock_200M),
    .locked(count_start),
    .rst(rst),
    .wa(waitt),
    .comp(comp),
    .oy(dy),
    .tanh(tanhy),
    .en(en_2)
    );
    
    tanhz hz(
    .clk(clock_200M),
    .locked(count_start),
    .rst(rst),
    .wa(waitt),
    .comp(comp),
    .oz(dz),
    .tanh(tanhz),
    .en(en_3)
    );
    
    pwfunction pw1(
    .clk(clock_200M),
    .rst(rst),
    .locked(clk_lock),
    .com(),
    .sig_out(signal)
    );
    
    singal pw2(
    .clk(clock_200M),
    .rst(rst),
    .locked(clk_lock),
    .sig_out_1(signal_1),
    .sig_out_2(signal_2),
    .sig_out_3(signal_3)
    );
    
    
    clk_wiz_0 U0(
   .clk_out1(clock_200M),
   .reset(~rst),
   .locked(clk_lock),
   .clk_in1(clk)
 );
 


    
endmodule
