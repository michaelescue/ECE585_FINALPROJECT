// ECE 585
// Final Project
// Michael Escue

module parser(opcode, address);

`define MCD_SIZE;

reg [255:0] test_string;
output reg [7:0] opcode;
output reg [8*64-1:0] address;

integer tracefile;
integer scanned;
integer line_number;

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
	   if(tracefile) $display ("File Open.\n");
	   else $display ("File Open - FAILED.\n");
	   
	 line_number = 0;
	 scanned = 0;
        while(~scanned) begin
            scanned = $fscanf(tracefile, "%d %h\n", opcode, address);
	    if(scanned)
                $display("INPUT: opcode = %c address = %0h\n", opcode, address);
            else $display("END-OF-INPUT\n");
                line_number = line_number +1;
        end
   //  $ferror(scanned);
     $display ("LINES READ: %d\n", line_number);
	   
	 $fclose(tracefile);
	   end
	
		
	
	























































endmodule
