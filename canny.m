% NAME: M.Hitesh
% ROLL NO: 15EE01033
% INST: IIT BBSR
% CATEGORY: B.TECH
% BRANCH: ELECTRICAL
% Image and Video Tutorial 05
% Canny edge detection

clc;clear all;close all;
I=imread('building.tif');
figure;
subplot(3,3,1);imshow(I);
title('original');
Idouble=im2double(I);

Idouble= imgaussfilt(Idouble,1);
subplot(3,3,2);imshow(Idouble);
title('gaussian smoothing')
 
            % Sobel edge detection
Mx1=[-1 0 1 ; -2 0 2 ; -1 0 1];
My1=[-1 -2 -1; 0 0 0 ; 1 2 1];
Mx=conv2(Idouble,Mx1);
My=conv2(Idouble,My1);
M1=sqrt((Mx.^2)+(My.^2));
subplot(3,3,3);
imshow(Mx);
title('sobel along x');
subplot(3,3,4);
imshow(My);
title('sobel along y');
subplot(3,3,5);
imshow(M1);
title('sobel');

[u,v]=size(Mx);
for i = 1: u
    for j= 1: v
        theta(i,j)=atand(My(i,j)/Mx(i,j));
        theta(i,j)=theta(i,j)+90;
        if theta(i,j)>22.5 && theta(i,j)<67.5
            theta1(i,j)=1;
        elseif theta(i,j)>67.5 && theta(i,j)<112.5
            theta1(i,j)=2;
        elseif theta(i,j)>112.5 && theta(i,j)<157.5
            theta1(i,j)=3;
        elseif theta(i,j)>157.5 && theta(i,j)<=180 || theta(i,j)>=0 && theta(i,j)<22.5
            theta1(i,j)=4;
        end       
    end
end

            % nonmaximum supression 
supression= zeros(u,v);Thigh=0.211;Tlow=0.127;
for i=2 :u-1
    for j=2:v-1
        if M1(i,j)>Thigh
            if theta1(i,j)==1  % diagonal 2 
                if M1(i,j)>M1(i-1,j+1) && M1(i,j) >M1(i+1,j-1)
                   supression(i,j)=1;
                end
            elseif theta1(i,j)==2 % top to bottom 
                if M1(i,j)>M1(i,j-1) && M1(i,j) >M1(i,j+1)
                   supression(i,j)=1;
                end
            elseif theta1(i,j)==3 % diagonal 1
                if M1(i,j)>M1(i-1,j-1) && M1(i,j) >M1(i+1,j+1)
                   supression(i,j)=1;
                end
            elseif theta1(i,j)==4 % left to right 
                if M1(i,j)>M1(i-1,j) && M1(i,j) >M1(i+1,j)
                   supression(i,j)=1;
                end
            end
        end
    end
end
subplot(3,3,6);
imshow(supression);
title('non maximum supression');

            % thresholding with hysterisis 
for i = 2: u-1
    for j = 2 : v-1 
        if supression(i,j)==1            
             if theta1(i,j)==1
                for k=1 :u
                    if theta1(i-k,j+k)==theta1(i,j)  &&  (i-k)>1 && (j+k) >1 && M1(i-k,j+k)>Tlow
                        supression(i,j)=1;                        
                    else
                        break
                    end
                end
                for k=1 :u
                    if theta1(i+k,j-k)==theta1(i,j)  &&  (i+k)<u && (j-k) <v && M1(i+k,j-k)>Tlow
                        supression(i,j)=1;                       
                    else
                        break
                    end
                end              
             end
            
             if theta1(i,j)==2
                for k=1 :u
                    if theta1(i,j-k)==theta1(i,j)  &&  (i)>1 && (j-k) >1 && M1(i,j-k)>Tlow
                        supression(i,j)=1;                        
                    else
                        break
                    end
                end
                for k=1 :u
                    if theta1(i,j+k)==theta1(i,j)  &&  (i)<u && (j+k) <v && M1(i,j+k)>Tlow
                        supression(i,j)=1;                        
                    else
                        break
                    end
                end               
             end
                     
             if theta1(i,j)==3
                for k=1 :u
                    if theta1(i-k,j-k)==theta1(i,j)  &&  (i-k)>1 && (j-k)>1 && M1(i-k,j-k)>Tlow
                        supression(i,j)=1;                        
                    else
                        break
                    end
                end
                for k=1 :u
                    if theta1(i+k,j+k)==theta1(i,j)  &&  (i+k)<u && (j+k)<v && M1(i+k,j+k)>Tlow
                        supression(i,j)=1;                        
                    else
                        break
                    end
                end
              end
             
              if theta1(i,j)==4
                for k=1 :u
                    if theta1(i-k,j)==theta1(i,j)  &&  (i-k)>1 && (j) >1 && M1(i-k,j)>Tlow
                        supression(i,j)=1;                       
                    else
                        break
                    end
                end
                for k=1 :u
                    if theta1(i+k,j)==theta1(i,j)  &&  (i+k)<u && (j) <v && M1(i+k,j)>Tlow
                        supression(i,j)=1;                        
                    else
                        break
                    end
                end                
              end       
        end
    end
end

subplot(3,3,7);
imshow(supression);
title('hysterisis thresholding');
