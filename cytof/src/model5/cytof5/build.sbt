name := "cytof5"

version := "0.1.0"

scalaVersion := "2.12.6"

libraryDependencies ++= Seq(
  "org.ddahl" %% "rscala" % "2.5.0", // may not be necessary.
  "org.scalanlp" %% "breeze" % "0.13.2", // may not be necessary. we'll see.
  "org.apache.commons" % "commons-math3" % "3.6.1",
  "org.scalatest" %% "scalatest" % "3.0.0" % "test"
)

lazy val root = Project("root", file(".")) dependsOn(distributions)
lazy val distributions = RootProject(uri("git://github.com/luiarthur/scala-distributions.git"))


