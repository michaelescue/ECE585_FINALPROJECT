/*
* Bus Operation types
*/
#define READ 1 /* Bus Read */
#define WRITE 2 /* Bus Write */
#define INVALIDATE 3 /* Bus Invalidate */
#define RWIM 4 /* Bus Read With Intent to Modify */
/*
* Snoop Result types
*/
#define NOHIT 0 /* No hit */
#define HIT 1 /* Hit */
#define HITM 2 /* Hit to modified line */
/*
* L2 to L1 message types
*/
#define GETLINE 1 /* Request data for modified line in L1 */
#define SENDLINE 2 /* Send requested cache line to L1 */
#define INVALIDATELINE 3 /* Invalidate a line in L1 */
#define EVICTLINE 4 /* Evict a line from L1 */
// this is when L2's replacement policy causes eviction of a line that
// may be present in L1. It could be done by a combination of GETLINE
// (if the line is potentially modified in L1) and INVALIDATELINE.

/*
Used to simulate a bus operation and to capture the snoop results of last
level caches of other processors
*/
void BusOperation(char BusOp, unsigned int Address, char *SnoopResult);
SnoopResult = GetSnoopResult(Address);

#ifndef SILENT
printf(“BusOp: %d, Address: %h, Snoop Result: %d\n”,*SnoopResult);
#endif

}
/*
Used to simulate the reporting of snoop results by other caches
*/
char GetSnoopResult(unsigned int Address);
{}

/*
Used to report the result of our snooping bus operations performed by other
caches
*/
void PutSnoopResult(unsigned int Address, char SnoopResult);
{
#ifndef SILENT
printf(“SnoopResult: Address %h, SnoopResult: %d\n”, Address,SnoopResult);
}
#endif

/*
Used to simulate communication to our upper level cache
*/
void MessageToCache(char Message, unsigned int Address);
{
#ifndef SILENT
printf(“L2: %d %h\n”, Message, Address);
#endif
}