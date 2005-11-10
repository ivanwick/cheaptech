

/* This class shares some descendent object relationship with NSDictionary
   - a subclass probably
   Actually NSMutableDictionary is an abstract class (class cluster) that can't
   be subclassed in this manner.
   It has been changed from an is-a relationship to a has-a one.
   I h
*/


#import <Foundation/Foundation.h>
#import "iTDBParse/iTDBParseMhit.h"

@interface iTSongInfo : NSObject
{
	NSMutableDictionary *info;
}


- (id)initWithParseMhit:(iTDBParseMhit *)datamhit;


/* NSMutableDictionary partial interface */
- (void)setObject:(id)anObject forKey:(id)aKey;
- (void)removeObjectForKey:(id)aKey;
- (unsigned)count;
- (id)objectForKey:(id)aKey;
- (NSEnumerator *)keyEnumerator;

/* key value coding
   it seems like this is what i should've been looking for all along when I was
   trying to find a way to subclass NSDictionary so I could handle these by key.
*/
- (id)valueForUndefinedKey:(id)aKey;


/* these are convenience wrappers for invocations of NSDictionary's
   objectForKey: */
- (NSString *)artist;
- (NSString *)title;
- (NSString *)album;
- (NSString *)path;


@end
