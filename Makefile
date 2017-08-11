CXX = g++
CFLAGS = -O0 -Wall -g -pg
SRCS = matadd.s matadd-driver.o
SRCSU2 = matadd_u2.s matadd-driver.o
SRCSU4 = matadd_u4.s matadd-driver.o
SRCSU8 = matadd_u8.s matadd-driver.o
BIN = matadd

all:
	$(CXX) $(CFLAGS) -o $(BIN) $(SRCS)

u2:
	$(CXX) $(CFLAGS) -o $(BIN) $(SRCSU2)

u4:
	$(CXX) $(CFLAGS) -o $(BIN) $(SRCSU4)

u8:
	$(CXX) $(CFLAGS) -o $(BIN) $(SRCSU8)

clean:
	rm -f $(BIN)
