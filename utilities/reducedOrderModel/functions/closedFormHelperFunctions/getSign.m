function s = getSign(direction,Delta_de)

s = -1;
if dot( direction, Delta_de ) > 0
    s = 1;
end

end

