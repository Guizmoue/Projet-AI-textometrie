# Journal de bord du projet PPE 2023

## Semaine 9

### Plan

Lors de cette semaine, nous avons créé un git partagé par les trois membres de notre groupe, afin de pouvoir gérer le projet de façon collaborative. Nous avons ensuite apporté des modifications au programme réalisé pendant le mini-projet dans le but de sauvegarder les pages aspirées et les dumps textuels. Nous avons également ajouté le compte des occurrences de notre mot étudié, ainsi que ses contextes.

### Sauvegarder la page aspirée et le dump textuel

Afin de sauvegarder la page aspirée, nous avons ajouté la ligne de code suivante à notre programme :
aspi=$(curl -s -L -o "../aspirations/${lang}-${lineno}.html" $URL)
On récupère ainsi avec la commande curl les pages correspondant à nos URLs nommées au préalable sous le format langue-numéro_de_ligne.html, et on les stocke dans la variable aspi$.
Puis on ajoute cette variable comme colonne de notre tableau.

Pour les dumps, nous avons utilisé la ligne de code suivante :
dumps=$(lynx -dump $URL > "../dumps-text/${lang}-${lineno}.txt")
Cette commande permet, avec lynx auquel on ajoute l'option -dump, de récupérer les dumps textuels des nos URLs.

### Compter les occurrences du mot étudié



### Contexte



### Difficultés

Nous avons rencontré des difficultés pour le traitement des pages en chinois.






