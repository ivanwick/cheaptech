#include "dns_message.h"

/* this code is heavily dependent on short being 2 bytes
   and long being 4 bytes. if this is different, mr t will
   break your face sucka
*/

void parse_dns_message(struct dnsmessage * dm, char * buf)
{
	int i;
	short * sbuf;

	sbuf = (short*)buf;

	dm->h.trxnid = ntohs(sbuf[0]);
	dm->h.flags = ntohs(sbuf[1]);
	dm->h.qcount = ntohs(sbuf[2]);
	dm->h.acount = ntohs(sbuf[3]);
	dm->h.nscount = ntohs(sbuf[4]);
	dm->h.arcount = ntohs(sbuf[5]);

	buf += sizeof(struct dnsmessage_header);

	/* FIX: should check whether there is a question
	   before actually putting the name in dm->q.name
	*/

	i = -1;
	do
	{
		i++;
		dm->q.name[i] = buf[i];
	} while (buf[i]);

	buf += i+1;

	dm->q.type = ntohs(*( (short *) buf));
	dm->q.class = ntohs(*( (short *) (buf+sizeof(short))));

}

long construct_dns_response(struct dnsmessage * dm, char * buf)
{
	short * dh;
	long * dpl;
	int i = 0;


	char * startbuf = buf;
	dh = (short *)buf;

	dh[0] = htons(dm->h.trxnid);
	dh[1] = htons(dm->h.flags);
	dh[2] = htons(dm->h.qcount);
	dh[3] = htons(dm->h.acount);
	dh[4] = htons(dm->h.nscount);
	dh[5] = htons(dm->h.arcount);

	buf += sizeof(dm->h);

	/* repeat back the query */
	buf = (char *)stpcpy(buf, dm->q.name);
	buf++;

	dh = (short *)buf;
	dh[0] = htons(dm->q.type);
	dh[1] = htons(dm->q.class);
	dh += 2;


	buf = (char *)dh;
	/* answer */

	/* stpcpy returns a pointer to the ending null char
	   that was just copied */
	buf = (char *)stpcpy(buf, dm->a.name);
	buf ++;

	dh = (short *)buf;
	dh[0] = htons(dm->a.type);
	dh[1] = htons(dm->a.class);
	dh += 2;

	dpl = (long *)dh;
	dpl[0] = htonl(dm->a.ttl);
	dpl += 1;

	dh = (short *)dpl;
	dh[0] = htons(dm->a.datalen);
	dh += 1;

	buf = (char*)dh;

	strncpy(buf, dm->a.data, dm->a.datalen);
	buf += 4;

	return (buf - startbuf);
}
