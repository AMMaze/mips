CC=iverilog
CFLAGS=-Wall
LDFLAGS=
SOURCES=$(wildcard modules/*.v)
ROOT=test_bench.v
#OBJECTS=$(SOURCES:.v=.o)
EXECUTABLE=mips

all: 
	$(CC) $(CFLAGS) $(ROOT) $(SOURCES) -o $(EXECUTABLE)


#all: $(SOURCES) $(EXECUTABLE)
	
#$(EXECUTABLE): $(OBJECTS) 
#	$(CC) $(LDFLAGS) $(OBJECTS) -o $@
