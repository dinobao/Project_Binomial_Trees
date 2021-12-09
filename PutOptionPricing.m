%%2种看跌期权的定价

%输入具体参数
S0=100;  %当前股价 current stock price
K=90;  %执行价格 exercise price 
r=0.05;  %利率 risk-free interest rate
T=1;  %期权有效期 
sigma=0.3 %波动率
q=0.02; %红利率 
n=4;  %步数  

%计算二叉树相关参数
dt=T/n;  %时间步长 time step
u=exp(sigma*sqrt(dt));  %计算上升比率 
d=1/u;  %计算下降比率/人为构造期权定价方程求解条件  
p=(exp((r-q)*dt)-d)/(u-d);  %计算上升概率

%%构造二叉树矩阵，其中列数j表示时期数，行数i表示从j开始的时期数，Sx为股价矩阵，
%%fx为期权内在价值 intrinsic value
for j=1:n+1
    for i=1:j
        Sx(i,j)=S0*(u^(j-i))*(d^(i-1));
        fx(i,j)=max(K-Sx(i,j),0);
    end;
end;

%计算欧式期权价格矩阵Efx和美式Afx

%计算最后一期的期权价格
for i=1:n+1   %期权到期时,j=n+1
    Efx(i,n+1)=fx(i,n+1);   
    Afx(i,n+1)=fx(i,n+1);
end;

%由最后一期期权价格倒推之前各期的价格
for j=1:n  
    j=n+1-j;
    for i=1:j
        Efx(i,j)= exp(-r*dt)*(p*Efx(i,j+1)+(1-p)*Efx(i+1,j+1));
        Afx(i,j)= max(exp(-r*dt)*(p*Afx(i,j+1)+(1-p)*Afx(i+1,j+1)),fx(i,j));
    end;
end;

%%设置输出数值精度/有效数位
format long g;   %关闭科学计数法
a=-7;   %设置小数点后保留的有效数位


%%输出两种期权的定价结果
disp('欧式看跌期权的定价矩阵为：');
disp(Efx);
Efx=roundn(Efx,a);
disp('美式看跌期权的定价矩阵为：');
Afx=roundn(Afx,a);
disp(Afx);

IEOP=Efx(1,1);    %Initial European Option Price
IAOP=Afx(1,1);    %Initial American Option Price

%输出股价矩阵
disp('股票价格的变化矩阵为：');

Sx=roundn(Sx,a);
disp(Sx);

disp('欧式看跌期权的初始定价为：');

disp(IEOP);
disp('美式看跌期权的初始定价为：');
disp(IAOP);

