function [ denoise ] = noise_remove( a, rowindx, colindx )

i = size(rowindx,2); w = 3;
[row col] = size(a);
temp = zeros(row+w-1,col+w-1); 

    % zeor padding
    for ii = ceil(w/2):1:row+floor(w/2)
        for jj = ceil(w/2):1:col+floor(w/2)
            temp(ii,jj) = a(ii-floor(w/2),jj-floor(w/2));
        end
    end
    
denoise = temp;
for m = 1:i
    mask = denoise(rowindx(m):rowindx(m)+w-1,colindx(m):colindx(m)+w-1);
    denoise(rowindx(m)+floor(w/2),colindx(m)+floor(w/2)) = median(sort(mask(:)));
end

denoise = denoise(ceil(w/2):row+ceil(w/2)-1,ceil(w/2):row+ceil(w/2)-1);
end

