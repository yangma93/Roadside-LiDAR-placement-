function points = uniformKnots (ncs,delta_t,w)
% ncs refers to the output of cscvn(.)
points = [];
d_res = 0;
for i=1:1:ncs.pieces
    T = ncs.breaks(i+1) - ncs.breaks(i);
    x = ppmak([0 T],ncs.coefs(2*i-1,:));
    y = ppmak([0 T],ncs.coefs(2*i,:));
    % points = [points;ppval(x,0) ppval(y,0)];
    t = 0:delta_t:T;
    p1 = [ppval(x,t(end)) ppval(y,t(end))];
    p2 = [ppval(x,T) ppval(y,T)];
    % p1 and p2 are last two points with gap less than delta_t
    g = @(p) ncs.coefs(2*i-1,1)*3*p.^2 + ncs.coefs(2*i-1,2)*2*p + ...
        ncs.coefs(2*i-1,3);
    f = @(p) ncs.coefs(2*i,1)*3*p.^2 + ncs.coefs(2*i,2)*2*p + ...
        ncs.coefs(2*i,3);
    s = sqrt(f(t).^2 + g(t).^2) * delta_t;
    num = length(t)-1;
    lengthOfNcs = sum(s(1:end-1)) + norm(p1-p2);
    remOft = rem(lengthOfNcs + d_res,w);
    delta_d = 0;
    for  j = 1:1:num
        delta_d = delta_d + s(j);
        indicator = sign(delta_d - (w-d_res));
        lengthOfNcs = lengthOfNcs  - s(j);
        if  indicator >= 0
            points = [points;ppval(x,t(j+1)) ppval(y,t(j+1))]; %#ok<*AGROW>
            delta_d = 0;
            d_res = 0;
        else 
            continue;
        end
        if lengthOfNcs <= remOft
            d_res = lengthOfNcs;
            break
        end  
    end
end
end

