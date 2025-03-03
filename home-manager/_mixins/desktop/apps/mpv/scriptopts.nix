{...}: {
  console = {
    font_size = 40;
  };
  leader = {
    leader_key = ",";
    pause_on_open = "no";
    # another possible value is true
    resume_on_exit = "only-if-was-paused";
    # timeout in seconds to hide menu
    hide_timeout = 2;
    # timeout in seconds to show which-key menu
    which_key_show_delay = 1;
    # max symbols for cmd names in which-key menu
    strip_cmd_at = 28;

    # styles
    font_size = 21;
    # this padding for now applies only to 'left', not x
    menu_x_padding = 3;
    which_key_menu_y_padding = 3;
  };
  M_x = {
    # strip cmd name
    strip_cmd_at = 65;
    # available values: priority, command_name
    sort_commands_by = "priority";

    #- options for extended menu ------------------------------------------------
    toggle_menu_binding = "t";
    lines_to_show = 17;
    pause_on_open = "yes";
    resume_on_exit = "only-if-was-paused";

    #- styles
    font_size = 21;
    # cursor 'width', useful to change if you have hidpi monitor
    cursor_x_border = 0.3;
    line_bottom_margin = 1;
    menu_x_padding = 5;
    menu_y_padding = 2;

    # heading text of a search bar
    search_heading = "M-x";
    # will determine in which fields to look for your search query. For instance if
    # you don't want to search in comments to commands then just omit it from initial
    # table.
    filter_by_fields = ["cmd" "key" "comment"];
    column_layout = "no";
  };
  M_x_rofi = {
    # strip command name at N symbols and place '...' at the end
    strip_cmd_at = 65;

    # available values: priority, command_name
    sort_commands_by = "priority";

    # keybinding to toggle the M-x menu
    toggle_menu_binding = "t";

    # pause playback on manu open
    pause_on_open = "yes";

    # resume playback on menu close.
    # values: 'only-if-was-passed', 'yes', 'no'
    resume_on_exit = "only-if-was-paused";
  };
  recent = {
    # -- Automatically save to log, otherwise only saves when requested
    # -- you need to bind a save key if you disable it
    auto_save = true;
    save_bind = "";
    # -- When automatically saving, skip entries with playback positions
    # -- past this value, in percent. 100 saves all, around 95 is
    # -- good for skipping videos that have reached final credits.
    auto_save_skip_past = 100;
    # -- Display only the latest file from each directory
    hide_same_dir = "no";
    auto_run_idle = "yes";
    write_watch_later = "yes";
    display_bind = "TAB";
    mouse_controls = "yes";
    log_path = "history.log";
    date_format = "%d/%m/%y %X";
    show_paths = "no";
    split_paths = "yes";
    slice_longfilenames = "no";
    slice_longfilenames_amount = 100;
    font_scale = 50;
    border_size = 0.7;
    hi_color = "H46CFFF";
    ellipsis = "no";
    list_show_amount = 20;
  };
  thumbfast = {
    # Socket 路径，留空即自动
    socket = "";

    # 缩略图缓存路径，留空即自动
    thumbnail = "";

    # 缩略图的最大尺寸，以像素为单位，默认 360 360
    max_height = 360;
    max_width = 360;

    # 不知道用途就别改它
    overlay_id = 42;
    scale_factor = 1;
    # 加载文件时就开始生成缩略图，默认 no
    spawn_first = "no";
    # 是否退出超时未活动的缩略图进程（秒），默认 0 即禁用
    quit_after_inactivity = 0;
    # 是否对流媒体启用，默认 no
    network = "no";
    # 是否对音频文件启用，默认 no
    audio = "no";
    # [仅Windows且LuaJIT] 使用Windows的原生API来写入pipe。默认 yes
    direct_io = "yes";
    # 使用的解码API（缩略图使用的编码模式中，仅有限api可用且可能强制执行copy），默认 yes
    hwdec = "yes";
    # mpv_path = "";
  };
  uosc = {
    ###不支持参数后注释，须另起一行
    ###不允许选项和值之间存在多余的空格

    # 时间线样式，默认 line 其它可用的是 bar
    timeline_style = "bar";
    # 时间线粗度（窗口模式），默认 2
    timeline_line_width = 2;
    # 时间线的高度，以像素为单位，0 即隐藏，默认 40
    timeline_size = 40;
    # 时间线上方额外渲染的背景高度，用以明显区分边界，默认 1
    timeline_border = 1;
    # 在时间线上使用鼠标滚轮时，跳转的步进秒数，默认 1 ，可以添加前缀半角惊叹号执行精确跳转，示例 !1
    timeline_step = 1;
    # 显示流媒体的缓存范围的指示标记，默认 yes
    timeline_cache = "yes";
    # 始终显示时间线的状态白名单，多个值用半角逗号分隔，默认 idle,audio 可用的其它值 paused image video windowed fullscreen
    timeline_persistency = "idle,audio";

    # 始终显示最小化的进度条的时机。其它可用值为 windowed fullscreen always never
    # 也可以使用 `toggle-progress` 命令按需切换
    progress = "windowed";
    progress_size = 2;
    progress_line_width = 20;

    # 自定义时间线上方的控件按钮，多个值以半角逗号分隔。值 never 即禁用，示例即默认值
    # 详参 “脚本选项的扩展说明” https://github.com/hooke007/MPV_lazy/discussions/186
    controls = "menu,gap,command:history:script-message-to recent display-recent?Recently played,subtitles,<has_many_audio>audio,<has_many_video>video,<has_many_edition>editions,<stream>stream-quality,gap,space,speed,space,shuffle,loop-playlist,loop-file,gap,prev,items,next,gap,fullscreen";
    controls_size = 32;
    controls_margin = 8;
    controls_spacing = 2;
    controls_persistency = "idle,audio";

    # 音量控件的显示位置，默认 right 其它可用值为 none left
    volume = "right";
    volume_size = 40;
    volume_border = 1;
    volume_step = 1;
    volume_persistency = "idle,audio";

    # 速度控件相关。鼠标按住拖动/滚轮可改变数值，单机则重置.示例即默认值
    speed_step = 0.1;
    speed_step_is_factor = "no";
    speed_persistency = "idle,audio";

    # 上下文菜单样式，示例即默认值
    menu_item_height = 36;
    menu_min_width = 260;
    menu_padding = 4;
    # 是否启用菜单快速搜索（只需输入任何文本即可），否则使用按键 / 或 Ctrl+F 来激活搜索。启用该项时，如果输入的是一个 Unicode 字符，就不能再使用相同的键位来关闭已打开的菜单
    menu_type_to_search = "yes";

    # 顶栏的显隐逻辑（仅在无边框和全屏模式下显示），默认 no-border 其它可用的值 never always
    top_bar = "no-border";
    top_bar_size = 40;
    # 启用顶栏的控制按钮，其它可用的值 no left
    top_bar_controls = "right";
    # 启用顶栏主标题，yes即使用mpv.conf中的设定，no则禁用，或使用自定义的属性扩展字符串。推荐 ${media-title}
    top_bar_title = "yes";
    # 启用顶栏备用标题，留空即不使用，推荐 ${filename}
    top_bar_alt_title = "\${filename}";
    # <默认below|toggle> 备用标题显示的样式
    top_bar_alt_title_place = "below";
    # 当加载文件位于限定范围中时，刷新顶栏。多个值用半角逗号分隔，其它可用的值 audio video image chapter
    top_bar_flash_on = "video,audio";
    top_bar_persistency = "";

    # 无边框模式下绘制的内边框和透明度，默认 2
    window_border_size = 2;

    # 如果播放列表中不存在其它文件且当前文件未结束，uosc自动加载当前路径的下一个文件。默认 no
    # 使用 load_types 来限制哪类文件会自动加载
    # 启用该设置时，usoc会自动设置以下参数 --keep-open=yes --keep-open-pause=no
    autoload = "no";
    # 启用播放列表/当前目录的乱序播放，默认 no
    shuffle = "no";

    # 界面元素的缩放率，默认 0 （即自动计算），负值则表示采用自动dpi缩放
    scale = 1;
    # # 界面元素的在全屏时的缩放补偿，默认 1
    scale_fullscreen = 1;
    # 字体缩放率，默认 1
    font_scale = 1;
    # 仅使用字体的Bold字重，默认 no
    font_bold = "no";
    # 控件元素的边框，默认 1.2
    text_border = 1.2;
    # 界面元素中圆角矩形的弧度，默认 4
    border_radius = 4;
    # 界面元素的颜色，多个值之间用半角逗号分隔。
    # 示例的默认值：foreground=ffffff,foreground_text=000000,background=000000,background_text=ffffff,curtain=000000,success=a5e075,error=ff616e
    color = "";
    # 界面元素的不透明度，多个值之间用半角逗号分隔（不影响文本）。
    # 示例的默认值：timeline=0.9,position=1,chapters=0.8,slider=0.9,slider_gauge=1,controls=0,speed=0.6,menu=1,submenu=0.4,border=1,title=1,tooltip=1,thumbnail=1,curtain=0.5,idle_indicator=0.8,audio_indicator=0.5,buffering_indicator=0.3,playlist_position=0.8
    opacity = "timeline=0.9,position=1,chapters=0.8,slider=0.9,slider_gauge=1,controls=0,speed=0.6,menu=1,submenu=0.4,border=1,title=1,tooltip=1,thumbnail=1,curtain=0.5,idle_indicator=0.8,audio_indicator=0.5,buffering_indicator=0.3,playlist_position=0.8";

    # 高级功能启用列表（禁用提升性能），多个条目用半角逗号分隔，当前支持的有 text_width sorting
    #  text_width 为更准确的文本宽度预估
    #  sorting 为更准确的列表排序
    refine = "text_width,sorting";

    # 元素动画的持续时间，以毫秒为单位
    animation_duration = 100;
    # 鼠标左键点击画面的时间短于此值时才执行命令（根据 --input-doubleclick-time 过滤双击），以毫秒为单位。0 即禁用，默认 0
    click_threshold = 0;
    click_command = "cycle pause; script-binding uosc/flash-pause-indicator";
    # 由 flash-{element} 命令使用的一闪持续时间，以毫秒为单位，默认 1000
    flash_duration = 1000;
    # 元素完全淡入/淡出的距离，以像素为单位，默认 40 120
    proximity_in = 40;
    proximity_out = 120;
    # <默认total|playtime-remaining|time-remaining> 显示总时间或剩余播放时间或剩余时间
    destination_time = "total";
    # 显示时间码的亚秒，精确等效到秒的小数点后的位数。默认 0
    time_precision = 0;
    # mpv隐藏光标时也隐藏界面元素，默认 no （另参见主设置中的 --cursor-autohide ）
    autohide = "no";
    # 如果流的缓冲时间低于这个秒数，就在时间线上显示缓存时间。0 即禁用，默认 60
    buffered_time_threshold = 60;
    # 暂停图标的样式，默认 flash ，其它可用值 static manual （由 flash-pause-indicator 和 decide-pause-indicator 命令控制）
    pause_indicator = "flash";
    # 流式传输质量 列表中列出的可选偏好项，示例即默认值
    stream_quality_options = "4320,2160,1440,1080,720,480,360,240,144";

    # （加载文件/导入视频音频轨时）文件浏览器的扩展名过滤列表。默认值覆盖极广，此预设精简为常见的视频和音频格式
    video_types = "avi,flv,m2ts,m4v,mkv,mov,mp4,mpeg,mpg,ogv,rm,rmvb,ts,vob,webm,wmv";
    audio_types = "aac,ac3,ape,dsf,dts,flac,m4a,mka,mp3,ogg,opus,wav,wma,wv";
    image_types = "apng,avif,bmp,gif,jfif,jpeg,jpg,jxl,png,svg,tif,tiff,webp";
    # （导入字幕时）文件浏览器的扩展名过滤列表。默认值覆盖极广，此预设精简为常见的字幕格式
    subtitle_types = "ass,idx,lrc,mks,pgs,sup,srt,ssa,txt,vtt";
    # （导入播放列表时）文件浏览器的扩展名过滤列表，示例即默认值
    playlist_types = "m3u,m3u8,pls,url,cue";

    # 文件浏览器的默认目录，示例即默认值，特殊值 {drives} 表示根目录
    default_directory = "/";
    # 读取目录时列出隐藏文件。此功能受限于平台存在极大限制
    show_hidden_files = "no";
    # 当使用内置命令删除文件时是否移动到回收站（非Windows系统需要自行安装trash-cli依赖）。默认 no
    use_trash = "no";
    # 根据界面元素的可见性动态调节OSD边距，默认 no
    adjust_osd_margins = "no";

    # 将一些常见的章节类型转换成章节范围指示标记。示例即默认值
    # 补充额外的lua模式来识别简单章节范围的起始点（除 ads 外的所有章节）。示例即默认值
    # 详参 “脚本选项的扩展说明” https://github.com/hooke007/MPV_lazy/discussions/186
    chapter_ranges = "openings:30ABF964,endings:30ABF964,ads:C54E4E80";
    chapter_range_patterns = "openings:オープニング;endings:エンディング";

    # 此版本中此项仅表示从 opensubtitles 网站获取字幕时的语言过滤类型。多个值之间用半角逗号分隔，特殊值 slang 会解析主设置中 --slang 的值
    # 该网站使用的语言代码参考 https://opensubtitles.stoplight.io/docs/opensubtitles-api/1de776d20e873-languages
    languages = "slang,en";

    # 禁用的界面元素，多个值之间用半角逗号分隔。当前以下元素支持受用户自行禁用
    # window_border,top_bar,timeline,controls,volume,idle_indicator,audio_indicator,buffering_indicator,pause_indicator
    disable_elements = "";
  };
}
