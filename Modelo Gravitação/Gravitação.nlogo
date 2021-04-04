turtles-own
[ fx     ;; vetor força no eixo x
  fy     ;; vetor força no eixo x
  vx     ;; vetor velocidade no eixo x
  vy     ;; vetor velocidade no eixo x
  xc     ;; coordenada no eixo x (caso as particulas saiam do mundo)
  yc     ;; coordenada no eixo y  (caso as particulas saiam do mundo)
  r-sqrd ;; Quadrado da distância para o centro de massa
]

globals
[ m-xc  ;; Coordenada do click-mouse  (onde a massa ira atuar)
  m-yc  ;; Coordenada do click-mouse  (onde a massa ira atuar)
  g     ;; Constante gravitacional para diminuir a aceleração
]

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Procedimento Montar ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
to montar
  clear-all
  set g 0.5
  set-default-shape turtles "circle"
  create-turtles numero
  [
    if (not cores?)
    [ set color white ]
    set size 10
    fd (random-float (max-pxcor - 6))
    set vx 0
    set vy 0
    set xc xcor
    set yc ycor
  ]
  reset-ticks
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Procedimento em tempo de execução ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
to ativar
  if mouse-down? [
    ;; Recebe as coordenadas do mouse
    set m-xc mouse-xcor
    set m-yc mouse-ycor
    ask turtles [ gravitate ]
    enfraquecer-rastro
    tick
  ]
end

to gravitate
  atualizar-forca
  atualizar-velocidade
  atualizar-posicao
end

to atualizar-forca
  ;; Parecido com o procedimento 'distancexy', só que para um cenário infinito(Sem bordas)
  set r-sqrd (((xc - m-xc) * (xc - m-xc)) + ((yc - m-yc) * (yc - m-yc)))

  ;;Impede a divisão por zero prevents divide by zero
  ifelse (r-sqrd != 0)
  [
    ;; Calcula os componentes do vetor F usando lei do inverso do quadrado
    set fx ((cos (atan (m-yc - yc) (m-xc - xc))) * (massa / r-sqrd))
    set fy ((sin (atan (m-yc - yc) (m-xc - xc))) * (massa / r-sqrd))
  ]
  [
    ;; se r-sqrd = 0, então está na massa, portanto não há força.
    set fx 0
    set fy 0
  ]
end

to atualizar-velocidade ;; Turtle Procedure
  ;; Atualiza a velocidade de cada particula
  ;; Realizando a soma com a força e velocidade anterior
  set vx (vx + (fx * g))
  set vy (vy + (fy * g))
end

to atualizar-posicao ;; Turtle Procedure
  set xc (xc + vx)
  set yc (yc + vy)

  ifelse patch-at (xc - xcor) (yc - ycor) != nobody
  [
    setxy xc yc
    ifelse (cores?)
    [
      if (color = white)
      [ set color one-of base-colors ]
    ]
    [ set color white ]
    show-turtle
    if (taxa-desaparecimento != 100)
    [ ifelse (color = white)
      [ set pcolor red + 3 ]
      [ set pcolor color + 3 ]
    ]
  ]
  [ hide-turtle ]
end

to enfraquecer-rastro
  ask patches with [pcolor != black]
  [ ifelse (taxa-desaparecimento = 100)
    [ set pcolor black ]
    [ if (taxa-desaparecimento != 0)
      [ fade ]
    ]
  ]
end

to fade ;; Procedimento do Rastro
  let new-color pcolor - 8 * taxa-desaparecimento / 100
  ;; se new-color não está com o mesmo tom, então o rastro se torna preto
  ifelse (shade-of? pcolor new-color)
  [ set pcolor new-color ]
  [ set pcolor black ]
end


; Copyright 1998 Uri Wilensky.
; See Info tab for full copyright and license.
@#$#@#$#@
GRAPHICS-WINDOW
232
11
642
422
-1
-1
2.0
1
10
1
1
1
0
0
0
1
-100
100
-100
100
1
1
1
ticks
10.0

BUTTON
8
23
138
56
MONTAR
montar
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
9
132
209
165
numero
numero
0
100
8.0
1
1
particulas
HORIZONTAL

SLIDER
9
171
210
204
massa
massa
0.0
1000
50.0
1.0
1
NIL
HORIZONTAL

BUTTON
8
59
138
92
ATIVAR
ativar
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SWITCH
9
95
119
128
cores?
cores?
0
1
-1000

SLIDER
9
209
211
242
taxa-desaparecimento
taxa-desaparecimento
0
100
2.7
0.1
1
%
HORIZONTAL

TEXTBOX
13
268
195
408
Enquanto o botão GO estiver ativo, clique e segure com o botão esquerdo do mouse onde deseja que a força gravitacional haja.\n\n
11
0.0
0

@#$#@#$#@
## O QUE É?

Este projeto exibe o fenômeno natural expresso pela lei do inverso do quadrado. Essencialmente, este modelo mostra o que acontece quando a intensidade da força entre dois objetos varia inversamente com o quadrado da distância entre esses dois objetos.


## COMO FUNCIONA

Neste modelo, a fórmula usada para guiar o comportamento de cada objeto é a fórmula da Lei da Gravitação Universal:

>(m1 * m2 * G) / d<sup>2</sup>

Este é um modelo de 'corpo-n' de força única, onde temos um certo número de pequenas partículas e uma grande massa atuante (o ponteiro do mouse). A força é inteiramente unilateral: a grande massa não é afetada pelas partículas menores ao seu redor. E as partículas menores também não são afetadas umas pelas outras. (Observe que isso é puramente para fins de simulação. No mundo real, uma força como a gravidade atua em todos os corpos ao seu redor.)

A gravidade é o melhor exemplo dessa força. Você pode observar as partículas formarem órbitas elípticas ao redor do ponteiro do mouse ou vê-las disparar ao redor dele, semelhante a como um cometa passa pelo nosso sol. Pense nos objetos individuais como planetas ou outros corpos solares e veja como eles reagem a várias massas que se movem ou permanecem estacionárias.

## COMO USAR

Primeiro selecione o número de partículas com o controle deslizante NUMERO. Em seguida, pressione o botão MONTAR para criá-los e espalhá-los pelo mundo.

O controle deslizante MASSA define o valor da massa da força atuante. (também determina a que distâncias as partículas podem orbitar com segurança antes de serem sugadas por uma força avassaladora.)

O controle deslizante TAXA-DESAPARECIMENTO controla a porcentagem de cor que os caminhos marcados pelas partículas desbotam após cada ciclo. Portanto, em 100% não haverá nenhum caminho, pois eles desaparecem imediatamente, e em 0% os caminhos não desaparecerão de forma alguma. Com isso você pode ver as elipses e parábolas formadas por diferentes viagens de partículas.

Quando o interruptor CORES? é definido como ON, atribui cores diferentes às partículas, caso contrário, elas serão todas brancas.

Quando os controles deslizantes tiverem sido definidos para os níveis desejáveis, pressione o botão ATIVAR para iniciar a simulação. Mova o mouse para onde deseja começar e clique e segure o botão esquerdo do mouse. Isso iniciará o movimento das partículas. Se desejar parar a simulação (digamos, para alterar o valor de MASSA), solte o botão do mouse e as partículas irão parar de se mover. Você pode então alterar as configurações que desejar (exceto NUMERO DE PARTICULAS). Então, para continuar a simulação, basta colocar o mouse na janela novamente e clicar e segurar. Os objetos na janela só se moverão enquanto o botão do mouse estiver pressionado dentro da janela.

## PONTOS PARA OBSERVAR

A coisa mais importante a observar é o comportamento das partículas. Observe que, como as partículas não têm velocidade inicial própria, uma única massa de ação imóvel irá puxá-las todas para dentro. Mesmo uma massa muito pequena (MASSA ajustada para um valor pequeno) irá puxar todas as partículas. (Devido à precisão limitada além de um certo ponto, a força motriz em uma partícula pode se tornar zero.)

Mova o mouse e observe o que acontece se você movê-lo rápido ou lentamente. Sacuda-o em um único lugar ou deixe-o parado. Observe em quais padrões as partículas se enquadram. (Mantenha TAXA-DESAPARECIMENTO baixo para assistir explicitamente.)

## COISAS PARA TENTAR

Existem alguns outros parâmetros, definidos no código, que afetam o comportamento do modelo. A força que atua sobre cada partícula é multiplicada por uma constante, 'g' (outra variável global). Sinta-se à vontade para brincar com seus valores, definidos no procedimento de 'montar'. (Obviamente, o valor padrão de g para o modelo, 0,5, é muito maior do que o valor usado na Mecânica Newtoniana, 6,67e-11.)

As condições iniciais são muito importantes para um modelo como este. Tente mudar a forma como as partículas são colocadas durante o procedimento de `montar`.

Certifique-se de observar como os diferentes valores do controle deslizante MASSA impactam o modelo.

## EXPANDINDO O MODELO

Deixe as partículas começarem com uma velocidade constante ou dê a todas elas uma velocidade aleatória. Você poderia adicionar um controle deslizante que permitiria ao usuário definir as velocidades e, assim, ser capaz de comparar os efeitos de diferentes velocidades. Ou tente dar a cada partícula uma massa variável, que afeta diretamente a intensidade da força atuante sobre ela.

O modelo assume que a força é uma força atrativa (as partículas tendem a ser puxadas em sua direção). No entanto, deve ser uma mudança relativamente fácil transformar isso em uma força repulsiva. Experimente configurar o modelo com uma força repulsiva e observe o que acontece.

## CARACTERÍSTICAS DO NETLOGO 

Este modelo cria a ilusão de um plano de tamanho infinito, para melhor modelar o comportamento das partículas. Observe que, com a marcação do rastro, você pode ver a maior parte da elipse que uma partícula desenha, embora a partícula periodicamente saia dos limites. Isso é feito por meio de uma combinação dos primitivos básicos de tartaruga `hide-turtle` e `show-turtle`, quando uma partícula atinge o limite, mantendo cada tartaruga `xcor` e `ycor` como variáveis especiais de tartaruga `xc` e `yc `, e cálculos semelhantes à primitiva `distance` que usa `xc` e `yc` em vez de `xcor` e `ycor`.

Ao examinar o código, observe que os comandos tartaruga padrão como `set heading`,` fd 1` e assim por diante não são usados aqui. Tudo é feito diretamente nas coordenadas X e Y das tartarugas.

## COMO CITAR

Se você mencionar este modelo ou o software NetLogo em uma publicação, pedimos que inclua as citações abaixo.


Para este modelo:

* Wilensky, U. (1998).  NetLogo Gravitation model.  http://ccl.northwestern.edu/netlogo/models/Gravitation.  Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

Cite o software NetLogo como:

* Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## COPYRIGHT E LICENÇA DE USO

Copyright 1998 Uri Wilensky.

![CC BY-NC-SA 3.0](http://ccl.northwestern.edu/images/creativecommons/byncsa.png)

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 License.  To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.

Commercial licenses are also available. To inquire about commercial licenses, please contact Uri Wilensky at uri@northwestern.edu.

This model was created as part of the project: CONNECTED MATHEMATICS: MAKING SENSE OF COMPLEX PHENOMENA THROUGH BUILDING OBJECT-BASED PARALLEL MODELS (OBPML).  The project gratefully acknowledges the support of the National Science Foundation (Applications of Advanced Technologies Program) -- grant numbers RED #9552950 and REC #9632612.

This model was converted to NetLogo as part of the projects: PARTICIPATORY SIMULATIONS: NETWORK-BASED DESIGN FOR SYSTEMS LEARNING IN CLASSROOMS and/or INTEGRATED SIMULATION AND MODELING ENVIRONMENT. The project gratefully acknowledges the support of the National Science Foundation (REPP & ROLE programs) -- grant numbers REC #9814682 and REC-0126227. Converted from StarLogoT to NetLogo, 2002.

<!-- 1998 2002 -->
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
