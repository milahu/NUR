package org.nixos.gradle2nix

import org.gradle.api.DefaultTask
import org.gradle.api.Project
import org.gradle.api.artifacts.Configuration
import org.gradle.api.artifacts.component.ModuleComponentIdentifier
import org.gradle.api.file.FileCollection
import org.gradle.api.invocation.Gradle
import org.gradle.api.tasks.Internal
import org.gradle.api.tasks.TaskProvider
import org.gradle.internal.deprecation.DeprecatableConfiguration
import org.nixos.gradle2nix.model.RESOLVE_ALL_TASK

fun interface ResolveAllArtifactsApplier {
    fun apply(gradle: Gradle)
}

abstract class AbstractResolveAllArtifactsApplier : ResolveAllArtifactsApplier {
    abstract fun Project.registerProjectTask(): TaskProvider<*>

    final override fun apply(gradle: Gradle) {
        val resolveAll = gradle.rootProject.tasks.register(RESOLVE_ALL_TASK)

        // Depend on "dependencies" task in all projects
        gradle.allprojects { project ->
            val resolveProject = project.registerProjectTask()
            resolveAll.configure { it.dependsOn(resolveProject) }
        }

        // Depend on all 'resolveBuildDependencies' task in each included build
        gradle.includedBuilds.forEach { includedBuild ->
            resolveAll.configure {
                it.dependsOn(includedBuild.task(":$RESOLVE_ALL_TASK"))
            }
        }
    }
}

abstract class ResolveProjectDependenciesTask : DefaultTask() {
    @Internal
    protected fun getReportableConfigurations(): List<Configuration> =
        project.configurations.filter {
            (it as? DeprecatableConfiguration)?.canSafelyBeResolved() ?: true
        }

    protected fun Configuration.artifactFiles(): FileCollection =
        incoming
            .artifactView { viewConfiguration ->
                viewConfiguration.isLenient = true
                viewConfiguration.componentFilter { it is ModuleComponentIdentifier }
            }.files
}
