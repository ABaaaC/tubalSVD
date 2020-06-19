clc;clear all
randn('state',1); rand('state',1); 

true_pwd = pwd;
crpy = 'CroppedYale/';
dir_path = strcat(pwd, '/', crpy, crpy);
cd(dir_path)

% sz1 = 480; sz2 = 640;

tic

dirs = dir;
progressbar('progress')

a = zeros(192, 0, 168);
b = zeros(192, 30, 168);
ii = 1;
for j = 3:size(dirs,1)
    progressbar(j / size(dirs,1))
    
    fold = dirs(j).name;
    cd(strcat(dir_path, fold))
    
    lst = dir('*.pgm');

    for i = 1:min(size(lst,1), 30)
        q1 = getpgmraw(lst(i).name) / 255;  % faster
%         a(:,ii,:) = q1;
%         ii = ii + 1;

        b(:,i,:) = q1;
%         q1 = imread(lst(i).name);         % slower
    end
    a(:,ii:ii+30-1,:) = b;
    ii = ii + 30;
    cd(dir_path)

end
progressbar(1)

toc

cd(true_pwd)


save('yaleB.mat', 'a');
