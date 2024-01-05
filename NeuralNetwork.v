module NeuralNetwork(
    input clk,
    input rst,
    input locked,
    input en,
    input wire [31:0] tanx,
    input wire [31:0] tany,
    input wire [31:0] tanz,
    input wire rest,
    input wire sig,
    input wire sig_1,
    input wire sig_2,
    input wire sig_3,
    output reg rst_com,
    output reg [13:0] x,
    output reg [13:0] y,
    output reg [13:0] z,
    output reg	signed [31:0] ddx, //dx 32
	output reg	signed [31:0] ddy, //dy 32		
	output reg	signed [31:0] ddz, //
	output reg com,
	output reg wa = 1'b1,
    output reg daclk_1,
    output reg daclk_2,
    output reg ws_1,
    output reg ws_2
    );
    
        parameter XYZ_WIDTH=32;  //
		parameter TMP_WIDTH=64;  //

        parameter m = 9;
		parameter n = 10;
		parameter g = 3;
		parameter h = 16;
		parameter p = 0;
		
		
		parameter signed	a = 32'b0_00010_00110011001100110011001101;// a = 2.2	
		parameter signed	b = 32'b0_00001_00110011001100110011001101;// b = 1.2
		parameter signed	c = 32'b0_00001_01100110011001100110011010;// c = 1.4    
		parameter signed	d = 32'b0_00001_00100110011001100110011010; //d = 1.15
        parameter signed	e = 32'b0_00101_00000000000000000000000000; //e = 5

	
		
	
        

		
		reg signed[XYZ_WIDTH-1:0]	tanhx = 32'd0; 
		reg signed[XYZ_WIDTH-1:0]	tanhy = 32'd0; 
		reg signed[XYZ_WIDTH-1:0]	tanhz = 32'd0;

		

		reg signed[XYZ_WIDTH-1:0]	x0 = 32'b0_00000_00000000000000000000000000; //  
		reg signed[XYZ_WIDTH-1:0]	y0 = 32'b0_00000_00011001100110011001100110; //   0.1
		reg signed[XYZ_WIDTH-1:0]	z0 = 32'b0_00000_00000000000000000000000000;  //
		
		reg signed[XYZ_WIDTH-1:0]	x00 = 32'b0_00000_00000000000000000000000000; //  
		reg signed[XYZ_WIDTH-1:0]	y00 = 32'b0_00000_00011001100110011001100110; //   0.1
		reg signed[XYZ_WIDTH-1:0]	z00 = 32'b0_00000_00000000000000000000000000;  //
		
		
	
		
  
        reg signed[XYZ_WIDTH-1:0]   x_offset = 32'b0_00100_00000000000000000000000000; 	// x,y,z ?????????????? 0	
        reg signed[XYZ_WIDTH-1:0]   y_offset = 32'b0_00100_00000000000000000000000000;
		reg signed[XYZ_WIDTH-1:0]   z_offset = 32'b0_01010_00000000000000000000000000;
		
		
	

        reg   	signed[XYZ_WIDTH-1:0]	dx; 	
		reg   	signed[XYZ_WIDTH-1:0]	dy; 	
		reg   	signed[XYZ_WIDTH-1:0]	dz; 	
	
			
        reg		signed[XYZ_WIDTH-1:0]	fx;  //fx 32
		reg		signed[XYZ_WIDTH-1:0]	fy;	// fy 32
		reg		signed[XYZ_WIDTH-1:0]	fz;	//
	


	
		

		reg	signed[TMP_WIDTH-1:0]	atanhx; //  
	    reg	signed[TMP_WIDTH-1:0]	btanhy; //  
	    reg	signed[TMP_WIDTH-1:0]	atanhx_sub_btany; // 
	    reg	signed[XYZ_WIDTH-1:0]	ptanhz; //  
	    reg signed[XYZ_WIDTH-1:0]	atanhx_sub_btany_add_ptanz; //
	    reg signed[XYZ_WIDTH-1:0]	atanhx_sub_btany_add_ptanz_sub_x; // 

		
		reg	signed[TMP_WIDTH-1:0]	dtanhz; //  
		reg	signed[TMP_WIDTH-1:0]	ctanhy; // 
		reg	signed[TMP_WIDTH-1:0]	ctanhy_add_dtanhz; // 
		reg	signed[XYZ_WIDTH-1:0]	pptanhx;	// 
		reg	signed[XYZ_WIDTH-1:0]	ctanhy_add_dtanhz_sub_y; // 
		reg	signed[XYZ_WIDTH-1:0]	ctanhy_add_dtanhz_add_pptanhx_sub_y; // 
		 
		 
		reg	signed[TMP_WIDTH-1:0]	etanhx ;  
		reg	signed[XYZ_WIDTH-1:0]	mz ; // 
		reg	signed[XYZ_WIDTH-1:0]	mz_sub_tanhz ; // 
		reg signed[XYZ_WIDTH-1:0]   mz_sub_tanhz_sub_etanhy; //
		
		
		

	
		
		reg	signed[XYZ_WIDTH-1:0]	x_tmp = 32'd0; // dx/dt 32
		reg	signed[XYZ_WIDTH-1:0]	y_tmp = 32'd0;// dy/dt 32
		reg	signed[XYZ_WIDTH-1:0]	z_tmp = 32'd0; // dz/dt 32
		
		
		
        reg	signed[XYZ_WIDTH:0]	x_ttmp  = 33'd0; // dx/dt 32
		reg	signed[XYZ_WIDTH:0]	y_ttmp  =33'd0;// dy/dt 32
		reg	signed[XYZ_WIDTH:0]	z_ttmp  =33'd0; // dz/dt 32
	
	

	
	    reg signed[XYZ_WIDTH:0]   x_add = 33'b0_000010_10000000000000000000000000; 	// x,y,z ?????????????? 0	
        reg signed[XYZ_WIDTH:0]   y_add = 33'b0_000001_10000000000000000000000000;
		reg signed[XYZ_WIDTH:0]   z_add = 33'b0_000110_00000000000000000000000000;


		
		reg	  [4:0] state_1;  // 4��??
		reg   step_1;
		reg   step_2;
		reg   step_3;
		reg   siggg;
		

	  

	
						
	always@( posedge clk or negedge rst )    //������ʱ�Ϳ�ʼִ��always��������
			begin
			if(rst == 1'b0 || locked == 1'b0 || rest == 1'b1)   //�жϸ�λ�ź�Ϊ0   ������λ�źŴ��� ��ϵͳά�ָ�ֵ״̬��
					begin
						dx <= x00;
						dy <= y00;
						dz <= z00; //��ֵ����
                        x0 <= x00;
                        y0 <= y00;
						z0 <= z00; //��ֵ����
						fx <= 32'd0;
						fy <= 32'd0;
						fz <= 32'd0;
						state_1 <= 5'd0; //���嵱ǰ״̬s0
				        step_1 <= 1'b0;
				        step_2 <= 1'b0;
				        rst_com <= 1'b1;
					end
			  else  begin   //����λ���ͷţ�
	
		    	case(state_1) //�жϵ�ǰ״̬
			            
			             
			             
			             
			             0+p:  begin 
			                      rst_com <= 1'b0;              
			                      com <= 1'b0;
                                  state_1 <= state_1 + 1'b1;
                              end
			            
						1+p:begin
						          wa <= 1'b0;
			                      ddx <= dx; // dx
			                      ddy <= dy; // dy
			                      ddz <= dz; // dz
                                  state_1 <= state_1 + 1'b1;
                           end
			             
			            		
						2+p: begin  // wait for tanh calculating complete
						    if (en == 1) begin
						        tanhx <= tanx;
						        tanhy <= tany;
						        tanhz <= tanz;
						        state_1 <= state_1 + 1'b1;
						    end
						    else 
						        state_1 <= state_1;
						end	
				
	                      
	                 
	                    
						3+p:   
						 		begin		
						 		    daclk_1 <= 1'b0;
                                    daclk_2 <= 1'b0;
                                    ws_1 <= 1'b0;
                                    ws_2 <= 1'b0;
									atanhx<= a * tanhx;	 //2.2tanhx   x
									pptanhx <= tanhx <<< 1; //2tanhx   y
									etanhx <= e * tanhx; //5tanhx   z
									state_1 <= state_1 + 1'b1; //״̬+1
								end
		
						
						
						
						
						4+p:   
						 		begin	 	 		        
                                        mz <=  ~dz + 1'b1;  // -z    z
                                        btanhy <= b * tanhy; // 1.2tanhy     x
                                        ptanhz <= tanhz >>> 1; //0.5tanhz    x
                                        ctanhy <= tanhy * c; // 1.5tany     y
									    dtanhz <= d * tanhz; //1.15tanhz    y
                                        state_1 <= state_1 + 1'b1; //״̬+1
								end
								
								
					       
	                   5+p: //   
		                       begin
		                           if (sig == 1) begin
		                                atanhx_sub_btany <= atanhx - btanhy;      // x  2.2tanhx - 1.2tanhy             
		                                siggg <= 1'b1;
                                        state_1 <= state_1 + 1'b1;
                                    end
                                    else begin
                                        atanhx_sub_btany <= atanhx + btanhy; //     x   2.2tanhx + 1.2tanhy         
                                        siggg <= 1'b0;                                      
                                        state_1 <= state_1 + 1'b1;
						            end
							   end		
							   
						
						
			          	6+p:   //
						 		begin		
									ctanhy_add_dtanhz <= ctanhy + dtanhz;//     y  1.5tanhy + 1.15tanhz  
									mz_sub_tanhz <= mz - tanhz;//              z		-z - tanz						
									state_1 <= state_1 + 1'b1; //״̬+1
								end
			
			             
						7+p: //   
		                  begin
								    atanhx_sub_btany_add_ptanz <={atanhx_sub_btany[TMP_WIDTH-1],atanhx_sub_btany[TMP_WIDTH-8:XYZ_WIDTH-6]}  - dx;
									state_1 <= state_1 + 1'b1;		//״̬+1			
							end		
				
			             
				     
					
						
						8+p:   // 
                            begin
		                           if (siggg == 1) begin
		                               atanhx_sub_btany_add_ptanz_sub_x <= atanhx_sub_btany_add_ptanz + ptanhz;//  x  2.2tanhx - 1.2tanhy + 0.5tanhz  
		                               ctanhy_add_dtanhz_sub_y <=  {ctanhy_add_dtanhz[TMP_WIDTH-1],ctanhy_add_dtanhz[TMP_WIDTH-8:XYZ_WIDTH-6]} + pptanhx; // y  1.5tanhy + 1.15tanhz + 2tanhx 
		                               mz_sub_tanhz_sub_etanhy <= mz_sub_tanhz - {etanhx[TMP_WIDTH-1],etanhx[TMP_WIDTH-8:XYZ_WIDTH-6]};// -z - tanhz - 5tanhx  z compelet
                                        state_1 <= state_1 + 1'b1;
                                    end
                                    else begin
                                       atanhx_sub_btany_add_ptanz_sub_x <= atanhx_sub_btany_add_ptanz - ptanhz;//  x  2.2tanhx + 1.2tanhy - 0.5tanhz  
                                       ctanhy_add_dtanhz_sub_y <=  {ctanhy_add_dtanhz[TMP_WIDTH-1],ctanhy_add_dtanhz[TMP_WIDTH-8:XYZ_WIDTH-6]} - pptanhx;// y  1.5tanhy + 1.15tanhz - 2tanhx 
                                       mz_sub_tanhz_sub_etanhy <= mz_sub_tanhz + {etanhx[TMP_WIDTH-1],etanhx[TMP_WIDTH-8:XYZ_WIDTH-6]};// -z - tanhz + 5tanhx  z compelet
                                       state_1 <= state_1 + 1'b1;
						            end
							   end			   
					
						9+p:  //   
								begin
									ctanhy_add_dtanhz_add_pptanhx_sub_y <=  ctanhy_add_dtanhz_sub_y - dy;// 2.2tanhx - 1.2tanhy - x + 0.5tanz x compelet  
									state_1 <= state_1 + 1'b1;								
								end
						  
				
			
					10+p:  //   
								begin
									fx	<= atanhx_sub_btany_add_ptanz_sub_x; 
									fy	<= ctanhy_add_dtanhz_add_pptanhx_sub_y;
									fz	<= mz_sub_tanhz_sub_etanhy;		
									com <= 1'b1;
								   	wa  <=1'b1;	 
									state_1 <= state_1 + 1'b1;								
								end
				
		
								
						11+p:  //Ϊ�����������  �ж� �� X1/2 = X0 + dX1/dt/256  ���� X1 = X0 + dX2/dt/128
								begin							
									case(step_1)  
									
						           1'b0:	
											begin		// ���� X1/2 = X0 + dX1/dt/256 		 		
                                                        dx <= x0 + (fx >>> m);   
                                                        dy <= y0 + (fy >>> m);
                                                        dz <= z0 + (fz >>> m); 
                                                        step_1 <= step_1 + 1'b1;
                                                        state_1 <= 0;         
											end
											
										1'b1:
											begin  // ���� X1 = X0 + dX2/dt/128  �� x1 ��Ϊ���
                                                    dx <= x0 + (fx >>> n);   
                                                    dy <= y0 + (fy >>> n);
                                                    dz <= z0 + (fz >>> n); // һ�ζ����������������� ��Ϊ��һ������	
                                                    state_1 <= state_1 + 1'b1;
                                              end
									endcase									
								end
						
						
						
							
                      12+p:  
								begin 
										case(step_2) 	
										  1'b0:
											begin  // ���� X1 = X0 + dX2/dt/128  �� x1 ��Ϊ���
											     
                                                    dx <= x0 + (fx >>> n);   
                                                    dy <= y0 + (fy >>> n);
                                                    dz <= z0 + (fz >>> n); // һ�ζ����������������� ��Ϊ��һ������	
                                                    step_2 <= step_2 + 1'b1;
                                                    state_1 <= 0;
                                               end
											
										1'b1:	
											begin  // ���� X1 = X0 + dX2/dt/128  �� x1 ��Ϊ���
											     
                                                    dx <= x0 + (fx >>> m);   
                                                    dy <= y0 + (fy >>> m);
                                                    dz <= z0 + (fz >>> m); // һ�ζ����������������� ��Ϊ��һ������	
                                                    state_1 <= state_1 + 1'b1;
                                               end
									endcase									
								end	
								
						 13+p:  //���һ�ζ��������������  ���ֵ����ƫ����
								begin 
										x_tmp <= dx + x_offset;	 
										y_tmp <= dy + y_offset;
										z_tmp <= dz + z_offset;		
										x0 <= dx;
										y0 <= dy;
										z0 <= dz;  //����ǰ������ֵ  ���� x0�д洢		
										state_1 <= state_1 + 1'b1;       		
								 end	
			
						
							14+p: begin
							         x_ttmp <= {x_tmp[XYZ_WIDTH-1],1'b0,x_tmp[XYZ_WIDTH-2:0]};
							         y_ttmp <= {y_tmp[XYZ_WIDTH-1],1'b0,y_tmp[XYZ_WIDTH-2:0]};
							         z_ttmp <= {z_tmp[XYZ_WIDTH-1],1'b0,z_tmp[XYZ_WIDTH-2:0]};
							         state_1 <= state_1 + 1'b1;
							end
								
							15:   //����   y-x xz xy
							begin			
								 if    (sig_1 == 0) 
								 begin  // ���Ϊ��
										 x_ttmp <= x_ttmp;	
										 state_1 <= state_1 + 1'b1;
								 end		
								 else begin
								         x_ttmp <= x_ttmp - x_add ;
										state_1 <= state_1 + 1'b1;	
								 end
							end
							
			               16 :   //����   y-x xz xy
							begin			
								 if    (sig_2 == 0) 
								 begin  // ���Ϊ��
										 y_ttmp <= y_ttmp;	
										 state_1 <= state_1 + 1'b1;
								 end		
								 else begin
								         y_ttmp <= y_ttmp - y_add ;
										state_1 <= state_1 + 1'b1;	
								 end
							end
			
			             17:   //����   y-x xz xy
							begin			
								 if    (sig_3 == 0) 
								 begin  // ���Ϊ��
										 z_ttmp <= z_ttmp;	
										 state_1 <= state_1 + 1'b1;
								 end		
								 else begin
								         z_ttmp <= z_ttmp - z_add ;
										state_1 <= state_1 + 1'b1;	
								 end
							end
								
						
								
						18+p:	//10λ���				IU
								begin							
                                        x = {x_ttmp[XYZ_WIDTH-g:XYZ_WIDTH-h]};     // 10λ��� [ 26 : 13]
                                        y = {y_ttmp[XYZ_WIDTH-g:XYZ_WIDTH-h]};
                                        z = {z_ttmp[XYZ_WIDTH-g:XYZ_WIDTH-h]};
                                        step_1 <= 1'b0;
				                        step_2 <= 1'b0;
                                        state_1 <= 0;
                                        daclk_1 <= 1'b1;
                                        daclk_2 <= 1'b1;
                                        ws_1 <= 1'b1;
                                        ws_2 <= 1'b1;
								end
								
    						default: // ����״̬ ��ת�� 0״̬
    								state_1 <= 5'b0;
    		
    					endcase
    
    					end
    				end			
    		endmodule