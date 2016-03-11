function [ output_args ] = LPQ( image )
%LPQ Summary of this function goes here
%   Detailed explanation goes here

    % Convert imput images to gray-scale and cast to a double
    image = rgb2gray(image);
    image = double(image);

    % The convolution window will encompass a 7x7 neighbourhood, i.e.
    window_radius = 3;
    % window defined in 1D. Convolution is separable.
    x = -window_radius: window_radius;
    % width of the window
    n = 2*window_radius + 1;
    
    % As defined in the paper, the value of a = (diameter-1)/2
    a = 1/window_radius;

%     u1 = [a 0]';
%     u2 = [0 a]';
%     u3 = [a a]';
%     u4 = [a -a]';
    
    % u component = 0, phi becomes one because u1'*x = 0 thus e^0 = 1
    w0 = a*x*0+1;
    
    % u component = a
    w1 = exp(-1i*2*pi*a*x/n);
    
    % u component = -a. the conjugate of w1
    w2 = exp(1i*2*pi*a*x/n);

    
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
    
    Fc = [O1re O1im O2re O2im O3re O3im O4re O4im];
    
    rho = 0.95;
    [X Y] = meshgrid(1:n^2,1:n^2);
    pow = abs(X-Y);
    C = rho.^pow;
    
    wu1 = w0.' * w1;
    wu2 = w1.' * w0;
    wu3 = w1.' * w1;
    wu4 = w2.' * w1;
    
    wu1re = real(wu1);
    wu1im = imag(wu1);
    wu2re = real(wu2);
    wu2im = imag(wu2);
    wu3re = real(wu3);
    wu3im = imag(wu3);
    wu4re = real(wu4);
    wu4im = imag(wu4);
    
    W = [wu1re(:) wu1im(:) wu2re(:) wu2im(:) wu3re(:) wu3im(:) wu4re(:) wu4im(:)];
    
    D = W.'*C*W;
    
    [~,~,V] = svd(D);
    
    Gx = V.' * Fc.';
    H = bi2de(Gx' >= 0);
    histogram(H,256,'Normalization', 'probability');
    output_args = H;

end

