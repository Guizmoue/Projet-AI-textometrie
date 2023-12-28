# - * - coding: utf - 8 -*-
"""
create wordcloud with chinese
=============================

Wordcloud is a very good tool, but if you want to create
Chinese wordcloud only wordcloud is not enough. The file
shows how to use wordcloud with Chinese. First, you need a
Chinese word segmentation library jieba, jieba is now the
most elegant the most popular Chinese word segmentation tool in python.
You can use 'PIP install jieba'. To install it. As you can see,
at the same time using wordcloud with jieba very convenient
"""

"""
fais les commandes d'abords : 
pip install jieba wordcloud imageio matplotlib
"""

import jieba
# jieba.enable_parallel(4)
# Setting up parallel processes :4 ,but unable to run on Windows
from os import path
from imageio import imread
import matplotlib.pyplot as plt
import os
# jieba.load_userdict("txt\userdict.txt")
# add userdict by load_userdict()
from wordcloud import WordCloud, ImageColorGenerator

# get data directory (using getcwd() is needed to support running example in generated IPython notebook)
d = path.dirname(__file__) if "__file__" in locals() else os.getcwd()

stopwords_path = d + '/itrameur/stopwords-zh.txt' # le chemin stopwords
# Chinese fonts must be set
font_path = d + '/itrameur/SourceHanSerifSC-Regular.otf' # le chemin de la police

# the path to save worldcloud
"""tu peux remplacer ça par un masque. Le masque principal en noir et blanc (tons de gris). 
Ce masque détermine la forme générale du nuage de mots."""
imgname1 = d + '/itrameur/fond_cn.jpg' 
# ça normalement c'est le chemin de sortie
imgname2 = d + '/itrameur/fond_cn_colored.jpg'
# read the mask / color image taken from
back_coloring = imread(path.join(d, d + '/itrameur/fond_cn_couleur.jpg')) # C'est le chemin vers le masque en couleur. Ce masque est utilisé pour la coloration du nuage de mots.

# Read the whole text.
text = open(path.join(d, d + '/itrameur/source_nuage_cn.txt')).read() # le chemin d'input

# if you want use wordCloud,you need it
# add userdict by add_word()
userdict_list = ['阿Ｑ', '孔乙己', '单四嫂子']


# The function for processing text with Jieba
def jieba_processing_txt(text):
    for word in userdict_list:
        jieba.add_word(word)

    mywordlist = []
    seg_list = jieba.cut(text, cut_all=False)
    liststr = "/ ".join(seg_list)

    with open(stopwords_path, encoding='utf-8') as f_stop:
        f_stop_text = f_stop.read()
        f_stop_seg_list = f_stop_text.splitlines()

    for myword in liststr.split('/'):
        if not (myword.strip() in f_stop_seg_list) and len(myword.strip()) > 1:
            mywordlist.append(myword)
    return ' '.join(mywordlist)


wc = WordCloud(font_path=font_path, background_color="white", max_words=2000, mask=back_coloring,
               max_font_size=100, random_state=42, width=1000, height=860, margin=2,)


wc.generate(jieba_processing_txt(text))

# create coloring from image
image_colors_default = ImageColorGenerator(back_coloring)

plt.figure()
# recolor wordcloud and show
plt.imshow(wc, interpolation="bilinear")
plt.axis("off")
plt.show()

# save wordcloud
wc.to_file(path.join(d, imgname1))

# create coloring from image
image_colors_byImg = ImageColorGenerator(back_coloring)

# show
# we could also give color_func=image_colors directly in the constructor
plt.imshow(wc.recolor(color_func=image_colors_byImg), interpolation="bilinear")
plt.axis("off")
plt.figure()
plt.imshow(back_coloring, interpolation="bilinear")
plt.axis("off")
plt.show()

# save wordcloud
wc.to_file(path.join(d, imgname2))
