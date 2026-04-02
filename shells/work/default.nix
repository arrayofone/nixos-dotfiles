# Devshell for the work repo.
# Provides Node 20, custom protobuf toolchain, and local dev infrastructure tools.
{ pkgs, ... }:
pkgs.mkShell {
  packages = with pkgs; [
    # Core (ported from .nix/ci/flake.nix)
    nodejs_20
    corepack_20
    jq
    zip
    gh

    # Custom protobuf (via work-protobuf overlay)
    work-protobuf
    protoc-gen-grpc-node
    protoc-gen-improbable-eng-grpc-web

    # Build (bazelisk wrapped as `bazel`)
    (writeShellScriptBin "bazel" ''exec ${bazelisk}/bin/bazelisk "$@"'')

    # Code quality
    biome

    # Infrastructure
    terraform
    google-cloud-sdk
    mkcert

    # Services
    firebase-tools
    docker-compose

    # Testing
    playwright-driver
  ];

  shellHook = ''
    export MINGA_PROTOC="${pkgs.work-protobuf}/bin/protoc"
    export MINGA_PROTOC_GEN_GRPC_NODE="${pkgs.protoc-gen-grpc-node}/bin/protoc-gen-grpc-node"
    export MINGA_PROTOC_GEN_GRPC_WEB="${pkgs.protoc-gen-improbable-eng-grpc-web}/bin/protoc-gen-improbable-eng-grpc-web"
    export PLAYWRIGHT_BROWSERS_PATH="${pkgs.playwright-driver.browsers}"
  '';
}
