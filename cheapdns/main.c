/*
 *
 */

#include "inet.h"

#define LOCAL_PORT 53

int main(int argc, char *argv[])
{
	int sockfd;
	struct sockaddr_in serv_addr, remote_addr;

	if ( (sockfd = socket(AF_INET, SOCK_DGRAM, 0) ) < 0 )
	{
		perror("socket");
		exit(1);
	}

	serv_addr.sin_family = AF_INET;
	serv_addr.sin_port = htons(LOCAL_PORT);
	serv_addr.sin_addr.s_addr = htonl(INADDR_ANY);
	memset( &(serv_addr.sin_zero), '\0', 8);

	/* i hear that bind()ing isn't necessary for your stock
	   udp but this is here for "both a good programming habit,
	   and to provide consitency between protocols."
	   (you can that W. Richard Stevens for that) (pg 287)
	 */
	if (bind(sockfd, (struct sockaddr *) &serv_addr, sizeof(serv_addr)) < 0)
	{
		perror("bind");
		exit(1);
	}


	process_dns(sockfd, (struct sockaddr *) &remote_addr, sizeof(remote_addr));


	/* not reached */
	return 0;
}
