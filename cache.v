// PLRU bits applied to the set.
reg [6:0] plru_bits [14:0];

// Cache core: Set by Ways. 
reg [14:0] tag_array0 [14:0]; // Contains way0 state[14:13], valid[12], and dirty bit[11].
reg [14:0] tag_array1 [14:0]; // Contains way1 state[14:13], valid[12], and dirty bit[11].
reg [14:0] tag_array2 [14:0]; // Contains way2 state[14:13], valid[12], and dirty bit[11].
reg [14:0] tag_array3 [14:0]; // Contains way3 state[14:13], valid[12], and dirty bit[11].
reg [14:0] tag_array4 [14:0]; // Contains way4 state[14:13], valid[12], and dirty bit[11].
reg [14:0] tag_array5 [14:0]; // Contains way5 state[14:13], valid[12], and dirty bit[11].
reg [14:0] tag_array6 [14:0]; // Contains way6 state[14:13], valid[12], and dirty bit[11].
reg [14:0] tag_array7 [14:0]; // Contains way7 state[14:13], valid[12], and dirty bit[11].

end
endfunction

// Reading Cache functions
// Return the result of a tag compare to each way in the set. 
function cache_tag_hit;
input [14:0] set;
input [10:0] tag;

begin
	
	if(tag == tag_array0[set]) cache_hit = 1;
	else if(tag == tag_array1[set]) cache_hit = 1; 
	else if(tag == tag_array2[set]) cache_hit = 1; 
	else if(tag == tag_array3[set]) cache_hit = 1; 
	else if(tag == tag_array4[set]) cache_hit = 1; 
	else if(tag == tag_array5[set]) cache_hit = 1; 
	else if(tag == tag_array6[set]) cache_hit = 1; 
	else if(tag == tag_array7[set]) cache_hit = 1; 
	else cache_hit = 0;
	
end
endfunction

// Return the matching way of the set (only valid when cache_tag_hit == 1).
function cache_way_taken;
input [14:0] set;
input [10:0] tag;

begin

	if(tag == tag_array0[set]) cache_way_taken = 0;
	else if(tag == tag_array1[set]) cache_way_taken = 1; 
	else if(tag == tag_array2[set]) cache_way_taken = 2; 
	else if(tag == tag_array3[set]) cache_way_taken = 3; 
	else if(tag == tag_array4[set]) cache_way_taken = 4; 
	else if(tag == tag_array5[set]) cache_way_taken = 5; 
	else if(tag == tag_array6[set]) cache_way_taken = 6; 
	else if(tag == tag_array7[set]) cache_way_taken = 7; 
	else cache_way_taken = 0;

end
endfunction

// Return the plru bits of the set.
function [6:0]cache_set_plru;		// Yes, perhaps redundant, but keeps with form.
input [14:0] set;
begin
	cache_set_plru = plru_bits[set];
end
endfunction

// Return the valid bit of the matching tag.
function cache_tag_valid_bit;
input [14:0] set;
input [10:0] tag;

begin
		if(tag == tag_array0[set]) cache_tag_valid_bit = tag_array0[set][12];	// bit 12 is the valid bit.
	else if(tag == tag_array1[set]) cache_tag_valid_bit = tag_array1[set][12]; 
	else if(tag == tag_array2[set]) cache_tag_valid_bit = tag_array2[set][12]; 
	else if(tag == tag_array3[set]) cache_tag_valid_bit = tag_array3[set][12]; 
	else if(tag == tag_array4[set]) cache_tag_valid_bit = tag_array4[set][12]; 
	else if(tag == tag_array5[set]) cache_tag_valid_bit = tag_array5[set][12]; 
	else if(tag == tag_array6[set]) cache_tag_valid_bit = tag_array6[set][12]; 
	else if(tag == tag_array7[set]) cache_tag_valid_bit = tag_array7[set][12]; 
	else cache_tag_valid_bit = 0;
end
endfunction

// Return the dirty bit of the matching tag.
function cache_tag_dirty_bit;
input [14:0] set;
input [10:0] tag;

begin
		if(tag == tag_array0[set]) cache_tag_dirty_bit = tag_array0[set][11];	// bit 11 is the dirty bit.
	else if(tag == tag_array1[set]) cache_tag_dirty_bit = tag_array1[set][11]; 
	else if(tag == tag_array2[set]) cache_tag_dirty_bit = tag_array2[set][11]; 
	else if(tag == tag_array3[set]) cache_tag_dirty_bit = tag_array3[set][11]; 
	else if(tag == tag_array4[set]) cache_tag_dirty_bit = tag_array4[set][11]; 
	else if(tag == tag_array5[set]) cache_tag_dirty_bit = tag_array5[set][11]; 
	else if(tag == tag_array6[set]) cache_tag_dirty_bit = tag_array6[set][11]; 
	else if(tag == tag_array7[set]) cache_tag_dirty_bit = tag_array7[set][11]; 
	else cache_tag_dirty_bit = 0;
end
endfunction

// Return the state in a 2-bit format.
function [1:0]cache_tag_state_bits;
input [14:0] set;
input [10:0] tag;

begin
		if(tag == tag_array0[set]) cache_tag_state_bits = tag_array0[set][14:13];	// bits 14:13 are the state bits.
	else if(tag == tag_array1[set]) cache_tag_state_bits = tag_array1[set][14:13]; 
	else if(tag == tag_array2[set]) cache_tag_state_bits = tag_array2[set][14:13]; 
	else if(tag == tag_array3[set]) cache_tag_state_bits = tag_array3[set][14:13]; 
	else if(tag == tag_array4[set]) cache_tag_state_bits = tag_array4[set][14:13]; 
	else if(tag == tag_array5[set]) cache_tag_state_bits = tag_array5[set][14:13]; 
	else if(tag == tag_array6[set]) cache_tag_state_bits = tag_array6[set][14:13]; 
	else if(tag == tag_array7[set]) cache_tag_state_bits = tag_array7[set][14:13]; 
	else cache_tag_state_bits = 0;
end
endfunction

// Writing to cache function.
task write_to_cache_line;
input [14:0] set;
input [2:0] way;
input [1:0] state;
input valid_bit;
input dirty_bit;
input [10:0] tag;

begin
	case(way)
		0: 	tag_array0[set] = {state, valid, dirty, tag};	
		1:	tag_array1[set] = {state, valid, dirty, tag};
		2:	tag_array2[set] = {state, valid, dirty, tag};
		3:	tag_array3[set] = {state, valid, dirty, tag};
		4:	tag_array4[set] = {state, valid, dirty, tag};
		5:	tag_array5[set] = {state, valid, dirty, tag};
		6:	tag_array6[set] = {state, valid, dirty, tag};
		7:	tag_array7[set] = {state, valid, dirty, tag};
		default:
			begin
				`ifndef SILENT
				$display("Error in write_to_cache_line function!\n");
				`endif
			end
	endcase
end
endfunction
