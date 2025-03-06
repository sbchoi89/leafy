# 빌드 이미지로 node:14로 지정
FROM node:14 AS build

WORKDIR /app

# 라이브러리 설치에 필요한 파일 복사
COPY package.json .
COPY package-lock.json .

# package.json 폴더의 내용을 참고해서 의존 라이브러리들을 다운로드하는 명령어
# package.json 폴더의 내용이 변경되지 않는 이상 npm ci 까지의 레이어는 캐시를 사용하게 된다.
RUN npm ci

# 빌드 컨텍스트의 소스코드를 작업 디렉토리로 복사, 라이브러리 설치 및 빌드
COPY . /app

# 소스 코드를 빌드해서 애플리케이션으로 만들어 서버 내 dist 폴더에 생성
RUN npm run build

# 런타임 이미지로 nginx 1.21.4 지정 
FROM nginx:1.21.4-alpine

# 소스코드의 nginx.conf 파일을 이미지 빌드 시 nginx 설정으로 복사 (v0.1)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# 소스코드의 nginx.conf 파일을 template 파일로 복사 (v0.2)
COPY nginx.conf /etc/nginx/conf.d/default.conf.template
# 기본 환경변수 지정 -e 옵션을 주지 않았을 때 사용되는 기본 값
ENV BACKEND_HOST=leafy
ENV BACKEND_PORT=8080
# 컨테이너 실행시 자동으로 실행될 스크립트 지정 (커스텀 스크립트, 추가 프로그램, 자동화된 명령어 실행 파일을 배치하는 용도로 사용됨)
COPY docker-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/docker-entrypoint.sh


# 빌드 스테이지에서 생성된 빌드 결과물을 복사
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

# 스크립트 실행 처리
ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD ["nginx", "-g", "daemon off;" ]
