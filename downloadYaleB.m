clear;
clc;

% Websave has no visualize tools, 
% so please check finish messages.

disp("Cropped Yale B loading...")
url2 = 'http://vision.ucsd.edu/extyaleb/CroppedYaleBZip/CroppedYale.zip';
websave('CroppedYaleB.zip', url2)
disp("Cropped Yale B downloaded")

% Big database: ~2GB

% disp("Extended Yale B loading...")
% url ='http://vision.ucsd.edu/~leekc/ExtYaleDatabase/download.html';
% websave('ExtendedYaleB.zip', url)
% disp("Extended Yale B downloaded")

