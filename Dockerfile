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