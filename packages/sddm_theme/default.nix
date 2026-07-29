{ pkgs }:

let
  # Barad-dûr / Eye of Sauron themed wallpaper
  imgLink = "https://w.wallhaven.cc/full/dp/wallhaven-dp9y1m.jpg";

  image = pkgs.fetchurl {
    url = imgLink;
    sha256 = "sha256-xNumxunUokDBrkpiXVdXmU3UUXq/R7iPiH9Cu6Zaoqs=";
  };
in
pkgs.stdenv.mkDerivation {
  name = "sddm-theme";
  src = pkgs.fetchFromGitLab {
    owner = "Matt.Jolly";
    repo = "sddm-eucalyptus-drop";
    rev = "0b82ca465b7dac6d7ff15ebaf1b2f26daba5d126";
    sha256 = "sha256-SUOqcK7fGb5OnWmB4Wenqr9PPiagYUoEHjLd5CM6fyk=";
  };
  installPhase = ''
    mkdir -p $out
    cp -R ./* $out/
    cd $out/
    cp -r ${image} $out/Background.jpg
    echo "[General]

    Background=\"Background.jpg\"

    DimBackgroundImage=\"0.2\"
    ## Slight darkening for better text readability

    ScaleImageCropped=\"true\"

    ScreenWidth=\"2560\"
    ScreenHeight=\"1440\"

    ## [Blur Settings]

    FullBlur=\"false\"
    PartialBlur=\"true\"

    BlurRadius=\"80\"

    ## [Design Customizations - Glacier + LotR Theme]

    HaveFormBackground=\"true\"

    FormPosition=\"left\"

    BackgroundImageHAlignment=\"center\"
    BackgroundImageVAlignment=\"center\"

    MainColour=\"#E8F1FA\"
    ## Glacier text color

    AccentColour=\"#9FE8FF\"
    ## Glacier ice accent - matches hyprlock/waybar theme

    BackgroundColour=\"#101828\"
    ## Glacier base

    OverrideLoginButtonTextColour=\"#101828\"
    ## Dark text on ice button for contrast

    InterfaceShadowSize=\"6\"
    InterfaceShadowOpacity=\"0.7\"

    RoundCorners=\"14\"
    ## Matches hyprland rounding

    ScreenPadding=\"0\"

    Font=\"Ubuntu Sans\"

    FontSize=\"\"

    ## [Interface Behavior]

    ForceRightToLeft=\"false\"
    ForceLastUser=\"true\"
    ForcePasswordFocus=\"true\"
    ForceHideCompletePassword=\"false\"
    ForceHideVirtualKeyboardButton=\"true\"
    ForceHideSystemButtons=\"false\"
    AllowEmptyPassword=\"false\"
    AllowBadUsernames=\"false\"

    ## [Locale Settings]

    Locale=\"\"
    HourFormat=\"HH:mm\"
    DateFormat=\"dddd, MMMM d yyyy\"

    ## [Translations - Lord of the Rings Theme]

    HeaderText=\"Barad-dûr\"

    TranslatePlaceholderUsername=\"Servant of the Dark Lord\"
    TranslatePlaceholderPassword=\"Speak friend and enter...\"
    TranslateShowPassword=\"Reveal\"
    TranslateLogin=\"Enter Mordor\"
    TranslateLoginFailedWarning=\"The way is shut.\"
    TranslateCapslockWarning=\"The Eye sees your capslock\"
    TranslateSession=\"Realm\"
    TranslateSuspend=\"Rest\"
    TranslateHibernate=\"Slumber\"
    TranslateReboot=\"Return\"
    TranslateShutdown=\"Into Shadow\"
    TranslateVirtualKeyboardButton=\"\"

    " > $out/theme.conf
  '';
}
