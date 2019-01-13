#!/bin/bash
mkdir -p /home/repositorio/
mkdir -p /repositorio/{Isos,Libros,Cursos,Peliculas}
FSTAB="/etc/fstab"
 if [ "$(grep repositorio $FSTAB)" == "" ] ; then
	echo "/home/repositorio/Isos /repositorio/Isos  none	bind  0 0" >> $FSTAB
	echo "/home/repositorio/Libros /repositorio/Libros none bind 0 0"  >> $FSTAB
	echo "/home/repositorio/Cursos /repositorio/Cursos none bind 0 0"  >> $FSTAB
	echo "/home/repositorio/Peliculas /repositorio/Peliculas none bind 0 0" >> $FSTAB
fi
