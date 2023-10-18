function bus = createBus(struct)
    struct = Simulink.Bus.createObject(struct);
    bus = evalin('base',struct.busName);
    evalin('base','clear slBus1')
end