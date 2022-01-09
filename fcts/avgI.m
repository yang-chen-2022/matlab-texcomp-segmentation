function [avg] = avgI(A,r)
%Compute the average gray level of a 3-D image
%   [avg] = avgI(A,r)
%   -----------------
%   Inputs:
%       >   A: 3-D image to be processed
%       >   r: 3x1 vector, window dimensions, the window has a size of
%              (2*r1+1) * (2*r2+1) * (2*r3+1)
%
%   Outputs:
%       > avg: average gray level of the image A
%
% note: the average gray level is evaluated within the same window as that
%       used in the filtering step.
%
% Yang CHEN version 2018.12.18

w = ones(2*r(1)+1,2*r(2)+1,2*r(3)+1); %uniform average filter
    % sig = 1;
    % [y,x,z] = ndgrid(-r:1:r,-r:1:r,-r:1:r);
    % w = exp(-(x.^2+y.^2+z.^2)./(2*sig^2)); %Gaussian average filter
    %     figure;surf(x(:,:,r+1),y(:,:,r+1),w(:,:,r+1));set(gca,'ZLim',[0 1])
w = w./(sum(w(:)));

avg = convn(A,w,'same');
avg = single(avg);
