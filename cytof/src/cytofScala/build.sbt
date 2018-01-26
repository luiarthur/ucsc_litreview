name := "cytofScala"

version := "0.1.0"

scalaVersion := "2.11.8"

scalacOptions := Seq("-unchecked", "-deprecation")

libraryDependencies ++= Seq(
  //"org.ddahl" %% "rscala" % "2.5.0",
  
  // A smaller jar (14MB) can be downloaded at: https://mvnrepository.com/artifact/org.scalanlp/breeze_2.11/1.0-RC2
  //"org.scalanlp" %% "breeze" % "1.0-RC2",
  "org.scalanlp" %% "breeze" % "0.13.2",

  "org.scalatest" %% "scalatest" % "3.0.0" % "test"
)

