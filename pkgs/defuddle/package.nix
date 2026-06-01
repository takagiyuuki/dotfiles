{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "defuddle";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "kepano";
    repo = "defuddle";
    tag = finalAttrs.version;
    hash = lib.fakeHash; # 後で置き換える
  };

  npmDepsHash = lib.fakeHash; # 後で置き換える

  meta = {
    description = "Extract article content and metadata from web pages";
    homepage = "https://github.com/kepano/defuddle";
    license = lib.licenses.mit;
    mainProgram = "defuddle";
    maintainers = with lib.maintainers; [ ]; # 後で自分の handle を追加
  };
})
