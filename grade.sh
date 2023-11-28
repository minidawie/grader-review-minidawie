CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission

if [[ $? -ne 0 ]]; then
    echo "Repo not found"
    exit 1
fi

echo -e "Finished cloning"
if [[ ! -f student-submission/ListExamples.java ]]; then
    echo -e "File not found"
    exit 1
fi

echo -e "File ListExamples.java Found!"

cp student-submission/ListExamples.java ./TestListExamples.java grading-area/

grepOut=`cat grading-area/ListExamples.java | grep -E "class\s+ListExamples"`
if [[ $grepOut == "" ]] ; then
    echo -e "Wrong class name"
    exit 1
fi

echo -e "Correct class name!"

javac -cp $CPATH grading-area/*.java 2> grading-area/javac-out
if [[ $? -ne 0 ]]; then
    echo -e "Compilation failed. Fix your shit before submitting :|\n"
    echo " "
    echo "`cat grading-area/javac-out`"
    exit 1
fi

java -cp "$CPATH:grading-area" org.junit.runner.JUnitCore TestListExamples > grading-area/test-output

# All tests pass
okgrep=`cat grading-area/test-output | grep -E "OK"`
if [[ $okgrep != "" ]]; then
    numTests=`echo $okgrep | grep -Eo "\d+"`
    echo -e "All tests passed ($numTests tests)"
    echo -e "Score: 100%"
    exit 0
fi

lastLine=`cat grading-area/test-output | grep "Tests run"`
numTests=`echo $lastLine | grep -oE "Tests run: \d+" | grep -oE "\d+"`
numFailures=`echo $lastLine | grep -oE "Failures: \d+" | grep -oE "\d+"`
numSuccess=$(( numTests - numFailures ))
score=`echo "scale=2; ($numSuccess*100) / $numTests" | bc`
echo -e "Score: $score%"
echo -e "Success: $numSuccess, Failure: $numFailures"