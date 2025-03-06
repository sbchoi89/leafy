#!/bin/sh 
# 오류가 발생했을 때 스크립트를 중단하도록 설정
set -e 

# envsubst 명령어를 사용해서 default.conf.template 파일에서 환경 변수를 실제 값으로 대체하고 결과를 default.conf에 저장 
# 템플릿 파일과 환경 변수를 읽은 뒤 nginx.conf 파일을 구성하여 nginx 설정으로 복사

# envsubst '${BACKEND_HOST} ${BACKEND_PORT}' -> ${BACKEND_HOST}와 ${BACKEND_PORT}를 환경 변수 값으로 치환
# < /etc/nginx/conf.d/default.conf.template -> 템플릿 파일을 입력으로 사용
# > /etc/nginx/conf.d/default.conf -> 치환된 내용을 새로운 파일(default.conf)에 저장
envsubst '${BACKEND_HOST} ${BACKEND_PORT}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf 

# 다음 명령어를 실행
# "$@" -> CMD ["nginx", "-g", "daemon off;" ] 옵션 값을 실행하는 부분 
exec "$@" 