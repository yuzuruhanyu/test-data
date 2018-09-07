%function J=Attack(path, method, stren)
clc
clear

filenum=3000;

src_folder='original_dir';   % 3000 original images 
root_folder='distorted_dir';    % distorted images

tot=0;

for method=0:8
       
    switch method
        case 0 % JPEG Compression
            stren=[1,5,10:20:90,95];
            dist='JPEG';
        case 1 % Gaussian Noise
            stren=[0.01:0.01:0.05 0.1 0.15  0.2 0.25];
            dist='Gaussian_Noise';
        case 2 % Rotation+Cropping
            stren=[1:4,6:2:10];
            dist='rotation+cropping';
        case 3 % Median Filtering
            stren=2:2:20;
            dist='Median_Filtering';
        case 4 % Histogram Equalization
            stren=[8, 16, 32:32:224];
            dist='Histogram_Equalization';
        case 5 % Gamma Correction
            stren=[0.55:0.1:0.95, 1.05:0.1:1.45];
            dist='GAMMA';
        case 6 % Speckle Noise
            stren=[0.01 0.05 0.1:0.1:0.3];
            dist='Speckle_Noise';
        case 7 % Circular Averaging Filtering
           stren=[1 5 10:5:40];
           dist='CIRFLT';   
        case 8 % Scaling
           stren=[0.2 0.4 0.5 2 4];
           dist='SCALE';
    end
    
    dis_img_num=size(stren,2);
    
    for n=1:filenum
        
        dist_folder=fullfile(root_folder, dist, num2str(n));
        mkdir(dist_folder);
        
        disp(sprintf('%s-%d',dist, n));
        
        filename=[num2str(n),'.bmp'];
        path=fullfile(src_folder, filename);
        
        I = imread(path);
        
        switch method % Attacks
            case 0 % JPEG Compression
                jpg_cache=fullfile(root_folder,'cache.jpg');
                for k=1:dis_img_num % for each strength
                    imwrite(I, jpg_cache, 'Quality', stren(k));
                    J = imread(jpg_cache);
                    dest_path=fullfile(dist_folder, [num2str(k),'.bmp']);
                    imwrite(J,dest_path,'bmp');
                end
                
            case 1 % Gaussian Noise
                for k=1:dis_img_num
                    J = imnoise(I,'gaussian', 0,stren(k));
                    dest_path=fullfile(dist_folder, [num2str(k),'.bmp']);
                    imwrite(J,dest_path,'bmp');
                end
                
            case 2 % Rotation+Cropping
                for k=1:dis_img_num
                    J = imrotate(I, stren(k), 'bilinear','crop');
                    dest_path=fullfile(dist_folder, [num2str(k),'.bmp']);
                    imwrite(J,dest_path,'bmp');
                end
                
            case 3 % Median Filtering
                for k=1:dis_img_num
                    J = medfilt2(I, [stren(k) stren(k)]);
                    dest_path=fullfile(dist_folder, [num2str(k),'.bmp']);
                    imwrite(J,dest_path,'bmp');
                end
                
            case 4 % Histogram Equalization
                for k=1:dis_img_num
                    J = histeq(I, stren(k));
                    dest_path=fullfile(dist_folder, [num2str(k),'.bmp']);
                    imwrite(J,dest_path,'bmp');
                end
                
            case 5 % Gamma Correction
                for k=1:dis_img_num
                    J=imadjust(I,[],[],stren(k));
                    dest_path=fullfile(dist_folder, [num2str(k),'.bmp']);
                    imwrite(J,dest_path,'bmp');
                end
                
            case 6 % Speckle Noise
                for k=1:dis_img_num
                    J=imnoise(I,'speckle',stren(k));
                    dest_path=fullfile(dist_folder, [num2str(k),'.bmp']);
                    imwrite(J,dest_path,'bmp');
                end
                
             case 7 % Circular Averaging Filtering
                for k=1:dis_img_num
                    J=imfilter(I,fspecial('disk',stren(k)));
                    dest_path=fullfile(dist_folder, [num2str(k),'.bmp']);
                    imwrite(J,dest_path,'bmp');
                end
                
            case 8 % Scaling
                for k=1:dis_img_num
                    J=imresize(I,stren(k));
                    dest_path=fullfile(dist_folder, [num2str(k),'.bmp']);
                    imwrite(J,dest_path,'bmp');
                end
        end
        
    end
end
