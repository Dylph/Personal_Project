clear all; clc;
tic
format long

Data_ret = xlsread('C:\Users\PC LENOVO\Desktop\Math\Final Script\_Step1\Bitcoin Historical Data (2 years).xlsx','Data (2 years)',  sprintf('D%d:D%d',3,732));
Data_price = xlsread('C:\Users\PC LENOVO\Desktop\Math\Final Script\_Step1\Bitcoin Historical Data (2 years).xlsx','Data (2 years)',  sprintf('C%d:C%d',367,731));

%Parameter untuk simulasi Monte Carlo
M = 100000;
T = 365;
N = 365;
dt = T / N;
s = ones(M,N);
r = normrnd(0, 1, [M, N]);

%Membangun Mu & Sigma untuk 1 tahun 
for i = 1 : 365
    Mu (i) = mean (Data_ret( i : 364+i));
    Sigma(i) = std (Data_ret( i : 364+i));
    s(:,i) = Data_price(i) * s(:,i);
end

%akan disimulasikan harga saham hingga akhir T
for i = 1 : T
   s(:,i) = s(:,i) .* exp((Mu(i) - Sigma(i)^2 / 2) .* dt + Sigma(i) .*  r(:,i) .* sqrt(dt));
end

%Dicari nilai VaR berdasarkan tingkat kepercayaan (1%, 5%, 10%)
for j = 1 : T
    %Diurutkan semua harga dari hasil semulasi
    V = sort(s(:,j));

    % VaR 99%
    a = V(M * 0.01);
    VaR1(j)  = log(a/Data_price(j));

    % Var 95%
    b = V(M * 0.05);
    VaR5(j)  = log(b/Data_price(j));

    % Var 90%
    c = V(M * 0.1);
    VaR10(j) = log(c/Data_price(j));
end

figure(1)
plot(Data_ret(366:730))
hold on
plot(VaR1)
hold off

figure(2)
plot(Data_ret(366:730))
hold on
plot(VaR5)
hold off

figure(3)
plot(Data_ret(366:730))
hold on
plot(VaR10)
hold off

toc
