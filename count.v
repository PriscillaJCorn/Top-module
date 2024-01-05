`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/05 15:46:33
// Design Name: 
// Module Name: count
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


module count(
    input clk,
    input rst,
    input locked,
    input [13:0] num,
    output reg com = 0
    );
     
   
     reg [15:0] cnt = 16'd0; 
     reg [13:0] compare_number = 14'd0;
     reg current;
    
    always@(posedge clk or negedge rst)  
	begin
		if (!rst || locked) 
            begin   
                com <= 1'b0;
                compare_number <= 14'd0;
                cnt <= 16'd0; 
                current <= 1'b0;
            end
		else if (cnt == 16'h50DC)
            begin
                 case(current)
                  
                  0: begin
                     if (compare_number == num)begin
                         current <= 1'b1; 
                         cnt <= 16'd0; 
                         com <= 1'b0;
                     end
                     else begin
                        cnt <= 16'd0;
                        current <= 1'b0;
                        com <= 1'b0;
                        compare_number <= num;
                     end
                  end
                  
                  
                  1:begin
                    if (compare_number == num)begin
                          com <= 1'b1;
                     end
                     else begin
                          cnt <= 16'd0;
                          current <= 1'b0;
                          compare_number <= num;
                          com <= 1'b0;
                     end               
                  end
                 endcase
            end	   
        else  
            
            cnt <= cnt + 1'b1;
	end

endmodule
