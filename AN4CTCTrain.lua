--[[Trains the CTC model using the AN4 audio database. Training time as of now takes less than 40 minutes on a GTX 970.]]

local AudioData = require 'AudioData'
local Network = require 'Network'
local Batcher = require 'Batcher'

--Training parameters
local epochs = 70
local numberOfValidationSamples = 20
torch.setdefaulttensortype('torch.FloatTensor')

local networkParams = {
    loadModel = false,
    saveModel = true,
    fileName = "CTCNetwork.t7",
    modelName = 'DeepSpeechModel',
    backend = 'cudnn',
    nGPU = 2, -- Set -1 to use CPU
    lmdb_path = '/data1/yuanyang/torch_projects/data/an4_lmdb/',-- online loading path
    batch_size = 50
}
--Parameters for the stochastic gradient descent (using the optim library).
local sgdParams = {
    learningRate = 1e-4,
    learningRateDecay = 1e-9,
    weightDecay = 0,
    momentum = 0.9,
    dampening = 0,
    nesterov = true
}

--Window size and stride for the spectrogram transformation.
local windowSize = 256
local stride = 75

--The larger this value, the larger the batches, however the more padding is added to make variable sentences the same.
local maximumSizeDifference = 0 -- Setting this to zero makes it batch together the same length sentences.

--Create and train the network based on the parameters and training data.
Network:init(networkParams)

-- Network:trainNetwork(trainingDataSet, nil, epochs, sgdParams)
-- lets test jit loading 
Network:trainNetwork(epochs, sgdParams)

--Creates the loss plot.
Network:createLossGraph()

print("finished")
