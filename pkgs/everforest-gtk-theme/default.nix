{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk-engine-murrine,
  jdupes,
  sassc,
  accent ? ["default"],
  shade ? "dark",
  size ? "standard",
  tweaks ? [],
}: let
  validAccents = ["default" "purple" "pink" "red" "orange" "yellow" "green" "teal" "grey" "all"];
  validShades = ["light" "dark"];
  validSizes = ["standard" "compact"];
  validTweaks = ["frappe" "macchiato" "black" "float" "outline" "macos"];

  single = x: lib.optional (x != null) x;
  pname = "Everforest";
in
  lib.checkListOfEnum "${pname} Valid theme accent(s)" validAccents accent
  lib.checkListOfEnum "${pname} Valid shades"
  validShades (single shade)
  lib.checkListOfEnum "${pname} Valid sizes"
  validSizes (single size)
  lib.checkListOfEnum "${pname} Valid tweaks"
  validTweaks
  tweaks
  stdenv.mkDerivation {
    pname = "magnetic-${lib.toLower pname}";
    version = "0-unstable-2024-11-07";

    src = fetchFromGitHub {
      owner = "Fausto-Korpsvart";
      repo = "Everforest-GTK-Theme";
      rev = "43cbe4f1aeba8b46e41836de4c8ea7ac398db119";
      hash = "sha256-Z46i0Ihpzo4LhFvzKsvnzcHFzeYxJMvQmg2k6lmjGH0=";
    };

    nativeBuildInputs = [jdupes sassc];

    propagatedUserEnvPkgs = [gtk-engine-murrine];

    postPatch = ''
      find -name "*.sh" -print0 | while IFS= read -r -d ''' file; do
        patchShebangs "$file"
      done
    '';

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/themes

      ./themes/build.sh
      ./themes/install.sh \
        --name ${pname} \
        ${toString (map (x: "--theme " + x) accent)} \
        ${lib.optionalString (shade != null) ("--color " + shade)} \
        ${lib.optionalString (size != null) ("--size " + size)} \
        ${toString (map (x: "--tweaks " + x) tweaks)} \
        --dest $out/share/themes

      jdupes --quiet --link-soft --recurse $out/share

      runHook postInstall
    '';

    meta = with lib; {
      description = "GTK Theme with Everforest colour scheme";
      homepage = "https://github.com/Fausto-Korpsvart/Everforest-GTK-Theme";
      license = licenses.gpl3Only;
      maintainers = with maintainers; [icy-thought];
      platforms = platforms.all;
    };
  }
