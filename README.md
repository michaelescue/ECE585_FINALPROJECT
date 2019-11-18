###### **ECE 585 Final Project Folder**

### Primary Function Objectives:
	Last Level Cache Simulation.
	Compatible with 3 other processors in a shared memory configuration.
	
### Cache Details:
	Capacity	16MB
	Cache Line Size	64 Bytes
	Associativity	8-Way
	Eviction/Replacement Policy	Pseudo-LRU
	Write Policy	Write-Allocate
	Coherence Protocol	MESI
	
### Next (Higher) Level Cache Details:
	Cache Line Size	64 Bytes
	Associativity	4-Way
	Write Policy	Write-Once (First write is Write-Through, subsequent writes are Write-Back)
	
### System Details:
	- Maintain Inclusivity.
	- Not necessary to be synthesizable.
	- Data doesn't need to be stored.
		○ Model the behavior only for hits, misses, evictions, etc.
	- No mention of addressable memory sizes.
		○ Expect trace file to have variable address sizes (this will probably be exploited during Faust's testing).
	
### Simulation Details:
	- Model communication between LLC and the next higher level cache.
	- Model bus operations that the LLC performs.
	- Model snooping results that the LLC reports on the bus in response to snooping of the simulated bus operations of other processors and their caches.
	- Model snooping results returned by other LLCs in response to the primary LLC operation. 
	- Required Simulation Modes:
		Mode 1:
			▪ In response to op code of "9" only:
				• Must print the following after the execution of each trace for each cache at every level in the shared memory configuration.
					○ Number of cache reads.
					○ Number of cache writes.
					○ Number of cache hits.
					○ Number of cache misses.
					○ Cache hit ratio.
		Mode 2:
			▪ In response to op code of "9" only:
				• Must print the following after the execution of each trace for each cache at every level in the shared memory ###configuration.
					○ Number of cache reads.
					○ Number of cache writes.
					○ Number of cache hits.
					○ Number of cache misses.
					○ Cache hit ratio.
				• Must also print for each cache:
					○ Bus operations.
					○ Reported snoop results.
					○ Communication messages to higher level caches.
			
 
### Coding Suggestions:
	- Use a separate header file.
	- Use $value $plusargs to accept dynamic trace file names.

### Demonstration Requirements:
	- No debugging information visible during demonstration.

### Testing Requirements:
	- Test plan writeup required.
	- Each test on the model must be described in the report. 

###### **Report Requirements:**
	- Describe the interface to the next level cache.
	- Describe the interface to the shared bus.
	- Describe the Internal design of cache behavioral model.
	- Describe modules used in validation of cache operation.
		○ Testbench in verilog.
	- Simulation results.
	- Usage statistics.
	- Assumptions that influenced design (especially about L1 cache).
	

