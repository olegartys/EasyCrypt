#!/bin/bash

#
# EasyCrypt
# 
# Copyright 2014 olegartys <olegartys@gmail.com>
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
# MA 02110-1301, USA.
# 
# 
#


#VARIABLES INITIALIZATION
#----------------------------------------------------------------------#
DATE=6173;
COUNT=1;
PWD_OLD=$PWD;
RED="\033[0;31m";
YELLOW="\033[1;33m";
ENDCOLOR="\033[0m";
#Команды расшифровки/шифрования
DECRYPT_COMMAND="gpg";
CRYPT_COMMAND="gpg -c";
FIND_COMMAND="find . -maxdepth 1 -not -type d";
LIST=`find . -maxdepth 1 -not -type d -and -not -name '.*'`;
echo;
#----------------------------------------------------------------------#


#FUNCTIONS
#----------------------------------------------------------------------#
function fDeleteFile() {
	echo "Do you sure you want delete file $NAME? [Y/n]"; 
    read CHOOSE; 
    if [ "$CHOOSE" = "Y" ] || [ "$CHOOSE" = "y" ] || [ "$CHOOSE" = "" ]; 
        then rm -f "$NAME";
    fi; 
    echo -e "$RED Done!$ENDCOLOR";
}

function fPrintList() {
#FIXME : не работает подстановка переменной FIND_COMMAND и вывод всех фа\
йлов, включая скрытые
#Вывод всех нескрытых файлов в директории и считывание введённого номера
	echo -e "-----------$RED Choose the file:$ENDCOLOR------------";
	find . -maxdepth 1 -not -type d -and -not -name '.*' | cat -n
	echo "----------------------------------------";
	echo -e -n "$YELLOW Enter the number of file:$ENDCOLOR "; 
	read NUMBER;
}

function fFindFile() {
#Поиск файла в директории в соответствии с введённым номером
	for i in $LIST; do 
	  if [ "$COUNT" = "$NUMBER" ]; 
	  #Если введённый номер равен счётчику, то имя файла - $i
		  then NAME="$i"; break;
	  fi
	  ((COUNT++));
	done
	#В случае ошибки
	if [ "$NAME" = "" ]; then echo "Error: no file founded!" >&2; \
		exit 1; cd $PWD_OLD;
	fi
}
#----------------------------------------------------------------------#


#MAIN
#----------------------------------------------------------------------#
fPrintList;
fFindFile;

TMP=`echo "$NAME" | grep ".gpg"`
#Если в имени файла содержится ".gpg", то расшифровать, иначе зашифровать
if [ "$TMP" = "" ]; 
    then $CRYPT_COMMAND "$NAME"; 
	else $DECRYPT_COMMAND "$NAME"; 
fi

#fDeleteFile;
cd $PWD_OLD;
#----------------------------------------------------------------------#

exit 0
