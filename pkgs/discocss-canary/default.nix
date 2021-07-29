{ stdenvNoCC, lib, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "discocss-canary";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "mlvzk";
    repo = "discocss";
    rev = "v${version}";
    sha256 = "sha256-afmQCOOZ1MwQkbZZNHYfq2+IRv2eOtYBrGVHzDEbUHw=";
  };

  patches = [ ./canary.patch ];

  dontBuild = true;

  installPhase = ''
    install -Dm755 ./discocss $out/bin/discocss-canary
    '';

  meta = with lib; {
    description = "A tiny Discord css-injector (canary)";
    changelog = "https://github.com/mlvzk/discocss/releases/tag/v${version}";
    homepage = "https://github.com/mlvzk/discocss";
    license = licenses.mpl20;
    platforms = platforms.unix;
  };
}
