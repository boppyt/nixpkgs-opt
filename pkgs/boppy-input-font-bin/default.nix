{ lib, fetchFromGitHub }:

let
  version = "2021-10-02";
in
fetchFromGitHub rec {
  name = "boppy-input-font-bin-${version}";

  owner = "boppyt";
  repo = "boppy-input-font";
  rev = "fc652b6369ba06016b5b033ceb26a9f824afbea8";
  sha256 = "sha256-H7UzAABuh49YNVpqDDv9fH9WAP+nR5D1/qcGAzJEYIk=";

  postFetch = ''
    tar xzf $downloadedFile --strip=1
    mkdir -p $out/share/fonts/truetype
    install Input_Fonts/Input/*.ttf $out/share/fonts/truetype
  '';

  meta = with lib; {
    description = "Boppyt's custom Input Mono Font.";
    homepage = "https://github.com/boppyt/boppy-input-font";
    license = {
      fullName = "INPUT FONT SOFTWARE LICENSE AGREEMENT";
      url = "https://input.djr.com/license/";
    };
    platforms = platforms.all;
    maintainers = with maintainers; [ boppyt ];
  };
}
