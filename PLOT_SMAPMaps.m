clc
close all
clear all

addpath('./');

%%USER INPUT
startDate=20150825;
endDate = 20150827;

%Folder containing the datset
parentFolderName = 'SMAP_L3_Soil_Moisture_9x9';

%Name of the output figure
outputMapName = 'SMAP L3 36km Soil Moisture';

%Variable to create the world map from
variable = 'soil_moisture';

addpath(strcat('./',parentFolderName));
H5_ParentFolder = dir(strcat('./',parentFolderName));
cnt = 1;
%Iterates through the entire dataset
for xy=1:length(H5_ParentFolder)
    %If cnt is equal to number of days in the range given then the program
    %can stop and not iterate through the rest of the dataset.
    if(cnt == (endDate - startDate+2))
        break;
    end
    %The first two indexes in a File object is . and .. which we don't
    %want.
    if(~contains(H5_ParentFolder(xy).name,'.'))
        %Creates a File object which iterates through the subset folders
        Files = dir(strcat('./',parentFolderName,'/',H5_ParentFolder(xy).name));
        for yy=1:length(Files)
            %Makes sure it is an SMAP .h5 file
            if(contains(Files(yy).name, 'SMAP')&&~contains(Files(yy).name,'.xml'))
                fileNameNumber = extractBetween(Files(yy).name,14,21);
                
                %Checks to see if the .h5 file is within the data range
                if((str2double(fileNameNumber) >= startDate) && (str2double(fileNameNumber)<=endDate))
                    addpath(strcat('./',parentFolderName,'/',H5_ParentFolder(xy).name));
                    
                    %Adds the .h5 file to the files that need to be
                    %analyzed.
                    filesToCompute{cnt} = Files(yy).name;
                        cnt = cnt+1;
                end
            end
        end
    end      
end

 
figure(1)
[soil_moisture,lat,long]=calculateSoilMoistureGrid(filesToCompute,variable);    
createMap(soil_moisture,lat,long);

tempTitle = sprintf('%s Average Soil Moisture from %d to %d', outputMapName, startDate, endDate);
title(tempTitle);

saveas(figure(1),outputMapName);

% close all;