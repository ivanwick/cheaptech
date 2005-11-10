

#import "iTSongInfo.h"
#import "iTDBParse/iTDBParseStringMhod.h"

@implementation iTSongInfo

/* key value coding */
- (id)valueForUndefinedKey:(id)aKey
{
	//NSLog(@"valueForUndefineKey: %@", aKey);
	return [info objectForKey:aKey];
}


- (id)initWithParseMhit:(iTDBParseMhit *)datamhit
{
	NSString *addString;
	NSString *addKey;
	iTDBParseStringMhod *curmhod;
	int i;
	
	info = [[NSMutableDictionary alloc] init];
	
	i = 0;
	curmhod = [[iTDBParseStringMhod alloc]
				initWithMemOffset:[datamhit bodyOffset]];
	
	while (i < [datamhit numChildren])
	{
		addKey = nil;
		//NSLog(@"[curmhod type] = %d\n", [curmhod type]);
		switch ([curmhod type])
		{
		case PMhodTTitle:
			addKey = @"Title";
			break;
			
		case PMhodTArtist:
			addKey = @"Artist";
			break;
			
		case PMhodTAlbum:
			addKey = @"Album";
			break;
			
		case PMhodTPath:
			addKey = @"Path";
			break;

		/* "deprecated use of label at end of compound statement
		default:
			// do nothing
		*/
		}
		
		if (addKey != nil)
		{
			addString = [[NSString alloc] initWithString:[curmhod string]];
			//NSLog(@"%@:\t%@\n", addKey, addString);
			
			[self setObject:addString forKey:addKey];
			
			[addString release];
			addString = nil;

			// ? [addKey release];
			addKey = nil;
		}
	
	/* incrementation */
		i++;
		[curmhod doIncrementOffset];
	}
	
	return self;
}



/* passthru functions for the NSMutableDictionary */
- (void)setObject:(id)anObject forKey:(id)aKey
{
	[info setObject:anObject forKey:aKey];
}

- (void)removeObjectForKey:(id)aKey
{
	[info removeObjectForKey:aKey];
}
- (unsigned)count
{
	return [info count];
}

- (id)objectForKey:(id)aKey
{
	return [info objectForKey:aKey];
}

- (NSEnumerator *)keyEnumerator;
{
	return [info keyEnumerator];
}
/************/

- (NSString *)artist
{
	return [self objectForKey:@"Artist"];
}


- (NSString *)title
{
	return [self objectForKey:@"Title"];
}

- (NSString *)album
{
	return [self objectForKey:@"Album"];
}

- (NSString *)path
{
	return [self objectForKey:@"Path"];
}

@end