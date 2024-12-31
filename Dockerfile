FROM eclipse-temurin:21-jdk as build
WORKDIR /workspace/app

COPY gradlew .
COPY *.gradle.kts ./
COPY gradle gradle
COPY src src

RUN --mount=type=cache,target=/root/.gradle ./gradlew clean build -x test
RUN mkdir -p build/dependency && (cd build/dependency; jar -xf ../libs/*-SNAPSHOT.jar)

FROM eclipse-temurin:21-jre
VOLUME /tmp

RUN addgroup --system spring && adduser --system spring --ingroup spring
USER spring

ENV SPRING_PROFILES_ACTIVE=docker

ARG DEPENDENCY=/workspace/app/build/dependency

COPY --from=build ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=build ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=build ${DEPENDENCY}/BOOT-INF/classes /app

ENTRYPOINT ["java","-cp","app:app/lib/*","org.example.kotlindemo.KotlinDemoApplicationKt"]