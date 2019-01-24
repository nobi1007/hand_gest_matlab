clc
%% Please specify your ip address
% Download the droidCam app
% then connect your mpbile and lappy over same wifi

cam=ipcam('http://192.168.43.147:4747/video/mjpegfeed?480x480');      %%here ip address depends on the device connected
preview(cam)

%% If want to run this code properly then first
% create a folder training in that create 28 subfolders each labeled as (all capital)'A'..to..'Z' and 'SPACE' AND 'STOP'
% refer to line 32, it will make sense.

pause   %% start the shoot when your ready
for p=1:28
    for z=1:300
        img=snapshot(cam);
        I2=rgb2ycbcr(img);
        S=size(img);
        Cb=I2(:,:,2);
        Cr=I2(:,:,3);
        Y2=zeros(S(1),S(2));
        I3=cat(3,Y2,Cb,Cr);
        I4=I3;
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
        I5=imresize(rgb2gray(I4),[28 28]);
        if(p<=26)
            fileName=strcat('F:\DATA\training\',char(64+p),'\',int2str(z),'.jpeg');
        end
        if(p==27)
            fileName=strcat('F:\DATA\training\SPACE\',int2str(z),'.jpeg');
        end
        if(p==28)
            fileName=strcat('F:\DATA\training\STOP\',int2str(z),'.jpeg');
        end
        imwrite(I5,fileName);
        
    end
    pause       %% take the snaps of each letter 300 times on your demand/ when you are ready
end

closePreview
clear cam