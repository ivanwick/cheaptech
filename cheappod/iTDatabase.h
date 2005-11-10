
/* iTDatabase is an OPENSTEP object wrapper around the iTunesDB file found on
   iPods.  This file stores a lot of the information used by the iPod including
   namely song information and playlists. Other information used by the iPod 
   (e.g. play counts, album art) are stored in separate files an are not of
   immediate interest.  Some object restructuring/reinterfacing will likely need
   to be done if this additional data is to be included.
*/



#import <Foundation/Foundation.h>
#import "iTSongInfo.h"
#import "iTDBParse/iTDBParseMhdb.h"

@interface iTDatabase : NSObject
{
	/* instance variables ?? */

	NSMutableArray  *songList;	/* NSArray of iTSongInfo objects */
	NSString *dbFilePath;
}


- (id)init;
- (id)initWithFile:(NSString *)path;



/* returns an array of the songs listed in the iTunesDB file.
   (should this be an NSSet instead?)

*/
- (NSMutableArray *)songList;

- (void)doParse;
- (BOOL)didParse;

- (void)parseSongsWithMhdb:(iTDBParseMhdb *)parsedb;

- (void)dealloc;

@end
