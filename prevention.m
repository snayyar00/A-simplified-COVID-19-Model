%% Function for Prevention
function R = prevention(t)

if (t>=0) && (t<=20)
    R = 3;
elseif (t>20) && (t<=70)
    R = 2.2;
elseif (t>70) && (t<=84)
    R = 0.9;
elseif (t>80) && (t<=90)
    R = 2.5;
elseif (t>90) && (t<=110)
    R = 3.2;
elseif (t>110) && (t<=1000)
    R = 0.85;
elseif (t>1000)
    R = 0.5;
end

end