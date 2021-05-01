/*
MODULE OVERVIEW:
This module computes the Cyclic Redundancy Check for an input bitstream.
The generator polynomial that is used to carry out the polynomial division is x^15 + x^14 + x^10 + x^8 + x^7 + x^4 + x^3 + x^0,i.e, 1100010110011001.
The remainder has 15 bits.
*/

module CRC(
input           clk,        //Clock
input           rst_n,      //active low reset
input           Din,        //serial input
input  [15:0]   size,       //size of the input data packet
output [14:0]   checksum    //remainder of the CRC calculation
);

integer count;
reg [14:0] crc;
reg [14:0] polynomial = 15'b100010110011001;
wire LSB;
reg MSB;

always @(posedge clk or negedge rst_n)
begin
 if(~rst_n)
 begin
  count <= 0;
  crc <= 15'h0000;
  MSB <= 0;
 end
 else if(count == size + 15)
 begin
  count <= 0;
  crc <= 15'h0000;
  MSB <= 0;
 end
 else
 begin
  count <= count + 1;
  if (count >= 1)
  begin
   MSB <= crc[14];
   crc <= {crc[13:0],LSB};
   if(MSB == 1)
    crc <= crc ^ polynomial;
  end
  else MSB <= 0;
 end
end

assign LSB = (count <= size) ? Din : 1'b0;

assign checksum = (count == size + 15) ? crc : 15'hzzzz;

endmodule
