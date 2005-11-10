/* EPTableDataSource */

#import <Cocoa/Cocoa.h>
#import "iTSongInfo.h"

@interface EPTableDataSource : NSObject
{
	NSMutableArray *songList; /* NSArray of iTSongInfo objects */
	NSString *mountPrefix;
}

- (NSMutableArray *)songList;
- (void)setSongList:(NSMutableArray *)newList;

- (NSString *)mountPrefix;
- (void)setMountPrefix:(NSString *)prefixpath;

- (int)numberOfRowsInTableView:(NSTableView *)aTableView;

- (id)tableView:(NSTableView *)aTableView
	objectValueForTableColumn:(NSTableColumn *)aTableColumn
	row:(int)rowIndex;

- (void)tableView:(NSTableView *)aTableView
	setObjectValue:(id)anObject
	forTableColumn:(NSTableColumn *)aTableColumn
	row:(int)rowIndex;

- (BOOL)tableView:(NSTableView *)tableView
	writeRows:(NSArray *)rows
	toPasteboard:(NSPasteboard *)pboard;

- (void)tableView:(NSTableView *)tableView
	sortDescriptorsDidChange:(NSArray *)oldDescriptors;

@end

