%Load CT images into MATLAB and display them in axial view (if axial view is default)

function [info, img3d] = CTax()
%Get path from user selections
path = uigetdir('C:\Users\bhaan','Select folder with CT files');
cd(path);

%Make file list
files = dir('*.dcm');
files = extractfield(files,'name');

%Compile all dicom headers in 'info'
info = [];

for p = 1:size(files,2)
    info = [info, dicominfo(files{p},'UseDictionaryVR',true)]; %reads file info for each name
end

%Read in all images, stack them into in img3d
for k = 1:size(files,2)
    img3d(:,:,k) = dicomread(files{k});
end

%Display image slice by slice
for i= 1:size(img3d,3)
    aximage=squeeze(img3d(:,:,i)); %squeeze out columns to create 2D axial images
    imshow(aximage,[]);
end

end

