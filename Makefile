CC = g++
CFLAGS = -O2 -shared -fPIC -std=c++11 -I/opt/homebrew/include/luajit-2.1 -IOpenFBX/src
#LDFLAGS = -LOpenFBX/build -lOpenFBX -LOpenFBX/build/_deps/libdeflate-build/ -ldeflate -L/opt/homebrew/lib -llua
LDFLAGS = -undefined dynamic_lookup -LOpenFBX/build -lOpenFBX OpenFBX/build/_deps/libdeflate-build/libdeflate.a

TARGET = openfbx.so
SRC = luaopenfbx.cpp

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) $(SRC) $(LDFLAGS) -o $(TARGET)

clean:
	rm -f $(TARGET)