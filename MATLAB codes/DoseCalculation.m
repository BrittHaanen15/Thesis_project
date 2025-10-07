%Select folder with calibration data
path = uigetdir('C:\Users\bhaan','Select folder with calibration data');
cd(path)
load('Calibration_data.mat')

%Select folder with scanned films
path = uigetdir('C:\Users\bhaan','Select folder with scanned films');
cd(path)
%Extract files from folder
files = dir('*.tif');
files = extractfield(files,'name');

%Prepare matrix for calculated dose and uncertainty
OD_avg_red = zeros([1 size(files,2)]);
OD_std_red = zeros([1 size(files,2)]);

%Display first film to set ROI for analysis
figure
imagesc(imread(files{1,1}));
title("Place analysis ROI in centre of film")
pixel_size = 0.0085; %cm/pixel, obtained before
ROI_size = 1; %cm
ROI_size_pixels = ROI_size/pixel_size;
r1 = drawrectangle('Position', [0 0 ROI_size_pixels ROI_size_pixels],'InteractionsAllowed','translate');
%Wait to pass position until ROI has been confirmed with double click
wait(r1)
Pos = r1.Position;

%Display again to get ROI for dose map
figure
imagesc(imread(files{1,1}));
title("Place dose mapping ROI over entire film")
pixel_size = 0.0085; %cm/pixel, obtained before
ROI_size = 5; %cm
ROI_size_pixels = ROI_size/pixel_size;
r2 = drawrectangle('Position', [0 0 ROI_size_pixels ROI_size_pixels],'InteractionsAllowed','all');
%Wait to pass position until ROI has been confirmed with double click
wait(r2)
Pos2 = r2.Position;

%For all pictures, extract to red channel, convert to OD and find mean OD.
%Dose calculation follows from this
for i = 1:size(files,2)
    %Analysis%%%%%%%%
    %Read in each image, display with ROI for check
    figure
    image = imread(files{1,i});
    imagesc(image)
    drawrectangle('Position', Pos);
    title(['Image ' num2str(i)])

    pause(1)

    %Crop image to ROI size
    crop = imcrop(image,Pos);

    %Read out pixel values of red channel
    [PV_red,~,~] = imsplit(crop);

    %Conversion of pixel value to optical density (Micke)
    OD_red = -log10(double(PV_red)./65535);

    %Mean optical density in ROI
    OD_avg_red(:,i) = mean(OD_red,'all') - OD_control;

    %Standard deviation of optical density in ROI
    OD_std_red(:,i) = std(OD_red, 0, 'all');
    



    %Dose map%%%%%%%%%
    %Crop image to ROI size
    crop = imcrop(image,Pos2);

    %Read out pixel values of red channel
    [PV_red,~,~] = imsplit(crop);

    %Conversion of pixel value to optical density (Micke)
    OD_red = -log10(double(PV_red)./65535);

    Dosemap = fun(x, (OD_red- OD_control));
    imagesc(Dosemap)
    title(['Dose map film ' num2str(i)])
    c = colorbar;
    c.Limits = [0 10];
    c.Label.String = 'Dose (Gy)';
end

%Calculate dose
Calculated_dose = fun(x, OD_avg_red);

%Export data
T = table(transpose(files), transpose(Calculated_dose), transpose(OD_std_red), 'VariableNames',{'File','Dose (Gy)','Standard dev'});
writetable(T,'Dose calculation data.xlsx');