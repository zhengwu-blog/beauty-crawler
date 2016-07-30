require 'nn'
require 'image'

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
	trainset.labels[j] = 0
end

for m = 1,618 do
	testset.data[m] = image.load('/Users/Dandy/beauty-crawler/dataset/testset/beauty/'..m..'.png',3,'double')
	testset.labels[m] = 1
end

for n = 619,1185 do
	testset.data[n] = image.load('/Users/Dandy/beauty-crawler/dataset/testset/ugly/'.. n-618 ..'.png',3,'double')
	testset.labels[n] = 0
end

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

net:add(nn.Linear(24,2))
net:add(nn.Tanh())

--define loss function
criterion = nn.MSECriterion()

for i = 1,train_size do
	local input = trainset.data[i]
	local output = net:forward(input)
	net:zeroGradParameters()
	criterion:forward(output,trainset.labels[i])
	gradients = criterion:backward(output,trainset.labels[i])
	net:backward(input, gradients)
	net:updateParameters(0.001)
end

--test the net and print accuracy
for i=1,3 do
	testset.data[{ {}, {i}, {}, {} }]:add(-mean[i])
	testset.data[{ {}, {i}, {}, {} }]:div(stdv[i])
end

correct = 0
for i = 1,test_size do
	local prediction = net:forward(testset.data[i])
	local groundtruth = testset.labels[i]
	if groundtruth==1 and prediction>0.5 or groundtruth==0 and prediction<0.5 then 
		correct = correct+1
	end
end

print ('accuracy: ' .. 100*correct/10000 .. ' % ')

