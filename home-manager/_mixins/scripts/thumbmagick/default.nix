{
  config,
  pkgs,
  ...
}: let
  inherit (config._custom.globals) fonts;
  name = builtins.baseNameOf (builtins.toString ./.);
  shellApplication = pkgs.writeShellApplication {
    inherit name;
    runtimeInputs = with pkgs; [
    ];
    text = '''';
    # text = ''
    #   #!/usr/bin/env bash
    #   # @author nate zhou
    #   # @since 2024
    #   # thumbmagick -- thumbnail creation automated using imagemagick

    #   # known issues:
    #   #       CJK characters and ASCII characters width

    #   Font=${fonts.mono}
    #   FontSize=100
    #   Image_bg=""
    #   Text_line1=""
    #   Text_line2=""
    #   Text_line3=""
    #   Colorscheme="#8533ff;#eeeeee;black;#9b1a8f"
    #   Icon_l=""
    #   Icon_r=""

    #   # print help menu
    #   usage() {
    #       echo "usage: thumbmagick -b BG_IMAGE -1 text_line1 [OPTIONS] ..."
    #       echo "thumbnail creation automated using imagemagick"
    #       echo "known issues: width of the rectangle under text is calculated with CJK fonts (doubled width), regular ASCII characters not supported yet"
    #       echo -e "\nREQUIRED OPTIONS:"
    #       echo "  -b  :  background image"
    #       echo "  -1  :  text of the first line"
    #       echo "  -2  :  text of the second line"
    #       echo "  -3  :  text of the thrid line"
    #       echo -e "\nOPTIONAL OPTIONS:"
    #       printf "%s" "  -c  :  colorscheme for text and block, 3 colors separated by ';'\n         default colorscheme is '$Colorscheme'"
    #       echo "  -l  :  icons on the left side"
    #       echo "  -r  :  icons on the right side"
    #       echo "  -h  :  display this help message and exit."
    #   }

    #   # parse options
    #   while getopts ":b:1:2:3:c:l:r:h" opt; do
    #       case ''${opt} in
    #           b)
    #               Image_bg=$OPTARG
    #               ;;
    #           1)
    #               Text_line1=$OPTARG
    #               ;;
    #           2)
    #               Text_line2=$OPTARG
    #               ;;
    #           3)
    #               Text_line3=$OPTARG
    #               ;;
    #           c)
    #               Colorscheme=$OPTARG
    #               ;;
    #           l)
    #               Icon_l=$OPTARG
    #               ;;
    #           r)
    #               Icon_r=$OPTARG
    #               ;;
    #           h)
    #               usage
    #               exit 0
    #               ;;
    #           \?)
    #               echo "Invalid options: -$OPTARG" 1>&2
    #               usage
    #               exit 1
    #               ;;
    #           :)
    #               echo "Option -$OPTARG requires an argument." 1>&2
    #               usage
    #               exit 1
    #               ;;
    #       esac
    #   done

    #   # check if required arguments are provided
    #   if [[ -z $Image_bg ]] || [[ -z $Text_line1 ]]; then
    #       echo -e "Required argument is missing.\n"
    #       usage
    #       exit 1
    #   fi

    #   # parse Colorscheme
    #   Color1=$(echo "$Colorscheme" | awk -F ';' '{print $1}')
    #   Color2=$(echo "$Colorscheme" | awk -F ';' '{print $2}')
    #   Color3=$(echo "$Colorscheme" | awk -F ';' '{print $3}')
    #   Color4=$(echo "$Colorscheme" | awk -F ';' '{print $4}')

    #   # count characters
    #   Words1=$(echo -n "$Text_line1" | wc -m)
    #   Words2=$(echo -n "$Text_line2" | wc -m)
    #   Words3=$(echo -n "$Text_line3" | wc -m)
    #   # count chinese characters using my personal script ~/.local/bin/wc-cjk
    #   # non-CJK word's width have to be divided by 2

    #   # calculate rectangles' width
    #   Width1=$(( Words1 * FontSize ))
    #   Width2=$(( Words2 * FontSize ))
    #   Width3=$(( Words3 * FontSize ))
    #   # calculate rectangle's  A/B point position on x-axis
    #   #  -----------------1200------------------
    #   #  |                                     |   Xb-Xa=$Width
    #   #  9      A(Xa,Ya)--$Width--------       |   (Xa+Xb)/2=600
    #   #  0      |         C(600,Yc)    |       |
    #   #  0      -----------------------B(Xb,Yb)|   Xb=($Width+1200)/2
    #   #  |                                     |   Xa=1200-Xb
    #   #  --------------------------------------

    #   Xb1=$(((Width1 + 1200) / 2 ))
    #   Xa1=$((1200 - Xb1))
    #   Xb2=$(((Width2 + 1200) / 2 ))
    #   Xa2=$((1200 - Xb2))
    #   Xb3=$(((Width3 + 1200) / 2 ))
    #   Xa3=$((1200 - Xb3))

    #   convert "$Image_bg" -gravity northwest -crop 1200x900+0+0 \
    #               -fill "$Color3" -draw "rectangle $Xa1,''$FontSize $Xb1,$((FontSize + 110))" \
    #               -fill "$Color1" -pointsize "''$FontSize" -font "''$Font" -annotate "+$Xa1+80" "$Text_line1" \
    #               -fill "$Color4" -draw "rectangle $Xa2,$((FontSize + 150)) $Xb2,$((FontSize +250))" \
    #               -fill "$Color2" -pointsize "''$FontSize" -font "''$Font" -annotate "+$Xa2+225" "$Text_line2" \
    #               -fill "$Color1" -draw "rectangle $Xa3,$((FontSize + 300)) $Xb3,$((FontSize +400))" \
    #               -fill "$Color3" -pointsize "''$FontSize" -font "''$Font" -annotate "+$Xa3+375" "$Text_line3" \
    #               output.png

    #   # add icons image if provided
    #   if [[ -n $Icon_l ]]; then
    #       convert output.png "$Icon_l" -geometry +100+220 -composite output.png
    #   fi

    #   if [[ -n $Icon_r ]]; then
    #       convert output.png "$Icon_r" -geometry +800+220 -composite output.png
    #   fi
    # '';
  };
in {
  home.packages = with pkgs; [shellApplication];
}
