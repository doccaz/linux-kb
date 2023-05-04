#!/bin/bash
#
# constroi um RPM a partir de um SPEC
#

trap cleanup SIGTERM SIGINT
SPECNAME=`ls -1 *spec | head -1`
PKGNAME=`grep '^Name.*:' ${SPECNAME} | cut -d\: -f2 | tr -d [:space:]`
TOPDIR="$HOME/rpmbuild"
RPMCMD=$(rpm --define "_topdir ${TOPDIR}" --eval '%{_sourcedir}')
SOURCESDIR=$(rpm --define "_topdir ${TOPDIR}" --eval '%{_sourcedir}')
BUILDDIR=$(rpm --define "_topdir ${TOPDIR}" --eval '%{_builddir}')
VERSION=`grep '^Version.*:' ${SPECNAME} | cut -d\: -f2 | tr -d [:space:]`
TMPDIR=`mkdir -p $TOPDIR/tmp; mktemp -d $TOPDIR/tmp/build-XXXXXXX`
SRCFILE="${SOURCESDIR}/${PKGNAME}-${VERSION}.tar.gz"

cleanup() 
{

rm -rf ${TMPDIR}

}

if [ -z $SPECNAME ]; then
	echo "Não foi possível determinar o nome do SPEC."
	exit 1
fi


echo "Criando diretórios..."
mkdir -p ${TOPDIR}/{SRPMS,RPMS,SOURCES,BUILD,SPECS} 
if [ $? != 0 ]; then
	echo "Erro ao criar diretórios ${TOPDIR}, ${SOURCESDIR}, ${BUILDDIR}"
	exit 1
fi

echo "Construindo pacote $PKGNAME..."
CURDIR=`pwd`

rm -f ${SOURCESDIR}/${SRCFILE}

mkdir -p ${TMPDIR}/${PKGNAME}-${VERSION}

cd ${TMPDIR}/${PKGNAME}-${VERSION}
echo "Criando arquivo .tar.gz..."
cp -dpRv ${CURDIR}/* .
tar -C ${TMPDIR} --exclude=.svn -cvzf ${SRCFILE} ${PKGNAME}-${VERSION}/
cd -
rm -rf ${TMPDIR}

rpmbuild --define "_topdir ${TOPDIR}" --define "_tmppath ${TOPDIR}/tmp" -ba ${SPECNAME} 

echo "Finalizado."

