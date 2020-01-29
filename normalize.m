function [normalized_matrix, raw_min, raw_max] = normalize( raw_matrix )
    raw_min=min(raw_matrix);
    raw_max=max(raw_matrix);
    normalized_matrix=(raw_matrix-raw_min)./(raw_max-raw_min);
end

