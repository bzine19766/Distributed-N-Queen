# Distributed-N-Queen
The purpose of this project is to evaluate the practicality of the concept presented in the paper that has been submitted to the Journal of Expert Systems With Applications. We appreciate your contribution to this field and look forward to exploring this idea further. The project aims to represent the chessboard as a graph and split it into a network of nodes. The maximum cliques computed from this representation could potentially provide a solution to the n-queen problem. This approach considers multiple perspectives and could be worth exploring further.
The paper's main idea is based on the notion of configuration. There are two types of configurations: enabled configurations, which can be split, and terminal configurations, which cannot. The presented distributed algorithm is based on refinement. The refinement method in our distribution strategy involves breaking down a configuration into smaller ones, which are then further decomposed until reaching a stage where a solution is found, and we can no longer decompose any further.
It could be assumed that the working directory is located at E:/work.


Open the Erlang shell and enter the following command:


cd("e:/work").


Let's say we want to solve the 4-queen problem. type in Erlang shell


c(codinglist).


Refvec=codinglist:coding_list(4).


 c(library).

 
 S0=library:getInitialConf(Refvec).

 
you got 


<<0,0,255,255>>


To see a configuration as described in the paper type :


library: split_Conf(S0,Refvec)


you got :


{0,65535}


if you want to see a configuration as list type :


library: displayOfConf(S0,Refvec).


you got :


{[],
 [34856,33300,135300,131361,10308,1048,1153,132162,17444,
  20552,8328,16658,67714,8209,66113,8738]}

  

for choosing an element for refinement type :


library:choose(0,65535,Refvec).


you got :


34856


we draw attention, that 0 represents the first component of configuration and 65535 represents the second component of configuration.
To split a configuration into two configuration types:


{S1,S2}=library:split(S0, Refvec).


you got :


{<<32,0,40,93>>,<<32,0,223,255>>}


To know the own of a configuration you need to hash the second part of this configuration as fellow:


c(testhash).


if we assume that the number of workstations is 3 :


I0=testhash:h(S0,3,Refvec).


you got :


1


I1=testhash:h(S1,3,Refvec).


you got:


1


I2=testhash:h(S2,3,Refvec).


you got :


0


That's enough for configuration; now let's move to the sequential program.
type in the Erlang shell :



c(seqalgo).



Refvec=codinglist:coding_list(4).


S0=library:getInitialConf(Refvec).


go to the code of the library  delete exactly "io:format("e=~w~n",[E])," save and compile library as follow:


c(library).


type the command :


A4=seqalgo:generate(Refvec,[S0],[]).


you got :


[<<97,130,65,130>>,<<40,20,40,20>>]


To count the number of solution types:


length(A4).


you got :


2


To display a solution on the chessboard type :


library:displayOnChess(<<97,130,65,130>>,Refvec).


you got :


[8,1,14,7]


To test the solution for  different chessboards for example 8-queen type:


Refvec8=codinglist:coding_list(8).


S8=library:getInitialConf(Refvec8).


A8=seqalgo:generate(Refvec8,[S8],[])


length(A8).


you got :


92


To test the running in microsecond  time just type :


timer:tc(seqalgo,generate,[Refvec8,[S8],[]]).


 for example, it depends on the computer you have:

 
 {7721992,

 
 [<<205,30,114,179,47,13,119,23,4,16,2,128,32,8,64,1>>,

 
...........}




7721992 is the time in microseconds dividing this time 1000000 you get the time in seconds
is around 8 seconds as described in the paper in the graph of timing.



That's enough for the sequential algorithm based on the notion of configuration. We move on to the load balancing and test the performance of the hashing function.



We would like to point out that the concept of configuration in its basic form is similar to a Marking in Petri Nets, so at this time, we do not require a distributed algorithm to test the performance of the hash function. We can test it locally as follows:



for example, for the 7-queens we have :



Refvec7=codinglist:coding_list(7).


S7= library:getInitialConf(Refvec7). 


A7 = testhash:allConfiguration(Refvec7,[S7],[]).


Totalconf7=length(A7).


you got :


33886 configurations 


if we assume that we have 10 machine type:


 N7= testhash:numOfConfByMachines(10,Refvec7,A7). 

 
 you got :

 
["379","339","398","417","402","385","351","422","389", "404"]


This is the distribution for the configurations over machines.


Now you need to install anaconda3 which has Jupiter for Python language to draw the graphs on the paper.











  




