function handles = VideoPlayerView()
    % build the GUI
    handles = initGUI();
end

function handles = initGUI()
    % Load view from GUIDE file
    h_fig = hgload('VideoPlayerView.fig');

    % Store handles for control objects
    video_window = findobj(h_fig, 'tag', 'video_window');
    video_controls = findobj(h_fig, 'tag', 'video_controls');
    play_button = findobj(h_fig, 'tag', 'play_button');
    menu_bar = findobj(h_fig, 'tag', 'menu');
    menu_open_video = findobj(h_fig, 'tag', 'open_video');
    menu_open_folder = findobj(h_fig, 'tag', 'open_folder');
    time_slider = findobj(h_fig, 'tag', 'time_slider');
    file_listbox = findobj(h_fig, 'tag', 'file_listbox');

    file_listbox.String = {'No video(s) loaded.'};

    % set up handles
    handles = struct('fig', h_fig, ...
        'video_window', video_window, ...
        'video_controls', video_controls, ...
        'play_button', play_button, ...
        'menu_bar', menu_bar, ...
        'menu_open_video', menu_open_video, ...
        'menu_open_folder', menu_open_folder, ...
        'time_slider', time_slider, ...
        'file_listbox', file_listbox);

    guidata(h_fig, handles);
end
