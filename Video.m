classdef Video < handle
    properties
        FilePath
        Frames
        Vid
        IsPlaying
    end

    methods
        function obj = Video(filePath)
            if nargin == 1
                obj.FilePath = filePath;
            end

            obj.IsPlaying = false;

            % init the video if a file path exists
            if ~isempty(obj.FilePath)
                obj.initVideo();
            end
        end

        function initVideo(obj)
            % initVideo
            %   Initializes the video by loading the file at obj.FilePath
            %
            
            obj.Vid = VideoReader(obj.FilePath);
            %obj.Frames = read(obj.Vid);
        end

        function loadVideo(obj, filePath)
            % loadVideo
            %   Loads a video from the given filePath
            
            assert(~isempty(filePath), 'Video.loadVideo(): No file path given.');

            obj.FilePath = filePath;
            obj.initVideo();
        end

        function frame = nextFrame(obj)
            % nextFrame
            %   Attempts to return the next frame from the current video.
            
            frame = [];
            
            if hasFrame(obj.Vid)
                frame = readFrame(obj.Vid);
            else
                obj.resetVideo();
                frame = readFrame(obj.Vid);
            end
        end

        function resetVideo(obj)
            % resetVideo
            %   Reset video to the beginning.

            obj.IsPlaying = false;
            obj.Vid.CurrentTime = 0;
        end
    end
end
