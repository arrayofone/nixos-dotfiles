# Overlay: Custom protobuf toolchain for the work repo.
# Ported from the work repo's .nix/ci/flake.nix — same source revs and hashes.
{ ... }:
final: _prev: {
  # ChangeGamers protobuf fork — builds protoc + libprotoc (3.15.0)
  work-protobuf = final.stdenv.mkDerivation {
    pname = "work-protobuf";
    version = "3.15.0-work";

    src = final.fetchFromGitHub {
      owner = "ChangeGamers";
      repo = "protobuf";
      rev = "722277f127f03a0649c7f9231e693ca3c9a54254";
      hash = "sha256-76SaWBsqJvxawaVDkgkWsNZdq+nbHibQS4rX51capzY=";
    };

    nativeBuildInputs = [ final.cmake ];
    buildInputs = [ final.zlib ];

    # The repo has a Bazel BUILD file that collides with cmake's "build"
    # dir on case-insensitive filesystems (macOS).
    postUnpack = ''
      rm -f $sourceRoot/BUILD $sourceRoot/six.BUILD
    '';

    cmakeDir = "../cmake";

    cmakeFlags = [
      "-Dprotobuf_BUILD_TESTS=OFF"
      "-Dprotobuf_BUILD_CONFORMANCE=OFF"
      "-Dprotobuf_BUILD_EXAMPLES=OFF"
      "-Dprotobuf_BUILD_PROTOC_BINARIES=ON"
      "-Dprotobuf_WITH_ZLIB=ON"
      "-DCMAKE_INSTALL_LIBDIR=lib"
      # The fork's CMakeLists.txt requires cmake_minimum_required < 3.5,
      # which CMake 4.x dropped. This flag restores compatibility.
      "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    ];
  };

  # zaucy/protoc-gen-grpc-node — C++ protoc plugin
  protoc-gen-grpc-node = final.stdenv.mkDerivation {
    pname = "protoc-gen-grpc-node";
    version = "0.0.1";

    src = final.fetchFromGitHub {
      owner = "zaucy";
      repo = "protoc-gen-grpc-node";
      rev = "d5332f7c46f6b951db3f451530baad0539620fe2";
      hash = "sha256-E+XwYwNzZmufBY7HebKdo/OYIlpvkXuCkJatjKBijHs=";
    };

    buildInputs = [
      final.work-protobuf
      final.zlib
    ];

    dontConfigure = true;

    buildPhase = ''
      c++ -std=c++11 \
        -I${final.work-protobuf}/include \
        src/main.cc \
        src/grpc-node-generator.cc \
        src/grpc-node-generator-options.cc \
        src/grpc-node-generator-utils.cc \
        -L${final.work-protobuf}/lib \
        -lprotoc -lprotobuf \
        -L${final.zlib}/lib -lz \
        -lpthread \
        -o protoc-gen-grpc-node
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp protoc-gen-grpc-node $out/bin/
    '';
  };

  # ChangeGamers/protoc-gen-improbable-eng-grpc-web — C++ protoc plugin
  protoc-gen-improbable-eng-grpc-web = final.stdenv.mkDerivation {
    pname = "protoc-gen-improbable-eng-grpc-web";
    version = "0.0.1";

    src = final.fetchFromGitHub {
      owner = "ChangeGamers";
      repo = "protoc-gen-improbable-eng-grpc-web";
      rev = "1e55435c2316955aeb0d92f907e04b7dac269add";
      hash = "sha256-23XW27dAo9EeARMPrdCn87mQlUGZnnaAIQXceFAIqr0=";
    };

    buildInputs = [
      final.work-protobuf
      final.zlib
    ];

    dontConfigure = true;

    buildPhase = ''
      c++ -std=c++11 \
        -I${final.work-protobuf}/include \
        protoc-gen-improbable-eng-grpc-web/main.cc \
        protoc-gen-improbable-eng-grpc-web/generator.cc \
        protoc-gen-improbable-eng-grpc-web/generator-options.cc \
        -L${final.work-protobuf}/lib \
        -lprotoc -lprotobuf \
        -L${final.zlib}/lib -lz \
        -lpthread \
        -o out-bin
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp out-bin $out/bin/protoc-gen-improbable-eng-grpc-web
    '';
  };
}
