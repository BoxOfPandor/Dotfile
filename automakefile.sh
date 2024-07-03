#!/bin/bash

# Nom du binaire
TARGET=main

# Dossiers
SRC_DIR=src
OBJ_DIR=obj
LIB_DIR=lib

# Assurer que le dossier obj existe
mkdir -p $OBJ_DIR

# Fichiers source et objet
SRCS=$(find $SRC_DIR -name '*.c')
OBJS=$(echo "$SRCS" | sed -e "s/$SRC_DIR\//$OBJ_DIR\//g" -e 's/\.c$/.o/g')

# Compilateur et flags
CC=gcc
CFLAGS=-Iinclude

# Début du Makefile
cat <<EOF >Makefile
CC=$CC
CFLAGS=$CFLAGS
OBJS=$OBJS

all: \$(OBJS)
    \$(CC) -o $TARGET \$(OBJS)

EOF

# Règle pour les fichiers objet
for OBJ in $OBJS; do
    SRC=$(echo "$OBJ" | sed -e "s/$OBJ_DIR\//$SRC_DIR\//g" -e 's/\.o$/.c/g')
    # Assurer que le dossier pour l'objet existe
    OBJ_DIR_PATH=$(dirname $OBJ)
    echo "mkdir -p $OBJ_DIR_PATH" >> Makefile
    cat <<EOF >>Makefile
$OBJ: $SRC
    mkdir -p $OBJ_DIR_PATH
    \$(CC) \$(CFLAGS) -c $SRC -o $OBJ

EOF
done

# Ajout des règles clean, fclean, et re
cat <<EOF >>Makefile

clean:
    rm -f \$(OBJS)

fclean: clean
    rm -f $TARGET

re: fclean all
EOF

echo "Makefile généré avec succès."
