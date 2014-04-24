# Algoritmos Divide y vencerás.
# makefile.
# Basado en: http://stackoverflow.com/questions/9787160/makefile-that-compiles-all-cpp-files-in-a-directory-into-separate-executable

BIN=./bin
SRC=./src
DATA=./data
TEX=./tex
FLAGS=-std=c++0x -Wall -fopenmp

# make all: Compilar todos los programas 

.PHONY: tex

tex:
	./gentex.sh

# Limpieza de los ejecutables
clean:
	rm $(BIN)/*
