# base image: eclipse-temurin 17 JRE
FROM eclipse-temurin:17-jre-alpine

# JAR 파일을 컨테이너의 /app 디렉토리로 복사
COPY cs.jar /app/cs.jar

# 컨테이너 실행 시 JAR 파일을 실행
CMD ["java", "-jar", "/app/cs.jar"]

