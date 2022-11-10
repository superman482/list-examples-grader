# Create your grading script here
CP = ".;lib/hamcrest-core-1.3.jar;lib/junit-4.13.2.jar"
CP1 = ".;lib/junit-4.13.2.jar;lib/hamcrest-core-1.3.jar"

set -e

rm -rf student-submission

echo "Student-submission is deleted"

git clone $1 student-submission

echo "Finished cloning student-submission"

cp TestListExamples.java student-submission/

echo "Copied Test Successfully"

cd student-submission/

echo "In student-submission/"

javac -cp $CP *.java

echo "Compiled"

java -cp $CP1 org.junit.runner.JUnitCore TestListExamples