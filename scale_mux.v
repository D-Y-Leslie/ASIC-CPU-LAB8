//-------------------scale_mux.v --------------------
/**************************************************
* 2-TO-1 N-BIT WIDE SCALABLE MUX *
**************************************************/

module scale_mux (out, sel, b, a);

parameter size = 1;

output [size-1:0] out;
input [size-1:0] b, a;
input sel;

assign out = (!sel) ? a :
             (sel) ? b :
             {size{1'bx}};

endmodule