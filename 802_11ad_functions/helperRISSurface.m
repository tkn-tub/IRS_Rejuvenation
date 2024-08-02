classdef helperRISSurface < matlab.System
    % untitled2 Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties
        ReflectorElement
        Size = [8 8]
        ElementSpacing = [0.5 0.5]
        OperatingFrequency = 3e8
    end

    properties (DiscreteState)

    end

    % Pre-computed constants
    properties (Access = private)
        pPropagationSpeed = physconst('lightspeed');
        cAntArray
        cTxArray
        cRxArray
    end

    methods
        function obj = helperRISSurface(varargin)
            setProperties(obj, nargin, varargin{:});
            if isempty(coder.target)
                if isempty(obj.ReflectorElement)
                    obj.ReflectorElement = phased.IsotropicAntennaElement;
                end
            else
                if ~coder.internal.is_defined(obj.ReflectorElement)
                    obj.ReflectorElement = phased.IsotropicAntennaElement;
                end
            end
        end

        function stv = getSteeringVector(obj)
            antarray = getRISArray(obj);
            stv = phased.SteeringVector('SensorArray',antarray);
        end
        
        function risarray = getRISArray(obj)
            if isLocked(obj)
                risarray = obj.cAntArray;
            else
                risarray = phased.URA(obj.Size,obj.ElementSpacing,'Element',obj.ReflectorElement);
            end
        end
    end

    methods (Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            obj.cAntArray = phased.URA(obj.Size,obj.ElementSpacing,'Element',obj.ReflectorElement);
            obj.cTxArray = phased.Radiator('Sensor',obj.cAntArray,'OperatingFrequency',obj.OperatingFrequency);
            obj.cRxArray = phased.Collector('Sensor',obj.cAntArray,'OperatingFrequency',obj.OperatingFrequency);
        end

        function y = stepImpl(obj,x,ang_in,ang_out,w)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            y = obj.cTxArray(obj.cRxArray(x,ang_in).*w.',ang_out);
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
            reset(obj.cAntArray);
            reset(obj.cTxArray);
            reset(obj.cRxArray);
        end

        function releaseImpl(obj)
            release(obj.cAntArray);
            release(obj.cTxArray);
            release(obj.cRxArray);
        end
    end
end
