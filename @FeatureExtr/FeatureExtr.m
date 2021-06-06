classdef FeatureExtr< handle & hgsetget
  % FeatureExtract Implementation of a features extraction
  %   Detailed explanation goes here
  
  properties
    data;
    sample_rate;
    description;
    % setting1 is for PSD
    setting1={};
    % setting2 is for PLI
    setting2={};
  end
  
  
  
  methods
             % Class constructor
        function obj = FeatureExtr(EEG_data,Srate,description)
           if nargin>=1; obj.data=EEG_data; end       
           if nargin>=2; obj.sample_rate=Srate;   end
           if nargin>=3 && isa(description, 'char')
                obj.description = description;
           end
           
           % initialize your variables here
            obj.setting1.nwind = 100; % welch window lenth, 1/2 of whole L
            obj.setting1.alfa = [8,  13];
            obj.setting1.beta = [14, 29];
            obj.setting1.delta= [0.5, 4];
            obj.setting1.theta= [4, 7.5];
            obj.setting1.gamma= [30, 45];
            obj.setting1.tot=   [0.5 45];
            % refer to book: EEG Signal Processing. saeid sanei and J.A. Chambers
            
            % for PLI
            obj.setting2.fs=Srate;
            obj.setting2.sensitivity = 0.8; % [0<s<1]
            obj.setting2.subbands = [0.5,4; 4,8; 8,12; 12,16; 16,30; 30,45]; % f-bands
        end
            % Other functions...
            
  end
end


