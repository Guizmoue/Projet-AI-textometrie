'''
Ce programme permet d'ouvrir un fichier texte et de remplacer "intelligence artificielle" par "intelligenceartificielle"
'''

def replaceAI(source, destination) : 
    with open(source, 'r', encoding='utf-8') as s : 
        content = s.read()
    #modified_content = content.replace(r'\b(A|a)rtificial\s(I/i)ntelligence\b', "artificialintelligence")
    #content_min = content.lower()
    modified_content = content.replace('人工 智能', '人工智能')
    modified_content = modified_content.replace('人工 智慧', '人工智慧')
    modified_content = modified_content.replace('人工智慧', '人工智能')
    with open(destination, 'w') as d : 
        d.write(modified_content)
        
def main():
    replaceAI("./itrameur/Contextes-cn.txt", "./itrameur/ContextesNettoyes-cn.txt")

if __name__ == "__main__":
    main()
