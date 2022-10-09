#include <iostream>
#include <cstring>
#include <sys/socket.h>
#include <sys/types.h>
#include <netdb.h>

#define PORT "3000"

int main(){

    //this client address info
    struct addrinfo *clinfo;
    struct addrinfo *slinfo;
    struct addrinfo hints;
    int socketfd;
    int coms_socketfd;
    std::string serverip;
    std::string message;

    //set hints 
    memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_UNSPEC;
    hints.ai_flags = AI_PASSIVE;
    hints.ai_socktype = SOCK_STREAM;

    //creating a socket for the client
    if(int status = getaddrinfo(NULL, PORT, &hints, &clinfo) != 0){
        std::cerr << "get address info error" << status;
        exit(1);
    }

    socketfd = socket(clinfo->ai_family, clinfo->ai_socktype, clinfo->ai_protocol);

    //bind it to port 3000
    if (int status = bind(socketfd, clinfo->ai_addr, clinfo->ai_addrlen)!=0){
        std::cerr << "bind error" << status;
        exit(2);
    }

    //finding server socket
    std::cout << "enter the server's address:" << std::endl;
    std::cin >> serverip;

     if(int status = getaddrinfo(serverip.c_str(), PORT, &hints, &slinfo) != 0){
        std::cerr << "get address info error" << status;
        exit(3);
    }

    //connect server socket to client socket
    if (int status = connect(socketfd, slinfo->ai_addr, slinfo->ai_addrlen)){
        std::cerr << "connect error" << status;
        exit(4);
    }

    //send message
    std::cout << "enter message:" << std::endl;
    std::cin >> message;
    
    int bytes_sent = 0;
    int message_size = message.size()+1;
    std::string final_message = (char*)message_size + message;
    message_size += sizeof (int);

    do{
        bytes_sent += send(socketfd, final_message.c_str() + bytes_sent, message_size - bytes_sent, 0);
    }while(bytes_sent < message_size);

    return 0;
}