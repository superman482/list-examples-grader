# Create your grading script here

#set -e

# Setting variables
TOTAL_GRADE=0
CP=".:$PWD/lib/hamcrest-core-1.3.jar:$PWD/lib/junit-4.13.2.jar"

echo "---Deleting Old Submssion---" #I got this idea from kNelaconda
# Delete old student-submission
if [[ -e student-submission/ ]]; then
    rm -rf student-submission
    echo "Student-submission is deleted"
else
    echo "Student-submission doesn't exist, proceed to Cloning"
fi

echo "---Cloning New Submission---"
# Cloning student submission
git clone $1 student-submission
echo "Finished cloning student-submission"

echo "---Copying Test File---"
# Copying my tests to the student submission directory
if [[ -e student-submission/ListExamples.java ]]; then
    cp TestListExamples.java student-submission/
    echo "Copied Test Successfully"
else
    find student-submission -name "*.java" | xargs -I % cp % student-submission/ | cp TestListExamples.java student-submission/
    echo "Found and Copied Test File Successfully"
fi

echo "---Changing into Submission Directory---"
# Change into the student submission directory
cd student-submission/
echo "In student-submission/"

echo "---Compiling---"
# Compiling all the java files
javac -cp $CP *.java 2> stderr.txt
if [[ $? -eq 0 ]]; then
    echo "Compiled"
else
    echo "Failed to compile"
    TOTAL_GRADE="Your total grade is: 0/1"
    echo $TOTAL_GRADE
    exit $?
fi

echo "---Running Some Tests---"
# Run the Test file
# If all tests passed, grade = 100%
java -cp $CP org.junit.runner.JUnitCore TestListExamples 1> stdout.txt
if [[ $? -eq 0 ]]; then
    TOTAL_GRADE=1
    echo "Amazing, you passed every tests"
else
    TESTS_RAN=$(grep "^Tests" stdout.txt | cut -d " " -f 3 | cut -b 1) #Getting the number of ran tests.
    TESTS_FAILED=$(grep "^Tests" stdout.txt | cut -d " " -f 6) #Getting the number of failed tests.
    TOTAL_GRADE=$(printf %.2f "$((10**2 * ($TESTS_RAN - $TESTS_FAILED) / $TESTS_RAN))e-2") #Final version
    # TOTAL_GRADE=$((($TESTS_RAN - $TESTS_FAILED) / $TESTS_RAN * 100))
    # printf $TOTAL_GRADE * 100
    # printf %.2f "$((10**2 * ($TESTS_RAN - $TESTS_FAILED) / $TESTS_RAN))e-2"
fi

echo "---Printing Final Score---"
# Print student's submission final score
printf "Your score is $TOTAL_GRADE/1\n"