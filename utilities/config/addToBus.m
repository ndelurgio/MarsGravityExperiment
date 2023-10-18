function bus = addToBus(bus,name,type)
    elem = Simulink.BusElement;
    elem.Name = name;

    if type=="bus"
        elem.DataType = "Bus: " + name;
    elseif type=="real"
        elem.DataType = "double";
        data = evalin('base',name);
        elem.Dimensions = size(data);
    end
    
    elementNames = [];
    for i = 1:length(bus.Elements)
        elementNames = [elementNames, string(bus.Elements(i).Name)];
    end
    if ~isempty(elementNames) && any(contains(elementNames,name))
        bus.Elements(find(elementNames == name)) = elem;
    else
        bus.Elements(end+1) = elem;
    end
    evalin('base','clear slBus*')
end