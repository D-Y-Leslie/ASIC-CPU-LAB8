`timescale 1ns/100ps
module alu (out, zero, opcode, data, accum) ;
input [7:0] data, accum;
input [2:0] opcode ;
output zero;
output [ 7:0] out;
reg [7:0] out;
reg zero;
parameter PASS0= 3'b000 ,
	  PASS1 = 3'b001,
	  ADD = 3'b010,
	  AND = 3'b011,
          XOR=3'b100,
 	PASSD = 3'b101,
	PASS6=3'b110,
	PASS7 =3'b111;

always@(*)begin
	case(opcode)
	PASS0:out=accum;
	PASS1:out=accum;
	ADD:out=data+accum;
	AND:out=data&accum;
	XOR:out=data^accum;
	PASSD:out=data;
	PASS6:out=accum;
	PASS7:out=accum;
	default:out=8'bx;
	endcase
end

always@(*) begin
if(accum==0)begin
	zero=1;
end
else begin
	zero=0;
end
end
            
endmodule
