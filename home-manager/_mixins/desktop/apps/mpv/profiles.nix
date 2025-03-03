{...}: {
  ##⇘⇘基本说明：
  ##这是附属设置文件，是配置预设（即 https://mpv.io/manual/master/#profiles ）的集合，通用区已有的参数会被激活的配置预设覆盖
  ##需要主设置文件 "mpv.conf" 中的 --include 参数指定本文件后才生效 https://github.com/hooke007/MPV_lazy/discussions/126
  ##[xxx] 用于定义一组配置预设的头部标签，注释某组参数不能只注释头部
  ##详细了解配置预设与通用参数的混合用法请读 https://hooke007.github.io/unofficial/mpv_profiles.html
  ##关于被删去的“内置配置预设组”与“传统配置预设组”部分，查看 https://github.com/hooke007/MPV_lazy/discussions/42

  ##################
  # 常规配置预设组 #
  ##################
  ##⇘⇘常规配置预设没有自动触发条件（内置配置预设组也全为常规配置预设）
  ##可以在主设置文件中使用 --profile=<profile1,profile2,...> 或多行 --profile=<xxx> 参数激活数个配置预设

  pure = {
    profile-desc = "返璞归真";
    brightness = 0;
    contrast = 0;
    saturation = 0;
    gamma = 0;
    hue = 0;
    dither-depth = "no";
    gpu-dumb-mode = "yes"; # 启用该参数以屏蔽大量 --vo=gpu 的功能（包括下列三项）
    #glsl-shaders  = "";
    #deband        = "no";
    #sharpen       = 0;
    vf = "";
    speed = 1;
  };

  ##⇘⇘可用于回退脚本命令 `script-binding input_plus/pip_dummy` （伪窗口化）
  ##由于个别选项的局限性，建议用 input.conf 的组合命令方案代替 ——
  ## set fullscreen no ; set border yes ; set current-window-scale 1 ; set auto-window-resize yes ; set keepaspect-window yes ; set ontop no

  window_reset = {
    profile-desc = "重置窗口状态";
    fullscreen = "no";
    border = "yes";
    title-bar = "yes";
    window-scale = 1;
    auto-window-resize = "yes";
    keepaspect-window = "yes";
    ontop = "no";
  };

  "DeBand+" = {
    profile-desc = "自定义去色带";
    deband = "yes";
    deband-iterations = 3; # <0-16> 去色带执行次数，越高强度但也越费时费力，数值>4实际无效（默认1）
    deband-threshold = 42; # <0-4096> 滤波器的截止阈值，更高的数字会增加强度，但会逐渐减少图像细节（默认48）
    deband-range = 12; # <1-64> 初始半径，越大的值去色带越强且性能占用越高；值越小越平滑（默认值16）。如果增大 --deband-iterations，需减小此值来进行补偿
    deband-grain = 24; # <0-4096> [如果使用以下两个静态降噪着色器，将此设置为0] 添加额外动态噪点，有助于掩盖剩余的量化伪影（默认32）
    #glsl-shaders-append = "~~/shaders/noise_static_chroma.glsl";
    #glsl-shaders-append = "~~/shaders/noise_static_luma.glsl";
  };

  ##⇘⇘备选的软件缩放方案
  ##在mpv内部需要执行格式转换时会用到软件缩放器

  SWscaler = {
    profile-desc = "软件缩放器";
    #sws-allow-zimg             = "no";              # 优先使用zimg（通常具有更高质量）而不是libswscale，默认 yes
    sws-scaler = "bicublin"; # [libswscale] <fast-bilinear|bilinear|bicubic默认|x|point|area|bicublin|gauss|sinc|lanczos|spline>
    # [libswscale] 缩放算法（同时作用于色度平面）
    #sws-fast                   = "yes";             # [libswscale] 以质量为代价优化性能，默认 no
    #zimg-scaler-chroma         = "bicubic";         # [zimg] <point|bilinear默认|bicubic|spline16|spline36|lanczos>
    # [zimg] 色度还原算法
    #zimg-scaler-chroma-param-a = "1/3";             # [zimg] 色度还原算法的子参数，不支持调节的算法不受影响，默认 default
    #zimg-scaler-chroma-param-b = "1/3";
    zimg-scaler = "bicubic"; # [zimg] 缩放算法，可用值参考 --zimg-scaler-chroma（默认 lanczos）
    zimg-scaler-param-a = "1/3"; # [zimg] 缩放算法的子参数
    zimg-scaler-param-b = "1/3";
    #zimg-dither                = "error-diffusion"; # [zimg] <no|ordered|random默认|error-diffusion> 色深抖动算法
    zimg-fast = "no"; # [zimg] 以质量为代价优化性能，默认 yes
  };

  ##################
  # 条件配置预设组 #
  ##################
  ##⇘⇘条件触发配置预设，根据给定条件激发特定参数。简易格式见示例
  ##仅注释掉 --profile-cond 和 --profile-restore 即可将条件配置预设变为常规配置预设，常规配置预设的使用方法为通用区 --profile=<value>

  ##⇘⇘条件配置预设的格式示例
  ##[ABCDEFG]                    # 配置预设的名称，自定义（必要）
  ##profile-desc    = 这是描述   # 配置预设的描述，随意写（可选）
  ##profile-cond    = <property> # 触发该配置预设的条件。可用的属性列表 https://mpv.io/manual/master/#property-list （必要）
  ##profile-restore = copy       # 此参数一般用于回归触发前的通用参数（关闭此项将保留）（可选）
  ##...                          # 然后写该条件下触发的参数

  ##⇘⇘备选的HDR转SDR方案，若你的显卡不支持 --hdr-compute-peak 应启用这个方案且禁用 [H2S-DTM]
  ##其它可选的改良方案 https://github.com/hooke007/MPV_lazy/discussions/25

  H2S-STM = {
    profile-desc = "HDR转SDR（静态色调映射）";
    #profile-cond           = ''p["video-params/sig-peak"]>1'';
    profile-restore = "copy";
    #blend-subtitles        = "video";      # 问题状态（静态映射不受影响） https://github.com/mpv-player/mpv/issues/6368
    target-peak = 100; # <10-10000> 值越低，画面整体越亮。默认auto即203（不要用作通用参数，因为会影响sdr片源的正常输出亮度）
    hdr-compute-peak = "no"; # 当yes时提供了基于场景的动态色调映射默认auto（完整支持该特性需要显卡opengl版本≥4.3）
    tone-mapping = "hable"; # <auto默认|clip|mobius|reinhard|hable|bt.2390|gamma|linear> 色调映射算法
    #tone-mapping-param     = "default";    # 上项的小参。default根据算法的使用不同初始值，对部分算法无效
    # clip=1.0; mobius=0.3; reinhard=0.5; gamma=1.8; linear=1.0
    tone-mapping-max-boost = 1.0; # <1.0-10.0> 过曝指数，默认1.0
    gamut-mapping-mode = "desaturate"; # <auto默认|clip||desaturate|warn> 完成色调映射后的色域裁剪方式
  };

  H2S-DTM = {
    profile-desc = "HDR转SDR（动态色调映射-基础版）";
    profile-cond = ''p["video-params/sig-peak"]>1'';
    profile-restore = "copy";
    blend-subtitles = "no";
    #target-peak              = "auto";
    hdr-compute-peak = "yes";
    hdr-peak-decay-rate = 150; # [须 --hdr-compute-peak=yes ] <0.0-1000.0> 亮度峰值检测算法的衰减率，默认 20.0
    hdr-scene-threshold-low = 4; # [须 --hdr-compute-peak=yes ] <0.0-100.0> 场景变化亮度的下限阈值，默认 1.0
    hdr-scene-threshold-high = 16; # [须 --hdr-compute-peak=yes ] <0.0-100.0> 场景变化亮度的上限阈值，默认 3.0
    tone-mapping = "bt.2390";
    #tone-mapping-param       = "default
    tone-mapping-max-boost = 1.5;
    gamut-mapping-mode = "clip";
  };

  ##⇘⇘备用，可基本取代脚本 ontop_playback.lua 的职能

  ontop_playback = {
    profile-desc = "暂停时取消置顶";
    #profile-cond    = "pause";
    profile-restore = "copy";
    ontop = "no";
  };

  ##⇘⇘文件名匹配的示例写法：根据文件名中的特定字符触发配置预设
  ##字符 "-" 需要使用LUA的转义符 "%"

  VCB-Studio = {
    profile-desc = "真空断路器";
    profile-cond = ''filename:match("VCB%-Studio")'';
    profile-restore = "copy";
    term-playing-msg = ''"LittlePox : SAYA is a lolicon !!!"'';
  };

  ##⇘⇘这套参数针对的是压制脚本而不是 --vf=vapoursynth 滤镜播放脚本的预览
  ##尽可能排除参数干扰以接近实际效果（仅限SDR），更理想的环境是使用单独的清洁的设置文件

  EXT_vpy = {
    profile-desc = "预览VapourSynth脚本";
    profile-cond = ''filename:match("%.vpy$")'';
    profile-restore = "copy";
    demuxer-lavf-format = "vapoursynth";
    profile = "pure"; # 引入它的目的是防止花里胡哨的干扰
    icc-profile = "";
    icc-profile-auto = "no";
    video-unscaled = "yes";
    video-sync = "desync";
    framedrop = "no";
    aid = "no";
    audio-file-auto = "no";
    sid = "no";
    sub-auto = "no";
  };
}
