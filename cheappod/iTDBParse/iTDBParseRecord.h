
#import <Foundation/Foundation.h>

/* general "record" parser for iTunesDB file.
   This class is subclassed by
     iTDBParseMhdb
     iTDBParseMhsd
     iTDBParseMhst
     iTDBParseMhit
     iTDBParseMhod
*/

/* this is an abstract superclass, how do you codify this in objc? */

/* some offset constants.
   I don't know if they belong here. (or in an enum for that matter (wtf?))
   (kid606, the action packed mentalist, track 6)
*/
enum
{
	PRHeaderIdentifierOffset = 0,
	PRHeaderLengthOffset = 4,
	PRTotalLengthOffset = 8
};

@interface iTDBParseRecord : NSObject
{
	char *base;

}

- (id)initWithMemOffset:(char*)memOffset;

- (char *)baseOffset;
- (unsigned int)headerLength;
- (unsigned int)totalLength;
- (char *)nextRecordOffset;

/* this might be better as "firstChildOffset" but maybe that doesn't work for
   ones that don't have children records.  maybe add firstChildOffset to the
   ones that do ? */
- (char *)bodyOffset;

- (id)doIncrementOffset;


@end
