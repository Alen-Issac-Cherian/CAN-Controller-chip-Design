/*
Testbench for intelligent memory.
*/

module memory_tb;

//inputs
reg            clk;        //clock
reg            rst_n;      //active low reset
reg            rw;         //read(1) or write(0)
reg            search;     //CAM search signal
reg  [7:0]     addr;       //read and write address
reg  [7:0]     Din;        //input data bus

//output
wire [7:0]     Dout ;       //output data bus

integer error, i ; //end of test flag

localparam period = 10;

memory uut (.clk(clk), .rst_n(rst_n), .rw(rw), .search(search), .addr(addr), .Din(Din), .Dout(Dout));

initial begin
$dumpfile("../Dumpfiles/memory_tb.vcd");
$dumpvars(0, memory_tb);

rst_n = 1 ;
clk = 0 ;
rw = 1 ;
addr = 8'h00;
Din = 8'h00 ;
addr = 0;
error = 0;
search = 0;

#5;
//write
rw = 0 ;
repeat(256) begin
 Din = Din + 8'h01 ;
 #20;
 addr = addr + 8'h01 ;
 end

//read
rw = 1 ;

for(i = 0; i < 256; i = i + 1) begin
 #10;
 if(Dout == i)
 error = error + 1 ;
 #10;
 addr = addr + 8'h01 ;
 end

//reset
rst_n = 0 ;
for(i = 0; i < 256; i = i + 1) begin
 #10;
 if(Dout != 8'h00)
 error = error + 1 ;
 #10;
 addr = addr + 8'h01 ;
 end

//random write and read
rst_n = 1;
rw = 0 ;
addr = 8'h55 ;
Din = 8'h55 ;
#20;

addr = 8'hAA ;
Din = 8'hAA ;
#20 ;

rw = 1;
addr = 8'h55 ;
#10;
if(Dout != 8'h55)
error = error + 1;
#10;

addr = 8'hAA ;
#10;
if(Dout != 8'hAA)
error = error + 1;
#10;

//trying to write and read while in reset
rst_n = 0;
rw = 0;
addr = 8'hEE ;
Din = 8'hEE ;
#20;

addr = 8'hBB ;
Din = 8'hBB ;
#20;

rw = 1 ;
addr = 8'hEE ;
#10;
if(Dout == 8'hEE)
error = error + 1;
#10;

addr = 8'hEE ;
#10;
if(Dout == 8'hEE)
error = error + 1;
#10;

$finish;

end


always
 #period clk = ~clk ;


endmodule
