%Create calibration curve from set of calibration films. Plots all values
%in a figure. Then calculates best fit parameters and uses these to create
%calibration curve.

%Get doses
Doses = input('Specify doses as vector\n');
repeat = input('How many duplicates per dose level?\n');
Doses = repelem(Doses,repeat);

%Extract files from folder
path = uigetdir('C:\Users\bhaan','Select folder with calibration files');
cd(path)
files = dir('*.tif');
files = extractfield(files,'name');

%Prepare matrix for optical densities
OD_avg_red = zeros([1 size(files,2)]);
OD_std_red = zeros([1 size(files,2)]);

%Display first film to select ROI on which the calibration is carried out
figure
imagesc(imread(files{1,23}));
pixel_size = 0.0085; %cm/pixel, obtained before
ROI_size = 1; %cm
ROI_size_pixels = ROI_size/pixel_size;
r1 = drawrectangle('Position', [0 0 ROI_size_pixels ROI_size_pixels],'InteractionsAllowed','translate');
%Wait to pass position until ROI has been confirmed with double click
wait(r1)
Pos = r1.Position;

%For all pictures, extract to red channel, convert to OD and find mean OD
for i = 1:size(files,2)

    %Read in each image, display with ROI for check
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
    OD_avg_red(:,i) = mean(OD_red,'all');

    %Standard deviation of optical density in ROI
    OD_std_red(:,i) = std(OD_red, 0, 'all');
end

%Correct optical densities to net optical density (AAPM)
OD_control = mean(OD_avg_red(:,1:repeat),'all');
OD_avg_red = OD_avg_red(:, (repeat+1):end) - OD_control;
Doses = Doses(:,(repeat+1):end);
OD_std_red = OD_std_red(:,(repeat+1):end);

%Plot optical density data
figure
errorbar(OD_avg_red, Doses, 0.02*Doses, 0.02*Doses, OD_std_red, OD_std_red,'o','MarkerSize', 2, 'MarkerFaceColor','b');
title('Dose as function of net optical density (red channel)')
xlabel('OD')
ylabel('Dose (Gy)')
hold on

%Perform curve fit (Delmon)
nvalues = 0.5:0.5:5;
Rvalues = zeros(size(nvalues));
for i = 1:size(nvalues,2)
    n = nvalues(i);

    %Fit curve
    fun = @(x,OD_avg_red) x(1)*OD_avg_red + x(2)*((OD_avg_red).^n);
    x = nlinfit(OD_avg_red, Doses, fun, [1 1]);

    txt1 = ['OD = ' num2str(round(x(1),3)) 'OD + ' num2str(round(x(2),3)) '(OD)^' num2str(n)];
    sprintf(txt1)

    %Calculate R^2
    R2 = 1 - sum((Doses - fun(x,OD_avg_red)).^2)/sum((Doses - mean(Doses)).^2);
    Rvalues(i) = abs(R2);

end

%Find optimal n
[~,I] = max(Rvalues);
n = nvalues(I);

%Refit with optimal n
fun = @(x,OD_avg_red) x(1)*OD_avg_red + x(2)*(OD_avg_red).^n;
[x,residuals,~,CovB,~,ErrorModelInfo] = nlinfit(OD_avg_red, Doses, fun, [1 1]);

%Plot calibration curve
ods = 0:0.01:round(max(OD_avg_red),1);
dose_model = fun(x,ods);
plot(ods, dose_model)

%Return calibration relation
txt1 = ['D = ' num2str(round(x(1),3)) 'OD + ' num2str(round(x(2),3)) '(OD)\^(' num2str(n) ')'];
txt2 = ['R2 = ' num2str(round(R2,2))];
txt = {txt1, txt2};
text(0.1,3,txt)

%Confidence interval of parameters
ci = nlparci(x, residuals, "Covar", CovB);
pm = transpose(x) - ci(:,1);
plusminus_x1 = pm(1);
plusminus_x2 = pm(2);

%Export data
if ~[exist('Calibration data')]==0
    rmdir('Calibration data', 's')
end
mkdir('Calibration data')
cd('Calibration data\')
save('Calibration_data.mat', 'fun', 'n', 'x', 'plusminus_x1','plusminus_x2', 'R2', 'OD_control')
saveas(gcf, 'Calibration_curve.jpeg')