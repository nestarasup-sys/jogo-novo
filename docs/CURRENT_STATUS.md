# Estado mais recente — editor-first em revisão

O [PR #5](https://github.com/nestarasup-sys/jogo-novo/pull/5) corrige falhas observadas pelo Codex ao abrir o projeto no editor Godot: cena principal cinza, superficies/móveis invisíveis, colisões criadas por runtime e princesa não editável.

## Status
- `main`: última versão integrada pelo PR #4 com protótipo funcional em runtime, mas visualização do editor incompleta.
- `fix/editor-first-scenes`: implementação de pré-visualização `@tool`, colisões persistidas, `princess.tscn`, `hud.tscn` e instâncias na cena principal.
- **Não assumir que PR #5 foi integrado antes de conferir o status.** Validação automática via GitHub Actions e inspeção visual Windows são necessárias.
- PR #3 de JPGs do quarto foi fechado sem merge; arte temporária livre para substituição.
- Android permanece adiado.

## Regras
Manter os seis sprites oficiais da princesa, controles e os três ambientes. Não tocar em lore, romances, tempo, NPCs ou novas regiões. Para modificar cenas no editor, consultar [EDITOR_WORKFLOW.md](EDITOR_WORKFLOW.md).
