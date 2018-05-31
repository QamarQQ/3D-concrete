%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example which computes effective diffusvity
% tensor of an SVE. Comutations are based on
% stationary simmulations.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc

addpath([pwd,'/classFiles'])
addpath([pwd,'/misc'])
warning('off','all')


% % create object
SVE = SVEclass;

% % set properties
SVE.nx                = 40;
SVE.realizationNumber = 1;
SVE.Lbox              = 2.0;
SVE.aggFrac           = 0.3;
maxTime = 1/60; % hours

% % input for 'generateSVE()'
M = dlmread('sieve-input.txt',',');
ballastRadii = M(:,1)/2/10; % [20 8 4 2]/2/10;   % Radius in [cm]. From http://www.sciencedirect.com/science/article/pii/S0168874X05001563
gravelSieve  = M(:,2)/sum(M(:,2)); % [.25 .25 .35 .15]; % Distribution in fraction. sum(gravelSieve) should be 1.0
numberOfGravel = 500;            % ballast particles are distributed inside domainFactor*LBox


% % input for 'LinTransSolver()' method
time.steps       = 10;
time.stepsize    = 0.1;
initialCondition = eps;

% % set SVE boundary type
% % 1 = physical boundary where no aggregates cut the boundary surface
% % default value is 0 if not set by user
% SVE.boundary.x.back  = 1;
% SVE.boundary.x.front = 1;
% SVE.boundary.y.back  = 1;
% SVE.boundary.y.front = 1;
% SVE.boundary.z.back  = 1;
% SVE.boundary.z.front = 1;

% set convective coefficient at the three 'plus' faces of the SVE 
% SVE.convCoeff.x.back = 100;
% SVE.convCoeff.y.back = inf;
% SVE.convCoeff.z.back = inf;
% SVE.convCoeff.y.front = inf;
% SVE.convCoeff.z.back  = inf;
% SVE.convCoeff.z.front = inf;

% set ambient humidity around the SVE where convective coefficient ~=inf
% SVE.ambHum.x.back  = 1;
% SVE.ambHum.x.front = 0;
% SVE.ambHum.y.back  = 0;
% SVE.ambHum.y.front = 0;
% SVE.ambHum.z.back  = 0;
% SVE.ambHum.z.front = 0;


% % apply methods
SVE.setPath(); % uses current working directory
% SVE.setPath('C:\optional\path'); % if you want files to be saved elsewhere
SVE.generateSVE(ballastRadii,gravelSieve,numberOfGravel);
SVE.packSVE(maxTime);
SVE.deleteOverlappingSpheres();
SVE.meshSVE();
SVE.writeTopology();
SVE.computeEffectiveDiffusivtyTensor();
% SVE.LinTransSolver(initialCondition,time);
% SVE.TransPostProcessor();
% [spatialDirection,slicedPlane] = SVE.plotTransientFront();
