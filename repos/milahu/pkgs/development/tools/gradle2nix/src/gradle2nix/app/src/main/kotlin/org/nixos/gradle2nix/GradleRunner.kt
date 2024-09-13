package org.nixos.gradle2nix

import kotlinx.coroutines.suspendCancellableCoroutine
import org.gradle.tooling.GradleConnectionException
import org.gradle.tooling.GradleConnector
import org.gradle.tooling.ProjectConnection
import org.gradle.tooling.ResultHandler
import org.gradle.tooling.model.gradle.GradleBuild
import org.nixos.gradle2nix.model.DependencySet
import java.io.File
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException
import kotlin.io.path.absolutePathString

fun connect(
    config: Config,
    projectDir: File = config.projectDir,
): ProjectConnection =
    GradleConnector
        .newConnector()
        .apply {
            when (val source = config.gradleSource) {
                is GradleSource.Distribution -> useDistribution(source.uri)
                is GradleSource.Path -> useInstallation(source.path)
                GradleSource.Project -> useBuildDistribution()
                is GradleSource.Wrapper -> useGradleVersion(source.version)
            }
        }.forProjectDirectory(projectDir)
        .connect()

suspend fun ProjectConnection.buildModel(): GradleBuild =
    suspendCancellableCoroutine { continuation ->
        val cancellationTokenSource = GradleConnector.newCancellationTokenSource()

        continuation.invokeOnCancellation { cancellationTokenSource.cancel() }

        action { controller -> controller.buildModel }
            .withCancellationToken(cancellationTokenSource.token())
            .run(
                object : ResultHandler<GradleBuild> {
                    override fun onComplete(result: GradleBuild) {
                        continuation.resume(result)
                    }

                    override fun onFailure(failure: GradleConnectionException) {
                        continuation.resumeWithException(failure)
                    }
                },
            )
    }

suspend fun ProjectConnection.build(
    config: Config,
    tasks: List<String>,
): DependencySet =
    suspendCancellableCoroutine { continuation ->
        val cancellationTokenSource = GradleConnector.newCancellationTokenSource()

        continuation.invokeOnCancellation { cancellationTokenSource.cancel() }

        action { controller -> controller.getModel(DependencySet::class.java) }
            .withCancellationToken(cancellationTokenSource.token())
            .forTasks(*tasks.toTypedArray())
            .setJavaHome(config.gradleJdk)
            .addArguments(config.gradleArgs)
            .addArguments(
                "--refresh-dependencies",
                "--gradle-user-home=${config.gradleHome}",
                "--init-script=${config.appHome}/init.gradle",
            ).apply {
                if (config.logger.stacktrace) {
                    addArguments("--stacktrace")
                }
                if (config.logger.logLevel < LogLevel.ERROR) {
                    setStandardOutput(System.err)
                    setStandardError(System.err)
                }
                if (config.dumpEvents) {
                    withSystemProperties(
                        mapOf(
                            "org.gradle.internal.operations.trace" to
                                config.outDir
                                    .toPath()
                                    .resolve("debug")
                                    .absolutePathString(),
                        ),
                    )
                }
            }.run(
                object : ResultHandler<DependencySet> {
                    override fun onComplete(result: DependencySet) {
                        continuation.resume(result)
                    }

                    override fun onFailure(failure: GradleConnectionException) {
                        continuation.resumeWithException(failure)
                    }
                },
            )
    }
