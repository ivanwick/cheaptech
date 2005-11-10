/* EPTableView */

#import <Cocoa/Cocoa.h>

@interface EPTableView : NSTableView
{
}


- (unsigned int)draggingSourceOperationMaskForLocal:(BOOL)isLocal;

@end
