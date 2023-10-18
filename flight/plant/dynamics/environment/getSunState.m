function sunState = getSunState(sunStateData,timeData,t)

sunPosX = interp1(timeData,sunStateData(1,:),t);
sunPosY = interp1(timeData,sunStateData(2,:),t);
sunPosZ = interp1(timeData,sunStateData(3,:),t);
sunVelX = interp1(timeData,sunStateData(4,:),t);
sunVelY = interp1(timeData,sunStateData(5,:),t);
sunVelZ = interp1(timeData,sunStateData(6,:),t);

sunState = [sunPosX; sunPosY; sunPosZ; sunVelX; sunVelY; sunVelZ];

end

