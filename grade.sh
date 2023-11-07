CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'

tests=`find ./student-submission -name "ListExamples.java"`

echo $tests
if [[ "$tests" ==  *"ListExamples.java" ]];
then 
    echo "The file was found"
else 
    echo "File not found"
    exit 1
fi

cp $tests ./grading-area
# cp GradeServer.java ./grading-area
# cp Server.java ./grading-area
cp TestListExamples.java ./grading-area

javac -cp $CPATH ./grading-area/TestListExamples.java ./grading-area/ListExamples.java > output.txt
echo `cat output.txt`
java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > testOutput.txt
echo `cat testOutput.txt`


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests
