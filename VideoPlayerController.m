function [model, view] = VideoPlayerController()
    % Load the model
    model = Video();

    % Set up the view
    view = VideoPlayerView();

    % Set callbacks
    % TODO: Figure out how to handle the references to view (handles)
    set(view.play_button, 'Callback', {@playButtonPress, view, model});
    set(view.menu_bar, 'Callback', {@openFileMenu});
    set(view.menu_open_video, 'Callback', {@openVideoFile, view, model});
    set(view.menu_open_folder, 'Callback', {@openVideoFolder, view, model});
    set(view.file_listbox, 'Callback', {@fileListBoxSelect, view, model});

    % slider event listener
    try
        % for 2013b and older
        addlistener(view.time_slider, 'ActionEvent', @(o, e) sliderChanged(o, e, view, model));
    catch
        % for 2014a and newer
        addlistener(view.time_slider, 'ContinuousValueChange', @(o, e) sliderChanged(o, e, view, model));
    end
end

%--------------------------------------------------------------------------------
% Callbacks
%--------------------------------------------------------------------------------

function playButtonPress(o, ~, handles, model)
    % playButtonPress
    % Callback handler for play button.
    % TODO: Consider consolidating some of this into the Video model.
    % TODO: The slider resets to a little past the start. Ideally it should be
    % at the absolute beginning.

    if isempty(model.Vid)
        return
    end

    model.IsPlaying = ~model.IsPlaying;

    while model.IsPlaying == true
        frame = model.nextFrame();
        handles.time_slider.Value = model.Vid.CurrentTime / model.Vid.Duration;
        image(frame, 'Parent', handles.video_window);
        handles.video_window.Visible = 'off';
        pause(1 / model.Vid.FrameRate);
    end
end

function sliderChanged(o, ~, handles, model)
    % sliderChanged
    % Callback function for the time slider. Changes the current time of the
    % video when changed.
    
    model.Vid.CurrentTime = o.Value * model.Vid.Duration;

    % Display the frame
    frame = model.nextFrame();
    image(frame, 'Parent', handles.video_window);
    handles.video_window.Visible = 'off';
end

function fileListBoxSelect(o, ~, handles, model)
    % fileListBoxSelect
    % Callback handler for selecting an item in the listbox.
    % TODO: How should I save the directory path?
    % TODO: Verification
    
    handles = guidata(o);
    items = get(o, 'String');
    index_selected = get(o, 'Value');
    item_selected = items{index_selected};

    % load the video
    file_path = strcat(handles.folder_name, item_selected);
    loadVideo(o, model, file_path);
end

%----------------------------------------
% File Menu Callbacks
%----------------------------------------

function openFileMenu(o, ~, handles)
    % openFileMenu
    % Callback function for opening the top 'File' menu item.
end

function openVideoFile(o, ~, handles, model)
    % openVideoFile
    % Callback handler for opening a file using a GUI dialog.
    % TODO: Add verification that the video was opened successfully.

    [file_name, path_name] = uigetfile({'*.avi;*.mpg;*.mpeg', 'Video files (*.avi, *.mpg, *.mpeg)'});

    if file_name == 0
        return
    end

    % show the file name in the listbox
    handles.file_listbox.String = {file_name};

    % initialize model
    model.loadVideo(strcat(path_name, file_name));

    % Display the first frame
    frame = model.nextFrame();
    image(frame, 'Parent', handles.video_window);
    handles.video_window.Visible = 'off';
    handles.time_slider.Enable = 'on';
end

function openVideoFolder(o, ~, handles, model)
    % openVideoFolder
    % Callback function for opening a folder of videos.
    
    %TODO: This kills the handles to []
    %handles = guidata(o);

    % get list of all files in this directory and display them in the listbox
    folder_name = uigetdir('');

    if folder_name == 0
        return
    end

    file_pattern = fullfile(folder_name, '*.mpg');
    folder_info = dir(file_pattern);
    set(handles.file_listbox, 'string', {folder_info.name});

    % load the first video
    folder_name = strcat(folder_name, '/');
    
    % set handles
    handles.folder_name = folder_name;
    setappdata(o, 'folder_name', folder_name);
    display(handles);

    loadVideo(o, model, strcat(folder_name, folder_info(1).name));

    guidata(o, handles);
end


%----------------------------------------
% User Functions
%----------------------------------------

function loadVideo(o, model, file_path)
    % loadVideo
    % Loads a video into the given model using the given file_path.
    % Performs the necessary UI functions to display the video.

    handles = guidata(o);

    model.loadVideo(file_path);

    % Display the first frame
    frame = model.nextFrame();
    image(frame, 'Parent', handles.video_window);
    handles.video_window.Visible = 'off';
    handles.time_slider.Enable = 'on';

    guidata(o, handles);
end
