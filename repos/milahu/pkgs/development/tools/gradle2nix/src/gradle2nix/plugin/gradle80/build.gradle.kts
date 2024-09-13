plugins {
    `plugin-conventions`
}

dependencies {
    implementation(project(":plugin:gradle8"))
    compileOnly(libs.gradle.api.get80())
}

tasks.shadowJar {
    archiveFileName = "plugin-gradle80.jar"
}
