# Create your grading script here

#set -e

#Setting variables
CP=".:$PWD/lib/hamcrest-core-1.3.jar:$PWD/lib/junit-4.13.2.jar"

#Delete old student-submission
if [[ -e student-submission/ ]]; then
    rm -rf student-submission
    echo "Student-submission is deleted"
else
    echo "student-submission doesn't exist"
fi

#Cloning student submission
git clone $1 student-submission
echo "Finished cloning student-submission"

#Copying my tests to the student submission directory 
cp TestListExamples.java student-submission/
echo "Copied Test Successfully"

#Change into the student submission directory
cd student-submission/
echo "In student-submission/"

#Compiling all the java files
javac -cp $CP *.java
if [[ $? -eq 0 ]]; then
    echo "Compiled"
else
    echo "Failed to compile"
    TOTAL_GRADE="Your total grade is: 0/100"
    echo $TOTAL_GRADE
    exit $?
fi


#Run the Test file
java -cp $CP org.junit.runner.JUnitCore TestListExamples 1> stdout.txt 2> stderr.txt
# if [[ $? -eq 0 ]]; then
#     TEMP=$(grep -o "Failure" stderr.txt || grep -o "OK" stdout.txt)
    
#     TOTAL_GRADE=
# fi