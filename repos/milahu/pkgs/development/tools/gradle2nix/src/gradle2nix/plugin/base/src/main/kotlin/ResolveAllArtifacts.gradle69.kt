package org.nixos.gradle2nix

import org.gradle.api.Project
import org.gradle.api.tasks.TaskAction
import org.gradle.api.tasks.TaskProvider
import org.nixos.gradle2nix.model.RESOLVE_PROJECT_TASK

object ResolveAllArtifactsApplierBase : AbstractResolveAllArtifactsApplier() {
    override fun Project.registerProjectTask(): TaskProvider<*> =
        tasks.register(RESOLVE_PROJECT_TASK, ResolveProjectDependenciesTaskBase::class.java)
}

abstract class ResolveProjectDependenciesTaskBase : ResolveProjectDependenciesTask() {
    @TaskAction
    fun action() {
        for (configuration in getReportableConfigurations()) {
            configuration.artifactFiles().count()
        }
    }
}
