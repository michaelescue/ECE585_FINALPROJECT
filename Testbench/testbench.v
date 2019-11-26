// ECE 585
// Final Project
// Michael Escue
//
// Simulation command line code:
//
// 		vsim work.testbench +DEBUG_ON +testname=cc1.din
//

module testbench();

`define MCD_SIZE;

reg [255:0] test_string;
reg [255:0] error_string;
integer tracefile;
integer scanned;
integer line_number;

reg [7:0] opcode;
reg [8*64-1:0] address;

// Conditional Execution
// Specify debug option by  adding "+DEBUG_ON" to runtime options.
initial begin
  
	if($test$plusargs("DEBUG_ON"))
      		$display("DEBUG_ON\n");
	else
        	$display("DEBUG_OFF\n");
	
	if($value$plusargs("testname=%s", test_string))
	   	$display("%s\n", test_string);
	   	tracefile = $fopen(test_string, "r");
	if(tracefile) 
		$display ("File Open.\n");
	else begin
		$display ("File Open - FAILED.\n");
		$ferror(tracefile, error_string);
		$display("%s\n", error_string);
		end 
	   
	line_number = 0;
	scanned = 0;

        while(~scanned) begin
		scanned = $fscanf(tracefile, "%c %h\n", opcode, address);
       		if(scanned) begin
        		$display("INPUT: opcode = %c address = %h\n", opcode, address);
                	line_number = line_number +1;
			end
        	else begin
			$display("END-OF-INPUT\n");
			end
        	end
        
	$display ("LINES READ: %d\n", line_number);
	$fclose(tracefile);
	end
	
		
	
	























































endmodule