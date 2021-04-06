bits 32

global start        

extern exit, printf, scanf         
import exit msvcrt.dll    
import printf msvcrt.dll    
import scanf msvcrt.dll     
                          
segment data use32 class=data

    
    startmeniu db `MENU \n`,0
    op1 db `Play New Game (p) \n`, 0
    op2 db `Quit (q) \n`, 0
    ind db `Choose?\n`,0
    mplayer1 db `Player 1-please enter 3 numbers! \n`,0
    mplayer2 db `Player 2-please guess the numbers!\n`,0
    format db `%d strike(s) and %d ball(s) \n`, 0
    mcontinue db `Type 3 numbers: \n`,0
    msjrezultat db `It takes %d times\n`, 0
    strikeout db ` Strike out!! \n`,0
    
    choice dd 0
    ;number set 1
    nr1 dd 0
    nr2 dd 0
    nr3 dd 0
    ;number set 2
    n1 dd 0
    n2 dd 0
    n3 dd 0
    
    ct dd 0 ;number of required tries
    trei dd 3
    strikes dd 0 ;number of strikes
    balls dd 0   ; number of balls
    formatchoice  db "%s", 0  
    formatsetnr1 db "%d",0

    
segment code use32 class=code
    start:
        
        MOV dword[strikes], 0
        MOV dword[balls],0
        MOV dword[trei], 3
        MOV dword[ct],0
        
        MOV ECX, 2
        ;Game start
        Begin:
        
            ;display main menu
            push dword startmeniu  
            call [printf]      
            add esp, 4*1 
            
            push dword op1  
            call [printf]      
            add esp, 4*1 
            
            push dword op2  
            call [printf]      
            add esp, 4*1 
            
            push dword ind  
            call [printf]      
            add esp, 4*1 
            
  
            push dword choice       ; p or q 
            push dword formatchoice   
            call [scanf]       ; scanf function used for reading input
            add esp, 4 * 2     
                    
            MOV EBX, 0
            MOV EBX, 'q'
            CMP dword[choice], EBX  ; q=exit game
            JZ exitmeniu
            MOV ECX, 2
            
            push dword mplayer1 
            call [printf]      
            add esp, 4*1 
            
            ; the first player writes his numbers 
            push dword nr1 
            push dword formatsetnr1 
            call [scanf]       
            add esp, 4 * 2
            
            push dword nr2 
            push dword formatsetnr1 
            call [scanf]       
            add esp, 4 * 2
            
            push dword nr3 
            push dword formatsetnr1 
            call [scanf]       
            add esp, 4 * 2
            
            
            push dword mplayer2 
            call [printf]      
            add esp, 4*1 
            ;the curent number of tries, strikes and balls is set to 0
            MOV ECX, 2
            MOV dword[strikes], 0
            MOV dword[balls],0
            MOV dword[ct],0 ; number tries
            
            ;Rounds of tries
            Game:
                ADD dword[ct], 1
                
                push dword mcontinue
                call [printf]      
                add esp, 4*1 
                
                ; the second player writes the guess numbers
                push dword n1 
                push dword formatsetnr1 
                call [scanf]       
                add esp, 4 * 2
                
                push dword n2 
                push dword formatsetnr1 
                call [scanf]       
                add esp, 4 * 2
                
                
                push dword n3 
                push dword formatsetnr1 
                call [scanf]       
                add esp, 4 * 2
                
                
                ; we compare the numbers on the same position and we increment strikes if there is a match 
                
                ; Checking the 3-rd number
                MOV EBX, 0
                MOV EBX, [n3]
                CMP EBX, [nr3]
                JZ count
                CMP EBX, [nr2]
                JZ countballs1
                CMP EBX, [nr1]
                JZ countballs1
                jmp pas2
                countballs1:
                INC dword[balls] ; we increment balls if a number is guessed, but on the wrong position
                jmp pas2
                
                count: 
                INC dword[strikes] ; we increment strikes if a number is guessed on the right position
                jmp pas2
                
                
                ; Checking the 2-nd number
                pas2:
                MOV EBX,0
                MOV EBX, [n2]
                CMP EBX, [nr2]
                JZ count2
                CMP EBX, [nr1]
                JZ countballs2
                CMP EBX, [nr3]
                JZ countballs2
                jmp pas3
                
                
                countballs2:
                INC dword[balls]
                jmp pas3
                count2:
                INC dword[strikes]
                jmp pas3
                
                
                ; Checking the 1-st number
                pas3:
                MOV EBX,0
                MOV EBX, [n1]
                CMP EBX, [nr1]
                JZ count3
                CMP EBX, [nr2]
                JZ countballs3
                CMP EBX, [nr3]
                JZ countballs3
                jmp pas4
                countballs3:
                INC dword[balls]
                jmp pas4
                count3:
                INC dword[strikes]
                jmp pas4
                
                
                pas4:
                MOV EBX, 0
                MOV EBX, dword[strikes]
                CMP EBX, dword[trei]     ; Checking if we have a full match (strikes=3)
                JZ gata ; if they were guessed, we exit the rounds
                
               
                
                ; Displaying the number of strikes and balls
                push dword [balls]
                push dword [strikes]
                push format
                call[printf]
                add esp, 4*3
                
                ; setting strikes and balls on 0 for the next try
                MOV ECX, 2
                MOV dword[strikes],0
                MOV dword[balls],0
                jmp Game
        gata:
        ; The number were guessed
        push dword strikeout
        call [printf]
        add esp, 4*1
        
        push dword [ct]
        push dword msjrezultat  ; displaying the required number of tries
        call [printf]      
        add esp, 4*2
        jmp Begin ;Going back to the main menu
        
        ; when choosing 'q', we exit the game 
        exitmeniu:
             
 
        
        push dword 0     
        call [exit]      