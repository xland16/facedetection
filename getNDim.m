function [x_l, x_h, y_l, y_h] = getNDim(x,y,x_max,y_max,xsize,ysize)
    %Returns the point locations defining a point's neighborhood
    x_l = x - xsize;
	x_h = x + xsize;
	y_l = y - ysize;
	y_h = y + ysize;
        
    if x_l < 1
        x_l = 1;
    end
    if y_l < 1
        y_l = 1;
    end
    if x_h > x_max
        x_h = x_max;
    end
    if y_h > y_max
        y_h = y_max;
    end
end