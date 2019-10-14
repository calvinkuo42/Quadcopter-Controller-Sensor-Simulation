load('signalOutput.mat');
len = length(raw);
t = raw(1,:);
unfiltered = raw(2,:);

%Moving Average Filter
window = 40;

filtered = zeros(1,len);
for i = 1:len
    if i <= len - window + 1
        filtered(1,i) = (1/window)*...
            sum(unfiltered(1,i:i + window - 1));
    else
        diff = len - i + 1;
        filtered(1,i) = (1/diff)*...
            sum(unfiltered(1,i:i+diff-1));
    end
end

%subplot(2,1,1),stem(t(1:70000),ma_filtered(1:70000));
%title("Moving AVG Filter N=40");
%subplot(2,1,2),stem(t(1:70000),unfiltered(1:70000));
%title('Unfiltered')

heightFiveSignal = filtered(20000:30000);
subplot(2,1,1), stem(t(20000:30000),heightFiveSignal);
title('Signal at 5 Meters');

heightTenSignal = filtered(50000:60000);
subplot(2,1,2), stem(t(50000:60000),heightTenSignal);
title('Signal at 10 Meters');

pAvgHeightFive = (1/10000)*sum(heightFiveSignal.^2);
pAvgHeightTen = (1/10000)*sum(heightTenSignal.^2);
x = t(50000:60000);
sourcePower = (1/10000)*sum((10*sin(2*pi*x)).^2);

%Algorithm
h1=5;
h2=10;
sourceY = (sourcePower*(1/pAvgHeightFive - 1/pAvgHeightTen) - (h1^2-h2^2))/(2*(h2-h1));
sourceX = ((sourcePower/pAvgHeightFive) - (sourceY - h1)^2)^(1/2);