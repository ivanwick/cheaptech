
#include "inet.h"
#include "dns_message.h"

#define MAX_DNS_MSG_LEN 512

/* this function never returns */
void process_dns(int sockfd, struct sockaddr *remote_addr, int maxaddrlen)
{
	char * buf;
	int numbytes, addrlen;
	struct dnsmessage dpq, dpa;
	in_addr_t resolvaddr;

	buf = (char*)malloc(MAX_DNS_MSG_LEN);

	while (1)
	{
		addrlen = maxaddrlen;
		if ((numbytes =
			recvfrom(sockfd, buf, MAX_DNS_MSG_LEN, 0, remote_addr, &addrlen))
			== -1 )
		{
			perror("recvfrom");
			exit(1);
		}

		parse_dns_message(&dpq, buf);

		/* make the right dns message packet */
		dpa.h.trxnid = dpq.h.trxnid;

		dpa.h.qcount = 1;
		dpa.h.acount = 1;
		dpa.h.nscount = 0;
		dpa.h.arcount = 0;
		dpa.h.flags = 0x8400; /* response, authoritative */

		/* FIX: hardcoded length */
		strncpy(dpa.a.name, dpq.q.name, 80);
		dpa.a.type = 0x0001; /* host address */
		dpa.a.class = 0x0001; /* inet */
		dpa.a.ttl = 80;
		dpa.a.datalen = 4;
		resolvaddr = inet_addr("132.239.70.98");

		/* FIX: don't know if this is correct or portable */
		strncpy(dpa.a.data, (char *)&resolvaddr, dpa.a.datalen);

		dpa.q = dpq.q;
		numbytes = construct_dns_response(&dpa, buf);

		if (sendto(sockfd, buf, numbytes, 0, remote_addr, addrlen)
			!= numbytes)
		{
			perror("sendto");
			exit(1);
		}
		printf("numbytes %d\n", numbytes);
	}

	/* never reached */
	free(buf);
}
