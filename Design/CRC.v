/*
MODULE OVERVIEW:
This module computes the Cyclic Redundancy Check for an input bitstream.
The generator polynomial that is used to carry out the polynomial division is x^15 + x^14 + x^10 + x^8 + x^7 + x^4 + x^3 + x^0.
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

always @(posedge clk or negedge rst_n)
begin
 if(~rst_n)
 begin
  crc <= 15'h0000;
  count <= 0;
 end
 else
 begin
  crc[0] <= Din ^ crc[14];
  crc[3] <= crc[2] ^ crc[14];
  crc[4] <= crc[3] ^ crc[14];
  crc[7] <= crc[6] ^ crc[14];
  crc[8] <= crc[7] ^ crc[14];
  crc[10] <= crc[9] ^ crc[14];
  crc[14] <= crc[13] ^ crc[14];

  crc[2:1] <= crc[1:0];
  crc[6:5] <= crc[5:4];
  crc[9] <= crc[8];
  crc[13:11] <= crc[12:10];

  count <= count + 1;
  if(count == size + 14)
  begin
   count <= 0;
   crc <= 15'h0000;
  end
 end
end

assign checksum = (count == size + 14) ? crc : 15'hzzzz;

endmodule
