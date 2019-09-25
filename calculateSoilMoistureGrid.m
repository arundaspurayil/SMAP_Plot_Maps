function[soil_moisture, lat,long] = calculateSoilMoistureGrid(filesToCompute,variable)
    
    fileName = string(filesToCompute(1));

    %Creates a matrix of all the latitude values
    lat = h5read(fileName,'/Soil_Moisture_Retrieval_Data_AM/latitude');
    %Creates a matrix of all the longitude values
    long = h5read(fileName,'/Soil_Moisture_Retrieval_Data_AM/longitude');
    
    %Creates a 3 dimensional NaN matrix. First dimension corresponds to the
    %latitude, 2nd dimension corresponds to latitude, and third dimension
    %corresponds to the day.
    lat_all = NaN(size(long,1),size(long,2),length(filesToCompute));
    long_all = NaN(size(long,1),size(long,2),length(filesToCompute));
    soil_moisture_all = NaN(size(long,1),size(long,2),length(filesToCompute));
    

    for x=1:length(filesToCompute)
        fileName = string(filesToCompute(x));
        
        %Gets the latitude matrix for 1 given day and replaces all -9999
        %values with NaN values.
        lat_specific = h5read(fileName,'/Soil_Moisture_Retrieval_Data_AM/latitude');
        lat_specific(find(lat_specific == -9999)) = NaN;
        
        %Gets the longitude matrix for 1 given day and replaces all -9999
        %values with NaN values.
        long_specific = h5read(fileName,'/Soil_Moisture_Retrieval_Data_AM/longitude');
        long_specific(find(long_specific == -9999)) = NaN;
        
        %Gets the soil moisutre matrix for 1 given day and replaces all -9999
        %values with NaN values.
        soil_moisture_specific = h5read(fileName,strcat('/Soil_Moisture_Retrieval_Data_AM/',variable));
        soil_moisture_specific(find(soil_moisture_specific == -9999)) = NaN;

        %Layers each matrix to the 3D matrix which contains all values.
        lat_all(:,:,x) = lat_specific;
        long_all(:,:,x) = long_specific;
        soil_moisture_all(:,:,x) = soil_moisture_specific;
        
       
    end
    %Calculates averages
    lat = nanmean(lat_all,3);
    long = nanmean(long_all,3);
    soil_moisture = nanmean(soil_moisture_all,3);
    %For standard deviation
    %soil_moisture = nanstd(soil_moisture_all,0,3);
end
