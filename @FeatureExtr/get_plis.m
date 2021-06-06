function [plis] = get_plis(obj, FC_pattern, PLI, pairs)
% returns a list of PLI's for interconnected nodes/electrodes/sensors
% returns zeros if not interconnected

plis = zeros (size(PLI));
for pair_index = 1:size(pairs,1)
    if (FC_pattern(pairs(pair_index,1)))
        if (FC_pattern(pairs(pair_index,2)))
            % we are here if both nodes are inter-connected
            plis(pair_index) = PLI(pair_index);
        end
    end
end
                