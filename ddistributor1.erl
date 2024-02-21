-module(ddistributor1).
-compile(export_all).
-import(lists,[map/2,sum/1,reverse/1,filter/2,append/2]).
-import(codinglist,[coding_list/1]).
-import(library,[split/2,is_Terminal/2,getInitialConf/1,displayOfConf/2,countSetBits/1,second/2]).
-import(testhash,[h/3,allConfiguration/3,maph/3,numOfConfByMachines/3]).
-define(N,9).
-define(M,2).
-define(Nd,3).

workstation()-> [w0,w1,w2,w3,w4,w5,w6,w7,w8,w9].
nnode() -> [node0@acer,node1@acer,node2@bzine19,node3@bzine19].
nodeName(I)-> if 
                 I< 1 ->indice(0 , nnode());
                 (I < 2)and (I>0) ->  indice(2 , nnode());
                 (I < 6)and (I>3) ->  indice(2 , nnode());
                 (I < 4)and (I>2) ->  indice(3 , nnode())
                 %%I < 10 ->  indice(2 , nnode())
              end.

indice(0, [H|_]) ->
                      H;
indice(I, [_|T]) ->
                indice(I - 1, T).
procName(I)-> indice(I , workstation()).

refvec() -> coding_list(?N).

initiator(I) -> Refvec=refvec(),S0= getInitialConf(Refvec), I0=h(S0,?M,Refvec),
                if 
                      I == I0 -> true;
                      I/=I0 -> false
                end. 
registerName(I,Pid)-> rpc:call(nodeName(I),erlang, register,[procName(I),Pid]).

start(I)-> Refvec=refvec(),S0= getInitialConf(Refvec), I0=h(S0,?M,Refvec),
           if 
               I == I0 -> Pid= spawn(nodeName(I),ddistributor1, onReceive, [I,true,false,false,0,0,[S0],[]]),
                       registerName(I,Pid ),io:format("initiator=~w~n",[I0]);

               I /=  I0 -> Pid=spawn(nodeName(I),ddistributor1,onReceive, [I,false,false,false,0,0,[],[]]), registerName(I,Pid )
           end.

startAll()-> startAl(?M).
startAl(0)-> true;
startAl(M) -> start(M-1),startAl(M-1).

gen(I)-> Pid = spawn(nodeName(I),ddistributor1, generate, [I]),Pid.

generateAll() -> generateAl(?M).
generateAl(0)->  true;
generateAl(M)-> gen(M-1),generateAl(M-1).


stopAll()-> stopAl(?M).
stopAl(0)->true;
stopAl(M)-> sendStop(M-1),stopAl(M-1).



sendConf(Conf,I) -> {procName(I),nodeName(I)}!{state,Conf}.

sendRec(I,K) -> {procName(I),nodeName(I)}! {rec,K}.

sendSnd(I,K,Totalrecd) ->  {procName(I),nodeName(I)}!{snd ,K,Totalrecd}.

sendTerm(I,K) ->   {procName(I),nodeName(I)}!{term,K}.
sendStop(I)  -> {procName(I),nodeName(I)}! stop.


generate(I)-> W= procName(I),
             
             W!{self(),terminatedi},
  receive 
         
        
        {W,{I,Initiator,Terminatedi, Len}} -> if 
                                 ((not (Terminatedi)) and (Len /= 0))-> W!{self(),gen},generate(I);
                                  ((not (Terminatedi)) and (Len == 0))-> W!{self(),gen}, generate(I) ;
                                   ((Terminatedi)and(Len == 0))-> if 
                                                                               Initiator ->T2=erlang:now(), io:format("Distributed Termination Detection ~w~n",[T2]);
                                                                               not(Initiator) ->sendStop(I), ok
                                                                               end
                                                                                 
                               end
       
        
           
   end.

onReceive(I,Initiator,Terminit,Terminatedi,Nbrecdi,Nbsenti,S,T) -> 
                                receive
                                        {state,Conf} -> Nbr=Nbrecdi+1,Refvec=refvec(),B=not(is_Terminal(Conf,Refvec)),      
                                                         if 

                                                              B ->  onReceive(I,Initiator,Terminit,Terminatedi,Nbr,Nbsenti,[Conf|S],T);
                                                             not(B)-> onReceive(I,Initiator,Terminit,Terminatedi,Nbr,Nbsenti,S,[Conf|T])
                                                         end;
                                       { From,gen } -> 
                                                  case S of 
                                                      []-> if 
                                                        (Initiator and not(Terminit))-> J= (I+1) rem ?M,
                                                                                                          
                                                                                                          sendRec(J,Nbrecdi),
                                                                                                          onReceive(I,Initiator,true,Terminatedi,Nbrecdi,Nbsenti,S,T);
                                                          


                                                           not(Initiator)       -> onReceive(I,Initiator,Terminit,Terminatedi,Nbrecdi,Nbsenti,S,T);
                                                         Initiator and  Terminit       ->   onReceive(I,Initiator,Terminit,Terminatedi,Nbrecdi,Nbsenti,S,T)
                                                              
                                              end;
                                                      
                                                   
                                                       [Conf|Tl]-> Refvec=refvec(), B=not(is_Terminal(Conf,Refvec)),


                                              if 
                                                 B  -> {Rs1,Rs2}= split(Conf,Refvec),I1=h(Rs1,?M,Refvec),I2=h(Rs2,?M,Refvec),
                                                       B1= (countSetBits(second(Rs1,Refvec)) >= math:sqrt(length(Refvec))),
                                                       B2= (countSetBits(second(Rs2,Refvec)) >= math:sqrt(length(Refvec))),
                                                       
                                                                                                                      if 
                                                                                                                   (B1 and B2)    and  (I1==I)and (I2==I)  -> onReceive(I,Initiator,false,Terminatedi,Nbrecdi,Nbsenti,[Rs2|[Rs1|Tl]],T);
                                                                                                                   (B1 and B2)    and    (I1/=I) and (I2==I) -> sendConf(Rs1,I1),Nbs = Nbsenti+1,onReceive(I,Initiator,false,Terminatedi,Nbrecdi,Nbs,[Rs2|Tl],T);
                                                                                                                   (B1 and B2)    and   (I2/=I)and (I1==I) -> sendConf(Rs2,I2),Nbs = Nbsenti+1,onReceive(I,Initiator,false,Terminatedi,Nbrecdi,Nbs,[Rs1|Tl],T);
                                                                                                                   (B1 and B2)    and    (I2/=I) and (I1/=I) -> sendConf(Rs1,I1),sendConf(Rs2,I2),Nbs = Nbsenti+2,onReceive(I,Initiator,false,Terminatedi,Nbrecdi,Nbs,Tl,T);
                                                                                                                   (not(B1) and B2)    and  (I2==I)  -> onReceive(I,Initiator,false,Terminatedi,Nbrecdi,Nbsenti,[Rs2|Tl],T);
                                                                                                                   (not(B1) and B2)    and  (I2/=I)  -> sendConf(Rs2,I2),Nbs = Nbsenti+1,onReceive(I,Initiator,false,Terminatedi,Nbrecdi,Nbs,Tl,T);
                                                                                                                   (B1 and not(B2))    and  (I1==I)  -> onReceive(I,Initiator,false,Terminatedi,Nbrecdi,Nbsenti,[Rs1|Tl],T);
                                                                                                                   (B1 and not(B2))    and  (I1/=I)  -> sendConf(Rs1,I1),Nbs = Nbsenti+1,onReceive(I,Initiator,false,Terminatedi,Nbrecdi,Nbs,Tl,T);
                                                                                                                    (not(B1) and not(B2))-> onReceive(I,Initiator,false,Terminatedi,Nbrecdi,Nbsenti,Tl,T)
                                                                                                                        end;
                                                                                                                      
                                                                                                                        
                                                                                                                                 
                                                             
                                                        
                                                       
                                                                                                           
                                                            
                                                        
                                              (not(B))-> onReceive(I,Initiator,false,Terminatedi,Nbrecdi,Nbsenti,Tl,[Conf|T])
                                            end
                                               
                                         
                                      
                                                          


                                                           
                                            end;
                                            


                            {From,terminatedi} -> Card=length(S),From ! {procName(I),{I,Initiator,Terminatedi,Card}},onReceive(I,Initiator,Terminit,Terminatedi,Nbrecdi,Nbsenti,S,T) ;
                              
                            {rec,K } -> J= (I+1) rem ?M,  if 
                                                                not(Initiator) and (length(S)==0) ->
                                                                 
                                                                                     sendRec(J,Nbrecdi+K),
                                                                                     onReceive(I,Initiator,Terminit,Terminatedi,Nbrecdi,Nbsenti,S,T);
                                                                not(Initiator) and (length(S)/=0) ->  onReceive(I,Initiator,Terminit,Terminatedi,Nbrecdi,Nbsenti,S,T);
                                                                Initiator and (Terminit ) -> Totalrecd = K,sendSnd(J,Nbsenti,Totalrecd),onReceive(I,Initiator,Terminit,Terminatedi,Nbrecdi,Nbsenti,S,T);
                                                                  Initiator and not (Terminit )  -> onReceive(I,Initiator,Terminit,Terminatedi,Nbrecdi,Nbsenti,S,T)
                                               
                                                          end;
                            {snd ,K,Totalrecd}  -> J= (I+1) rem ?M,  if 
                                                                not(Initiator) ->
                                                                                     Total= K+ Nbsenti,
                                                                                     sendSnd(J,Total,Totalrecd),
                                                                                     onReceive(I,Initiator,Terminit,Terminatedi,Nbrecdi,Nbsenti,S,T);
                                                              Initiator and (Terminit and (Totalrecd ==K) ) ->  
                                                                                       Nsol = length(T),sendTerm(J,Nsol),onReceive(I,Initiator,Terminit,true,Nbrecdi,Nbsenti,S,T);
                                                              Initiator and  ((not(Terminit) )or (not (Totalrecd ==K)))       ->  onReceive(I,Initiator,false,Terminatedi,Nbrecdi,Nbsenti,S,T)
                                                              
                                               
                                                          end;
                          {term, K} -> J= (I+1) rem ?M,  if 
                                                                not(Initiator) ->    
                                                                                     Nsol= length(T), 
                                                                                     Total= Nsol+K,
                                                                                     sendTerm(J,Total),
                                                                                     onReceive(I,Initiator,Terminit,true,Nbrecdi,Nbsenti,S,T);
                                                                 Initiator -> io:format(" Total Solution=~w~n",[K])
                                                             end;
                           
                            
                             stop ->  ok           
end.



                     