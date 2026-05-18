function data = filterData(data,num,den)
    u = filter(num,den,data.InputData);
    y = filter(num,den,data.OutputData);
    data = iddata(y,u,data.Ts);
end