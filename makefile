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

FLAGS := 

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
	