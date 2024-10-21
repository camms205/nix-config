{
  stdenv,
  fetchFromGitHub,
  pnpm,
  nodejs,
  python3,
  node-gyp,
  makeWrapper,
  lib,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "riven-frontend";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "rivenmedia";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-wwWF4sz+DnO+yi6zsGmoSAxXNDzUc3jZcGxhWUATlcw=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-pQBFB6KBBMvAKdt2jNj1YTF9yLSTGBWp0TKDlluIZ9Q=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
    python3 # required for sqlite3 bindings
    node-gyp # required for sqlite3 bindings
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild

    pushd node_modules/better-sqlite3
    node-gyp rebuild
    popd

    pnpm --offline build
    pnpm prune --prod
    find node_modules/.bin -xtype l -delete

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/riven-frontend
    mv {build,node_modules,package.json,version.txt} $out/share/riven-frontend/

    makeWrapper "${nodejs}/bin/node" "$out/bin/riven-frontend" \
      --add-flags $out/share/riven-frontend/build

    runHook postInstall
  '';

  meta = {
    description = "The frontend for riven";
    homepage = "https://github.com/rivenmedia/riven-frontend";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ camms205 ];
    platforms = lib.platforms.linux;
    mainProgram = "riven-frontend";
  };
})
