# Niko Dalla Noce - niko.dalla@stud.unifi.it 
# Alberto Giglioli - alberto.giglioli@stud.unifi.it
# Gabriele Vallario - gabriele.vallario@stud.unifi.it
# Data di consegna

.data 

strNuovoComando: .asciiz "\ninserisci un nuovo comando: "
strA: .asciiz "\nInserisci un numero intero n compreso tra 0<n<5 per definire la dimensione della matrice: \n"
strBenvenuto: .asciiz "\nInserisci uno dei seguenti comandi: \n Comando a per eseguiere l'inserimento delle matrici.\n Comando b per eseguiere la somma tra le matrici create.\n Comando c per eseguiere la sottrazione tra le matrici.\n Comando d per eseguiere la moltiplicazioni tra matrici.\n Comando e per uscire dal programma.\n"
strErrore : .asciiz "\nIl comando selezionato non è accettabile.\n Riprovare altro comando.\n"
strErrore1 : .asciiz "\nIl numero inserito non è accettabile.\n Riprovare altro numero.\n"
strUscita: .asciiz "\nHai selezionato il comando e per uscire dal programma.\n"
stringaA: .asciiz "\nHai selezionato il comando a per creare le matrici\n"
stringaB: .asciiz "\nHai selezionato il comando b che esegue la somma tra le matrici\n"
stringaC: .asciiz "\nHai selezionato il comando c che esegue la sottrazione tra le matrici\n"
stringaD: .asciiz "\nHai selezionato il comando d che esegue la moltiplicazione tra le matrici\n"
stringaRis: .asciiz "Il risultato dell'operazione scelta: \n\n"
secondaMatrice: .asciiz "\n Seconda matrice"
str: .asciiz "inserisci riga "
strColonne: .asciiz "Numero colonne: "
insM1: .asciiz "\nMatrice 1\n"
insM2: .asciiz "\nMatrice 2\n"
acapo: .asciiz "\n"


.text
.globl main

main:
	                          # scelta della procedura o dell'uscita
   	  li $v0, 4               # $v0 =codice della print_string 
          la $a0, strBenvenuto    # $a0 =  indirizzo della stringa 
	  syscall                 # stampa la strBenvenuto	 

choice:

          move $s4,$s3
	  mul $s4, $s4,$s4       # numero di celle della matrice
 
# legge la scelta
          

    li $v0, 12
	  syscall
	  move $t0, $v0           # $t2=scelta a,b,c,d o e
	  li $t1, 0               # serve per andare a capo nella stampa delle matrici 

	  beq  $t0, 97, jA	      #if($t2==a) vai a ja
	  beq  $t0, 98, jB		  #if($t2==b) vai a jb
	  beq  $t0, 99, jC     	 #if($t2==c) vai a jc	
	  beq  $t0, 100, jD		 #if($t2==d) vai a jd
	  beq  $t0, 101, jE 	 #if($t2==e) vai a je

	  li $v0 , 4
	  la $a0, strErrore     #legge la stringa errore perchè non è stato inserito un comando corretto
	  syscall
	  j choice				

jA:
	 
		la $a0, stringaA     #stampa la stringa del comando a 
		li $v0, 4
		syscall
	A:
		la $a0 , strA       #stampa la richiesta di inserire un intero compreso tra 0 e 5 esclusi
		li $v0, 4 
		
		syscall

		li $v0, 5
	  	syscall           #legge un intero inserito
	  	move $s3, $v0     #e lo sposta in $s3
	  	move $s4,$s3
	  	mul $s4, $s4, $s4
	  	mul $s5, $s3, 4   # indirizzo per spostarmi alla cella della successiva riga
	  	 

	  	sle  $t2, $s3, $zero	# $t0=1 se $t1 <= 0
	  	bne  $t2, $zero, errore # errore se scelta <=0
	  	li   $t0, 5
	  	sle  $t2, $t0, $s3
	  	bne  $t2, $zero, errore  # errore se scelta >=5
	  	
	  	li $v0, 4
	  	la $a0,insM1
	  	syscall

#ho inserito il numero della grandezza della matrice ed ora la riempio 
		
allocazioneMatrice:
					mul $t4, $s3, $s3
					mul $t4, $t4, 4
					li $v0, 9          #il comando li $v0, 9 è il comando sbrk che alloca in memoria le matrici in sequenza
					move $a0, $t4
					syscall
					move $t0, $v0

					j printRequestRiga

inserimentoRiga:
				li $v0, 5
				syscall
				sw $v0, ($t0)         #inserisco il numero digitato da tastiera nella posizione $t0 
				addi $t0, $t0, 4      #incremento la posizione della matrice
				sub $t3, $t3, 1       #la sottrazione serve per vedere quante posizoni mancano da riempire
				beqz $t3, printRequestRiga      #se $t3 arriva a 0 salta alla stampa di una nuova riga 
				j inserimentoRiga

printRequestRiga:
				 beq $s3, $s0, save  #controllo il numero di righe da inserire
				 li $v0, 4
				 la $a0, str
				 syscall

				 li $v0, 1
				 addi $s0, $s0, 1       
				 move $a0, $s0               
                 syscall
                 
                 li $v0, 4
                 la $a0, acapo      #stampo \n per scrivere il numero seguente a capo
                 syscall
                 
                 move $t3, $s3
                 j inserimentoRiga 

save:           
                            
                 li $s0, 0
                 addi $t5, $t5, 1           #il metodo save serve per decidere quale delle due matrici devo salvare nei registri
                 
                 beq $t5, 1, indirizzoM1      
               
                 beq $t5, 2, indirizzoM2 
                 j allocazioneMatrice  
                                                                                                                                            
indirizzoM1:    
                  li $v0, 4                   #questo metodo serve per salvare la matrice numero 1 tutta riempita in $s1
	  	            la $a0, insM2
	  	            syscall
                  
                  mul $s1, $s3, $s3
                  mul $s1, $s1, 4
                  sub $t0, $t0, $s1                                                  
                  move $s1, $t0                   
                  j allocazioneMatrice 
                  
                  
                  
indirizzoM2:     
                 
                 mul $s2, $s3, $s3          #questo metodo serve per salvare la matrice numero 2tutta riempita in $s2
                 mul $s2, $s2, 4
                 sub $t0, $t0, $s2
                 move $s2, $t0
                 li $v0, 4

altroComando:
                 
                 la $a0, strNuovoComando
                 li $v0, 4                  #in questo metodo resettiamo tutti i registri pronti per essere usati in altri comandi
                 syscall
                 li $t5, 0
                 li $t6, 0
                 li $t9, 0
                 li $t2, 0
                 move $t3,$s1         #sposto l'indirizzo della prima matrice in $t3
                 move $t4,$s2         #sposto l'indirizzo della seconda matrici in $t4

		 j choice	

jB:
		la $a0, stringaB
		li $v0, 4
		syscall
		
		la $a0, stringaRis
		li $v0, 4
		syscall
#################################################
addizione:	

                beqz $s4, altroComando
                
		            lw $t7, ($t3)  # carico primo elemento della prima matrice
                lw $t8, ($t4)  # carico primo elemento della seconda matrice
                
                
                add $t7, $t7, $t8     #sommo il primo elemento con il secondo elemento 
                add $t3, $t3, 4       #mi sposto nella matrici numero 1 all'elemento seguente 
                add $t4, $t4, 4       #stessa procedura della riga precedente solo nella seconda matrice
                
                sub $s4, $s4, 1
                
                beq $t1, $s3, rigaDopoA
                add $t1, $t1, 1         #contatori
                move $a0, $t7
                li $v0, 1
                syscall
                
                li $a0, 32        #stampa uno spazio tra i numeri
                li $v0, 11
                syscall
                
                j addizione
                
rigaDopoA:                             
                
                li $t1, 1
                
                la $a0, acapo       #questo metodo quando arriva in fondo alla riga della matrice va a capo
                li $v0, 4           #mettendo tra ogni numero uno spazio per distanziare i numeri
                syscall   
                
                move $a0, $t7
                li $v0, 1
                syscall    
                
                li $a0, 32
                li $v0, 11
                syscall  
                          
                j addizione
                
                	

jC:
		la $a0, stringaC
		li $v0, 4
		syscall
		
		la $a0, stringaRis
		li $v0, 4
		syscall

sottrazione:	

                beqz $s4, altroComando
                
		            lw $t7, ($t3)  # carico primo elemento della prima matrice
                lw $t8, ($t4)  # carico primo elemento della seconda matrice
                
                
                sub $t7, $t7, $t8 
                add $t3, $t3, 4
                add $t4, $t4, 4
                
                sub $s4, $s4, 1
                
                  
                beq $t1, $s3, rigaDopoS  # stampo la riga successiva quando $t1 arriva in fondo alla riga della matrice
                add $t1, $t1, 1 # contatori
                move $a0, $t7
                li $v0, 1
                syscall
                
                li $a0, 32
                li $v0, 11
                syscall
                
                j sottrazione
                
rigaDopoS:                             
                
                li $t1, 1
                
                la $a0, acapo
                li $v0, 4
                syscall   
                
                move $a0, $t7 
                li $v0, 1     
                syscall   
                
                li $a0, 32
                li $v0, 11
                syscall   
                          
                j sottrazione
                	

jD:
		la $a0, stringaD
		li $v0, 4
		syscall
		
		la $a0, stringaRis       
		li $v0, 4
		syscall
		li $t5, 0
		move $t3, $s1       #salva in $t3 l'indirizzo della prima matrice
		move $t4, $s2       #salva in $t4 l'indirizzo della seconda matrice, vengono spostati in questi due registri perchè in seguito verranno incrementati
	  move $s6, $s2       #$s6 = indirizzo della colonna nella seconda matrice (usato come appoggio)
	  li $s7, 0
	        
	        
		
moltiplicazione:   
                   beq $s7, $s3, altroComando
                   lw $t7, ($t3)  # carico primo elemento della prima matrice
                   lw $t8, ($t4)  # carico primo elemento della seconda matrice
  
                   mul $t7, $t7, $t8   #moltiplicazione dell'elemento della riga della prima matrice con l'elemento della colonna della seconda matrice
                   add $t9, $t9, $t7   #$t9 sarà il risultato di una casella della matrice da stampare 
                   
                   addi $t3, $t3, 4    #incremento di una posizione nella prima matrice
                   add $t4, $t4, $s5   #mi sposto nella riga successiva nella solita colonna 
                   
                   addi $t5, $t5, 1    #contatore che indica se sono arrivato in fondo alla colonna della seconda matrice
                   
                   bne $t5, $s3, moltiplicazione     
                                      
                    
                   j colonnaDopo    #se ho finito una colonna mi sposto a quella successiva

colonnaDopo:       
                   addi $t1, $t1, 1           #contatore per sapere quando andare alla riga dopo        
                   beq $t1, $s3, rigaDopoM    
                   li $v0, 1
                   move $a0, $t9          #stampa il risultato di quella casella 
                   syscall
                   li $v0, 11
                   li $a0, 32             #$a0 in questo caso serve per spazioare il risultato
                   syscall
                   
                   li $t5, 0            #resetto il contatore delle colonne $t5 
                   addi $s6, $s6, 4       #mi sposto nella colonna successiva della seconda matrice
                   move $t4, $s6         
                   sub $t3, $t3, $s5    #torna all'inizio della riga della prima matrice
                   li $t9, 0            #resetto il regestro $t9 per il prossimo risultato 
                   
                   
                   
                   j moltiplicazione
                                                                            
rigaDopoM:         
                   
                   beq $s7, $s3, altroComando   #se ho finito di scorre la matrice richiede un nuovo comando 
                   
                   li $t5,0             #resetto il contatore delle colonne della seconda matrice
                   
                   li $v0, 1
                   move $a0, $t9       #stampa il risultato presente nel registro $t9
                   syscall
                   
                   li $v0, 11
                   la $a0, 32      
                   syscall
                   
                   li $v0, 4
                   la $a0, acapo    
                   syscall
                   
                   li $t9,0         #resetto il risultato
                   
                   li $t1, 0        #resetto il contatore per andare alla riga dopo 
                   
                   
                   
                   move $s6, $s2    #torna all'inizio della seconda matrice                          
                   
                   move $t4, $s2     #resetto l'indice per la prossima operazione 
                   addi $s7, $s7, 1  #$s7 serve per vedere se ho esaminato tutta la matrice
                   j moltiplicazione
                                      

jE:

	li $v0, 4
	la $a0 ,strUscita
	syscall

	j jExit

errore: 
      li $v0, 4  
      la $a0, strErrore1
      syscall # stampa la stringa strErrore1		
	  				  		  		  	  
      j A # ritorna alla richiesta di inserimento di un numero tra 1 e 4 
	  




jExit:
	li $v0, 10      # termina programma
    syscall    
