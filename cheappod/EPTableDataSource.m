#import "EPTableDataSource.h"

@implementation EPTableDataSource
- (NSMutableArray *)songList
{
	return songList;
}

- (void)setSongList:(NSMutableArray *)newList
{
	/* is this necessary/correct? */
	NSMutableArray * oldList;
	oldList = songList;
	songList = newList;
	
	[songList retain];

	if (oldList != nil)
	{	[oldList release];
	}
}

- (NSString *)mountPrefix
{
	return mountPrefix;
}

- (void)setMountPrefix:(NSString *)pathprefix
{
	NSString *oldprefix;
	oldprefix = mountPrefix;
	mountPrefix = pathprefix;
	
	[mountPrefix retain];
	
	if (oldprefix != nil)
	{	[oldprefix release];
	}
}

- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
	return [songList count];
}

- (id)tableView:(NSTableView *)aTableView
	objectValueForTableColumn:(NSTableColumn *)aTableColumn
	row:(int)rowIndex
{
	//NSLog(@"getter: identifier: %@",
	//	[aTableColumn identifier]);
	
	return [(iTSongInfo *)[songList objectAtIndex:rowIndex]
			objectForKey:[aTableColumn identifier]];		
}

/* the table should be set to uneditable so this should never
   be called. */
- (void)tableView:(NSTableView *)aTableView
	setObjectValue:(id)anObject
	forTableColumn:(NSTableColumn *)aTableColumn
	row:(int)rowIndex
{
	NSLog(@"setter function.");
}

- (BOOL)tableView:(NSTableView *)tableView writeRows:(NSArray *)rows
	toPasteboard:(NSPasteboard *)pboard
{
	NSMutableArray *fileList;
	NSEnumerator *selEnum;
	NSNumber *curSelIndex;
	iTSongInfo *curSong;
	NSArray *pathComponents;
	
	selEnum = [rows objectEnumerator];
	
	fileList = [[NSMutableArray alloc] initWithCapacity:[rows count]];

	
	while(curSelIndex = (NSNumber *)[selEnum nextObject])
	{
		curSong = [songList objectAtIndex:[curSelIndex unsignedIntValue]];
		pathComponents = [[curSong path] componentsSeparatedByString:@":"];
		
		/*
		NSLog([NSString stringWithFormat:@"%@%@", mountPrefix,
				[pathComponents componentsJoinedByString:@"/"]]);
		*/
				
		[fileList addObject:
			[NSString stringWithFormat:@"%@%@", mountPrefix,
				[pathComponents componentsJoinedByString:@"/"]]
		];
	}

    [pboard declareTypes:[NSArray arrayWithObject:NSFilenamesPboardType]
		owner:nil ];
    [pboard setPropertyList:fileList forType:NSFilenamesPboardType];
    
	return YES;
}
- (void)tableView:(NSTableView *)tableView
	sortDescriptorsDidChange:(NSArray *)oldDescriptors
{
	NSLog(@"sort descriptors did change: %@", [tableView sortDescriptors]);
	
	[songList sortUsingDescriptors:[tableView sortDescriptors]];
	
	[tableView reloadData];
	
/*
        NSArray *newDescriptors = [tableView sortDescriptors];
        [myDataSourceArray sortUsingDescriptors:newDescriptors];
        [tableView reloadData];
*/
}


@end






#if 0

/* this is included here for posterity in case this app ever gets ported up to
   Mac OS X 10.4 (Tiger), where an NSIndexSet is given instead of an array
   of table rows. */

/* This is a little weird from when i thought that the mouseDragged method had
   to be overridden in order to code up the drag and drop. (This may have been
   true in previous releases of Mac OS X */

- (void)mouseDragged:(NSEvent *)theEvent
{
	[super mouseDragged:theEvent];

	NSLog(@"mouseDragged");
	/* act one: wherein the list of file paths is derived from the set of
	            rows selected in the tableview */
	NSRange fullRange;
	NSIndexSet *selIndices;
	unsigned int *indexBuf;
	unsigned int retcount, i;
	
	NSMutableArray *fileList;
	NSTableColumn *pathCol;
	
	selIndices = [self selectedRowIndexes];
	fullRange = NSMakeRange([selIndices firstIndex],
		([selIndices lastIndex] - [selIndices firstIndex]) + 1);
	
	indexBuf = (unsigned int*)
		malloc(sizeof(unsigned int) * [selIndices count]);
	
	retcount = [selIndices getIndexes:indexBuf
		maxCount:[selIndices count]
		inIndexRange:&fullRange ];
	
	fileList = [[NSMutableArray alloc] initWithCapacity:[selIndices count]];
	pathCol = [self tableColumnWithIdentifier:@"Path"];
	
	for (i = 0; i < retcount; i++)
	{
		// add the path to an Array
		[fileList addObject:
			[[self dataSource] tableView:self
				objectValueForTableColumn:pathCol
				row:indexBuf[i]]];
	}
	
	free(indexBuf);
	

	/* act two: wherein the file list is copied to the pasteboard and
	            the drag action is intiated  */

    NSImage *dragImage;
    NSPoint dragPosition;
    NSPasteboard *pboard = [NSPasteboard pasteboardWithName:NSDragPboard];
    [pboard declareTypes:[NSArray arrayWithObject:NSFilenamesPboardType]
            owner:nil];
    [pboard setPropertyList:fileList forType:NSFilenamesPboardType];
    // Start the drag operation
    dragImage = [[NSWorkspace sharedWorkspace]
		iconForFile:@"/Users/ivan/smallreel_2.mov"];
    dragPosition = [self convertPoint:[theEvent locationInWindow]
                        fromView:nil];
    //dragPosition.x -= 16;
    //dragPosition.y -= 16;


	[self dragImage:dragImage
		at:dragPosition
		offset:NSZeroSize
		event:theEvent
		pasteboard:pboard
		source:[self dataSource] /* object set as a connection in IB */
		slideBack:YES ];

}

#endif


