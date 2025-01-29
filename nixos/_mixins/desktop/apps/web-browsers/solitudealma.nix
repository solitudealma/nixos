{...}: {
  programs = {
    chromium = {
      extensions = [
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
        "mdjildafknihdffpkfmmpnpoiajfjnjd" # Consent-O-Matic
        "gebbhagfogifgggkldgodflihgfeippi" # Return YouTube Dislike
        "fdpohaocaechififmbbbbbknoalclacl" # GoFullPage
        "clpapnmmlmecieknddelobgikompchkk" # Disable Automatic Gain Control
        "clngdbkpkpeebahjckkjfobafhncgmne" # Stylus
      ];
      extraOpts = {
        PromptForDownloadLocation = true;
      };
    };
    firefox = {
      policies = {
        #   "3rdparty".Extensions = {
        #     "uBlock0@raymondhill.net" = {
        #       advancedSettings = [
        #         [
        #           "userResourcesLocation"
        #           "https://raw.githubusercontent.com/pixeltris/TwitchAdSolutions/master/video-swap-new/video-swap-new-ublock-origin.js"
        #         ]
        #       ];
        #       adminSettings = {
        #         userFilters = lib.concatMapStrings (x: x + "\n") [
        #           "twitch.tv##+js(twitch-videoad)"
        #           "||1337x.vpnonly.site"
        #         ];
        #         userSettings = rec {
        #           uiTheme = "dark";
        #           uiAccentCustom = true;
        #           uiAccentCustom0 = "#CA9EE6";
        #           cloudStorageEnabled = lib.mkForce false; # Security liability?
        #           advancedUserEnabled = true;
        #           userFiltersTrusted = true;
        #           importedLists = [
        #             "https://easylist-downloads.adblockplus.org/antiadblockfilters.txt"
        #             "https://gitflic.ru/project/magnolia1234/bypass-paywalls-clean-filters/blob/raw?file=bpc-paywall-filter.txt"
        #             "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/BrowseWebsitesWithoutLoggingIn.txt"
        #             "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/ClearURLs for uBo/clear_urls_uboified.txt"
        #             "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/Dandelion Sprout's Anti-Malware List.txt"
        #             "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/LegitimateURLShortener.txt"
        #             "https://raw.githubusercontent.com/OsborneLabs/Columbia/master/Columbia.txt"
        #             "https://raw.githubusercontent.com/bogachenko/fuckfuckadblock/master/fuckfuckadblock.txt?_=rawlist"
        #             "https://raw.githubusercontent.com/iam-py-test/my_filters_001/main/antimalware.txt"
        #             "https://raw.githubusercontent.com/liamengland1/miscfilters/master/antipaywall.txt"
        #             "https://raw.githubusercontent.com/yokoffing/filterlists/main/annoyance_list.txt"
        #             "https://raw.githubusercontent.com/yokoffing/filterlists/main/privacy_essentials.txt"
        #           ];
        #           externalLists = lib.concatStringsSep "\n" importedLists;
        #           popupPanelSections = 31;
        #         };
        #         selectedFilterLists = [
        #           "ublock-filters"
        #           "ublock-badware"
        #           "ublock-privacy"
        #           "ublock-quick-fixes"
        #           "ublock-unbreak"
        #           "easylist"
        #           "adguard-generic"
        #           "adguard-mobile"
        #           "easyprivacy"
        #           "adguard-spyware"
        #           "adguard-spyware-url"
        #           "block-lan"
        #           "urlhaus-1"
        #           "curben-phishing"
        #           "plowe-0"
        #           "dpollock-0"
        #           "fanboy-cookiemonster"
        #           "ublock-cookies-easylist"
        #           "adguard-cookies"
        #           "ublock-cookies-adguard"
        #           "fanboy-social"
        #           "adguard-social"
        #           "fanboy-thirdparty_social"
        #           "easylist-chat"
        #           "easylist-newsletters"
        #           "easylist-notifications"
        #           "easylist-annoyances"
        #           "adguard-mobile-app-banners"
        #           "adguard-other-annoyances"
        #           "adguard-popup-overlays"
        #           "adguard-widgets"
        #           "ublock-annoyances"
        #           "DEU-0"
        #           "FRA-0"
        #           "NLD-0"
        #           "RUS-0"
        #           "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/LegitimateURLShortener.txt"
        #           "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/BrowseWebsitesWithoutLoggingIn.txt"
        #           "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/Dandelion Sprout's Anti-Malware List.txt"
        #           "https://raw.githubusercontent.com/yokoffing/filterlists/main/privacy_essentials.txt"
        #           "https://raw.githubusercontent.com/yokoffing/filterlists/main/annoyance_list.txt"
        #           "https://easylist-downloads.adblockplus.org/antiadblockfilters.txt"
        #           "https://raw.githubusercontent.com/liamengland1/miscfilters/master/antipaywall.txt"
        #           "https://gitflic.ru/project/magnolia1234/bypass-paywalls-clean-filters/blob/raw?file=bpc-paywall-filter.txt"
        #           "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/ClearURLs for uBo/clear_urls_uboified.txt"
        #           "https://raw.githubusercontent.com/iam-py-test/my_filters_001/main/antimalware.txt"
        #           "https://raw.githubusercontent.com/OsborneLabs/Columbia/master/Columbia.txt"
        #           "https://raw.githubusercontent.com/bogachenko/fuckfuckadblock/master/fuckfuckadblock.txt?_=rawlist"
        #           "user-filters"
        #         ];
        #         trustedSiteDirectives = [
        #           "app.element.io"
        #           "baidu.com"
        #         ];
        #       };
        #     };
        #   };
        # Check about:support for extension/add-on ID strings.
        ExtensionSettings =
          (with builtins; let
            extension = shortId: uuid: {
              name = uuid;
              value = {
                install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
                installation_mode = "normal_installed";
              };
            };
          in
            listToAttrs [
              (extension "adaptive-tab-bar-colour" "ATBC@EasonWong")
              (extension "bewlybewly" "addon@bewlybewly.com")
              (extension "consent-o-matic" "gdpr@cavi.au.dk")
              (extension "downthemall" "{DDC359D1-844A-42a7-9AA1-88A850A938A8}")
              (extension "hcfy" "{0982b844-4f35-48b7-9811-6832d916f21c}")
              (extension "immersive-translate" "{5efceaa7-f3a2-4e59-a54b-85319448e305}")
              (extension "material-icons-for-gitHub" "{eac6e624-97fa-4f28-9d24-c06c9b8aa713}")
              (extension "ruffle_rs" "{b5501fd1-7084-45c5-9aa6-567c2fcf5dc6}")
              (extension "sidebery" "{3c078156-979c-498b-8990-85f7987dd929}")
              (extension "styl-us" "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}")
              (extension "ublock-origin" "uBlock0@raymondhill.net")
              (extension "userchrome-toggle-extended@n2ezr.ru" "userchrome-toggle-extended")
              (extension "{plasma-browser-integration@kde.org}" "{plasma-browser-integration@kde.org}")
              (extension "{646d57f4-d65c-4f0d-8e80-5800b92cfdaa}" "{646d57f4-d65c-4f0d-8e80-5800b92cfdaa}")
              (extension "{7da5011d-0496-4632-8408-e0da16b8c59f}" "{7da5011d-0496-4632-8408-e0da16b8c59f}")
            ])
          // {
            "firefoxbeta@tampermonkey.net" = {
              install_url = "https://www.tampermonkey.net/xpi/firefox-current-beta.xpi";
              installation_mode = "force_installed";
            };
          };
        #   "Homepage" = {
        #     # "URL" = "https://kagi.com";
        #   };
        "PromptForDownloadLocation" = true;
        #   "SearchEngines" = {
        #     "Default" = "Google";
        #     "DefaultPrivate" = "Google";
        #   };
      };
    };
  };
}
