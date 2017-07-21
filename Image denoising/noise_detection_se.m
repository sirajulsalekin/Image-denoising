function [ denoise, rowindx, colindx ] = noise_detection_se( a, s, type, theta, w )
% Effective impulse detector based on rank-order criteria
% Aizenberg, I. ; Univ. Dortmund, Germany ; Butakoff, C.

    [row col] = size(a);
    temp = zeros(row+w-1,col+w-1); 

    % zeor padding
    for ii = ceil(w/2):1:row+floor(w/2)
        for jj = ceil(w/2):1:col+floor(w/2)
            temp(ii,jj) = a(ii-floor(w/2),jj-floor(w/2));
        end
    end
    
    denoise = zeros(row,col);
    a = temp; N = w*w; med = ceil((w*w)/2); indx = 1;  
      
        for i = ceil(w/2):1:row+floor(w/2)
            for j = ceil(w/2):1:col+floor(w/2)
                   
              window = a(i-floor(w/2):i+floor(w/2),j-floor(w/2):j+floor(w/2));
          
                    var_series = sort(window(:));
                    median = var_series(med);
                    rank = find(var_series==window(med));
                    ranksize = size(rank,1);                   
                    
              switch type
                  case 'HH'
                        if window(med) > median
                            d = abs(window(med) - var_series(rank(1)-2));
                            %elseif window(med) < median
                            %d = abs(window(med) - var_series(rank(1)+ranksize));
                            else d = 0;
                        end
                        
                        if (((rank(ranksize) >= N-s+1)) && (d >= theta))
                            denoise(i-floor(w/2),j-floor(w/2)) = median;
                            rowindx(indx) = i-floor(w/2);
                            colindx(indx) = j-floor(w/2);
                            indx = indx + 1;
                        else denoise(i-floor(w/2),j-floor(w/2)) = a(i,j);
                        end 
                 
                  case 'LL'
                        if window(med) > median
                            d = abs(window(med) - var_series(rank(1)-1));
                            elseif window(med) < median
                            d = abs(window(med) - var_series(rank(1)+ranksize));
                            else d = 0;
                        end
                        
                        if (((rank(1) <= s) || (rank(ranksize) >= N-s+1)) && (d >= theta))
                            denoise(i-floor(w/2),j-floor(w/2)) = median; 
                            rowindx(indx) = i-floor(w/2);
                            colindx(indx) = j-floor(w/2);
                            indx = indx + 1;
                        else denoise(i-floor(w/2),j-floor(w/2)) = a(i,j);
                        end 
                        
                  case 'LH'
                        if window(med) < median
                             d = abs(window(med) - var_series(rank(1)+ranksize));
                            else d = 0;
                        end
                        
                        if ((rank(1) <= s) && (d >= theta))
                            %denoise(i-floor(w/2),j-floor(w/2)) = median;
                            rowindx(indx) = i-floor(w/2);
                            colindx(indx) = j-floor(w/2);
                            indx = indx + 1;
                        else denoise(i-floor(w/2),j-floor(w/2)) = a(i,j);
                        end 
                      
              end
                        
                        
            end  
        end
    
end

