/*
MODULE OVERVIEW:
This module is a 8 bit sequnce detector which detects the seqence
loaded manually.
Operation:
1)Reset the module.
2)Then provide the sequence to be detected in the serial input port.
  At the same time, make sure that the load port is set to 1.
3)Observe serial output port. If the specified sequence arrives in the input
  port, then a HIGH value is written to the output port.
*/

module seq_8(
 input          clk,				//clock.
 input          rst_n, 			//reset active low.
 input          load,			  //load input to change between u_data and s_data state.
 input          din,				//serial input.
 output         dout		    //output.
 );

reg flag = 0;
reg [7:0] data;		         //register to store the user data.
reg [2:0] counter;         //counter.
reg [2:0] ps, ns;		       //present state and next state.

parameter idle = 3'b001, u_data = 3'b010, s_data = 3'b100 ; 	//states.

always@(posedge clk or negedge rst_n)			//syncronous part
begin : syn_pro
 if(~rst_n)
  ps <= idle ;					     //idle on reset.
 else
  ps <= ns ;					       //state change.
end


always @(posedge clk)
begin
 case(ps)
  idle:
  begin
   counter <= 3'd7;
   data <= 8'h00;
  end
  u_data:
  begin
   data[counter] <= din;                       //accept the sequence from the user.
   counter <= counter - 3'd1;
  end
  s_data:
  begin
   if(din == data[counter])                    //serial data in din is checked with corresponding bit in data.
    counter <= counter - 3'd1;
   else counter <= 3'd7;
  end
 endcase
end

always@(ps, load, din)						//combinatorial part.
begin : com_pro
 case(ps)
  idle : begin
  		    if(load == 1)
  	       ns = u_data ;
  		    else ns = idle;
  		   end
  u_data : begin
  		      if(counter == 3'd0)
  		   	   ns = s_data ;
  		      else ns = u_data ;
  		     end
  s_data : begin
            flag = ((counter == 3'd0) && (din == data[counter])) ? 1 : 0;
			      ns = s_data ;						           //stay in the same state until reset is high.
		       end
  default : ns = idle;
 endcase
end

assign dout = (flag) ? 1 : 0;

endmodule
