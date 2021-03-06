function [preprocessedImg] = preProcess(rawImg,row,col)
[counts,x] = imhist(rawImg,16);
T = otsuthresh(counts);
BW = imbinarize(rawImg,T);

subplot(2,5,2);imshow(BW)
SE=strel("disk",8,8);
dilatedImg = imdilate(BW,SE);
bw2=bwareafilt(BW,1);

%bw2=bw2&BW;
imageWOartifact = rawImg;
imageWOartifact(~bw2) = 0;
subplot(2,5,3);imshow(imageWOartifact)
leftI=bw2(:,1:col/2);
rightI=bw2(:,col/2+1:col);
leftSum=sum(leftI,"all");
rightSum=sum(rightI,"all");
isLeftOriented=leftSum>=rightSum;
pectorialImg=bw2;
if (isLeftOriented)
    for i=1:row
        for j=1:col
            if (2*j-col-(2-col)/(row-1)*(i-1))<=0
                pectorialImg(i,j)=0;
            end
        end
    end
end   
if (~isLeftOriented)
    for i=1:row
        for j=1:col
            if (2*j-col)*(row-1)-(col)*(i-1)>=0
                pectorialImg(i,j)=0;
            end
        end
    end
end


subplot(2,5,4);imshow(pectorialImg)

sumQ=sum(pectorialImg,"all");
imageWOartifact(~pectorialImg) = 0;
ImgContrast=adapthisteq(imageWOartifact);
NoiselessI = medfilt2(ImgContrast);
subplot(2,5,5);imshow(NoiselessI)
preprocessedImg=NoiselessI;

end