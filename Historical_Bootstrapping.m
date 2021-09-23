clear all; clc;
tic
format long

Data_ret = xlsread('C:\Users\PC LENOVO\Desktop\Math\Final Script\_Step1\Bitcoin Historical Data (2 years).xlsx','Data (2 years)',  sprintf('D%d:D%d',3,732));
Data_price = xlsread('C:\Users\PC LENOVO\Desktop\Math\Final Script\_Step1\Bitcoin Historical Data (2 years).xlsx','Data (2 years)',  sprintf('C%d:C%d',367,731));

M = 300;
ite = 5000;
T = 365;
a = ones(ite, T);
b = ones(ite, T);
c = ones(ite, T);

for i = 1:ite
    r = round((364*rand(M, T))+1);
    
    for j = 1:T
        Data_smpl = Data_ret(j : 364+j);
        s(:, j) = Data_price(j) * (1 + Data_smpl(r(:,j)));
        
        V = sort(s(:, j));
    
        a(i, j) = V(M * 0.01); % VaR 99%
        b(i, j) = V(M * 0.05); % Var 95%
        c(i, j) = V(M * 0.1);  % Var 90%
    end
end

for k = 1 : T
    VaR1  (k) = log((1/ite * sum(a(:, k))) / Data_price(k));
    VaR5  (k) = log((1/ite * sum(b(:, k))) / Data_price(k));
    VaR10 (k) = log((1/ite * sum(c(:, k))) / Data_price(k));
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