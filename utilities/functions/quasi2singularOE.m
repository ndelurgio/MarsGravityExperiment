function OE = quasi2singularOE(OE_quasi)
% Quasi non-singular OEs to singular OEs

w = wrapTo2Pi(atan2(OE_quasi(4), OE_quasi(3)));
OE = zeros(6, 1);
OE(1) = OE_quasi(1);
OE(2) = OE_quasi(3) / cos(w);
OE(3) = OE_quasi(5);
OE(4) = OE_quasi(6);
OE(5) = w;
OE(6) = wrapTo2Pi(OE_quasi(2) - w);

end
