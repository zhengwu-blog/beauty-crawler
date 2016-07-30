#! usr/bin/python
__author__='Zheng Wu'

import re
import urllib2
from PIL import Image

num=1

for i in xrange(1,51):
	url='https://tuchong.com/tags/%E7%BE%8E%E5%A5%B3/?type=new&page='+str(i)
	html=urllib2.urlopen(url).read() 
	#print html
	regx='<img src="(.*?)" alt=""/>'
	pattern=re.compile(regx)
	links=re.findall(pattern,html)

	for link in links:
		print link
		#link=link.replace('\\','')
		data=urllib2.urlopen(link).read()
		pic = open('/Users/Dandy/beauty-crawler/dataset/beauty/'+str(num)+'.jpg','wb')
		pic.write(data)
		pic.close()
		img=Image.open('/Users/Dandy/beauty-crawler/dataset/beauty/'+str(num)+'.jpg')
		img=img.resize((400,400))
		img.save('/Users/Dandy/beauty-crawler/dataset/beauty/'+str(num)+'.jpg')
		num+=1