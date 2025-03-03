{config, ...}: let
  inherit (config._custom.globals) fonts;
in {
  ##⇘⇘基本说明：
  ##没有必要写入和默认值相同的参数，这里只是为了演示说明
  ##行首存在注释符"#"，代表此项处于屏蔽状态（即未被mpv读取）
  ##注释内容解释 —— # <可选值> [条件要求] 参数意义说明 （补充）
  ##部分选项之间有关联作用，MPV读取参数时由上往下读，所以注意书写通用参数的顺序，可查看此处的更多解释 https://hooke007.github.io/unofficial/mpv_profiles.html#id4

  ########
  # 基础 #
  ########
  # <gpu|gpu-next> 视频输出驱动。许多渲染相关的选项也只能在这两项下正常工作。当前版本首选gpu
  # gpu最高普适性和完成度；gpu-next查看此处讨论 https://github.com/hooke007/MPV_lazy/discussions/39
  vo = "gpu";
  # <win|d3d11|winvk> 选择图形输出后端，默认 auto（此项的值与 --gpu-api=<opengl|d3d11|vulkan> 相对应）
  # 非特殊情况下Win&NV用户应使用d3d11。vulkan可能的10bit问题 https://github.com/mpv-player/mpv/issues/8554
  gpu-context = "auto";
  # <最高为rgba32f> 内处理精度。此项通常由 --gpu-api 或 --gpu-context 自动决定正确值，默认 auto 优先选择16位及以上的精度
  fbo-format = "auto";

  # 指定应使用的硬件视频解码API，默认值 no 为软解。值 auto 或 auto-safe（等效值 yes） 即优先尝试原生硬解，但不支持部分设置/滤镜。
  # 它也可以是多个值组成的优先级列表，例如值 vulkan-copy,nvdec-copy,dxva2-copy 表示依次尝试这些解码模式
  # 更多详情参见Wiki的FAQ页面下的“软硬解的选择”部分
  hwdec = "no";
  # 对限定范围内的编码尝试硬解，特殊值 all 即任意格式都尝试硬解，当前版本默认值 h264,vc1,hevc,vp8,vp9,av1,prores
  hwdec-codecs = "h264,vc1,hevc,vp8,vp9,av1,prores";
  # <默认auto|yes|no> 是否直接解码到显存，个别低端英特尔处理器可能需要显式禁用此功能以大幅提速解码
  vd-lavc-dr = "auto";

  ########
  # 功能 #
  ########
  # 自定义窗口上显示的标题内容，也会影响部分脚本的 title 属性。默认值：${?media-title:${media-title}}${!media-title:No file}
  title = ''''${?pause==yes:⏸}''${?mute==yes:🔇}''${?ontop==yes:📌}''${?demuxer-via-network==yes:''${media-title}}''${?demuxer-via-network==no:''${filename}}'';
  # [使用部分同类脚本的前置条件(no)] 禁用原OSC（即内置的"osc.lua"脚本）以兼容第三方的界面样式，默认 yes
  osc = "no";
  # <yes|默认no|once> 是否空闲待机（中止播放或所有文件播放后依旧保持mpv运行）
  idle = "yes"; # no会导致rofi不能启动
  log-file = "~~/files/mpv.log"; # 记录名为 xxxxx 的log日志在桌面。默认为空，例值 "~~desktop/mpv-lazy.log"
  # input-ipc-server=<ipc_path> 开启 Ipc 功能，Windows: input-ipc-server=\\.\pipe\mpvsocket
  # IPC支持，默认为空
  # 示例：使用SVP Manager时的值应为 mpvpipe
  input-ipc-server = "/tmp/mpvsocke";

  # 是否以暂停状态启动播放器，默认 no
  pause = "no";
  # <0.0-1.0> 额外的后处理（使用 --scale 的算法）放大画面，默认 0.0
  # 这取决于窗口和源之间是否存在额外黑边（可用于 --keepaspect-window=no 时的画面自动填充），如不存在则什么也不做
  # 值为 1 时，也常用于消除全屏播放时，片源与显示器的宽高比不一致而产生的黑边（部分画面在视觉效果上被裁切）
  panscan = "0.0";
  # <inf|默认no> 是否循环播放当前文件
  loop = "no";
  # <inf|force|默认no> 播放列表循环。值 force 会强制播放列表中标记为失效的条目而不是跳过它
  loop-playlist = "no";
  # <no|absolute|default|yes|always> 选择何时使用不限于关键帧的精确跳转。此类跳转需要将视频从前一个关键帧解码到目标位置，因此可能需要一些时间，具体取决于解码性能
  # no：禁用；absolute：只对章节使用精确跳转；default：类似 absolute，但在纯音频的情况下启用精准跳转。可能随版本更新发生行为变化；yes：尽可能使用精确跳转；always：与 yes 相同（为了兼容性）
  hr-seek = "yes";
  # [补帧时推荐设置为no] 跳转时允许丢帧，默认 yes 。禁用它利于修正音频延迟
  hr-seek-framedrop = "yes";
  # 退出时记住播放状态，默认 no
  save-position-on-quit = "yes";
  # [补帧时注意避免记录值 vf ] 稍后观看的属性白名单。示例即默认值
  # 推荐精简为 start,aid,vid,sid 以避免与你的核心设置冲突
  # 当 --save-position-on-quit=yes 或使用退出时保存到稍后观看的功能时，如果不使用白名单，滤镜列表、音量、速率等其它状态也会被保存并在下次启动时恢复
  # 具体参数值：start,speed,edition,volume,mute,audio-delay,gamma,brightness,contrast,saturation,hue,deinterlace,vf,af,panscan,aid,vid,sid,sub-delay,sub-speed,sub-pos,sub-visibility,secondary-sub-visibility,sub-scale,sub-use-margins,sub-ass-force-margins,sub-ass-vsfilter-aspect-compat,sub-ass-override,ab-loop-a,ab-loop-b,video-aspect-override
  watch-later-options = "start,vid,aid,sid";
  # 将文件名写入播放记录缓存文件
  write-filename-in-watch-later-config = true;
  # 播放下一文件时需重置的更改项（色彩、画面、音轨、字幕和滤镜相关)
  reset-on-next-file = "vid,aid,sid,secondary-sid,vf,af,loop-file,deinterlace,contrast,brightness,gamma,saturation,hue,video-zoom,video-rotate,video-pan-x,video-pan-y,panscan,speed,audio-delay,sub-pos,sub-scale,sub-delay,sub-speed,sub-visibility,secondary-sub-visibility";
  # 指定各种输入元数据的编码（默认值：auto）。这会影响文件标签、章节标题等的解释方式。例如，可以将其设置为 auto 以启用编码的自动检测（非 UTF-8 编码是一个晦涩难懂的边缘用例）
  metadata-codepage = "auto";
  # <module1=level1,module2=level2,...> 控制每个模块在控制台输出日志的详细程度，这也会影响日志文件。可用 level：<no|fatal|error|warn|info|status 默认|verbose|debug|trace>
  msg-level = "all=debug";
  # 如果文件的修改时间与保存时相同，则从 watch_later 配置子目录（通常为~/.config/mpv/watch_later/）恢复播放位置。这可以防止在具有不同内容的同名文件中的错误行为（默认：no）
  resume-playback-check-mtime = "yes";

  ##⇘⇘前 autoload.lua 脚本的平替功能 https://github.com/mpv-player/mpv/blob/master/TOOLS/lua/autoload.lua
  ##打开单个文件时，根据过滤条件，自动添加当前路径下的其它文件到播放列表，实现类似某种“自动播放下一集”的功能

  autocreate-playlist = "no"; # <默认no|filter|same> 打开单个本地文件时，是否自动填充播放列表，默认禁用
  # 值 filter 为依据 --directory-filter-types --video-exts 等选项填充当前目录下的其它文件至播放列表
  # 值 same 为仅填充同类文件（例如打开的文件名后缀名符合 --video-exts 中的任意一项，则仅填充其它同为视频类文件）
  directory-mode = "auto"; # <默认auto|lazy|recursive|ignore> 打开目录时，当前路径下子文件夹的处理模式。
  # 建议使用值 ignore 来忽略子目录（阻止添加到播放列表），尤其是当你同时启用 --autocreate-playlist 时
  directory-filter-types = "video,audio,image,archive,playlist";
  # <video,audio,image,archive,playlist> 打开目录或使用 --autocreate-playlist 自动填充播放列表时，限制填充的文件类型，示例即默认值
  video-exts = "3g2,3gp,avi,flv,m2ts,m4v,mj2,mkv,mov,mp4,mpeg,mpg,ogv,rmvb,ts,webm,wmv,y4m";
  # 打开目录或使用 --autocreate-playlist 自动填充播放列表时，限制填充文件类型对应的扩展名白名单
  # 示例即默认值。下方二项的功能同理
  image-exts = "avif,bmp,gif,heic,heif,j2k,jp2,jpeg,jpg,jxl,png,qoi,svg,tga,tif,tiff,webp";
  audio-exts = "aac,ac3,aiff,ape,au,dts,eac3,flac,m4a,mka,mp3,oga,ogg,ogm,opus,thd,wav,wav,wma,wv";
  # 注意此项同时被额外用作 --audio-file-auto 自动加载外挂音轨格式匹配的白名单

  ##⇘⇘窗口相关
  ##此处已精简，详细说明与更多自定义参数请查看： https://github.com/hooke007/MPV_lazy/discussions/69
  # --fs 等效 --fullscreen。运行MPV自动进入全屏，默认 no
  fs = "no";
  # <yes|默认no|always> 默认为播完列表不暂停，值为 yes 播完列表暂停，值为 always 时每个文件播完都暂停
  keep-open = "no";
  # 窗口置顶（当 --gpu-api=vulkan 时附带全屏独占的功能），默认 no。可选择性的启用配置预设 ontop_playback
  ontop = "no";
  # 控制是否使用窗口标题栏播放，默认启用。与 --no-border 不同，--no-title-bar 可以保留 Windows 原生窗口特性
  title-bar = true;
  # 设定初始位置或尺寸（默认为空），附带锁定窗口比例的作用。支持多种表示方法（例值 1280x720 即初始分辨率； 50%x50% 即桌面长宽的一半）
  geometry = "";
  # <默认yes|no> 是否允许自动调节窗口大小
  # 如果使用这项参数将无效化以下选项 --autofit --autofit-larger --autofit-smaller --window-scale
  auto-window-resize = "yes";
  # 窗口自动拉伸时（初起动/切换文件）防止太大（例值 80%x80%），默认为空。使用 --autofit 系列的参数将无效化 --window-scale
  autofit-larger = "";
  # 窗口自动拉伸时（初起动/切换文件）防止太小（例值 40%x40%），默认为空
  autofit-smaller = "40%x30%";
  # 窗口自由拉伸（no）还是按比例拉伸（默认 yes）
  keepaspect-window = "yes";
  # <yes|默认no> 是否执行HIDPI缩放（推荐禁用，原因是会影响 --window-scale 的计算数值）
  hidpi-window-scale = "no";

  ##⇘⇘缓存相关

  # <yes|no|默认auto> 是否启用网络缓存（进内存）
  # 如果设为 yes ，播放本地文件时会积极的预读更多内容进内存，此大小主要由 --demuxer-max-bytes 影响
  cache = "auto";
  # 播放网络视频时的向后缓存大小（KiB或MiB），默认 150MiB
  demuxer-max-bytes = "150MiB";
  # 是否在本地存储ICC配置文件的3dlut缓存，默认 yes
  # 可以用来加快加载速度，未压缩的LUT的大小取决于 --icc-3dlut-size
  icc-cache = "yes";
  # 指定ICC配置文件的3dlut缓存目录（例值 "~~/_cache/icc"），Windows平台便携式设置下的默认实际为 "~~/cache"
  icc-cache-dir = "";
  # 是否在本地存储GLSL着色器的编译缓存，可以提高启动性能，默认 yes
  gpu-shader-cache = "yes";
  # 指定GLSL着色器的编译缓存目录（例值 "~~/_cache/shader"），Windows平台便携式设置下的默认实际为 "~~/cache"
  gpu-shader-cache-dir = "";
  # 稍后观看功能的缓存目录，其中的文件记录 --watch-later-options 指定的项。WIN平台默认为 "~~/watch_later"
  watch-later-dir = "~~/cache/watch_later";

  #############
  # OSD / OSC #
  #############
  ##⇘⇘OSD 即 On-Screen-Display，通常为屏幕上弹出显示的信息。OSC 即 on-screen-controller，MPV 中指的是简易操控界面
  ##更多自定义查询 https://mpv.io/manual/master/#osd

  osd-bar = "no";
  border = "no";
  osd-on-seek = "msg-bar"; # <no,bar,msg,msg-bar> 在跳转时间轴时显示的信息类型
  osd-bar-w = 100;
  osd-bar-h = 2;
  osd-bar-align-y = -1;
  #osd-fonts-dir=~~/fonts               # 指定 OSD 字体查找目录，示例即为默认值
  osd-font = "${fonts.mono}"; # 指定 OSD 字体
  osd-font-size = 24; # 更改 OSD 字体大小（全局，影响多个功能显示的文本）（默认值：38）
  osd-color = "#FFFFFFFF"; # OSD 文本主颜色
  osd-outline-size = 1.0; # OSD 文本轮廓大小
  osd-outline-color = "#FF000000"; # OSD 文本轮廓颜色
  osd-shadow-offset = 0.5; # OSD 文本字幕阴影大小
  osd-shadow-color = "#FF000000"; # OSD 文本字幕阴影/背景颜色
  osd-border-style = "outline-and-shadow"; # <默认 outline-and-shadow|opaque-box|background-box> 文本字幕边框的样式
  # outline-and-shadow：绘制轮廓和阴影；opaque-box：绘制轮廓和阴影；将轮廓和阴影绘制为不透明框，紧密包裹每一行文本；background-box：绘制一个背景框，将所有文本行框框起来
  #osd-spacing=1                        # OSD 文本字幕字间距
  #osd-blur=0.5                         # OSD 文本字幕的边缘模糊度 <0..20.0>
  #osd-bar-outline-size=1.2             # OSD 栏的轮廓大小
  #osd-scale-by-window=no               # <默认 yes|no> 指定是否根据窗口大小缩放 OSD
  #osd-playlist-entry=filename          # <默认 title|filename|both> 指定播放列表显示媒体标题或文件名或显示两者
  #osd-playing-msg="${?demuxer-via-network==yes:${media-title}}${?demuxer-via-network==no:${filename}} ${!playlist-count==1:列表:${playlist-pos-1}/${playlist-count}}"
  # 每个文件开始播放时短暂显示的信息。预设显示文件名
  osd-status-msg = ''''${playback-time/full} / ''${duration/full} (''${percent-pos}%)\nframe: ''${estimated-frame-number} / ''${estimated-frame-count}'';
  # 跳转时 OSD 显示的信息
  osd-fractions = "yes"; # 以秒为单位显示 OSD 时间（毫秒精度），有助于查看视频帧的确切时间戳
  osd-duration = 2000; # 设置（全局）OSD 文本信息的持续时间（毫秒）（默认值：1000）
  #osd-playing-msg-duration=2000        # --osd-playing-msg 文本的持续时间，如不设置此项，则使用全局持续时间

  ########
  # 音频 #
  ########

  # --ao=<driver1,driver2,...[,]> 指定要使用的音频输出驱动程序的优先级列表，如果列表有尾随的 ','，mpv 将回退到未包含在列表中的驱动程序
  ## windows 推荐 wasapi；linux 推荐 alsa，需配合参数--audio-channels=auto；macos 推荐 coreaudio 或 coreaudio_exclusive
  ## 经测试如果有其他软件独占音频通道后再打开 MPV 画面会无比卡顿
  ao = "alsa";
  # 此项用于指定启动时的音频输出设备，默认 auto 。改具体值示例 "wasapi/{xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx}"
  # 设备名的获取方式参见 维基的FAQ 或 https://mpv.io/manual/master/#options-audio-device
  # 同一设备ID可能受其它因素发生变化，该情况下参见上一条说明改用名词指定，示例 "wasapi/扬声器 (Realtek(R) Audio)"
  audio-device = "auto";
  # 音频通道独占（如果有其他软件先独占音频通道后，再打开MPV可能会画面会卡顿），默认 no
  audio-exclusive = "no";
  # 播放器启动音量。0为无，默认 100
  volume = 100;
  # <100.0-1000.0> 最大音量。默认 130（该响度约为100的两倍 1.3^3≈2）
  volume-max = 200;

  # <默认值 auto-safe|auto|layouts|stereo>，如果双声道系统播放多声道影片时有的声道声音没出现，尝试强制设定为双声道
  # 特殊值 stereo 强制多声道音源下混为双声道输出（避免可能的7.1/5.1→2.0声音丢失和音量过小）
  # 注意：此项必须设置为实际音频输出设备的相关声道值或优先级顺序。mpv 默认的 auto-safe 和 auto 下会出现多声道下混丢声道的问题，不推荐使用
  # 示例参数 7.1,5.1,stereo 为常见音频输出设备的优先级顺序，会自动回退选择符合实际音频输出设备的输出值（大多数使用的是 stereo 双声道设备）
  # 多声道音轨下混成双声道时，如果觉得背景音过响，角色台词声音小，尝试看看这个：https://github.com/mpv-player/mpv/issues/6563
  audio-channels = "auto-safe";
  # 变速播放时的音调修正，默认 yes
  audio-pitch-correction = "yes";
  # 音轨首选语言，但MPV优先加载外挂轨道，此项参数可能实际用处不大。
  # 默认为空，特殊值可为 auto （尝试匹配系统语言），例值（优选中文） chs,sc,zh,chi,zho
  alang = "japanese,jpn,jap,ja,jp,english,eng,en";
  # <默认 no|exact|fuzzy|all> 指定自动加载外部音轨的方式
  ## no：禁用；exact：自动加载含有符合 BCP 47 语言标签语法的扩展名的外部音轨；fuzzy：自动加载包含视频文件名的外部音轨；all：自动加载检测到的所有音轨
  audio-file-auto = "fuzzy";
  # <path1:path2:...> 在指定的额外目录中寻找匹配的音轨，支持相对和绝对路径
  ## ":" 在 windows 上使用 ";" 代替
  ## 可使用 fuzzydir.lua 增强路径配置，添加"**"可实现自动加载视频同目录下所有可匹配的子目录音轨
  audio-file-paths = "audio;audios;**";
  # <no|yes|weak 默认> 尝试在文件更改时播放连续的音频文件，而不会静音或中断。默认值 weak: 当音频格式发生变化时初始化音频输出
  gapless-audio = "no";

  ########
  # 视频 #
  ########

  ##⇘⇘音视频同步模式。
  # 默认值 audio（与音频/系统时钟同步）通常兼容性最好
  # 值 display-resample 具有类"ReClock"作用，帧速率重采样匹配刷新率以减少judder（会增加性能开销），自动调节音频速度补偿偏移
  video-sync = "audio";
  # [当 --video-sync=display-xxxx 时生效] 当使用某种 display-* 模式时，超过阈值就临时禁用，增大此值以放宽这种限制，不建议超过 5。
  # 具体情景解释见 https://mpv.io/manual/master/#options-video-sync-max-video-change
  video-sync-max-video-change = 1;
  # [当 --video-sync=display-xxxx 时生效] 减少由于视频帧率和刷新率不匹配而引起的颤动。默认 no
  interpolation = "no";
  # [当 --interpolation=yes 时生效] 时间插值算法（帧混合），默认值的效果类似MADVR的smoothmotion
  tscale = "oversample";

  ##⇘⇘“画质”相关
  # 色度还原算法。若不设定（默认），则自动采用 --scale 的值
  cscale = "";
  # 放大算法，默认值 lanczos （追求最快算法可用 bilinear ）
  scale = "lanczos";
  # 缩小算法。默认值 hermite 。若设为空值，则自动采用 --scale 的值
  dscale = "hermite";
  ##所有可用的内置算法参见手册 [06]

  # [须 --fbo-format 指定16位及以上的精度；与 --sigmoid-upscaling 不兼容] （对HDR内容无影响）默认 no
  linear-upscaling = "no";
  # [与 --linear-upscaling 不兼容] 放大时非线性的颜色转换，可避免强振铃伪影。默认 yes
  sigmoid-upscaling = "yes";
  ##开发者建议要么优先使用 --sigmoid-upscaling ，要么以上两项干脆都不用
  # [须 --fbo-format 指定16位及以上的精度] （对HDR内容无影响）默认 yes
  linear-downscaling = "yes";
  ##上两项 --linear- 的参数对应MADVR中的"scale in linear light"，在缩小时进行线性处理可以提升颜色对比度的精确性
  # [当 --dscale=bilinear 时此项无效] 可用于削弱部分算法缩小处理时产生的锯齿。默认 yes
  correct-downscaling = "yes";
  # <N|no|默认auto> 是否开启色深抖动弥补色彩转换损失。auto的实际值取决于 --vo --gpu-context 不一定正确
  # 如果选择填写具体的数值，通常应与显示驱动所设定的位深数相匹配
  dither-depth = "auto";
  # <默认fruit|ordered|error-diffusion|no> 色深抖动的算法；值 no 等效 --dither-depth=no
  # 误差扩散非常好但没必要，它基于计算着色器需要不低的性能开销，感知弱
  dither = "fruit";
  # 去色带，默认 no。可能受硬解码影响实际效果
  deband = "no";
  #profile                     = DeBand+           # 备选的去色带方案，具体参数见 "profiles.conf" 中的同名配置预设

  #profile                     = SWscaler          # 备选的软件缩放器方案，具体参数见 "profiles.conf" 中的同名配置预设

  ##⇘⇘色彩管理
  ##如果不具备该领域丰富的知识体系，不建议触碰此区块的内容。如果只是想避免广色域屏过饱和的问题，可尝试仅修改 --target-prim
  # 自动校色，默认 no
  # 如果做过专业校色应开启（系统目录存在对应的icm档）。未做校色的广色域屏推荐手动指定 --target-prim
  icc-profile-auto = "no";
  # 此选项用于加载指定的ICC，与前项不共存。默认为空，例值 "X:/xxx/xxxx.icm"
  icc-profile = "";
  # <2-512> 从ICC配置文件的每个维度生成的3D LUT的大小。默认 auto ，通常如 64x64x64 这样的示例值已足够
  icc-3dlut-size = "auto";
  # <默认no|0-1000000|inf> 强制指定ICC的静态对比度而不是使用配置文件的内设（可能存在测量错误）
  # 普通LCD一般使用 1000（以面板原生数据为准）；使用OLED显示设备的用户尝试使用 1000000 或特殊值 inf

  icc-force-contrast = "no";
  # [不与 --icc-* 一起使用] 当不使用ICC时，视频颜色将适应此颜色空间
  # 例如99%的argb屏幕写 adobe 。90%+的p3色域屏写 display-p3 （标准srgb屏无需更改此默认值）
  target-prim = "auto";
  # [不与 --icc-* 一起使用] 当不使用ICC时，使用指定的传输特性。一般显示器使用值 gamma2.2
  target-trc = "auto";

  ####################
  # 脚本 滤镜 着色器 #
  ####################

  ##以下都可选择在此处开启，即默认每次随播放器启动；或者使用"input.conf"中的方案手动选择加载

  ##⇘⇘脚本部分

  ##内置脚本开关（如果没有必要的目的，那就不要屏蔽mpv内建的功能）

  # <yes|no|默认auto> 新版条件配置预设（使用旧版外挂的用户记得禁用）
  load-auto-profiles = "no";
  # [须要 --load-console=yes ] 多功能信息展示与控制，默认 yes
  load-select = "no";
  # 统计信息，默认 yes
  load-stats-overlay = "no";
  # 网址解析增强，默认 yes
  ytdl = "yes";
  # [当 --ytdl=yes 时有效] 将自定义的选项传递给ytdl，默认为空 https://github.com/ytdl-org/youtube-dl#options
  # 示例（ cookies-from-browser=firefox ）仅为传递单个选项，多个选项最好独立追加，即写多个 --ytdl-raw-options-append 参数
  ytdl-raw-options-append = "";
  # 在启动期间禁用 mpv 内置键位绑定的加载。此选项不会影响外部加载脚本的键位绑定
  #input-builtin-bindings=no
  # 禁用 mpv 内置键位及外部加载脚本的--mp.add_key_binding 键位绑定方案
  ## 可以有效解决脚本快捷键冲突，启用后需在 input.conf 里指定所需快捷键
  input-default-bindings = "no";

  ##外置脚本开关
  # 自动挂载 /scripts/ 目录中的所有外置脚本，默认 yes。设置为no时可用下一行示例的命令加载指定的外置脚本
  # load-scripts = "yes";
  # scripts = "~~/scripts/xxxxx.lua;~~/scripts/yyyyy.lua";

  ##⇘⇘滤镜部分
  ##设定随MPV启动的音/视频滤镜的书写格式（支持多项） --af/vf=滤镜①=参数❶=值:参数❷=值,滤镜②...
  ## --af 和 --vf 仅能各存在一条。如果不想只使用这条参数，可以拆开写，例如使用 --vf-append 单项多次追加更多的滤镜，并不会覆盖 --vf 指定的滤镜
  ##更多实用向的滤镜可参考 https://github.com/hooke007/MPV_lazy/discussions/120

  # vf = "vflip";
  # vf-append = "hflip";
  # vf-append = "format=rotate=90";

  ##⇘⇘着色器部分
  ##此处的 --glsl-shaders 用于指定每次随MPV共同启动的着色器（支持多项）。具体的着色器信息参见 https://hooke007.github.io/unofficial/mpv_shaders.html
  ##--glsl-shaders-append 等效 --glsl-shader （注意和上行中参数的区别），表示追加着色器（单次仅能追加一项），并不会覆盖第一条 --glsl-shaders 指定的着色器，可无限追加该命令。

  ##初始加载多个着色器的示例写法
  # glsl-shaders = "~~/shaders/hooks_01.glsl;~~/shaders/hooks_02.glsl;~~/shaders/hooks_03.glsl";

  ##下接的逐个单项 --glsl-shaders-append （或 --glsl-shader ） 会依次排列在 --glsl-shaders 之后，当然你也可以不写 --glsl-shaders 只用前二者选项的队列
  # glsl-shaders-append = "~~/shaders/hooks_04.glsl";
  # glsl-shaders-append = "~~/shaders/hooks_05.glsl";

  ########
  # 字幕 #
  ########
  # <no|默认 exact|fuzzy|all> 指定自动加载外部字幕的方式
  ## no：禁用；exact：自动加载含有符合 BCP 47 语言标签语法的扩展名的外部字幕；fuzzy：自动加载包含视频文件名的外部字幕；all：自动加载检测到的所有字幕
  sub-auto = "fuzzy";
  # 在指定的额外目录中寻找匹配的字幕。支持相对和绝对路径，默认为空
  # 例值（ sub;subtitles;字幕;C:/字幕库 ）即自动搜索当前文件路径下名为"sub","subtitles","字幕"和C盘的"字幕库"文件夹内
  sub-file-paths = "";
  # 字幕首选语言，但MPV优先加载外挂轨道，此项参数可能实际用处不大。
  # 默认值为空 （尝试匹配系统语言），例值（优选中文） chs,sc,zh,chi,zho
  slang = "chs,sc,zh-CN,zh-Hans,cht,tc,zh-Hant,zh-HK,zh-TW,chi,zho,zh";
  # <yes|默认default|no> 现有字幕轨无法满足 --slang 的条件时是否回退选择其它字幕，值 default 表示仅选择带有“默认”标记的轨道
  subs-fallback = "default";
  # <yes|video|默认no> 在插值和颜色管理之前，将字幕混合到视频帧上。值video类似于yes，但是以视频的原始分辨率绘制字幕，并与视频一起缩放
  # 启用此功能会将字幕限制在视频的可见部分（不能出现在视频下方的黑色空白处）
  # 还会让字幕受 --icc-profile --target-prim --target-trc --interpolation --gamma-factor --glsl-shaders 的影响
  # 与 --interpolation 一起使用时，可提高字幕渲染性能
  blend-subtitles = "no";
  # <默认auto|none|fontconfig> 字幕字体提供程序。默认 auto 将根据系统选择不同的字体提供程序。
  # none 将不使用任何字体提供程序，字幕字体只能从配置目录 `fonts` 文件夹和嵌入字体 (除非禁用了嵌入字体 embeddedfonts=no) 加载。
  # fontconfig 将使用 fontconfig 作为字体提供程序，如果当前 mpv 构建不支持 fontconfig，将不使用任何字体提供程序。
  # fontconfig 可以配合 auto_load_fonts 脚本实现自动加载当前文件目录下 fonts 文件夹内的字体文件
  # auto_load_fonts 脚本使用说明: https://github.com/hooke007/MPV_lazy/discussions/189

  sub-font-provider = "auto";

  ##⇘⇘纯文本字幕部分 —— SRT LRC
  ##更多自定义查询 https://mpv.io/manual/master/#options-sub-font

  # 指定文本字幕的默认字体名（不是字体的文件名），默认 sans-serif ，例值： LXGW WenKai
  # 当前也被用作ASS字幕的回退字体
  # 指定纯文本字幕的字体，该参数本应对 ASS 字幕无效，实际影响了 ASS 的缺省默认字体 https://github.com/mpv-player/mpv/issues/8637
  sub-font = "${fonts.mono}";
  # 纯文本字幕的尺寸
  sub-font-size = 50;
  # 文本字幕使用粗体样式
  sub-bold = "yes";
  # 文本字幕字体颜色。<格式为 (AA)RRGGBB> AA 为十六进制的透明度，RRGGBB 为十六进制的颜色表示
  sub-color = "#FFFFFFFF";
  # <格式为(AA)RRGGBB> 设定纯文本字幕的背景色
  sub-back-color = "#00000000";
  # 文本字幕轮廓大小
  sub-outline-size = 0.5;
  # 文本字幕轮廓颜色
  sub-outline-color = "#FF000000";
  # 文本字幕阴影大小
  sub-shadow-offset = 0.5;
  # 文本字幕阴影/背景颜色
  sub-shadow-color = "#FF000000";
  # 是否使纯文本字幕输出在黑边上，默认 yes
  sub-use-margins = "yes";

  ##⇘⇘高级字幕部分 —— SSA ASS
  # <no|yes|默认scale|force|strip> 是否覆盖字幕脚本的原始样式。值 yes 只应用 --sub-ass-* 类的选项
  # scale 在此基础上也应用了 --sub-scale ， force 会尝试应用所有 --sub-* 的选项， strip 剥离全部ASS标记和样式
  sub-ass-override = "scale";
  # 字幕随窗口缩放而不是随视频缩放，默认 no
  sub-ass-scale-with-window = "no";
  # 是否使用mkv容器的内嵌字体，默认 yes
  embeddedfonts = "yes";
  # [当 --blend-subtitles=yes/video 时无效] 是否使ASS字幕尽可能输出在黑边上，默认 no
  sub-ass-force-margins = "no";
  # 使用自定义的参数以覆盖字幕文件内的预设。默认为空，例值（覆盖字幕内的所有字体） Fontname=LXGW WenKai
  sub-ass-style-overrides = "";

  ##⇘⇘模拟vsfilter相关
  ##默认情况下libass和vsfilter渲染的字幕存在部分差异，以下选项可用于使视觉效果相近（模仿vsfilter）

  # <none|aspect-ratio|默认all> 控制传递给 libass 的视频流信息
  # 值 aspect-ratio 对部分未设置LayoutRes头信息的字幕可能有效，影响3d旋转和blur的效果；值 none 对宽高比异常视频可能有效
  sub-ass-use-video-data = "all";
  # [须要 --sub-ass-use-video-data 设为任意非 none 的值] 覆盖向libass传递指定的宽高比（例如 3:2），而不是视频的实际宽高比。默认 no
  sub-ass-video-aspect-override = "no";
  # <默认basic|full|force-601|no> 字幕色彩空间处理
  sub-ass-vsfilter-color-compat = "basic";

  ##⇘⇘图形字幕部分 —— IDX SUB SUP
  # 拉伸图形字幕到缩放分辨率而不是参考视频分辨率，可以使PGS实现输出在黑边的效果，可能破坏显示效果。默认 no
  stretch-image-subs-to-screen = "no";
  # 使用视频分辨率覆盖图形字幕的原始分辨率，默认 no
  image-subs-video-resolution = "no";

  ########
  # 截图 #
  ########
  # <默认 jpg|(同前)jpeg|png|webp|jxl|avif>
  screenshot-format = "jpg";

  ##更多其它格式对应的关联选项参见官方手册
  ## https://mpv.io/manual/master/#options-screenshot-webp-lossless
  ## https://mpv.io/manual/master/#options-screenshot-avif-encoder
  # <0-100> JPEG的质量，默认 90
  screenshot-jpeg-quality = 90;
  # 用与源视频相同的色度半采样写入JPEG，默认 yes
  screenshot-jpeg-source-chroma = "yes";
  # <0-9> PNG压缩等级，过高的等级影响性能，默认 7
  screenshot-png-compression = 7;
  # <0-5> PNG的压缩过滤器。默认值 5 即可实现最佳压缩率
  screenshot-png-filter = 5;
  # <0-15> JXL的视觉模型距离，0为质量无损，0.1为视觉无损，默认值 1 相当于JPEG的90质量
  screenshot-jxl-distance = 1;
  # <1-9> JXL压缩等级，过高的等级影响性能，默认 4

  screenshot-jxl-effort = 4;
  # 使用适当的色彩空间标记屏幕截图（并非所有格式受支持）默认 yes
  screenshot-tag-colorspace = "yes";
  # 尽可能使用高位深作截屏，可能导致巨大的文件体积（并非所有格式受支持），默认 yes
  screenshot-high-bit-depth = "yes";
  # 截图命名模板： https://mpv.io/manual/master/#options-screenshot-template
  # 示例即默认值。可额外选填路径，例值 "~~desktop/MPV-%P-N%n"
  screenshot-template = "~~/files/screen/%{media-title}-%P-%n";
  # [若已在截图命名模板中设置路径，此时无需使用该选项 ] 默认为空，例值（保存截图在桌面） "~~desktop/"
  # screenshot-dir = "";

  ##################
  # 通用参数补充区 #
  ##################

  # [须 --gpu-api=d3d11] 此项参数用于直出 HDR，且不支持条件配置会影响 sdr 播放。
  # 当前版本需先手动打开 win10 OS HDR，再打开 MPV 后全屏开始播放
  # d3d11-output-csp="pq";
  # 在播放文件同目录中加载配置文件
  # 默认 no https://mpv.io/manual/master/#file-specific-configuration-files
  use-filedir-conf = "no";
  # 追加读取指定的配置文件
  # 自此以下的所有配置组参数亦可单独放入"~~/profiles.conf"中，启用此参数时效果一致
  # include="~~/profiles.conf";
  # 指定 input 配置文件，用于指定键位绑定
  # input-conf="~~/input.conf";
  # 将额外的原始选项传递给 libplacebo 渲染后端（由 --vo=gpu-next 使用），用于调试目的
  # 详细参数见：http://libplacebo.org/options
  # 示例参数作用为：强制使用峰值检测进行 hdr 色调映射
  libplacebo-opts = "tone_map_metadata=cie_y";

  ##⇘⇘以下为常规配置组启用参数，视需求选择使用
  profile = [
  ];

  # uosc options
  # There's an "ad" type, but gets really annoying when you download all sponsorblock settings
  script-opts = ''uosc-chapter_ranges="openings:30abf964,endings:30abf964"'';
}
