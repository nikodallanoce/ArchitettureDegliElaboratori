# Niko Dalla Noce - niko.dalla@stud.unifi.it 
# Alberto Giglioli - alberto.giglioli@stud.unifi.it
# Gabriele Vallario - gabriele.vallario@stud.unifi.it
# Data di consegna

.data
richiestaIntero: .asciiz "Inserisci numero: \n"
acapo: .asciiz "\n"
ritorno: .asciiz "f: return "
risultato: .asciiz "G: return "
overflow: .asciiz "Overflow "
effe: .asciiz "F: "
freccia: .asciiz " -> "

.text 
.globl main

main: 
         li $v0, 4
         la $a0, richiestaIntero
         syscall
         
         li $v0, 5
         syscall
         
         move $s5, $v0   # il numero inserito è in $a0
         add $s5, $s5 , 1
         

G:       
         li $s4, 0      # b=0
         li $s3, 1      # u=1
         
                  
for:     
         
         beq $s1, $s5, esci         
         move $s0 , $s1
         
         la $a0, effe
         li $v0, 4
         syscall
         
         move $a0, $s1
         li $v0, 1
         syscall
         
         la $a0, freccia
         li $v0, 4
         syscall
         
         jal F
         mul $s4, $s4, $s4    # b al quadrato
         mfhi $s7
         bnez $s7, over
         add $s4, $s4, $v0    # b^2 + u
         
         
         move $t1, $v0         
         
         la $a0, ritorno
         li $v0, 4
         syscall
                 
         move $a0, $t1
         li $v0, 1
         syscall
         
         la $a0, freccia
         li $v0, 4
         syscall
         
        
         move $v0, $t1
         
         addi $s1, $s1, 1
         j for

F:       
        
         bnez $s0, nonCasoBase        
         li $v0, 1
         
         move $t1, $v0         
         
         la $a0, ritorno
         li $v0, 4
         syscall
                 
         move $a0, $t1
         li $v0, 1
         syscall
         
         la $a0, freccia
         li $v0, 4
         syscall
          move $v0, $t1   
                 
         jr $ra
         
        
         
nonCasoBase: 
         
         
         addi $sp, $sp, -8  #abbasso lo stack pointer di 2 word
         sw $s0, 0($sp)     # salvo la n di f(n)
         sw $ra, 4($sp)     # salvo l'indirizzo da dove sono venuto
         sub $s0, $s0, 1   # n-1
         
         move $t1, $v0
         la $a0, effe
         li $v0, 4
         syscall
         
         move $a0, $s0
         li $v0, 1
         syscall  
         
         la $a0, freccia
         li $v0, 4
         syscall
         
         move $v0, $t1   
         
            
         jal F
         
         lw $s0, 0($sp) #Riprendo $s0 dallo stack 
         lw $ra, 4($sp) #Riprendo il punto da cui sono venuto. 
         addi $sp, $sp, 8 #Libero le due word dallo stack        
        
         mul $v0, $v0, 2   #moltiplico per 2 la chiamata precedente
                  
         add $v0, $v0, $s0 #faccio la somma n * $v0 e salvo il risultato in $v0 
         jr $ra            #torno da dove sono venuto. 

over:
      la $a0, overflow
      li $v0, 4
      syscall 
      li $v0, 10
      syscall                                   

esci:   

         la $a0, risultato
         li $v0, 4
         syscall

        li $v0, 1
        move $a0, $s4
        syscall
        
        li $v0, 10
        syscall
