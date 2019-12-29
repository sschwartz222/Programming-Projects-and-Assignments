#!/usr/bin/env python

from collections import OrderedDict
from os import system, getcwd, chdir
from os.path import isfile, isdir
from subprocess import Popen, PIPE
from Queue import Empty
from multiprocessing import Process, Queue
import os

folder_name =  os.getcwd().split(os.sep)[-1]
if folder_name == 'test-scripts':
	HERE = './'
else:
	print 'Please run grade script inside p4shell/test-scripts'
	exit(0)

# Path to Batch Files
PBF = HERE + '/../batch-files'
PEF = HERE + '/../expected-output'
# Path to src solution files
SOLN = '../'
shell_path = SOLN + 'myshell'

TIMEOUT = 10

batchfiles = OrderedDict((('gooduser_basic', 8),
                          ('gooduser_args', 8),
                          ('gooduser_rd', 8),
                          ('gooduser_multipleCommand', 8),
                          ('buildin_wrongFormat', 8),
                          ('cd_toFolderNotExist', 3),
                          ('badCommand', 4),
                          ('complexCommand', 6),
                          ('multipleCommand', 9),
                          ('complexRedirection_format', 6),
			              ('advancedRedirection_format', 6),
                          ('complexRedirection_illegal', 6),
			              ('advancedRedirection_illegal', 6),
                          ('advancedRedirection_concat', 6),
			              ('emptyInput', 1),
                          ('1KCommand', 3)))

aux_files = {
	         'advancedRedirection_concat': [14],
             'advancedRedirection_format': range(1, 9),
             'advancedRedirection_illegal': [9],

             'complexRedirection_format': range(1, 9),
             'complexRedirection_illegal': [9],
             'gooduser_rd': range(1,3)}

def __safeExec(child, result_queue):
    result_queue.put(child.communicate(''))
    return

def safeExec(cli):
    q = Queue()
    child = Popen(cli, shell=True, stdout=PIPE, stderr=PIPE, stdin=PIPE)
    t = Process(target =  __safeExec, args = (child, q))
    t.start()
    try:
        output = q.get(True, TIMEOUT)
    except Empty:
        child.kill()
        t.terminate()
        t.join()
        system('killall -r myshell')
        print 'Timed out'
        return (True, ('', ''))
    t.join()
    return (False, output)

def takeDiff(file1, file2):
    system('chmod u+r {}'.format(file1))
    exec_result = safeExec('diff {} {}'.format(file1, file2))
    stdout = exec_result[1][0]
    print stdout
    stderr = exec_result[1][1]
    print stderr
    if stdout.strip() == '' and stderr.strip() == '':
        #success
        return True
    return False

def runBatch(bf):

    print "----------------------------------"
    print "Running batch file: " + bf
   
    if not isfile(shell_path):
        print shell_path + " does not exist"
        return False

    exec_result = safeExec("{shell_path} {PBF}/{bf} 1> out/{bf}.stdout 2> out/{bf}.stderr".format(shell_path=shell_path, PBF=PBF, bf=bf))
    if exec_result[0]:
        #timed out
        return False
    
    extensions = [('out/', '.stdout'), ('out/', '.stderr')]
    try:
        aux = aux_files[bf]
    except KeyError:
        aux = ()
    for num in aux:
        extensions.append(('', '_rd_{:d}'.format(num)))
        
    output_match = True
    for extension in extensions:
        filename = bf + extension[1]
        print 'Diffing ' + filename
	#print extension[0] + filename + " vs " + PEF + '/' + filename
        output_match = output_match and takeDiff(extension[0] + filename, PEF + '/' + filename)
    return output_match

def scorePrint(name, score, potential):
    padding = ' '*(20-len(name))
    print '{}{}{:d}\t{:d}'.format(name, padding, score, potential)


def runAll():
    system('rm gooduser_rd_*') #These will cause gooduser to break
    system('rm complexRedirection_*')
    system('rm advancedRedirection_*')
    system('rm -f *~')
    if not isdir('out'):
        system('mkdir out')
    system('rm -f out/*')
    here = getcwd()
    chdir(SOLN)
    safeExec('make')
    chdir(here)
    totalScore = 0
    for bf in batchfiles:
        score = 0
        potential = batchfiles[bf]
        if runBatch(bf):
            score = potential
        scorePrint(bf, score, potential)
        totalScore += score
    #run 2 batch files
    score = 0
    potential = 2
    exec_result = safeExec("{shell_path} {PBF}/gooduser {PBF}/badCommand".format(shell_path=shell_path, PBF=PBF))
    if (not exec_result[0]) and (exec_result[1][0].strip() == 'An error has occurred'):
        score = potential
    scorePrint('two arguments', score, potential)
    totalScore += score
    #run non-existant batch file 
    score = 0
    potential = 2
    if isfile('notafile'):
        system('rm notafile')
    exec_result = safeExec("{shell_path} notafile".format(shell_path=shell_path, PBF=PBF))
    if (not exec_result[0]) and exec_result[1][0].strip() == 'An error has occurred':
        score = potential
    scorePrint('does not exist', score, potential)
    totalScore += score
    scorePrint('total', totalScore, 100)

if __name__ == '__main__':
    thisdir = getcwd()
    chdir(HERE)
    # added to clean the durectory before start grading
    system('./clean.sh')
    runAll()
    chdir(thisdir)
