function [output] = weightedmed(a, region)
%% weighted median filter on image with salt & pepper noise %%
output = a;
[row col] = size(a);
for x = 2:1:row-1
    for y = 2:1:col-1
%% To make a 3x3 weighted mask into a 1x9 mask
if (region=='c')
a1 = [a(x-1,y-1) 0 a(x-1,y+1) ...
      a(x,y-1) a(x,y-1) a(x,y-1) 0 a(x,y+1) a(x,y+1) a(x,y+1)  ...
      a(x+1,y-1) 0 a(x+1,y+1)];
  
    a2 = sort(a1);
    med = a2(8);
    
elseif (region=='r') 
a1 = [a(x-1,y-1) a(x-1,y) a(x-1,y) a(x-1,y) a(x-1,y+1) ...
      0 0 0  ...
      a(x+1,y-1) a(x+1,y) a(x+1,y) a(x+1,y) a(x+1,y+1)];

    a2 = sort(a1);
    med = a2(8);
    
elseif (region=='v')
    a1 = [a(x,y-3) a(x,y-2) a(x,y-1) a(x,y) a(x,y+1) a(x,y+2) a(x,y+3)];
    a2 = sort(a1);
    med = a2(4);
    
elseif (region=='h')
    a1 = [a(x-3,y) a(x-2,y) a(x-1,y) a(x,y) a(x+1,y) a(x+2,y) a(x+3,y)];
    a2 = sort(a1);
    med = a2(4);
    
else (region=='d');
    a1 = [a(x-1,y-1) a(x+1,y-1) a(x,y) a(x-1,y+1) a(x+1,y+1)];
    a2 = sort(a1);
    med = a2(3);
    
end

output(x,y) = med;

    end
end

end