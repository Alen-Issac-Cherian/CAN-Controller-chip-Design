// test bench for sequence detector
//
//
module seq_8_test ;

 reg clk, rst_n, load, din;
 wire dout ;
 //reg [3:0] coun ;
 integer i;

 localparam period = 10;

 seq_8 uut (clk, rst_n, load, din, dout) ;

 initial begin
 $dumpfile("../Dumpfiles/seq_8_test.vcd");
 //$dumpfile("seq_8_test.vcd");
 $dumpvars(0, seq_8_test);

 rst_n = 0 ;
 clk = 0 ;
 load = 0 ;
 din = 0 ;
 #25 ;
  rst_n = 1 ;
  load = 1 ;
  for(i = 0 ; i < 4 ; i = i+1) begin
   #40 ;
    din = ~din ;
  end

  load = 0 ;

 #40 ;
  for(i = 0 ; i < 4 ; i = i+1) begin
   #40 ;
    din = ~din ;
  end

 #40 ;
  din = 1;
  $finish;
 #100;
 end

always
 #period clk = ~clk ;




endmodule
