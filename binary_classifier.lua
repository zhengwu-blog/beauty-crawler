require 'nn'
require 'image'
require 'optim'

train_size = 10665 
test_size = 1185

-- load the dataset
trainset = {
	data = torch.Tensor(train_size,3,60,60),
	labels = torch.Tensor(train_size,1),
	size = function() return train_size end
}

testset = {
	data = torch.Tensor(test_size,3,60,60),
	labels = torch.Tensor(test_size,1),
	size = function() return test_size end
}

for i = 1,5563 do
	trainset.data[i] = image.load('/Users/Dandy/beauty-crawler/dataset/trainset/beauty/'..i..'.png',3,'double')
	trainset.labels[i] = 1
end

for j = 5564,10665 do
	trainset.data[j] = image.load('/Users/Dandy/beauty-crawler/dataset/trainset/ugly/'.. j-5563 ..'.png',3,'double')
	trainset.labels[j] = -1
end

for m = 1,618 do
	testset.data[m] = image.load('/Users/Dandy/beauty-crawler/dataset/testset/beauty/'..m..'.png',3,'double')
	testset.labels[m] = 1
end

for n = 619,1185 do
	testset.data[n] = image.load('/Users/Dandy/beauty-crawler/dataset/testset/ugly/'.. n-618 ..'.png',3,'double')
	testset.labels[n] = -1
end

trainset.data = trainset.data:double()

--preprocess the data
mean = {}
stdv = {}
for i = 1,3 do

	mean[i] = trainset.data[{ {}, {i}, {}, {} }]:mean()
	trainset.data[{ {}, {i}, {}, {} }]:add(-mean[i])

	stdv[i] = trainset.data[{ {}, {i}, {}, {} }]:std()
	trainset.data[{ {}, {i}, {}, {} }]:div(stdv[i])
end

--build the model
net = nn.Sequential()

net:add(nn.SpatialConvolution(3,6,11,11))
net:add(nn.ReLU())
net:add(nn.SpatialMaxPooling(2,2,2,2))

net:add(nn.SpatialConvolution(6,16,10,10))
net:add(nn.ReLU())
net:add(nn.SpatialMaxPooling(2,2,2,2))
net:add(nn.View(16*8*8))

net:add(nn.Linear(16*8*8,240))
net:add(nn.ReLU())

net:add(nn.Linear(240,24))
net:add(nn.ReLU())

net:add(nn.Linear(24,1))
net:add(nn.Tanh())


--define loss function
criterion = nn.MSECriterion()

--training

for i = 1,train_size do
	net:zeroGradParameters()
	pred = net:forward(trainset.data[i])
	local gradCriterion = criterion:backward(pred, trainset.labels[i])
	net:backward(trainset.data[i],gradCriterion)
	net:updateParameters(0.01)
end

--test the net and print accuracy
for i=1,3 do
	testset.data[{ {}, {i}, {}, {} }]:add(-mean[i])
	testset.data[{ {}, {i}, {}, {} }]:div(stdv[i])
end

correct = 0
for i = 1,test_size do
	local prediction = net:forward(testset.data[i])
	print (prediction)
	local groundtruth = testset.labels[i]
	--print (groundtruth)
	if groundtruth[1]*prediction[1]>0 then 
		correct = correct+1
	end

end

print (correct)

print ('accuracy: ' .. correct/test_size*100 .. ' % ')

