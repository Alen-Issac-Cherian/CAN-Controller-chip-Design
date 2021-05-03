

module CRC_tb;

reg clk, rst_n, valid;
reg [15:0] size;
reg [23:0] Din;

wire [14:0] checksum;

CRC check (clk, rst_n, Din, valid, size, checksum);

initial
begin
 $dumpfile("../Dumpfiles/CRC_tb.vcd");
 $dumpvars(0, CRC_tb);

 size = 15'd3;
 rst_n = 0;
 Din = 24'habcdef;
 valid = 0;
 #10;
 rst_n = 1;
 #5;
 valid = 1;
 #5;
 valid = 0;
 #40
 Din = 24'hfedcba;
 valid = 1;
 #60;
 $finish;
end

always
begin
 clk = 1'b1;
 #1;
 clk = 1'b0;
 #1;
end

endmodule
