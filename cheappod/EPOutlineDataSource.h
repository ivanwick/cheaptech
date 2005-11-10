/* EPOutlineDataSource */

/* someday, this will have playlists */

#import <Cocoa/Cocoa.h>

@interface EPOutlineDataSource : NSObject
{
}

/*
NSOutlineView data source (<EPOutlineDataSource: 0x33f350>).  Must implement 
outlineView:numberOfChildrenOfItem:, outlineView:isItemExpandable:, 
outlineView:child:ofItem: and 
outlineView:objectValueForTableColumn:byItem:
*/

- (id)outlineView:(NSOutlineView *)outlineView child:(int)index ofItem:(id)item;

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item;

- (int)outlineView:(NSOutlineView *)outlineView
	numberOfChildrenOfItem:(id)item;
	
- (id)outlineView:(NSOutlineView *)outlineView
	objectValueForTableColumn:(NSTableColumn *)tableColumn
	byItem:(id)item;


@end

