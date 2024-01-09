`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/10 09:00:25
// Design Name: 
// Module Name: tanhx
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


module tanhx(
     input clk,
    input rst,
    input [31:0] ox,
    input locked,
    input require,
    input comp,
    input wa,
    output reg signed [31:0] tanh,
    output reg en
    );
    
    parameter one = 32;
    parameter two = 64;
    parameter three = 96;
    
    
    parameter onee  = 32'b0_00001_00000000000000000000000000;
    parameter onept = 32'b0_00001_01001100110011001100110011;
    
    parameter a    =  32'b0_00011_00000000000000000000000000; //3
    parameter b    =  32'b0_00111_10000000000000000000000000; // 7.5
    parameter c    =  32'b0_10010_10000111100001101100001001;//18.5294
    parameter d    =  32'b0_10110_11011100111001110011100111;//22.8629
    
    
    
  
    
    
   
    reg signed [two-1:0] x2;
    
    reg signed [three-1:0] x3;
    reg signed [two-1:0] ax3;
    reg signed [three-1:0] x5;
    reg signed [two-1:0] bx5;
    reg signed [three-1:0] x7;
    reg signed [two-1:0] cx7;
    reg signed [three-1:0] x9;
    reg signed [two-1:0] subdx9;
    reg signed [two-1:0] subdx99;
       
    
    
     reg signed [one-1:0] o_sub_t;
     reg signed [one-1:0] o_sub_t_add_f;
     reg signed [one-1:0] o_sub_t_add_f_sub_s;
 
     
     reg [3:0] statex;
     reg signed [one-1:0] subdx;
     
     reg my;
     
     
     always@(posedge clk or negedge rst) begin
        if ( rst == 1'b0  || locked == 1'b1) begin
        en <= 1'b0;
        statex <= 4'd0;
        subdx <= 32'd0;
        end
        else begin
            case (statex)
                0: begin
                    if (wa == 1) 
                        statex <= statex;

                    else 
                        statex <= statex + 1'b1;
                end
                
                1: begin
                   
                   subdx <= ox;
                   statex <= statex + 1'b1;
                end
                
                2: begin 
                    if (subdx[one-1] == 0) begin
                        my <= 1'b0;
                        subdx <= subdx;
                        statex <= statex + 1'b1;
                    end
                    else begin
                        my <= 1'b1;
                        subdx <= ~subdx + 1'b1;
                        statex <= statex + 1'b1;
                    end  
                end
            
                3: begin
                    if (subdx > onept) begin
                        tanh <= onee;
                        statex <= 4'd12;
                    end
                    else begin
                        statex <= statex + 1'b1;
                    end        
                end
                
                4: begin
                    x2 <= subdx * subdx;
                    statex <= statex + 1'b1;
                end
            
                 5: begin
                    x3 <= x2 * subdx;
                    statex <= statex + 1'b1;
                 end
                
                6: begin
                    ax3 <= x3 / a;
                    x5 <= {x3[three-1],x3[three-14:two-12]} * x2;
                    statex <= statex + 1'b1;
                end
                
                7: begin
                    bx5 <= x5 / b;
                    x7 <= {x5[three-1],x5[three-14:two-12]} * x2;
                    o_sub_t <= subdx - {ax3[two-1],ax3[two-8:one-6]};
                    statex <= statex + 1'b1;
                end
                
               8: begin
                    cx7 <= x7 / c;
                    x9 <= {x7[three-1],x7[three-14:two-12]} * x2;
                    o_sub_t_add_f <= o_sub_t + {bx5[two-1],bx5[two-8:one-6]};
                    statex <= statex + 1'b1;
                end
            
                9: begin
                    subdx9 <= x9 / d;
                    o_sub_t_add_f_sub_s <= o_sub_t_add_f - {cx7[two-1],cx7[two-8:one-6]};
                    statex <= statex + 1'b1;
                end
                
                10: begin
                    subdx99 <= subdx9 >>> 1;
                    statex <= statex + 1'b1;
                end
                
                11: begin
                    tanh <= o_sub_t_add_f_sub_s + {subdx99[two-1],subdx99[two-8:one-6]};
                    statex <= statex + 1'b1;
                end
                
                12: begin
                      if (my == 0) begin
                        tanh <= tanh;
                        statex <= statex + 1'b1;
                     end
                     else begin
                        tanh <= ~tanh + 1'b1;
                        statex <= statex + 1'b1;
                     end
                end
                
                13: begin
                    if (comp == 0) begin
                        en <= 1'b1;
                        tanh <= tanh;
                        statex <= statex;
                    end
                    else begin
                        en <= 1'b0;
                        statex <= 4'd0;
                end
               end 
            endcase
        end   
     end
endmodule

