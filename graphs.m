function A = equation01(t, r, n, A0)
    A = A0 * (1 + r/n).^(n*t);
end

function A = equation02(t, r, A0)
    A = A0 * exp(r*t);
end

function exportGraph(name, figHandle)
    plotsFolder = 'Project01/plots';
    if ~exist(plotsFolder, 'dir')
        mkdir(plotsFolder);
    end
    pdfFilename = fullfile(plotsFolder, [name, '.pdf']);
    exportgraphics(figHandle, pdfFilename, 'ContentType', 'vector');
end


%#2.1
t = 0:0.1:30;
figure1 = figure;
plot(t, equation01(t, 0.03, 4, 750000), 'Color', '#CFB87C', 'LineWidth', 2); hold on;
plot(t, equation01(t, 0.03, 12, 750000), 'Color', '#A2A4A3', 'LineWidth', 2);
plot(t, equation02(t, 0.03, 750000), 'Color', '#0A3758', 'LineWidth', 2);
xlabel('Time (years)'); ylabel('Loan Value ($)');
title('Loan Value: Compounded 4x/year, 12x/year, and Continuously');
legend('n = 4', 'n = 12', 'Continuous', 'Location', 'northwest');
grid on; hold off;
exportGraph('3.1.1', figure1);

%#3.1
% Fixed rate: Euler vs True (h = 0.5)
A0 = 750000;
r = 0.05;
p = 4000;
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

A_true = (12*p)/r + (A0 - (12*p)/r).*exp(r*t);
figure2 = figure;
plot(t, A, 'LineWidth', 2, 'Color', '#565A5C'); hold on;
plot(t, A_true, 'LineWidth', 2, 'Color', '#CFB87C');
yline(0, 'k--');
xlabel('t (years)'); ylabel('A(t) ($)');
title('Fixed rate: Euler vs True (h = 0.5)');
legend('Euler', 'True', 'Location', 'best');
grid on; hold off;
exportGraph('3.2.2', figure2);

% Fixed rate: Euler vs True (h = 0.01)
h = 0.01;
t2 = 0;
A2 = A0;
k = 1;

while A2(k) >= 0 && t2(k) < maxYears
    t2(k+1) = t2(k) + h;
    A2(k+1) = A2(k) + h*(r*A2(k) - 12*p);
    k = k + 1;
end

A_true2 = (12*p)/r + (A0 - (12*p)/r).*exp(r*t2);
figure3 = figure;
plot(t2, A2, 'LineWidth', 2, 'Color', '#565A5C'); hold on;
plot(t2, A_true2, 'LineWidth', 2, 'Color', '#CFB87C');
yline(0, 'k--');
xlabel('t (years)'); ylabel('A(t) ($)');
title('Fixed rate: Euler vs True (h = 0.01)');
legend('Euler', 'True', 'Location', 'best');
grid on; hold off;
exportGraph('3.2.3', figure3);

% Adjustable rate mortgage: Euler h=0.01
A0 = 750000;
h = 0.01;
p1 = 4000;
p2 = 4500;
tA = 0;
AA = A0;
k = 1;

while AA(k) >= 0 && tA(k) < maxYears
    if tA(k) <= 5
        rk = 0.03;
    else
        rk = 0.03 + 0.015*sqrt(tA(k) - 5);
    end
    tA(k+1) = tA(k) + h;
    AA(k+1) = AA(k) + h*(rk*AA(k) - 12*p1);
    k = k + 1;
end

tB = 0;
AB = A0;
k = 1;

while AB(k) >= 0 && tB(k) < maxYears
    if tB(k) <= 5
        rk = 0.03;
    else
        rk = 0.03 + 0.015*sqrt(tB(k) - 5);
    end
    tB(k+1) = tB(k) + h;
    AB(k+1) = AB(k) + h*(rk*AB(k) - 12*p2);
    k = k + 1;
end

figure4 = figure;
plot(tA, AA, 'LineWidth', 2, 'Color', '#565A5C'); hold on;
plot(tB, AB, 'LineWidth', 2, 'Color', '#CFB87C');
yline(0, 'k--');
xlabel('t (years)'); ylabel('A(t) ($)');
title('Adjustable rate mortgage: Euler h=0.01');
legend(sprintf('p=$%d', p1), sprintf('p=$%d', p2), 'Location', 'best');
grid on; hold off;
exportGraph('3.2.4', figure4);