#!/bin/bash

if [ -d /usr/java/latest/jre ]; then

	update-alternatives --install /usr/bin/java java /usr/java/latest/jre/bin/java 1
	update-alternatives --config java

	update-alternatives --install /usr/lib64/browser-plugins/javaplugin.so javaplugin /usr/java/latest/jre/lib/amd64/libnpjp2.so 1
	update-alternatives --config javaplugin

	update-alternatives --install /usr/bin/javac javac /usr/java/latest/bin/javac 1
	update-alternatives --config javac

	update-alternatives --install /usr/bin/javah javah /usr/java/latest/bin/javah 1
	update-alternatives --config javah

	update-alternatives --install /usr/bin/jar jar /usr/java/latest/bin/jar 1
	update-alternatives --config jar


else

	update-alternatives --install /usr/bin/java java /usr/java/latest/bin/java 1
	update-alternatives --config java

	update-alternatives --install /usr/lib64/browser-plugins/javaplugin.so javaplugin /usr/java/latest/lib/amd64/libnpjp2.so 1
	update-alternatives --config javaplugin

fi
