function [numberofTumours maxDiameter position] = Project(imagename)
%imagename = 'mrt1.jpg';

%orgim = imread(imagename);
orgim = imagename;
im = (orgim);
numberofTumours = 55;
maxDiameter = 40;
position = 57 ;


%figure('Name','Original Image');
%imshow(im);

%2 step
im = im2double(im).^3;


%1 step
[rows, columns, numberOfColorChannels] = size(im);
if numberOfColorChannels > 1
    % It's a true color RGB image.  We need to convert to gray scale.
    im = rgb2gray(im);
else
    % It's already gray scale.  No need to convert.
    im = im;
end
%im = rgb2gray(im);



%3 step
im = medianfilter(im);
[row col] = size(im);


figure('Name','Scan after preprocessing');
imshow(im,[]);


%4 step
segmentation = thresholdsegment(uint8(im*255));
% LPF = [1 1 1; 1 1 1; 1 1 1] * (1/9);

ratio = 5.2941e-04 * 2;

[row col channel] = size(orgim);

radius = sqrt(ratio*row*col/pi);

figure('Name','Image After Segmentation')
imshow(segmentation,[]);

% 5 step 
% surette ulken daqty tabady

imBw = im2bw(im);
 imBwLabel = bwlabel(imBw);
 s = regionprops(imBwLabel, 'Area');   
 area = cat(1, s.Area);
 index = find(area == max(area));

 img = ismember(imBwLabel, index);

 props = regionprops(img, 'BoundingBox');
 bbx = vertcat(props.BoundingBox); 
  
  figure('Name','Large spot fence');
  imshow(im);hold on

  rectangle('Position',bbx,'EdgeColor','r', 'linewidth',2);
    
  s = regionprops(imBwLabel, 'Centroid');
 
 centroid = s(index,:);
 idx = centroid.Centroid(1);
 idy = centroid.Centroid(2);    
  % % LGDF 
Img = im;
Img = double(Img(:,:,1));
NumIter = 450;          %iterations
timestep=0.1;           %time step
mu= 2;                      % level set regularization term
sigma = 7;                  %size of kernel
epsilon = 1;
c0 = 2;                     % the constant value 
lambda1=1.03;
lambda2=1.0;
% if lambda1>lambda2; tend to inflate
% if lambda1<lambda2; tend to deflate
nu = 0.001*255*255;     %length term
alf = 20;                       %data term weight

 [Height Wide] = size(Img);
 [xx yy] = meshgrid(1:Wide,1:Height);
  r = bbx(4)/3;
phi = (sqrt(((xx - idx).^2 + (yy - idy).^2 )) - r);
phi = sign(phi).*c0;

BinaryLS = phi;
BinaryLS(BinaryLS>0) = 0;
BinaryLS(BinaryLS<0) = 1;
NHOOD = ones(5,5);

ErodeImg = imerode(BinaryLS,NHOOD);
DilateImg = imdilate(BinaryLS,NHOOD);
Narrowband = DilateImg - ErodeImg;
 
Ksigma=fspecial('gaussian',round(2*sigma)*2 + 1,sigma); %  kernel
ONE=ones(size(Img));
KONE = imfilter(ONE,Ksigma,'replicate');  
KI = imfilter(Img,Ksigma,'replicate');  
KI2 = imfilter(Img.^2,Ksigma,'replicate'); 

 figure,imagesc(im),colormap(gray),axis off;axis equal,
 title('Initial contour');
 hold on,[c,h] = contour(phi,[0 0],'r','linewidth',2); hold off

% % hold on,[cc,hh] = contour(DilateImg,[0 0],'b','linewidth',2); hold off
 pause(0.5)
%%% 
for iter = 1:NumIter    
    [phi] = evolution(Img,phi,epsilon,Ksigma,KONE,KI,KI2,mu,nu,lambda1,lambda2,timestep,alf, Narrowband);
    BinaryLS = phi;
    BinaryLS(BinaryLS>0) = 0;
    BinaryLS(BinaryLS<0) = 1;
    ErodeImg = imerode(BinaryLS,NHOOD);
    DilateImg = imdilate(BinaryLS,NHOOD);
    Narrowband = double(phi.*double(DilateImg-BinaryLS)>0)+double(phi.*double(BinaryLS-ErodeImg)<0);    
    if(mod(iter,450) == 0)
        disp('going save')
        figure,
        imagesc(im),colormap(gray),axis off;axis equal,title('')
        hold on,[c,h] = contour(phi,[0 0],'r','linewidth', 2); hold off       
        % hold on,[cc,hh] = contour(DilateImg,[0 0],'b','linewidth',2); hold off    
         %saveas(gcf,'DetectedTumor.jpg')
         %detectedTumor = imread('DetectedTumor.jpg');
            F = getframe ;
            %save_file_name = strcat('C:\Users\Doszhan\Desktop\For_diploma\programmaV2.0', 'Eye_res_00001.jpg');
            imwrite(F.cdata, 'detected_tumor.jpg');
            
            %figure_size = get(gcf,'position')
            %set(gcf,'PaperPosition',figure_size/100);
            %print(gcf,'-djpeg','-r100',['./save_as_same.jpg']);
            
            close(figure)
    end
end
