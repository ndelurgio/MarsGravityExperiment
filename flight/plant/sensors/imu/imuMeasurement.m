function y_imu = imuMeasurement(d_SRP,a_control,b,sqrtR,noise)

noise = sqrtR*noise;
y_imu = d_SRP + a_control + b + noise;

end

