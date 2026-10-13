# M3 — Polimento do protótipo de quarto (sem trocar os sprites oficiais)

## Objetivo
Melhorar legibilidade e enquadramento no primeiro print real do jogo. **O tamanho da princesa foi aprovado pelo criador e fica intocado**; manter zoom 1.30×. Sem reiniciar a arquitetura ou instalar texturas descartáveis do PR #3.

## Alterações
- `scenes/rooms/bedroom.tscn`: mover exclusivamente os quatro placeholders existentes e as interações de cama/escrivaninha. Cama (395,306), escrivaninha (895,286), armário (332,515), poltrona (968,514). Os footprints e tamanhos permanecem. Uma faixa central continua livre da spawn inicial (640,420) até a porta de saída (640,624).
- `scripts/world/furniture.gd`: placeholder com bordas internas e nome centralizado; a arte final continua substituível por `art_texture`. Não altera geometria de colisão nem outras cenas.
- `scripts/world/interaction_point.gd`: placas de porta mais legíveis em todas as cenas, mesmo usando assets temporários; interações mantidas.
- `scenes/ui/hud.tscn` + `scripts/prototype_hud.gd`: placa pequena no canto superior esquerdo, fonte mais contida; placa contextual inferior aparece apenas quando há objeto próximo.
- `scripts/player.gd`: **somente sombra achatada próxima dos pés**; não toca em PNGs, escala, animações, movimento ou colisão.
- `tests/smoke.gd`: mantém smoke de física e adiciona validações de enquadramento lateral, folga superior, HUD e altura da princesa.

## Cuidado com o trabalho local do criador
**IMPORTANTE:** há uma alteração local deliberada no `Boundaries/North` do arquivo `scenes/rooms/bedroom.tscn`, além de `project.godot`, `.gd.uid` e formatação produzida pela Godot. Este PR muda a **mesma cena do quarto**, mas **não toca no bloco North nem em seus CollisionShape2D**, justamente para permitir reaplicar a alteração do criador.

Quem sincronizar deve:
1. Analisar `git status` e `git diff` antes de integrar; criar backup ou stash com também arquivos não rastreados, evitando sobrescrever o conteúdo.
2. Resolver conflito, se houver, preservando **o deslocamento local de North** e usando as novas posições apenas dos móveis e dos marcadores `BedInspect`/`WritingDeskInspect`.
3. Revisar `project.godot` e os seis `.gd.uid`; incluir o que for adequado sem perda e sem supor que toda mudança automática da Godot precisa ser commitada.
4. Não usar `reset --hard` ou `clean`.
5. Depois atualizar o ambiente Godot, importar e rodar os testes novamente.

## Aceite
- Godot 4.7.2 Windows: importação e smoke passam sem erros de script.
- Ao abrir o quarto na janela 1280×720, com câmera 1.30×, nenhuma das quatro caixas é cortada à esquerda/direita.
- HUD não cobre a cama/escrivaninha no enquadramento inicial; porta inferior reconhecível.
- A princesa conserva a mesma escala, quadro idle, caminhada e colisão dos pés; sombra mais discreta.
- Locais corredor e jardim, transições e interações continuam funcionando.
- Inspeção manual no editor/janela Windows é necessária para aprovar a aparência, ainda que CI passe.

## Exclusões
Sem móveis finais, wallpapers JPG, mapa novo, novos sistemas, Android, NPCs ou história.
