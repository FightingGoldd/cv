clear all
uv=[139	57
212	57
286	56
361	56
434	55
508	55
139	131
213	131
287	130
361	130
435	130
508	129
140	205
214	205
287	204
361	204
435	203
508	203
141	278
214	278
288	278
362	277
435	277
509	276
142	352
215	352
289	351
363	351
436	350
510	350
143	425
216	425
290	425
363	424
436	424
510	423];
XYZ=[0	0	0       %%%%%%%采集的特征点从空间投影到图像平面的坐标
15	0	0
30	0	0
45	0	0
60	0	0
75	0	0
0	15	0
15	15	0
30	15	0
45	15	0
60	15	0
75	15	0
0	30	0
15	30	0
30	30	0
45	30	0
60	30	0
75	30	0
0	45	0
15	45	0
30	45	0
45	45	0
60	45	0
75	45	0
0	60	0
15	60	0
30	60	0
45	60	0
60	60	0
75	60	0
0	75	0
15	75	0
30	75	0
45	75	0
60	75	0
75	75	0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%采集的特征点在世界坐标系中的坐标
gdy=length(uv);      %gdy = 180
for g=1:1:gdy        %2*gdy
X1(2*g-1,  :)=[XYZ(g,1)  XYZ(g,2)  XYZ(g,3)   1      0       0         0       0     -uv(g,1)*XYZ(g,1)  -uv(g,1)*XYZ(g,2)  -uv(g,1)*XYZ(g,3)];
X1(2*g-0,  :)=[0           0           0      0  XYZ(g,1)  XYZ(g,2)  XYZ(g,3)  1     -uv(g,2)*XYZ(g,1)  -uv(g,2)*XYZ(g,2)  -uv(g,2)*XYZ(g,3)];
B(2*g-1,1   )=uv(g,1);     %B的（2*g-1）行的第一列，相当于马松德的U，X1相当于K
B(2*g-0,1   )=uv(g,2);
end
A1=X1;
A=A1'*A1;                       %%根据A1X=B1得到A1'A1X=A1'B,其中A'B为6*1的列向量，A1'A1为5*5的矩阵 
B=A1'*B;                      %%
n=length(B);
x=zeros(n,1);
c=zeros(1,n);
d1=0;
for i=1:n-1
    max=abs(A(i,i));
    m=i;
    for j=i+1:n
        if max<abs(A(j,i))     %%%应该是abs(A(j,i))；而不是abs(A(j,j))
            max=abs(A(j,i));   %%%%选择第i行第j列最大的数
            m=j;               %%%%标记第i行第j列位置处该最大的数的位置为(i,j)
        end
    end
    if(m~=i)                       %%如果第i行最大的数的列数大于所在的行数i，则交换第i行与第j行所有的数值
        for k=i:n                  %%
            c(k)=A(i,k);           %%

            A(i,k)=A(m,k);         %%
            A(m,k)=c(k);           %%  
        end
        d1=B(i);                  %%此处为方程右边的相应的列进行交换
        B(i)=B(m);                %%
        B(m)=d1;                  %%
    end
    for k=i+1:n
        for j=i+1:n
            A(k,j)=A(k,j)-A(i,j)*A(k,i)/A(i,i);       %%此处建议解一个多元方程，就明白算法，目的是使得元素(i，i)下面的数全部为零
        end
        B(k)=B(k)-B(i)* A(k,i)/A(i,i);                %%与前一行一样
        A(k,i)=0;
    end
end
x(n)=B(n)/A(n,n);                      %%得到上三角形行列式
for i=n-1:-1:1
    sum=0;
    for j=i+1:n
        sum=sum+A(i,j)*x(j);            %%
    end
    x(i)=(B(i)-sum)/A(i,i);         %%
end
disp('方程组的解为：');
x
disp('Hello, World!')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m1=[x(1)   x(2)   x(3)];
m2=[x(5)  x(6)    x(7)];
m3=[x(9)  x(10)  x(11)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r3=m3/norm(m3)                        %norm(A)/norm(A,2)，返回的是矩阵A的二范数
u0=m1*m3'/norm(m3)/norm(m3)
v0=m2*m3'/norm(m3)/norm(m3)
ax=norm([m1(2)*m3(3)-m1(3)*m3(2) -m1(1)*m3(3)+m1(3)*m3(1) m1(1)*m3(2)-m1(2)*m3(1)] )/norm(m3)/norm(m3)
ay=norm([m2(2)*m3(3)-m2(3)*m3(2) -m2(1)*m3(3)+m2(3)*m3(1) m2(1)*m3(2)-m2(2)*m3(1)])/norm(m3)/norm(m3)
r1=(m1-u0*m3)/norm(m3)/ax
r2=(m2-v0*m3)/norm(m3)/ay
tz=1/norm(m3)
tx=(x(4)-u0)/norm(m3)/ax
ty=(x(8)-v0)/norm(m3)/ay