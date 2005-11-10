#import "EPController.h"

@implementation EPController


-(void)awakeFromNib
{
	NSLog(@"EPController awakeFromNib");
	[iPodListDataSource loadList];

	if ([iPodListDataSource numberOfRowsInTableView:nil] == 1 ) /* && NO) */
	{
		[self showiPodContentsWithPrefix:[iPodListDataSource firstPrefix]];
	}
	else
	{
		[iPodListDataSource registerMountNotifications];
		[iPodListDataSource updateiPodListUI];
		[mainWindow setContentView:iPodSelectView];
	}
}


- (void)showiPodContentsWithPrefix:(NSString *)ipodprefix
{

	itdb = [[iTDatabase alloc] initWithFile:
			[ipodprefix
			stringByAppendingPathComponent:@"/iPod_Control/iTunes/iTunesDB"]
			];
	[itdb doParse];
	[songListDataSource setSongList:[itdb songList]];
	[songListDataSource setMountPrefix:ipodprefix];
	
	[mainWindow setContentView:nil];
	
	NSRect curRect, listRect, newRect;
	curRect = [mainWindow frame];
	listRect = [listView frame];

	/* geometry calculations */
	newRect.size.height = listRect.size.height;
	newRect.origin.y = curRect.origin.y
					   - (listRect.size.height - curRect.size.height);
					   	
	newRect.size.width = listRect.size.width;
	newRect.origin.x = curRect.origin.x 
					   - ((listRect.size.width - curRect.size.width) / 2);
	
	[mainWindow setFrame:newRect display:YES animate:YES];
	[mainWindow setContentView:listView];
	
	
}


@end
