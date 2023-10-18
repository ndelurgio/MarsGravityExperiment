function gij = gij(eta, n, si, sj, fi, fj, hif, hjf, dv_min, dMij)

gij = eta*n*si*fi*hif - eta*n*sj*fj*hjf + 6*dv_min*si*sj*dMij*fi*fj;

end

