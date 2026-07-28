# codyssey-week1-workstation

## 1. 프로젝트 개요

- **코디세이 AI 입학 연수 2기 1주차**
- **Mission E1-1:** 내 컴퓨터에 개발자용 '작업실' 꾸미기

<br/>

## 2. 실행 환경

- **OS:** macOS (Apple Silicon)
- **Container Runtime:** OrbStack (Docker Engine v29.4.0)
- **Shell:** zsh / bash
- **Git:** v2.46.2

<br/>

## 3. 수행 항목 체크리스트

- [x] 터미널 기본 조작 및 폴더 구성
- [x] 권한 변경 실습 (chmod 644 / 755)
- [x] Docker 설치/점검 (OrbStack)
- [x] Docker 기본 운영 명령 수행
- [x] hello-world 및 ubuntu 컨테이너 실행
- [x] 커스텀 Dockerfile 빌드 및 실행
- [x] 포트 매핑 접속 (8080, 8081)
- [x] 바인드 마운트 반영 검증
- [x] Docker 볼륨 데이터 영속성 검증
- [x] Git/GitHub 연동
- [x] VSCode Github 연결

<br/>

## 4. 터미널 및 권한 조작 로그

1. 입력 CLI

```bash
# 1. 디렉토리 조작 실습
pwd                          # 현재 위치 확인
ls -la                       # 숨김 파일 포함 목록 확인
touch test-file.txt          # 빈 파일 생성
mkdir test-dir               # 디렉토리 생성
cp test-file.txt copy.txt    # 파일 복사
mv copy.txt renamed.txt      # 이름 변경
rm renamed.txt               # 삭제

# 2. 파일/디렉토리 권한 변경 실습
# 파일 권한 변경 (644)
chmod 644 test-file.txt
ls -l test-file.txt          # 변경 전/후 권한 확인 로그 수집

# 디렉토리 권한 변경 (755)
chmod 755 test-dir
ls -ld test-dir              # 변경 전/후 권한 확인 로그 수집
```

2. CLI 실행 화면
<img width="1470" height="923" alt="4" src="https://github.com/user-attachments/assets/2dc4e4e7-a740-4ddc-aaa7-048345389f8f" />


<br/>

## 5. Docker 커스텀 이미지 & 포트 매핑

### 5-1. Docker 설치 및 데몬 정보 확인

1. CLI

```bash
docker --version
docker info
```

2. CLI 실행 화면
<img width="1470" height="923" alt="5-1" src="https://github.com/user-attachments/assets/990b9ec4-72d3-4bb5-ac70-460461e624a9" />


### 5-2. hello-world 컨테이너 실행

1. CLI

```bash
docker run hello-world
```

2. CLI 실행 화면
<img width="1470" height="923" alt="5-2" src="https://github.com/user-attachments/assets/254a03a2-a8dd-4e5f-b8a8-02338c307d25" />


### 5-3. ubuntu 컨테이너 진입 및 간단한 명령 수행

1. CLI

```bash
docker run -it ubuntu bash
ls -la
echo "Hello Ubuntu"
exit
```

2. CLI 실행 화면

<img width="1470" height="923" alt="5-3" src="https://github.com/user-attachments/assets/50df23ba-1836-497b-8f1f-396ee5cfb032" />


<br/>

## 6. 커스텀 웹 서버 빌드 및 포트 매핑

### 6-1.파일 작성

1. `app/index.html`

```html
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <title>Dev Workstation</title>
  </head>
  <body>
    <h1>🚀 Hello from My Custom Nginx Web Server!</h1>
  </body>
</html>
```

2. `Dockerfile`

```Dockerfile
# 1. 베이스 이미지 선택 (가볍고 안정적인 Nginx Alpine 이미지)
FROM nginx:alpine

# 2. 메타데이터 지정 (커스텀 이미지 구분용)
LABEL maintainer="hyu <hyu@example.com>"
LABEL description="My Custom Nginx Web Server for Mission"

# 3. 환경변수 설정
ENV APP_ENV=development

# 4. 호스트의 정적 웹 파일(app/)을 Nginx 기본 HTML 디렉토리로 복사
COPY ./app /usr/share/nginx/html

# 5. 컨테이너가 사용할 포트 명시 (알림용)
EXPOSE 80

# 6. 컨테이너 실행 시 Nginx 데몬을 포그라운드로 실행
CMD ["nginx", "-g", "daemon off;"]
```

### 6-2. 이미지 빌드 및 포트 매핑 실행

1. CLI

```bash
# 이미지 빌드
docker build -t my-web:1.0 .

# 포트 매핑 실행 (-p 8080:80)
docker run -d -p 8080:80 --name my-web-container my-web:1.0

# 컨테이너 상태 및 로컬 접속 확인
docker ps
curl http://localhost:8080
```

2. CLI 실행 화면

|<img width="1470" height="923" alt="6-2-1" src="https://github.com/user-attachments/assets/c47fbd30-87b7-44fb-b4be-e04f12f70773" />|<img width="1470" height="923" alt="6-2-3" src="https://github.com/user-attachments/assets/2bd2ff24-b9de-4f9e-b463-ff42d4900c04" />|
|---|---|


4. 결과 화면

<img width="1470" height="923" alt="6-3" src="https://github.com/user-attachments/assets/c1da3ac7-d8c0-4f6a-94bc-dcd8064ce6cc" />


<br/>

## 7. 바인드 마운트 & 볼륨 영속성 검증

### 7-1. 바인드 마운트 실습

1. CLI

- 접속 문제로 인하여 8081 포트로 변경 실행

```bash
# 호스트의 app 폴더를 컨테이너 내부 Nginx 경로로 직접 연결하여 실행
docker run -d -p 8081:80 -v $(pwd)/app:/usr/share/nginx/html --name web-bind my-web:1.0

# 호스트에서 index.html 파일 변경
echo "<h1>Updated Content via Bind Mount!</h1>" > app/index.html

# 접속하여 변경사항 확인
curl http://localhost:8081
```

2. CLI 실행 화면

<img width="1470" height="923" alt="7-1-2" src="https://github.com/user-attachments/assets/415ee6f8-0304-49f1-b918-4c21025aeae4" />


3. 결과 화면
<img width="1470" height="923" alt="7-1-3" src="https://github.com/user-attachments/assets/9ae425ec-1956-450e-bfc8-4b0df1fd833c" />

### 7-2. Docker 볼륨 데이터 영속성 검증

1. CLI

```bash
# 1. 볼륨 생성
docker volume create my-data-vol

# 2. 1번 컨테이너에 볼륨 연결 후 데이터 생성
docker run -d --name vol-container1 -v my-data-vol:/data ubuntu sleep infinity
docker exec vol-container1 bash -c "echo 'Persistent Data' > /data/test.txt"
docker exec vol-container1 cat /data/test.txt

# 3. 1번 컨테이너 강제 삭제
docker rm -f vol-container1

# 4. 2번 컨테이너에 동일 볼륨 연결 후 데이터 보존 확인
docker run -d --name vol-container2 -v my-data-vol:/data ubuntu sleep infinity
docker exec vol-container2 cat /data/test.txt
# (출력: Persistent Data -> 영속성 검증 성공)
```

2. 실행 화면

<img width="1470" height="923" alt="7-2-1" src="https://github.com/user-attachments/assets/04f4cf09-129c-4a88-ad8b-d03fe7889262" />


<br/>

## 8. Git 설정 및 GitHub 저장소 생성

### 8-1. Github 설정 및 저장소 연결 CLI
<img width="1470" height="923" alt="8-1" src="https://github.com/user-attachments/assets/b5d6f16c-7759-49c4-bb2d-046cee398af3" />


### 8-2. 결과 화면
- `test-dir`은 빈 디렉토리이므로 `origin`에 올라가지 않습니다.
|origin|local|
|---|---|
|<img width="1470" height="923" alt="8-2" src="https://github.com/user-attachments/assets/31211c89-8cc5-466f-90f9-3d899dd0f528" />|<img width="1470" height="923" alt="8-3" src="https://github.com/user-attachments/assets/41d03f02-20f3-4db6-b1e4-4dea9ad88fd3" />|


<br/>

## 9. 트러블슈팅

### [Troubleshooting 1] macOS Apple Silicon(M 시리즈) 환경의 플랫폼 호환성 이슈

<b> [문제 상황]</b> <br/>
OrbStack/Docker 빌드 시 일부 베이스 이미지 사용 시
`WARNING: The requested image's platform (linux/amd64) does not match the detected host platform` 경고 발생.

<b> [원인 가설]</b> </br>
호스트 기기(MacBook Air)가 ARM64(aarch64) 아키텍처를 사용하는데 불러오려는 이미지나 일부 종속 라이브러리가 x86_64(amd64) 기반으로 작성되었을 것이다.

<b>[검증 방법]</b> </br>
`docker inspect <image_name>` 명령을 통해 Architecture 항목이 arm64인지 amd64인지 확인.

<b> [해결 방안]</b> </br>
docker build 명령어 실행 시 `--platform linux/arm64` 플래그를 명시하여 호스트 아키텍처에 맞는 이미지를 다운로드 및 빌드하도록 해결함.

---

### [Troubleshooting 2] 포트 충돌(Port Conflict)로 인한 컨테이너 실행 실패

<b>[문제 상황]</b> </br>
`docker run -d -p 8080:80 ...` 명령어로 웹 서버 컨테이너를 실행하려고 할 때 `bind: address already in use` 에러가 발생하며 컨테이너가 생성되지 않음.

<b>[원인 가설]</b> </br>
호스트 PC의 8080 포트를 이미 다른 애플리케이션이나 이전에 실행한 테스트 컨테이너가 사용 중일 것이다.

<b>[검증 방법]</b> </br>
터미널에서 macOS 포트 확인 명령 `lsof -i :8080`으로 점유 프로세스를 확인함.

<b>[해결 방안]</b> </br>
호스트 포트를 바꿔서 `docker run -d -p 8081:80 ...` 형태로 매핑 포트를 변경하여 정상 실행함.
