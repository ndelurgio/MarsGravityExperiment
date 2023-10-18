function OE_quasi = singular2quasiOE(OE)
% Singular OEs to quasi-nonsingular OEs
OE_quasi = zeros(6,1);
OE_quasi(1) = OE(1);
OE_quasi(2) = wrapTo2Pi(OE(5) + OE(6));
OE_quasi(3) = OE(2) * cos(OE(5));
OE_quasi(4) = OE(2) * sin(OE(5));
OE_quasi(5) = OE(3);
OE_quasi(6) = OE(4);

end
