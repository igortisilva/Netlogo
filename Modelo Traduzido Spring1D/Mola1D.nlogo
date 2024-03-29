; William M. Spears September 2011
; 1D Spring Law Tutorial Code
; For research and educational use only

globals [momentolinear_total energiaCinetica_total energiaPotencial_total energia_total centro_de_massa_x
         k atrito DeltaT tamanhoMola S maxS minS]

turtles-own [vizinho distanciaAtual r F velocidade DeltaV massa energiaCinetica momentoLinear]

to setup
   clear-all
   crt 2
   atualizar-informacao
   set maxS 0 set minS 100000
   ask turtles [setup-turtles]

   set S abs(([xcor] of turtle 1) -
             ([xcor] of turtle 0))


   set centro_de_massa_x (([massa] of turtle 0) * ([xcor] of turtle 0) +
                         ([massa] of turtle 1) * ([xcor] of turtle 1)) /
                        (([massa] of turtle 0) + ([massa] of turtle 1))
   ask patch (round centro_de_massa_x) 0
      [ask patches in-radius 4 [set pcolor red]]
   reset-ticks
end

to iniciar-monitorar
   if (count turtles < 1) [user-message "Monte a simulação primeiro" stop]
   atualizar-informacao
   ask turtles [fisica-artifical]
   ask turtles [movimentar]

   set centro_de_massa_x (([massa] of turtle 0) * ([xcor] of turtle 0) +
                         ([massa] of turtle 1) * ([xcor] of turtle 1)) /
                        (([massa] of turtle 0) + ([massa] of turtle 1))
   ask patch (round centro_de_massa_x) 0
      [ask patches in-radius 4 [set pcolor red]]

   if (S > maxS) [set maxS S]
   if (S < minS) [set minS S]

   set momentolinear_total sum [momentoLinear] of turtles
   set energiaCinetica_total sum [energiaCinetica] of turtles
   set energiaPotencial_total (k * (S - tamanhoMola) * (S - tamanhoMola) / 2)
   set energia_total (energiaCinetica_total + energiaPotencial_total)
   tick
   montar-grafico
end

to setup-turtles
   set color white
   home
   set shape "circle" set size 5

   ifelse (who = 0)
      [set massa 1
       set heading 90
       fd (1 + random (tamanhoMola / 2))]
      [set massa Massa_
       set heading 270
       fd (1 + random (tamanhoMola / 2))]
end

to fisica-artifical
   set velocidade (1 - atrito) * velocidade

   set vizinho [who] of other turtles
   foreach vizinho [ ?1 ->
      set distanciaAtual (([xcor] of turtle ?1) - xcor)
      set r abs(distanciaAtual)
      set S r
      ifelse (distanciaAtual > 0)
         [set F (k * (r - tamanhoMola))]
         [set F (k * (tamanhoMola - r))]
   ]
   set DeltaV DeltaT * (F / massa)
   set velocidade  (velocidade + DeltaV)
   set distanciaAtual DeltaT * velocidade
end

to movimentar
   set xcor (xcor + distanciaAtual)
   set energiaCinetica (velocidade * velocidade * massa / 2)
   set momentoLinear (massa * velocidade)
end

to atualizar-informacao
   set k Constante_Elastica
   set atrito Atrito_
   set DeltaT Tempo_
   set tamanhoMola Tamanho_Mola
end

to montar-grafico
   set-current-plot "Energia"
   set-current-plot-pen "Total"
   plot energia_total
   set-current-plot-pen "Potencial"
   plot energiaPotencial_total
   set-current-plot-pen "Cinetica"
   plot energiaCinetica_total

   set-current-plot "Separacao"
   set-plot-y-range precision (minS - 1) 0
                    precision (maxS + 1) 0
   set-current-plot-pen "Sep"
   plot S
end
@#$#@#$#@
GRAPHICS-WINDOW
316
10
725
420
-1
-1
1.0
1
10
1
1
1
0
1
1
1
-200
200
-200
200
1
1
1
ticks
30.0

BUTTON
25
15
153
48
Montar Simulação
setup
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

BUTTON
159
14
283
48
Iniciar
iniciar-monitorar
T
1
T
OBSERVER
NIL
M
NIL
NIL
1

SLIDER
10
67
287
100
Massa_
Massa_
1
10
1.0
1
1
NIL
HORIZONTAL

SLIDER
11
113
286
146
Constante_Elastica
Constante_Elastica
1
10
1.0
1
1
NIL
HORIZONTAL

SLIDER
12
159
287
192
Atrito_
Atrito_
0
0.01
0.0
0.001
1
NIL
HORIZONTAL

SLIDER
12
204
287
237
Tempo_
Tempo_
0.001
0.01
0.001
0.001
1
NIL
HORIZONTAL

SLIDER
12
246
287
279
Tamanho_Mola
Tamanho_Mola
2
100
81.0
1
1
NIL
HORIZONTAL

PLOT
18
454
382
640
Energia
Tempo
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Total" 1.0 0 -6459832 true "" ""
"Potencial" 1.0 0 -13345367 true "" ""
"Cinetica" 1.0 0 -10899396 true "" ""

PLOT
403
455
724
639
Separacao
Tempo
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"sep" 1.0 0 -2674135 true "" ""

MONITOR
17
395
148
440
Momento Linear
momentolinear_total
10
1
11

MONITOR
154
394
305
439
Separação das particulas
S
2
1
11

@#$#@#$#@
## O QUE É?

Este é um modelo de uma mola unidimensional, para o livro intitulado "Physicomimetics: Physics-Based Swarm Intelligence."

## COMO FUNCIONA

As duas partículas usam F = ma e a lei de Hooke para se mover como uma mola.

## COMO USAR

Clique em Montar Simulação para inicializar as duas partículas e clique em Iniciar para que eles se movam.

O controle deslizante Massa_ permite que você controle as massas relativas das partículas nas extremidades da mola, na inicialização. Alterar este controle deslizante enquanto a simulação está em execução não terá efeito. 

Todos os outros controles deslizantes afetarão a simulação enquanto estiver em execução.

## PONTOS PARA OBSERVAR

Esta simulação serve para ensinar um modelo simples de uma mola, bem como apresentar conceitos mais avançados, como a Conservação do Momento Linear e a Conservação de Energia. Isso é abordado em detalhes no Capítulo 2 do livro.

Observe como aumentar o Tempo_ introduz variações muito suaves no gráfico de Conservação de Energia. A energia total é mostrada em marrom, a energia cinética em verde e a energia potencial em azul. A energia total permanece relativamente constante, embora haja uma troca constante entre a energia potencial e a cinética. Observe a simulação - quando a energia cinética está alta? Quando a energia potencial está alta?

O que acontece quando o Atrito_ aumenta de 0.000 para 0.001? Para onde foi a energia?

O ponto vermelho na simulação mostra o centro de massa do sistema. Se a Conservação do Momento Linear for mantida, o ponto vermelho não se moverá. Nesta simulação, se uma das partículas cruzar a fronteira do mundo (reentrando pelo outro lado), o centro de massa mudará porque a suposição da física padrão de uma geometria euclidiana foi quebrada (conforme explicado no Capítulo 2) .

O painel gráfico no NetLogo é toroidal. Isso significa que quando um agente de partículas sai do painel para o Norte (Sul), ele entra novamente pelo Sul (Norte). Da mesma forma, quando uma partícula se move para fora do painel para o leste (oeste), ela entra novamente pelo oeste (leste). No entanto, a física newtoniana assume a geometria euclidiana. Portanto, usamos molas curtas para garantir que nenhuma das partículas cruze a borda.

O mundo toroidal é o padrão do NetLogo, mas pode ser alterado - veja em http://ccl.northwestern.edu/netlogo/docs/programming.html#topology

## COISAS PARA TENTAR

Veja como o Constante_Elastica muda o comportamento. 

O que acontece quando você usa a mola com Atrito_?

O que acontece se você tornar uma das partículas mais pesada movendo o controle deslizante Massa_(isso deve ser feito antes de clicar em Montar Simulação)?

Edite Tamanho_Mola para um valor grande, como 500. O que acontece? Consulte o Capítulo 2 para obter detalhes.

## EXPANDINDO O MODELO

Atualmente, o controle deslizante Massa_ é usado apenas durante a inicialização de uma das partículas. Modifique o código para monitorar sempre este controle deslizante (dica: você pode fazer isso no procedimento "atualizar-informacao"), para que a massa da partícula 1 possa ser alterada. 

Apresente uma terceira partícula e crie uma estrutura mais complexa que contenha três molas. Use constantes de mola diferentes para as três molas. Uma maneira de fazer isso é criar inicialmente três partículas (dizendo "crt 3"): 0, 1 e 2. Em seguida, você precisará modificar "setup-turtles" para que inicialize todas as três partículas de maneira apropriada. Finalmente, o procedimento "fisica-artificial" precisa ser modificado para saber qual par de partículas está interagindo (0 e 1, 0 e 2, ou 1 e 2). Você vai querer ter um valor diferente de "k" para cada par. Se você fizer isso, qual é o comportamento do sistema?

Observe que, para alterar qualquer simulação do NetLogo, você deve ter o código-fonte (ou seja, "spring1D.nlogo") baixado para o seu computador, bem como o próprio NetLogo. Você não pode alterar o código quando estiver executando a simulação com seu navegador.

## CARACTERÍSTICAS DO NETLOGO

Como estamos usando um tamanho de patch de um, queríamos que as partículas fossem mais visíveis. Isso é feito com "definir tamanho 5" no código. No entanto, ainda são consideradas partículas pontuais (sem tamanho) na simulação.

Observe também como o procedimento "montar-grafico" desenha o gráfico de energia e o gráfico de separação.

O NetLogo fornece comandos integrados para modelar molas, mas para os objetivos deste livro é melhor ver como uma mola funciona a partir dos primeiros princípios. Na verdade, um dos conceitos centrais deste livro é que quanto melhor compreendermos os primeiros princípios, mais elegantes serão nossas soluções.

## MODELOS RELACIONADOS

Esta é nossa primeira simulação. Ele será generalizado cada vez mais ao longo do livro.

## CRÉDITOS E REFERÊNCIAS

## COMO CITAR

Se você mencionar este modelo em uma publicação acadêmica, pedimos que inclua estas citações para o próprio modelo e para o software NetLogo: 
- Spears, William M. and Spears, Diana F. (eds.) Physicomimetics: Physics-Based Swarm Intelligence, Springer-Verlag, (2011).  
- Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## COPYRIGHT NOTICE

Copyright 2011 William M. Spears. All rights reserved.

A permissão para usar, modificar ou redistribuir este modelo é concedida, desde que ambos os requisitos a seguir sejam seguidos:  
a) este aviso de direitos autorais está incluído, e  
b) este modelo não será redistribuído com fins lucrativos sem a permissão de William M. Spears. Contate William M. Spears para licenças apropriadas para redistribuição com fins lucrativos.

http://www.swarmotics.com
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
set population 200
setup
repeat 200 [ go ]
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
