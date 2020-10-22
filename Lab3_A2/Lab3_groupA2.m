% Let us imagine that the urn contains 10 balls signed by numbers from 1 to 10
% We will use the rand function to simulate a single drawing of just 1 ball from the urn at the time.
% Note that we can easily "convert" the result returned by the rand function into a digit from a range [1 ...10], 
% so that the drawing of each of these face values were as likely as 1 / 10 (simple probability statistics).
% If 0 <x <1 (as returned by rand function), then a whole part of the number represented by
% y = 1 + 10x is an integer within the required range. 
% You can easily justify that if x has a distribution uniform in [0…1], 
% y takes the values from the set [1, ..., 10] with equal probabilities.
close all;
clear all;
%variable:
%ball= fix(1+10*rand);
balls=zeros(100);
% Now imagine that after each drawing the ball from the urn wins a certain amount of money equal
% to the number written on the ball. Therefore, we can each draw to receive 1 to 10 PLN. 

for i = 1 : 100
    balls(i)=fix(1+10*rand);
    total=cumsum(balls);
end

size=get(0,'ScreenSize');
figure('Position', [1 1 size(3) size(4)]);
n =1:100; % numero de tiradas
subplot(2,1,1);
h=plot(n,balls);
title('Drawing of 1 out of 10 balls', 'FontSize', 20);
subplot(2,1,2);
s=plot(n,total);
axis([1 100 0 1000])
grid on;

%--------------SECOND PART---------------------
tax=5;
balls=zeros(100);
for i = 1 : 100
    balls(i)=fix(1+10*rand);
    total=cumsum(balls-tax);
end
figure('Position', [1 1 size(3) size(4)]);
n =1:100; % numero de tiradas
subplot(2,1,1);
h=plot(n,balls);
title('Drawing of 1 out of 10 balls with taxes', 'FontSize', 20);
subplot(2,1,2);
s=plot(n,total);
axis([1 100 -1000 1000]);
legend(s,'\ittotal\rm','\ittotal-taxes(5)\rm');

grid on;
