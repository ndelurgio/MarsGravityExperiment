function bdot = imuDynamics(sqrtQ,noise)

noise = sqrtQ*noise;
bdot = noise;

end

