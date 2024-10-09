APPNAME = mp3player
EXT = .cpp
SRCDIR = src
OBJDIR = obj

# de acá para abajo no se toca
CC = g++
CXXFLAGS = -std=c++11 -Wall
LDFLAGS = -lmpg123 -lasound -lpthread

SRC = $(wildcard $(SRCDIR)/*$(EXT))
OBJ = $(SRC:$(SRCDIR)/%$(EXT)=$(OBJDIR)/%.o)
DEP = $(OBJ:$(OBJDIR)/%.o=%.d)


all: $(APPNAME)

$(APPNAME): $(OBJ)
	$(CC) $(CXXFLAGS) -o $@ $^ $(LDFLAGS)

#dependencias
%.d: $(SRCDIR)/%$(EXT)
	@$(CPP) $(CFLAGS) $< -MM -MT $(@:%.d=$(OBJDIR)/%.o) >$@

#incluye las .h
-include $(DEP)

$(OBJDIR)/%.o: $(SRCDIR)/%$(EXT)
	$(CC) $(CXXFLAGS) -o $@ -c $<

.PHONY: clean
clean:
	rm $(DELOBJ) $(DEP) $(APPNAME)

.PHONY: cleandep
cleandep:
	rm $(DEP)


