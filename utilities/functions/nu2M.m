function M = nu2M(nu, e)
E = 2 .* atan(sqrt((1 - e) ./ (1 + e)) .* tan(nu ./ 2));
M = E - e .* sin(E);
M = mod(M, 2 * pi);
end
