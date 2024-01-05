`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/11 09:43:33
// Design Name: 
// Module Name: singal
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


module singal(
    input clk,
    input rst,
    input locked,
    output  wire sig_out_1,
    output  wire sig_out_2,
    output  wire sig_out_3
    );

    
    reg   vawe_1 = 0;
	reg   vawe_2 = 0;
	reg   vawe_3 = 0;


	reg [23:0] cnt_1;
	reg [23:0] cnt_2;
	reg [23:0] cnt_3;
	

	assign	    sig_out_1 = vawe_1;
	assign      sig_out_2 = vawe_2;
	assign      sig_out_3 = vawe_3;
	      
		
	always@(posedge clk or negedge rst)
		if (rst == 0 && locked == 0)
		 begin
			cnt_1 <= 24'd0;
			cnt_2 <= 24'd0;
			cnt_3 <= 24'd0;      
		end
		else if (cnt_1 == 24'h24C5D9)
		begin
				  cnt_1 <= 24'd0;
				  cnt_2 <= cnt_2 + 1'b1;	
				  cnt_3 <= cnt_3 + 1'b1;				  
		end		  			  
		else if (cnt_2 == 24'h265831)
		begin
				  cnt_2 <= 24'd0;  
				  cnt_1 <= cnt_1 + 1'b1;
				  cnt_3 <= cnt_3 + 1'b1;		 
		end		  			  
		else if (cnt_3 == 24'h27DED1)
		begin
				  cnt_3 <= 24'd0;  
				  cnt_1 <= cnt_1 + 1'b1;
				  cnt_2 <= cnt_2 + 1'b1;				  
		end				  
		else begin
				 cnt_1 <= cnt_1 + 1'b1;		  
				 cnt_2 <= cnt_2 + 1'b1;		  
				 cnt_3 <= cnt_3 + 1'b1;				
		end 
		  		
	always@(posedge clk or negedge rst)  
	begin
		if (rst == 0 && locked == 0) 
		begin   
			vawe_1 <= 1'b1;
			vawe_2 <= 1'b1;
			vawe_3 <= 1'b1;
		end
		else if (cnt_1 == 24'h24C5D9)
		   vawe_1 <= ~vawe_1;
		else if (cnt_2 == 24'h265831)
		   vawe_2 <= ~vawe_2;	
		else if (cnt_3 == 24'h27DED1)
		   vawe_3 <= ~vawe_3;
		else begin
		    vawe_1 <= vawe_1;
			vawe_2 <= vawe_2;
			vawe_3 <= vawe_3;
		end
	end

endmodule
