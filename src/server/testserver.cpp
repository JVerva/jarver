#include <iostream>
#include <cstring>
#include <sys/socket.h>
#include <sys/types.h>
#include <netdb.h>

#define PORT "3000"

int main(){
    
    struct addrinfo* sinfo;
    struct addrinfo hints;
    struct sockaddr_storage claddr;
    socklen_t addr_size = sizeof claddr;
    int socketfd;
    int connection_socketfd;
    int listen_queue_size = 10;
    char* buffer;

    memset(&hints, 0, sizeof hints);

    hints.ai_flags = AI_PASSIVE;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_family = AF_UNSPEC;

    //set hints 
    memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_UNSPEC;
    hints.ai_flags = AI_PASSIVE;
    hints.ai_socktype = SOCK_STREAM;

    //creating a socket for the client
    if(int status = getaddrinfo(NULL, PORT, &hints, &sinfo) != 0){
        std::cerr << "get address info error" << status;
        exit(1);
    }

    socketfd = socket(sinfo->ai_family, sinfo->ai_socktype, sinfo->ai_protocol);

    //bind it to port 3000
    if (int status = bind(socketfd, sinfo->ai_addr, sinfo->ai_addrlen)!=0){
        std::cerr << "bind error" << status;
        exit(2);
    }

    //listen to possible connections
    if(int status = listen(socketfd, listen_queue_size) != 0){
            std::cerr << "listen error" << status;
        exit(3);
    }


    //wait until accepted connection
    while(1){
        if(connection_socketfd = accept(socketfd, (struct sockaddr*) &claddr, &addr_size) == -1){
            std::cerr << "no connection to accept";
            continue;
        }
    }

    //recieve message size (first 4 bytes(int))
    int bytes_read=0;

    if(bytes_read = recv(connection_socketfd, buffer, sizeof (int), 0) == -1){
        std::cerr << "error recieving data";
        exit(5);
    }else if(bytes_read != sizeof (int)){
        std::cerr << "error recieving data";
        exit(6);
    }

    //read the actual message
    bytes_read = 0;
    int message_size = (int)buffer;
    memset(buffer, 0, sizeof buffer);

    do{
        if(bytes_read += recv(connection_socketfd, buffer, message_size - bytes_read, 0) == -1){
            std::cerr << "error recieving data";
            exit(7);
        }
    }while(bytes_read < message_size);

    return 0;
}