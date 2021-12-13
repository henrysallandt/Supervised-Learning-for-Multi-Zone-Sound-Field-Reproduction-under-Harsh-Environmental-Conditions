function set_groot()
%set_groot - prepares default text interpreter of figures to LaTeX.
%
% Syntax:  
%    set_groot()
%
% Inputs:
%
% Outputs:
%
    set(groot, 'DefaultTextInterpreter', 'LaTeX'); 
    set(groot, 'DefaultAxesTickLabelInterpreter', 'LaTeX'); 
    set(groot, 'DefaultAxesFontName', 'LaTeX'); 
    set(groot, 'DefaultLegendInterpreter', 'LaTeX'); 
    set(groot, 'DefaultTextboxshapeInterpreter', 'LaTeX')
    set(groot, 'DefaultTextarrowshapeInterpreter', 'LaTeX')
    set(groot, 'DefaultGraphplotInterpreter', 'LaTeX')
    set(groot, 'DefaultColorbarTickLabelInterpreter', 'LaTeX')
%     set(groot, 'defaultfigureposition',[40 40 600 300])
end