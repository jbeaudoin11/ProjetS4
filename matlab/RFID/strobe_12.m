function strobe_12(block)
    setup(block)

function setup(block)
clc
    % Register ports
    block.NumInputPorts = 1;
    block.NumOutputPorts = 1;
    
    % Setup ports
    block.SetPreCompInpPortInfoToDynamic;
    block.SetPreCompOutPortInfoToDynamic;

%     block.InputPort(1).DatatypeID    = 0;
    block.InputPort(1).Complexity    = 0;
    block.InputPort(1).Dimensions    = 1;
    block.InputPort(1).SamplingMode  = 0;

    block.OutputPort(1).DatatypeID   = 0;
    block.OutputPort(1).Complexity   = 0;
    block.OutputPort(1).Dimensions   = 1;
    block.OutputPort(1).SamplingMode = 0;

    block.InputPort(1).SampleTime  = [-1 0];
    block.OutputPort(1).SampleTime = [-1 0];
    
    %
    block.SimStateCompliance = 'DefaultSimState';
    block.RegBlockMethod('PostPropagationSetup', @DoPostPropSetup);
    block.RegBlockMethod('SetOutputPortSampleTime', @SetOutputPortSampleTime);
    block.RegBlockMethod('SetInputPortSampleTime', @SetInputPortSampleTime);
    block.RegBlockMethod('InitializeConditions', @InitializeConditions);
    block.RegBlockMethod('Start', @Start);
    block.RegBlockMethod('Outputs', @Outputs);
    
function DoPostPropSetup(block)
    block.NumDworks = 2;
    
    block.Dwork(1).Name = 'cnt';
    block.Dwork(1).Dimensions      = 1;
    block.Dwork(1).DatatypeID      = 0;
    block.Dwork(1).Complexity      = 0;
    block.Dwork(1).UsedAsDiscState = 1;
    
    % State
    % 0 -> ready
    % 1 -> buzy
    block.Dwork(2).Name = 'state';
    block.Dwork(2).Dimensions      = 1;
    block.Dwork(2).DatatypeID      = 0;
    block.Dwork(2).Complexity      = 0;
    block.Dwork(2).UsedAsDiscState = 1;
    

function SetInputPortSampleTime(block, idx, st)
    block.InputPort(1).SampleTime = st;
    block.OutputPort(1).SampleTime = [st(1)*12, st(2)];
    
% not call for some reason ??
function SetOutputPortSampleTime(block, idx, st)
    block.OutputPort(1).SampleTime = st;
    
function InitializeConditions(block)
    block.Dwork(1).Data = 1;
    block.Dwork(2).Data = 0;

function Start(block)
    Outputs(block)
%     block.Dwork(1).Data = 1;
%     block.Dwork(2).Data = 0;
    
function Outputs(block)
%     disp([num2str(block.Dwork(1).Data), ' - ', num2str(block.InputPort(1).Data)])
    
    if block.InputPort(1).IsSampleHit
        if (block.Dwork(2).Data == 0) && (block.InputPort(1).Data > 0)
            block.Dwork(2).Data = 1; % ready -> buzy
        end
        
        if (block.Dwork(2).Data == 1)
            if block.Dwork(1).Data < 12
                block.Dwork(1).Data = block.Dwork(1).Data + 1; % cnt++
            else 
                InitializeConditions(block) % Reset
            end
        end
    end
    
    if block.OutputPort(1).IsSampleHit
        if block.Dwork(1).Data == 2
            block.OutputPort(1).Data = 1;
        else
            block.OutputPort(1).Data = 0;
        end
    end
        
    
    
    
    
    
    
    
    
    
    
  

    
