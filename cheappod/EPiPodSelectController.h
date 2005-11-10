/* EPiPodSelectController */

#import <Cocoa/Cocoa.h>
#import "EPiPodListDataSource.h"
#import "EPController.h"

@interface EPiPodSelectController : NSObject
{
    IBOutlet id continueButton;
    IBOutlet id listView;
	IBOutlet EPiPodListDataSource * listDataSource;
    IBOutlet EPController * parentController;
}

- (IBAction)updateContinue:(id)sender;
- (IBAction)continueUsingCurrentSelection:(id)sender;

@end
