plugins {
    `plugin-conventions`
}

dependencies {
    implementation(project(":plugin:gradle8"))
    compileOnly(libs.gradle.api.get81())
}

tasks.shadowJar {
    archiveFileName = "plugin-gradle81.jar"
}
