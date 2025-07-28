CC = g++
#CFLAGS = -O2 -fPIC -shared -arch arm64 -arch x86_64 -std=c++11 -I/opt/homebrew/include/luajit-2.1 -IOpenFBX/src
CFLAGS = -O2 -fPIC -shared -arch arm64 -arch x86_64 -std=c++11 -I/opt/homebrew/include/lua5.4 -IOpenFBX/src
#LDFLAGS = -LOpenFBX/ -lOpenFBX -LOpenFBX/ -ldeflate -L/opt/homebrew/lib -llua
#LDFLAGS = -undefined dynamic_lookup -LOpenFBX/ -lOpenFBX -ldeflate
LDFLAGS = -undefined dynamic_lookup OpenFBX/libOpenFBX.a OpenFBX/libdeflate.a

TARGET = openfbx.so
SRC = luaopenfbx.cpp ufbx.c

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) $(SRC) $(LDFLAGS) -o $(TARGET)

clean:
	rm -f $(TARGET)