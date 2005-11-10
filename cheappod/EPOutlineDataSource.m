#import "EPOutlineDataSource.h"

@implementation EPOutlineDataSource

- (id)outlineView:(NSOutlineView *)outlineView child:(int)index ofItem:(id)item
{
	NSLog(@"child of item: %@", item);
	if (item == nil)
	{
		/* root node */
		return @"Library";
	}
	else
	return nil;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
	NSLog(@"item is expandable: %@", item);
	return NO;
}
	
- (int)outlineView:(NSOutlineView *)outlineView
	numberOfChildrenOfItem:(id)item
{
	NSLog(@"number of children of item: %@", item);
	if (item == nil)
	{	return 1;
	}
	else
	{	return 0;
	}
}
	
- (id)outlineView:(NSOutlineView *)outlineView
	objectValueForTableColumn:(NSTableColumn *)tableColumn
	byItem:(id)item
{
	NSLog(@"objectvalue for table column: %@, item: %@", tableColumn, item);
	return @"Library";
}


@end
