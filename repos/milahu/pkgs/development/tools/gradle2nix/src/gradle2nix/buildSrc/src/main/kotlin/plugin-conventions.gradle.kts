@file:Suppress("UnstableApiUsage")

import com.github.jengelman.gradle.plugins.shadow.tasks.ShadowJar

plugins {
    id("gradle-kotlin-conventions")
    id("io.github.goooler.shadow")
    `java-gradle-plugin`
}

dependencies {
}

configure<GradlePluginDevelopmentExtension> {
    plugins {
        register("gradle2nix") {
            id = "org.nixos.gradle2nix"
            displayName = "gradle2nix"
            description = "Expose Gradle tooling model for the gradle2nix tool"
            implementationClass = "org.nixos.gradle2nix.Gradle2NixPlugin"
        }
    }
}

configurations {
    "api" {
        dependencies.remove(project.dependencies.gradleApi())
    }
}

tasks {
    "jar" {
        enabled = false
    }

    named("shadowJar", ShadowJar::class) {
        duplicatesStrategy = DuplicatesStrategy.EXCLUDE
        isPreserveFileTimestamps = false
        isReproducibleFileOrder = true
        val mode644 = 0b110100100
        val mode755 = 0b111101101
        fileMode = mode644
        dirMode = mode755
        filesMatching("**/bin/*") { mode = mode755 }
        filesMatching("**/bin/*.bat") { mode = mode644 }

        relocate("kotlinx", "${project.group}.shadow.kotlinx")
        relocate("org.intellij", "${project.group}.shadow.intellij")
        relocate("org.jetbrains", "${project.group}.shadow.jetbrains")

        dependencies {
            exclude { it.moduleGroup == "org.jetbrains.kotlin" && it.moduleName == "kotlin-stdlib" }
            exclude { it.moduleGroup == "org.jetbrains.kotlin" && it.moduleName == "kotlin-stdlib-common" }
            exclude { it.moduleGroup == "org.jetbrains.kotlin" && it.moduleName == "kotlin-stdlib-jdk7" }
            exclude { it.moduleGroup == "org.jetbrains.kotlin" && it.moduleName == "kotlin-stdlib-jdk8" }
            exclude { it.moduleGroup == "org.jetbrains.kotlin" && it.moduleName == "kotlin-reflect" }
            exclude { it.moduleGroup == "org.jetbrains.kotlin" && it.moduleName == "kotlin-script-runtime" }
        }
    }
}
