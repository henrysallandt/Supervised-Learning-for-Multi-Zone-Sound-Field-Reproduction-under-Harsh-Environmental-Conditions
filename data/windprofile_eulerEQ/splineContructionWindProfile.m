% close all

y_log = linspace(0, 8, 20);
y_ref = linspace(0, 8, 2000);

% M = 0.04;
% u = M*343;
% % 2m over the ground there is a wind speed of Ma=0.04
% u_star = 0.04*343 / log((2.25+0.3)/0.3);

M = 1/343;
u = M*343;
% 2m over the ground there is a wind speed of Ma=0.04
u_star = M*343 / log((2.25+0.3)/0.3);

u_log  = u_star * log(max((y_log -( 2.25) + 0.3) / 0.3,1));
y_index_log = find(u_log~= 0);

r = 0.5;
y_0 = -2.25 - r + 0.1485 + 4.25;
y_circ = linspace(y_0 + 0.4*r , y_0 + r, 7);
u_circ = -sqrt(r^2 - (y_circ - y_0).^2) + r;

y_lin = linspace(0, y_0 + 0.2*r, 5);
u_lin = (y_lin - y_0 + 0.2*r) * (u_circ(1)*0.95) / (y_0 + 0.2*r - 0) + u_circ(1)*0.95;

clf
plot( y_log, u_log )
hold on
plot( y_circ, u_circ)
plot( y_lin, u_lin )

plot( y_ref, spline([y_lin y_circ y_log(y_index_log)], [u_lin u_circ u_log(y_index_log)], y_ref), 'r.', 'LineWidth',3)

spline = spline([y_lin y_circ y_log(y_index_log)], [u_lin u_circ u_log(y_index_log)]./u);

% r = 0.5;
% z_0 = 0.3;
% y_g = 0;
% y_0 = -r+0.1 - 0.0915;
% 
% y = linspace(-0.5, 3, 2001);
% u_star = 0.04*343 / log((2+z_0)/z_0);
% u_log = u_star * log(max((y -( 0) + z_0) / 0.3,1));
% d_u_log = real(u_star * z_0 ./ (max(y - y_g,0) + z_0));
% d_u_log(d_u_log == u_star) = Inf;
% u_circ = -sqrt(r^2 - (y - y_0).^2) + r;
% d_u_circ = real(-0.5 * 1 ./ sqrt(r^2 - (y - y_0).^2) .* (-2*y + 2*y_0));
% figure
% subplot(2,1,1)
% plot(u_log, y)
% hold on
% plot(u_circ, y)
% 
% subplot(2,1,2)
% plot(d_u_log, y)
% hold on
% plot(d_u_circ, y)
