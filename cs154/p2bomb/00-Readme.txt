
For this project (and only this project) you will not be using svn to
check out or submit C code.  As described in the assignment, you
request bombs from http://bomb.cs.uchicago.edu:15213 and your progress
will be reported at http://bomb.cs.uchicago.edu:15213/scoreboard

However, you should use this directory to save the one bombN.tar file
corresponding to the single bomb for which you want your work graded.
After you download bombN.tar, mv it into this directory and

  svn add bombN.tar
  svn commit -m "bomb to grade" bombN.tar

If you decide to get a new bomb (say, bombM.tar), then:

  svn rm bombN.tar
  svn add bombM.tar
  svn commit -m "getting new bomb" bombN.tar bombM.tar

Using this directory to record the bomb you work on is useful because
it resolves potential ambiguities about which of the many possible
bombs associated with a given CNetID should be counted for grading.

To work on your bomb, you will "tar xvf bombN.tar".  You are welcome
but not required to add this directory (and the executable bomb
therein) to your repository.

Also, please feel free to use this directory to keep notes and
whatever partial solutions you want to save as you work through the
various phases.
