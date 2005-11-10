#import "EPiPodSelectController.h"
#import "EPiPodInfo.h"

@implementation EPiPodSelectController

- (IBAction)updateContinue:(id)sender
{
	NSLog(@"update continue");
	
	if ([listView selectedRow] != -1)
	{
		[continueButton setEnabled:YES];
	}
	else
	{
		[continueButton setEnabled:NO];
	}
}

- (IBAction)continueUsingCurrentSelection:(id)sender
{
	EPiPodInfo *selipod;
	int selrow = [listView selectedRow];
	
	if (selrow != -1)
	{
		selipod = [listDataSource infoAtRow:selrow];
		[parentController showiPodContentsWithPrefix:[selipod prefix]];
	}
}

@end
