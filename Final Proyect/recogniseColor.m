function [color] = recogniseColor(Icrop, colorThreshold, cButton)
    %recogniseColor Determine the color of one eye picture
    %   Input:
    %       Icrop- cropped image of the eye
    %       center- coordenades of eye's center
    %       radii- lenght of eye's radius
    %   
    %   Output:
    %   This function returns the following codification:
    %   Color={ Green=1, Blue=2, Brown=3, Unrecognized=-1 }
    %   
    %%%
    %Octavio Sales
    %19-Jun-2019
    %%%
    
    r=Icrop(:,:,1);
    g=Icrop(:,:,2);
    b=Icrop(:,:,3);
    
    
    GREEN_redMask=(r > colorThreshold(1,1) & r < colorThreshold(1,2));
    GREEN_greenMask=(g > colorThreshold(1,3) & g < colorThreshold(1,4));
    GREEN_blueMask=(b > colorThreshold(1,5) & b < colorThreshold(1,6));
    
    BLUE_redMask=(r > colorThreshold(2,1) & r < colorThreshold(2,2));
    BLUE_greenMask=(g > colorThreshold(2,3) & g < colorThreshold(2,4));
    BLUE_blueMask=(b > colorThreshold(2,5) & b < colorThreshold(2,6));
    
    BROWN_redMask=(r > colorThreshold(3,1) & r < colorThreshold(3,2));
    BROWN_greenMask=(g > colorThreshold(3,3) & g < colorThreshold(3,4));
    BROWN_blueMask=(b > colorThreshold(3,5) & b < colorThreshold(3,6));
    
    green= (GREEN_redMask & GREEN_greenMask & GREEN_blueMask);
    blue= (BLUE_redMask & BLUE_greenMask & BLUE_blueMask);
    brown= (BROWN_redMask & BROWN_greenMask & BROWN_blueMask);
    
    
    if(sum(sum(green))> sum(sum(blue)) && sum(sum(green)) > sum(sum(brown)))
        color=1;
    elseif(sum(sum(blue))> sum(sum(green)) && sum(sum(blue)) > sum(sum(brown)))
        color=2;
    elseif(sum(sum(brown)) > sum(sum(green)) && sum(sum(brown)) > sum(sum(blue)))
        color=3;
    else
        color=-1;
    end
    f2= figure('Name', 'Brown Color Map','NumberTitle','off');
    f3= figure('Name','Blue Color Map','NumberTitle','off');
    f4= figure('Name','Green Color Map','NumberTitle','off');
    num=(sum(sum(brown)));
    total=(size(green,1)*size(brown,1));
    figure(f2);
    pcolor(brown);
    colormap jet
    axis ij
    title('Brown Color Map');
    legend([ 'Total brown pixels: ', num2str(num), ' / ', num2str(total)], 'Location', 'south');
    colorbar;
    figure(f3);
    num=(sum(sum(blue)));
    pcolor(blue);
    colormap cool
    axis ij
    title('Blue Color Map');
    legend([ 'Total blue pixels: ', num2str(num), ' / ', num2str(total)], 'Location', 'south');
    colorbar;
    figure(f4);
    num=(sum(sum(green)));
    pcolor(green);
    colormap prism
    axis ij
    title('Green Color Map');
    legend([ 'Total green pixels: ', num2str(num), ' / ', num2str(total)], 'Location', 'south');
    colorbar;
end



