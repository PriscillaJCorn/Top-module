module tanhz(
    input clk,
    input rst,
    input [31:0] oz,
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
    reg signed [two-1:0] subdz9;
    reg signed [two-1:0] subdz99;
       
    
    
     reg signed [one-1:0] o_sub_t;
     reg signed [one-1:0] o_sub_t_add_f;
     reg signed [one-1:0] o_sub_t_add_f_sub_s;
    
     
     reg [3:0] statez;
     reg mz;
     reg signed [one-1:0] subdz;
     
     
     always@(posedge clk or negedge rst) begin
        if (rst == 1'b0  || locked == 1'b1) begin
       
        en <= 1'b0;
        statez <= 4'd0;
        subdz <= 32'd0;
        end
        else begin
            case (statez)
                0: begin
                    if (wa == 1) 
                        statez <= statez;
                 
                    else 
                        statez <= statez + 1'b1;
                end
                
                1: begin
                   subdz <= oz;
                   statez <= statez + 1'b1;
                end
                
                2: begin 
                    if (subdz[one-1] == 0) begin
                        mz <= 1'b0;
                        subdz <= subdz;
                        statez <= statez + 1'b1;
                    end
                    else begin
                        mz <= 1'b1;
                        subdz <= ~subdz + 1'b1;
                        statez <= statez + 1'b1;
                    end  
                end
            
                3: begin
                    if (subdz > onept) begin
                        tanh <= onee;
                        statez <= 4'd12;
                    end
                    else begin
                        statez <= statez + 1'b1;
                    end        
                end
                
                4: begin
                    x2 <= subdz * subdz;
                    statez <= statez + 1'b1;
                    en <= 1'b0;
                end
            
                 5: begin
                    x3 <= x2 * subdz;
                    statez <= statez + 1'b1;
                 end
                
                6: begin
                    ax3 <= x3 / a;
                    x5 <= {x3[three-1],x3[three-14:two-12]} * x2;
                    statez <= statez + 1'b1;
                end
                
                7: begin
                    bx5 <= x5 / b;
                    x7 <= {x5[three-1],x5[three-14:two-12]} * x2;
                    o_sub_t <= subdz - {ax3[two-1],ax3[two-8:one-6]};
                    statez <= statez + 1'b1;
                end
                
               8: begin
                    cx7 <= x7 / c;
                    x9 <= {x7[three-1],x7[three-14:two-12]} * x2;
                    o_sub_t_add_f <= o_sub_t + {bx5[two-1],bx5[two-8:one-6]};
                    statez <= statez + 1'b1;
                end
            
                9: begin
                    subdz9 <= x9 / d;
                    o_sub_t_add_f_sub_s <= o_sub_t_add_f - {cx7[two-1],cx7[two-8:one-6]};
                    statez <= statez + 1'b1;
                end
                
                10:begin
                    subdz99 <= subdz9 >>> 1;
                    statez <= statez + 1'b1;
                end
                
                11: begin
                    tanh <= o_sub_t_add_f_sub_s + {subdz99[two-1],subdz99[two-8:one-6]};
                    statez <= statez + 1'b1;
 
                end
                
                
                
                 12: begin
                      if (mz == 0) begin
                        tanh <= tanh;
                        statez <= statez + 1'b1;
                     end
                     else begin
                        tanh <= ~tanh + 1'b1;
                        statez <= statez + 1'b1;
                     end
                end
                
                
                13: begin
                    if (comp == 0) begin
                        en <= 1'b1;
                        tanh <= tanh;
                        statez <= statez;
                    end
                    else begin
                        en <= 1'b0;
                        statez <= 4'd0;
                end
               end 
        
            endcase
        end
     
     
     end
    
    
endmodule
