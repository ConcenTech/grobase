allprojects {
    repositories {
        google()
        mavenCentral()
    }
}



subprojects {
    afterEvaluate {
        if (hasProperty("android")) {
            when (val androidExtension = extensions.findByName("android")) {
                is com.android.build.api.dsl.ApplicationExtension -> androidExtension.compileSdk = 36
                is com.android.build.api.dsl.LibraryExtension -> androidExtension.compileSdk = 36
            }
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

