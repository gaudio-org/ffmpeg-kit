#!/bin/bash

cd "${LIB_NAME}" || return 1

# 이전 빌드 정리
make distclean 2>/dev/null 1>/dev/null

# 최신 config.sub, config.guess로 교체
echo "🔄 최신 config.sub로 교체"
curl -L -o config.sub https://git.savannah.gnu.org/cgit/config.git/plain/config.sub
chmod +x config.sub

curl -L -o config.guess https://git.savannah.gnu.org/cgit/config.git/plain/config.guess
chmod +x config.guess

echo "📂 현재 디렉토리: $(pwd)"
echo "🔍 configure.in 존재 확인..."
# configure.in → configure.ac 변경
if [ -f "configure.in" ]; then
  echo "📝 configure.in → configure.ac 변경"
  mv configure.in configure.ac
fi

# m4 디렉토리 생성
echo "📁 m4 디렉토리 생성"
mkdir -p m4

# 매크로 복사
cp /opt/homebrew/Cellar/gettext/0.25/share/gettext/m4/*.m4 m4/

# 환경 변수 설정
echo "📦 환경 변수 설정 (ACLOCAL_PATH, PKG_CONFIG_PATH)"
export ACLOCAL_PATH="/opt/homebrew/share/aclocal:/opt/homebrew/opt/gettext/share/aclocal"
export PKG_CONFIG_PATH="/opt/homebrew/lib/pkgconfig:/opt/homebrew/opt/libiconv/lib/pkgconfig"

# configure.ac에 매크로 디렉토리 지정
if ! grep -q "AC_CONFIG_MACRO_DIRS" configure.ac; then
  echo "AC_CONFIG_MACRO_DIRS 추가"
  sed -i '' 's/AC_PREREQ(2.69)/AC_CONFIG_MACRO_DIRS([m4])\n&/' configure.ac
fi

# aclocal이 m4를 인식하도록 강제
aclocal -I m4

# autoreconf 실행
echo "🔁 autoreconf -fiv 실행"
autoreconf -fiv

# 존재하지 않는 심볼 제거
LAME_SYM="$SRC_DIR/lame/include/libmp3lame.sym"
if [ -f "$LAME_SYM" ]; then
  echo "🧽 존재하지 않는 심볼 lame_init_old 제거"
  sed -i.bak '/^lame_init_old$/d' "$LAME_SYM"
else
  echo "⚠️  libmp3lame.sym이 존재하지 않음: $LAME_SYM"
fi

# config.cache 파일 생성
echo "📄 config.cache 파일 생성"
cat <<EOF > config.cache
ac_cv_func_strtol=yes
ac_cv_func_malloc_0_nonnull=yes
ac_cv_func_gettimeofday=yes
ac_cv_c_bigendian=no
EOF

# cross compile 관련 환경 변수 명시
export ac_cv_prog_cc_cross=yes
export lt_cv_sys_lib_dlsearch_path_spec="/usr/lib"
export lt_cv_sys_max_cmd_len=262144

BUILD_SYSTEM=$("${BASEDIR}"/apple/config.guess)

# configure 실행
echo "⚙️ configure 실행 (cross compile 대응)"
./configure \
  --prefix="${LIB_INSTALL_PREFIX}" \
  --with-pic \
  --with-sysroot="${SDK_PATH}" \
  --with-libiconv-prefix="${SDK_PATH}/usr" \
  --enable-static \
  --disable-shared \
  --disable-fast-install \
  --disable-maintainer-mode \
  --disable-frontend \
  --disable-efence \
  --disable-gtktest \
  --build="${BUILD_SYSTEM}" \
  --host="${HOST}" \
  --cache-file=config.cache || return 1
  # --host="${HOST}" || return 1

# make 및 설치
make -j$(get_cpu_count) || return 1

make install || return 1

# CREATE PACKAGE CONFIG MANUALLY
create_libmp3lame_package_config "3.100" || return 1
