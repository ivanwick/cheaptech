
/* 
   http://www.rfc-editor.org/
   http://www.rfc-editor.org/rfcxx00.html
   ftp://ftp.rfc-editor.org/in-notes/rfc1035.txt
*/

/* these structs' organization can be modified.
   at one point i wanted to keep the fields in order of how
   they would appear in the protocol so i could cast directly
   from the buffer (off the wire) into dns_header. it worked
   on the sun, but in order to be portable, you end up having
   to call ntohs on every field anway. i don't think this is
   any better than parsing and assigning each field manually.
*/
struct dnsmessage_header
{
	unsigned short trxnid;

	unsigned short flags;
	unsigned short qcount;	/* questions */
	unsigned short acount;	/* answers */
	unsigned short nscount;	/* authoratative nameservers */
	unsigned short arcount; /* additional records */
};

struct dnsmessage_query
{
	char name[80];
	unsigned short type;
	unsigned short class;
};

struct dnsmessage_answer
{
	char name[80];
	unsigned short type;
	unsigned short class;
	unsigned long ttl;
	unsigned short datalen;
	char data[4];
};


/* doesn't implement multiple questions and answers */
struct dnsmessage
{
	struct dnsmessage_header h;

	struct dnsmessage_query q;
	struct dnsmessage_answer a;
};


void parse_dns_message(struct dnsmessage * dm, char * buf);

long construct_dns_response(struct dnsmessage * dm, char * buf);

