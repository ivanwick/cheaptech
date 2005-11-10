
#import "iTDBParseRecord.h"

@implementation iTDBParseRecord

- (id)initWithMemOffset:(char*)memOffset
{
	base = memOffset;
	return self;
}

- (char*)baseOffset
{
	return base;
}


- (unsigned int)headerLength
{
	return NSSwapLittleIntToHost(
			*(unsigned int *)(base + PRHeaderLengthOffset) );
}

- (unsigned int)totalLength
{
	return NSSwapLittleIntToHost(
			*(unsigned int *)(base + PRTotalLengthOffset) );
}

- (char *)nextRecordOffset
{
	return (base + [self totalLength]);
}

- (char *)bodyOffset
{
	return (base + [self headerLength]);
}

- (id)doIncrementOffset
{
	base += [self totalLength];
	
	return self;
}


@end
