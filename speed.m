clc; 
close all;
inputvideo=vision.VideoFileReader('traffic.mj2'); 
vid1=vision.VideoPlayer; 
while~isDone(inputvideo) 
    frame1=step(inputvideo);
    step(vid1,frame1); 
    pause(0.005);
end
imwrite(frame1,'D:\referenceimage.jpg','jpg');
release(inputvideo); 
release(vid1);
referenceimage=imread('D:\referenceimage.jpg'); 
vid2=vision.VideoFileReader('Traffic.mj2');
X=zeros(2,121);
Y=zeros(2,121);
Z=zeros; 
for i=2:121 
    clc; 
    frame=step(vid2); 
    frame2=((im2double(frame))-(im2double(referenceimage)));
    frame1=imbinarize(frame2,0.1); 
    [Labelimage]=bwlabeln(frame1); 
    stats=regionprops(Labelimage,'basic');
    
    BB=stats.BoundingBox;
    X(i)=BB(1);
    Y(i)=BB(2);
    Dist=((X(i)-X(i-1))^2+(Y(i)-Y(i-1))^2)^(1/2);
    Z(i)=Dist;
    M=median(Z);
    disp('speed=')
    Speed=((M)*(120/8))/(4);
     disp(Speed);
    
    if(Speed>50&&Speed<100) 
        disp('MEDIUM SPEED');
    elseif(Speed<50) 
        disp('SLOW SPEED'); 
    else
        disp('FAST SPEED'); 
    end
    SE = strel('disk',6); 
    frame3=imclose(frame1,SE); 
    step(vid1,frame1); 
    pause(0.05); 
end

release(vid1);