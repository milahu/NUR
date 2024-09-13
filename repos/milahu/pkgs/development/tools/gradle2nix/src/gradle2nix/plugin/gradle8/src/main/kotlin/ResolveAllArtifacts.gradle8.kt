package org.nixos.gradle2nix

import org.gradle.api.Project
import org.gradle.api.file.FileCollection
import org.gradle.api.model.ObjectFactory
import org.gradle.api.tasks.TaskAction
import org.gradle.api.tasks.TaskProvider
import org.gradle.internal.serialization.Cached
import org.gradle.work.DisableCachingByDefault
import org.nixos.gradle2nix.model.RESOLVE_PROJECT_TASK
import javax.inject.Inject

object ResolveAllArtifactsApplierG8 : AbstractResolveAllArtifactsApplier() {
    override fun Project.registerProjectTask(): TaskProvider<*> =
        tasks.register(RESOLVE_PROJECT_TASK, ResolveProjectDependenciesTaskG8::class.java)
}

@DisableCachingByDefault(because = "Not worth caching")
abstract class ResolveProjectDependenciesTaskG8
    @Inject
    constructor(
        private val objects: ObjectFactory,
    ) : ResolveProjectDependenciesTask() {
        private val artifactFiles = Cached.of { artifactFiles() }

        private fun artifactFiles(): FileCollection =
            objects.fileCollection().from(
                getReportableConfigurations().map { configuration ->
                    configuration.artifactFiles()
                },
            )

        @TaskAction
        fun action() {
            artifactFiles.get().count()
        }
    }
