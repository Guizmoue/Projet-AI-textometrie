from os import path
from wordcloud import WordCloud, STOPWORDS
import matplotlib.pyplot as plt
from PIL import Image
import numpy as np

# Chemin du texte
text_path = '/itrameur/source_nuage_fr.txt'

# Charger le texte
text = open(text_path, encoding='utf-8').read()

# Chemin du fichier de stopwords
stopwords_path = '/itrameur/stopwords-fr.txt'

# Charger les stopwords depuis le fichier
with open(stopwords_path, encoding='utf-8') as f_stop:
    stopwords = set(f_stop.read().splitlines())

# Chemin de l'image de fond
background_image_path = '/itrameur/fond_cn_couleur.jpg'

# Charger l'image de fond
background_image = np.array(Image.open(background_image_path))

# Créer un objet WordCloud
wc = WordCloud(stopwords=stopwords, background_color='white', contour_color='black',
               contour_width=1, mask=background_image, scale=3, width=800, height=600,
               max_font_size=120, random_state=42)

# Générer le nuage de mots
wc.generate(text)

# Recolorer le nuage de mots avec une teinte
teinte_wc = wc.recolor(colormap='viridis', random_state=42)

# Afficher le nuage de mots teinte avec une résolution plus élevée
plt.figure(figsize=(10, 8), dpi=200)
plt.imshow(teinte_wc, interpolation='bilinear')
plt.axis('off')

# Sauvegarder l'image teinte avec l'image de fond
teinte_wc.to_file('/itrameur/wordcloud_teinte.png')