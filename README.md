# ⚙️Dockerfile-Minimize
<br>

## 📄목차

1. [🤝 Team Members](#-team-members)
2. [🥅 Goal](#-goal)
3. [🤔문제 발견](#문제-발견)
4. [🛠 JDK와 JRE 비교](#1-jdk와-jre-비교)
5. [🫙경량화 작업](#2-경량화-작업)
6. [📖 Process](#-process)
7. [💥 TroubleShooting](#-troubleshooting)
8. [🔎 Review](#-review)


<br>

## 🤝 Team Members
| <img src="https://github.com/kcs19.png" width="200px"> |  <img src="https://github.com/unoYoon.png" width="200px"> |
| :---: | :---: |
| [김창성](https://github.com/kcs19) | [윤원호](https://github.com/unoYoon) |

<br>
<br>

## 🥅 Goal

### 개요
Spring Boot 애플리케이션(JAR)을 Docker 이미지로 빌드하고, 이를 Docker Hub에 푸시한 후, 다른 사람이 해당 이미지를 풀 받아 컨테이너를 생성하고 실행하는 과정입니다. 

특히, Dockerfile 최적화를 통해 이미지 빌드 속도와 실행 효율성을 개선하여, 실제 운영 환경에서의 성능 향상과 유지보수 효율을 높였습니다.


### 목표
Spring Boot 애플리케이션을 실제로 Docker화하여 배포 및 실행 환경을 표준화하고, Dockerfile 최적화를 통해 개발과 운영의 효율성을 높이고자 했습니다.


### 🛠️Stack

| Category                  | Technology                                                                 |
|---------------------------|---------------------------------------------------------------------------|
| 🐳 **Containerization**    | ![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white) |
| ☁️ **Cloud & DevOps**      | ![Docker Hub](https://img.shields.io/badge/Docker%20Hub-0db7ed?style=for-the-badge&logo=docker&logoColor=white) |
| ⚙️ **Backend Framework**   | ![Spring Boot](https://img.shields.io/badge/Spring%20Boot-6DB33F?style=for-the-badge&logo=spring&logoColor=white) |
| 🧑‍💻 **Programming Language** | ![Java](https://img.shields.io/badge/Java-007396?style=for-the-badge&logo=java&logoColor=white) |
| 🐧 **Operating System**    | ![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=white) ![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white) |

<br>
<br>

## 🤔문제 발견


### **Tomcat은 OpenJDK 사용**


→ Tomcat은 기본적으로 JDK를 사용하지만, 실행만 하는 환경에서는 JRE가 더 적합함.


![image](https://github.com/user-attachments/assets/abeb626c-efed-4598-a175-5c399e11f1d1)


<br>
<br>


## 🛠 **1. JDK와 JRE 비교**

### **JDK (Java Development Kit)**

- **전체 개발 환경**을 제공하며, Java 개발 도구(컴파일러, 디버거 등)와 **라이브러리**도 포함

### **JRE (Java Runtime Environment)**

- **JDK의 일부**로, 개발 도구나 라이브러리는 포함되지 않으며, Java **애플리케이션 실행 환경**만을 제공

<br>

💡 **결론**

**→ JDK보다 JRE가 더 가벼운 환경을 제공하며, 실행 목적에 맞는 효율적인 선택임.**

<br>
<br>

## 🫙2. **경량화 작업**

### 🔎 2.1 다양한 JDK/JRE 버전의 용량 비교

| **이름** | **버전** | **용량** |
| --- | --- | --- |
| **openjdk** | 17 | 471MB |
| **openjdk** | 17-slim | 408MB |
| **openjdk** | 17-alpine | 326MB |
- **openjdk:17**
    - 전체 JDK 환경 제공
    - 필요한 라이브러리나 도구들이 기본적으로 포함되어 있어 개발 및 디버깅 환경에 적합
    - 가장 큰 용량
- **openjdk:17-slim**
    - 라이브러리나 도구 등 불필요한 파일을 최소화한 경량화된 버전
    - **개발용**이나 **배포용 적합**
- **openjdk:17-alpine**
    - 시스템 라이브러리가 최소화된 환경
    - 가장 작은 용량
    - **보안**과 **최소화된 환경**
    - **호환성** 문제나 **디버깅**이 필요한 경우에는 추가 라이브러리를 설치 필요
    
    **⇒ 시스템 라이브러리가 최소화된 환경으로 가장 작은 용량의 alpine 버전 선택**

<br>


  ### 👉**2.2 eclipse-temurin:17-jre-alpine 선택**

- JRE만 제공하는 공식적인 이미지
- **180MB 최소화된 크기**

![image](https://github.com/user-attachments/assets/ac20d02d-da4c-4cdb-bdae-1cc32a3cd849)


![image](https://github.com/user-attachments/assets/a2d8bd2e-5f80-4c57-974a-5e7efa9a16e0)





## 📖 Process

### 1. Spring Boot JAR 파일 준비

먼저 Spring Boot 애플리케이션을 빌드하여 JAR 파일을 생성합니다.

```jsx
mvn clean package
```

`target` 폴더 안에 `*.jar` 파일이 생성됩니다.

### 2. Dockerfile 작성

Docker 이미지를 만들기 위한 `Dockerfile`을 작성합니다.

```jsx
FROM eclipse-temurin:17-jre-alpine

# 현재 디렉토리에서 JAR 파일을 컨테이너의 /app 디렉토리로 복사
COPY sh.jar /app/sh.jar

# 컨테이너 실행 시 JAR 파일을 실행
CMD ["java", "-jar", "/app/sh.jar"]
```

### 3. Docker 이미지 만들기

`Dockerfile`이 위치한 폴더에서 Docker 이미지를 빌드합니다.

```jsx
docker build -t happy/javaapp:latest .
```

### 4. Docker 컨테이너 실행 확인

이미지가 정상적으로 빌드되었으면, 해당 이미지를 실행하여 

JAR 파일이 잘 동작하는지 확인합니다.

```jsx
docker run -d --name javaapp-container happy/javaapp:latest
```

백그라운드에서 실행되므로 로그를 확인하려면 다음 명령어로 컨테이너의 로그를 볼 수 있습니다

```jsx
docker logs javaapp-container
```

### 5. Docker Hub에 이미지 Push

Docker 이미지를 Docker Hub에 업로드하여 다른 사람들과 공유할 수 있습니다. 이미지를 먼저 로그인한 후 push합니다

```jsx
docker login
docker push happy/javaapp:latest
```

### 6. 다른 사람이 Docker Hub에서 Pull하고 컨테이너 실행

다른 사람이 Docker Hub에서 이미지를 pull하고 실행할 수 있습니다.

```jsx
docker pull happy/javaapp:latest
docker run -d --name javaapp-container happy/javaapp:latest
```

<br>
<br>

## 💥 TroubleShooting


- 수정 전 코드


```jsx
# ✅ JDK 기반에서 필요한 모듈만 포함한 JRE 빌드
FROM openjdk:17-jdk as builder

RUN jlink \
    --module-path /opt/java/openjdk/jmods \
    --add-modules java.base,java.logging,java.sql \
    --output /custom-jre

# ✅ 경량화된 JRE 기반 실행
FROM debian:bullseye-slim

COPY --from=builder /custom-jre /opt/jre
ENV PATH="/opt/jre/bin:${PATH}"

WORKDIR /app
COPY step01_basic_t-0.0.1-SNAPSHOT.jar app.jar

CMD ["java", "-jar", "app.jar"]
----------------------------------------------------------

ERROR: failed to solve: openjdk:17-jre: failed to resolve source metadata for docker.io/library/openjdk:17-jre: docker.io/library/openjdk:17-jre: not found
```


- 사용하고 싶었던 이유


1. **JDK 기반에서 필요한 모듈만 포함한 JRE 빌드**: `jlink`를 사용하여 JRE를 빌드하고, 필요하지 않은 모듈을 제외해 경량화된 이미지를 만들기 위해 사용했습니다.

2. **빌드된 JRE 복사**: 빌드된 JRE를 최종 이미지에 복사하여 불필요한 JDK를 포함하지 않도록 했습니다.

3. **JRE 최적화**: 경량화된 JRE 이미지를 사용하여 컨테이너의 크기를 줄이고 실행 성능을 최적화했습니다.

4. **애플리케이션 실행**: 빌드된 JRE를 사용하여 애플리케이션을 실행할 수 있도록 설정했습니다.



- 문제 상황



`ERROR: failed to solve: openjdk:17-jre: failed to resolve source metadata for docker.io/library/openjdk:17-jre: docker.io/library/openjdk:17-jre: not found` 에러는 Dockerfile 내에서 `openjdk:17-jre` 이미지를 사용할 수 없다는 것을 나타냅니다. 


이 오류의 원인은 `openjdk:17-jre` 이미지가 Docker Hub에서 더 이상 사용할 수 없는 상태이기 때문입니다.


 `openjdk` 이미지에서 `17-jre` 태그는 존재하지 않으며, 그 대신 `openjdk` 이미지는 `17-jdk`나 `eclipse-temurin` 이미지 등을 사용하여 Java 런타임 환경을 설정해야 합니다.


```jsx
// Dockerfile code 변경
FROM eclipse-temurin:17-jre-alpine

// 현재 디렉토리에서 JAR 파일을 컨테이너의 /app 디렉토리로 복사
COPY sh.jar /app/sh.jar

// 컨테이너 실행 시 JAR 파일을 실행
CMD ["java", "-jar", "/app/sh.jar"]

```


- 해결 방법

1. `FROM eclipse-temurin:17-jre-alpine`을 사용하여 경량화된 Java 런타임 환경을 제공하는 `eclipse-temurin` 이미지를 선택했습니다.
  

2. `COPY sh.jar /app/sh.jar`로 현재 디렉토리의 JAR 파일을 컨테이너의 `/app` 디렉토리로 복사했습니다.
  

3. `CMD ["java", "-jar", "/app/sh.jar"]`를 통해 컨테이너 실행 시 JAR 파일을 실행하도록 설정했습니다.

<br>
<br>

## 🔎 Review

Docker 이미지를 최적화하려는 과정에서 여러 방법을 고려해본 결과, 현재는 이미지 크기를 205MB까지 줄였지만, 아직 개선할 여지가 많다는 것을 알게 되었습니다.

- 멀티 스테이지 빌드: 

    멀티 스테이지 빌드를 사용하면 빌드 환경과 실행 환경을 분리할 수 있어, 빌드 도구나 개발 관련 파일을 최종 이미지에서 제외할 수 있습니다.

    이를 통해 이미지 크기를 크게 줄일 수 있을 것으로 예상됩니다.

- 불필요한 캐시와 레이어 제거: 

    Dockerfile에서 불필요한 캐시와 레이어를 제거하는 것은 이미지 최적화에 중요한 부분입니다. 예를 들어, 중간 단계에서 발생한 임시 파일들을 처리하고, 레이어를 합쳐서 이미지 크기를 최소화할 수 있습니다.

- JAR 파일 최적화: 

    JAR 파일을 최적화하는 것도 중요한 부분입니다. 불필요한 리소스나 라이브러리를 제거하고, JAR 파일 크기를 줄이는 방법을 적용하면 더 작은 이미지를 만들 수 있습니다.

이 세 가지 방법은 아직 실험해보지 않았지만, 앞으로 Docker 이미지를 더 최적화하려면 반드시 도입해야 할 기술들입니다. 

현재 상태에서도 205MB로 만족스럽지만, 최적화를 통해 더 작은 이미지와 더 빠른 빌드를 얻을 수 있을 것으로 기대합니다.
