

module CRC_tb;

reg clk, rst_n, Din;
reg [15:0] size;

reg [15:0] data;
reg [3:0] ptr;

wire [14:0] checksum;

CRC check (clk, rst_n, Din, size, checksum);

initial
begin
 $dumpfile("../Dumpfiles/CRC_tb.vcd");
 $dumpvars(0, CRC_tb);

 data = 16'habcd;
 ptr = 4'd15;
 size = 15'd16;
 rst_n = 0;
 #9;
 rst_n = 1;
 #130;
 $finish;
end

always
begin
 clk = 1'b1;
 #1;
 clk = 1'b0;
 #1;
end

always @(posedge clk)
begin
 Din = data[ptr];
 if(rst_n)
  ptr <= ptr - 4'd1;
end

endmodule
