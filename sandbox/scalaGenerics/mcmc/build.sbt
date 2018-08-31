name := "mcmc"

version := "0.1.0"

scalaVersion := "2.12.6"

libraryDependencies ++= Seq(
  "org.scalanlp" %% "breeze" % "0.13.2",
  "org.apache.commons" % "commons-math3" % "3.6.1", // in case i need it. remove later.
  "org.scalatest" %% "scalatest" % "3.0.0" % "test"
)

assemblyJarName in assembly := "mcmc.jar"
