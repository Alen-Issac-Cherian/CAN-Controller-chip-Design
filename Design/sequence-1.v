/*
MODULE OVETVIEW 
This module is a 8 bit sequnce detector which detects the seqence
loaded manually.
*/

module seq_8(
 input clk,				//clock.
 input rst, 			//reset active high.
 inout load,			//load input to change between u_data and s_data state.
 input din,				//serial input.
 output reg dout		//output.
 );

reg din_buff; 			//act as input buffer.
reg [7:0] data ;		//register to store the user data.
reg [2:0] counter ;		//counter.
reg [2:0] ps, ns ;		//present state and next state.

parameter idle = 3'b001, u_data = 3'b010, s_data = 3'b100 ; 	//states.

always@(posedge clk)			//syncronous part
begin : syn_pro
 if(rst == 1'b1) begin
  ps <= idle ;					//idle on reset.
  data <= 8'bzzzzzzzz ;			//high impedance state when reset.
 end

 else begin
  din_buff <= din ;				//serial data on din to the buffer on each poedge of clock.
  ps <= ns ;					//state change.
  end
end

always@(ps)						//combinatorial part.
begin : com_pro
 ns <= idle ;					// redundancy .
 dout <= 0 ;					//redundancy.


 case(ps)
  idle : begin
  		  counter = 3'b000 ;
  		  din_buff = 1'bz;
  		  if(load == 1)						//accept the sequence from the user.
  	       ns = u_data ;
  		  else ns = s_data;
  		 end

  u_data : begin 							//data by user is stored.
  		    data[counter] = din_buff ;		//8 bit sequnce stored in data register.
  		    counter = counter + 3'b001 ;	//counter to specify the position.

  		    if(counter == 3'b111)			
  		   	 ns = idle ;					//when 8 bits are taken goes to idle.
  		    else ns = u_data ;
  		   end

  s_data : begin 									//serial data accepted from din.
   			if(din_buff == data[counter]) begin 	//checks input serial data with data register.
   			  counter = counter + 3'b001 ;			
   			   if(counter == 3'b111)				
   			    dout = 1 ;							//if the sequence is same then output 1.
   			   else dout = 0 ;						//if sequence is not matching then output 0.
   			 end
   			else begin 
			  counter = 3'b000 ;					//counter is reset.
			  dout = 0 ;
			 end

			 ns = s_data ;							//stay in the same state until reset is high.
		   end 

  default : begin
  			 dout = 0 ;
  			 ns = idle ;
  			 counter = 3'b000 ;
  			end
 endcase
end 		//end of com block.



endmodule 





  			
