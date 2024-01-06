# Ce programme permet d'obtenir des fichiers en pseudo-XML pouvant être traités par iTrameur.
# Il prend en entrée un dossier contenant les fichiers de contextes de ontre mots, et la langue.
# Les fichiers sont compilés en un seul fichier utilisé par la suite dans iTrameur.

#!/usr/bin/env bash

# vérification des arguments
if [[ $# -ne 2 ]]
then
	echo "Entrez 2 arguments : un dossier ('Contextes') et une langue ('fr' ou 'en' ou 'cn')"
	exit
fi

# stockage des arguments dans des variables
dossier=$1
basename=$2

echo "<lang=\"$basename\">" > "../itrameur/$dossier-$basename.txt"

# Pour chaque fichier du dossier, on effectue les actions suivantes :
for chemin in $(ls ../$dossier/$basename-*.txt)
do
	pagename=$(basename -s .txt $chemin)

	# format pseudo-XML pour le fichier de sortie
	echo "<page=\"$pagename\">" >> "../itrameur/$dossier-$basename.txt"
	echo "<text>" >> "../itrameur/$dossier-$basename.txt"

	# récupération des contenus des fichiers
	content=$(cat $chemin)

	# substitutions des caractères &, < et >
	content=$(echo "$content" | sed 's/&/&amp;/g')
	content=$(echo "$content" | sed 's/</&lt;/g')
	content=$(echo "$content" | sed 's/>/&gt;/g')

	# format pseudo-XML pour le fichier de sortie
	echo "$content" >> "../itrameur/$dossier-$basename.txt"
	echo "</text>" >> "../itrameur/$dossier-$basename.txt"
	echo "</page> §" >> "../itrameur/$dossier-$basename.txt"
done

# format pseudo-XML pour le fichier de sortie
echo "</lang>" >> "../itrameur/$dossier-$basename.txt"
