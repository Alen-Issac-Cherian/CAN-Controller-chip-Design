/*
MODULE OVETVIEW 
This module is a 8 bit sequnce detector which detects the seqence
loaded manually.
*/

module seq_8(
 input clk,
 input rst_n, load,
 input din,
 output reg dout
 );

reg din_buff;
reg [7:0] data ;
reg [2:0] counter ;
reg [2:0] ps, ns ;

parameter idle = 3'b001, u_data = 3'b010, s_data = 3'b100 ; 

always@(posedge clk)
begin : seq_pro
 if(rst_n == 1'b1) begin
  ps <= idle ;
  data <= 8'bzzzzzzzz ;
 end

 else
  din_buff <= din ;
  ps <= ns ;
end

always@(ps, load)
begin : com_pro
 ns <= idle ;
 dout <= 0 ;


 case(ps)
  idle : begin
  		  counter = 3'b000 ;
  		  din_buff = 1'bz;
  		  if(load == 1)
  	       ns <= u_data ;
  		  else ns <= s_data;
  		 end

  u_data : begin
  		    data[counter] = din_buff ;
  		    counter = counter + 3'b001 ;

  		    if(counter == 3'b000)
  		   	 ns <= idle ;
  		    else ns <= u_data ;
  		   end

  s_data : begin 
   			if(din_buff == data[counter]) begin 
   			  counter = counter + 3'b001 ;
   			   if(counter == 3'b000)
   			    dout = 1 ;
   			   else dout = 0 ;
   			 end
   			else begin 
			  counter = 3'b000 ;
			  dout = 0 ;
			 end

			 ns <= s_data ;
		   end 

  default : begin
  			 dout <= 0 ;
  			 ns <= idle ;
  			 counter <= 3'b000 ;
  			end
 endcase
end 		//end of com block.



endmodule 





  			
