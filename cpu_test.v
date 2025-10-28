`timescale 1 ns / 1 ns
module cpu_test;  
  reg		rst_	;
  reg [(3*8):1] mnemonic;
  reg 		haltbuf;
  integer i;
// Instantiate the VeriRISC CPU
  cpu cpu1 ( rst_ ) ;
// Generate mnemonic
  always @ ( cpu1.opcode )
    case ( cpu1.opcode )
      3'h0    : mnemonic = "HLT" ;
      3'h1    : mnemonic = "SKZ" ;
      3'h2    : mnemonic = "ADD" ;
      3'h3    : mnemonic = "AND" ;
      3'h4    : mnemonic = "XOR" ;
      3'h5    : mnemonic = "LDA" ;
      3'h6    : mnemonic = "STO" ;
      3'h7    : mnemonic = "JMP" ;
      default : mnemonic = "???" ;
    endcase
// Monitor signals
  initial
    begin
      $timeformat ( -9, 1, " ns", 12 ) ;
      $dumpvars (0,cpu_test);
    end
// Apply stimulus
  always
    begin
	// $stop ; 
	@ ( negedge cpu1.clock )
	rst_ = 0;
	@ ( negedge cpu1.clock )
	rst_ = 1; 
	@ ( posedge cpu1.halt ) 
	$display ( "HALTED AT PC = %h", cpu1.pc_addr ); 
	disable test ;
    end

  task test ;
    input [2:0] N ;
    reg [12*8:1] testfile ;
    if ( 1<=N && N<=4 )
      begin
        testfile = { "CPUtest", 8'h30+N, ".dat" } ;
        $readmemb ( testfile, cpu1.mem1.memory ) ;
        case ( N )
          1:
            begin
              $display ( "RUNNING THE BASIC DIAGOSTIC TEST" ) ;
              $display ( "THIS TEST SHOULD HALT WITH PC = 17" ) ;
              $display ( "PC INSTR OP DATA ADR" ) ;
              $display ( "-- ----- -- ---- ---" ) ;
              forever @ ( cpu1.opcode or cpu1.ir_addr ) 
		begin
              		$strobe ( "%h %s   %h  %h   %h", cpu1.pc_addr, mnemonic, cpu1.opcode, cpu1.data, cpu1.addr );	
		end	 			  
            end
          2:
            begin
              $display ( "RUNNING THE ADVANCED DIAGOSTIC TEST" ) ;
              $display ( "THIS TEST SHOULD HALT WITH PC = 10" ) ;
              $display ( "PC INSTR OP DATA ADR" ) ;
              $display ( "-- ----- -- ---- ---" ) ;
              forever @ ( cpu1.opcode or cpu1.ir_addr )
		begin
	        	$strobe ( "%h %s   %h  %h   %h",cpu1.pc_addr, mnemonic, cpu1.opcode, cpu1.data, cpu1.addr ) ;
		end
            end
            3:
              begin
                $display ( "RUNNING THE FIBONACCI CALCULATOR" ) ;
                $display ( "THIS PROGRAM SHOULD CALCULATE TO 144" ) ;
                $display ( "FIBONACCI NUMBER" ) ;
                $display ( " ---------------" ) ;
                forever @ ( cpu1.opcode )
		begin
                  if (cpu1.opcode == 3'h2)
                    $strobe ( "%d", cpu1.mem1.memory[5'h1B] ) ;
		end
            end
	/*
	    4:
              begin
                $display ( "RUNNING THE CALCULATOR" ) ;
                $display ( "THIS PROGRAM SHOULD CALCULATE TO 128" ) ;
                $display ( "SQUARE NUMBER" ) ;
                $display ( " ---------------" ) ;
                forever @ ( cpu1.opcode )
		begin
                  if (cpu1.opcode == 3'h2)
                    $strobe ( "%d", cpu1.mem1.memory[5'h1A] ) ;
		end
            end
	*/
        endcase
      end
    else
      begin
        $display("Not a valid test number. Please try again." ) ;
        $stop ;
      end
  endtask

initial 
begin
for(i=1;i<=3;i=i+1)
test(i);
$display("TEST FINISHED");
$finish;
end

`ifdef FSDB
initial begin
	$fsdbDumpfile("cpu.fsdb");
	$fsdbDumpvars;
end
`endif

endmodule