cheapdns:	dns_message.o process_dns.o main.o
	gcc dns_message.o process_dns.o main.o -o cheapdns

dns_message.o:	dns_message.c
	gcc -c dns_message.c


process_dns.o:	process_dns.c
	gcc -c process_dns.c


main.o:	main.c
	gcc -c main.c

clean:	
	rm *.o cheapdns
