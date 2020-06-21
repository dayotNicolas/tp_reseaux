# sujet 1 assembleur

ex 1:

```
org 100h


;var

var1 DB 1h
var2 DB 0h

mov ah,var1
mov al,var2
mov bh,var1
mov bl,var2

;do


not bh
not bl

and bh,al
and bl,ah

or bh,bl


ret
```

ex 2 :

```
org 100h

; additionneur
mov ah,A
mov al,B
xor ah,al

mov bh,C
and bh,ah

mov bl,C
xor bl,ah
; resultat somme
; puis calcul retenue

mov cl,B
mov ch,A
and cl,ch

or cl,bh

ret
```

ex 3 :

```
org 100h

mov ax, 3
int 10h

mov ax, 1003h
mov bx, 0
int 10h

mov ax, 0b800h
mov ds, ax

mov [02h], 'H'

mov [04h], 'e'

mov [06h], 'l'

mov [08h], 'l'

mov [0ah], 'o'

mov [0ch], ','

mov [0eh], 'W'

mov [10h], 'o'

mov [12h], 'r'

mov [14h], 'l'

mov [16h], 'd'

mov [18h], '!'

mov cx, 12
mov di, 03h

c: mov [di], 11101100b
 add di, 2
loop c

; wait for any key press:
mov ah, 0
int 16h

ret
```

ex 4 :

```

.code

;var1 DB 1h

;start:
; mov dl,var1
;boucle:
; cmp dl,0Ah
; ja fin
; mov ah,9
; inc dl
; jmp boucle
;fin:
; dec dl
; int 21h

(bon ça fonctionne pas parce que j'arrive pas à faire fonctionner mon int 21h mais pour le principe de la boucle avec jump j ai a peu prêt compris).

```
