/* EPController */

#import <Cocoa/Cocoa.h>
#import "iTDatabase.h"
#import "EPTableDataSource.h"
#import "EPiPodListDataSource.h"
#import "EPOutlineDataSource.h"

@interface EPController : NSObject
{
    IBOutlet EPOutlineDataSource  *playListDataSource;
    IBOutlet EPTableDataSource    *songListDataSource;
	IBOutlet EPiPodListDataSource *iPodListDataSource;
	
	IBOutlet NSWindow *mainWindow;
	IBOutlet NSView *iPodSelectView;
	IBOutlet NSView *listView;

	iTDatabase *itdb;
}

- (void)awakeFromNib;

/* private? */
- (void)showiPodContentsWithPrefix:(NSString *)ipodprefix;


@end
