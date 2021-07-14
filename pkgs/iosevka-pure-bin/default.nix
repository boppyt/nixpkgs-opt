{ lib, fetchFromGitHub }:

let
  version = "7.2.0-1";
in
fetchFromGitHub rec {
  name = "iosevka-pure-bin-${version}";

  owner = "boppyt";
  repo = "iosevka-pure";
  rev = "9cdc0b881b701354d8a90a05f120eb411ee20771";
  sha256 = "sha256-lbE/igEjAyPKNeUkcSknMmar0lVi0fYesnmUvNY9QcQ=";

  postFetch = ''
    tar xzf $downloadedFile --strip=1
    mkdir -p $out/share/fonts/truetype
    install truetype/ttf/*.ttf $out/share/fonts/truetype
  '';

  meta = with lib; {
    description = "Iosevka custom build by boppyt which aims to provide pure soothing font";
    homepage = "https://github.com/boppyt/iosevka-pure";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ boppyt ];
  };
}
