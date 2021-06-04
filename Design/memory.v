/*
MODULE OVERVIEW:
This module represents the intelligent memory of the CC770.
*/

module memory (
input            clk,        //clock
input            rst_n,      //active low reset
input            rw,         //read(1) or write(0)
input            search,     //active high status signal to perform CAM search. Driven by CAN controller
input  [7:0]     addr,       //read and write address
input  [7:0]     Din,        //input data bus
output reg [7:0] Dout        //output data bus
);

reg [7:0] registers[0:255];             //internal register array
reg [7:0] location;

wire w1;
reg flag;

assign w1 = {search,rw};                //concatinating rw and search

integer i;                              //loop variable to address the internal registers

always @(posedge clk or negedge rst_n)
begin
 if(~rst_n)
 begin
  for(i = 0; i < 256; i = i + 1)
   registers[i] <= 8'h00;                               //clearing all the contents of the array
 end
 else if(search)
 begin
  for(i = 0; (i < 256) && (flag == 1'b0) ; i = i + 1)
  begin
   if(Din == registers[i])
   begin
    location <= i;
    flag <= 1'b1;
   end 
   else flag <= 1'b0;
  end
 end
 else if(~rw)
  registers[addr] <= Din;                               //writing into the register
end

always @(*)
begin
 case(w1)
  00: Dout = 8'hzz;
  01: Dout = registers[addr];                           //reading from the register
  10: Dout = (flag) ? location : 8'hzz;                 //searching the registers
  11: Dout = (flag) ? location : 8'hzz;                 //searching the registers
 endcase
end

endmodule