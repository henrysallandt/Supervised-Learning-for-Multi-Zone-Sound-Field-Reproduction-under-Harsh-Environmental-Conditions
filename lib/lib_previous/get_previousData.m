function [nets, sol, params] = get_previousData(params)
%get_previousData - loads data from previous runs if desired.
%
% Syntax:  
%    [nets, sol, params] = get_previousData(params)
%
% Inputs:
%    params - parameter structure
%
% Outputs:
%    nets   - neural network cell array / dummy variable if no read in
%    sol    - structure containing solution values
%    params - parameter structure

if strcmp(params.menu.switch_transferFunctionNetSource, 'readIn')
    disp('loading previously created data...')
    load([params.save.netsPath params.load.netName], 'nets')
    params.geom = nets{1,1}.paramsLearn.geom;
else
    nets = true;
end
sol = struct;

