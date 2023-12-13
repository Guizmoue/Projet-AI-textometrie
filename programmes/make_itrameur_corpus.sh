#!/usr/bin/env bash

# vérification des arguments
if [[ $# -ne 2 ]]
then
	echo "Entrez 2 arguments : un dossier ('dumps-text' ou 'Contextes') et une langue ('fr' ou 'en' ou 'cn')"
	exit
fi

dossier=$1
basename=$2

echo "<lang=\"$basename\">" > "./itrameur/$dossier-$basename.txt"

for chemin in $(ls $dossier/$basename-*.txt)
do
	pagename=$(basename -s .txt $chemin)

	echo "<page=\"$pagename\">" >> "./itrameur/$dossier-$basename.txt"
	echo "<text>" >> "./itrameur/$dossier-$basename.txt"

	# récupération des contenus des fichiers
	content=$(cat $chemin)

	# substitutions des caractères &, < et >
	content=$(echo "$content" | sed 's/&/&amp;/g')
	content=$(echo "$content" | sed 's/</&lt;/g')
	content=$(echo "$content" | sed 's/>/&gt;/g')

	echo "$content" >> "./itrameur/$dossier-$basename.txt"

	echo "</text>" >> "./itrameur/$dossier-$basename.txt"
	echo "</page> §" >> "./itrameur/$dossier-$basename.txt"
done

echo "</lang>" >> "./itrameur/$dossier-$basename.txt"
