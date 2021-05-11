# Niko Dalla Noce - niko.dalla@stud.unifi.it 
# Alberto Giglioli - alberto.giglioli@stud.unifi.it
# Gabriele Vallario - gabriele.vallario@stud.unifi.it
# Data di consegna

.data 

comando : .asciiz "Inserisci stringa \n"
input: .space 102
uno: .asciiz "uno "
due: .asciiz "due "
nove: .asciiz "nove "
appo: .space 101

.text 
.globl main

main: 

printRequest:

            la $a0, comando
            li $v0, 4
            syscall
    
takeInput:

      li $v0, 8
      #la $t2, str  # t2 punta ad un carattere della stringa
      la $a0, input
      li $a1, 100
      syscall
      
init:
      la $t3, appo      # t3 punta ad un carattere della stringa
      li $t1, 0             # t1 conta la lunghezza
      la $t2, input      # t2 punta ad un carattere della stringa
      lb $s1, ($t2)
      beq $s1,32, end  #se la stringa è vuota esco

addSpace: 

             lb $s1, ($t2)
             beq $s1, 10, initializeInput
             addi $t2, $t2, 1
             j addSpace            

initializeInput:  

               li $s2, 32
               sb $s2, ($t2)
               la $t2, input
                      
      
nextCh: lb $t0, ($t2)           # leggo un carattere della stringa
        sb $t0, ($t3)
        add $t3, $t3, 1
        add $t2, $t2, 1            # incremento la posizione sulla stringa
        beqz $t0, end             # se è zero ho finito (pseudoistruzione)
        bne $t0, 32, nextCh   # vedo se c'è uno spazio     
        j spaceFound
        j nextCh                     # continuo al prossimo carattere
        
spaceFound:  
           la $t4, uno           #carico l'indirizzo di uno
           la $t7, due          # carico due
           la $t1, nove        # carico nove
           la $t3, appo        #carico l'indirizzo di appo
         
           j loopUno
              


loopUno:
         lb $t5, ($t4)          #carico in $t5 il carattere da confrontare di uno
         lb $t6, ($t3)          #carico in $t6 il carattere da confrontare di appo

         li $a0, 1
         beqz $t5, print          
         bne $t5, $t6, loopDue      #appena trovo un carattere che non coincide salto al confronto 
         addi $t4,$t4, 1            #con il due, altrimenti incremento i puntatori per poter       
         addi $t3, $t3,1            #confrontare i successivi caratteri
         addi $t8, $t8, 1
         j loopUno

loopDue:  
          lb $t5, ($t7)
          lb $t6, ($t3)
          li $a0, 2
          beqz $t5, print              #loopDue esegue la solita procedura di loopUno
          bne $t5, $t6, loopNove 
          addi $t7,$t7, 1
          addi $t3, $t3,1
          addi $t8, $t8, 1
          j loopDue
          
loopNove: lb $t5, ($t1)
          lb $t6, ($t3)
          li $a0, 9
          beqz $t5, print        #loopNove esegue la solita procedura di loopUno
          bne $t5, $t6, printBo
          addi $t1,$t1, 1
          addi $t3, $t3,1  
          addi $t8, $t8, 1  
          j loopNove      
         
print: 
          bgt $t8, 5, printBo	#se $t8 è maggiore di 5 stampa ? perchè i numeri da tradurre non sono più lunghi di 4 lettere
                                #(viene contato anche lo spazio)
          li $v0, 1		#sennò stampa la traduzione 
          syscall
          la $t3, appo
          j initializeAppo	
          

printBo: 
          li $a0, 63		
          li $v0, 11
          syscall            # stampa il punto interrogativo perchè non viene riconosciuta nessuna parola
          la $t3, appo        
          j initializeAppo                                                                                                                                                                                                                                      
        
initializeAppo: 
                 
                 #sb $s3, ($t3)
                 addi $t3, $t3, 1
                 lb $t5, ($t3)                
                 beqz $t5, initAppo #ciclo finchè non trovo uno spazio, per ricominciare la procedura di codifica dei numeri
                 j initializeAppo
                 
initAppo:        
              li $t8, 0           #reinizializzazione
              la $t3, appo
              j nextCh
          
end:   
        li $v0,10     #esce
        syscall       
