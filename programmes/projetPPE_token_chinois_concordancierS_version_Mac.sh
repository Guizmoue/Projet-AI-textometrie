#!/usr/bin/env bash

if [ $# -ne 1 ]
then
    echo "On veut exactement un argument"
    exit
fi

cd ../URLs/ # pourquoi on a besoin d'aller dans le fichier URLs ?

URLS="$1"

if [ ! -f $URLS ]
then
    echo "On attend un fichier !"
fi

lineno=1
lang=$(basename $URLS .txt)
html_file="../tableaux/$lang.html"
#motif="intelligence\sartificielle"
motif="(\bIA\b|intelligence\sartificielle|\bAI\b|artificial\sintelligence|人工(\s)?智能|人工(\s)?智慧)"


echo "<table class="table mt-4 table-striped table-hover" id="${lang}">" >> $html_file
echo "<tr><th>Ligne</th><th>URL</th><th>Code HTTP</th><th>Encodage</th><th>Aspiration</th><th>Dump</th><th>Compte</th><th>Contexte</th><th>Concordances</th></tr>" >> $html_file

while read -r URL
do
    response=$(curl -s -I -L -w "%{http_code}" -o /dev/null $URL)
    encoding=$(curl -s -I -L -w "%{content_type}" -o /dev/null $URL | ggrep -P -o "charset=\S+" | cut -d"=" -f2)
    aspi=$(curl -s -L -o "../aspirations/${lang}-${lineno}.html" $URL)

    compte=0
    TEXTFILE="NA"

    if [ $response -eq 200 ]
    then

        # tokenisation des textes en chinois
        if [ ! "${lang}" = "cn" ]
        then
            # création du dump text
            lynx -assume_charset=utf-8 -display_charset=utf-8 -dump -nolist $URL > "../dumps-text/${lang}-${lineno}.txt"
            TEXTFILE="../dumps-text/${lang}-${lineno}.txt"
        fi

        if [ "${lang}" == "cn" ]
        then
            w3m $URL > ../dumps-text/${lang}-${lineno}.txt
            TEXTFILE=../dumps-text/${lang}-${lineno}.txt
            python -m thulac ${TEXTFILE} ../dumps-text/${lang}-${lineno}_token.txt -seg_only
            TEXTFILE=../dumps-text/${lang}-${lineno}_token.txt
        fi

        # compter le nombre d'occurrence
        compte=$(ggrep -P -i -o $motif "../dumps-text/${lang}-${lineno}.txt" | wc -l)

        # recherche des contextes
        cat $TEXTFILE | ggrep -P -i -A 1 -B 1 "${motif}" > "../Contextes/${lang}-${lineno}.txt"

        # création du concordancier
        echo "<html><head></head><body>" > "../concordances/${lang}-${lineno}.html"
        echo "<table border='1'>" >> "../concordances/${lang}-${lineno}.html"
        echo "<tr><th>Contexte gauche</th><th>Mot</th><th>Contexte droit</th></tr>" >> "../concordances/${lang}-${lineno}.html"
        if [ "${lang}" == "cn" ] # concordancier chinois
        then
            export LANG=zh_CN.UTF-8
            ggrep -Po "(?:\p{Han}{1,}\s|[\x{3002}\x{FF0C}\x{FF1A}\x{FF01}\x{FF1F}\x{3010}\x{3011}\x{FF08}\x{FF09}]\s|\n){0,5}(人工 智能|人工 智慧|AI|ai|Ai)(\s\p{Han}{1,}|\s[\x{3002}\x{FF0C}\x{FF1A}\x{FF01}\x{FF1F}\x{3010}\x{3011}\x{FF08}\x{FF09}]|\n){0,5}" $TEXTFILE | LANG=C sed -E -r "s/(.*)(人工 智能|人工 智慧|AI|ai|Ai)(.*)/<tr><td>\1<\/td><td>\2<\/td><td>\3<\/td><\/tr>/" >> "../concordances/${lang}-${lineno}.html"
            ggrep -Po "(?:\p{Han}{1,}\s|[\x{3002}\x{FF0C}\x{FF1A}\x{FF01}\x{FF1F}\x{3010}\x{3011}\x{FF08}\x{FF09}]\s|\n){0,5}(人工智能|人工智慧)(\s\p{Han}{1,}|\s[\x{3002}\x{FF0C}\x{FF1A}\x{FF01}\x{FF1F}\x{3010}\x{3011}\x{FF08}\x{FF09}]|\n){0,5}" $TEXTFILE | LANG=C sed -E -r "s/(.*)(人工智能|人工智慧)(.*)/<tr><td>\1<\/td><td>\2<\/td><td>\3<\/td><\/tr>/" >> "../concordances/${lang}-${lineno}.html"
        fi
        if  [ "${lang}" = "en" ] # concordancier anglais
        then
            ggrep -Po -i "(\w+\W+){0,5}(AI|artificial intelligence)(\W+\w+){0,5}" $TEXTFILE | sed -E -r "s/(.*)(AI|ai|artificial intelligence|Artificial Intelligence|Artificial intelligence|Ai)(.*)/<tr><td>\1<\/td><td>\2<\/td><td>\3<\/td><\/tr>/" >> "../concordances/${lang}-${lineno}.html"
        fi
        if [ "${lang}" = "fr" ] # concordancier français
        then
            ggrep -Po -i "(\w+\W+){0,5}(IA|intelligence artificielle)(\W+\w+){0,5}" $TEXTFILE | sed -E -r "s/(.*)(IA|intelligence artificielle|ia|Intelligence Artificielle|Intelligence artificielle|Ia)(.*)/<tr><td>\1<\/td><td>\2<\/td><td>\3<\/td><\/tr>/" >> "../concordances/${lang}-${lineno}.html"
        fi
        echo "</table></body></html>" >> "../concordances/${lang}-${lineno}.html"
    fi

    echo "<tr>
    <td>$lineno</td>
    <td>$URL</td>
    <td>$response</td>
    <td>$encoding</td>
    <td><a href ="../aspirations/${lang}-${lineno}.html">Aspiration</a></td>
    <td><a href ="../dumps-text/${lang}-${lineno}.txt">Dump</a></td>
    <td>$compte</td>
    <td><a href="../Contextes/${lang}-${lineno}.txt">Contextes</a></td>
    <td><a href="../concordances/${lang}-${lineno}.html">Concordances</a></td>
    </tr>" >> $html_file
    lineno=$(expr $lineno + 1)
done < $URLS
echo "</table>" >> $html_file

# Créer les sources pour les nuages de mot
cat "../Contextes/${lang}-*.txt >> "../itrameur/source_nuage_${lang}.txt"