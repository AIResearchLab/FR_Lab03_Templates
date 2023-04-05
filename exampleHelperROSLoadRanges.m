function scanPubmsg = exampleHelperROSLoadRanges()
    %exampleHelperROSLoadRanges - Loads data for the laser scan message in startExamples
    %   
    %   See also exampleHelperROSCreateSampleNetwork
    
    %   Copyright 2014-2015 The MathWorks, Inc.
    
    laserfile = fullfile(fileparts(mfilename('fullpath')), '..', 'data', 'laserdata.mat');
    lasercell = load(laserfile);
    scanPubmsg = lasercell.laserdata;
end