function [color] = recogniseColor(Icrop, rlow, rhigh, glow, ghigh, blow, bhigh, cButton)
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
    
    GREEN_redLowThreshold = 3;
	GREEN_redHighThreshold = 178;
	GREEN_greenLowThreshold = 58;
	GREEN_greenHighThreshold = 255;
	GREEN_blueLowThreshold = 0;
	GREEN_blueHighThreshold = 150;
   
    BLUE_redLowThreshold = 30;
    BLUE_redHighThreshold = 160;
    BLUE_greenLowThreshold = 11;
    BLUE_greenHighThreshold = 140;
    BLUE_blueLowThreshold = 40;
    BLUE_blueHighThreshold = 198;
    
    BROWN_redLowThreshold = 28;
    BROWN_redHighThreshold = 160;
    BROWN_greenLowThreshold = 0;
    BROWN_greenHighThreshold = 97;
    BROWN_blueLowThreshold = 0;
    BROWN_blueHighThreshold = 48;
    
    if(cButton == 1)
        GREEN_redLowThreshold = rlow;
        GREEN_redHighThreshold = rhigh;
        GREEN_greenLowThreshold =glow;
        GREEN_greenHighThreshold = ghigh;
        GREEN_blueLowThreshold = blow;
        GREEN_blueHighThreshold =  bhigh;
    elseif(cButton == 2)
        BLUE_redLowThreshold = rlow;
        BLUE_redHighThreshold = rhigh;
        BLUE_greenLowThreshold = glow;
        BLUE_greenHighThreshold = ghigh;
        BLUE_blueLowThreshold = blow;
        BLUE_blueHighThreshold = bhigh;
    else
        BROWN_redLowThreshold = rlow;
        BROWN_redHighThreshold = rhigh;
        BROWN_greenLowThreshold = glow;
        BROWN_greenHighThreshold = ghigh;
        BROWN_blueLowThreshold = blow;
        BROWN_blueHighThreshold = bhigh;
    end
    
    BROWN_redMask=(r > BROWN_redLowThreshold & r < BROWN_redHighThreshold);
    BROWN_greenMask=(g > BROWN_greenLowThreshold & g < BROWN_greenHighThreshold);
    BROWN_blueMask=(b > BROWN_blueLowThreshold & b < BROWN_blueHighThreshold);
    
    BLUE_redMask=(r > BLUE_redLowThreshold & r < BLUE_redHighThreshold);
    BLUE_greenMask=(g > BLUE_greenLowThreshold & g < BLUE_greenHighThreshold);
    BLUE_blueMask=(b > BLUE_blueLowThreshold & b < BLUE_blueHighThreshold);
    
    GREEN_redMask=(r > GREEN_redLowThreshold & r < GREEN_redHighThreshold);
    GREEN_greenMask=(g > GREEN_greenLowThreshold & g < GREEN_greenHighThreshold);
    GREEN_blueMask=(b > GREEN_blueLowThreshold & b < GREEN_blueHighThreshold);
    
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

end

