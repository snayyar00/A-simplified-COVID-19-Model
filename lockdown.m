%% Function for Lockdown
function R = lockdown(t)

if (t>=0) && (t<=20)
    R = 3.5;
elseif (t>20) && (t<=70)
    R = 2.6;
elseif (t>70) && (t<=84)
    R = 1.9;
elseif (t>80) && (t<=90)
    R = 1.0;
elseif (t>90) && (t<=110)
    R = 0.55;
elseif (t>110) && (t<=1000)
    R = 0.55;
elseif (t>1000)
    R = 0.5;
end

end