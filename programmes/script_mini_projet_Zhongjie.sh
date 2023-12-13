#!/usr/bin/env bash

if [[ $# -ne 1 ]]; 
then
    echo "Il faut un argument qui est le nom complet du fichier texte"
    exit
fi

URLS=$1
if [ ! -f $URLS ]
    then
        echo "On attend un fichier, pas un dossier"
        exit
fi

lineno=1
html_file="./tableau.html"
echo "<html><head></head><body>" > $html_file
echo "<table border='1'>" >> $html_file
while read -r line;
do
    response=$(curl -s -I -L -w "%{http_code}" -o /dev/null $line)
    charset=$(curl -s -I -L -w "%{content_type}" -o /dev/null $line | grep -E -o "charset=\S+" | cut -d"=" -f2 | tail -1)
    echo "<tr><td>$lineno</td><td>$line</td><td>$response</td><td>$charset</td></tr>" >> $html_file
    lineno=$(expr $lineno + 1)
done < $URLS
echo "</table></body></html>" >> $html_file

# Pour codes HTTP :
# Méthode 1 : curl -sI & head -1 | egrep -o "[0-9]{3}" ou curl -sI head -1 | cut -d" " -f2
# Méthode 2 : curl -s -I -w "%{http_code}" -o /dev/null https://fr.wikipedia.org/wiki/Robot # /dev/null est un fichier poubelle que l'on peut écrire n'importe quoi dedans
# -L changer les codes "300" à "200" : curl -s -I -L "%{http_code}" -o /dev/null fr.wikipedia.org/wiki/Robot_d%27indexation # suivre toutes les redirections que tu trouves, même s'il y en a pas, c'est pas grave.

# Pour codes charset :
# curl -s -I -w "%{content_type}" -o /dev/null $line | egrep -o "charset=\S+" (un non caractère d'espace) | cut -d"=" -f2 (deuxième colonne) | tail -n 1


