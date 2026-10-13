> **Atualização M3 — 12/10/2026:** [PR #6](https://github.com/nestarasup-sys/jogo-novo/pull/6) integrado à `main`: HUD compacto, melhor enquadramento do quarto, placas de portas legíveis e sombra corrigida. Mantidas altura da protagonista e câmera 1.30×. [CI Windows/Godot 4.7.2 aprovada](https://github.com/nestarasup-sys/jogo-novo/actions/runs/38337782521); falta conferência visual/manual na Godot local. **Preservar alteração local do criador em `scenes/rooms/bedroom.tscn` → `Boundaries/North` ao sincronizar.**\n\n# Estado mais recente — editor-first em revisão

O [PR #5](https://github.com/nestarasup-sys/jogo-novo/pull/5) foi **mesclado à main**, corrigindo os problemas estruturais de visualização do editor Godot (cena principal cinza, pisos/móveis invisíveis, colisões criadas por runtime, princesa e HUD não editáveis).

## Status
- `main`: contém a fundação modular (PR #4) e a correção editor-first (PR #5).
- `fix/editor-first-scenes`: branch histórica do PR #5 já mesclado; correções presentes na main.
- **Validação automática aprovada:** [Godot 4.7.2 Windows](https://github.com/nestarasup-sys/jogo-novo/actions/runs/38335444897) importou e executou os testes. **Ainda falta abrir o editor no Windows do criador e avaliar visualmente.**
- PR #3 de JPGs do quarto foi fechado sem merge; arte temporária livre para substituição.
- Android permanece adiado.

## Regras
Manter os seis sprites oficiais da princesa, controles e os três ambientes. Não tocar em lore, romances, tempo, NPCs ou novas regiões. Para modificar cenas no editor, consultar [EDITOR_WORKFLOW.md](EDITOR_WORKFLOW.md).
