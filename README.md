# Distributed-N-Queen
The purpose of this project is to evaluate the practicality of the concept presented in the paper that has been submitted to the Journal of Expert Systems With Applications. We appreciate your contribution to this field and look forward to exploring this idea further. The project aims to represent the chessboard as a graph and split it into a network of nodes. The maximum cliques computed from this representation could potentially provide a solution to the n-queen problem. This approach considers multiple perspectives and could be worth exploring further.
The paper's main idea is based on the notion of configuration. There are two types of configurations: enabled configurations, which can be split, and terminal configurations, which cannot. The presented distributed algorithm is based on refinement. The refinement method in our distribution strategy involves breaking down a configuration into smaller ones, which are then further decomposed until reaching a stage where a solution is found, and we can no longer decompose any further.

let us assume that we have 3 workstation at the initial state we will have :

![partition 0](https://github.com/bzine19766/Distributed-N-Queen/assets/122158226/edf9c424-6474-47cb-938e-32b170c5d752)

after that, the configuration s0 will be split into two configurations s1 and s2 and each configuration will be sent to the right machine based on hashing function h 

![partition 1](https://github.com/bzine19766/Distributed-N-Queen/assets/122158226/731842b6-ba87-4863-9024-f8a4ce7121b8)



in this situation, we will have two workstations calculating in parallel 

![partition 1](https://github.com/bzine19766/Distributed-N-Queen/assets/122158226/054f6deb-ad70-4aac-901a-8a4bf49b101d)


after that s1 will be divided into s3 and s4 like this 

![partition 2](https://github.com/bzine19766/Distributed-N-Queen/assets/122158226/e263b716-f865-48eb-be7d-942478a2d8f7)


after that, we will have s2 split into s5 and s6 like this where will have three workstations working in parallel and the process continue until finding a solution.


![partition 3](https://github.com/bzine19766/Distributed-N-Queen/assets/122158226/ab5e497b-1b12-46c8-bdbf-87b7b894cf01)











Download and install the Erlang programming language 



It could be assumed that the working directory is located at E:/work.


Open the Erlang shell and enter the following command:


**cd("e:/work").**


Let's say we want to solve the 4-queen problem. type in Erlang shell


**c(codinglist).**


**Refvec=codinglist:coding_list(4).**


 **c(library).**

 
 **S0=library:getInitialConf(Refvec).**

 
you got 


**<<0,0,255,255>>**


To see a configuration as described in the paper type :


**library: split_Conf(S0,Refvec)**


you got :


**{0,65535}**


if you want to see a configuration as list type :


**library: displayOfConf(S0,Refvec).**


you got :


{[],
 [34856,33300,135300,131361,10308,1048,1153,132162,17444, 20552,8328,16658,67714,8209,66113,8738]}

  

for choosing an element for refinement type :


**library:choose(0,65535,Refvec).**


you got :


34856


we draw attention, that 0 represents the first component of configuration and 65535 represents the second component of configuration.
To split a configuration into two configuration types:


**{S1,S2}=library:split(S0, Refvec).**


you got :


**{<<32,0,40,93>>,<<32,0,223,255>>}**


To know the own of a configuration you need to hash the second part of this configuration as fellow:


**c(testhash).**


if we assume that the number of workstations is 3 :


**I0=testhash:h(S0,3,Refvec).**


you got :


**1**


**I1=testhash:h(S1,3,Refvec).**


you got:


**1**


**I2=testhash:h(S2,3,Refvec).**


you got :


**0**


That's enough for configuration; now let's move to the sequential program.
type in the Erlang shell :



**c(seqalgo).**



**Refvec=codinglist:coding_list(4).**


**S0=library:getInitialConf(Refvec).**


Go to the code of the library  delete exactly "io:format("e=~w~n",[E])," from the split function save and compile library as follow:


**c(library).**


type the command :


**A4=seqalgo:generate(Refvec,[S0],[]).**


you got :


**[<<97,130,65,130>>,<<40,20,40,20>>]**


To count the number of solution types:


**length(A4).**


you got :


**2**


To display a solution on the chessboard type :


**library:displayOnChess(<<97,130,65,130>>,Refvec).**

![cliqueof4solution](https://github.com/bzine19766/Distributed-N-Queen/assets/122158226/0469b460-b5d4-49c7-8969-33a7acf37708)



you got :


**[8,1,14,7]**


To test the solution for  different chessboards for example 8-queen type:


**Refvec8=codinglist:coding_list(8).**


**S8=library:getInitialConf(Refvec8).**


**A8=seqalgo:generate(Refvec8,[S8],[])**


**length(A8).**


you got :


**92**


To test the running in microsecond  time just type :


**timer:tc(seqalgo,generate,[Refvec8,[S8],[]]).**


 for example, it depends on the computer you have:

 
 {7721992,

 
 [<<205,30,114,179,47,13,119,23,4,16,2,128,32,8,64,1>>,

 
...........}




7721992 is the time in microseconds dividing this time by 1000000 you get the time in seconds
is around 8 seconds as described in the paper in the graph of timing. We would like to point out that the current method for estimating runtime is incorrect. For instance, in the case of the 4-queen problem, the reported runtime of 0 seconds is inaccurate. Therefore, in order to estimate the runtime accurately, we should calculate the mean of multiple runtimes, up to 100 runs, resulting in an average of 4 milliseconds.



That's enough for the sequential algorithm based on the notion of configuration. We move on to the load balancing and test the performance of the hashing function.



We would like to point out that the concept of configuration in its basic form is similar to a Marking in Petri Nets, so at this time, we do not require a distributed algorithm to test the performance of the hash function. We can test it locally as follows:



for example, for the 7-queens we have :



**Refvec7=codinglist:coding_list(7).**


**S7= library:getInitialConf(Refvec7).** 


**A7 = testhash:allConfiguration(Refvec7,[S7],[]).**


**Totalconf7=length(A7).**


you got :


33886 configurations 


if we assume that we have 10 machine type:


** N7= testhash:numOfConfByMachines(10,Refvec7,A7).** 

 
 you got :

 
["379","339","398","417","402","385","351","422","389", "404"]


This is the distribution for the configurations over machines.


![7-queenshisto](https://github.com/bzine19766/Distributed-N-Queen/assets/122158226/5ff7db7d-0ca6-4e8f-b1dc-e59c08340780)




Now you need to install anaconda3 which has Jupiter for Python language to draw the graphs above.
Take a look at The Jupyter notebook ExpertSystem.ipynb.


For the algorithm distributor, we are currently in the debugging stage of the distributed termination detection. The current form of the distributor is only for testing purposes. We have the 'generate(I)' function which runs sequentially for each machine, alternating between them. This is for testing the termination detection, which currently only works for N=4 and M=3. Here, N represents the number of queens and M represents the number of machines. Once we fix the bugs in the distributed termination detection, we will move to the true parallel version of the distributor. To test this version, simply type  into the shell:



c(distributor).


distributor:startAll().


distributor:generate(1).


you got :

![execution](https://github.com/bzine19766/Distributed-N-Queen/assets/122158226/49da70f0-3e57-45b8-a017-fbeaf73354d4)

As shown in the picture above, the number of messages sent is equal to 28 and the number of messages received is also 28. Therefore, we are in the state of distributed Termination Detection. The algorithm prints the total solution, which is equal to 2. Machine number 1 owns one terminal configuration representing one solution, and machine 2 owns the other terminal configuration. It should be noted that the algorithm is currently stuck when N is not equal to 4 and M is not equal to 3. We will address this issue shortly.



Additionally, it should be noted that the running time of the distributor is currently longer than that of the sequential algorithm. This is because we are currently only testing the distributed termination detection and have not yet fully parallelized our algorithm.

**Kneser Representation**


From definition 1 in the paper we can conclude that a Kneser representation for a graph is the solution to a 2-SAT problem, where there is a solution only if m >= n. m represents the number of bits used to encode a vertex in the graph and n represents the number of vertices in the graph. we note that an encoding of vertex v represents its relationship with all other vertices in the graph.
We have that vi is adjacent to vj if and only if encoding(vi)&encoding(vj)=0 where & is the bitwise and operation.


For the sake of simplicity, we will do this exercise. See if you can find the Kneser representation for the graph below.

![Graph](https://github.com/bzine19766/Distributed-N-Queen/assets/122158226/4567690e-9a5b-4348-b061-7d1afed69895)

because we have 4-vertices in the graph our encoding may be on 4 bits as follows:

![Kneser1](https://github.com/bzine19766/Distributed-N-Queen/assets/122158226/77bc6835-7ca8-4006-afca-17d3a99229be)

so we have :

![Kneser2](https://github.com/bzine19766/Distributed-N-Queen/assets/122158226/70320fe3-bd53-49fd-b7a7-7c6cfa89f4a0)

![kneser3](https://github.com/bzine19766/Distributed-N-Queen/assets/122158226/8104a43e-43b5-4d6f-9a06-14d55d899690)












  




