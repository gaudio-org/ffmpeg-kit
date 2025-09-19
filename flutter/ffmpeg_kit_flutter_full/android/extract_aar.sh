#!/bin/bash

# AAR 파일 추출 및 설정 스크립트
# 사용법: ./extract_aar.sh [AAR파일명]

set -e  # 오류 발생 시 스크립트 중단

# 스크립트 디렉토리 설정
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIBS_DIR="$SCRIPT_DIR/libs"
EXTRACTED_DIR="$LIBS_DIR/ffmpeg-kit-extracted"
JNI_LIBS_DIR="$SCRIPT_DIR/src/main/jniLibs"

# AAR 파일명 설정 (첫 번째 인자 또는 기본값)
AAR_FILE="${1:-ffmpeg-kit-lame-16kb.aar}"

# AAR 파일 경로 설정 (libs/ 접두사가 있으면 제거)
if [[ "$AAR_FILE" == libs/* ]]; then
    AAR_FILE="${AAR_FILE#libs/}"
fi
AAR_PATH="$LIBS_DIR/$AAR_FILE"

echo "🔧 AAR 파일 추출 및 설정 시작..."
echo "📁 AAR 파일: $AAR_PATH"

# AAR 파일 존재 확인
if [ ! -f "$AAR_PATH" ]; then
    echo "❌ 오류: AAR 파일을 찾을 수 없습니다: $AAR_PATH"
    echo "📋 사용 가능한 AAR 파일들:"
    ls -la "$LIBS_DIR"/*.aar 2>/dev/null || echo "   AAR 파일이 없습니다."
    exit 1
fi

# 기존 추출된 폴더 삭제
if [ -d "$EXTRACTED_DIR" ]; then
    echo "🗑️  기존 추출된 폴더 삭제 중..."
    rm -rf "$EXTRACTED_DIR"
fi

# AAR 파일 압축 해제
echo "📦 AAR 파일 압축 해제 중..."
mkdir -p "$EXTRACTED_DIR"
unzip -q "$AAR_PATH" -d "$EXTRACTED_DIR"

# classes.jar 파일 존재 확인
if [ ! -f "$EXTRACTED_DIR/classes.jar" ]; then
    echo "❌ 오류: classes.jar 파일을 찾을 수 없습니다."
    exit 1
fi

# jniLibs 디렉토리 생성 및 네이티브 라이브러리 복사
echo "📱 네이티브 라이브러리 복사 중..."
if [ -d "$EXTRACTED_DIR/jni" ]; then
    # 기존 jniLibs 폴더 삭제
    if [ -d "$JNI_LIBS_DIR" ]; then
        rm -rf "$JNI_LIBS_DIR"
    fi
    
    # jniLibs 디렉토리 생성
    mkdir -p "$JNI_LIBS_DIR"
    
    # 네이티브 라이브러리 복사
    cp -r "$EXTRACTED_DIR/jni"/* "$JNI_LIBS_DIR/"
    
    echo "✅ 네이티브 라이브러리 복사 완료:"
    ls -la "$JNI_LIBS_DIR"
else
    echo "⚠️  경고: jni 폴더를 찾을 수 없습니다. 네이티브 라이브러리가 없을 수 있습니다."
fi

echo "✅ AAR 파일 추출 및 설정 완료!"
echo ""
echo "📋 추출된 내용:"
echo "   - JAR 파일: $EXTRACTED_DIR/classes.jar"
echo "   - 네이티브 라이브러리: $JNI_LIBS_DIR/"
echo ""
echo "🚀 이제 Flutter 프로젝트를 빌드할 수 있습니다:"
echo "   flutter clean && flutter build apk --debug"
