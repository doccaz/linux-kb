#!/bin/bash

CURYEAR=`date +%Y`
REPORTALL="sloc-all.txt"

FILES1YEAR="arquivos-1ano.txt"
FILES3YEARS="arquivos-3anos.txt"
FILES5YEARS="arquivos-5anos.txt"
FILESALL="arquivos-all.txt"

declare -a DIRS INFO
let count=0

declare -a LAST5DIRS LAST5INFO
let countfive=0

declare -a LAST3DIRS LAST3INFO
let countthree=0

declare -a LAST1DIRS LAST1INFO
let countone=0

echo "Buscando lista de diretorios..."
DIRS_TO_SCAN=`find . -type d | egrep -v '\.svn'`

echo "Gerando relatorios, aguarde..."
for f in $DIRS_TO_SCAN; do

	DIRS[$count]=`echo -e \"$f\"`
	INFO[$count]=`svn info --xml $f 2>/dev/null | grep '<date>' | sed -e 's@<date>@@1;s@</date>@@1' | cut -dT -f1`
	echo -n "."

	let count=count+1
done

echo 

for ((f=0; f<$count; f++)); do
	if [ ! -z ${INFO[$f]} ]; then
		YEAR=`echo ${INFO[$f]} | cut -d- -f1`
		if [ ${YEAR} == "" ]; then 
			DIFF=999
			echo "Ignorando diretório sem data de modificação: ${DIRS[$f]} ${YEAR}"
		else
			let DIFF=${CURYEAR}-${YEAR}
		fi

		if [ $DIFF -lt 6 ]; then
			LAST5DIRS[$countfive]=${DIRS[$f]}
			LAST5INFO[$countfive]=${INFO[$f]}
			let countfive=countfive+1
		fi
		if [ $DIFF -lt 4 ]; then
			LAST3DIRS[$countthree]=${DIRS[$f]}
			LAST3INFO[$countthree]=${INFO[$f]}
			let countthree=countthree+1
		fi
		if [ $DIFF -lt 2 ]; then
			LAST1DIRS[$countone]=${DIRS[$f]}
			LAST1INFO[$countone]=${INFO[$f]}
			let countone=countone+1
		fi
	else
		echo "Ignorando elemento sem informacao de data: ${DIRS[$f]}"
		continue
	fi
done

echo "Total de $count diretorios encontrados."
echo "$countfive diretorios alterados nos últimos 5 anos"
echo "$countthree diretorios alterados nos últimos 3 anos"
echo "$countone diretorios alterados nos últimos 1 anos"

# um ano
echo "Gerando relatorio de arquivos alterados ha 1 ano..."
echo "Lista de diretórios alterados há menos de 1 ano (`date +%Y-%m-%d`)" > $FILES1YEAR
echo "==================================================================" >> $FILES1YEAR
echo >> $FILES1YEAR
for ((f=0; f<$countone; f++)); do
	echo "(${LAST1INFO[$f]}) ${LAST1DIRS[$f]}" >> $FILES1YEAR
done
echo >> $FILES1YEAR
echo "Total de $countone diretórios." >> $FILES1YEAR

# tres anos
echo "Gerando relatorio de arquivos alterados ha 3 anos..."
echo "Lista de diretórios alterados há menos de 3 anos (`date +%Y-%m-%d`)" > $FILES3YEARS
echo "==================================================================" >> $FILES3YEARS
echo >> $FILES3YEARS
for ((f=0; f<$countthree; f++)); do
	echo "(${LAST3INFO[$f]}) ${LAST3DIRS[$f]}" >> $FILES3YEARS
done
echo >> $FILES3YEARS
echo "Total de $countthree diretórios." >> $FILES3YEARS

# cinco anos
echo "Gerando relatorio de arquivos alterados ha 5 anos..."
echo "Lista de diretórios alterados há menos de 5 anos (`date +%Y-%m-%d`)" > $FILES5YEARS
echo "==================================================================" >> $FILES5YEARS
echo >> $FILES5YEARS
for ((f=0; f<$countfive; f++)); do
	echo "(${LAST5INFO[$f]}) ${LAST5DIRS[$f]}" >> $FILES5YEARS
done
echo >> $FILES5YEARS
echo "Total de $countfive diretórios." >> $FILES5YEARS


# todos os arquivos
TMPFILE=`mktemp /tmp/svnbydate.XXXXXX`
echo "Gerando relatorio de arquivos completa..."
echo "Lista de diretórios completa (gerado em `date +%Y-%m-%d`)" > $FILESALL
echo "==================================================================" >> $FILESALL
echo >> $FILESALL
for ((f=0; f<$count; f++)); do
	if [ ! -z ${INFO[$f]} ]; then
		echo "(${INFO[$f]}) ${DIRS[$f]}" >> $FILESALL
		echo ${DIRS[$f]} >> $TMPFILE
	fi
done
echo >> $FILESALL
echo "Total de $count diretórios." >> $FILESALL

echo Gerando relatorios de SLOC para todos os arquivos...
echo "Sumário de arquivos de código-fonte (gerado em `date +%Y-%m-%d`)" > $REPORTALL
echo "Total de $count diretórios." >> $REPORTALL
echo "=================================================================================================" >> $REPORTALL
ohcount -s < ${TMPFILE} 2>&1 >> $REPORTALL
if [ $? != 0 ]; then
	echo "Erro ao executar ohcount. Temporários salvos em ${TMPFILE}, report parcial em ${REPORTALL}"
else
	rm -f ${TMPFILE}
fi

echo "Pronto."
