allprojects {
    repositories {
        google()
        mavenCentral()
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

subprojects {
    val configAction = Action<Project> {
        val androidExt = extensions.findByName("android")
        if (androidExt != null) {
            try {
                val getNamespaceObj = androidExt.javaClass.getMethod("getNamespace")
                val ns = getNamespaceObj.invoke(androidExt)
                if (ns == null || ns.toString().isEmpty()) {
                    val setNamespaceObj = androidExt.javaClass.getMethod("setNamespace", String::class.java)
                    setNamespaceObj.invoke(androidExt, project.group.toString())
                }
            } catch (e: Exception) {}
        }
    }
    if (state.executed) {
        configAction.execute(this)
    } else {
        afterEvaluate(configAction)
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
