#import "EPTableView.h"

@implementation EPTableView


- (unsigned int)draggingSourceOperationMaskForLocal:(BOOL)isLocal
{
	if (! isLocal)
	{
		return NSDragOperationCopy;
	}
	else
	{
		return NSDragOperationNone;
	}
}

@end
