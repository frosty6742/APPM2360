%../APPM2360/Project01/proj1.m
s = settings;
s.matlab.appearance.figure.GraphicsTheme.TemporaryValue = "light";

function exportGraph(name, figHandle)
    plotsFolder = 'Project01/plots';

    if ~exist(plotsFolder, 'dir')
        mkdir(plotsFolder);
    end

    pdfFilename = fullfile(plotsFolder, [name, '.pdf']);
    exportgraphics(figHandle, pdfFilename, 'ContentType', 'vector');
end

function A = equation01(t, r, n, A0)
    A = A0 * (1 + r/n).^(n*t);
end

function A = equation02(t, r, A0)
    A = A0 * exp(r*t);
end

function dAdt = equation03(r, A, p, A0)
    dAdt = r*A - 12*p;
end


%#2.1
ns = [1 2 4 12]; % number of compounds per year
comp_n = zeros(size(ns));

% Total cost after 5 years
for i = 1:length(ns)
    comp_n(i) = equation01(5, 0.03, ns(i), 750000);
end

fprintf('Total cost after 5 years:\n');
for i = 1:length(ns)
    fprintf('  n=%d: $%.2f\n', ns(i), comp_n(i));
end

continuous_value = equation02(5, 0.03, 750000);
fprintf('  Continuous: $%.2f\n\n', continuous_value);

% Plot for 0 to including 30 years
t = 0:0.1:30;

f = figure;
plot(t, equation01(t, 0.03, 4, 750000), 'Color', '#CFB87C', 'LineWidth', 2);
hold on;
plot(t, equation01(t, 0.03, 12, 750000), 'Color', '#A2A4A3', 'LineWidth', 2);
plot(t, equation02(t, 0.03, 750000), 'Color', '#0A3758', 'LineWidth', 2);
xlabel('Time (years)');
ylabel('Loan Value ($)');
title('Loan Value: Compounded 4x/year, 12x/year, and Continuously');
legend('n = 4', 'n = 12', 'Continuous', 'Location', 'northwest');
grid on;
hold off;
exportGraph('3.1.1', f);


%#3.1
A0 = 750000;
r  = 0.05;
p  = 4000;

% (1) Euler with h = 0.5 until payoff  
h = 0.5;
t = 0;
A = A0;
k = 1;
maxYears = 200; 

while A(k) >= 0 && t(k) < maxYears
    t(k+1) = t(k) + h;
    A(k+1) = A(k) + h*(r*A(k) - 12*p);
    k = k + 1;
end

tpay_h05 = t(end);
fprintf('Fixed rate (r=%.2f, p=$%.0f): Euler h=%.2f payoff ~ %.2f years\n', r, p, h, tpay_h05);

% (2) Plot Euler and true solution together h=0.5
A_true = (12*p)/r + (A0 - (12*p)/r).*exp(r*t);

f = figure;
plot(t, A, 'LineWidth', 2, 'Color', '#565A5C'); hold on;
plot(t, A_true, 'LineWidth', 2, 'Color', '#CFB87C');
yline(0, 'k--');
xlabel('t (years)'); ylabel('A(t) ($)');
title(sprintf('Fixed rate: Euler vs True (h = %.2f)', h));
legend('Euler', 'True', 'Location', 'best');
grid on; hold off;
exportGraph('3.2.2', f);

% (3) Repeat for h=0.01  
h = 0.01;
t2 = 0;
A2 = A0;
k = 1;

while A2(k) >= 0 && t2(k) < maxYears
    t2(k+1) = t2(k) + h;
    A2(k+1) = A2(k) + h*(r*A2(k) - 12*p);
    k = k + 1;
end

tpay_h001 = t2(end);

fprintf('Fixed rate (r=%.2f, p=$%.0f): Euler h=%.2f payoff ~ %.2f years\n\n', r, p, h, tpay_h001);

A_true2 = (12*p)/r + (A0 - (12*p)/r).*exp(r*t2);

f = figure;
plot(t2, A2, 'LineWidth', 2, 'Color', '#565A5C'); hold on;
plot(t2, A_true2, 'LineWidth', 2, 'Color', '#CFB87C');
yline(0, 'k--');
xlabel('t (years)'); ylabel('A(t) ($)');
title(sprintf('Fixed rate: Euler vs True (h = %.2f)', h));
legend('Euler', 'True', 'Location', 'best');
grid on; hold off;
exportGraph('3.2.3', f);

%#3.2
A0 = 750000;
h  = 0.01;

% Scenario 1: p = 4000   
p1 = 4000;

tA = 0;
AA = A0;
interestA = 0;

k = 1;
while AA(k) >= 0 && tA(k) < maxYears
    if tA(k) <= 5
        rk = 0.03;
    else
        rk = 0.03 + 0.015*sqrt(tA(k) - 5);
    end

    interestA = interestA + h*(rk*AA(k));         
    tA(k+1) = tA(k) + h;
    AA(k+1) = AA(k) + h*(rk*AA(k) - 12*p1);
    k = k + 1;
end

tpay_p4000 = tA(end);

% Scenario 2: p = 4500   
p2 = 4500;

tB = 0;
AB = A0;
interestB = 0;

k = 1;
while AB(k) >= 0 && tB(k) < maxYears
    if tB(k) <= 5
        rk = 0.03;
    else
        rk = 0.03 + 0.015*sqrt(tB(k) - 5); 
    end

    interestB = interestB + h*(rk*AB(k));
    tB(k+1) = tB(k) + h;
    AB(k+1) = AB(k) + h*(rk*AB(k) - 12*p2);
    k = k + 1;
end

tpay_p4500 = tB(end);

fprintf('ARM (Euler h=%.2f):\n', h);
fprintf('  p=$%d payoff ~ %.2f years, interest paid ~ $%.2f\n', p1, tpay_p4000, interestA);
fprintf('  p=$%d payoff ~ %.2f years, interest paid ~ $%.2f\n', p2, tpay_p4500, interestB);


f = figure;
plot(tA, AA, 'LineWidth', 2,'Color', '#565A5C'); 
hold on;
plot(tB, AB, 'LineWidth', 2, 'Color', '#CFB87C');
yline(0, 'k--');
xlabel('t (years)'); ylabel('A(t) ($)');
title('Adjustable rate mortgage: Euler h=0.01');
legend(sprintf('p=$%d (payoff ~ %.2f yrs)', p1, tpay_p4000), ...
       sprintf('p=$%d (payoff ~ %.2f yrs)', p2, tpay_p4500), ...
       'Location', 'best');
grid on; hold off;
exportGraph('3.2.4', f);