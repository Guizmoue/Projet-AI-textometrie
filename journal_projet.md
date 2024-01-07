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

### Site Web

Création de la page d'accueil de notre site web en Html et Css.

### Difficultés

Nous avons rencontré des difficultés pour le traitement des pages en chinois.
On n'a pas réussi à récupérer les données depuis les sites en chinois parce que certains sont énormément écrits en JavaScripts et certains montrent un refus à cause de la location de notre serveur. De ce fait, on est actuellement bloqués devant les sites en chinois à défaut de solution.



## Semaine 10

### Plan

Lors de cette semaine, nous avons terminé notre concordancier et ajouté les liens à nos tableaux html. Nous avons également écrit un nouveau script permettant de générer une base analysable par itrameur.

### Fichier base iTrameur

Nous avons commencé par intégrer la struture pseudo-XML à notre script, en y incluant les balises langue, page, et texte.

### Travail sur les dumps textuels et les contextes

Nous avons ensuite intégré 2 arguments à notre script : un dossier (dumps-text ou Contextes) et la langue (dans notre cas, fr, en, ou cn).
Avec une boucle, on parcourt tous les fichiers dumps-text ou Contextes dans la langue indiquée en argument, et on récupère leur contenu que l'on stocke dans la balise text. On effectue aussi des substitutions pour les caractères "&", "<" et ">" pour éviter les problèmes d'interprétation.

### Site Web

Finalisation de la maquette du site web avec le framework Bootstrap.

### Travail sur iTrameur

iTrameur est un outil de textométrie en ligne assez puissant pour traiter les textes en alphabet latin. Il donne la possibilité de rendre la distribution de termes dans le corpus. Nous pouvons obtenir les concordances, les cooccurents, la fréquence (relative ou absolue) ainsi que d'autres caractéristiques d'un terme spécifique à l'aide d'iTrameur. Pourtant, il n'est pas conçu pour certaines langues asiatiques comme le chinois. Donc afin de procéder à la textométrie des textes en chinois, il faut s'appuyer sur d'autres outiles comme "SketchEngine", qui tokenise et analyse correctement les textes en chinois. 

L'autre imperfection de l'iTrameur est qu'il ne peut pas enquêter plusieurs mots en une seule fois. Comme nous avons pris le terme IA, qui s'écrit souvent sous forme complète : interlligence artificielle, iTrameur ne permet pas d'analyser la forme complète, ce qui nous pose des problèmes.

### Utiliser des scripts directement

Afin de compléter le défaut de l'iTrameur, nous avons sollicité à des scripts complémentaires. Grâce au script "cooccurents.py", nous avons réussi à obtenir les cooccurrents d'"intelligence artificielle" ou d'autres termes composés de plusieurs mots en utilisant l'expression régulière. Pourtant, le script ne permet toujours pas de traiter les textes en chinois et il nous semble qu'il ne détecte pas les termes "AI" ou "IA". 



## Semaine 12

### Plan

Durant cette semaine, nous avons réussi à tokeniser les textes chinois et à obtenir les concordanciers correctement affichés. Avant, il y avait des lignes de phrases en dessus des tableaux. Ce problème était surtout important dans les concordanciers chinois. Le problème était dû au motif pour la commande sed. Différent de grep, sed n'est pas capable de reconnaître certains symboles de la regex comme '?', '[]'. Si on utilise le motif de grep à sed, sed va rejeter certains motifs non reconnus et en mettent à côté, ce qui fait que ces motifs ne sont pas entrés dans les tableaux de concordancier. Donc, la solution est d'utiliser la structure '(|)' pour citer tous les motifs en recherche. Concernant les concordanciers chinois, afin de répondre à la nécessité de prendre en compte les ponctuations dans les concordanciers, nous avons cité tous les Unicodes de la plupart des ponctuations chinoises dans le motif de grep car les ponctuations chinoises sont différentes de celles du français et de l'anglais.

D'ailleurs, nous avons conçus des programmes de python pour pré traiter les textes passé à l'iTrameur. Comme l'iTrameur analyse chaque fois un seul mot, nous avons collé "artificial intelligence" ensemble comme "artificialintelligence", donc "intelligenceartificielle" pour le français. Pour le chinois, l'IA est traduit à la fois en '人工智能' ou '人工智慧'. Ces deux termes sont identiques et interchangeables, et ils sont tokenisé en '人工 智能' ou '人工 智慧' par le tokeniseur. En vue de faciliter l'analyse sur iTrameur, nous avons respectivement collé '人工' et '智能', '人工' et '智慧' ensemble， puis nous avons remplacé tous les '人工智慧' par '人工智能'.

### Site Web

Creation d'un script, nomme script_generateur_tableaux.sh, qui integre dans la page data.html les tableaux fr.html, en.html et cn.html.


### Difficultés

Les points noires sont les conflits entre local et serveur git. Dans le cas ou, suite a des mofifications en local alors que l'utilisateur a 2 commits de retards sur le serveur. Nous avons experiente la solution suivantes : premierement entrez la commande git stash qui va retirer et enregistrer les fichiers modifies non valides. Deuxiement, l'utilisateur doit mettre a jour son git pour rattraper son retard a l'aide des commandes : git add, git commit et git pull. Enfin, on reintegre les fichiers avec la commande git stash apply que l'on add et commit avant de push.


## Semaine 15

### Plan

Analyse des resultats et rédaction pour le rendu final.

Création des nuages de mots en filtrant les stopwords.

### Site Web

Mise en place d'un canal de communication avec les internautes. Grâce à l'onglet CONTACTEZ-NOUS, il est possible d'envoyer un message à l'équipe par le biais d'une boite email. Cette fonctionnalité est géré par les fichiers question.html et question.js.