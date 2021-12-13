function [f, g, h] = errorFunc(X, ATF, reg, params)
%errorFunc - calculates the error, the gradient of the error and the
%hessian of the error function
%
% Syntax:  
%    [f, g, h] = errorFunc(X, ATF, reg, params)
%
% Inputs:
%    X      - input to error function
%    ATF    - acoustic transfer functions, system matrix
%    reg    - regularisation parameter
%    params - parameter structure
%
% Outputs:
%    f      - error value
%    g      - gradient of error
%    h      - hessian of error

% f = (1 - X(1))^2 + 10 * (X(2) - X(1)^2)^2;
% g = [2*X(1) - 40*X(1)*(- X(1)^2 + X(2)) - 2; 20 * (X(2) - X(1)^2)];
% h = [120*X(1)^2 - 40*X(2) + 2, -40*X(1);
%     -40*X(1), 20];

% f = X(1).^2 + X(2).^4 + 1;
% h = 0.001;
% g = [((X(1)+h).^2 - (X(1)-h).^2)/(2*h); ((X(2)+h).^4 - (X(2)-h).^4)/(2*h)];
% h = eye(2);


n  = length(X);
n2 = round(n/2);

errorFunction = @(X) sum(abs(ATF*(X(1:n2,:) + 1i*X(n2+1:end,:))-params.solve.micGoal).^2,1) + (reg*vecnorm(X(1:n2,:) + 1i*X(n2+1:end,:))).^2;

f = errorFunction(X);
h = 0.00001;
g = ((errorFunction(X+h*eye(n)) - errorFunction(X-h*eye(n)))/(2*h))';
% g = g(1:n2) + 1i*g(n2+1:end);
h = eye(n);
