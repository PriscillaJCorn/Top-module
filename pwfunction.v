`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/11 09:50:27
// Design Name: 
// Module Name: pwfunction
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


module pwfunction(
    input clk,
    input rst,
    input locked,
    output wire sig_out,
    output reg com
    );

    reg   vawe_1 = 0;
	reg [23:0] cnt_1;
	reg [24:0] cnt_2;
    assign 	 sig_out   =  vawe_1;
   
   // p(t) only value  cnt_1 <= 23'b100_1100_1011_0110_0100_0000    cnt_2 <= 25'b100_1100_1011_0110_0100_0000_10  
    		
	always@(posedge clk or negedge rst) 
	begin
		if (rst == 0 && locked == 0)
		begin
			cnt_1 <= 24'd0;
			cnt_2 <= 25'd0;
			com <= 1'b0;
	    end
        else if (cnt_1 == 24'h498bb2)
        begin
			cnt_1 <= 24'd0;
			cnt_2 <= cnt_2 + 1'b1;
			com <= 1'b0;
	    end
	    else if (cnt_2 == 25'h931764) 
        begin
			cnt_1 <= cnt_1 + 1'b1;	
			com <= 1'b1;
			cnt_2 <= 25'd0;
	    end
		else begin
		    cnt_1 <= cnt_1 + 1'b1;		
		    cnt_2 <= cnt_2 + 1'b1;
			com <= 1'b0;
	    end  
	end		
	
		  
	always@(posedge clk or negedge rst)  
	begin
		if (rst == 0 && locked == 0) 
		begin   
			vawe_1 <= 1'b1;
		end
		else if (cnt_1 == 24'h498bb2)
		   vawe_1 <= ~vawe_1;
		else 
		    vawe_1 <= vawe_1;  
	end

endmodule
