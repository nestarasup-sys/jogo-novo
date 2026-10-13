# Editar móveis do quarto na Godot

Abra `scenes/rooms/bedroom.tscn` e expanda `WorldSpace/Furniture` na árvore da cena.

- Selecione o móvel (por exemplo, `Bed`) na árvore e arraste no viewport para mover arte e colisão juntas.
- Selecione o filho `Visual` e arraste para reposicionar somente o desenho. Com esse nó selecionado, o Inspector também mostra `art_texture`, `art_size` e `art_offset`; esses campos editam a arte do móvel pai.
- Para adicionar uma imagem, arraste o PNG da aba `FileSystem` para `art_texture` no Inspector, ou clique no campo e escolha o recurso. A textura aparecerá no viewport do editor.
- Selecione `Footprint` para ajustar a colisão separadamente; `footprint_size` no móvel redimensiona essa forma.
- No nó do móvel, use `footprint_size` para ajustar a colisão e `display_name`/`placeholder_color` para o placeholder, quando ainda não houver imagem.

Decorações também têm `Footprint`, mas vêm com `is_solid = false`, então não bloqueiam a protagonista.

## Sheet de móveis do quarto

O sheet original está em `assets/furniture/bedroom_furniture_sheet.png`; cada móvel foi recortado para um PNG independente com fundo transparente em `assets/furniture/`. A cena já atribui essas imagens à cama, penteadeira, guarda-roupa, escrivaninha, estante, poltrona e baú. Os seis itens de decoração usam PNGs transparentes próprios: tapete, porta visual, mesa lateral, espelho, planta e quadro. O sheet original está em `assets/furniture/bedroom_decor_sheet.png`; os recortes independentes ficam em `assets/furniture/`. Eles mantêm nós `Visual` e `Footprint` separados e editáveis.

## Jeito mais fácil de mexer só na imagem

1. Abra `scenes/rooms/bedroom.tscn`.
2. Na aba **Cena**, expanda `Bedroom > WorldSpace > Furniture` e expanda o móvel desejado (por exemplo, `Plant`).
3. Clique no filho **Visual**. No viewport 2D, arraste a imagem para reposicioná-la sem mover a colisão.
4. Com **Visual** selecionado, use o **Inspector** à direita: `Art Texture` troca o PNG, `Art Size` ajusta largura e altura em pixels e `Art Offset` faz um ajuste fino.
5. Salve com **Ctrl+S**.

Para mover a imagem e sua área física juntas, selecione o móvel pai. Para editar apenas a colisão, selecione `Footprint`. Se a intenção for só ajustar a aparência, fique em **Visual**.

## Tamanhos atuais

A protagonista tem 180 px de altura visível. Os tamanhos abaixo mantêm móveis de chão próximos dessa escala e deixam o quadro de parede menor que a personagem.

| Item | Arte (px) | Footprint (px) |
| --- | ---: | ---: |
| Cama | 170 × 205 | 150 × 85 |
| Escrivaninha | 145 × 170 | 145 × 72 |
| Guarda-roupa | 130 × 195 | 115 × 70 |
| Poltrona | 140 × 140 | 110 × 85 |
| Penteadeira | 140 × 170 | 125 × 72 |
| Estante | 84 × 170 | 76 × 80 |
| Baú | 110 × 95 | 90 × 60 |
| Tapete / porta visual | 235 × 165 / 100 × 170 | sem colisão |
| Mesa lateral / espelho / planta / quadro | 100 × 135 / 90 × 150 / 100 × 120 / 92 × 112 | sem colisão |

As colisões sólidas ficam na base dos móveis. Para organizar o quarto, arraste o móvel pai: o `Visual` está no ponto local zero e a colisão acompanha o pai. Use o filho `Footprint` apenas para ajustar a forma da base. A cama e a mesa lateral formam a área de descanso à esquerda; penteadeira e espelho ficam no meio; escrivaninha, estante, armário e baú ficam à direita. O centro permanece livre para circular.

A protagonista usa altura visível alvo de 180 px; a colisão nos pés permanece independente da escala visual.
