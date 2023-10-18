function cartesianState = propYA(OE0,EROE0,mu,t)

OE = OE0;
cartesianState = zeros(6,length(t));
% cartesianState(:,1) = cartesianGuffantiSolution(OE0,t(1),mu)*EROE0;
for i = 1:length(t)
    OE(6) = OE0(6) + meanMotion(mu,OE0(1))*t(i);
    STM = cartesianGuffantiSolution(OE,t(i),mu);
    cartesianState(:,i) = STM*EROE0;
end

end

