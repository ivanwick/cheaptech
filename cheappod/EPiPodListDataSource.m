#import "EPiPodListDataSource.h"
#import "iPodUtils.h"

@implementation EPiPodListDataSource

- (EPiPodListDataSource *)init
{
	NSLog(@"EPiPodListDatSource init");
	self = [super init];

	/* where is this ever released?? */
	iPodList = [[NSMutableArray alloc] initWithCapacity:3];
	
	return self;
}

- (EPiPodInfo *)infoAtRow:(int)rowIndex
{
	return [iPodList objectAtIndex:rowIndex];
}



- (void)handleMountNotification:(NSNotification *)note
{
	NSLog(@"handleMountNotification");
	NSString * devpath;
	devpath = [[note userInfo] objectForKey:@"NSDevicePath"];
	EPiPodInfo *newInfo;
	
	if ([iPodUtils isiPodAtPrefix:devpath])
	{
		newInfo = [[EPiPodInfo alloc] initWithPrefix:devpath];
		/* add it to the list */
		[iPodList addObject:newInfo];
		[newInfo release];

		/* update UI */
		[self updateiPodListUI];
	}
}

- (void)handleUnmountNotification:(NSNotification *)note
{

	NSString * devpath;
	devpath = [[note userInfo] objectForKey:@"NSDevicePath"];
	EPiPodInfo *rmInfo;

	NSLog(@"handleUnmountNotification: path:%@", devpath);

	
		rmInfo = [[EPiPodInfo alloc] initWithPrefix:devpath];
		
		/* remove it from the list */
		[iPodList removeObject:rmInfo];
		[rmInfo release];

		[self updateiPodListUI];
}


- (void)registerMountNotifications
{
	NSNotificationCenter *wsnc;
	
	wsnc = [[NSWorkspace sharedWorkspace] notificationCenter];
	[wsnc addObserver:self
		selector:@selector(handleMountNotification:)
		name:NSWorkspaceDidMountNotification
		object:nil];
		
	[wsnc addObserver:self
		selector:@selector(handleUnmountNotification:)
		name:NSWorkspaceDidUnmountNotification
		object:nil];
}

- (void)deregisterMountNotifications
{
	NSNotificationCenter *wsnc;
	
	wsnc = [[NSWorkspace sharedWorkspace] notificationCenter];
	[wsnc removeObserver:self
		name:NSWorkspaceDidMountNotification
		object:nil];
		
	[wsnc removeObserver:self
		name:NSWorkspaceDidUnmountNotification
		object:nil];
}

- (void)updateiPodListUI
{
	NSLog(@"updateiPodListUI");
	NSEnumerator *e;
	EPiPodInfo *curInfo;
	
	e = [iPodList objectEnumerator];
	
	NSLog(@"iPodList has %d items", [iPodList count]);
	while (curInfo = [e nextObject])
	{
		NSLog(@"prefix: %@, icon: %@", [curInfo prefix], [curInfo icon]);
	}
	
	
	[table reloadData];
}

- (NSString *)firstPrefix
{
	EPiPodInfo *firstInfo;
	
	firstInfo = [iPodList objectAtIndex:0];	
	return [firstInfo prefix];
}

- (void)loadList
{
	NSLog(@"EPiPodListDatSource loadList");
	NSArray *prefixList;
	NSString *curPrefix;
	NSEnumerator *e;
	EPiPodInfo *curInfo;
	
	prefixList = [iPodUtils connectediPodsPrefixes];
	e = [prefixList objectEnumerator];
	
	while (curPrefix = [e nextObject])
	{
		curInfo = [[EPiPodInfo alloc] initWithPrefix:curPrefix];
		[iPodList addObject:curInfo];
		[curInfo release];
	}
}



/********************/

- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
	return [iPodList count];
}


- (id)tableView:(NSTableView *)aTableView
	objectValueForTableColumn:(NSTableColumn *)aTableColumn
	row:(int)rowIndex
{
	EPiPodInfo *rowInfo;
	
	rowInfo = (EPiPodInfo *)[iPodList objectAtIndex:rowIndex];
	
	if ([[aTableColumn identifier] isEqual:@"icon"])
	{
		NSLog(@"EPiPodListDataSource returning icon");
		return [rowInfo icon];
	}
	else
	{
		NSLog(@"EPiPodListDataSource about to return %@", [rowInfo prefix]);
		return [rowInfo name];
	}
}

- (void)tableView:(NSTableView *)aTableView
	setObjectValue:(id)anObject
	forTableColumn:(NSTableColumn *)aTableColumn
	row:(int)rowIndex
{
	/* not editable. */
	return;
}



@end
