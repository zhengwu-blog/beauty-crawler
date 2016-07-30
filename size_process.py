#! usr/bin/python

import random
from PIL import Image
#import os

rootpath='/Users/Dandy/beauty-crawler/dataset/'

beauty_test=618
beauty_train=6181-618
ugly_test=567
ugly_train=5669-567

for i in xrange(1,619):
	img=Image.open('/Users/Dandy/beauty-crawler/dataset/testset/beauty/'+str(i)+'.png')
	img=img.resize((60,60))
	img.save('/Users/Dandy/beauty-crawler/dataset/testset/beauty/'+str(i)+'.png')

for i in xrange(1,568):
	img=Image.open('/Users/Dandy/beauty-crawler/dataset/testset/ugly/'+str(i)+'.png')
	img=img.resize((60,60))
	img.save('/Users/Dandy/beauty-crawler/dataset/testset/ugly/'+str(i)+'.png')

for i in xrange(1,5564):
	img=Image.open('/Users/Dandy/beauty-crawler/dataset/trainset/beauty/'+str(i)+'.png')
	img=img.resize((60,60))
	img.save('/Users/Dandy/beauty-crawler/dataset/trainset/beauty/'+str(i)+'.png')

for i in xrange(1,5103):
	img=Image.open('/Users/Dandy/beauty-crawler/dataset/trainset/ugly/'+str(i)+'.png')
	img=img.resize((60,60))
	img.save('/Users/Dandy/beauty-crawler/dataset/trainset/ugly/'+str(i)+'.png')
