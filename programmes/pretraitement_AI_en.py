'''
Ce programme permet d'ouvrir un fichier texte et de remplacer "artificial intelligence" par "artificialintelligence"
'''

def replaceAI(source, destination) : 
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
