'''
Ce programme permet d'ouvrir un fichier texte et de remplacer "intelligence artificielle" par "intelligenceartificielle"
'''

def replaceAI(source, destination) : 
    with open(source, 'r') as s : 
        content = s.read()
    #modified_content = content.replace(r'\b(A|a)rtificial\s(I/i)ntelligence\b', "artificialintelligence")
    content_min = content.lower()
    modified_content = content_min.replace('intelligence artificielle', 'intelligenceartificielle')
    with open(destination, 'w') as d : 
        d.write(modified_content)
        
def main():
    replaceAI("../itrameur/Contextes-fr.txt", "../itrameur/ContextesNettoyes-fr.txt")

if __name__ == "__main__":
    main()
