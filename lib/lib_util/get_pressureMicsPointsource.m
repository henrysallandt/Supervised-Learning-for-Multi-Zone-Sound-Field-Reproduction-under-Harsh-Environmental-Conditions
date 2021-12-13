function [data] = get_pressureMicsPointsource(mic, src, t, c, Ma, dim)
%get_pressureMicsPointsource - calculates the pressure of several point
%sources at several microphone positions for several time steps
%
% Syntax:  
%    [data] = get_pressureMicsPointsource(mic, src, t, c, Ma, dim, windProfileFunc)
%
% Inputs:
%    mic             - microphone structure
%    src             - source structure
%    t               - time steps to evaluate
%    c               - speed of sound
%    Ma              - Mach number
%    dim             - number of dimensions ('2D' / '3D')
%    windProfileFunc - wind profile function (only use uniform flow)
%
% Outputs:
%    ampsNSE       - measured amplitudes of speakers
%    phasesNSE     - measured phases of speakers
%    errNSE        - mean square error of the sinus approximation
%    freqs         - used frequencies
%    Mas           - used Mach numbers


%% init
% sig_out = zeros(length(t), length(mic.x));

c2      = c^2;
Ma2      = Ma^2;

% reshape stuff
src.x     = reshape(src.x    , [], 1 , 1 );
src.y     = reshape(src.y    , [], 1 , 1 );
src.freqs = reshape(src.freqs, [], 1 , 1 );
src.amps  = reshape(src.amps , [], 1 , 1 );
src.phase = reshape(src.phase, [], 1 , 1 );
mic.x     = reshape(mic.x    , 1 , [], 1 );
mic.y     = reshape(mic.y    , 1 , [], 1 );
t         = reshape(t        , 1 , 1 , []);


omega   = 2*pi*src.freqs;
%                                pi/2 because of natural phase shift due to
%                                PDE
timeShiftDuePhase = (src.phase - pi/2)./(omega);
% timeShiftDuePhase = (src.phase - 0)./(omega);
t = t + timeShiftDuePhase;


fx = src.amps;

switch dim
    case '2D'
        Rw = sqrt((mic.x - src.x).^2+(1-Ma2)*(mic.y - src.y).^2);
        G = 1i/4 * 1./(c2*sqrt(1-Ma2)) * besselh(0,1,max(omega/c.*Rw/(1-Ma2),eps)).* exp(-1i*Ma/(1-Ma2)*omega.*(mic.x - src.x)/c - 1i*omega.*t);
        data = squeeze(sum(real(G.*fx),1))';
            
%         % for aquivalence of the source term with the Euler equations
%         dGdt_part = omega/(4*c2*sqrt(1-M2)) .* besselh(0,1,max(omega/c.*Rw/(1-M2),eps)) .* exp(-1i*Ma/(1-M2)*omega.*(mic.x - src.x)/c - 1i*omega.*t);
%         u0_dGdx_part = Ma*omega/(4*c2*sqrt(1-M2)*(1-M2)) .* exp(-1i*Ma/(1-M2)*omega.*(mic.x - src.x)/c - 1i*omega.*t) .* ...
%             (-1i*(mic.x - src.x)./max(Rw,eps) .* besselh(1,1,max(omega/c.*Rw/(1-M2),eps)) + Ma * besselh(0,1,max(omega/c.*Rw/(1-M2),eps)));
%         dGdt = dGdt_part + u0_dGdx_part;
%         data = squeeze(sum(real(dGdt.*fx),1))';
    case '3D'
        tauM = -1/c * ((mic.x-src.x)*Ma - sqrt((mic.x-src.x).^2 + (1-Ma^2)*(mic.y-src.y).^2))/(1-Ma^2);
        tauP = -1/c * ((mic.x-src.x)*Ma + sqrt((mic.x-src.x).^2 + (1-Ma^2)*(mic.y-src.y).^2))/(1-Ma^2);
        G = 0;
        if tauM >= 0
            G = G + exp(-1i*omega.*t).*exp(1i*omega.*tauM)./(sqrt(((mic.x-src.x)-Ma*c*tauM).^2+(mic.y-src.y).^2));
        end
        if tauP >= 0
            G = G + exp(-1i*omega.*t).*exp(1i*omega.*tauP)./(sqrt(((mic.x-src.x)-Ma*c*tauP).^2+(mic.y-src.y).^2));
        end

        data = squeeze(sum(real(G.*fx),1))';
%         keyboard
    otherwise
        error('wrong params.geom.switch_numberDimensions!')
end

