#!/bin/bash


testname=gooduser_basic
BATCHPATH=../batch-files
OUTPUTPATH=../expected-output


./clean.sh

mkdir out

../myshell  $BATCHPATH/$testname 1> out/$testname.stdout 2> out/$testname.stderr

echo "Testing $testname stdout" 
diff $OUTPUTPATH/$testname.stdout out/$testname.stdout
echo "Testing $testname stderr"
diff $OUTPUTPATH/$testname.stderr out/$testname.stderr

for filename in *_rd_*;do
        if [[ $filename == "*_rd_*" ]]
        then
                exit
        fi
        echo "Testing $filename redirection"
        diff $OUTPUTPATH/$filename $filename
done

exit

