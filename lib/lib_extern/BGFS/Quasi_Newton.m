function [x, f, n] = Quasi_Newton(ATF, fun, x0, nit, eps, reg, method, params)
%Quasi_Newton - solves the system of equations using the BFGS method
%
% Syntax:  
%    [x, f, n] = Quasi_Newton(ATF, fun, x0, nit, eps, reg, method, params)
%
% Inputs:
%    ATF    - matrix of acoustic transfer functions (system matrix)
%    fun    - function to calculate gradient and hessian
%    x0     - initial guess
%    nit    - number of iterations
%    eps    - interruption criterion
%    reg    - regularisation parameter
%    params - parameter structure
%
% Outputs:
%    x      - solution
%    f      - residual
%    n      - number of iterations
%
%    Copyright (c) 2019 Omar-Belghaouti (minor changes to make it
%    compatible with the code by J. Henry Sallandt)
x(:, 1) = x0;
rho     = 0.4;
b       = 0.8;
% First approximation for H matrix
[~, ~, h] = fun(x(:, 1),ATF,reg,params);
H_old     = eye(length(h));
for i=1:nit
    % Update descent direction
    [~, g, ~] = fun(x(:, i),ATF,reg,params);
    dk        = -inv(H_old) * g;
    % Searching for optimal step by Armijo's method
    a     = 1;
    x_new = x(:, i) + a * dk;
    f_new = fun(x_new,ATF,reg,params);
    f     = fun(x(:, i),ATF,reg,params);
    while f_new > f + rho * a * g' * dk
        a     = a * b;
        x_new = x(:, i) + a * dk;
        f_new = fun(x_new,ATF,reg,params);
    end
    % Update x
    x(:, i+1) = x_new;
    if(norm(dk) < eps)
        break;
    end
    % Update H_old
    [~, g_k, ~]   = fun(x(:, i),ATF,reg,params);
    [~, g_k_1, ~] = fun(x(:, i+1),ATF,reg,params);
    yk = g_k_1 - g_k;
    sk = x(:, i+1) - x(:, i);
    if method == 0 % BFGS method
        H_new = H_old + (yk*yk')/(yk'*sk) - (H_old*(sk)*sk'*H_old)/(sk'*H_old*sk);
    elseif method == 1 % DFP method
        B_old = inv(H_old);
        B_new = B_old + (sk*sk')/(yk'*sk) - (B_old*(yk)*yk'*B_old)/(yk'*B_old*yk);
        H_new = inv(B_new);
    else
        error('Error using function');
    end
    if any(isnan(H_new))
        warning('H_new is nan! Breaking out of the loop.')
        break
    end
%     keyboard
    H_old = H_new;
end
n = i;
f = fun(x(:, end),ATF,reg,params);
