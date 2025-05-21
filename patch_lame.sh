#!/bin/bash
set -e

# 경로 설정: ffmpeg-kit repo 내부의 lame 디렉토리로 수정 필요
LAME_DIR="./src/lame/lame"

if [ ! -d "$LAME_DIR" ]; then
  echo "❌ lame 디렉토리를 찾을 수 없습니다: $LAME_DIR"
  exit 1
fi

echo "🔧 lame 디렉토리로 이동: $LAME_DIR"
cd "$LAME_DIR"

# configure.in → configure.ac
if [ -f "configure.in" ]; then
  echo "📝 configure.in → configure.ac 변경"
  mv configure.in configure.ac
fi

# m4 디렉토리 생성
echo "📁 m4 디렉토리 생성"
mkdir -p m4

# 매크로 복사
cp /opt/homebrew/Cellar/gettext/0.25/share/gettext/m4/iconv.m4 m4/

# 환경 변수 설정
echo "📦 환경 변수 설정 (ACLOCAL_PATH, PKG_CONFIG_PATH)"
export ACLOCAL_PATH="/opt/homebrew/share/aclocal:/opt/homebrew/opt/gettext/share/aclocal"
export PKG_CONFIG_PATH="/opt/homebrew/lib/pkgconfig:/opt/homebrew/opt/libiconv/lib/pkgconfig"

# configure.ac에 매크로 디렉토리 지정
# AC_CONFIG_MACRO_DIRS([m4]) 가 configure.ac 내에 존재해야 함) -> AC_PREREQ(2.69) 위에 추가
if ! grep -q "AC_CONFIG_MACRO_DIRS" configure.ac; then
  echo "AC_CONFIG_MACRO_DIRS 추가"
  sed -i '' 's/AC_PREREQ(2.69)/AC_CONFIG_MACRO_DIRS([m4])\n&/' configure.ac
fi

# aclocal이 m4를 인식하도록 강제
aclocal -I m4

# autoreconf 실행
echo "🔁 autoreconf -fiv 실행"
autoreconf -fiv

echo "⚙️ configure 실행 (cross compile 대응)"
# config.cache 파일 생성
echo "📄 config.cache 파일 생성"
{
  echo "ac_cv_func_strtol=yes"
  echo "ac_cv_func_malloc_0_nonnull=yes"
  echo "ac_cv_func_gettimeofday=yes"
  echo "ac_cv_c_bigendian=no"
} > config.cache

./configure \
  --host=x86_64-apple-darwin \
  --disable-shared \
  --enable-static \
  --cache-file=config.cache

echo "✅ lame 패치 및 configure 완료"