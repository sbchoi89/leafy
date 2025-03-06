# 빌드 이미지로 OpenJDK 11 & Gradle을 지정 (AS를 써서 빌드 스테이징을 명시)
FROM gradle:7.6.1-jdk11 AS build

# 소스코드를 복사할 작업 디렉토리를 생성 (mkdir+cd 효과)
WORKDIR /app

# 라이브러리 설치에 필요한 파일 복사
# build.gradle settings.gradle 내용이 변경되지 않는 이상 gradle dependencies 레이어까지는 캐시 활용
COPY build.gradle settings.gradle ./
RUN gradle dependencies --no-daemon

# 호스트 머신의 소스코드를 작업 디렉토리로 복사 (docker cp 명령과 동일: 호스트OS 경로(앞) 가상 컨테이너 경로(뒤) )
COPY . /app

# Gradle 빌드를 실행하여 JAR 파일을 생성
RUN gradle clean build --no-daemon

# 런타임 이미지로 OpenJDK 11 JRE-slipm 지정
# 이렇게 FROM 이 2개 있게 되면 도커가 두 개의 컨테이너를 동시에 생성하고 마지막 FROM을 기준으로 이미지 생성
FROM openjdk:11-jre-slim

# 애플리케이션을 실행할 작업 디렉토리를 생성
WORKDIR /app

# 빌드 이미지에서 생성된 JAR 파일을 런타임 이미지로 복사
# COPY 명령어에 from 옵션을 사용하면 빌드 컨텍스트에 있는 파일을 가져오는 것이 아니라 build라고 이름 지어진 maven 스테이지에서 파일을 가져오게 된다.
COPY --from=build /app/build/libs/*.jar /app/leafy.jar 

EXPOSE 8080

ENTRYPOINT [ "java" ]
CMD [ "-jar", "leafy.jar" ]
