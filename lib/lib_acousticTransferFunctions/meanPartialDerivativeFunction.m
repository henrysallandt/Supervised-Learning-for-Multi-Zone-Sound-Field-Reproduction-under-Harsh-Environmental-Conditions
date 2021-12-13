function derivative = meanPartialDerivativeFunction(phases, k)
% keyboard
possibleDerivatives = reshape([((phases(2:end, :) - phases(1:end-1, :)       ) ./ (k(2:end) - k(1:end-1))),...
                               ((phases(2:end, :) - phases(1:end-1, :) + 2*pi) ./ (k(2:end) - k(1:end-1))),...
                               ((phases(2:end, :) - phases(1:end-1, :) - 2*pi) ./ (k(2:end) - k(1:end-1)))],size(phases,1)-1,size(phases,2),3);

whereTrueDerivatives = min(abs(possibleDerivatives),[],3) == abs(possibleDerivatives);

possibleDerivatives(~whereTrueDerivatives) = nan;

derivative = mean(max(possibleDerivatives,[],3),1);

end