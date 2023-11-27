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

Le comptage des occurrences du mot étudié se font avec l'expression régulière et la commande "wc".
grep prend -w, -i et -E comme option pour repérer les mots entiers avec l'ignorance de la casse. Les mots mis en recherche sont "IA, intelligence artificielle" pour le français et "AI, artificial intelligence" pour l'anglais.
Une fois que les occurrences sont retrouvés grâce à "grep", on passe à l'étape suivante pour les compter.
Comme on veut uniquement le nombre des occurrences, on utilise l'option "-w" de la commande "wc".
Voici la commande complète :
compte=$(grep -w -i -E "(IA|intelligence artificielle|AI|artificial intelligence)" "../dumps-text/${lang}-${lineno}.txt" | wc -w)

### Contexte

Concernant le contexte, le but est de repérer les N lignes d'avant et d'après du mot clé. Pour cela, on peut se servir de l'option "-C NUM" de la commande "grep". Si on veut les 2 lignes qui entourent le mot en recherche, la commande sera : 
Contextes=$(grep -w -i -E -o -C 2 "(IA|intelligence artificielle|AI|artificial intelligence)" "../dumps-text/${lang}-${lineno}.txt" > "../Contextes/${lang}-${lineno}.txt")

Quelques commentaires à mettre en place : 
l'utilisation de l'option "-o" permet de montrer seulement les résultats qu'on trouve dans la sortie standard. Ensuite, on les dirige vers les fichiers nommés par le nom de la langue et par l'indice de liens.

### Difficultés

Nous avons rencontré des difficultés pour le traitement des pages en chinois.
On n'a pas réussi à récupérer les données depuis les sites en chinois parce que certains sont énormément écrits en JavaScripts et certains montrent un refus à cause de la location de notre serveur. De ce fait, on est actuellement bloqués devant les sites en chinois à défaut de solution.