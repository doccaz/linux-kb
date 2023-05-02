#!/bin/bash
#
# Downloads and installs a python interpreter with the required version in the homedir
# and creates a corresponding virtualenv
#
# Erico Mendonca <erico.mendonca@suse.com>
# Jan/2022
#
set -e

cd ~
mkdir -p tmp
cd tmp

if [ -z $1 ] || [ -z $2 ]; then
        echo "Usage: $0 <python version> <path where the virtualenv will be created>"
        exit 1
else
        VERSION="$1"
        CUTVER=$(echo $VERSION | cut -d\. -f1-2)
	VENVDIR="$2"
fi

if [ ! -x /usr/bin/gcc ]; then
	echo "You need to install the development tools first."
	echo "Execute: sudo zypper in -t pattern devel_C_C++"
	exit 1
fi

PDIR="${HOME}/opt/python-${VERSION}"

if [ ! -x ${PDIR}/bin/python${CUTVER} ]; then
	rm -f Python-${VERSION}.tgz
	wget https://www.python.org/ftp/python/${VERSION}/Python-${VERSION}.tgz
	if [ $? != 0 ]; then
		echo "Error downloading file. Do you need a proxy?"
		exit 1
	fi

	rm -rf Python-${VERSION}
	tar xvzf Python-${VERSION}.tgz
	cd Python-${VERSION}
	./configure --prefix=${PDIR} --exec-prefix=${PDIR}
	make
	#make install
	make altinstall
else
	echo "Won't compile this interpreter again, there is already a Python ${VERSION} at ${PDIR}"
fi

# ethis is required for SUSE or else the virtualenv won't work!
cd ${PDIR}/lib/python${CUTVER}
rm -f lib-dynload
ln -s ../../lib64/python${CUTVER}/lib-dynload .

cd -

export PYTHONHOME=${PDIR}

echo "Updating pip3 into ${PDIR}..."
rm -f get-pip.py
wget https://bootstrap.pypa.io/get-pip.py
if [ $? != 0 ]; then
	echo "Error downloading file. Do you need a proxy?"
	exit 1
fi
${PDIR}/bin/python${CUTVER} get-pip.py
# ${PDIR}/bin/python${CUTVER} -m pip install --upgrade pip

echo "Installing virtualenv module into ${PDIR}..."
${PDIR}/bin/pip3 install virtualenv

echo "Creating virtualenv into ${VENVDIR}..."
${PDIR}/bin/virtualenv ${VENVDIR}

echo "Use the following commands to activate the venv for Python ${VERSION}:"
echo 
echo "source ${VENVDIR}/bin/activate"
echo
echo "Use 'deactivate' to exit the Python ${VERSION} venv."


