#! usr/bin/python

import random
from PIL import Image
import os

rootpath='/Users/Dandy/beauty-crawler/dataset/'

beauty_test=618
beauty_train=6181-618
ugly_test=567
ugly_train=5669-567

beauty_test_list=random.sample(xrange(1,6182),beauty_test)
print len(beauty_test_list)
ugly_test_list=random.sample(xrange(1,5669),ugly_test)
print len(ugly_test_list)

re_beauty_path=rootpath+'beauty/'
re_ugly_path=rootpath+'ugly/'

train_beauty_num=1
train_ugly_num=1
test_beauty_num=1
test_ugly_num=1

for i in xrange(1,6182):

	if os.path.isfile(re_beauty_path+str(i)+'.jpg'):
		img=Image.open(re_beauty_path+str(i)+'.jpg')
		img=img.resize((200,200))
	else:
		img=Image.open(re_beauty_path+str(i)+'.png')
		img=img.resize((200,200))

	if i in beauty_test_list:
		img.save(rootpath+'testset/beauty/'+str(test_beauty_num)+'.png')
		test_beauty_num+=1
	else:
		img.save(rootpath+'trainset/beauty/'+str(train_beauty_num)+'.png')
		train_beauty_num+=1

for j in xrange(1,5670):

	img=Image.open(re_ugly_path+str(j)+'.png')
	img=img.resize((200,200))

	if j in ugly_test_list:
		img.save(rootpath+'testset/ugly/'+str(test_ugly_num)+'.png')
		test_ugly_num+=1
	else:
		img.save(rootpath+'trainset/ugly/'+str(train_ugly_num)+'.png')
		train_ugly_num+=1

	