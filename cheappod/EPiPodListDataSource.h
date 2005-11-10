/* EPiPodListDataSource */

#import <Cocoa/Cocoa.h>
#import "EPiPodInfo.h"

@interface EPiPodListDataSource : NSObject
{
	IBOutlet NSTableView *table;
	NSMutableArray *iPodList;
}

/*
- (NSArray *)prefixList;
- (void)setPrefixList:(NSArray *)newList;
*/

- (EPiPodInfo *)infoAtRow:(int)rowIndex;

- (int)numberOfRowsInTableView:(NSTableView *)aTableView;

- (id)tableView:(NSTableView *)aTableView
	objectValueForTableColumn:(NSTableColumn *)aTableColumn
	row:(int)rowIndex;

- (void)tableView:(NSTableView *)aTableView
	setObjectValue:(id)anObject
	forTableColumn:(NSTableColumn *)aTableColumn
	row:(int)rowIndex;
	
- (void)registerMountNotifications;
- (void)deregisterMountNotifications;

- (void)handleMountNotification:(NSNotification *)note;
- (void)handleUnmountNotification:(NSNotification *)note;

- (void)updateiPodListUI;

- (NSString *)firstPrefix;

- (void)loadList;

@end

