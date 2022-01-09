%Demo for the supervised image segmentation of textile composites
%
% Precaution, the input image used herein is randomly generated. Replace
% the input by your own image with textile patterns.
%
% ===========================================================
% // Parameters need to be adjusted according to your case //
% ===========================================================
%   > window size
%       The valus is recommended to be at least 3~5 times fibre diameters
%   > features to be used for segmentation
%       vec1: vector along fibres (if voxel belongs to a yarn)
%       verc3: vector normal to flatterned plate
%       beta: anisotropy ratio, or the ratio between EignValue_min and
%             EigenValu_max
%       avg: locally averaged grey level
%       phi: angle between vec1 and z-axis
%       psi: angle between vec1-z plane and x-axis
%
% written by Yang Chen, University of Oxford

addpath ../0_fct_basic/
addpath ../1_unitGen/

clear all;
close all;

% define the directory to save the analysis results
dirSave = 'results/';

% import a 3D image
A = randi([0,255], 100, 110, 120); % here represented by a random 3D array
A = uint8(A);

typeA = class(A);
siz = size(A);

% build a MEX function from the C code (https://github.com/yang-chen-2022/matlab-utils/blob/main/netcodes/eig3volume_YC.c)
if exist('eig3volume_YC.mexa64')==0
    mex ../0_fct_basic/netcodes/eig3volume_YC.c
end


% feature vector ----------------------------------------------------------
% -------------------------------------------------------------------------

%window size, smaller -> more detailed (more noises)
r = 3; 

%choose the features to be calculated
str_out = {'vec1','beta','avg','phi','psi','vec3'}; 

%calculate the features
[vec1,beta,avg,phi,psi,vec3] = featureParam_bloc(A,r,str_out,3);

%re-arrange vec into array
vec1 = [vec1{1}(:),vec1{2}(:),vec1{3}(:)];
vec3 = [vec3{1}(:),vec3{2}(:),vec3{3}(:)];

%select the features to be used for segmentation
v = [beta(:),avg(:),psi(:)];
str_vec = {'beta','avg','psi'};
clear S lambda beta avg phi psi vec1 vec3;

%
nvx = size(v,1); %number of voxels
np = size(v,2); %number of parameters

% supervised clustering (subimage was used) -------------------------------
% -------------------------------------------------------------------------

%define the training sets (pre-selected manually)
run demo_trainSets.m 
trainSetPlot(Tsets,A); %visu for check

ncl = size(Tsets,1);

% determine the centroid & covariance matrix of each training cluster
v0T = zeros(ncl,np);
COVT = zeros(ncl,np,np);
for icl = 1:ncl
    id = false(siz);
    id( Tsets(icl,2):Tsets(icl,5),...
        Tsets(icl,1):Tsets(icl,4),...
        Tsets(icl,3):Tsets(icl,6) ) = 1;
    vT = v(id(:),:);
    [v0_icl,COV_icl] = covMatrix(vT);
    v0T(icl,:) = v0_icl;
    COVT(icl,:,:) = COV_icl;
end

% probability function for each cluster
P = zeros(nvx,ncl,'single');
for icl=1:ncl
    P(:,icl) = probFun(v,v0T(icl,:),squeeze(COVT(icl,:,:)));%function to be checked !
end

% clustering
[Pmax,idx] = max(P,[],2);

idx = reshape(idx,siz);
label = zeros(siz,'uint8');
label(idx==1) = 0; %void
label(idx==2) = 1; %matrix
label(idx==3) = 2; %yarn in direction 1
label(idx==4) = 3; %yarn in direction 2

% visualisation
figure; isl=ceil(size(A,3).*0.9);
subplot(2,1,1);imshow(A(:,:,isl)); title('initial image')
subplot(2,1,2);imshow(label(:,:,isl),[0 3]); title('label image')



