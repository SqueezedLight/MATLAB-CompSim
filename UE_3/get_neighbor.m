function neighbor = get_neighbor(L)
% neighbor = GET_NEIGHBOR(L)    
%     generates a field neighbor(i,nu) for all nearest neighbors on
%     a square lattice of size LxL.
%     i  = 1,2,...,L^2 are the lattice sites.
%     nu = 1,2,3,4 are the directions to the neighboring sites. 
%        
%     In the beginning of the simulation call
%     >> neighbor = get_neighbor(L);

if (not(isnumeric(L)) | L < 2) % anything else?
   error('Input parameter L does not make sense.') 
end

% labeling of sites:
%
% .   .         L^2
% .   .         .
% .   .         .
% .   .         .
% L+1 L+2 ..... 2L
% 1   2   3 ... L

neighbor=zeros(L*L,4);

for site=1:L*L    
    if mod(site,L)
        right = site+1;
    else
        right = site-L+1;
    end    
    if mod(site-1,L)
        left = site-1;
    else
        left = site+L-1;
    end
    up = site+L;
    if up > L*L
        up = up-L*L;
    end    
    down = site-L;
    if down < 1
        down = down+L*L;
    end
    neighbor(site,:)=[up,right,down,left];
end