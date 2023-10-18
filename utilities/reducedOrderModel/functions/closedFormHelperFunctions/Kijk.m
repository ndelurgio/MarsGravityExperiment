function Kijk = Kijk(dv_min, si, sj, sk, dMij, dMik, dMjk, fi, fj, fk)

Kijk = 6*dv_min*( si*sj*dMij - si*sk*dMik*fi*fk + sj*sk*dMjk*fj*fk );

end

