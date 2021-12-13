function regulizationParameter = get_regularizationParameter(A, b)
%solve_optimizationProblem - calculates regularisation parameter using
%L-Curve method.
%
% Syntax:  
%    regulizationParameter = get_regularizationParameter(A, b)
%
% Inputs:
%    A                     - matrix
%    b                     - right hand side
% Outputs:
%    regulizationParameter - solution array with interesting values
[U,s,~] = csvd(A'*A);

[regulizationParameter,~,~,~] = l_curve(U,s,A'*b,'Tikh');