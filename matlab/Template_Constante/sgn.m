function [ symbol ] = sgn( i )
% Fonction sgn pour obtenir le signe de la force Fk

if i < 0 
    symbol = -1;
elseif i == 0
    symbol = 0;
else
   symbol = 1;
end
end

