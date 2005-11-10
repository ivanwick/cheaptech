

#import "iTDBParseRecord.h"

/* offsets */
enum
{
	PMhodTypeOffset = 12
};

enum PMhodType
{
	PMhodTTitle               = 1,
	PMhodTPath                = 2,
	PMhodTAlbum               = 3,
	PMhodTArtist              = 4,
	PMhodTGenre               = 5,
	PMhodTFiletype            = 6,
	PMhodTEQSetting           = 7,
	PMhodTComment             = 8,
	PMhodTCategory            = 9,    /* podcast category ? */
	PMhodTComposer            = 12,
	PMhodTGrouping            = 13,
	PMhodTDescription         = 14,   /* e.g. podcast show notes ? */
	PMhodTPodcastEnclosureURL = 15,
	PMhodTPodcastRSSURL       = 16,
	PMhodTChapterData         = 17,
	PMhodTSubtitle            = 18,    /* usually same as description ? */
	PMhodTSmartPlaylistData   = 50,
	PMhodTSmartPlaylistRules  = 51,
	PMhodTSmartPlaylistIndex  = 52,
	PMhodTOther               = 100
};


@interface iTDBParseMhod : iTDBParseRecord
{
}

- (unsigned int)type;


@end
