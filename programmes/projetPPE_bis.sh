#!/usr/bin/env bash

if [ $# -ne 1 ]
then
    echo "On veut exactement un argument"
    exit
fi

# cd ./URLs/ # pourquoi on a besoin d'aller dans le fichier URLs ?

URLS="$1"

if [ ! -f $URLS ]
then
    echo "On attend un fichier !"
fi

lineno=1
lang=$(basename $URLS .txt)
html_file="./tableaux/$lang.html"
#motif="intelligence\sartificielle"
motif="(\bIA\b|intelligence\sartificielle|\bAI\b|artificial\sintelligence|人工智能|人工智慧)"


echo "<html><head></head><body>" > $html_file
echo "<table border='1'>" >> $html_file
echo "<tr><th>Ligne</th><th>URL</th><th>Code HTTP</th><th>Encodage</th><th>Aspiration</th><th>Dump</th><th>Compte</th><th>Contexte</th><th>Concordances</th></tr>" >> $html_file

while read -r URL
do
    response=$(curl -s -I -L -w "%{http_code}" -o /dev/null $URL)
    encoding=$(curl -s -I -L -w "%{content_type}" -o /dev/null $URL | ggrep -P -o "charset=\S+" | cut -d"=" -f2)
    aspi=$(curl -s -L -o "./aspirations/${lang}-${lineno}.html" $URL)

    compte=0
    TEXTFILE="NA"

    if [ $response -eq 200 ]
    then
        if [ ! $encoding == "UTF-8"]
        then
            iconv -f "${encoding}" -t "UTF-8" -o "/tmp/recode_${lineno}.html" "./aspirations/${lang}-${lineno}.html"
            mv "/tmp/recode_${lineno}.html" "./aspirations/${lang}-${lineno}.html"
        fi

        # création du dump text
        lynx -assume_charset UTF-8 -dump -nolist "./aspirations/${lang}-${lineno}.html" > "./dumps-text/${lang}-${lineno}.txt"

        TEXTFILE="./dumps-text/${lang}-${lineno}.txt"
        compte=$(ggrep -P -i -o $motif "./dumps-text/${lang}-${lineno}.txt" | wc -l)

        # recherche des contextes
        cat $TEXTFILE | ggrep -P -i -A 1 -B 1 "${motif}" > "./Contextes/${lang}-${lineno}.txt"

        if [ ! ${lang} = "cn" ]
        then
            # création du concordancier
            echo "<html><head></head><body>" > "./concordances/${lang}-${lineno}.html"
            echo "<table border='1'>" >> "./concordances/${lang}-${lineno}.html"
            echo "<tr><th>Contexte gauche</th><th>Mot</th><th>Contexte droit</th><th></tr>" >> "./concordances/${lang}-${lineno}.html"
            grep -E -i -o "(\w+\W+){0,5}$motif(\W+\w+){0,5}" $TEXTFILE | sed -E 's/(.*)(\bIA\b|intelligence\sartificielle|\bAI\b|artificial\sintelligence)(.*)/<tr><td>\1<\/td><td>\2<\/td><td>\3<\/td><\/tr>/' >> "./concordances/${lang}-${lineno}.html"
            echo "</table></body></html>" >> "./concordances/${lang}-${lineno}.html"
        fi

        if [ ${lang} = "cn" ]
        then
            motif="(人工 智能|人工 智慧)"
            echo "<html><head></head><body>" > "./concordances/${lang}-${lineno}.html"
            echo "<table border='1'>" >> "./concordances/${lang}-${lineno}.html"
            echo "<tr><th>Contexte gauche</th><th>Mot</th><th>Contexte droit</th><th></tr>" >> "./concordances/${lang}-${lineno}.html"
            cat $TEXTFILE | python3 ./programmes/chinois/tokenize_chinese.py | grep -E -i -o "(\w+\W+){0,5}$motif(\W+\w+){0,5}" $TEXTFILE | sed -E 's/(.*)(人工 智能|人工 智慧)(.*)/<tr><td>\1<\/td><td>\2<\/td><td>\3<\/td><\/tr>/' >> "./concordances/${lang}-${lineno}.html"
            echo "</table></body></html>" >> "./concordances/${lang}-${lineno}.html"
        fi
        motif="(\bIA\b|intelligence\sartificielle|\bAI\b|artificial\sintelligence|人工智能|人工智慧)"
    fi

    echo "<tr>
    <td>$lineno</td>
    <td>$URL</td>
    <td>$response</td>
    <td>$encoding</td>
    <td><a href ="./aspirations/${lang}-${lineno}.html">Aspiration</a></td>
    <td><a href ="./dumps-text/${lang}-${lineno}.txt">Dump</a></td>
    <td>$compte</td>
    <td><a href="./Contextes/${lang}-${lineno}.txt">Contextes</a></td>
    <td><a href="./concordances/${lang}-${lineno}.html">Concordances</a></td>
    </tr>" >> $html_file
    lineno=$(expr $lineno + 1)
done < $URLS
echo "</table></body></html>" >> $html_file
