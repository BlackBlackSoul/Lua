CC = gcc
CFLAGS = -Wall -O2 $(shell pkg-config --cflags lua5.3)
LDLIBS = $(shell pkg-config --libs lua5.3)
RM = rm -v -f

all: summation.so reverse.so merge.so

summation.so: summation.c
	$(CC) $(CFLAGS) $^ $(LDLIBS) -shared -fPIC -o summation.so
reverse.so: reverse.c
	$(CC) $(CFLAGS) $^ $(LDLIBS) -shared -fPIC -o reverse.so
merge.so: merge.c
	$(CC) $(CFLAGS) $^ $(LDLIBS) -shared -fPIC -o merge.so
#splitAt.so: splitAt.c
#	$(CC) $(CFLAGS) $^ $(LDLIBS) -shared -fPIC -o splitAt.so

clean:
	@$(RM) *.so
	@$(RM) *~
