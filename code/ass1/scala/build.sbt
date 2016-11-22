name := "ass1"

version := "0.1.0"

scalaVersion := "2.11.8"

libraryDependencies ++= Seq(
  //https://commons.apache.org/proper/commons-math/javadocs/api-3.3/org/apache/commons/math3/random/RandomDataGenerator.html
  "org.ddahl" %% "rscala" % "1.0.12", // for testing
  "org.apache.commons" % "commons-math3" % "3.6.1",
  "org.scalatest" %% "scalatest" % "3.0.0" % "test"
)

