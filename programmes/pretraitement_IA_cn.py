'''
Ce programme permet d'ouvrir un fichier texte et de remplacer "intelligence artificielle" par "intelligenceartificielle"
'''

from os import replace


def replaceAI(source, destination) : 
    # lire le fichier de source
    with open(source, 'r', encoding='utf-8') as s : 
        content = s.read()
    # "人工智能" et "人工智慧" sont deux synonymes parfaits
    # coller "人工" et "智能" ou "人工" et "智慧"ensemble
    modified_content = content.replace('人工 智能', '人工智能')
    modified_content = modified_content.replace('人工 智慧', '人工智慧')
    # remplacer tous les "人工智慧" par "人工智能" pour éviter faire deux fois l'analyse textométrique
    modified_content = modified_content.replace('人工智慧', '人工智能')

    # importer les stopwords
    # lire le fichier de stopwords
    with open('./itrameur/stopwords-zh.txt', 'r', encoding='utf-8') as file:
        stopwords = file.read().splitlines()
    # éliminer les stopwords dans le fichier de source
    modified_content = modified_content.split()
    for i in modified_content:
        if i in stopwords:
            modified_content.remove(i)
    modified_content = ' '.join(modified_content)
    # output le fichier nettoyé
    with open(destination, 'w') as d : 
        d.write(modified_content)
        
def main():
    replaceAI("./itrameur/Contextes-cn.txt", "./itrameur/ContextesNettoyes-cn.txt")

if __name__ == "__main__":
    main()
