function [] = createMap(soil_moisture,lat,long)

    
    %Makes latitude and longitude matrix a 1 dimension matrix.
    lat = lat(1,:);
    long = long(:,1);
    long = long';
    
    %Finds the minimum and maximum of the latitude and longitude
    latRange = [min(lat(:)), max(lat(:))];
    longRange = [min(long(:)),max(long(:))];

    %creates a meshgrid from the latitude and longitude values
    [lat,long] = meshgrid(lat,long);
    %Creates the world map given the range
    ax = worldmap(latRange, longRange);

    %Displays the soil moisutre
    geoshow(lat,long,soil_moisture, 'displaytype', 'texturemap');
    setm(ax,'mlabelparallel',-80)

    %general house keeping
    oldcmap = colormap;
    oldcmap(64,:) = 0.45;
    colormap( flipud(oldcmap) );
    cbh = colorbar('southoutside','FontSize',12);
    caxis([0 0.65])
    set(cbh,'YTick',[0:0.05:0.65]);
    
    %Borders
    bordersm('countries','k')
    


    ylabel(cbh,'Soil Moisture [m^3 m^-3]');
end

