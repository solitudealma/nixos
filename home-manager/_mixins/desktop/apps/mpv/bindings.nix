{
  adaptive-sharpen,
  AMD_FSR,
  anime4k,
  FSRCNNX_x2_8_0_4_1,
  KrigBilateral,
  mpv-lazy,
  mpv-prescalers,
  SSimDownscaler,
  SSimSuperRes,
  ...
}: let
in {
  # 左键单击暂停/双击忽略
  MBTN_LEFT = "cycle pause;script-message-to uosc flash-pause-indicator";
  MBTN_LEFT_DBL = "ignore";
  # 右键呼出菜单
  MBTN_Right = "script-binding uosc/menu";
  # 前进键 切换到列表中的下个文件
  MBTN_FORWARD = ''playlist-next;show-text "播放列表:''${playlist-pos-1}/''${playlist-count}"'';
  # 后退键 切换到列表中的上个文件
  MBTN_BACK = ''playlist-prev;show-text "播放列表:''${playlist-pos-1}/''${playlist-count}"'';
  MBTN_Right_DBL = "ignore";

  # 滚轮控制音量
  AXIS_UP = "no-osd add volume 2; script-message-to uosc flash-volume";
  AXIS_DOWN = "no-osd add volume -2; script-message-to uosc flash-volume";

  #暂停
  SPACE = "cycle pause;script-message-to uosc flash-pause-indicator";

  # 媒体按键
  ##以下键位不显示在 uosc 菜单中
  # 开/关 uosc 菜单
  MENU = "script-message-to uosc menu-blurred";
  PLAY = "cycle pause;script-message-to uosc flash-pause-indicator";
  PAUSE = "cycle pause;script-message-to uosc flash-pause-indicator";
  PLAYPAUSE = "cycle pause;script-message-to uosc flash-pause-indicator";
  FORWARD = "seek  30";
  POWER = "quit";
  STOP = "quit";
  REWIND = "seek -30";
  VOLUME_UP = ''add volume +2 ; show-text "Volume: ''${volume}"'';
  VOLUME_DOWN = ''add volume -2 ; show-text "Volume: ''${volume}"'';
  MUTE = "cycle mute";
  NEXT = "playlist-next";
  PREV = "playlist-prev";
  CLOSE_WIN = "quit";

  ##⇘⇘uosc 一级菜单：打开
  o = "script-message-to uosc open-file"; #menu: 打开 > 打开内置浏览器
  TAB = "script-binding recent/display-recent"; #menu: 打开 > Recent list
  "`" = "script-binding console/enable"; # 启用控制台

  ##⇘⇘uosc 一级菜单：文件
  f = "cycle fullscreen"; #menu: 文件 > 开/关 全屏          #@state=(fullscreen and 'checked')
  i = "script-binding stats/display-stats"; #menu: 文件 > 临时显示统计信息
  I = "script-binding stats/display-stats-toggle"; #menu: 文件 > 常驻显示统计信息
  "[" = "no-osd add speed -0.1; script-binding uosc/flash-speed"; #menu: 文件 > 速度 > 速度 -0.1
  "]" = "no-osd add speed  0.1; script-binding uosc/flash-speed"; #menu: 文件 > 速度 > 速度 +0.1
  BS = "no-osd set speed  1.0; script-binding uosc/flash-speed"; #menu: 文件 > 速度 > 重置速度
  "ALT+o" = "script-binding uosc/show-in-directory"; #menu: 文件 > 定位当前文件

  ##⇘⇘uosc 一级菜单：导航
  "<" = ''frame-back-step;show-text "当前帧：''${estimated-frame-number}"''; #menu: 导航 > 前进后退 > 上一帧
  ">" = ''frame-step     ;show-text "当前帧：''${estimated-frame-number}"''; #menu: 导航 > 前进后退 > 下一帧
  RIGHT = "seek 5; script-binding uosc/flash-timeline"; #menu: 导航 > 前进后退 > 前进 5 秒
  LEFT = "seek -5; script-binding uosc/flash-timeline"; #menu: 导航 > 前进后退 > 后退 5 秒
  UP = "no-osd add volume 2; script-binding uosc/flash-volume"; # 音量
  DOWN = "no-osd add volume -2; script-binding uosc/flash-volume"; # 音量
  "SHIFT+RIGHT" = "seek  1 exact"; #menu: 导航 > 前进后退 > 精准前进 1 秒
  "SHIFT+LEFT" = "seek -1 exact"; #menu: 导航 > 前进后退 > 精准后退 1 秒
  "CTRL+z" = "script-message-to undoredo undo"; #menu: 导航 > 跳转 > 撤消跳转
  "CTRL+x" = "script-message-to undoredo redo"; #menu: 导航 > 跳转 > 重做跳转
  "CTRL+ALT+z" = "script-message-to undoredo undoLoop"; #menu: 导航 > 跳转 > 循环跳转

  ##⇘⇘uosc 一级菜单：画面
  #                set video-aspect-override "-1";show-text "宽高比:${video-aspect-override}"                             #menu: 画面 > 切换 宽高比 > 默认值
  #                set video-aspect-override "16:9";show-text "宽高比:${video-aspect-override}"                           #menu: 画面 > 切换 宽高比 > 16:9
  #                set video-aspect-override "4:3";show-text "宽高比:${video-aspect-override}"                            #menu: 画面 > 切换 宽高比 > 4:3
  #                set video-aspect-override "2.35:1";show-text "宽高比:${video-aspect-override}"                         #menu: 画面 > 切换 宽高比 > 2.35:1
  A = ''cycle-values video-aspect-override 16:9 4:3 2.35:1 -1;show-text "宽高比:''${video-aspect-override}"''; #menu: 画面 > 切换 宽高比 > 循环切换
  "CTRL+LEFT" = ''cycle-values video-rotate 0 270 180 90;show-text "视频旋转:''${video-rotate}"''; #menu: 画面 > 左旋转
  "CTRL+RIGHT" = ''cycle-values video-rotate 0 90 180 270;show-text "视频旋转:''${video-rotate}"''; #menu: 画面 > 右旋转
  "ALT+-" = ''add video-zoom   -0.1;show-text "画面缩小:''${video-zoom}"''; #menu: 画面 > 画面缩放 > 画面缩小
  "ALT+=" = ''add video-zoom    0.1;show-text "画面放大:''${video-zoom}"''; #menu: 画面 > 画面缩放 > 画面放大
  "ALT+LEFT" = ''add video-pan-x  -0.1;show-text "画面左移动:''${video-pan-x}"''; #menu: 画面 > 画面缩放 > 画面左移动
  "ALT+RIGHT" = ''add video-pan-x   0.1;show-text "画面右移动:''${video-pan-x}"''; #menu: 画面 > 画面缩放 > 画面右移动
  "ALT+UP" = ''add video-pan-y  -0.1;show-text "画面上移动:''${video-pan-y}"''; #menu: 画面 > 画面缩放 > 画面上移动
  "ALT+DOWN" = ''add video-pan-y   0.1;show-text "画面下移动:''${video-pan-y}"''; #menu: 画面 > 画面缩放 > 画面下移动
  "ALT+p" = ''cycle-values panscan 0.0 1.0;show-text "视频画面缩放:''${panscan}"''; #menu: 画面 > 开/关 裁切填充        #@state=(panscan and 'checked')                                                                                               #menu: 画面 > ---
  "ALT+BS" = ''set video-zoom 0;set panscan 0;set video-rotate 0;set video-pan-x 0;set video-pan-y 0;set video-aspect-override -1;show-text "重置画面操作"''; #menu: 画面 > 重置以上画面操作

  "1" = ''add contrast -1;show-text "对比度:''${contrast}"''; #menu: 画面 > 调色 > 对比度 -1
  "2" = ''add contrast  1;show-text "对比度:''${contrast}"''; #menu: 画面 > 调色 > 对比度 +1
  "3" = ''add brightness -1;show-text "明度:''${brightness}"''; #menu: 画面 > 调色 > 明度 -1
  "4" = ''add brightness  1;show-text "明度:''${brightness}"''; #menu: 画面 > 调色 > 明度 +1
  "5" = ''add gamma -1;show-text "伽马:''${gamma}"''; #menu: 画面 > 调色 > 伽马 -1
  "6" = ''add gamma  1;show-text "伽马:''${gamma}"''; #menu: 画面 > 调色 > 伽马 +1
  "7" = ''add saturation -1;show-text "饱和度:''${saturation}"''; #menu: 画面 > 调色 > 饱和度 -1
  "8" = ''add saturation  1;show-text "饱和度:''${saturation}"''; #menu: 画面 > 调色 > 饱和度 +1
  "-" = ''add hue -1;show-text "色相:''${hue}"''; #menu: 画面 > 调色 > 色相 -1
  "=" = ''add hue  1;show-text "色相:''${hue}"''; #menu: 画面 > 调色 > 色相 +1
  "CTRL+BS" = ''set contrast 0;set brightness 0;set gamma 0;set saturation 0;set hue 0;show-text "重置调色"''; #menu: 画面 > 调色 > 重置
  D = ''cycle deband;show-text "去色带:''${deband}"''; #menu: 画面 > 去色带 > deband 开关	  #@state=(deband and 'checked')
  "ALT+z" = ''add   deband-iterations +1;show-text "增加去色带强度:''${deband-iterations}"''; #menu: 画面 > 去色带 > deband 强度 +1
  "ALT+x" = ''add   deband-iterations -1;show-text "降低去色带强度:''${deband-iterations}"''; #menu: 画面 > 去色带 > deband 强度 -1
  h = ''cycle-values tone-mapping auto spline bt.2390 hable bt.2446a st2094-40;show-text "HDR 映射曲线:''${tone-mapping}"''; #menu: 画面 > HDR 相关 > 切换 HDR 映射曲线
  "ALT+h" = ''cycle-values hdr-compute-peak yes no;show-text "HDR 动态映射:''${hdr-compute-peak}"''; #menu: 画面 > HDR 相关 > 切换 HDR 动态映射  #@state=(hdr_compute_peak and 'checked')
  "CTRL+h" = ''cycle target-colorspace-hint;show-text "HDR 直通模式:''${target-colorspace-hint}"''; #menu: 画面 > HDR 相关 > 切换 HDR 直通模式  #@state=(target_colorspace_hint and 'checked')
  "CTRL+t" = ''cycle-values target-trc auto pq gamma2.2;show-text "显示器传输特性:''${target-trc}"''; #menu: 画面 > HDR 相关 > 切换 显示器传输特性
  "CTRL+T" = ''cycle-values target-peak 100 203;show-text "映射目标峰值:''${target-peak}"''; #menu: 画面 > HDR 相关 > 切换 映射目标峰值
  "CTRL+g" = ''cycle gamut-mapping-mode ;show-text "色域映射模式:''${gamut-mapping-mode}"''; #menu: 画面 > HDR 相关 > 切换 色域映射模式

  ##⇘⇘menu 一级菜单：轨道
  #                ignore                                                                                                 #menu: 菜单 > 轨道     #@tracks
  #                ignore                                                                                                 #menu: 菜单 > 次字幕   #@tracks/sub-secondary

  ##⇘⇘uosc 一级菜单：视频

  "ALT+i" = ''cycle interpolation; show-text "抖动补偿:''${interpolation}"''; #menu: 视频 > 开/关 抖动补偿              #@state=(interpolation and 'checked')
  d = ''cycle deinterlace; show-text "去交错:''${deinterlace}"''; #menu: 视频 > 开/关 反交错                #@state=(deinterlace and 'checked')
  s = "screenshot subtitles"; #menu: 视频 > 截屏 > 同源尺寸 - 有字幕 - 无 OSD-单帧
  S = "screenshot video"; #menu: 视频 > 截屏 > 同源尺寸 - 无字幕 - 无 OSD-单帧
  "CTRL+s" = ''show-text "截屏" 400;script-message delay-command 0.5 screenshot window''; #menu: 视频 > 截屏 > 实际尺寸 - 有字幕 - 有 OSD-单帧
  "ALT+s" = "screenshot subtitles+each-frame"; #menu: 视频 > 截屏 > 同源尺寸 - 有字幕 - 无 OSD-逐帧
  "ALT+S" = "screenshot video+each-frame"; #menu: 视频 > 截屏 > 同源尺寸 - 无字幕 - 无 OSD-逐帧
  "CTRL+S" = ''show-text "逐帧截屏" 400;script-message delay-command 0.5 screenshot window+each-frame''; #menu: 视频 > 截屏 > 实际尺寸 - 有字幕 - 有 OSD-逐帧

  ##⇘⇘uosc 一级菜单：音频
  y = ''cycle audio;show-text "音轨切换为:''${audio}"''; #menu: 音频 > 切换 音频轨
  m = ''cycle mute;show-text "静音:''${mute}"''; #menu: 音频 > 切换 静音          #@state=(mute and 'checked')
  "CTRL+," = ''add audio-delay -0.1;show-text "音频延迟:''${audio-delay}"''; #menu: 音频 > 延迟 -0.1
  "CTRL+." = ''add audio-delay  0.1;show-text "音频预载:''${audio-delay}"''; #menu: 音频 > 延迟 +0.1
  ";" = ''set audio-delay  0  ;show-text "重置音频延迟:''${audio-delay}"''; #menu: 音频 > 延迟 重置
  "CTRL+y" = ''cycle audio-exclusive  ;show-text "音频独占模式:''${audio-exclusive}"''; #menu: 音频 > 切换 音频独占模式  #@state=(audio_exclusive and 'checked')
  "CTRL+Y" = ''cycle hr-seek-framedrop;show-text "音频同步模式:''${hr-seek-framedrop}"''; #menu: 音频 > 切换 音频同步模式  #@state=(hr_seek_framedrop and 'checked')
  "ALT+y" = ''cycle-values audio-channels "7.1,5.1,stereo" "7.1" "5.1" "stereo" "auto-safe" "auto";show-text "音频通道输出方式:''${audio-channels}"''; #menu: 音频 > 音频通道输出方式 > 循环切换
  F2 = ''cycle-values  af "@dynaudnorm:lavfi=[dynaudnorm=f=500:g=31:p=0.5:m=5:r=0.9]" "@loudnorm:lavfi=[loudnorm=I=-16:TP=-1.5:LRA=11]" ""''; #menu: 音频 >  切换 下混滤镜
  "ALT+`" = ''af clr ""''; #menu: 音频 > 清空 af 滤镜

  ##⇘⇘uosc 一级菜单：字幕
  j = ''cycle sub;show-text "字幕切换为:''${sub}"''; #menu: 字幕 > 切换 字幕轨
  k = ''cycle secondary-sid;show-text "切换次字幕:''${secondary-sid}"''; #menu: 字幕 > 切换 次字幕
  v = ''cycle sub-visibility;show-text "字幕可见性:''${sub-visibility}"''; #menu: 字幕 > 切换 字幕可见性   #@state=(sub_visibility and 'checked')
  "ALT+V" = ''cycle secondary-sub-visibility;show-text "次字幕可见性:''${secondary-sub-visibility}"''; #menu: 字幕 > 切换 次字幕可见性 #@state=(secondary_sub_visibility and 'checked')
  u = ''cycle sub-ass-override;show-text "字幕渲染样式:''${sub-ass-override}"''; #menu: 字幕 > 切换 渲染样式
  F = ''cycle-values sub-font "Noto Sans CJK SC" "Noto Sans CJK KR" "Noto Serif CJK SC" "Noto Serif CJK KR";show-text "字幕字体:''${sub-font}"''; #menu: 字幕 > 切换 默认字体
  "CTRL+r" = ''sub-reload;show-text "重载当前字幕"''; #menu: 字幕 > 重载当前字幕
  #                ignore                                                                                                 #menu: 字幕 > ---
  "ALT+R" = ''cycle secondary-sub-ass-override;show-text "次字幕样式覆盖:''${secondary-sub-ass-override}"''; #menu: 字幕 > 兼容性 > 切换 次字幕样式覆盖      #@state=(secondary_sub_ass_override and 'checked')
  "ALT+T" = ''cycle-values blend-subtitles yes no;show-text "字幕混合视频帧:''${blend-subtitles}"''; #menu: 字幕 > 兼容性 > 切换 字幕混合视频帧      #@state=(blend_subtitles and 'checked')
  K = ''cycle sub-fix-timing                 ;show-text "字幕时序修复:''${sub-fix-timing}"''; #menu: 字幕 > 兼容性 > 切换 字幕时序修复        #@state=(sub_fix_timing and 'checked')
  J = ''cycle sub-ass-vsfilter-color-compat  ;show-text "字幕颜色转换方式:''${sub-ass-vsfilter-color-compat}"''; #menu: 字幕 > 兼容性 > 切换 字幕颜色转换方式
  V = ''cycle sub-ass-use-video-data ;show-text "使用视频信息:''${sub-ass-use-video-data}"''; #menu: 字幕 > 兼容性 > 切换 使用视频信息
  "ALT+B" = ''cycle sub-vsfilter-bidi-compat       ;show-text "bidi 双向检测兼容性:''${sub-vsfilter-bidi-compat}"''; #menu: 字幕 > 兼容性 > 切换 bidi 双向检测兼容性 #@state=(sub_vsfilter_bidi_compat and 'checked')
  "ALT+X" = ''cycle-values sub-ass-style-overrides "ScaledBorderAndShadow=no" "ScaledBorderAndShadow=yes";show-text "强制替换 ass 样式:''${sub-ass-style-overrides}"''; #menu: 字幕 > 兼容性 > 切换 ass 字幕阴影边框缩放
  H = ''cycle sub-ass-force-margins          ;show-text "ass 字幕输出黑边:''${sub-ass-force-margins}"''; #menu: 字幕 > 兼容性 > 切换 ass 字幕输出到黑边  #@state=(sub_ass_force_margins and 'checked')
  "ALT+Z" = ''cycle sub-use-margins                ;show-text "srt 字幕输出黑边:''${sub-use-margins}"''; #menu: 字幕 > 兼容性 > 切换 srt 字幕输出到黑边  #@state=(sub_use_margins and 'checked')
  P = ''cycle stretch-image-subs-to-screen   ;show-text "pgs 字幕输出黑边:''${stretch-image-subs-to-screen}"''; #menu: 字幕 > 兼容性 > 切换 pgs 字幕输出到黑边  #@state=(stretch_image_subs_to_screen and 'checked')
  p = ''cycle sub-gray;show-text "pgs 字幕灰度转换:''${sub-gray}"''; #menu: 字幕 > 兼容性 > 切换 pgs 字幕灰度转换    #@state=(sub_gray and 'checked')
  #                ="ignore                                                                                                 #menu: 字幕 > ---
  Y = "script-message sub-select toggle"; #menu: 字幕 > 切换 字幕选择脚本
  "CTRL+d" = "script-message-to sub_assrt sub-assrt"; #menu: 字幕 > 打开 字幕下载菜单
  "CTRL+m" = "script-message-to autosubsync autosubsync-menu"; #menu: 字幕 > 打开 字幕同步菜单
  "CTRL+M" = "script-binding subtitle_lines/list_subtitles"; #menu: 字幕 > 打开 字幕内容菜单
  "ALT+m" = "script-message-to sub_export export-selected-subtitles"; #menu: 字幕 > 导出当前内封字幕
  "ALT+f" = "script-message-to sub_fastwhisper sub-fastwhisper"; #menu: 字幕 > 生成 AI 字幕
  #                ignore                                                                                                 #menu: 字幕 > ---
  r = ''add sub-pos -1;show-text "字幕上移:''${sub-pos}"''; #menu: 字幕 > 其他操作 > 字幕上移
  t = ''add sub-pos +1;show-text "字幕下移:''${sub-pos}"''; #menu: 字幕 > 其他操作 > 字幕下移
  R = ''add secondary-sub-pos -1;show-text "次字幕上移:''${secondary-sub-pos}"''; #menu: 字幕 > 其他操作 > 次字幕上移
  T = ''add secondary-sub-pos +1;show-text "次字幕下移:''${secondary-sub-pos}"''; #menu: 字幕 > 其他操作 > 次字幕下移
  z = ''add sub-delay -0.1;show-text "字幕延迟:''${sub-delay}"''; #menu: 字幕 > 其他操作 > 字幕延迟 -0.1
  x = ''add sub-delay  0.1;show-text "字幕预载:''${sub-delay}"''; #menu: 字幕 > 其他操作 > 字幕延迟 +0.1
  Z = ''add secondary-sub-delay -0.1;show-text "次字幕延迟:''${secondary-sub-delay}"''; #menu: 字幕 > 其他操作 > 次字幕延迟 -0.1
  X = ''add secondary-sub-delay  0.1;show-text "次字幕预载:''${secondary-sub-delay}"''; #menu: 字幕 > 其他操作 > 次字幕延迟 +0.1
  "ALT+k" = ''add sub-scale -0.1;show-text "字幕缩小:''${sub-scale}"''; #menu: 字幕 > 其他操作 > 字号 -0.1
  "ALT+j" = ''add sub-scale  0.1;show-text "字幕放大:''${sub-scale}"''; #menu: 字幕 > 其他操作 > 字号 +0.1
  "SHIFT+BS" = ''set sub-pos 100;set sub-scale 1.0;set sub-delay 0;show-text "重置字幕状态"''; #menu: 字幕 > 其他操作 > 恢复初始

  ##############
  ## 滤镜列表 ##
  ##############

  ##⇘⇘很多滤镜不支持 无-copy 的纯硬解方式（即 hwdec=xxxx )，最好使用 hwdec=no 或 hwdec=xxxx-copy 获得更好的兼容性
  ##其它未列出的方案按需添加修改，滤镜的详细语法说明参见 https://hooke007.github.io/unofficial/mpv_filters.html

  ##VS的补帧类脚本只能同时启用单个，启用另一个前先关闭其它
  ##开启/关闭 mvtools 补帧方案一 <shift 1>
  "!" = ''vf toggle vapoursynth="${mpv-lazy}/portable_config/vs/MEMC_MVT_LQ.vpy"''; # 开/关 mvtools补帧方案一
  ##开启/关闭 mvtools 补帧方案二 <shift 2>
  "@" = ''vf toggle vapoursynth="${mpv-lazy}/portable_config/vs/MEMC_MVT_STD.vpy"''; # 开/关 mvtools补帧方案二
  ##开启/关闭 svpflow 补帧方案一 <shift 3>
  SHARP = ''vf toggle vapoursynth="${mpv-lazy}/portable_config/vs/MEMC_SVP_LQ.vpy"''; # 开/关 svpflow补帧方案一
  ##开启/关闭 svpflow 补帧方案二 <shift 4>
  "$" = ''vf toggle vapoursynth="${mpv-lazy}/portable_config/vs/MEMC_SVP_PRO.vpy"''; # 开/关 svpflow补帧方案二
  ##开启/关闭 rife 补帧 <shift 5>
  "%" = ''vf toggle vapoursynth="${mpv-lazy}/portable_config/vs/MEMC_RIFE_STD.vpy"''; # 开/关 rife补帧

  ##开启/关闭 强制片源的色阶标记为16-235（少数片源存在压制后色彩范围标记错误，具体表现在背景纯黑显灰色/底色纯白却发绿） <shift 6>
  "^" = "vf toggle format=colorlevels=limited"; # 开/关 标记动态范围为有限
  ##开启/关闭 增加黑边（适用于2.35:1的片源适配16:9的字幕） <shift 7>
  "&" = "vf toggle pad=aspect=16/9:x=-1:y=-1"; # 开/关 填充黑边至16:9并居中源

  ##开启/关闭 画面转动 <shift 8> <shift 9> <shift 0>
  "*" = "vf toggle rotate=angle=180*PI/180"; # 开/关 画面旋转180°
  "(" = "vf toggle vflip"; # 开/关 画面垂直翻转
  ")" = "vf toggle hflip"; # 开/关 画面水平翻转

  ##开启/关闭 伽马修正为2.2，可用于校色后的调整（默认ICC校正以BT.1886为目标曲线） <shift ->
  "_" = "vf toggle format=gamma=gamma2.2"; # 开/关 伽马修正2.2

  ##开启/关闭 超级反交错方案 <shift =>
  "+" = ''vf toggle vapoursynth="${mpv-lazy}/portable_config/vs/ETC_DEINT_EX.vpy"''; # 开/关 QTGMC去隔行

  ################
  ## 着色器列表 ##
  ################
  ##⇘⇘第三方着色器的详细说明见 https://hooke007.github.io/unofficial/mpv_shaders.html
  ##开启/关闭 单项：KrigBilateral（速度较慢，高级色度还原，极高质量但感知很弱）
  "CTRL+1" = ''change-list glsl-shaders toggle "${KrigBilateral}"'';
  ##开启/关闭 单项：AMD_FSR（速度很快，放大到目标分辨率，伴随对比度自适应锐化）
  "CTRL+2" = ''change-list glsl-shaders toggle "${AMD_FSR}"'';
  ##开启/关闭 单项：RAVUzr3（速度一般，放大到目标分辨率，轻微锐化）
  "Ctrl+3" = ''change-list glsl-shaders toggle "${mpv-prescalers}/gather/ravu_zoom_r2.hook"'';
  ##开启/关闭 单项：Anime4K_Restore_CNN_M（速度快，无缩放，重建线条）
  "Ctrl+4" = ''change-list glsl-shaders toggle "${anime4k}/glsl/Restore/Anime4K_Restore_CNN_M.glsl"'';
  ##开启/关闭 单项：Anime4K_Upscale_GAN_x2_M（速度快，两倍放大，感知略强）
  "Ctrl+5" = ''change-list glsl-shaders toggle "${anime4k}/glsl/Upscale/Anime4K_Upscale_GAN_x2_M.glsl"'';
  ##开启/关闭 单项：FSRCNNX8041（速度较慢，两倍放大，比较忠于原始画面）
  "Ctrl+6" = ''change-list glsl-shaders toggle "${FSRCNNX_x2_8_0_4_1}"'';
  ##开启/关闭 单项：自适应锐化（速度一般，无缩放）
  "Ctrl+7" = ''change-list glsl-shaders toggle "${adaptive-sharpen}"'';
  ##开启/关闭 单项：nnedi3_nns64_win8x4（速度很慢，两倍放大，忠于原始画面）
  "Ctrl+8" = ''change-list glsl-shaders toggle "${mpv-prescalers}/nnedi3_nns64_win8x4.hook"'';
  ##清理并依次挂载 组合：Anime4k的"DTDD"（速度较快，无缩放，加深线条+细化线条+中位降噪+高斯解糊，主观感知强）
  "Ctrl+9" = ''change-list glsl-shaders set "${anime4k}/glsl/Experimental-Effects/Anime4K_Darken_HQ.glsl;${anime4k}/glsl/Experimental-Effects/Anime4K_Thin_HQ.glsl;${anime4k}/glsl/Denoise/Anime4K_Denoise_Bilateral_Mode.glsl;${anime4k}/glsl/Deblur/Anime4K_Deblur_DoG.glsl"'';
  ##清理并依次挂载 组合：双SSIM（速度一般，辅助内建算法进行放大缩小）
  "Ctrl+0" = ''change-list glsl-shaders set "${SSimSuperRes};${SSimDownscaler}"'';
  ##清空所有已挂载的着色器
  "Ctrl+`" = ''change-list glsl-shaders clr ""''; # 清空列表 —— 视频着色器

  ##⇘⇘uosc 一级菜单：其它
  "CTRL+P" = ''script-message cycle-commands "apply-profile FSRCNNX;show-text 配置组：FSRCNNX" "apply-profile AMD-FSR_EASU;show-text 配置组：AMD-FSR_EASU" "apply-profile NNEDI3;show-text 配置组：NNEDI3" "apply-profile ravu-zoom;show-text 配置组：ravu-zoom" "apply-profile Anime4K;show-text 配置组：Anime4K"''; #menu: 其它 > 常规配置组 > 切换 指定配置组
  "ALT+1" = ''apply-profile FSRCNNX;show-text "配置组：FSRCNNX"''; #menu: 其它 > 常规配置组 > 切换 FSRCNNX 配置
  "ALT+2" = ''apply-profile FSRCNNX+;show-text "配置组：FSRCNNX+"''; #menu: 其它 > 常规配置组 > 切换 FSRCNNX+ 配置
  "ALT+3" = ''apply-profile FSRCNNX-anime;show-text "配置组：FSRCNNX-anime"''; #menu: 其它 > 常规配置组 > 切换 FSRCNNX-anime 配置
  "ALT+4" = ''apply-profile FSRCNNX-anime+;show-text "配置组：FSRCNNX-anime+"''; #menu: 其它 > 常规配置组 > 切换 FSRCNNX-anime+ 配置
  "ALT+5" = ''apply-profile ravu-zoom;show-text "配置组：ravu-zoom"''; #menu: 其它 > 常规配置组 > 切换 Ravu-zoom 配置
  #                apply-profile ravu-3x;show-text "配置组：ravu-3x"                                                      #menu: 其它 > 常规配置组 > 切换 Ravu-3x 配置
  "ALT+6" = ''apply-profile Anime4K;show-text "配置组：Anime4K"''; #menu: 其它 > 常规配置组 > 切换 Anime4k 配置
  #                apply-profile Anime4K+;show-text "配置组：Anime4K+"                                                    #menu: 其它 > 常规配置组 > 切换 Anime4k+ 配置
  "ALT+7" = ''apply-profile NNEDI3;show-text "配置组：NNEDI3"''; #menu: 其它 > 常规配置组 > 切换 NNEDI3 配置
  "ALT+8" = ''apply-profile NNEDI3+;show-text "配置组：NNEDI3+"''; #menu: 其它 > 常规配置组 > 切换 NNEDI3+ 配置
  "ALT+9" = ''apply-profile AMD-FSR_EASU;show-text "配置组：AMD-FSR_EASU"''; #menu: 其它 > 常规配置组 > 切换 AMD-FSR_EASU 配置
  #                apply-profile SSIM;show-text "配置组：SSIM"                                                            #menu: 其它 > 常规配置组 > 切换 SSIM 配置
  #                cycle border;show-text "显示边框:${border}"                                                            #menu: 其它 > 切换 边框模式  #@state=(border and 'checked')
  "CTRL+B" = ''cycle title-bar;show-text "显示标题栏:''${title-bar}"''; #menu: 其它 > 切换 标题栏    #@state=(title_bar and 'checked')
  #                cycle-values title ${media-title} ${filename}                                                          #menu: 其它 > 切换 媒体标题
  "CTRL+R" = ''cycle-values   reset-on-next-file "all" "no" "vf,af,loop-file,deinterlace,border,contrast,brightness,gamma,saturation,hue,video-zoom,video-rotate,video-pan-x,video-pan-y,panscan,speed,audio,sub,audio-delay,sub-pos,sub-scale,sub-delay,sub-speed,sub-visibility";show-text "播放下一个文件时重置以下选项:''${reset-on-next-file}"''; #menu: 其它 > 重置播放中更改项

  ##⇘⇘uosc 一级菜单：工具
  "Ctrl+p" = ''script-message-to command_palette show-command-palette "Command Palette"''; #menu: 工具 > 打开命令面板
  #                script-message-to uosc keybinds                                                                        #menu: 工具 > 查看键绑定面板
  #                script-message set-clipboard ${filename}                                                               #menu: 工具 > 复制文件信息 > 复制当前文件名
  #                script-message set-clipboard ${path}                                                                   #menu: 工具 > 复制文件信息 > 复制当前文件路径
  "CTRL+ALT+t" = ''script-message set-clipboard ''${time-pos}''; #menu: 工具 > 复制文件信息 > 复制当前时间
  "CTRL+ALT+s" = ''script-message set-clipboard ''${sub-text}''; #menu: 工具 > 复制文件信息 > 复制当前字幕内容
  #                script-message-to uosc open-config-directory                                                           #menu: 工具 > 定位配置文件
  M = ''script-message manager-update-all ;show-text "更新脚本着色器"''; #menu: 工具 > 一键更新脚本和着色器
  #                ignore                                                                                                 #menu: ---

  ##⇘⇘uosc 一级菜单
  q = "quit"; #menu: 退出程序
  Q = "quit-watch-later"; # 退出并保存当前状态
}
