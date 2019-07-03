function [net,info] = faceCNN()
    global datadir;
    run matlab/vl_setupnn ; %init

    datadir = ' ';
    opts.expDir = fullfile('/Users/shixinyu/Documents/nus/course/PATTERN RECOGNITION/CA2/CA2/CNN/','imdb');
    opts.imdbPath = fullfile(opts.expDir, 'imdb.mat');

    if exist(opts.imdbPath,'file')
        imdb=load(opts.imdbPath);
    else
        imdb.images.data = [];
        imdb.images.labels = [];
        imdb.images.set = [];
        imdb.meta.sets = {'train','val','test'};

        faceCNN = load ('faceCNN.mat');
        imdb.images.data(:,:,:,1:2387) = single(reshape(faceCNN.TrData,32,32,1,2387));
        imdb.images.data(:,:,:,2388:3410) = single(reshape(faceCNN.TeData,32,32,1,1023));
        imdb.images.labels(1:2387) = single(faceCNN.TrLabel);
        imdb.images.labels(2388:3410) = single(faceCNN.TeLabel);
        imdb.images.set(1:2387) = 1;
        imdb.images.set(2388:3410) = 3;

        dataMean = mean(imdb.images.data,4);
        imdb.images.data = single(bsxfun(@minus,imdb.images.data,dataMean));
        imdb.images.data_mean = dataMean;
        mkdir(opts.expDir);
        save(opts.imdbPath,'-struct','imdb');
    end

    net = faceCNN_init();
    net.meta.normalization.averageImage = imdb.images.data_mean;
    opts.train.gpus = [];

    [net,info] = cnn_train(net,imdb,getBatch(opts), ...
        'expDir',opts.expDir, ...
        net.meta.trainOpts, ...
        opts.train, ...
        'val',find(imdb.images.set == 3));

    function fn = getBatch(opts)
        fn = @(x,y) getSimpleNNBatch(x,y);
    end

    function [images, labels] = getSimpleNNBatch(imdb,batch)
        images = imdb.images.data(:,:,:,batch);
        labels = imdb.images.labels(1,batch);
        if opts.train.gpus > 0
            images = gpuArray(images);
        end
    end
end