clc;clear all
randn('state',1); rand('state',1); 


A1=imread('peppers.png');

% A1(:,:,2) = zeros(256)*255;
% A1(:,:,1) = zeros(256)*255;

%A1=reshape(A1,[64,48,64]);
ad = double(A1) / 255;

relerr = 5e-2;
b = 4;
P = 2;
[U, S, V] = t_rSVD_auto(ad, relerr, b, P);
disp(size(S));

fprintf("Compression rate: %f\n", (numel(U)+numel(V) + numel(S)) / (numel(A1)))
Anew  = t_prod(t_prod(U, S), t_trans(V)) * 255;
Anew=reshape(Anew,[256,256,3]);
A1=reshape(A1,[256,256,3]);

subplot(1,2,1)
imshow(A1)
subplot(1,2,2)
imshow(uint8(Anew))
