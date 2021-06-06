function FC_pattern = detect_fc_pattern(obj,sencitivity, PLIs)
% detect FC-patterns given sencitivity and PLI estimates
% PLI estimates must be in a matrix form (upper-right triangle must be filled in!)
% FC_pattern is a list (array) of interconnected nodes (the index in the
% array is the node index)

%% Initialization
nr_nodes   = size(PLIs,1);
FC_pattern = zeros(1, nr_nodes);

% prepare the PLI matrix
PLIs = PLIs - diag(diag(PLIs)); % reset all diagonal elements to zero
% mirror the upper-right triangle of the PLI matrix
for i1 = 1:length(PLIs)
    PLIs(i1, 1:i1) = PLIs(1:i1, i1);
end

% construct all possible pairs of nodes
%possible_pairs = nchoosek(1:nr_nodes,2);

% find a pair of nodes with the largest PLI
[m,i1] = max(PLIs);
[m,i2] = max(m);
i1 = i1(i2); % {i1, i2} is the pair of nodes with the largest PLI 

% add node i1 into the list of connected nodes
FC_pattern(i1) = true;

%% Main algorithm
stop_searching = false;

while ~stop_searching
    L_plus  = zeros(1, nr_nodes);
    L_minus = zeros(1, nr_nodes);

    for i = 1:nr_nodes
        if(~FC_pattern(i))
            % compute L+ and L- for node i to be within FC_pattern
            [L_plus(i), L_minus(i)] = ...
                compute_likelihoods(sencitivity, PLIs, FC_pattern, i);
        end
    end
    
    % choose a node with the largest L+
    [m, i] = max(L_plus);

    if (L_plus(i) <= L_minus(i))
        % stop searching
        stop_searching = true;
    else
        %add the node into the list
        FC_pattern(i) = true;
        % continue with the main part
        continue;
    end
end

% FC-pattern with only one node is not defined!
if (sum(FC_pattern) == 1)
    FC_pattern = zeros(1, nr_nodes);
end



%% Subfunctions

function [L_plus, L_minus] = compute_likelihoods(sencitivity, PLIs, FC_pattern, index)
% compute L+ likelihood for index to be connected with FC_pattern

far_right = 99;
nr_nodes = length(FC_pattern);
l_plus   = ones(1, nr_nodes);
l_minus  = l_plus;

for i=1:nr_nodes
    if (FC_pattern(i) && (index ~= i))
        mu = PLIs(index, i);

        % compute sigma for given mu
        sigma = (0.7071) * (1-mu^2); % 0.7071 = 1/sqrt(2)

        % compute cdf
        tmp1     = normcdf([0 sencitivity far_right],  mu, sigma);
        tmp2     = normcdf([0 sencitivity far_right],  -mu, sigma);%= cdf('norm', [0 sencitivity far_right], -mu, sigma);
        l_minus(i) = tmp1(2) + tmp2(2) - tmp1(1) - tmp2(1);
        l_plus(i)  = tmp1(3) + tmp2(3) - tmp1(2) - tmp2(2);
    end
end

% compute product of l_plus to obtain "joint" L_plus
%l_plus(index)  = 1;
%l_minus(index) = 1;

L_plus  = prod(l_plus); 
L_minus = prod(l_minus);


