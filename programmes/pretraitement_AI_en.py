'''
Ce programme permet d'ouvrir un fichier texte et de remplacer toutes les occurrences de "artificial intelligence" par "artificialintelligence"
'''

def replaceAI(source, destination) : 
    '''Cette fonction permet de remplacer les différentes variantes de "artificial intelligence" par "artificialintelligence"'''
    with open(source) as s : 
        content = s.read()
    #modified_content = content.replace(r'\b(A|a)rtificial\s(I/i)ntelligence\b', "artificialintelligence")
    content_min = content.lower()
    modified_content = content_min.replace('artificial intelligence', 'artificialintelligence')
    with open(destination, 'w') as d : 
        d.write(modified_content)
        
def main():
    replaceAI("Contextes-en.txt", "ContextesNettoyes-en.txt")

if __name__ == "__main__":
    main()
