{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "atlantis";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "runatlantis";
    repo = "atlantis";
    rev = "v${version}";
    hash = "sha256-a+xrmEHkSh5kicxIIxnoXgF9ep2ay5kCXwMR2sAVJIA=";
  };
  ldflags = [
    "-X=main.version=${version}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  vendorHash = "sha256-ZbCNHARgliw9TMkHyS9k+cnWgbdCCJ+8nMdJMu66Uvo=";

  subPackages = [ "." ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/atlantis version | grep ${version} > /dev/null
  '';

  meta = with lib; {
    homepage = "https://github.com/runatlantis/atlantis";
    description = "Terraform Pull Request Automation";
    license = licenses.asl20;
    maintainers = with maintainers; [ jpotier ];
  };
}
