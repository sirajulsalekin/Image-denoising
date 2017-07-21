function [ denoise ] = noise_detection( a, s, type, theta )
% Effective impulse detector based on rank-order criteria
% Aizenberg, I. ; Univ. Dortmund, Germany ; Butakoff, C.

    [row col] = size(a);
    temp = zeros(row+2,col+2);
    
    % zeor padding
    for ii = 2:1:row+1
        for jj = 2:1:col+1
            temp(ii,jj) = a(ii-1,jj-1);
        end
    end
    
    denoise = zeros(row,col);
    a = temp;    N = 9; 
    
        for i = 2:1:row+1
            for j = 2:1:col+1
                   
%                window = a(i-1:i+1,j-1:j+1);
                window = [a(i-1,j-1) a(i-1,j) a(i-1,j+1) ...
                          a(i,j-1) a(i,j) a(i,j+1)  ...
                          a(i+1,j-1) a(i+1,j) a(i+1,j+1)];
          
                    var_series = sort(window);
                    median = var_series(5);
                    rank = find(var_series==window(5));
                    ranksize = size(rank,2);
                        
                        if window(5) > median
                            d = abs(window(5) - var_series(rank(1)-1));
                            elseif window(5) < median
                            d = abs(window(5) - var_series(rank(1)+ranksize));
                            else d = 0;
                        end
                       
                        switch type
                            case 'sqr'
                                
                        if (((rank(1) <= s) || (rank(ranksize) >= N-s+1)) && (d >= theta))                                                         
                            denoise(i-1,j-1) = median; 
                            else denoise(i-1,j-1) = a(i,j);
                        end
                        
                            case 'v'
                        if ((rank(ranksize) >= N-s+1) && (d >= theta))                                                         
                            denoise(i-1,j-1) = median; 
                            else denoise(i-1,j-1) = a(i,j);
                        end  
                        
                            case 'h'
                        if ((rank(1) <= s) && (d >= theta))                                                         
                            denoise(i-1,j-1) = median; 
                            else denoise(i-1,j-1) = a(i,j);
                        end 
                        end
                        
                        %{
                            % denoising
                            switch type
                                case 'v'
                                   a1 = sort(a(i,j-1:j+1));
                                   denoise(i-1,j-1) = a1(2);
  %                                 denoise(i-1,j-1) = median;

                                case 'h'
                                   a1 = sort(a(i-1:i+1,j));
                                   denoise(i-1,j-1) = a1(2);
                                   
                                case 'd'
                                   a1 = [a(i-1,j-1) a(i+1,j-1) a(i,j) a(i-1,j+1) a(i+1,j+1)];
                                   a2 = sort(a1);
                                   denoise(i-1,j-1) = a2(3);
%                                   denoise(i-1,j-1) = median;
                                   
                                case 'sqr'
                                   denoise(i-1,j-1) = median; 
                            end
                            
                            else denoise(i-1,j-1) = a(i,j);   
                        end                         
                       %} 
            end  
        end
    
end

