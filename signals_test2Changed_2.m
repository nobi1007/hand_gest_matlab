clc
close all

result=string;

stopVar=imread('F:\DATA_SET_SAP_1\stop.jpg');
spaceVar=imread('F:\DATA_SET_SAP_1\space.jpg');
array=cell(1,26);
resizedArray=cell(1,26);
for t=1:26 
    array{t}=imread(strcat('F:\DATA_SET_SAP_1\',char(96+t),'.jpg'));
    resizedArray{t}=imresize(rgb2gray(array{t}),[300 300]);
end
resizedStopVar=imresize(rgb2gray(stopVar),[300 300]);
resizedSpaceVar=imresize(rgb2gray(spaceVar),[300 300]);


cam=ipcam('http://192.168.137.14:4747/video/mjpegfeed?480x480');      %%here ip address depends on the device connected
preview(cam)

show='Get ready to show the gesture after 3 seconds.';
% array=cell(20,9);                        %%arbitrary size
instArray=cell(1,9);
hFinal=cell(30,1);

simiArray=cell(28,2);                      %% Array containg all the correlations

resized_hFinal=cell(30,1);
holdArray=cell(30,1);
k=1;                                     %%this is counter for the position of image to be stored in array

index=1;
similarity=0;

z=0;
for d=1:10000000
    p=1;
end
      pause  
% b=input('enter s: ');                       
% if(b=='s')
while(z<3)
    similarity=0;                       %% to be initialized for every iteration
    fprintf("%s",show);
 
    for x=1:1000000
    end
    
    figure
    for i=1:9
        
        for j=1:1000000
            tic;
        end
        toc;
        img = snapshot(cam);
%         array{k}=img;
        instArray{i}=img;
        subplot(3,3,i)
        image(img)
        %closePreview(cam)
    end
    holdArray{k}=instArray{5};
    
    I=holdArray{k};
     
%     subplot(1,nog,x)
%     imshow(I)
    
    I2=rgb2ycbcr(I);
    S=size(I);
    I4=I2;
    for i=1:S(1)
        for j=1:S(2)
            if(I4(i,j,2)>=77&&I4(i,j,2)<=127&&I4(i,j,3)>=133&&I4(i,j,3)<=173)
                I4(i,j,2)=255;
                I4(i,j,3)=255;
                I4(i,j,1)=255;
            else
                I4(i,j,2)=0;
                I4(i,j,1)=0;
                I4(i,j,3)=0;
            end
        end
    end
    hFinal{k}=rgb2gray(I4);
    resized_hFinal{k}=imresize(hFinal{k},[300 300]);
    figure
    imshow(resized_hFinal{k})
    hold on
    point1=detectSURFFeatures(resized_hFinal{k});
    plot(point1.selectStrongest(5));
    hold off 
    
    for p=1:26
        simiArray{p,1}=abs(corr2(resized_hFinal{k},resizedArray{p}));
        simiArray{p,2}=char(64+p);
        if(abs(corr2(resized_hFinal{k},resizedArray{p}))>similarity)
            similarity=abs(corr2(resized_hFinal{k},resizedArray{p}));
            index=p;
        end
    end
    
    result(k)=char(96+index);
    
    simiArray{27,1}=abs(corr2(resized_hFinal{k},resizedSpaceVar));
    simiArray{27,2}=' ';
    simiArray{28,1}=abs(corr2(resized_hFinal{k},resizedStopVar));
    simiArray{28,2}='Stop';
    

    if(abs(corr2(resized_hFinal{k},resizedSpaceVar))>similarity)
        similarity=abs(corr2(resized_hFinal{k},resizedSpaceVar));
        result(k)=' ';
    elseif(abs(corr2(resized_hFinal{k},resizedStopVar))>similarity)
        similarity=abs(corr2(resized_hFinal{k},resizedStopVar));
        result(k)='stop';
        break;
    end
    k=k+1;
    z=z+1;
    simiArray=simiArray
end

fprintf('%s',result)
closePreview(cam)
% simiArray=simiArray
clear cam;