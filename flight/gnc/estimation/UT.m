function [x,w] = UT(mu,cov)
lam = 2;
n = length(mu);
x = zeros(n,2*n+1);
w = zeros(1,2*n+1);
x(:,1) = mu;
w(1,1) = lam/(lam+n);
for i = 1:n
    mat = real(sqrtm((lam+n)*cov));
    x(:,i+1) = mu + mat(:,i);
    x(:,i+1+n) = mu - mat(:,i);
    w(1,i+1) = 1/(2*(lam+n));
    w(1,i+1+n) = 1/(2*(lam+n));
end


end

