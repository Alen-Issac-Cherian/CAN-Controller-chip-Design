/*
MODULE OVERVIEW:
This module computes the Cyclic Redundancy Check for an input data byte of length 16 bits or more.
The generator polynomial that is used to carry out the polynomial division is x^15 + x^14 + x^10 + x^8 + x^7 + x^4 + x^3 + x^0,i.e, 1100010110011001.
The remainder has 15 bits.
*/

module CRC(
input           clk,        //Clock
input           rst_n,      //active low reset
input  [23:0]   Din,        //input data packet
input           valid,      //indicates if data is present in the input bus
input  [15:0]   size,       //number of bytes in the input data packet
output [14:0]   checksum    //remainder of the CRC calculation
);

integer shift_count;        //counts the number of left shifts
integer limit;              //maximum value of shift_count
wire finish;                //active high signal to indicate the end of CRC calculation

reg [15:0] crc;                                   //LFSR to implement CRC calculation
reg [15:0] polynomial = 16'b1100010110011001;     //Generator polynomial to perform modulo-2 division

reg CS, NS;
parameter IDLE = 1'b0, FIND = 1'b1;

//Sequential block to update CS state register
always @(posedge clk or negedge rst_n)
begin
 if(~rst_n)
  CS <= IDLE;
 else CS <= NS;
end

//Sequential block to perform CRC calculation
always @(posedge clk)
begin
 case(CS)
  IDLE:
  begin
   crc <= (valid) ? (Din >>(8*(size - 2))) : 16'hffff;            //to store the most significant 16 bits in crc if valid is high.
   shift_count <= 0;
  end
  FIND:
  begin
  if(crc[15] == 1'b0)                                             //if MSB is 0, then left shift the contents of crc.
  begin                                                           //During shifting, the LSB of crc must be either loaded with the remaining
   if(shift_count < 8*(size - 2))                                 //most significant bits of input data. After which the LSB will be loaded
    crc <= {crc[14:0],Din[8*(size - 2) - (shift_count + 1)]};     //with zeroes.
   else crc <= crc << 1;
   shift_count <= shift_count + 1;
  end
  else crc <= crc ^ polynomial;                                   //if MSB is 1, then xor the contents of crc with the generator polynomial.
  end
 endcase
end

//Combinatorial block to find NS state register
always @(*)
begin
 limit = 15 + (8*(size - 2));
 case(CS)
  IDLE:
  begin
   if(valid)
    NS = FIND;
   else NS = IDLE;
  end
  FIND:
  begin
   if(finish)
    NS = IDLE;
   else NS = FIND;
  end
  default: NS = IDLE;
 endcase
end

assign finish = ((shift_count == limit) && (crc[15] == 1'b0)) ? 1'b1 : 1'b0;
assign checksum = (finish) ? crc[14:0] : 15'hzzzz;

endmodule
