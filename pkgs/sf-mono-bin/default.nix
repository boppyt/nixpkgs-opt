{ lib, fetchFromGitHub }:

let
  version = "2018-06-07";
in
fetchFromGitHub rec {
  name = "sf-mono-bin-${version}";

  owner = "supercomputra";
  repo = "SF-Mono-Font";
  rev = "1409ae79074d204c284507fef9e479248d5367c1";
  sha256 = "sha256-j/3/NZ4AyBN+xeY508ieK9LExk75HQANN+PpBjGcKs8=";

  postFetch = ''
    mkdir -p $out/share/fonts/opentype
    tar xf $downloadedFile -C $out/share/fonts/opentype
  '';

  meta = with lib; {
    description = "SF Mono";
    homepage = "https://github.com/supercomputra/SF-Mono-Font";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ boppyt ];
  };
}
