/*
MODULE OVERVIEW:
This module represents the intelligent memory of the CC770.
*/

module memory (
input            clk,        //clock
input            rst_n,      //active low reset
input            rw,         //read(1) or write(0)
input  [7:0]     addr,       //read and write address
input  [7:0]     Din,        //input data bus
output [7:0]     Dout        //output data bus
);

reg [7:0] registers[0:255];             //internal register array

integer i;                              //loop variable to address the register array

always @(posedge clk or negedge rst_n)
begin
 if(~rst_n)
 begin
  for(i = 0; i < 256; i = i + 1)
   registers[i] <= 8'h00;                               //clearing all the contents of the array
 end
 else if(~rw)
  registers[addr] <= Din;                               //writing into the register
end

assign Dout = (rw) ? registers[addr] : 8'hzz;           //reading from the register

endmodule