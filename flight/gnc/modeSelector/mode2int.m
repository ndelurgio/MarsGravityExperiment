function modeInt = mode2int(mode)
% Simple mapping from mode in string format to integer format

% modeNames = ["science", "formationBreak", "passive", "formationAcquisition"];
% modeDict = dictionary(modeNames, 1:4);
% 
% modeInt = modeDict(mode);

switch mode
    case "science"
        modeInt = 1;
    case "formationBreak"
        modeInt = 2;
    case "passive"
        modeInt = 3;
    case "formationAcquisition"
        modeInt = 4;
    otherwise
        modeInt = 0;
end

end