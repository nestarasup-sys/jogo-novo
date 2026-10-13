# Fluxo Godot — editar visualmente sem precisar programar

## Princípio (obrigatório)
Uma cena deve **mostrar no editor o que será visto no jogo**, antes de pressionar F5. Não reconstruir visual/colisões em `_ready()` se a informação pode ser salva em `.tscn`.

## Ponto de entrada
Abra `scenes/main.tscn`: o quarto inicial, a princesa, a câmera e a HUD são instâncias da própria cena. Quarto, corredor e jardim permanecem cenas separadas em `scenes/rooms/`. Durante o jogo, `game.gd` utiliza o quarto inicial instanciado e troca as salas quando houver interação com portas.

## Ajustar quarto, corredor ou jardim
1. Abrir `scenes/rooms/<room_id>.tscn`.
2. Em **Visual**, trocar as propriedades `floor_texture`, `wall_texture`, `wall_height`, cores, dimensões. O script `@tool` desenha no próprio editor.
3. Em **WorldSpace/Furniture**, arrastar cada móvel. Mudar `art_texture` no Inspector para substituir um placeholder pelo PNG real. A imagem fica alinhada por `art_size`/`art_offset`.
4. Cada móvel tem **Footprint (CollisionShape2D)** persistido no arquivo. O componente pode atualizar o tamanho da colisão quando `footprint_size` muda. Visualizar/editar a forma no editor.
5. Em **Boundaries**, ver e alterar as quatro colisões de parede — são quatro `StaticBody2D` com `CollisionShape2D` gravados na cena, não criados durante o jogo.
6. Em **Interactions**, selecionar portas e outros pontos. O script `@tool` mostra seus ícones e raios no editor; no Inspector ficam destino, ponto de entrada, legenda e mensagem.
7. Em **Spawns**, arrastar os marcadores de chegada.

## Princesa e interface
- A princesa é `scenes/actors/princess.tscn` com AnimatedSprite2D, SpriteFrames, FootCollisionShape2D e câmera **visíveis e persistidos** no editor.
- **Não** substituir os seis PNGs ou suas animações sem aprovação do criador.
- Interface em `scenes/ui/hud.tscn`: labels, painel e fundo estão na própria cena; painel de diálogo inicia oculto por design. Pode ser temporariamente revelado no Inspector para ajuste.
- O jogo usa a **mesma cena de princesa** editada, evitando uma cópia de visual só para preview.

## Coisas que NÃO precisam de edição visual
`data/room_catalog.json` mapeia nomes estáveis de áreas para arquivos `.tscn`. Outros tipos de interação e futuros serviços só serão implementados quando suas regras existirem; não inventar sistemas agora.

## Arquivos locais criados/alterados pela Godot
- `project.godot` pode ser reformatado pela engine ao abrir o editor. **Não** fazer `git reset --hard` ou descartar alterações locais sem analisar.
- Arquivos `.gd.uid` são IDs de recurso gerados pela Godot. Avaliar e versionar os IDs estáveis relevantes, evitando duplicações; não apagar automaticamente os não rastreados.
- A opção `window/handheld/orientation` é irrelevante para o Windows neste momento; Android fica para depois.
- As texturas JPG do PR #3 foram rejeitadas com aquele PR. Não são dependência da nova arquitetura. Poderão ser substituídas pelo Inspector mais tarde.

## Critérios de aceitação
1. Editor 2D mostra fundos, móveis, portas e princesa ao abrir `scenes/main.tscn`.
2. Abrir cada sala mostra paredes, móveis, colisões e interações selecionáveis.
3. Trocar cor/posição/tamanho de um móvel modifica o editor imediatamente e é refletido no F5.
4. Os seis sprites da princesa continuam idênticos; animações e movimento sem regressões.
5. Importação + `tests/smoke.gd` passam com a Godot 4.7.2 Windows e uma inspeção manual confirma a aparência.
