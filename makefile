CLIENT := client
SERVER := server

CLIENT_DEPENDENCIES := testclient.o
SERVER_DEPENDENCIES := testserver.o

EXTENSION := cpp
CC := g++

INCLUDEDIR := include
OBJDIR := obj
SRCDIR := src
BINDIR := bin
LIBDIR := lib

SRCFILES := $(shell find $(SRCDIR) -type f \( -iname "*.$(EXTENSION)" \) -exec basename \{} \;)
HEADERFILES := $(shell find $(INCLUDEDIR) -type f \( -iname "*.h" \) -exec basename \{} \;)
OBJFILES := $(SRCFILES:%.$(EXTENSION)=%.o)

FLAGS := -std=c++20
DEBUGFLAGS := -g -Wall
RELEASEFLAGS := -O3


client_debug: FLAGS += $(DEBUGFLAGS)
client_debug: clean setup $(CLIENT)

client_release: FLAGS += $(RELEASEFLAGS)
client_release: clean setup $(CLIENT)

server_debug: FLAGS += $(DEBUGFLAGS)
server_debug: clean setup $(SERVER)

server_release: FLAGS += $(RELEASEFLAGS)
server_release: clean setup $(SERVER)

#build target
$(CLIENT): $(CLIENT_DEPENDENCIES)
	$(CC) $(FLAGS) $(addprefix $(OBJDIR)/,$^) -o $(addprefix $(BINDIR)/,$@)
$(SERVER): $(SERVER_DEPENDENCIES)
	$(CC) $(FLAGS) $(addprefix $(OBJDIR)/,$^) -o $(addprefix $(BINDIR)/,$@)


#compile object files
%.o: $(SRCDIR)/%.$(EXTENSION)
	$(CC) $(FLAGS) -o $(addprefix $(OBJDIR)/,$@) -c $^ -I $(INCLUDEDIR)
%.o: $(SRCDIR)/**/%.$(EXTENSION)
	$(CC) $(FLAGS) -o $(addprefix $(OBJDIR)/,$@) -c $^ -I $(INCLUDEDIR)


#clean directory
clean:
	rm -rf $(OBJDIR)
	rm -rf $(BINDIR)
	rm -rf $(LIBDIR)


#setup directory
setup: 
	mkdir -p $(OBJDIR)
	mkdir -p $(BINDIR)
	mkdir -p $(LIBDIR)


#give execution permissions
permissions:
	chmod a+x $(BINDIR)/$(CLIENT)
	chmod a+x $(BINDIR)/$(SERVER)


#exec with std args
exec_server:
	@$(BINDIR)/$(SERVER) $$(cat server.txt)

exec_client:
	@$(BINDIR)/$(CLIENT) $$(cat client.txt)


#get todo list
todo:
	@grep -R TODO -n | tr -s ' ' | grep -v makefile


#print makefile info
info:
	@echo CLIENT = $(CLIENT)
	@echo SERVER = $(SERVER)
	@echo EXTENSION = $(EXTENSION)
	@echo INCLUDEDIR = $(INCLUDEDIR)
	@echo OBJDIR = $(OBJDIR)
	@echo SRCDIR = $(SRCDIR)
	@echo BINDIR = $(BINDIR)
	@echo LIBDIR = $(LIBDIR)
	@echo SRCFILES = $(SRCFILES)
	@echo HEADERFILES = $(HEADERFILES)
	@echo DEBUGFLAGS = $(FLAGS) $(DEBUGFLAGS)
	@echo RELEASEFLAGS = $(FLAGS)  $(RELEASEFLAGS)
	@echo CC = $(CC)
