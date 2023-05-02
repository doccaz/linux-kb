#!/bin/bash
#
# Baixa e instala um interpretador python da versão solicitada no homedir
# e cria o virtualenv correspondente
#
# Erico Mendonca <erico.mendonca@suse.com>
# Jan/2022
#
set -e

cd ~
mkdir -p tmp
cd tmp

if [ -z $1 ] || [ -z $2 ]; then
        echo "Uso: $0 <versão do python> <diretório onde será criado o venv>"
        exit 1
else
        VERSION="$1"
        CUTVER=$(echo $VERSION | cut -d\. -f1-2)
	VENVDIR="$2"
fi

if [ ! -x /usr/bin/gcc ]; then
	echo "Você precisa instalar as ferramentas de desenvolvimento primeiro."
	echo "Execute: sudo zypper in -t pattern devel_C_C++"
	exit 1
fi

PDIR="${HOME}/opt/python-${VERSION}"

if [ ! -x ${PDIR}/bin/python${CUTVER} ]; then
	rm -f Python-${VERSION}.tgz
	wget https://www.python.org/ftp/python/${VERSION}/Python-${VERSION}.tgz
	if [ $? != 0 ]; then
		echo "Erro ao baixar arquivo. Precisa de proxy?"
		exit 1
	fi

	rm -rf Python-${VERSION}
	tar xvzf Python-${VERSION}.tgz
	cd Python-${VERSION}
	./configure --prefix=${PDIR} --exec-prefix=${PDIR} --enable-ssl
	make
	#make install
	make altinstall
else
	echo "Não irei compilar novamente, já existe Python ${VERSION} em ${PDIR}"
fi

# este ajuste é necessário no SUSE
cd ${PDIR}/lib/python${CUTVER}
rm -f lib-dynload
ln -s ../../lib64/python${CUTVER}/lib-dynload .

cd -

export PYTHONHOME=${PDIR}

echo "Atualizando pip3 dentro de ${PDIR}..."
rm -f get-pip.py
wget https://bootstrap.pypa.io/get-pip.py
if [ $? != 0 ]; then
	echo "Erro ao baixar arquivo. Precisa de proxy?"
	exit 1
fi
${PDIR}/bin/python${CUTVER} get-pip.py
# ${PDIR}/bin/python${CUTVER} -m pip install --upgrade pip

echo "Instalando módulo virtualenv dentro de ${PDIR}..."
${PDIR}/bin/pip3 install virtualenv --global http.sslVerify false

echo "Criando virtualenv em ${VENVDIR}..."
${PDIR}/bin/virtualenv ${VENVDIR}

echo "Use o seguinte comandos para ativar o venv do Python ${VERSION}:"
echo 
echo "source ${VENVDIR}/bin/activate"
echo
echo "Use 'deactivate' para sair do venv do python ${VERSION}."


