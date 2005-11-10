

#import "iTDBParseRecord.h"


/* mhdb scaffold */

enum
{
	PMhdbVersionNumberOffset = 16,
	PMhdbNumChildrenOffset = 20,
	PMhdbIDOffset = 24
};

/* database version numbers */
enum PMhdbVersion
{
	PMViTunes42 = 0x09,
	PMViTunes45 = 0x0a, 
	PMViTunes47 = 0x0b,
	PMViTunes48 = 0x0d,
	PMViTunes50 = 0x0e
};

@interface iTDBParseMhdb : iTDBParseRecord
{
}

/* i thought you could specify an enum here but i guess not.
- (PMhdbVersion)getVersion;
*/
- (unsigned int)version;

- (unsigned int)numChildren;

@end
