
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/mman.h>

#import "iTDatabase.h"
#import "iTDBParse/iTDBParseMhsd.h"
#import "iTDBParse/iTDBParseMhlt.h"
#import "iTDBParse/iTDBParseMhit.h"
#import "iTSongInfo.h"

@implementation iTDatabase

- (id)init
{
	self = [super init];
	
	songList = nil;
	dbFilePath = nil;

	return self;
}

- (id)initWithFile:(NSString *)path
{
	[self init];
	dbFilePath = [[NSString alloc] initWithString:path];

	return self;
}

- (id)setFileName:(NSString *)path
{
	if (dbFilePath != path)
	{
		[dbFilePath release];
		dbFilePath = [[NSString alloc] initWithString:path];
	}
	
	return self;
}

- (void)dealloc
{
	[songList release];
	songList = nil;

	if (dbFilePath)
	{	[dbFilePath release];
		dbFilePath = nil;
	}

	[super dealloc];
}


- (NSMutableArray *)songList
{
	return songList;
}


/* this method needs some way to return an error if it occurs while parsing */
/* maybe some kind of exception handling. */

/* NOTE: this method was derived from a prototype written in C only.  Some of
   the functionality may be better served with OPENSTEP Foundation classes (e.g.
   stat-ing a file to get its size) */

- (void)doParse
{
	/* crazy mmap shitzz */
	void * dbmmap;
	int readfh;
	struct stat dbfstat;
	unsigned int dbfsize;
	iTDBParseMhdb * topLevelDB;


	/* open the file */
	/* NSString's -cString would make sense here except that it's deprecated */
	readfh = open([dbFilePath UTF8String], O_RDONLY);
	
	/* try to stat the file so we know its size. */
	fstat(readfh, &dbfstat);
	dbfsize = dbfstat.st_size;

	/* now mmap the entirety of the file */
	dbmmap = mmap(NULL, dbfsize, PROT_READ, MAP_PRIVATE, readfh, 0);

	/*
	if (dmbap == MAP_FAILED)
	{
		do something
	}
	*/

	topLevelDB = [[iTDBParseMhdb alloc] initWithMemOffset:dbmmap];

	[self parseSongsWithMhdb: topLevelDB];
	/* in the future there will be a similar "parsePlaylistsWithMhdb:" here */



	/* cleanup */
	munmap(dbmmap, 0);	/* not sure what the 0 is here, should RTFM again */
	close(readfh);
}


/* note: terminology here pertaining to "lists" and "list holders" was taken
   from http://ipodlinux.org/ITunesDB 
*/
- (void)parseSongsWithMhdb:(iTDBParseMhdb *)parsedb
{
	iTDBParseMhsd *mhsdListHolder;
	iTDBParseMhlt *mhltSongList;
	iTDBParseMhit *mhitCurSong;
	iTSongInfo * curSongInfo;
	int i;


	/* loop trough the mhsds until we get to the TrackList one */
	/* note: this may work better with an enumerator. */
	/* this might have been an unweildy for-loop but i made explicit
	   initialization and incrementation instead.
	*/

	/* initialization */
	i = 0;
	mhsdListHolder = [[iTDBParseMhsd alloc]
						initWithMemOffset:[parsedb bodyOffset]];

	while (i < [parsedb numChildren])
	{
		if ([mhsdListHolder type] == PMhsdTTrackList)
		{	break;
		}

	/* incrementation */
		i++;
		[mhsdListHolder doIncrementOffset];
	}

		/* [mhsdListHolder isTrackList] */
		/* this would be a convenient method but which way is correct? */
	if ([mhsdListHolder type] != PMhsdTTrackList)
	{
		/* problem */
		return;
	}


	mhltSongList = [[iTDBParseMhlt alloc]
						initWithMemOffset: [mhsdListHolder bodyOffset]];

	/* initialize our mutable array to the number of songs we expect to read
	   from the mhlt list */
	/* is this needed??
	if (songList != nil)
	{
		[songList release];
	}
	*/
	songList = [[NSMutableArray alloc]
				initWithCapacity:[mhltSongList numSongs]];


	i = 0;
	mhitCurSong = [[iTDBParseMhit alloc]
					initWithMemOffset:[mhltSongList bodyOffset]];

	while (i < [mhltSongList numSongs])
	{
		//mhitCurSong = [mhitCurSong doIncrementOffset];
		curSongInfo = [[iTSongInfo alloc] initWithParseMhit:mhitCurSong];

		/* add song to the object's array and release it */
		[songList addObject:curSongInfo];
		[curSongInfo release];

	/* increment */
		i++;
		[mhitCurSong doIncrementOffset];
	}


	[mhitCurSong release];
	[mhsdListHolder release];
	[mhltSongList release];
}

- (BOOL)didParse
{
	if (songList == nil)
	{	return NO;
	}
	else
	{	return YES;
	}
}

@end
