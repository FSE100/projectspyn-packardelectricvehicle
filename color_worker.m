classdef color_worker < AsyncWorker
     methods
        function result = onStart(obj, greeting)
            message = ['Worker started with message: ' greeting];
            result = message;
            while(1)
                disp("colorChecking")
            end
        end

        function onCancel(obj)
            % ...
        end

        function onError(obj, exception)
            % ...
        end
    end
end 