clc, clear, close all;
% % Rosenbrock's function
% [x,y] = meshgrid(-1.5:.1:1.5, -1.5:.1:1.5);
% f = (1 - x).^2 + 10 * (y - x.^2).^2;
% v = [0.01,0.5,2,5,10,15,25,35,50,100,200];
% [C, h] = contour(x, y, f, v);
% clabel(C, h);
% grid; hold on;
% nit = 100;
% x0 = [0; 15];
% eps = 10e-7;
% % 0 for BFGS, 1 for DFP
% tic
% [x, f, n] = Quasi_Newton(@fun_obj, x0, nit, eps, 1);
% toc
% plot(x(1, :), x(2, :), 'm-d',...
%     'LineWidth', 1.5,...
%     'MarkerEdgeColor', 'b',...
%     'MarkerFaceColor', 'b');

% Rosenbrock's function
[x,y] = meshgrid(-1.5:.1:1.5, -1.5:.1:1.5);
f = x.^2 + y.^4;

[C, h] = contour(x, y, f);
clabel(C, h);
grid; hold on;
nit = 100;
x0 = [1; 1];
eps = 1e-7;
% 0 for BFGS, 1 for DFP
tic
[x, f, n] = Quasi_Newton(@errorFunction, x0, nit, eps, 1);
toc
plot(x(1, :), x(2, :), 'm-d',...
    'LineWidth', 1.5,...
    'MarkerEdgeColor', 'b',...
    'MarkerFaceColor', 'b');
