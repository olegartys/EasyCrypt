#!/bin/bash

#Инициализация переменных
DATE=6173;
COUNT=1;
PWD_OLD=$PWD;
RED="\033[0;31m";
YELLOW="\033[1;33m";
ENDCOLOR="\033[0m";
#Команды расшифровки/шифровки
ENCRYPT_COMMAND="gpg";
CRYPT_COMMAND="gpg -c";
echo;

function fDeleteFile () {
	echo "Do you sure you want delete file $NAME? [Y/n]"; 
      read CHOOSE; 
      if [ "$CHOOSE" = "Y" ] || [ "$CHOOSE" = "y" ] || [ "$CHOOSE" = ""]; 
          then rm -f "$NAME";
      fi; echo -e "$RED Done!$ENDCOLOR"
}



if [ "$1" = "-d"]; then echo "hello"; fi
#Вывод всех нескрытых файлов в директории
LIST=`find . -maxdepth 1 -not -type d -and -not -name '.*'`

echo -e "-----------$RED Choose the file:$ENDCOLOR------------"
find . -maxdepth 1 -not -type d -and -not -name '.*' | cat -n; 
echo "----------------------------------------"
echo -e -n "$YELLOW Enter the number of file:$ENDCOLOR "; read NUMBER;

#Если введённый номер равен счётчику, то имя файла - $i
for i in $LIST; do 
	if [ "$COUNT" = "$NUMBER" ]; 
		then NAME="$i"; break;
	fi
	((COUNT++));
done

#В случае ошибки
if [ "$NAME" = "" ]; then echo "Error: no file founded!" >&2; exit 1; cd $PWD_OLD;
fi

#Если есть файлы с расширением .gpg 
TMP=`find . -maxdepth 1 -name '*.gpg'`

if [ "$TMP" != "" ]; 
    then gpg "$NAME"; 
	else gpg -c "$NAME"; 
fi

fDeleteFile ();
cd $PWD_OLD;

exit 0
