%Load image
imagesc(imread('Pixelsize_calibration.tif'));

%Draw line object between two points (took 5 and 15)
l = drawline;

%Calculate length of line
coord = l.Position;
length_image = sqrt((coord(2,1) - coord(1,1))^2 + (coord(2,2) - coord(1,2))^2);

%Return pixel size
length_real = 10; %cm
pixel_size = length_real/length_image;
sprintf(['Pixel size: ' num2str(pixel_size,2) ' cm/pixel'])