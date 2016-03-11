function [ H ] = LPQ( image )
%LPQ Performs Local Phase Quantization on the input image using a 7x7 mask
%
%   This is an implementation based on:
%   Ojansivu, Ville, and Janne Heikkilä. "Blur insensitive texture 
%   classification using local phase quantization." Image and signal 
%   processing. Springer Berlin Heidelberg, 2008. 236-243.
%
%   de Almeida, Paulo RL, et al. "PKLot?A robust dataset for parking lot 
%   classification." Expert Systems with Applications 42.11 (2015): 4937-4949.

    % Convert imput images to gray-scale and cast to a double
    image = rgb2gray(image);
    image = double(image);

    % The convolution window will encompass a 7x7 neighbourhood, i.e.
    window_radius = 3;
    % window defined in 1D because the convolution will be separable.
    x = -window_radius: window_radius;
    % length of the window
    n = length(x);
    
    %% Construction of basis vector components for STFT
    % As defined in the de Almeida paper, the value of a = (diameter-1)/2
    a = 1/window_radius;

	% Complex coefficients considered: u = [a 0] [0 a] [a a] [a -a]
    % The basis vectors are defined by: exp( -1i*2*pi*u*X/n^2 ) for all X in
    % the window. This is separated into components (basis vectors): 
    %           (w1 x w0) (w0 x w1) (w1 x w1) (w1 x w2)
    
    % u component = 0, phi becomes one because u1'*x = 0 thus e^0 = 1
    w0 = a*x*0+1;
    % u component = a
    w1 = exp(-1i*2*pi*a*x/n);
    % u component = -a
    w2 = exp(1i*2*pi*a*x/n);

    %% Apply STFT
    % Applied by column then row using the components of the basis vectors 
    % .' preserves complex numbers on transposition
    O1 = conv2(conv2(image, w0.', 'same'), w1, 'same');
    O2 = conv2(conv2(image, w1.', 'same'), w0, 'same');
    O3 = conv2(conv2(image, w1.', 'same'), w1, 'same');
    O4 = conv2(conv2(image, w2.', 'same'), w1, 'same');

    O1re = real(O1(:));
    O1im = imag(O1(:));
    O2re = real(O2(:));
    O2im = imag(O2(:));
    O3re = real(O3(:));
    O3im = imag(O3(:));
    O4re = real(O4(:));
    O4im = imag(O4(:));
    
    % Fx is the feature vector but the values are correlated
    Fx = [O1re O2re O3re O4re O1im O2im O3im O4im];
    
    %% Construction of Whitening Matrix to de-correlate data
    sig = 0.9;
    [X, Y] = meshgrid(1:n^2,1:n^2);
    pow = abs(X-Y);
    % covariance matrix
    C = sig.^pow;
    
    % explicit calculation of basis vectors
    wu1 = w0.' * w1;
    wu2 = w1.' * w0;
    wu3 = w1.' * w1;
    wu4 = w2.' * w1;
    
    % separation into real and imaginary compnents
    wu1re = real(wu1);
    wu1im = imag(wu1);
    wu2re = real(wu2);
    wu2im = imag(wu2);
    wu3re = real(wu3);
    wu3im = imag(wu3);
    wu4re = real(wu4);
    wu4im = imag(wu4);
    
    W = [wu1re(:) wu2re(:) wu3re(:) wu4re(:) wu1im(:) wu2im(:) wu3im(:) wu4im(:)];
    D = W.'*C*W;
    [~,~,V] = svd(D);
    % Apply whitening transformation to obtain de-correlated feature vector
    Gx = V.' * Fx.';
    
    %% Convert feature vectors to decimal numbers
    H = bi2de(Gx' >= 0);
end

