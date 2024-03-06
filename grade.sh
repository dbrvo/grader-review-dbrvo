CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests

cp student-submission/*.java grading-area
cp *.java grading-area
cp -r lib grading-area

cd grading-area

if ! [ -f ListExamples.java ]
then
    echo "Missing ListExamples.java in student submission"
    echo "Your score is 0"
    exit 1
fi

javac -cp $CPATH *.java
if [ $? -ne 0 ]
then
    echo "Compilation error"
    echo "Your score is 0"
    exit 1
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > junit-output.txt

lastline=$(cat junit-output.txt | tail -n 2 | head -n 1)
tests=$(echo $lastline | awk -F'[, ]' '{print $3}')
failures=$(echo $lastline | awk -F'[, ]' '{print $6}')

if [ $tests == "tests)" ]
then
    echo "Your score is 100%"
    exit 0
fi

successes=$((tests - failures))


echo "Your score is $successes / $tests"