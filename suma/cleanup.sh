#!/bin/bash

#
# Script para remover o cliente instalado, credenciais e IDs
#
# Referências:
# TID 7012170 - https://www.suse.com/support/kb/doc.php?id=7012170
# TID 7013242 - https://www.suse.com/support/kb/doc.php?id=7013242
# 

# Mata o cliente caso esteja rodando para evitar conflitos
killall -9 rhn_check

# remove versões antigas dos pacotes...
zypper -n rm 'zypp-plugin-spacewalk'
zypper -n rm 'spacewalk*'
zypper -n rm 'rhn*'

# atualiza o python usando os repositórios antigos, caso possível (para evitar o problema do Illegal instruction no 11SP2)
#zypper -n up python-base libxml2-python

# Limpa as credenciais para evitar problemas com sistemas clonados.
rm -f /etc/sysconfig/rhn/{osad-auth.conf,systemid}
rm /etc/zypp/credentials.d/NCCcredentials
rm /etc/zmd/deviceid  # SLES 10

cd /etc/zypp/repos.d
rm -rf old
mkdir old
mv *.repo old/
cd -

