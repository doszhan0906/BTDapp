function [current_bbx, centroid] = find_fluid_box(current_bbx, Img_cur, alfa)

if current_bbx(3)*current_bbx(4) / 2 > 50 
    Img_cur =  bwareaopen(Img_cur, 50);    
else
    Img_cur =  bwareaopen(Img_cur, 10);
end

% imbw = im2bw(Img_cur);
imLabel = bwlabel(Img_cur);
stat = regionprops(imLabel, 'BoundingBox');   
bbx = vertcat(stat.BoundingBox);
stats = regionprops(imLabel, 'Area');
area = cat(1, stats.Area);
s = regionprops(imLabel, 'Centroid');
% set BoundingBox rectangle
if current_bbx(1) - 20 >= 0 
    fb_x = current_bbx(1) - alfa*10;
else 
    fb_x = 0.1;
end

if current_bbx(2) - 20 >= 0 
    fb_y = current_bbx(2) - alfa*10;
else 
    fb_y = 0.1;
end

if (current_bbx(3) + current_bbx(1)) + 20   < 512 
    fb_w = current_bbx(3) + current_bbx(1) + alfa*10;
else 
    fb_w = current_bbx(3) + current_bbx(1) ;
end

if (current_bbx(2) + current_bbx(4)) + 20 < 1024 
    fb_h = current_bbx(2) + current_bbx(4) + alfa*10;
else 
    fb_h = current_bbx(2) + current_bbx(4);
end

area_index = -1; 
 i = 1;
 [N,M] = size(area);
 
  while i <= N        
        bx_x = bbx(i,1);
        bx_y = bbx(i,2);
        bx_w = bbx(i,1) + bbx(i,3);
        bx_h = bbx(i,2) + bbx(i,4);
        
        if fb_w >= bx_w && fb_h >= bx_h && fb_x <= bx_x && fb_y <= bx_y            
            if area_index == -1 
                area_index = i;                
            else
                if area(i) > area(area_index)  
                    area_index = i;
                end                   
            end                  
        end                             
     i = i+1;
  end
    
      if area_index == -1
      current_bbx = -1;       
      centroid = -1;
      else
      current_bbx = bbx(area_index,:);
      centroid = s(area_index,:);
      end
