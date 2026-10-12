> **ESTADO MAIS RECENTE — 12/10/2026:** o protótipo quarto → corredor → jardim foi **testado pelo criador**. Codex concluiu validações headless na Godot 4.7.2 segundo o [PR #1](https://github.com/nestarasup-sys/jogo-novo/pull/1), ainda **aberto e não mesclado**. Próxima ação administrativa: revisar e integrar PR #1. **Prioridade de plataforma: Windows apenas**; Android/SDK/APK/joysticks touch/QA mobile ficam na fase final. Próximas mecânicas serão definidas e aprovadas individualmente, sem começar NPCs, romance, calendário ou lore por conta própria.

---

> **ATUALIZAÇÃO DE ESCOPO (12/10/2026):** a etapa atualmente autorizada é SOMENTE testar e corrigir os controles de **quarto → mini corredor → jardim**. A porta inferior do corredor conduz ao jardim. A cena inicial é o quarto da princesa. Código inicial em `scenes/maps/`, `scripts/game.gd`, `player.gd`, `prototype_map.gd`, `prototype_hud.gd`, `mobile_controls.gd`, e teste `tests/smoke.gd`. **Ainda não foi executado na Godot**. O Codex deve importar, validar, testar e consertar, sem adicionar NPC, história, capítulos, tempo ou romances. Consultar [M1_PLAYABLE.md](M1_PLAYABLE.md). Todas as ideias abaixo são backlog de longo prazo, não tarefas desta rodada.

---

# Roadmap de implementação — jogo de palácio

**Não iniciado**, exceto bootstrap/documentação. Cada marco deve ser revisado e testado antes de avançar. O conteúdo do exemplo nunca é lore canônica.

- [ ] **M1 Fundação:** abrir/importar Godot, criar GameRoot, personagem top-down, input keyboard, colisões, cena de teste, testes headless.
- [ ] **M2 Exploração do palácio:** `private_wing`, `social_wing`, `imperial_gardens` provisórios, portas bidirecionais, interação contextual.
- [ ] **M3 Rotina diária:** WorldClock manhã/tarde/noite, descanso e agenda básica de NPCs.
- [ ] **M4 Narrativa genérica:** JSON validado, UI retratos/opções, EventDirector.
- [ ] **M5 Consequências:** RelationshipService, condições por stats/flags, capítulo de teste e escolhas com 2 resoluções.
- [ ] **M6 Save/load:** versionamento, idempotência, fallback de corrupção e testes.
- [ ] **M7 Mobile + exports:** interface responsiva, controles touch, export Windows, APK Android landscape.
- [ ] **M8 Qualidade:** regressão, UX, legibilidade, controle de erros e testes em hardware real.

## Trilhas opcionais (NÃO implementadas)
- Reputação imperial/rumores.
- Correspondências, convites e agenda.
- Vestuário/etiqueta.
- Regiões além do palácio.
- Diário de escolhas e histórico de diálogos.
- Personalização estética e conteúdo narrativo canônico.

## Próxima tarefa técnica
Somente M1, **quando o criador autorizar**. Neste momento a prioridade é design/gameplay, não preencher enredo.
