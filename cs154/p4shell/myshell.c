#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>

void myPrint(char *msg)
{
    write(STDOUT_FILENO, msg, strlen(msg));
}

char error_message[30] = "An error has occurred\n";
char error_messagetest[31] = "XAn error has occurred\n";

int main(int argc, char *argv[]) 
{
    char cmd_buff[514];
    char *pinput;
    FILE *fp;
    int batch = 0;
    if(argc == 2){
        fp = fopen(argv[1], "r");
        if(fp == NULL){
            myPrint(error_message);
            exit(0);
        }
        batch = 1;
    }
    if(argc > 2){
        myPrint(error_message);
        exit(0);
    }
    if(batch == 0)
        fp = stdin;
    //for batch file check argc number
    while (1) {
        if(batch == 0){
            myPrint("myshell> ");
        }
        pinput = fgets(cmd_buff, 514, fp);
        if (!pinput) {
            exit(0);
        }
        char* tok;
        int i, j;
        char* commands[514];
        char* onecommand[514];
        int toolong = 0;
        if ((strstr(pinput, "\n")) == NULL){
            toolong = 1;
            myPrint(pinput);
            while((strstr(pinput, "\n")) == NULL){
                pinput = fgets(cmd_buff, 514, fp);
                myPrint(pinput);
            }
            myPrint(error_message);
        }
        if(toolong == 1){
            continue;
        }
        if(batch == 1){
            char* token = strdup(pinput);
            token = strtok(token, " \t\n");
            if(token == NULL){
                continue;
            }
            myPrint(pinput);
        }
        //separate all the commands by semicolon
        for(i = 0, tok = strtok(pinput, ";\n"); 
            tok != NULL; 
            tok = strtok(NULL, ";\n"), i++){
                commands[i] = tok;
        }
        /*while((strstr(commands, "\n")) == NULL){
            buff = buff*2;
            commands[buff];
            for(i = 0, tok = strtok(pinput, ";\n"); 
                tok != NULL; 
                tok = strtok(NULL, ";\n"), i++){
                    commands[i] = tok;
            }
            toolong = 1;
        }*/
        j = i;
        //parse the individual arguments of each command and perform
        //their duties one command at a time before moving onto the next
        for(i = 0; i < j; i++){
            if(commands[i] != NULL){
                char temp[514];
                strcpy(temp, commands[i]);
                tok = strtok(temp, " \t");
                if(tok == NULL){
                    //myPrint(error_message);
                    continue;
                }
                int redirect = 0;
                temp = strstr(commands[i], ">");
                if (temp != NULL){
                    redirect = 1;
                    char* output = temp;

                }
                tok = strtok(commands[i], " \n\t");
                onecommand[0] = tok;
                int k = 1;
                while(tok != NULL){
                    tok = strtok(NULL, " \n\t");
                    onecommand[k] = tok;
                    k++;
                }
                /*k = 0;
                int redirect = 2;
                tok = onecommand[0];
                while(tok != NULL){
                    tok = onecommand[k]
                    
                }*/
                //myPrint(onecommand[1]);
                //char* ex = "exit";
                //char* cd = "cd";
                //char* pwd = "pwd";
                if ((strcmp(onecommand[0], "exit")) == 0){
                    if (onecommand[1] != NULL){
                        myPrint(error_message);
                        continue;
                    }
                    exit(0);
                }
                if ((strcmp(onecommand[0], "cd")) == 0){
                    int success;
                    if (onecommand[2] != NULL){
                        myPrint(error_message);
                        continue;
                    }
                    if (onecommand[1] != NULL){
                        success = chdir(onecommand[1]);
                        if(success == -1){
                            myPrint(error_message);
                            continue;
                        }
                        continue;
                    }
                    else{
                        chdir((getenv("HOME")));
                        continue;
                    }
                }
                if ((strcmp(onecommand[0], "pwd")) == 0){
                    if (onecommand[1] != NULL){
                        myPrint(error_message);
                        continue;
                    }
                    char curdirec[514];
                    //curdirec = getcwd(curdirec, 514);
                    myPrint(getcwd(curdirec, 514));
                    myPrint("\n");
                    continue;
                }
                else{
                    pid_t forkret = 0;
                    int reterr = 0;
                    int status;
                    if((forkret = fork()) == 0){
                        reterr = execvp(onecommand[0], onecommand);
                        if (reterr == -1){
                            myPrint(error_message);
                            exit(0);
                        }
                        exit(0);
                    }
                    else{
                        waitpid(forkret, &status, 0);
                        continue;
                    }
                }
            }
            else{
                break;
            }
            //check onecommand[0] for what it is then perform
            //the appropriate thing
        }
        //myPrint(cmd_buff);
    }
}
