%Θέμα 1ο :

x1=load('Data_Test_1');
x2=load('Data_Test_2');
x3=load('Data_Test_3');
x4=load('Data_Test_4');
x5=load('Data_Test_5');
x6=load('Data_Test_6');
x7=load('Data_Test_7');
x8=load('Data_Test_8');
z=[x1,x2,x3,x4,x5,x6,x7,x8];
c1=zeros(8,50);
c3=zeros(8,8);
sn=zeros(1,8);
index=zeros(8,4);
flag1=true;
flag2=true;
kexact=zeros(1,8);

%Ερώτημα 1.1

%Plots 10000 first samples.
for i=1:8
   figure(i)
   plot(z(i).data(1:10000))
   xlabel('Samples');
   ylabel('Amplitude');
   sn(i)=median(abs(z(i).data))/0.6745;
end

%Ερώτημα 1.2

%Counter for Spikes with Threshold for values of k that starts from 0.1 to
%5.
for i=1:8
    for k=0.1:0.1:5
            for j=1:1440000
               if(z(i).data(j)>=k*sn(i) && flag1==true)
                  c1(i,int8(k*10))=c1(i,int8(k*10))+1;
                  flag1=false;
               end
               if(z(i).data(j)<k*sn(i))
                   flag1=true;
               end
            end
    end
end

%Plot of Spikes vs values of k .
for i=1:8
    k=0.1:0.1:5;
    figure(i)
    plot(k,c1(i,int8(k*10)))
    ylabel('Spikes');
    xlabel('K');
end


%Ερώτημα 1.3


%Saving the two closest values of k for linear interpolation
for i=1:8
     for j=2:50
        if(flag2==true)
           if (c1(i,j)<=z(i).spikeNum)
               index(i,1)=c1(i,j-1);
               index(i,2)=c1(i,j);
               index(i,3)=k(j-1);
               index(i,4)=k(j);
               flag2=false;
           end
        end
     end
     flag2=true;
end

%Linear Interpolation for the value of k.
%This is the rule for choosing k for every data file.
for i=1:8
    if(index(i,1)==z(i).spikeNum)
        kexact(i)=index(i,3);
    elseif(index(i,2)==z(i).spikeNum)
            kexact(i)=index(i,4);
    else
           kexact(i)=index(i,3)+ ((index(i,1)-z(i).spikeNum)/(index(i,1)-index(i,2)))*(index(i,4)-index(i,3));
    end
end

%Calculating l for every signal seperately .
%While x is k  and y is the number of  spikes , to find λ
% I devide the number of spikes with k that has been chosen beneath for every
% signal.
for i=1:8
    l(i)=int64((z(i).spikeNum/kexact(i)));
end

%
for i=1:8
    for j=1:8
        c3(i,j)=(z(i).spikeNum - kexact(i)*l(j));
    end
end

%We choose  l(4) because for this value there is the min difference between
%spikeNum and spikes our algorithm reads.
%So the rule that we create is that the number of actual spikes is close to the point
% where the line  touches the curve of  spikes, with k running from
%0.1 to 5 ,  l = 1213 : y=l*x , y = spikes and x = k.
lselected=l(4);

%Θέμα 2ο :
        
        
y1=load('Data_Eval_E_1');
y2=load('Data_Eval_E_2');
y3=load('Data_Eval_E_3');
y4=load('Data_Eval_E_4');
d=[y1,y2,y3,y4];
flag3=true;
flag4=true;
sn2=zeros(1,4);
c2=zeros(4,50);
spikeThresholdEst1=zeros(1,3658);
spikeThresholdEst2=zeros(1,3768);
spikeThresholdEst3=zeros(1,3729);
spikeThresholdEst4=zeros(1,3735);
wzspikeTimesEst1=zeros(1,3658);% wz stands for "with zeros."
wzspikeTimesEst2=zeros(1,3768);
wzspikeTimesEst3=zeros(1,3729);
wzspikeTimesEst4=zeros(1,3735);
wzspikesEst1=zeros(3658,40);
wzspikesEst2=zeros(3768,40);
wzspikesEst3=zeros(3729,40);
wzspikesEst4=zeros(3735,40);
max1=zeros(3658,1);
max2=zeros(3768,1);
max3=zeros(3729,1);
max4=zeros(3735,1);
newSpikeTimesEst1=zeros(1,3330);
newSpikeTimesEst2=zeros(1,3455);
newSpikeTimesEst3=zeros(1,3308);
newSpikeTimesEst4=zeros(1,3032);
newspikesEst1=zeros(3330,40);
newspikesEst2=zeros(3455,40);
newspikesEst3=zeros(3308,40);
newspikesEst4=zeros(3032,40);
num1=zeros(1,3330);
num2=zeros(1,3455);
num3=zeros(1,3308);
num4=zeros(1,3032);






% Calculating sn for the new data files.
for i =1:4
    sn2(i)=median(abs(d(i).data))/0.6745;
end

%Counter for Spikes with Threshold for values of k that starts from 0.1 to
%5.

for i=1:4
    for k=0.1:0.1:5
            for j=1:1440000
               if(d(i).data(j)>=k*sn2(i) && flag3==true)
                  c2(i,int8(k*10))=c2(i,int8(k*10))+1;
                  flag3=false;
               end
               if(d(i).data(j)<k*sn2(i))
                   flag3=true;
               end
            end
    end
end

%From the plots and the intersection of the line with the curve we take spikeNum
%and the k’s for the four signals

for i=1:4
    k=0.1:0.1:5;
    figure(i)
    plot(k,c2(i,int8(k*10)))
    ylabel('Spikes');
    xlabel('K');
    hold on
    y=int64(1213*k);
    plot(k,y);
    hold off
end


%Ερώτημα 2.1


%We save  Spikes and  k for every data file in a matrix called spikesandks
%using the rule we created in the previous question.
spikesandks(1,1)=3653;
spikesandks(1,2)=3.01205;
spikesandks(2,1)=3770;
spikesandks(2,2)=3.1085;
spikesandks(3,1)=3730;
spikesandks(3,2)=3.0759;
spikesandks(4,1)=3740;
spikesandks(4,2)=3.0836;


%We locate the moments where the signal gets over the value of Threshold.

counter1=1;
for j=1:1440000
    if((d(1).data(j)>spikesandks(1,2)*sn2(1)) && flag4==true)
        spikeThresholdEst1(counter1)=j;
        counter1=counter1+1;
        flag4=false;
    end
    if(d(1).data(j) < spikesandks(1,2)*sn2(1))
        flag4=true;
    end
end

counter2=1;
for j=1:1440000
    if((d(2).data(j)>spikesandks(2,2)*sn2(2)) && flag5==true)
        spikeThresholdEst2(counter2)=j;
        counter2=counter2+1;
        flag5=false;
    end
    if(d(2).data(j) < spikesandks(2,2)*sn2(2))
        flag5=true;
    end
end

counter3=1;
for j=1:1440000
    if((d(3).data(j)>spikesandks(3,2)*sn2(3)) && flag6==true)
        spikeThresholdEst3(counter3)=j;
        counter3=counter3+1;
        flag6=false;
    end
    if(d(3).data(j) < spikesandks(3,2)*sn2(3))
        flag6=true;
    end
end

counter4=1;
for j=1:1440000
    if((d(4).data(j)>spikesandks(4,2)*sn2(4)) && flag7==true)
        spikeThresholdEst4(counter4)=j;
        counter4=counter4+1;
        flag7=false;
    end
    if(d(4).data(j) < spikesandks(4,2)*sn2(4))
        flag7=true;
    end
end

%Finding extremum for every  Spike and creating of  vectors wzspikeTimesEst
%for every data file.
for i=1:3658
    max1(i)=d(1).data(spikeThresholdEst1(i));
end
for i=1:3658
    for j=1:20
        if(d(1).data(spikeThresholdEst1(i)+j)>= max1(i))
            max1(i)=d(1).data(spikeThresholdEst1(i)+j);
            wzspikeTimesEst1(i)=spikeThresholdEst1(i)+j;
        end
    end
end

for i=1:3768
    max2(i)=d(2).data(spikeThresholdEst2(i));
end
for i=1:3768
    for j=1:20
        if(d(2).data(spikeThresholdEst2(i)+j)>= max2(i))
            max2(i)=d(2).data(spikeThresholdEst2(i)+j);
            wzspikeTimesEst2(i)=spikeThresholdEst2(i)+j;
        end
    end
end


for i=1:3729
    max3(i)=d(3).data(spikeThresholdEst3(i));
end
for i=1:3729
    for j=1:20
        if(d(3).data(spikeThresholdEst3(i)+j)>= max3(i))
            max3(i)=d(3).data(spikeThresholdEst3(i)+j);
            wzspikeTimesEst3(i)=spikeThresholdEst3(i)+j;
        end
    end
end

for i=1:3735
    max4(i)=d(4).data(spikeThresholdEst4(i));
end
for i=1:3735
    for j=1:20
        if(d(4).data(spikeThresholdEst4(i)+j)>= max4(i))
            max4(i)=d(4).data(spikeThresholdEst4(i)+j);
            wzspikeTimesEst4(i)=spikeThresholdEst4(i)+j;
        end
    end
end

%Ερώτημα 2.2


%Isolation and alignment of  spikes for every data file in matrixes called wzspikesEst.
for i=1:3658
    for j=1:20
    if(wzspikeTimesEst1(i)~=0)
        wzspikesEst1(i,j)=d(1).data(wzspikeTimesEst1(i)-20+j);
        wzspikesEst1(i,(20+j))=d(1).data(wzspikeTimesEst1(i)+j);
    end
    end
end

for i=1:3768
    for j=1:20
    if(wzspikeTimesEst2(i)~=0)
        wzspikesEst2(i,j)=d(2).data(wzspikeTimesEst2(i)-20+j);
        wzspikesEst2(i,(20+j))=d(2).data(wzspikeTimesEst2(i)+j);
    end
    end
end

for i=1:3729
    for j=1:20
    if(wzspikeTimesEst3(i)~=0)
        wzspikesEst3(i,j)=d(3).data(wzspikeTimesEst3(i)-20+j);
        wzspikesEst3(i,(20+j))=d(3).data(wzspikeTimesEst3(i)+j);
    end
    end
end
for i=1:3735
    for j=1:20
    if(wzspikeTimesEst4(i)~=0)
        wzspikesEst4(i,j)=d(4).data(wzspikeTimesEst4(i)-20+j);
        wzspikesEst4(i,(20+j))=d(4).data(wzspikeTimesEst4(i)+j);
    end
    end
end

% We remove all the zeros from the matrices above. We dont understant why there are % zeros in this matrix but when we check the values after and before every zero the look % reasonable, so we just decided to remove the zeros.  


temp=nonzeros(wzspikesEst1');
spikesEst1= reshape(temp,40,3583)';
temp=nonzeros(wzspikesEst2');
spikesEst2= reshape(temp,40,3695)';
temp=nonzeros(wzspikesEst3');
spikesEst3= reshape(temp,40,3599)';
temp=nonzeros(wzspikesEst4');
spikesEst4= reshape(temp,40,3327)';
temp=nonzeros(wzspikeTimesEst1');
spikeTimesEst1=reshape(temp,1,3583);
temp=nonzeros(wzspikeTimesEst2');
spikeTimesEst2=reshape(temp,1,3695);
temp=nonzeros(wzspikeTimesEst3');
spikeTimesEst3=reshape(temp,1,3599);
temp=nonzeros(wzspikeTimesEst4');
spikeTimesEst4=reshape(temp,1,3327);

% Plots of all the waveforms of spikes for every data file.


figure(1)
plot(spikesEst1')
grid
xlabel('Samples')
ylabel('Altitude')
figure(2)
plot(spikesEst2')
grid
xlabel('Samples')
ylabel('Altitude')
figure(3)
plot(spikesEst3')
grid
xlabel('Samples')
ylabel('Altitude')
figure(4)
plot(spikesEst4')
grid
xlabel('Samples')
ylabel('Altitude')

%Ερώτημα 2.3 

%Alignment of  actual spikes with the ones we find and counting of spikes
% created by noise and creation of the matrices newspikesEst# and
%newSpikeTimesEst# .Also alignment of the numbers of neurons which commensurate
%with the spikes which we find in the matrix called num# for every data file .




i=1;
j=1;
errcounter1=0;
while(i<=length(spikeTimesEst1))
    if(abs(spikeTimesEst1(i)-d(1).spikeTimes(j))<=40)
        errcounter1=errcounter1+1;
        newSpikeTimesEst1(1,errcounter1)=spikeTimesEst1(i);
        i=i+1;
        j=j+1;
    elseif (spikeTimesEst1(i)<d(1).spikeTimes(j))
       %in this case the value of  spikeTimesEst1 does not match with an
       %actual spike.
        i=i+1;
    else
        j=j+1;
    end
end


for i=1:3330
    for j=1:20
    if(newSpikeTimesEst1(i)~=0)
        newspikesEst1(i,j)=d(1).data(newSpikeTimesEst1(i)-20+j);
        newspikesEst1(i,(20+j))=d(1).data(newSpikeTimesEst1(i)+j);
    end
    end
end


i=1;
j=1;
errcounter2=0;
while(i<=length(spikeTimesEst2))
    if(abs(spikeTimesEst2(i)-d(2).spikeTimes(j))<=40)
        errcounter2=errcounter2+1;
        newSpikeTimesEst2(errcounter2)=spikeTimesEst2(i);
        i=i+1;
        j=j+1;
    elseif (spikeTimesEst2(i)<d(2).spikeTimes(j))
        i=i+1;
    else
        j=j+1;
    end
end


for i=1:3455
    for j=1:20
    if(newSpikeTimesEst2(i)~=0)
        newspikesEst2(i,j)=d(2).data(newSpikeTimesEst2(i)-20+j);
        newspikesEst2(i,(20+j))=d(2).data(newSpikeTimesEst2(i)+j);
    end
    end
end

i=1;
j=1;
errcounter3=0;
while(i<=length(spikeTimesEst3))
    if(abs(spikeTimesEst3(i)-d(3).spikeTimes(j))<=40)
        errcounter3=errcounter3+1;
        newSpikeTimesEst3(errcounter3)=spikeTimesEst3(i);
        i=i+1;
        j=j+1;
    elseif (spikeTimesEst3(i)<d(3).spikeTimes(j))
        i=i+1;
    else
        j=j+1;
    end
end

for i=1:3308
    for j=1:20
    if(newSpikeTimesEst3(i)~=0)
        newspikesEst3(i,j)=d(3).data(newSpikeTimesEst3(i)-20+j);
        newspikesEst3(i,(20+j))=d(3).data(newSpikeTimesEst3(i)+j);
    end
    end
end

i=1;
j=1;
errcounter4=0;
while(i<=length(spikeTimesEst4))
    if(abs(spikeTimesEst4(i)-d(4).spikeTimes(j))<=40)
        errcounter4=errcounter4+1;
        newSpikeTimesEst4(errcounter4)=spikeTimesEst4(i);
        i=i+1;
        j=j+1;
    elseif (spikeTimesEst4(i)<d(4).spikeTimes(j))
        i=i+1;
    else
        j=j+1;
    end
end


for i=1:3032
    for j=1:20
    if(newSpikeTimesEst4(i)~=0)
        newspikesEst4(i,j)=d(4).data(newSpikeTimesEst4(i)-20+j);
        newspikesEst4(i,(20+j))=d(4).data(newSpikeTimesEst4(i)+j);
    end
    end
end


j=1;
i=1;
while(j<=length(d(1).spikeTimes))    
    if(newSpikeTimesEst1(i)-d(1).spikeTimes(j)<=40)
        num1(i)=d(1).spikeClass(j);
        j=j+1;
        i=i+1;
    else
        j=j+1;
    end
end

j=1;
i=1;
while(j<=length(d(2).spikeTimes))    
    if(newSpikeTimesEst2(i)-d(2).spikeTimes(j)<=40)
        num2(i)=d(2).spikeClass(j);
        j=j+1;
        i=i+1;
    else
        j=j+1;
    end
end

j=1;
i=1;
while(j<=length(d(3).spikeTimes))    
    if(newSpikeTimesEst3(i)-d(3).spikeTimes(j)<=40)
        num3(i)=d(3).spikeClass(j);
        j=j+1;
        i=i+1;
    else
        j=j+1;
    end
end

j=1;
i=1;
while(j<=length(d(4).spikeTimes))    
    if(newSpikeTimesEst4(i)-d(4).spikeTimes(j)<=40)
        num4(i)=d(4).spikeClass(j);
        j=j+1;
        i=i+1;
    else
        j=j+1;
    end
end

%Ερώτημα 2.4


%Calculating characteristics for the signals.
%Calculating max amplitude for every  spike for every data file and how many times
% it crosses zero.
maxA1=zeros(3330,1);
zeroc1=zeros(3330,1);
for i=1:3330
    for j=1:39
        if(newspikesEst1(i,j)>=maxA1(i))
            maxA1(i)=newspikesEst1(i,j);
        end
        if(newspikesEst1(i,j)<0 && newspikesEst1(i,j+1)>0)
            zeroc1(i)=zeroc1(i)+1;
        end
    end
end

maxA2=zeros(3455,1);
zeroc2=zeros(3455,1);
for i=1:3455
    for j=1:39
        if(newspikesEst2(i,j)>=maxA2(i))
            maxA2(i)=newspikesEst2(i,j);
        end
        if(newspikesEst2(i,j)<0 && newspikesEst2(i,j+1)>0)
            zeroc2(i)=zeroc2(i)+1;
        end
    end
end

maxA3=zeros(3308,1);
zeroc3=zeros(3308,1);
for i=1:3308
    for j=1:39
        if(newspikesEst3(i,j)>=maxA3(i))
            maxA3(i)=newspikesEst3(i,j);
        end
        if(newspikesEst3(i,j)<0 && newspikesEst3(i,j+1)>0)
            zeroc3(i)=zeroc3(i)+1;
        end
    end
end



maxA4=zeros(3032,1);
zeroc4=zeros(3032,1);
for i=1:3032
    for j=1:39
        if(newspikesEst4(i,j)>=maxA4(i))
            maxA4(i)=newspikesEst4(i,j);
        end
        if(newspikesEst4(i,j)<0 && newspikesEst4(i,j+1)>0)
            zeroc4(i)=zeroc4(i)+1;
        end
    end
end


% Calculating how much indexes there are between two zeros of a spike.
cc1=zeros(3330,1);
flag=false;

for i=1:3330
    for j =1:39
        if(newspikesEst1(i,j)<0 && newspikesEst1(i,j+1)>0)
            flag=true;
        end
        if(flag==true)
            cc1(i)=cc1(i)+1;
        end
        if(newspikesEst1(i,j)>0 && newspikesEst1(i,j+1)<0)
            flag=false;
        end
            
    end
    flag=false;
end

cc2=zeros(3455,1);
flag=false;

for i=1:3455
    for j =1:39
        if(newspikesEst2(i,j)<0 && newspikesEst2(i,j+1)>0)
            flag=true;
        end
        if(flag==true)
            cc2(i)=cc2(i)+1;
        end
        if(newspikesEst2(i,j)>0 && newspikesEst2(i,j+1)<0)
            flag=false;
        end
            
    end
    flag=false;
end


cc3=zeros(3308,1);
flag=false;

for i=1:3308
    for j =1:39
        if(newspikesEst3(i,j)<0 && newspikesEst3(i,j+1)>0)
            flag=true;
        end
        if(flag==true)
            cc3(i)=cc3(i)+1;
        end
        if(newspikesEst3(i,j)>0 && newspikesEst3(i,j+1)<0)
            flag=false;
        end
            
    end
    flag=false;
end


cc4=zeros(3032,1);
flag=false;

for i=1:3032
    for j =1:39
        if(newspikesEst4(i,j)<0 && newspikesEst4(i,j+1)>0)
            flag=true;
        end
        if(flag==true)
            cc4(i)=cc4(i)+1;
        end
        if(newspikesEst4(i,j)>0 && newspikesEst4(i,j+1)<0)
            flag=false;
        end
            
    end
    flag=false;
end


%Calculating max difference between two values of every spike . 

dif1=diff(transpose(newspikesEst1));
maxDif1=zeros(3330,1);
for i=1:3330
    for j=1:39
        if(dif1(j,i)>maxDif1(i))
            maxDif1(i)=dif1(j,i);
        end
    end
end


dif2=diff(transpose(newspikesEst2));
maxDif2=zeros(3455,1);
for i=1:3455
    for j=1:39
        if(dif2(j,i)>maxDif2(i))
            maxDif2(i)=dif2(j,i);
        end
    end
end


dif3=diff(transpose(newspikesEst3));
maxDif3=zeros(3308,1);
for i=1:3308
    for j=1:39
        if(dif3(j,i)>maxDif3(i))
            maxDif3(i)=dif3(j,i);
        end
    end
end


dif4=diff(transpose(newspikesEst4));
maxDif4=zeros(3032,1);
for i=1:3032
    for j=1:39
        if(dif4(j,i)>maxDif4(i))
            maxDif4(i)=dif4(j,i);
        end
    end
end


%Plots of two characteristics as pairs for  classification between the three
%neurons


figure(1)
for i=1:3330
    if (num1(i)==1)
        plot(maxDif1(i),sqrt(real(max(fft(newspikesEst1(i,:))))^2+imag(max(fft(newspikesEst1(i,:))))^2),'r.')
        hold on
    end
    if(num1(i)==2)
        plot(maxDif1(i),sqrt(real(max(fft(newspikesEst1(i,:))))^2+imag(max(fft(newspikesEst1(i,:))))^2),'k.')
        hold on
    end
    if (num1(i)==3)
        plot(maxDif1(i),sqrt(real(max(fft(newspikesEst1(i,:))))^2+imag(max(fft(newspikesEst1(i,:))))^2),'g.')
        hold on
    end
end

figure(2)
for i=1:3455
    if (num2(i)==1)
        plot(maxDif2(i),sqrt(real(max(fft(newspikesEst2(i,:))))^2+imag(max(fft(newspikesEst2(i,:))))^2),'r.')
        hold on
    end
    if(num2(i)==2)
        plot(maxDif2(i),sqrt(real(max(fft(newspikesEst2(i,:))))^2+imag(max(fft(newspikesEst2(i,:))))^2),'k.')
        hold on
    end
    if (num2(i)==3)
        plot(maxDif2(i),sqrt(real(max(fft(newspikesEst2(i,:))))^2+imag(max(fft(newspikesEst2(i,:))))^2),'g.')
        hold on
    end
end

figure(3)
for i=1:3308
    if (num3(i)==1)
        plot(maxDif3(i),sqrt(real(max(fft(newspikesEst3(i,:))))^2+imag(max(fft(newspikesEst3(i,:))))^2),'r.')
        hold on
    end
    if(num3(i)==2)
        plot(maxDif3(i),sqrt(real(max(fft(newspikesEst3(i,:))))^2+imag(max(fft(newspikesEst3(i,:))))^2),'k.')
        hold on
    end
    if (num3(i)==3)
        plot(maxDif3(i),sqrt(real(max(fft(newspikesEst3(i,:))))^2+imag(max(fft(newspikesEst3(i,:))))^2),'g.')
        hold on
    end
end

figure(4)
for i=1:3032
    if (num4(i)==1)
        plot(maxDif4(i),sqrt(real(max(fft(newspikesEst4(i,:))))^2+imag(max(fft(newspikesEst4(i,:))))^2),'r.')
        hold on
    end
    if(num4(i)==2)
        plot(maxDif4(i),sqrt(real(max(fft(newspikesEst4(i,:))))^2+imag(max(fft(newspikesEst4(i,:))))^2),'k.')
        hold on
    end
    if (num4(i)==3)
        plot(maxDif4(i),sqrt(real(max(fft(newspikesEst4(i,:))))^2+imag(max(fft(newspikesEst4(i,:))))^2),'g.')
        hold on
    end
end


%Ερώτημα 2.5


%Creation of matrix data# and group# for every data file and finding the percentage of 
% classification using the function MyClassify() . Results are being saved in the variables % a1 , a2 , a3 , a4. 



data1=zeros(3330,6);
group1=zeros(3330,1);

for i=1:3330
    data1(i,1)=maxDif1(i);
    data1(i,3)=cc1(i);
    data1(i,6)=maxA1(i);
    data1(i,4)=zeroc1(i);
    data1(i,2)=sqrt(real(max(fft(newspikesEst1(i,:))))^2+imag(max(fft(newspikesEst1(i,:))))^2);
    data1(i,5)=max(newspikesEst1(i,:))-min(newspikesEst1(i,:));
    group1(i)=num1(i);
end

a1=MyClassify(data1,group1);

data2=zeros(3455,6);
group2=zeros(3455,1);

for i=1:3455
    data2(i,1)=maxDif2(i);
    data2(i,3)=cc2(i);
    data2(i,4)=maxA2(i);
    data2(i,5)=zeroc2(i);
    data2(i,2)=sqrt(real(max(fft(newspikesEst2(i,:))))^2+imag(max(fft(newspikesEst2(i,:))))^2);
    data2(i,6)=max(newspikesEst2(i,:))-min(newspikesEst2(i,:));
    group2(i)=num2(i);
end

a2=MyClassify(data2,group2);

data3=zeros(3308,6);
group3=zeros(3308,1);

for i=1:3308
    data3(i,1)=maxDif3(i);
    data3(i,4)=cc3(i);
    data3(i,3)=maxA3(i);
    data3(i,6)=zeroc3(i);
    data3(i,2)=sqrt(real(max(fft(newspikesEst3(i,:))))^2+imag(max(fft(newspikesEst3(i,:))))^2);
    data3(i,5)=max(newspikesEst3(i,:))-min(newspikesEst3(i,:));
    group3(i)=num3(i);
end

a3=MyClassify(data3,group3);

data4=zeros(3032,6);
group4=zeros(3032,1);

for i=1:3032
    data4(i,1)=maxDif4(i);
    data4(i,2)=cc4(i);
    data4(i,3)=maxA4(i);
    data4(i,6)=zeroc4(i);
    data4(i,4)=sqrt(real(max(fft(newspikesEst4(i,:))))^2+imag(max(fft(newspikesEst4(i,:))))^2);
    data4(i,5)=max(newspikesEst4(i,:))-min(newspikesEst4(i,:));
    group4(i)=num4(i);
end

a4=MyClassify(data4,group4);
